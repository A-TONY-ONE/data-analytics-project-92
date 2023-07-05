--4.1 customers_count.csv запрос, который считает общее количество покупателей
select count(customer_id) as customers_count
from customers;

  
--5.1 Отчет о десятке лучших продавцов
select
    first_name || ' ' || last_name as name,
    count(s.sales_id) as operations,
    ROUND(sum(s.quantity * p.price)) as income
from
    employees e
left join sales s on
    e.employee_id = s.sales_person_id
left join products p on
    p.product_id = s.product_id
group by
    e.employee_id
order by
    income desc nulls last
limit 10;

--5.2 lowest_average_income.csv  Информация о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам.
SELECT
    e.first_name || ' ' || e.last_name AS name,
    ROUND(AVG(s.quantity * p.price)) AS average_income
FROM
    sales s 
LEFT JOIN employees e ON
    s.sales_person_id=e.employee_id
LEFT JOIN products p ON
    p.product_id = s.product_id
GROUP BY
    e.employee_id
HAVING
    ROUND(AVG(s.quantity * p.price)) < (SELECT AVG(p2.price * s2.quantity) FROM sales s2 LEFT JOIN products p2 ON
    p2.product_id = s2.product_id)
order by average_income ASC
;

/*5.3 Третий отчет содержит информацию о выручке по дням недели. Каждая запись содержит имя 
и фамилию продавца, день недели и суммарную выручку. Отсортируйте данные по порядковому 
номеру дня недели и name
name — имя и фамилия продавца
weekday — название дня недели на английском языке
income — суммарная выручка продавца в определенный день недели, округленная до целого числа*/
SELECT
    CONCAT(first_name, ' ', last_name) AS name,
    TO_CHAR(s.sale_date, 'Day') AS weekday,
    ROUND(SUM(s.quantity * p.price), 0) AS income
FROM
    employees e
LEFT JOIN sales s ON
    e.employee_id = s.sales_person_id
LEFT JOIN products p ON
    p.product_id = s.product_id
GROUP BY
     s.sale_date,2, 1
order by EXTRACT(ISODOW FROM s.sale_date);

--6.1 Количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+
SELECT '16-25' as age_category, COUNT(distinct (customer_id)) as count 
FROM customers 
WHERE age BETWEEN 16 AND 25 
UNION ALL 
SELECT '26-40' as age_category, COUNT(distinct (customer_id)) as count 
FROM customers 
WHERE age BETWEEN 26 AND 40 
UNION ALL 
SELECT '40+' as age_category, COUNT(distinct (customer_id)) as count 
FROM customers 
WHERE age > 40;

/*6.2 Во втором отчете предоставьте данные по количеству уникальных покупателей и выручке, которую они принесли. Сгруппируйте данные по дате, которая представлена в числовом виде ГОД-МЕСЯЦ. Итоговая таблица должна быть отсортирована по дате по возрастанию и содержать следующие поля:
date - дата в указанном формате
total_customers - количество покупателей
income - принесенная выручка*/
SELECT
    to_char(s.sale_date, 'YYYY-MM') AS date,
    count(DISTINCT (s.customer_id)) AS total_customers,
    ROUND(sum(s.quantity * p.price), 3) AS income
FROM
    sales s
LEFT JOIN products p ON
    p.product_id = s.product_id
GROUP BY
   1
ORDER BY
    1 ASC ;

/*6.3 Третий отчет следует составить о покупателях, первая покупка которых была в ходе проведения акций (акционные товары отпускали со стоимостью равной 0). Итоговая таблица должна быть отсортирована по id покупателя. Таблица состоит из следующих полей:
customer - имя и фамилия покупателя
sale_date - дата покупки
seller - имя и фамилия продавца*/
select DISTINCT on (c.customer_id)
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    to_char(s.sale_date, 'YYYY-MM-DD') AS sale_date,
    CONCAT(e.first_name, ' ', e.last_name) AS seller
FROM
    sales s
LEFT JOIN products p ON
    p.product_id = s.product_id
LEFT JOIN employees e ON
    s.sales_person_id = e.employee_id 
LEFT JOIN customers c on
    s.customer_id = c.customer_id 
WHERE p.price = 0
ORDER by c.customer_id ASC;
