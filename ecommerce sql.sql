-- =============================================
-- E-commerce SQL Analysis Project
-- =============================================

-- =============================================
-- 0. إعداد الداتابيز
-- =============================================

CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- إنشاء الجداول
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    city VARCHAR(50),
    segment VARCHAR(20),
    registration_date DATE
);

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    order_date DATE,
    status VARCHAR(20),
    payment_method VARCHAR(30),
    shipping_country VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(4,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id VARCHAR(10) PRIMARY KEY,
    order_id VARCHAR(10),
    rating INT,
    review_date DATE,
    verified_purchase BOOLEAN,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- =============================================
-- FIX: حل مشكلة تنسيق التاريخ
-- =============================================

-- 1. غيري نوع العمود لـ TEXT الأول قبل الاستيراد
ALTER TABLE orders MODIFY order_date TEXT;

-- 2. بعد الاستيراد، أضيفي عمود جديد من نوع DATE
ALTER TABLE orders ADD COLUMN order_date_fixed DATE;

-- 3. حولي التاريخ من نص لصيغة DATE صحيحة
SET SQL_SAFE_UPDATES = 0;
UPDATE orders 
SET order_date_fixed = STR_TO_DATE(order_date, '%m/%d/%Y');

-- 4. تأكدي إن التحويل صح قبل ما تكملي
SELECT order_id, order_date, order_date_fixed 
FROM orders 
LIMIT 5;

-- 5. امسحي العمود القديم وسمي الجديد بنفس الاسم
ALTER TABLE orders DROP COLUMN order_date;
ALTER TABLE orders CHANGE order_date_fixed order_date DATE;

-- =============================================
-- Query 1: Revenue & Profit بالشهر
-- =============================================

SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.total_price) AS total_revenue,
    SUM(oi.quantity * p.cost) AS total_cost,
    SUM(oi.total_price) - SUM(oi.quantity * p.cost) AS total_profit,
    ROUND(
        (SUM(oi.total_price) - SUM(oi.quantity * p.cost)) / SUM(oi.total_price) * 100, 
    2) AS profit_margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- =============================================
-- Query 2: Top Customers (أكتر العملاء إنفاقاً)
-- =============================================

SELECT 
    cust.customer_name, 
    SUM(oi.total_price) AS Total_Price
FROM customers cust
JOIN orders o ON cust.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY cust.customer_name
ORDER BY Total_Price DESC;

-- =============================================
-- Query 3A: Top Products بالكمية المباعة
-- =============================================

SELECT 
    pro.product_name, 
    SUM(oi.quantity) AS total_quantity
FROM products pro
JOIN order_items oi ON pro.product_id = oi.product_id
GROUP BY pro.product_name 
ORDER BY total_quantity DESC;

-- =============================================
-- Query 3B: Top Products بالإيراد (الأهم تجارياً)
-- =============================================

SELECT 
    pro.product_name, 
    SUM(oi.total_price) AS total_revenue
FROM products pro
JOIN order_items oi ON pro.product_id = oi.product_id
GROUP BY pro.product_name
ORDER BY total_revenue DESC;

-- =============================================
-- Query 4: Customer Segments Analysis
-- =============================================

SELECT 
    cust.segment,
    SUM(oi.total_price) AS total_spending,
    COUNT(DISTINCT cust.customer_id) AS customer_count,
    ROUND(SUM(oi.total_price) / COUNT(DISTINCT cust.customer_id), 2) AS avg_spending_per_customer
FROM customers cust
JOIN orders o ON cust.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY cust.segment
ORDER BY avg_spending_per_customer DESC;

-- =============================================
-- Query 5: Average Order Value (AOV)
-- =============================================

SELECT 
    SUM(oi.total_price) AS total_spending,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(oi.total_price) / COUNT(DISTINCT o.order_id), 2) AS AOV
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered';