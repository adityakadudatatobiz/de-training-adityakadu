# AdventureWorksLT 2022 – SQL Schema Analysis

## 1. Tables and Row Counts

| Table Name | Row Count |
|---|---:|
| Address | 450 |
| Customer | 847 |
| CustomerAddress | 417 |
| Product | 295 |
| ProductCategory | 41 |
| ProductDescription | 762 |
| ProductModel | 128 |
| ProductModelProductDescription | 762 |
| SalesOrderDetail | 542 |
| SalesOrderHeader | 32 |

## 2. Primary Keys

| Table Name | Primary Key |
|---|---|
| Address | AddressID |
| Customer | CustomerID |
| CustomerAddress | AddressID, CustomerID |
| Product | ProductID |
| ProductCategory | ProductCategoryID |
| ProductDescription | ProductDescriptionID |
| ProductModel | ProductModelID |
| ProductModelProductDescription | Culture, ProductDescriptionID, ProductModelID |
| SalesOrderDetail | SalesOrderDetailID, SalesOrderID |
| SalesOrderHeader | SalesOrderID |

## 3. Foreign Keys

| Child Table | Child Column | Parent Table | Parent Column |
|---|---|---|---|
| CustomerAddress | CustomerID | Customer | CustomerID |
| CustomerAddress | AddressID | Address | AddressID |
| Product | ProductCategoryID | ProductCategory | ProductCategoryID |
| Product | ProductModelID | ProductModel | ProductModelID |
| ProductCategory | ParentProductCategoryID | ProductCategory | ProductCategoryID |
| ProductModelProductDescription | ProductModelID | ProductModel | ProductModelID |
| ProductModelProductDescription | ProductDescriptionID | ProductDescription | ProductDescriptionID |
| SalesOrderDetail | SalesOrderID | SalesOrderHeader | SalesOrderID |
| SalesOrderDetail | ProductID | Product | ProductID |
| SalesOrderHeader | CustomerID | Customer | CustomerID |
| SalesOrderHeader | ShipToAddressID | Address | AddressID |
| SalesOrderHeader | BillToAddressID | Address | AddressID |

## 4. Questions

### 1. Which table is the centre of the model?

The `SalesOrderHeader` table is an important central table in the sales part of the model. It connects sales orders with customers and addresses, and it is referenced by `SalesOrderDetail`.

### 2. Which table references itself, and why?

The `ProductCategory` table references itself through:

`ParentProductCategoryID → ProductCategoryID`

This allows the database to represent a category hierarchy, where one product category can have another category as its parent.

### 3. What is the difference between SalesOrderHeader and SalesOrderDetail grain?

- **SalesOrderHeader:** One row represents one sales order.
- **SalesOrderDetail:** One row represents one line item within a sales order.

Therefore, one sales order in `SalesOrderHeader` can have multiple related rows in `SalesOrderDetail`.

## 5. ER Diagram

The ER diagram is available in:

`er_diagram.png`