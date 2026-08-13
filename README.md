# Data Engineer SQL Challenges - Olist E-Commerce Dataset

This repository contains a growing, comprehensive set of SQL challenges designed for aspiring and practicing Data Engineers. It uses the real-world **Brazilian E-Commerce Public Dataset by Olist** to practice writing analytical queries, starting from basic concepts to advanced analytical window functions.

> **🌱 Continuous Learning Journey:** This repository is an active, living project. I am continuously pushing new challenges and complex queries to refine my Data Engineering skills. It serves as a personal log of my progress and mastery over SQL.

## 🚀 Features

- **Real-World Dataset**: Uses the Olist E-Commerce dataset, featuring multiple normalized tables including Customers, Orders, Order Items, Payments, Products, Reviews, Sellers, and Geolocation.
- **Progressive Challenges (Ongoing)**: A structured, expanding learning path currently covering:
  - [x] 1. Basic SELECT & Filtering
  - [x] 2. JOINs (Inner, Left, etc.)
  - [x] 3. Aggregations & `GROUP BY`
  - [x] 4. Subqueries & CTEs (Common Table Expressions)
  - [x] 5. Window Functions (`ROW_NUMBER()`, `RANK()`, `SUM() OVER()`)
  - [ ] *6. Advanced Analytics & Cohort Analysis (WIP)*
  - [ ] *7. Data Cleaning & String Manipulations (Planned)*
  - [ ] *8. Query Optimization & Performance Tuning (Planned)*
- **Dockerized Postgres Environment**: Easily spin up the entire database locally with Docker Compose, complete with automatic table creation and seed data ingestion.

## 🛠 Prerequisites

- [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/)
- A SQL client (e.g., DBeaver, DataGrip, pgAdmin) or `psql` via terminal.

## ⚙️ Quick Start

1. **Clone the repository** (if applicable) and navigate to the project directory:
   ```bash
   cd "Data Engineer SQL"
   ```

2. **Download the Dataset**:
   Download the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle. Extract the CSV files and place them inside the `seed/` directory in this project.

3. **Spin up the Database Environment**:
   Run the following command to start the PostgreSQL container. This will automatically run `init.sql` to create the schema and populate it with the Olist CSV seed data.
   ```bash
   docker-compose up -d
   ```

3. **Connect to the Database**:
   You can connect to the Postgres database using the following credentials:
   - **Host**: `localhost`
   - **Port**: `5432`
   - **User**: `data_engineer`
   - **Password**: `password123`
   - **Database**: `olist`

   *Alternatively, via terminal:*
   ```bash
   docker exec -it olist_postgres psql -U data_engineer -d olist
   ```

## 📂 Project Structure

```
├── challenges/             # Directory containing the SQL challenges
│   ├── 01_basic_select.sql
│   ├── 02_joins.sql
│   ├── 03_aggregations.sql
│   ├── 04_subqueries_ctes.sql
│   └── 05_window_functions.sql
├── database/               
│   └── init.sql            # Schema definitions and data copy commands
├── seed/                   # Raw CSV dataset (Olist)
├── docker-compose.yml      # Docker compose configuration for Postgres
└── README.md
```

## 📊 Database Schema

The database `olist` consists of the following core tables:
- `customers`
- `orders`
- `order_items`
- `order_payments`
- `order_reviews`
- `products`
- `sellers`
- `geolocation`
- `product_category_name_translation`

*(Refer to `database/init.sql` for precise column definitions).*

## 💡 How to Use

1. Navigate to the `challenges/` folder.
2. Open each `.sql` file starting from `01_basic_select.sql`.
3. Read the prompt for each question and write your query in the designated space.
4. Execute the query against your local Dockerized Postgres database to verify the results.

## 🤝 Contributing
Feel free to open an issue or submit a pull request if you'd like to add more challenges or optimize existing ones!

## 📜 Acknowledgements
Dataset provided by [Olist](https://olist.com/) and made publicly available on Kaggle as the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
