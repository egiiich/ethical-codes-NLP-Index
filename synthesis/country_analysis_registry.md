# Страновой анализ по категориям принципов (на основе `registry`)

Источник: `registry/principle_presence_matrix_long.csv` и `registry/principle_index_matrix.csv`.

## 1) Покрытие выборки

- China: 41 документов
- Indonesia: 40 документов
- Japan: 37 документов
- Korea: 38 документов
- Russia: 33 документов

## 2) Общая плотность покрытия по странам

Доля «не absent» по всем категориям:
- **Korea: 24.7%** (explicit 18.3%, brief 6.4%)
- **Japan: 20.8%** (explicit 14.0%, brief 6.8%)
- **Indonesia: 18.9%** (explicit 13.3%, brief 5.7%)
- **Russia: 16.6%** (explicit 9.7%, brief 7.0%)
- **China: 16.5%** (explicit 11.8%, brief 4.7%)

Интерпретация: в Корее и Японии кодексы в среднем более «детализированы» по категориям; в России и Китае чаще встречается более селективное покрытие.

## 3) Какие категории наиболее выражены в каждой стране

Ниже — доля присутствия внутри категории (не absent).

### China
- worker_to_company: **29.5%**
- hotline_principles: **23.8%**
- company_to_buyer: **23.6%**
- company_to_supplier: **22.8%**

### Indonesia
- company_to_supplier: **33.3%**
- worker_to_company: **29.5%**
- hotline_principles: **24.4%**
- company_to_buyer: **21.4%**

### Japan
- company_to_buyer: **34.1%**
- worker_to_company: **30.9%**
- company_to_people: **30.0%**
- hotline_principles: **25.0%**

### Korea
- company_to_supplier: **50.3%**
- company_to_buyer: **42.0%**
- worker_to_company: **30.5%**
- company_to_people: **24.9%**

### Russia
- hotline_principles: **24.9%**
- worker_to_company: **23.6%**
- company_to_supplier: **21.5%**
- worker_to_manager: **18.1%**

Ключевая закономерность: **worker_to_company** входит в топ почти во всех странах; при этом Korea/Japan сильнее по «внешним» бизнес-категориям (supplier/buyer/people).

## 4) Межстрановые различия именно на уровне категорий

По среднему категориальному индексу (из `principle_index_matrix.csv`) самый большой межстрановой разрыв:

1. **company_to_buyer**: диапазон **4.38** (min 5.00, max 9.38)
2. **company_to_supplier**: диапазон **3.50** (min 3.17, max 6.67)
3. **company_to_worker**: диапазон **2.36** (min 5.16, max 7.51)
4. **company_to_people**: диапазон **1.92** (min 3.40, max 5.32)

Это означает, что различия между странами сильнее проявляются в категориях, связанных с цепочкой ценности и стейкхолдерами (покупатели/поставщики/сотрудники/общество), чем в базовых «внутренних» категориях.

## 5) Профили стран по средним категориальным индексам

- **China**: профиль с доминированием `worker_to_company` и `hotline_principles`, более умеренные значения в stakeholder-категориях.
- **Indonesia**: похожая база (`worker_to_company`, `hotline_principles`), но с относительно заметной `company_to_supplier`.
- **Japan**: более сбалансированный stakeholder-профиль, особенно сильна `company_to_buyer`.
- **Korea**: наиболее выраженный stakeholder-профиль (`company_to_buyer`, `company_to_supplier`, `company_to_worker`) при высокой общей плотности.
- **Russia**: акцент на `hotline_principles` и `worker_to_company`, более низкие уровни по части внешних stakeholder-категорий.

## 6) Временные тренды по категориям

### Общий контур
- В большинстве стран категория `worker_to_company` остаётся «якорной» во всех периодах.
- После 2021 года в ряде стран усиливаются stakeholder-категории, но динамика неоднородна.

### По странам
- **Korea**: наиболее выраженный рост в период `>=2024` сразу в нескольких категориях (`worker_to_company`, `hotline_principles`, `company_to_buyer`, `company_to_worker`).
- **China**: плавное усиление от `<=2020` к `2021–2023`, затем стабилизация на близком уровне.
- **Japan**: более сильные значения в `2021–2023`, затем ослабление части категорий в `>=2024` (особенно `company_to_buyer`, `company_to_worker`).
- **Indonesia**: колебания без устойчивого монотонного тренда; в `>=2024` заметен спад части stakeholder-категорий.
- **Russia**: пик `hotline_principles` в `2021–2023`, затем частичная нормализация в `>=2024`.

## 7) Итоговые выводы (фокус на категории)

1. **Главная ось сходства** стран — доминирование категории `worker_to_company`.
2. **Главная ось различий** — степень развития stakeholder-категорий, прежде всего `company_to_buyer` и `company_to_supplier`.
3. **Korea** — лидер по глубине и широте категориального покрытия; **Japan** — второй наиболее «сбалансированный» stakeholder-профиль.
4. **China/Indonesia/Russia** чаще демонстрируют модель «базовое ядро + выборочное расширение категорий», но с разным акцентом (hotline vs supplier/buyer).
