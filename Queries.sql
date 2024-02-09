-- 1. 
-- a) Title yalnız 'Owner' olanları seçmək
SELECT 
	*
FROM
	customers
WHERE	
	contact_title = 'Owner';

-- b) Yalnız Fransadan olanları seçmək
SELECT 
	*	
FROM 
	customers 
WHERE 
	country = 'France';

-- 2.
-- a) stokda olmayan produktları seçmək
SELECT
	*
FROM
	products
WHERE
	units_in_stock = 0;

-- b) unit_price 50-dən böyük olanalrı göstərmək
SELECT
	*
FROM
	products
WHERE
	unit_price >= 50;

-- 3. 
-- 1998-ci ildən sonra olan sifarişləri göstərmək
SELECT
	*
FROM
	orders
WHERE
	order_date > '1998-01-01';

-- 4. 
-- a) 'Owner' contact_title ve yalniz fransadan olan müştəriləri göstərmək
SELECT
	*
FROM
	customers
WHERE
	contact_title = 'Owner'
AND
	country = 'France';
	
-- b) Yalnız Meksika və ya Fransadan olan müştərilər
SELECT
	*
FROM	
	customers
WHERE
	country = 'France'
OR
	country = 'Mexico';

-- 5. 
-- a) quantity_per_unitde boxes sozu olan məhsullar
SELECT
	*
FROM
	products
WHERE
	quantity_per_unit LIKE '%boxes%';


-- 6.
-- a)Hansı məhsulların vahid qiyməti 50 ilə 100 arasındadır? 
SELECT
	*
FROM
	products
WHERE
	unit_price >= 50
AND
	unit_price <= 100;
-- b) Hansı məhsulların vahid qiyməti 50 ilə 100 arasındadır? (BETWEEN)?
SELECT 
	*
FROM
	products
WHERE
	unit_price BETWEEN 50 AND 100

-- 7.


-- a) 01/01/1997 və 31/12/1997 tarixləri arasında hansı sifarişlər edildi (istifadə et BETWEEN)
SELECT
	*
FROM
	orders
WHERE
	order_date BETWEEN '1997-01-01' AND '1997-12-31';

-- 8. 
-- a) Müştərilərin sayını öyrənin.
SELECT 
	COUNT(*) AS total_customers
FROM
	customers;


-- 9. 
-- a) Məhsul ehtiyatının cəmi nə qədərdir
SELECT
	SUM(units_in_stock) AS total_products_stock
FROM
	products;

	
-- 10. 
SELECT
	MIN(unit_price) AS minimum_price,
	MAX(unit_price) AS maximum_price,
	AVG(unit_price) AS average_price
FROM
	products;

-- 11. Ölkə üzrə müştərilərin ümumi sayını tap
SELECT
	country,
	COUNT(*) AS total_customers
FROM
	customers
GROUP BY
	country
ORDER BY
	2 DESC;

-- 13. Təchizatçıya düşən ehtiyatın ümumi miqdarını tap
SELECT
	S.company_name,
	SUM(P.units_in_stock) AS total_stock
FROM
	products P
INNER JOIN
	suppliers S
ON
	P.supplier_id = S.supplier_id
GROUP BY
	S.company_name
ORDER BY
	2 DESC;

-- 14. Bir təchizatçıya görə məhsulların orta qiymətini tap
SELECT
	S.company_name,
	AVG(P.unit_price) AS average_price
FROM
	products P
INNER JOIN
	suppliers S
ON
	P.supplier_id = S.supplier_id
GROUP BY
	S.company_name
ORDER BY
	2 DESC;

-- 15. Yalnız contact_title = 'Owner' olan müştəriləri nəzərə alaraq, ölkə üzrə müştərilərin ümumi sayını tap 
SELECT
	country,
	COUNT(*) AS total_customers
FROM
	customers
WHERE
	contact_title = 'Owner'
GROUP BY
	country
ORDER BY
	2 DESC;


	-- 16. Yalnız 10-dan çox müştərisi olan ölkələri nəzərə alaraq, ölkə üzrə müştərilərin ümumi sayını tap
SELECT
	country,
	COUNT(*) AS total_customers
FROM
	customers
GROUP BY
	country
HAVING 
	COUNT(*) > 10
ORDER BY
	2 DESC;

-- 17. Aşağıdakı sahələri qaytaran sorğunu yerinə yetirin: product_name, unit_price, and category_name.
SELECT
	P.product_name,
	P.unit_price,
	C.category_name
FROM
	products P
INNER JOIN 
	categories C
ON 
	P.category_id = C.category_id;


-- 19. Məhsul başına sifarişlərin ümumi sayını qaytaran sorğu. Nəticəni azalan ardıcıllıqla sıralayın.
SELECT
	P.product_name,
	SUM(O.quantity) AS quantity_ordered
FROM
	products P
INNER JOIN
	order_details O
ON 
	O.product_id = P.product_id 
GROUP BY
	P.product_name
ORDER BY
	2 DESC;

