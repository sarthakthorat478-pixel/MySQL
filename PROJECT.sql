
--       PHARMACY STORE MANAGEMENT SYSTEM



--  1: DDL (Data Definition Language) ***************************


CREATE DATABASE  PharmacyStoreDB;
USE PharmacyStoreDB;

-- Table 1: Categories
CREATE TABLE Categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description   TEXT
);

-- Table 2: Suppliers
CREATE TABLE Suppliers (
    supplier_id   INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_name  VARCHAR(100),
    phone         VARCHAR(20),
    email         VARCHAR(100),
    address       VARCHAR(255),
    city          VARCHAR(80)
);

-- Table 3: Medicines
CREATE TABLE Medicines (
    medicine_id    INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name  VARCHAR(150) NOT NULL,
    category_id    INT,
    supplier_id    INT,
    price          DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    expiry_date    DATE,
    manufacture_date DATE,
    requires_prescription TINYINT(1) DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Table 4: Customers
CREATE TABLE Customers (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(80) NOT NULL,
    last_name     VARCHAR(80) NOT NULL,
    phone         VARCHAR(20),
    email         VARCHAR(100),
    address       VARCHAR(255),
    city          VARCHAR(80),
    date_of_birth DATE,
    loyalty_points INT DEFAULT 0
);

-- Table 5: Employees
CREATE TABLE Employees (
    employee_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(80) NOT NULL,
    last_name     VARCHAR(80) NOT NULL,
    role          VARCHAR(80),
    salary        DECIMAL(10,2),
    hire_date     DATE,
    phone         VARCHAR(20),
    email         VARCHAR(100)
);

-- Table 6: Sales
CREATE TABLE Sales (
    sale_id       INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT,
    employee_id   INT,
    sale_date     DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount  DECIMAL(10,2),
    discount      DECIMAL(5,2) DEFAULT 0.00,
    payment_mode  VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Table 7: Sale_Items
CREATE TABLE Sale_Items (
    item_id       INT AUTO_INCREMENT PRIMARY KEY,
    sale_id       INT,
    medicine_id   INT,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id)     REFERENCES Sales(sale_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);

-- Table 8: Purchase_Orders
CREATE TABLE Purchase_Orders (
    order_id      INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id   INT,
    order_date    DATE,
    total_cost    DECIMAL(10,2),
    status        VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Table: Audit_Log (used by Trigger)
CREATE TABLE Audit_Log (
    log_id        INT AUTO_INCREMENT PRIMARY KEY,
    action_type   VARCHAR(50),
    table_name    VARCHAR(80),
    record_id     INT,
    action_time   DATETIME DEFAULT CURRENT_TIMESTAMP,
    performed_by  VARCHAR(100)
);


-- ALTER TABLE Examples (DDL)  ***********************###########

ALTER TABLE Customers ADD COLUMN gender VARCHAR(10);

ALTER TABLE Employees  MODIFY COLUMN salary DECIMAL(12,2);   -- USED



--  DML (Data Manipulation Language)


-- INSERT: Categories
INSERT INTO Categories (category_name, description) VALUES
('Antibiotics',       'Medicines that kill or inhibit bacteria'),
('Analgesics',        'Pain-relieving medicines'),
('Antifungals',       'Medicines used to treat fungal infections'),
('Vitamins',          'Nutritional supplements and vitamins'),
('Antacids',          'Medicines to neutralize stomach acid'),
('Antihistamines',    'Medicines for allergies'),
('Antipyretics',      'Fever-reducing medicines'),
('Cardiovascular',    'Heart and blood pressure medicines');

-- INSERT: Suppliers
INSERT INTO Suppliers (supplier_name, contact_name, phone, email, address, city) VALUES
('Sun Pharma',          'Rajiv Mehta',   '9876543210', 'rajiv@sunpharma.com',    '12 Industrial Area',  'Mumbai'),
('Cipla Ltd',           'Anita Sharma',  '9123456789', 'anita@cipla.com',        '45 Pharma Zone',      'Pune'),
('Dr. Reddys Labs',     'Suresh Reddy',  '9234567890', 'suresh@drreddys.com',    '78 Biotech Park',     'Hyderabad'),
('Abbott India',        'Priya Nair',    '9345678901', 'priya@abbott.com',       '22 MG Road',          'Bangalore'),
('Lupin Pharma',        'Amit Joshi',    '9456789012', 'amit@lupin.com',         '99 Pharma Street',    'Mumbai');

-- INSERT: Medicines
INSERT INTO Medicines (medicine_name, category_id, supplier_id, price, stock_quantity, expiry_date, manufacture_date, requires_prescription, dosage_form) VALUES
('Amoxicillin 500mg',     1, 1, 85.00,  200, '2026-06-30', '2024-06-01', 1, 'Capsule'),
('Azithromycin 250mg',    1, 2, 120.50, 150, '2026-09-30', '2024-09-01', 1, 'Tablet'),
('Paracetamol 650mg',     2, 3, 25.00,  500, '2027-01-31', '2025-01-01', 0, 'Tablet'),
('Ibuprofen 400mg',       2, 1, 35.00,  400, '2026-12-31', '2024-12-01', 0, 'Tablet'),
('Clotrimazole Cream',    3, 4, 60.00,  100, '2026-08-31', '2024-08-01', 0, 'Cream'),
('Vitamin C 1000mg',      4, 5, 45.00,  300, '2027-03-31', '2025-03-01', 0, 'Tablet'),
('Vitamin D3 60K',        4, 2, 95.00,  180, '2027-06-30', '2025-06-01', 0, 'Capsule'),
('Omeprazole 20mg',       5, 3, 55.00,  250, '2026-11-30', '2024-11-01', 1, 'Capsule'),
('Pantoprazole 40mg',     5, 4, 70.00,  200, '2026-10-31', '2024-10-01', 1, 'Tablet'),
('Cetirizine 10mg',       6, 5, 30.00,  350, '2027-02-28', '2025-02-01', 0, 'Tablet'),
('Loratadine 10mg',       6, 1, 40.00,  280, '2027-04-30', '2025-04-01', 0, 'Tablet'),
('Dolo 650',              7, 2, 28.00,  600, '2027-05-31', '2025-05-01', 0, 'Tablet'),
('Metformin 500mg',       8, 3, 18.00,  400, '2026-07-31', '2024-07-01', 1, 'Tablet'),
('Amlodipine 5mg',        8, 4, 22.00,  320, '2026-09-30', '2024-09-01', 1, 'Tablet'),
('Atorvastatin 10mg',     8, 5, 75.00,  190, '2026-12-31', '2024-12-01', 1, 'Tablet');

-- INSERT: Customers
INSERT INTO Customers (first_name, last_name, phone, email, address, city, date_of_birth, loyalty_points, gender) VALUES
('Aisha',    'Khan',     '9001112222', 'aisha.khan@gmail.com',    '10 Park Lane',      'Mumbai',    '1990-04-15', 120, 'Female'),
('Rohan',    'Verma',    '9002223333', 'rohan.verma@gmail.com',   '22 MG Road',        'Delhi',     '1985-07-20', 85,  'Male'),
('Priya',    'Patel',    '9003334444', 'priya.patel@yahoo.com',   '5 Shivaji Nagar',   'Pune',      '1995-11-05', 200, 'Female'),
('Suresh',   'Nair',     '9004445555', 'suresh.nair@gmail.com',   '77 Anna Salai',     'Chennai',   '1978-02-28', 55,  'Male'),
('Kavya',    'Iyer',     '9005556666', 'kavya.iyer@outlook.com',  '33 Jubilee Hills',  'Hyderabad', '2000-09-10', 310, 'Female'),
('Amit',     'Singh',    '9006667777', 'amit.singh@gmail.com',    '45 Banjara Hills',  'Hyderabad', '1988-12-01', 40,  'Male'),
('Meena',    'Sharma',   '9007778888', 'meena.sharma@gmail.com',  '8 Civil Lines',     'Jaipur',    '1972-06-18', 175, 'Female'),
('Vikram',   'Rao',      '9008889999', 'vikram.rao@gmail.com',    '90 Koramangala',    'Bangalore', '1993-03-25', 90,  'Male');

-- INSERT: Employees
INSERT INTO Employees (first_name, last_name, role, salary, hire_date, phone, email) VALUES
('Neha',   'Gupta',    'Pharmacist',    55000.00, '2020-03-15', '9111222333', 'neha.gupta@pharmacy.com'),
('Ravi',   'Kumar',    'Store Manager', 70000.00, '2018-07-01', '9222333444', 'ravi.kumar@pharmacy.com'),
('Pooja',  'Mishra',   'Sales Staff',   30000.00, '2021-01-10', '9333444555', 'pooja.mishra@pharmacy.com'),
('Arjun',  'Desai',    'Pharmacist',    52000.00, '2019-11-20', '9444555666', 'arjun.desai@pharmacy.com'),
('Sneha',  'Bose',     'Cashier',       28000.00, '2022-05-05', '9555666777', 'sneha.bose@pharmacy.com');

-- INSERT: Sales
INSERT INTO Sales (customer_id, employee_id, sale_date, total_amount, discount, payment_mode) VALUES
(1, 3, '2025-01-10 10:30:00', 255.00,  5.00,  'Cash'),
(2, 1, '2025-01-12 11:00:00', 120.50,  0.00,  'Card'),
(3, 5, '2025-01-15 14:15:00', 185.00,  10.00, 'UPI'),
(4, 3, '2025-02-01 09:45:00', 340.00,  0.00,  'Cash'),
(5, 1, '2025-02-14 16:00:00', 95.00,   0.00,  'UPI'),
(6, 4, '2025-03-05 12:30:00', 210.00,  15.00, 'Card'),
(7, 2, '2025-03-20 10:00:00', 430.00,  20.00, 'Cash'),
(8, 5, '2025-04-02 13:45:00', 75.00,   0.00,  'UPI'),
(1, 3, '2025-04-18 11:30:00', 310.00,  5.00,  'Card'),
(3, 1, '2025-05-07 15:00:00', 145.00,  0.00,  'Cash');

-- INSERT: Sale_Items
INSERT INTO Sale_Items (sale_id, medicine_id, quantity, unit_price) VALUES
(1,  3,  5, 25.00),
(1,  6,  3, 45.00),
(1,  12, 2, 28.00),
(2,  2,  1, 120.50),
(3,  5,  2, 60.00),
(3,  10, 3, 30.00),
(4,  1,  2, 85.00),
(4,  8,  2, 55.00),
(4,  13, 5, 18.00),
(5,  7,  1, 95.00),
(6,  4,  3, 35.00),
(6,  11, 3, 40.00),
(7,  14, 4, 22.00),
(7,  15, 3, 75.00),
(7,  9,  2, 70.00),
(8,  10, 1, 30.00),
(8,  11, 1, 40.00),
(9,  1,  2, 85.00),
(9,  2,  1, 120.50),
(10, 6,  2, 45.00),
(10, 12, 2, 28.00);

-- INSERT: Purchase_Orders
INSERT INTO Purchase_Orders (supplier_id, order_date, total_cost, status) VALUES
(1, '2025-01-05', 15000.00, 'Delivered'),
(2, '2025-02-10', 22000.00, 'Delivered'),
(3, '2025-03-01', 18500.00, 'Pending'),
(4, '2025-03-25', 30000.00, 'Delivered'),
(5, '2025-04-10', 12000.00, 'In Transit');

-- UPDATE (DML)
UPDATE Medicines SET price = 90.00  WHERE medicine_id = 1;    -- USED

UPDATE Employees SET salary = 58000.00 WHERE employee_id = 1;


-- DELETE (DML)

DELETE FROM Sale_Items WHERE unit_price= 18;




-- SECTION 3: DQL (Data Query Language) + OPERATORS ******************######


-- Basic SELECT
SELECT * FROM Medicines;
SELECT medicine_name, price, stock_quantity FROM Medicines;
SELECT medicine_name FROM Medicines;
SELECT price FROM Medicines;   -- USED
SELECT stock_quantity FROM Medicines;


-- OPERATORS **********************#######################

-- Arithmetic Operators


SELECT price * stock_quantity AS total_value FROM Medicines;  -- UESD

SELECT price + 10 AS price_with_markup FROM Medicines;



-- Comparison Operators
SELECT medicine_name, price FROM Medicines WHERE price > 50; -- USED
SELECT medicine_name, price FROM Medicines WHERE price = 25.00;



-- Logical Operators (AND, OR, NOT, IN, BETWEEN, IS NULL)

-- LOGICAL AND OPERATOR
SELECT medicine_name, price
FROM Medicines
WHERE price BETWEEN 20 AND 60;   






-- SECTION 4: CLAUSES **************###############


-- ORDER BY (ASC and DESC)
SELECT medicine_name, price FROM Medicines ORDER BY price ASC;  -- USED
SELECT medicine_name, price FROM Medicines ORDER BY price DESC;


-- DISTINCT Keyword
SELECT DISTINCT payment_mode FROM Sales;
SELECT DISTINCT city FROM Customers; -- USED
SELECT DISTINCT category_id FROM Medicines;

-- LIKE Operator
SELECT * FROM Medicines WHERE medicine_name LIKE 'A%';           -- starts with A
SELECT * FROM Medicines WHERE medicine_name LIKE '%mg';          -- ends with mg
SELECT * FROM Medicines WHERE medicine_name LIKE '%cin%';        -- contains 'cin'
SELECT * FROM Customers WHERE email LIKE '%@gmail.com';
SELECT * FROM Suppliers WHERE city LIKE 'Mum%';  -- USED



-- GROUP BY with HAVING
SELECT category_id, COUNT(*) AS total_medicines, AVG(price) AS avg_price
FROM Medicines
GROUP BY category_id
HAVING AVG(price) > 40;



-- SECTION 5: STRING FUNCTIONS *********************#############


SELECT UPPER(medicine_name) AS upper_name FROM Medicines LIMIT 5;  -- USED 
SELECT LOWER(medicine_name) AS lower_name FROM Medicines LIMIT 5;   -- USED
SELECT LENGTH(medicine_name) AS name_length FROM Medicines LIMIT 5;
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM Medicines JOIN Customers ON 1=1 LIMIT 5;
SELECT TRIM('  Paracetamol  ') AS trimmed LIMIT 5;






-- SECTION 6: MATH FUNCTIONS ****************###################


SELECT medicine_name, price, ROUND(price, 0) AS rounded_price FROM Medicines;  -- USED
SELECT medicine_name, price, CEIL(price) AS ceiling_price FROM Medicines;     -- USED
SELECT medicine_name, price, FLOOR(price) AS floor_price FROM Medicines;
SELECT medicine_name, price, ABS(price - 50) AS abs_diff_from_50 FROM Medicines;

SELECT medicine_name, price, SQRT(price) AS sqrt_price FROM Medicines;




-- SECTION 7: AGGREGATE FUNCTIONS #################*****************

SELECT COUNT(*) AS total_medicines FROM Medicines;
SELECT SUM(stock_quantity) AS total_stock FROM Medicines;  -- used
SELECT AVG(price)  AS average_price  FROM Medicines;
SELECT MAX(price)  AS most_expensive FROM Medicines;  -- used
SELECT MIN(price)  AS cheapest   FROM Medicines;
SELECT COUNT(DISTINCT category_id) AS total_categories FROM Medicines;   -- used

-- Aggregates with GROUP BY
SELECT
    c.category_name,
    COUNT(m.medicine_id)   AS total_medicines,
    SUM(m.stock_quantity)  AS total_stock,
    AVG(m.price)           AS avg_price,
    MAX(m.price)           AS max_price,
    MIN(m.price)           AS min_price
FROM Medicines m
JOIN Categories c ON m.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_medicines DESC;  -- used



-- SECTION 8: SUBQUERIES **************************#################




-- Subquery To find highest-selling medicine
SELECT medicine_name, price
FROM Medicines
WHERE medicine_id = (
    SELECT medicine_id FROM Sale_Items
    GROUP BY medicine_id
    ORDER BY SUM(quantity) DESC
    LIMIT 1
);                                     









-- SECTION 9: JOINS ###############***************


-- INNER JOIN: Sales with customer and employee details

SELECT s.sale_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
CONCAT(e.first_name, ' ', e.last_name) AS employee_name, s.sale_date,
s.total_amount, s.payment_mode
FROM Sales s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Employees e ON s.employee_id = e.employee_id;  

-- LEFT JOIN: All medicines even if never sold

SELECT m.medicine_name, m.price, si.quantity
FROM Medicines m
LEFT JOIN Sale_Items si ON m.medicine_id = si.medicine_id;  


-- RIGHT JOIN: All sale items and their medicine details

SELECT m.medicine_name, si.quantity, si.unit_price
FROM Sale_Items si
RIGHT JOIN Medicines m ON si.medicine_id = m.medicine_id; 







-- SECTION 10: VIEWS. ###############***********************


-- View 1: Medicine stock summary
CREATE OR REPLACE VIEW vw_Medicine_Stock AS
SELECT m.medicine_id, m.medicine_name, c.category_name, s.supplier_name,
m.price, m.stock_quantity, m.expiry_date, m.requires_prescription, m.dosage_form
FROM Medicines m
JOIN Categories c ON m.category_id = c.category_id
JOIN Suppliers s ON m.supplier_id = s.supplier_id;

-- View 2: Customer purchase history

CREATE OR REPLACE VIEW vw_Customer_Purchase AS
SELECT CONCAT(c.first_name,' ',c.last_name) AS customer_name, c.phone, s.sale_id,
s.sale_date, s.total_amount, s.discount, s.payment_mode
FROM Sales s JOIN Customers c ON s.customer_id = c.customer_id;      -- used



-- Querying Views
SELECT * FROM vw_Medicine_Stock;
SELECT * FROM vw_Customer_Purchase ORDER BY sale_date DESC;  -- used




-- SECTION 11: STORED PROCEDURE ###############***********


DELIMITER $$

CREATE PROCEDURE sp_SalesReport(IN p_start DATE, IN p_end DATE)
BEGIN
		SELECT
			s.sale_id,
			CONCAT(c.first_name,' ',c.last_name) AS customer,
			s.sale_date,
			s.total_amount,
			s.payment_mode
		FROM Sales s
		JOIN Customers c ON s.customer_id = c.customer_id
		WHERE DATE(s.sale_date) BETWEEN p_start AND p_end
		ORDER BY s.sale_date;

END$$                            

DELIMITER ;


CALL sp_SalesReport('2025-01-01', '2025-06-30'); 





-- SECTION 12: STORED FUNCTION ################**************************


-- Function : Get full customer name

DELIMITER $$

CREATE FUNCTION fn_FullName(p_first VARCHAR(80), p_last VARCHAR(80))
RETURNS VARCHAR(165)
DETERMINISTIC
BEGIN
		RETURN CONCAT(p_first, ' ', p_last);
END$$                                        


DELIMITER ;

SELECT fn_FullName(first_name, last_name) AS full_name FROM Customers; 







-- SECTION 13: TRIGGERS ****************##############################


DELIMITER $$


CREATE TRIGGER trg_AfterSaleInsert
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (action_type, table_name, record_id, performed_by)
    VALUES ('INSERT', 'Sales', NEW.sale_id, USER());
END$$                                                      


DELIMITER ;

--  Insert a new sale 

INSERT INTO Sales (customer_id, employee_id, total_amount, discount, payment_mode)
VALUES (4, 2, 90.00, 0.00, 'Cash');

-- View audit log after trigger
SELECT * FROM Audit_Log;


-- ALL THE SELECT QUERIES ****************###############

Select * from Categories;
Select * from Suppliers;
Select * from Medicines;

Select * from Customers;
Select * from Employees;
Select * from Sales;
Select * from Sale_Items;
Select * from Purchase_Orders;







CREATE TABLE staff (
    Staff_id   INT AUTO_INCREMENT PRIMARY KEY,
    Staff_name VARCHAR(100) NOT NULL,
    description   TEXT
);

--  TRAUNCATE

Truncate Table staff;



