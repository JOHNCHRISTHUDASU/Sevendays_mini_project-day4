
-- ============================================================
-- 7 DAYS SQL CHALLENGE - DAY 4
-- CUSTOMER BEHAVIOR AND LOYALTY ANALYSIS
-- Database: sql7challenge
-- ============================================================

USE sql7challenge;


-- Q1: Total Customers
-- Count total registered customers.

SELECT
    COUNT(*) AS total_customers
FROM customers;


-- Q2: Customers by City
-- Count customers in each city.

SELECT
    city,
    COUNT(*) AS customers_count
FROM customers
GROUP BY city
ORDER BY customers_count DESC;


-- Q3: Top 10 Customers by Order Count
-- Find top 10 customers with the highest number
-- of non-cancelled orders.

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE LOWER(o.status) != 'cancelled'
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY total_orders DESC
LIMIT 10;


-- Q4: Customer Spending
-- Calculate total spending of each customer,
-- excluding cancelled orders.

SELECT
    c.customer_id,
    c.full_name,
    SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE LOWER(o.status) != 'cancelled'
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY total_spending DESC;


-- Q5: Average Spending per Customer
-- Calculate average spending among customers
-- who placed at least one non-cancelled order.

SELECT
    ROUND(AVG(customer_spending), 2)
        AS average_spending_per_customer
FROM (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price)
            AS customer_spending
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE LOWER(o.status) != 'cancelled'
    GROUP BY o.customer_id
) AS customer_totals;


-- Q6: Customers with More Than 5 Orders
-- Find customers with more than 5 non-cancelled orders.

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE LOWER(o.status) != 'cancelled'
GROUP BY
    c.customer_id,
    c.full_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;


-- Q7: Customer Segment Analysis
-- Count customers in each segment.

SELECT
    segment,
    COUNT(*) AS customers_count
FROM customers
GROUP BY segment
ORDER BY customers_count DESC;


-- Q8: Average Orders per Customer
-- Include customers with zero non-cancelled orders.

SELECT
    ROUND(AVG(order_count), 2)
        AS average_orders_per_customer
FROM (
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
        AND LOWER(o.status) != 'cancelled'
    GROUP BY c.customer_id
) AS customer_orders;


-- Q9: Top 10 Customers by Spending
-- Find top 10 customers with the highest
-- item sales value from non-cancelled orders.

SELECT
    c.customer_id,
    c.full_name,
    SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE LOWER(o.status) != 'cancelled'
GROUP BY
    c.customer_id,
    c.full_name
ORDER BY total_spending DESC
LIMIT 10;


-- Q10: Customer Signups by Month
-- Count new customer registrations per month
-- in chronological order.

SELECT
    DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
ORDER BY signup_month ASC;


-- ============================================================
-- END OF DAY 4
-- ============================================================
