# Реестр тематик анализа (`topic_id`)

Этот реестр задаёт поддерживаемые темы для анализа на уровне `document_id × topic_id`.

## Формат

- `topic_id` — машинный идентификатор темы.
- `topic_title_ru` — человеко-читаемое название.
- `scope_ru` — что включается в тему.
- `principles_path` — путь до канонического реестра принципов темы.

## Темы

### competitor_relations
- `topic_title_ru`: Отношения с конкурентами
- `scope_ru`: Антимонопольные требования, контакты с конкурентами, обмен чувствительной информацией, добросовестная конкуренция, эскалация и сообщения о рисках.
- `principles_path`: `docs/principles/competitor_relations.md`

### hotline_principles
- `topic_title_ru`: Принципы горячей линии
- `scope_ru`: Доступ работников к горячей линии, анонимность, whistleblowing, беспристрастное рассмотрение заявлений.
- `principles_path`: `docs/principles/hotline_principles.md`

### company_to_supplier
- `topic_title_ru`: Отношение компании к поставщикам
- `scope_ru`: Выбор поставщика, ориентация на партнерство, информирование поставщиков.
- `principles_path`: `docs/principles/company_to_supplier.md`

### worker_to_company
- `topic_title_ru`: Отношение работника к компании
- `scope_ru`: Уровень качества работы, конфиденциальность, знание и соблюдение законов, сохранение деловой репутации.
- `principles_path`: `docs/principles/worker_to_company.md`

### company_to_investors
- `topic_title_ru`: Отношение компании с обществом
- `scope_ru`: Равные права акционеров, дивидендная политика, прозрачность, раскрытие информации.
- `principles_path`: `docs/principles/worker_to_people.md`

### company_to_people
- `topic_title_ru`: Отношение компании с инвесторами
- `scope_ru`: Уважение традиций, содействие развитию регионов присутствия, исключение опасности для населения.
- `principles_path`: `docs/principles/company_to_people.md`

### company_to_buyer
- `topic_title_ru`: Отношение компании с потребителям
- `scope_ru`: Обеспечение качества улуг/продукта, обратная связь клиентов, предоставление полной информации об услуге/продукте.
- `principles_path`: `docs/principles/company_to_buyer.md`

## Добавление новой темы

1. Добавь новый блок с уникальным `topic_id`.
2. Определи `scope_ru`.
3. Создай файл `docs/principles/<topic_id>.md`.
4. Используй новый `topic_id` в анализе и синтезе.
