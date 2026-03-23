# Instruction 02 — Analysis of One Code Across All Topics

## Task
Проанализировать один корпоративный кодекс этики сразу по всем темам из `docs/topic_registry.md`.

## Required input
- `document_id`

## Goal
1. Для каждой темы загрузить список канонических принципов.
2. Для каждого принципа присвоить `principle_status`.
3. Сохранить единый файл `analysis/yaml/<document_id>.yaml`.
4. Обновить `registry/principle_presence_matrix.csv`.
5. Обновить `registry/principle_index_matrix.csv`.

## Language rule
- Анализ ведётся по языку оригинала документа.
- Цитаты сохраняются в оригинале.
- Для цитат-подтверждений обязателен перевод на русский.
- Нормализация и выводы записываются на русском.

## Allowed values

### `principle_status`
- `explicit_section`
- `implicit_scattered`
- `brief_mention`
- `absent`
- `unclear`

### `review_status`
- `completed`
- `needs_human_review`

## Source of principles
- Темы: `docs/topic_registry.md`.
- Принципы по теме: `docs/principles/<topic_id>.md`.

## Required procedure
1. Взять все темы из `docs/topic_registry.md`.
2. Для каждой темы пройти по всем `principle_code`.
3. Присвоить каждому принципу `principle_status`.
4. Для статусов `explicit_section`, `implicit_scattered` и `brief_mention` добавить цитаты в `key_excerpts` и связать их через `evidence_excerpt_ids`.
5. Если принцип не классифицируется надёжно, использовать `unclear`.
6. Сохранить один YAML на кодекс по `analysis/yaml/_template`.
7. Для каждого `excerpt_id` использовать формат `"<principle_code>_<principle_status>"` (например: `"COMP01_explicit_section"`).
8. Обновить строку кодекса в `registry/principle_presence_matrix.csv`.
9. Пересчитать строку кодекса в `registry/principle_index_matrix.csv`:
   - взять первые 4 столбца из `registry/principle_presence_matrix.csv`;
   - добавить по одному столбцу на каждый `topic_id` из `docs/topic_registry.md`;
   - вычислить индекс темы как сумму весов по всем принципам темы:
     `explicit_section=3`, `implicit_scattered=2`, `brief_mention=1`, `absent=0`, `unclear=0`.

## Required response
Кратко сообщи:
- какой документ обработан;
- сколько тем обработано;
- сколько принципов в каждом статусе;
- нужен ли `human review`.
- какой документ и какая тема обработаны;
- какой `topic_status` присвоен;
- какие `principle_codes_detected` найдены;
- нужен ли `human review`.
