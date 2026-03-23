# Ethics Codes Multi-Topic Principle Matrix Corpus

Репозиторий для анализа корпоративных кодексов этики по нескольким темам в формате **матрицы присутствия принципов**:

- строки: кодексы (`document_id`),
- столбцы: канонические принципы,
- значения: статус присутствия принципа в кодексе.

## Что внутри

- `Japan_Ethics_Codes_txt_files/` — исходные тексты кодексов.
- `registry/codes_index.csv` — инвентаризация документов.
- `registry/principle_presence_matrix_wide.csv` — широкая матрица `кодекс × принцип`.
- `registry/principle_presence_matrix_long.csv` — длинная матрица `кодекс × принцип` (одна строка на принцип в кодексе с полями доказательства и метаданными анализа).
- `registry/principle_index_matrix.csv` — индексная матрица `кодекс × тема` (сумма весов статусов принципов по каждой теме).
- `analysis/yaml/_template` — шаблон единой карточки анализа кодекса.
- `analysis/yaml/<document_id>.yaml` — единый YAML на кодекс (все темы сразу).
- `docs/topic_registry.md` — реестр тем.
- `docs/principles/<topic_id>.md` — канонические принципы тем.
- `prompts/` — инструкции для инвентаризации, анализа и синтеза.

## Минимальный рабочий цикл

1. Добавить/обновить документы в корпусе.
2. Обновить `registry/codes_index.csv`.
3. Для каждого `document_id` выполнить мультитематический анализ (все темы из `docs/topic_registry.md`).
4. Сохранить результат в `analysis/yaml/<document_id>.yaml`.
5. Обновить `registry/principle_presence_matrix_wide.csv`.
6. Обновить `registry/principle_presence_matrix_long.csv` (первые 4 столбца как в wide + поля `Principle_code`, `Principle_text`, `Presence`, `Evidence`, `Date of analysis`, `Analysis model`).
7. Обновить `registry/principle_index_matrix.csv` на основе `registry/principle_presence_matrix_wide.csv`.
7. Выполнять синтез по теме из агрегированных YAML/матриц.

## Базовые правила

- Анализ ведётся по языку оригинала.
- Для каждого принципа фиксируется отдельный статус присутствия.
- Шкала `principle_status`: `explicit_section|implicit_scattered|brief_mention|absent|unclear`.
