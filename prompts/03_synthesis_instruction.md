# Instruction 03 — Synthesis of the Ideal Section (Topic-Aware)

## Task
На основании завершённых YAML-карточек синтезировать унифицированный набор положений для выбранной темы (`topic_id`).

## Required input
- `topic_id` (из `docs/topic_registry.md`)

## Source
- `analysis/yaml/<topic_id>/*.yaml`
- `registry/topic_analysis_status.csv`

## Use only
Используй только карточки, для которых одновременно верно:
- `review_status = completed`
- `topic_status != unclear`
- `synthesis_ready = yes`

## Goal
1. Собрать `principle_codes_detected` по теме.
2. Оценить распространённость и устойчивость подтверждений.
3. Сформировать идеальную модель раздела по теме.
4. Обновить файлы в `synthesis/<topic_id>/`.

## Synthesis levels
- `basic`
- `strengthening`
- `advanced`

## Prevalence
- `prevalence_high`
- `prevalence_medium`
- `prevalence_low`

## Additional rules
1. Не выводи новые принципы «из головы».
2. Редкий, но критичный принцип может попасть в `basic`, если это объяснено.
3. Частота не определяет уровень автоматически.
4. Для `P99_other` фиксируй кандидатов на промотирование только с обоснованием.

## Required response
Кратко сообщи:
- сколько карточек использовано;
- какие принципы вошли в `basic`;
- какие карточки исключены;
- насколько синтез устойчив.
