# Методология мультитематического анализа кодексов этики (матрица принципов)

## 1. Цель

Методика предназначена для анализа каждого кодекса сразу по всем зарегистрированным темам с фиксацией статуса присутствия каждого канонического принципа.

Результат — матрица `document_id × principle_code`.

## 2. Единица анализа

Единица анализа — один кодекс (`document_id`).

Для каждого кодекса формируется **один YAML**: `analysis/yaml/<document_id>.yaml`, включающий все темы и все принципы.

## 3. Источники правил

- `docs/topic_registry.md` — перечень тем.
- `docs/principles/<topic_id>.md` — канонические принципы каждой темы.
- `docs/status_scale.md` — шкала статусов `principle_status` и `review_status`.

## 4. Общие правила

- Анализ ведётся по языку оригинала.
- Для каждого принципа обязателен статус.
- Статусы принципов используют ту же шкалу, что раньше использовалась для статуса наличия раздела:
  `explicit_section`, `implicit_scattered`, `brief_mention`, `absent`, `unclear`.
- Показатель `evidence_quality` не используется.

## 5. Порядок анализа одного кодекса

1. Собрать список всех тем из `docs/topic_registry.md`.
2. Для каждой темы загрузить канонические принципы из `docs/principles/<topic_id>.md`.
3. Для каждого принципа присвоить `principle_status`.
4. Сохранить единый YAML `analysis/yaml/<document_id>.yaml`.
5. Обновить `registry/principle_presence_matrix.csv`.

## 6. Матрица принципов

`registry/principle_presence_matrix.csv` хранит агрегированное представление:
- строка = `document_id`,
- столбец = принцип (рекомендуется префикс `topic_id__`),
- значение = `explicit_section|implicit_scattered|brief_mention|absent|unclear`.

## 7. Синтез

Синтез выполняется по теме на основе:
- соответствующих блоков в `analysis/yaml/<document_id>.yaml`,
- матрицы присутствия принципов.

## 8. Индексная матрица тем

`registry/principle_index_matrix.csv` хранит агрегированный числовой индекс:
- строка = `document_id`,
- первые 4 столбца совпадают с `registry/principle_presence_matrix.csv`:
  `Страна,Отрасль,Компания,document_id`,
- далее по одному столбцу на каждый `topic_id` из `docs/topic_registry.md`,
- значение в столбце `topic_id` = сумма весов статусов всех принципов этой темы.

Шкала весов:
- `explicit_section = 3`
- `implicit_scattered = 2`
- `brief_mention = 1`
- `absent = 0`
- `unclear = 0`

Порядок обновления после анализа кодекса:
1. Обновить `registry/principle_presence_matrix.csv`.
2. Пересчитать `registry/principle_index_matrix.csv` по актуальной матрице присутствия и реестру тем.
