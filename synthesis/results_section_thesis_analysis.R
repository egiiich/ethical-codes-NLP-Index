#!/usr/bin/env Rscript

# Reproducible analysis script for synthesis/results_section_thesis.md
# Inputs:
#   - registry/principle_index_matrix.csv
#   - registry/principle_presence_matrix_wide.csv
# Outputs:
#   - Console tables/statistics aligned with the Results section

options(stringsAsFactors = FALSE)

# -----------------------------
# Package setup
# -----------------------------
required <- c("sandwich", "lmtest", "boot", "psych")
missing <- required[!vapply(required, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
if (length(missing) > 0) {
  stop(
    sprintf(
      "Missing required packages: %s\nInstall with: install.packages(c(%s))",
      paste(missing, collapse = ", "),
      paste(sprintf('"%s"', missing), collapse = ", ")
    )
  )
}

library(sandwich)
library(lmtest)
library(boot)
library(psych)

# -----------------------------
# Helpers
# -----------------------------
safe_tab_value <- function(tab, key) {
  # table() returns NA when indexing a missing key by name; convert to 0
  if (!(key %in% names(tab))) return(0)
  as.numeric(tab[[key]])
}

perm_anova <- function(y, group, B = 5000, seed = 42) {
  set.seed(seed)
  group <- as.factor(group)

  fit <- aov(y ~ group)
  tab <- summary(fit)[[1]]
  f_obs <- tab[1, "F value"]
  df1 <- tab[1, "Df"]
  df2 <- tab[2, "Df"]

  # eta^2
  ss_between <- tab[1, "Sum Sq"]
  ss_within <- tab[2, "Sum Sq"]
  eta2 <- ss_between / (ss_between + ss_within)

  # permutation p-value
  f_perm <- numeric(B)
  for (b in seq_len(B)) {
    g_perm <- sample(group)
    fit_b <- aov(y ~ g_perm)
    f_perm[b] <- summary(fit_b)[[1]][1, "F value"]
  }
  p_perm <- (sum(f_perm >= f_obs) + 1) / (B + 1)

  list(
    f_obs = as.numeric(f_obs),
    p_perm = as.numeric(p_perm),
    eta2 = as.numeric(eta2),
    df1 = as.integer(df1),
    df2 = as.integer(df2)
  )
}

hc3_coef <- function(model, term) {
  vc <- robust_vcov(model)
  ct <- lmtest::coeftest(model, vcov. = vc)
  if (!(term %in% rownames(ct))) {
    stop(sprintf("Requested term '%s' not found in model coefficients.", term))
  }
  out <- ct[term, , drop = FALSE]
  if (!all(is.finite(out))) {
    warning(sprintf("Non-finite inference for term '%s' after robust vcov fallback.", term))
  }
  list(
    estimate = as.numeric(out[1, 1]),
    se = as.numeric(out[1, 2]),
    p = as.numeric(out[1, 4])
  )
}

fmt <- function(x, d = 3) format(round(x, d), nsmall = d, trim = TRUE)

robust_vcov <- function(model) {
  # Preferred: HC3 (as used in the Results section)
  # Fallback to HC1 if HC3 is non-finite (can happen in high-leverage designs),
  # and finally to classical vcov to avoid NaN standard errors.
  vc3 <- tryCatch(sandwich::vcovHC(model, type = "HC3"), error = function(e) NULL)
  if (!is.null(vc3) && all(is.finite(diag(vc3)))) return(vc3)

  vc1 <- tryCatch(sandwich::vcovHC(model, type = "HC1"), error = function(e) NULL)
  if (!is.null(vc1) && all(is.finite(diag(vc1)))) {
    warning("HC3 produced non-finite variances; using HC1 fallback for inference.")
    return(vc1)
  }

  warning("HC3 and HC1 produced non-finite variances; using classical vcov fallback.")
  stats::vcov(model)
}

# -----------------------------
# Read data
# -----------------------------
index_path <- "registry/principle_index_matrix.csv"
wide_path <- "registry/principle_presence_matrix_wide.csv"

idx <- read.csv(index_path, fileEncoding = "UTF-8-BOM", check.names = FALSE)
wide <- read.csv(wide_path, fileEncoding = "UTF-8-BOM", check.names = FALSE)

# Normalize key variable names
names(idx)[names(idx) == "Год"] <- "year"
names(idx)[names(idx) == "Страна"] <- "country"
names(idx)[names(idx) == "Отрасль"] <- "industry"
names(idx)[names(idx) == "Компания"] <- "company"

names(wide)[names(wide) == "Год"] <- "year"
names(wide)[names(wide) == "Страна"] <- "country"
names(wide)[names(wide) == "Отрасль"] <- "industry"
names(wide)[names(wide) == "Компания"] <- "company"

# Component columns used in Results section
components <- c(
  "competitor_relations",
  "hotline_principles",
  "company_to_supplier",
  "worker_to_company",
  "company_to_investors",
  "company_to_people",
  "company_to_buyer",
  "worker_to_worker",
  "manager_to_worker",
  "company_to_worker",
  "worker_to_manager"
)

# Ensure numerics
for (v in c("year", components)) idx[[v]] <- as.numeric(idx[[v]])

# Guard against accidental NA coercion from parsing
analysis_vars <- c("year", components)
na_rows <- !stats::complete.cases(idx[, analysis_vars])
if (any(na_rows)) {
  warning(
    sprintf(
      "Dropping %d row(s) with NA in required analysis variables after numeric parsing.",
      sum(na_rows)
    )
  )
  idx <- idx[!na_rows, , drop = FALSE]
}

# -----------------------------
# Construct indices used in the document
# -----------------------------
idx$total_index <- rowSums(idx[, components], na.rm = TRUE)

# H4 composites
idx$company_interest <- with(idx,
  competitor_relations + company_to_supplier + company_to_investors + company_to_buyer + worker_to_company
)
idx$employee_protection <- with(idx,
  company_to_worker + manager_to_worker + worker_to_manager + worker_to_worker + hotline_principles
)

# H5 compliance institutionalization proxy
idx$compliance_inst <- with(idx,
  hotline_principles + manager_to_worker + worker_to_manager + company_to_worker
)

cat("\n===============================\n")
cat("Sample structure\n")
cat("===============================\n")
cat("N:", nrow(idx), "\n")
cat("Year range:", min(idx$year), "to", max(idx$year), "\n")
print(table(idx$country))

# -----------------------------
# Section 2: Descriptives
# -----------------------------
cat("\n===============================\n")
cat("Total index descriptives\n")
cat("===============================\n")
cat("Mean:", fmt(mean(idx$total_index)), "\n")
cat("SD:", fmt(sd(idx$total_index)), "\n")
cat("Min:", min(idx$total_index), "\n")
cat("Max:", max(idx$total_index), "\n")

comp_stats <- data.frame(
  component = components,
  mean = vapply(components, function(v) mean(idx[[v]], na.rm = TRUE), numeric(1)),
  sd = vapply(components, function(v) sd(idx[[v]], na.rm = TRUE), numeric(1))
)
comp_stats <- comp_stats[order(-comp_stats$mean), ]
cat("\nComponent means (descending):\n")
print(comp_stats, row.names = FALSE)

# Paired checks from descriptive section
pt1 <- t.test(idx$worker_to_company, idx$hotline_principles, paired = TRUE)
pt2 <- t.test(idx$worker_to_manager, idx$manager_to_worker, paired = TRUE)

cat("\nPaired test: worker_to_company - hotline_principles\n")
cat("Mean diff:", fmt(mean(idx$worker_to_company - idx$hotline_principles)),
    " t:", fmt(unname(pt1$statistic)),
    " p:", signif(pt1$p.value, 4), "\n")

cat("\nPaired test: worker_to_manager - manager_to_worker\n")
cat("Mean diff:", fmt(mean(idx$worker_to_manager - idx$manager_to_worker)),
    " t:", fmt(unname(pt2$statistic)),
    " p:", signif(pt2$p.value, 4), "\n")

# -----------------------------
# Section 3: Wide matrix prevalence
# -----------------------------
meta_cols <- c("country", "industry", "company", "year", "document_id")
principle_cols <- setdiff(names(wide), meta_cols)

long_vals <- unlist(wide[, principle_cols], use.names = FALSE)
status_tab <- table(long_vals)
status_prop <- prop.table(status_tab)

cat("\n===============================\n")
cat("Principle-level prevalence (wide matrix)\n")
cat("===============================\n")
cat("Documents:", nrow(wide), "\n")
cat("Principles per document:", length(principle_cols), "\n")
cat("Total coded cells:", length(long_vals), "\n")
print(data.frame(status = names(status_tab), n = as.integer(status_tab),
                 prop = as.numeric(status_prop)), row.names = FALSE)

# Prefix family summary (e.g., COMP, HOT, CtoS...)
get_prefix <- function(x) {
  # Principle columns are like HOT01, CtoW03, COMP10, etc.
  # Group by family prefix (HOT, CtoW, COMP, ...), not by full item code.
  sub("[0-9]+$", "", x)
}
prefix <- vapply(principle_cols, get_prefix, character(1))

family_summary <- do.call(rbind, lapply(unique(prefix), function(px) {
  cols <- principle_cols[prefix == px]
  vals <- unlist(wide[, cols], use.names = FALSE)
  tb <- table(vals)
  total <- sum(tb)
  data.frame(
    family = px,
    total = total,
    explicit_section = safe_tab_value(tb, "explicit_section") / total,
    brief_mention = safe_tab_value(tb, "brief_mention") / total,
    absent = safe_tab_value(tb, "absent") / total
  )
}))

family_summary <- family_summary[order(-family_summary$explicit_section), ]
cat("\nFamily prevalence summary:\n")
print(family_summary, row.names = FALSE)

# -----------------------------
# Section 4 + 5: Hypotheses and core models
# -----------------------------
cat("\n===============================\n")
cat("H1: Year trend in total index\n")
cat("===============================\n")
cor_h1 <- cor.test(idx$year, idx$total_index)
cat("Correlation r:", fmt(unname(cor_h1$estimate), 4),
    " p:", signif(cor_h1$p.value, 4), "\n")

# Baseline model used repeatedly
base_model <- lm(total_index ~ year + factor(country) + factor(industry), data = idx)
h1_year <- hc3_coef(base_model, "year")
cat("OLS HC3 year coef:", fmt(h1_year$estimate),
    " SE:", fmt(h1_year$se),
    " p:", signif(h1_year$p, 4), "\n")
cat("R2:", fmt(summary(base_model)$r.squared),
    " Adj R2:", fmt(summary(base_model)$adj.r.squared), "\n")

cat("\n===============================\n")
cat("H2: Country differences\n")
cat("===============================\n")
a_country <- perm_anova(idx$total_index, idx$country, B = 5000, seed = 42)
cat("Permutation ANOVA F(", a_country$df1, ",", a_country$df2, ") =",
    fmt(a_country$f_obs),
    " p =", signif(a_country$p_perm, 4),
    " eta2 =", fmt(a_country$eta2), "\n", sep = "")

country_means <- aggregate(total_index ~ country, data = idx, FUN = mean)
country_sds <- aggregate(total_index ~ country, data = idx, FUN = sd)
country_tbl <- merge(country_means, country_sds, by = "country", suffixes = c("_mean", "_sd"))
print(country_tbl[order(-country_tbl$total_index_mean), ], row.names = FALSE)

ct <- lmtest::coeftest(base_model, vcov. = robust_vcov(base_model))
country_rows <- grep("^factor\\(country\\)", rownames(ct))
cat("\nCountry coefficients (vs reference country):\n")
print(ct[country_rows, , drop = FALSE])

cat("\n===============================\n")
cat("H3: Industry differences\n")
cat("===============================\n")
a_ind <- perm_anova(idx$total_index, idx$industry, B = 5000, seed = 43)
cat("Permutation ANOVA F(", a_ind$df1, ",", a_ind$df2, ") =",
    fmt(a_ind$f_obs),
    " p =", signif(a_ind$p_perm, 4),
    " eta2 =", fmt(a_ind$eta2), "\n", sep = "")

industry_means <- aggregate(total_index ~ industry, data = idx, FUN = mean)
industry_sds <- aggregate(total_index ~ industry, data = idx, FUN = sd)
industry_counts <- aggregate(total_index ~ industry, data = idx, FUN = length)
ind_tbl <- Reduce(function(x, y) merge(x, y, by = "industry"),
                  list(industry_means, industry_sds, industry_counts))
names(ind_tbl) <- c("industry", "mean", "sd", "n")
cat("\nTop 5 industries by mean:\n")
print(head(ind_tbl[order(-ind_tbl$mean), ], 5), row.names = FALSE)
cat("\nBottom 5 industries by mean:\n")
print(head(ind_tbl[order(ind_tbl$mean), ], 5), row.names = FALSE)

industry_rows <- grep("^factor\\(industry\\)", rownames(ct))
sig_ind <- ct[industry_rows, , drop = FALSE]
sig_ind <- sig_ind[sig_ind[, 4] < 0.05, , drop = FALSE]
cat("\nIndustry coefficients significant at p<0.05 (HC3):\n")
if (nrow(sig_ind) == 0) {
  cat("None\n")
} else {
  print(sig_ind)
}

cat("\n===============================\n")
cat("H4: Company-interest vs employee-protection orientation\n")
cat("===============================\n")
h4_pt <- t.test(idx$company_interest, idx$employee_protection, paired = TRUE, alternative = "greater")
cat("Mean company-interest:", fmt(mean(idx$company_interest)), "\n")
cat("Mean employee-protection:", fmt(mean(idx$employee_protection)), "\n")
cat("Mean paired diff:", fmt(mean(idx$company_interest - idx$employee_protection)), "\n")
cat("Paired t:", fmt(unname(h4_pt$statistic)),
    " p:", signif(h4_pt$p.value, 4), "\n")

cat("\n===============================\n")
cat("H5: Compliance institutionalization over time\n")
cat("===============================\n")
h5_cor <- cor.test(idx$year, idx$compliance_inst)
cat("Correlation r:", fmt(unname(h5_cor$estimate), 4),
    " p:", signif(h5_cor$p.value, 4), "\n")

h5_model <- lm(compliance_inst ~ year + factor(country) + factor(industry), data = idx)
h5_year <- hc3_coef(h5_model, "year")
cat("OLS HC3 year coef:", fmt(h5_year$estimate),
    " SE:", fmt(h5_year$se),
    " p:", signif(h5_year$p, 4),
    " Adj R2:", fmt(summary(h5_model)$adj.r.squared), "\n")

cat("\n===============================\n")
cat("H6: Reliability diagnostics\n")
cat("===============================\n")
alpha_out <- psych::alpha(idx[, components])
cat("Cronbach alpha:", fmt(alpha_out$total$raw_alpha), "\n")

pca <- prcomp(idx[, components], center = TRUE, scale. = TRUE)
eigvals <- pca$sdev^2
pc1_share <- eigvals[1] / sum(eigvals)
cat("PC1 eigenvalue:", fmt(eigvals[1]),
    " PC1 variance share:", fmt(100 * pc1_share, 1), "%\n")

# -----------------------------
# Section 6: Robustness checks
# -----------------------------
cat("\n===============================\n")
cat("Robustness checks\n")
cat("===============================\n")

# A) Winsorized total index (5th and 95th percentile)
q <- quantile(idx$total_index, probs = c(0.05, 0.95), na.rm = TRUE)
idx$total_wins <- pmin(pmax(idx$total_index, q[1]), q[2])
mod_wins <- lm(total_wins ~ year + factor(country) + factor(industry), data = idx)
yr_wins <- hc3_coef(mod_wins, "year")
cat("A) Winsorized [", q[1], ", ", q[2], "] year coef:", fmt(yr_wins$estimate),
    " p:", signif(yr_wins$p, 4),
    " Adj R2:", fmt(summary(mod_wins)$adj.r.squared), "\n", sep = "")

# B) Outlier-trimmed (±3 SD)
m <- mean(idx$total_index)
s <- sd(idx$total_index)
trim <- idx[abs(idx$total_index - m) <= 3 * s, ]
mod_trim <- lm(total_index ~ year + factor(country) + factor(industry), data = trim)
yr_trim <- hc3_coef(mod_trim, "year")
cat("B) Trimmed n=", nrow(trim), " year coef:", fmt(yr_trim$estimate),
    " p:", signif(yr_trim$p, 4),
    " Adj R2:", fmt(summary(mod_trim)$adj.r.squared), "\n", sep = "")

# C) Post-2015
post2015 <- idx[idx$year >= 2015, ]
mod_post <- lm(total_index ~ year + factor(country) + factor(industry), data = post2015)
yr_post <- hc3_coef(mod_post, "year")
cat("C) Post-2015 n=", nrow(post2015), " year coef:", fmt(yr_post$estimate),
    " p:", signif(yr_post$p, 4),
    " Adj R2:", fmt(summary(mod_post)$adj.r.squared), "\n", sep = "")

# D) Median-split LPM
med <- median(idx$total_index, na.rm = TRUE)
idx$high_total <- as.numeric(idx$total_index >= med)
mod_lpm <- lm(high_total ~ year + factor(country) + factor(industry), data = idx)
yr_lpm <- hc3_coef(mod_lpm, "year")
cat("D) LPM (median split", med, ") year coef:", fmt(yr_lpm$estimate, 4),
    " p:", signif(yr_lpm$p, 4),
    " Adj R2:", fmt(summary(mod_lpm)$adj.r.squared), "\n")

# E) Bootstrap CI for year coefficient (baseline model)
boot_stat <- function(data, indices) {
  d <- data[indices, ]
  m <- lm(total_index ~ year + factor(country) + factor(industry), data = d)
  coef(m)["year"]
}

set.seed(123)
b <- boot::boot(data = idx, statistic = boot_stat, R = 500)
ci <- quantile(b$t, probs = c(0.025, 0.5, 0.975), na.rm = TRUE)
cat("E) Bootstrap year coef median:", fmt(ci[2]),
    " CI95%:[", fmt(ci[1]), ",", fmt(ci[3]), "]\n")

cat("\nAnalysis complete.\n")
