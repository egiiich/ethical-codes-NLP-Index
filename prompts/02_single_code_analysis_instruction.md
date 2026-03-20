# Instruction 02 — Analysis of One Code (Topic-Aware)

## Task
Проанализировать один корпоративный кодекс этики по выбранной теме (`topic_id`).

## Required input
- `document_id`
- `topic_id` (из `docs/topic_registry.md`)

## Goal
1. Определить, присутствует ли выбранная тема.
2. Присвоить `topic_status`.
3. Извлечь подтверждающие цитаты.
4. Отнести найденные положения к каноническим `principle_code` темы.
5. Сохранить карточку в `analysis/yaml/<topic_id>/<document_id>.yaml`.
6. Обновить `registry/topic_analysis_status.csv`.

## Language rule
- Анализ ведётся по языку оригинала документа.
- Цитаты сохраняются в оригинале.
- Для каждой цитаты обязателен перевод на русский.
- Нормализация, статусы и выводы записываются на русском.

## Allowed values

### `topic_status`
- `explicit_section`
- `implicit_scattered`
- `brief_mention`
- `absent`
- `unclear`

### `evidence_quality`
- `high`
- `medium`
- `low`

### `review_status`
- `completed`
- `needs_human_review`

## Source of principles
- `principle_code` бери из `docs/principles/<topic_id>.md`.

## Required procedure
1. Сначала ищи явный раздел по выбранной теме.
2. Если явного раздела нет, ищи функциональные эквиваленты по смыслу темы.
3. Не выдумывай положения, которых нет в тексте.
4. Строго отделяй цитату от нормализации.
5. Если используется `P99_other`, обязательно опиши новый принцип отдельно.
6. Если текст неполный, перевод сомнителен или доказательства слабые, понижай `evidence_quality` и используй `needs_human_review`.
7. Цитата в `key_excerpts.original` — не более 2-3 предложений; длинные фрагменты разбивай.
8. Каждая запись в `key_excerpts` должна содержать `supports_principles`.

## Required YAML structure
Используй шаблон `analysis/yaml/_template`.

## Required response
Кратко сообщи:
- какой документ и какая тема обработаны;
- какой `topic_status` присвоен;
- какие `principle_codes_detected` найдены;
- нужен ли `human review`.
