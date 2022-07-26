--1. Вывести название, жанр и цену тех книг, количество которых больше 8, в отсортированном по убыванию цены виде.

SELECT title, name_genre, price
FROM genre INNER JOIN book
ON genre.genre_id=book.genre_id
WHERE amount>8
ORDER BY price DESC

Query result:
+-----------------------+------------+--------+
| title                 | name_genre | price  |
+-----------------------+------------+--------+
| Стихотворения и поэмы | Поэзия     | 650.00 |
| Игрок                 | Роман      | 480.50 |
| Идиот                 | Роман      | 460.00 |
+-----------------------+------------+--------+

--2. Вывести все жанры, которые не представлены в книгах на складе.

SELECT name_genre
FROM genre LEFT JOIN book
     ON genre.genre_id = book.genre_id
WHERE book.genre_id is Null

Query result:
+-------------+
| name_genre  |
+-------------+
| Приключения |
+-------------+

--3. Есть список городов, хранящийся в таблице city. Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. Дату проведения выставки выбрать случайным образом. Создать запрос, который выведет город, автора и дату проведения выставки. Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном порядке по названиям городов, а потом по убыванию дат проведения выставок. 

| city_id |    name_city    |
|:-------:|:---------------:|
| 1       | Москва          |
| 2       | Санкт-Петербург |
| 3       | Владивосток     |

SELECT name_city, name_author, (DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY)) as Дата
FROM city, author
ORDER BY name_city, Дата DESC; 

Query result:
+-----------------+------------------+------------+
| name_city       | name_author      | Дата       |
+-----------------+------------------+------------+
| Владивосток     | Достоевский Ф.М. | 2020-10-10 |
| Владивосток     | Булгаков М.А.    | 2020-10-06 |
| Владивосток     | Есенин С.А.      | 2020-06-14 |
| Владивосток     | Пастернак Б.Л.   | 2020-03-15 |
| Владивосток     | Лермонтов М.Ю.   | 2020-01-09 |
| Москва          | Лермонтов М.Ю.   | 2020-06-14 |
| Москва          | Есенин С.А.      | 2020-05-30 |
| Москва          | Булгаков М.А.    | 2020-05-25 |
| Москва          | Пастернак Б.Л.   | 2020-04-08 |
| Москва          | Достоевский Ф.М. | 2020-02-07 |
| Санкт-Петербург | Есенин С.А.      | 2020-12-14 |
| Санкт-Петербург | Пастернак Б.Л.   | 2020-10-10 |
| Санкт-Петербург | Булгаков М.А.    | 2020-09-27 |
| Санкт-Петербург | Достоевский Ф.М. | 2020-09-07 |
| Санкт-Петербург | Лермонтов М.Ю.   | 2020-04-21 |
+-----------------+------------------+------------+

--4. Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» в отсортированном по названиям книг виде.

SELECT name_genre, title, name_author
FROM genre
    JOIN book ON genre.genre_id=book.genre_id
    JOIN author ON author.author_id=book.author_id
WHERE name_genre = 'Роман'
ORDER BY title;

Query result:
+------------+--------------------+------------------+
| name_genre | title              | name_author      |
+------------+--------------------+------------------+
| Роман      | Белая гвардия      | Булгаков М.А.    |
| Роман      | Братья Карамазовы  | Достоевский Ф.М. |
| Роман      | Игрок              | Достоевский Ф.М. |
| Роман      | Идиот              | Достоевский Ф.М. |
| Роман      | Мастер и Маргарита | Булгаков М.А.    |
+------------+--------------------+------------------+

--5. Посчитать количество экземпляров  книг каждого автора из таблицы author.  Вывести тех авторов,  количество книг которых меньше 10, в отсортированном по возрастанию количества виде. Последний столбец назвать Количество.

SELECT name_author, SUM(amount) AS Количество
FROM 
    author LEFT JOIN book
    on author.author_id = book.author_id
GROUP BY name_author
HAVING Количество<10 OR Количество is NULL
ORDER BY Количество;  

Query result:
+----------------+------------+
| name_author    | Количество |
+----------------+------------+
| Лермонтов М.Ю. | NULL       |
| Пастернак Б.Л. | 2          |
| Булгаков М.А.  | 8          |
+----------------+------------+

--6. Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре. Поскольку у нас в таблицах так занесены данные, что у каждого автора книги только в одном жанре,  для этого запроса внесем изменения в таблицу book. Пусть у нас  книга Есенина «Черный человек» относится к жанру «Роман», а книга Булгакова «Белая гвардия» к «Приключениям» (эти изменения в таблицы уже внесены).

SELECT name_author
FROM book
    JOIN author ON author.author_id=book.author_id
GROUP BY name_author
HAVING COUNT(DISTINCT(genre_id))=1

Query result:
+------------------+
| name_author      |
+------------------+
| Достоевский Ф.М. |
| Пастернак Б.Л.   |
+------------------+

--7. Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра, цену и количество экземпляров книги), написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.

SELECT title, name_author, name_genre, price, amount
FROM 
    author 
    INNER JOIN book ON author.author_id = book.author_id
    INNER JOIN genre ON  book.genre_id = genre.genre_id
WHERE genre.genre_id IN
         (/* выбираем автора, если он пишет книги в самых популярных жанрах*/
          SELECT query_in_1.genre_id
          FROM 
              ( /* выбираем код жанра и количество произведений, относящихся к нему */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
               )query_in_1
          INNER JOIN 
              ( /* выбираем запись, в которой указан код жанр с максимальным количеством книг */
                SELECT genre_id, SUM(amount) AS sum_amount
                FROM book
                GROUP BY genre_id
                ORDER BY sum_amount DESC
                LIMIT 1
               ) query_in_2
          ON query_in_1.sum_amount= query_in_2.sum_amount
         )   
ORDER BY title

Query result:
+-----------------------+------------------+------------+--------+--------+
| title                 | name_author      | name_genre | price  | amount |
+-----------------------+------------------+------------+--------+--------+
| Белая гвардия         | Булгаков М.А.    | Роман      | 540.50 | 5      |
| Братья Карамазовы     | Достоевский Ф.М. | Роман      | 799.01 | 3      |
| Игрок                 | Достоевский Ф.М. | Роман      | 480.50 | 10     |
| Идиот                 | Достоевский Ф.М. | Роман      | 460.00 | 10     |
| Лирика                | Пастернак Б.Л.   | Поэзия     | 518.99 | 10     |
| Мастер и Маргарита    | Булгаков М.А.    | Роман      | 670.99 | 3      |
| Стихотворения и поэмы | Есенин С.А.      | Поэзия     | 650.00 | 15     |
| Черный человек        | Есенин С.А.      | Поэзия     | 570.20 | 6      |
+-----------------------+------------------+------------+--------+--------+


--8. Если в таблицах supply  и book есть одинаковые книги, которые имеют равную цену,  вывести их название и автора, а также посчитать общее количество экземпляров книг в таблицах supply и book,  столбцы назвать Название, Автор  и Количество.

SELECT title AS Название, name_author AS Автор, SUM(book.amount + supply.amount) AS Количество
FROM supply 
INNER JOIN book USING(price,title)
INNER JOIN author ON author.name_author = supply.author
GROUP BY author.name_author, book.title;

Query result:
+----------------+-------------+------------+
| Название       | Автор       | Количество |
+----------------+-------------+------------+
| Черный человек | Есенин С.А. | 12         |
+----------------+-------------+------------+
