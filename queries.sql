--4.1 запрос, который считает общее количество покупателей
select count(customer_id) as customers_count
from 
customers

  
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

--5.2: Информация о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам.

SELECT
    e.first_name || ' ' || e.last_name AS name,
    ROUND(AVG(s.quantity * p.price)) AS average_income
FROM
    employees e
LEFT JOIN sales s ON
    e.employee_id = s.sales_person_id
LEFT JOIN products p ON
    p.product_id = s.product_id
GROUP BY
    e.employee_id
HAVING
    ROUND(AVG(s.quantity * p.price)) < (SELECT AVG(p2.price * s2.quantity) FROM sales s2 LEFT JOIN products p2 ON
    p2.product_id = s2.product_id)
order by average_income desc
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
