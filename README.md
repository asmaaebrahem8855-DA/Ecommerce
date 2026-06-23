# 🛒 E-commerce Sales Analysis Project

## 📌 Project Overview
This project analyzes e-commerce sales data using **MySQL** and **Power BI** to extract business insights across sales performance, customer behavior, and product analysis.

---

## 🗄️ Database Structure
The database consists of **5 related tables:**

```
customers ──< orders ──< order_items >── products
                  └──< reviews
```

| Table | Description | Rows |
|---|---|---|
| `customers` | Customer info (name, country, segment) | 200 |
| `products` | Product details (category, price, cost) | 23 |
| `orders` | Order records (date, status, payment) | 1,000 |
| `order_items` | Order line items (quantity, discount, total) | 2,922 |
| `reviews` | Customer ratings | 400 |

---

## 🔧 Tools Used
- **MySQL** — Data storage & SQL analysis
- **Power BI** — Interactive dashboard & DAX measures

---

## 📊 SQL Analysis

### 1. Monthly Revenue & Profit
Tracks revenue, cost, profit, and profit margin % per month for delivered orders.

**Key Finding:** June 2023 was the highest revenue month (234,670) with a consistent profit margin of ~42-43% across all months.

### 2. Top Customers by Spending
Ranks all 200 customers by total spending on delivered orders.

**Key Finding:** Top customer (Customer_93) spent 34,801 — 150x more than the lowest spender (229), a classic Pareto distribution.

### 3. Top Products — Quantity vs Revenue
Compares products by units sold vs actual revenue generated.

**Key Finding:** Curtains ranked #1 by quantity (374 units) but only #5 by revenue. Tablet ranked #12 by quantity but #1 by revenue (588,710) — proving that sales volume alone is not a reliable performance metric.

### 4. Customer Segment Analysis (VIP / Regular / New)
Compares total spending and average spending per customer across segments.

**Key Finding:** Despite Regular customers having higher total spending (due to larger count), VIP customers spend 18% more per person (12,281) vs Regular (10,447) — validating the VIP classification.

### 5. Average Order Value (AOV)
Calculates the average value of each delivered order.

**Key Finding:** AOV = **3,405** — a key benchmark for measuring the impact of promotions and discount strategies.

---

## 📈 Power BI Dashboard

The dashboard includes:
- 📈 **Line Chart** — Monthly Revenue Trend
- 📊 **Bar Chart** — Top Products by Revenue
- 🍩 **Donut Chart** — Sales by Customer Segment
- 🔢 **Card** — Average Order Value (AOV)
- 🎛️ **Slicer** — Filter by Order Status

---

## 💡 Key Business Insights

1. **Sales volume ≠ Revenue** — High-ticket Electronics dominate revenue despite lower unit sales
2. **VIP customers** deliver higher value per person, justifying targeted retention strategies
3. **June** is the peak month — ideal timing for promotions and inventory planning
4. **AOV of 3,405** sets a baseline to measure future campaign effectiveness

---

## 📁 Project Files

| File | Description |
|---|---|
| `ecommerce_queries.sql` | All SQL queries with comments |
| `ecommerce_dashboard.pbix` | Power BI dashboard file |
| `datasets/` | CSV files (customers, products, orders, order_items, reviews) |

---

## 👩‍💻 Author
Data Analyst \| Cairo, Egypt
