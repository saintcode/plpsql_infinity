# plpsql_infinity
PLPSQL script to clear DB

*Инструкция:*
1. открыть PgAdmin и выбрать БД проэкта
2. открыть скрипт #1 в PgAdmin и выполнить его
3. открыть скрипт #2 в PgAdmin и выполнить его
4. открыть скрипт #3 в PgAdmin и выполнить его
5. открыть скрипт #4 в PgAdmin и выполнить его - это основной скрипт, ход выполнения будет виден во вкладке "Сообщения" PgAdmin'а
Всего на чистку 1560 записей, в сообщениях в начале будет виден текущий номер записи.
6. После завершения скрипта #4 в таблице "AA_remove" в колонке "is_found" будет перечень таблиц из которых был удален данный контакт.
Если в колонке "is_found" пустая строка - контакт не найден.
