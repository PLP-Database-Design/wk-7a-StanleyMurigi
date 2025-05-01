

-- Question 1: Achieving 1NF (First Normal Form) 🛠️
-- Goal: Remove repeating groups in the Products column by splitting each product into its own row.

-- Assuming original table is named ProductDetail
-- First, use a CTE or raw insert if we're transforming it manually (depending on DBMS, e.g., PostgreSQL supports string_to_array + unnest)

-- Sample transformation (PostgreSQL syntax):
WITH normalized AS (
  SELECT 
    OrderID,
    CustomerName,
    unnest(string_to_array(Products, ', ')) AS Product
  FROM 
    ProductDetail
)
SELECT * FROM normalized;

-- For other SQL dialects that don’t support unnest, you'd need to do it via multiple UNIONs or in your application logic.


-- Question 2: Achieving 2NF (Second Normal Form) 🧩
-- Goal: Remove partial dependency of CustomerName on OrderID by normalizing into two separate tables.

-- Step 1: Create a separate table for Orders
-- Each order has one customer — OrderID is the primary key here

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(255)
);

-- Step 2: Create a new table for OrderDetails (removing CustomerName)
-- Composite key: (OrderID, Product)

CREATE TABLE OrderLineItems (
  OrderID INT,
  Product VARCHAR(255),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Optional: Populate the tables (sample inserts)
-- Insert into Orders
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert into OrderLineItems
INSERT INTO OrderLineItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);
