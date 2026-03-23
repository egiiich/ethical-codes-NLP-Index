# Instruction 03 — Synthesis by Topic from Principle Matrix

## Task
Синтезировать унифицированный набор положений по выбранной теме на основе мультитематических YAML и матрицы присутствия принципов.

## Required input
- `topic_id` (из `docs/topic_registry.md`)

## Source
- `analysis/yaml/*.yaml`
- `registry/principle_presence_matrix.csv`
- `registry/principle_index_matrix.csv`

## Use only
Используй документы с `review_status = completed`.

## Goal
1. Собрать по теме статусы принципов из всех кодексов.
2. Оценить распределение статусов каждого принципа (`explicit_section|implicit_scattered|brief_mention|absent|unclear`).
3. Использовать индекс темы из `registry/principle_index_matrix.csv` как числовую опору сравнения кодексов.
4. Сформировать идеальную модель тематического раздела.
5. Обновить файлы в `synthesis/<topic_id>/`.

## Required response
Кратко сообщи:
- сколько кодексов использовано;
- какие принципы чаще имеют сильные статусы (`explicit_section`/`implicit_scattered`);
- какие принципы чаще `brief_mention`/`absent`/`unclear`;
- насколько синтез устойчив.