-- 20. Məhsul başına sifarişlərin ümumi sayını qaytaran sorğu. Nəticəni azalan ardıcıllıqla sıralayın. 
--Yalnız lüks məhsulları nəzərdən keçirin (vahid qiyməti 80 dollardan yuxarı olan).
SELECT
	P.product_name,
	SUM(O.quantity) AS quantity_ordered
FROM
	products P
INNER JOIN
	order_details O
ON
	O.product_id = P.product_id
WHERE
	P.unit_price >= 80
GROUP BY
	P.product_name
ORDER BY
	2 DESC;

-- 20. 
-- a)  view yaradin product_id,  product_name, unit_price
CREATE OR REPLACE VIEW vwproducts AS
	SELECT
		product_id, 
		product_name, 
		unit_price
	FROM
		products;

SELECT 
	*
FROM
	vwproducts;


-- b) adını dəyişin
ALTER VIEW vwproducts RENAME TO vw_prod;

-- c) silin viewi.
DROP VIEW vw_prod;

-- 21. 
-- a) CEILING istifadə edərək hər bir məhsul kateqoriyasının orta vahid qiymətini əldə edin
SELECT
	C.category_name,
	CEILING(AVG(P.unit_price)) AS average_price
FROM
	products P
INNER JOIN
	categories C
ON
	P.category_id = C.category_id
GROUP BY
	C.category_name
ORDER BY
	2 DESC;

-- b) FLOOR istifadə edərək hər bir məhsul kateqoriyasının orta vahid qiymətini əldə edin
SELECT
	C.category_name,
	FLOOR(AVG(unit_price)) AS average_price	
FROM
	products P
INNER JOIN
	categories C
ON
	P.category_id = C.category_id
GROUP BY
	C.category_name 
ORDER BY
	2 DESC;

-- c) ROUND istifadə edərək hər bir məhsul kateqoriyasının orta vahid qiymətini əldə edin
SELECT
	C.category_name,
	ROUND(CAST(AVG(P.unit_price) AS NUMERIC), 3) AS average_price
FROM
	products P
INNER JOIN 
	categories C
ON
	P.category_id = C.category_id
GROUP BY
	C.category_name
ORDER BY
	2 DESC;

-- d) TRUNC istifadə edərək hər bir məhsul kateqoriyasının orta vahid qiymətini əldə edin
SELECT
	C.category_name,
	TRUNC(CAST(AVG(P.unit_price) AS NUMERIC), 3)
FROM
	products P
INNER JOIN
	categories C
ON
	C.category_id = P.category_id
GROUP BY
	C.category_name
ORDER BY
	2 DESC;

-- 22. 
-- a) Bütün hərfləri böyüdün
SELECT
	UPPER(product_name) AS product_name
FROM
	products;
	
-- b) bütün hərfləri kiçiltin
SELECT
	LOWER(product_name)
FROM
	products;

-- c) Ancaq baş hərfkəri böyüdün
SELECT
	INITCAP(product_name)
FROM
	products;

-- d) hər bir adın uzunluğunu tapın
SELECT
	product_name,
	LENGTH(product_name) As number_characters
FROM
	products;

-- e)  'Owner'  'CEO' ilə dəyişin
SELECT
	contact_name,
	contact_title AS old_contact_title,
	REPLACE(contact_title, 'Owner', 'CEO') AS new_contact_title
FROM
	customers;

-- 23.
-- a) Müştərilərin şirkət adının ilk 3 simvolu ilə birlikdə seçin (LEFT)
SELECT
	company_name,
	LEFT(customer_id, 3) AS short_customer_id
FROM
	customers;
	
-- b) Müştərilərin şirkət adının ilk 3 simvolu ilə birlikdə seçin (SUBSTRING)
SELECT
	company_name,
	SUBSTRING(customer_id, 1, 3) AS short_customer_id
FROM
	customers;
	
	
-- 24.
-- a)Tərkibində - olan müştərilərin şirkət adlarını yerləri ilə birlikdə göstərin
SELECT
	company_name,
	STRPOS(company_name, '-') AS "position"
	
FROM
	customers
WHERE
	company_name LIKE '%-%';

-- b) Tərkibində - olan müştərilərin şirkət adlarını özündən əvvəlki simvollarla birlikdə göstərin
SELECT
	company_name,
	SUBSTRING(company_name, 1, STRPOS(company_name, '-') -1)
FROM
	customers
WHERE
	company_name LIKE '%-%';


-- 25. 
-- a) İşçilərin adlarını  doğum tarixləri və yaşları ilə birlikdə seçin.
SELECT
	first_name || ' ' || last_name AS employee_name,
	birth_date,
	AGE(birth_date) AS employee_age
FROM
	employees
	
-- b) Müştərilərin adlarını  gününü, ayı və doğum ilini seçin.
SELECT
	first_name || ' ' || last_name AS employee_name,
	birth_date,
	DATE_PART('DAY', birth_date) AS "day",
	DATE_PART('MONTH', birth_date) AS "month",
	DATE_PART('YEAR', birth_date) AS "year"
