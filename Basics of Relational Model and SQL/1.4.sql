+---------+-----------------------+------------------+--------+--------+
| book_id | title                 | author           | price  | amount |
+---------+-----------------------+------------------+--------+--------+
| 1       | Мастер и Маргарита    | Булгаков М.А.    | 670.99 | 3      |
| 2       | Белая гвардия         | Булгаков М.А.    | 540.50 | 5      |
| 3       | Идиот                 | Достоевский Ф.М. | 460.00 | 10     |
| 4       | Братья Карамазовы     | Достоевский Ф.М. | 799.01 | 3      |
| 5       | Игрок                 | Достоевский Ф.М. | 480.50 | 10     |
| 6       | Стихотворения и поэмы | Есенин С.А.      | 650.00 | 15     |
+---------+-----------------------+------------------+--------+--------+

-- 1. Вывести информацию (автора, название и цену) о  книгах, цены которых меньше или равны средней цене книг на складе. Информацию вывести в отсортированном по убыванию цены виде. Среднее вычислить как среднее по цене книги.

SELECT author, title, price
FROM book
WHERE price<=(
    SELECT AVG(price)
    FROM book
    )
ORDER BY price DESC;

Query result:
+------------------+---------------+--------+
| author           | title         | price  |
+------------------+---------------+--------+
| Булгаков М.А.    | Белая гвардия | 540.50 |
| Достоевский Ф.М. | Игрок         | 480.50 |
| Достоевский Ф.М. | Идиот         | 460.00 |
+------------------+---------------+--------+

-- 2. Вывести информацию (автора, название и цену) о тех книгах, цены которых превышают минимальную цену книги на складе не более чем на 150 рублей в отсортированном по возрастанию цены виде.

SELECT author, title, price
FROM book
WHERE (price-(SELECT MIN(price) FROM book))<=150
ORDER BY price;

Query result:
+------------------+----------------+--------+
| author           | title          | price  |
+------------------+----------------+--------+
| Достоевский Ф.М. | Идиот          | 460.00 |
| Достоевский Ф.М. | Игрок          | 480.50 |
| Булгаков М.А.    | Белая гвардия  | 540.50 |
| Пушкин А.С.      | Евгений Онегин | 610.00 |
+------------------+----------------+--------+