# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"


## Создание базы данных и пользователя

Для выполнения миграций и автотестов была создана БД `store` и пользователь `store_user`:

```sql
CREATE DATABASE store;
CREATE USER store_user WITH PASSWORD '...';
GRANT CONNECT ON DATABASE store TO store_user;
GRANT USAGE, CREATE ON SCHEMA public TO store_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO store_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO store_user;

-- добавил, прав выше не хватило
 GRANT CREATE, USAGE ON SCHEMA public TO store_user;