FROM
	employees;
	
-- 26. Identify products with a price above the average.
SELECT
	product_name,
	unit_price
FROM
	products
WHERE
	unit_price > (SELECT
				      AVG(unit_price)
				  FROM
				      products);
	
-- 27. Satılmış orta miqdardan yuxarı satılan sifarişləri müəyyənləşdirin.
SELECT
	D.order_id,
	O.order_date,
	C.contact_name,
	SUM(D.quantity) AS quantity
FROM
	order_details D
INNER JOIN
	orders O
ON
	O.order_id = D.order_id
INNER JOIN
	customers C
ON
	O.customer_id = C.customer_id	
GROUP BY
	D.order_id,
	O.order_date,
	C.contact_name
HAVING
	SUM(quantity) > (SELECT
					     AVG(total_quantity)
					 FROM (SELECT
						       order_id,
						       sum(quantity) AS total_quantity
					       FROM
						       order_details
						   GROUP BY
						       order_id) T);

-- 28. Müştərilərin orta sayını iş adlarına uyğun olaraq müəyyənləşdirin.
SELECT
	AVG(total_customers) customers_average
FROM
	(SELECT
	 	 contact_title,
	 	 COUNT(*) total_customers
	 FROM
	 	 customers
	 GROUP BY
	     contact_title
	 ORDER BY
	 	 2 DESC) t;

-- 29  Məhsullar cədvəlində məhsulların ümumi ortalamasını göstərən bir sütun əlavə edin.
SELECT
	product_name,
	unit_price,
	(SELECT
	     TRUNC(CAST(AVG(unit_price) AS NUMERIC), 2) AS average_price
	 FROM
	     products)
FROM
	products;
	
-- 30. Sadə bir satış  kalkulyator dəyişənlərdən 'quantity', 'price', 'sales_value', and 'salesperson'.
DO $$
DECLARE
	quantity NUMERIC (3, 0) := 100;
	price NUMERIC (5, 2) := 200.50;
	salesperson VARCHAR (200):= 'Otto';
	sales_value NUMERIC (7, 2);
BEGIN
	sales_value = price * quantity;
	RAISE NOTICE 'The salesperson % sold a total of $%', salesperson, price;
END $$;

-- 31. Neçə məhsulun qiyməti orta qiymətdən yuxarıdır?
DO $$
DECLARE
	average_price NUMERIC (4, 2);
	products_over_average NUMERIC(2, 0);
BEGIN
	average_price := (SELECT 
	                      AVG(unit_price)
					  FROM
						  products);
	products_over_average := (SELECT 
							      COUNT(*)
							  FROM
							      products
							  WHERE
							      unit_price > average_price);
	RAISE NOTICE 'There is a total of % products with a price above the average', products_over_average;
								
END $$;

-- 32. Məhsul ehtiyatını təhlil edən funksiya yaradın. Bu funksiya istifadəçi tərəfindən müəyyən edilmiş minimum və maksimum ehtiyat arasında ümumi ehtiyata malik məhsulların ümumi sayını qaytarmalıdır.
CREATE OR REPLACE FUNCTION calculateStockInRange(min_stock INTEGER, max_stock INTEGER)
	RETURNS NUMERIC(3, 0)
	LANGUAGE PLPGSQL
AS $$
DECLARE
	stock_count NUMERIC(3, 0);
BEGIN
	stock_count = (SELECT
					   COUNT(*)
				   FROM
					   products
				   WHERE
					   units_in_stock BETWEEN min_stock AND max_stock);
	RETURN stock_count;
END $$;

-- a) 
SELECT calculateStockInRange(10, 50) AS total_stock;

-- b) 
SELECT calculateStockInRange(min_stock := 20, max_stock := 50) AS total_stock;

-- c) 
SELECT calculateStockInRange(30, max_stock := 50) AS total_stock;

-- d) 
DROP FUNCTION IF EXISTS calculateStockInRange;

-- 33. İstifadəçi tərəfindən müəyyən bir iş adı ilə müştərilərin siyahısını qaytaran bir funksiya yaradın.
CREATE OR REPLACE FUNCTION RetrieveOwners(title VARCHAR)
	RETURNS TABLE (customer_id customers.customer_id%TYPE,
				   contact_name customers.contact_name%TYPE,
				   phone customers.phone%TYPE,
				   contact_title customers.contact_title%TYPE)
	LANGUAGE PLPGSQL
AS $$
BEGIN
	RETURN QUERY SELECT
				     C.customer_id,
				     C.contact_name,
				     C.phone,
				     C.contact_title
				 FROM
				     customers C
				 WHERE
				     C.contact_title = title;
END $$;

-- a) 
SELECT 
	*
FROM
	RetrieveOwners('Owner');
	
-- b) 
SELECT 
	*
FROM 
	RetrieveOwners(title := 'Sales Representative');

-- d) 
DROP FUNCTION IF EXISTS RetrieveOwners;

