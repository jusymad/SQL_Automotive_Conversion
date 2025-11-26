-- 1. Tabela z wyświetleniami ogłoszeń (Góra lejka)
CREATE TABLE ad_clicks (
    click_id INT PRIMARY KEY,
    date DATE,
    source VARCHAR(50), -- np. Facebook, Google, Direct
    car_model VARCHAR(50)
);

-- 2. Tabela z potencjalnymi klientami (Środek lejka)
CREATE TABLE leads (
    lead_id INT PRIMARY KEY,
    click_id INT, -- Klucz obcy łączący z kliknięciem
    customer_name VARCHAR(100),
    lead_type VARCHAR(50), -- 'Jazda próbna', 'Pytanie o ofertę'
    contact_date DATE
);

-- 3. Tabela ze sprzedażą (Dół lejka)
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    lead_id INT, -- Klucz obcy łączący z leadem
    sale_amount DECIMAL(10, 2),
    sale_date DATE
);

-- DANE PRZYKŁADOWE (MOCK DATA)
-- Wrzucamy dane, żeby mieć co analizować
INSERT INTO ad_clicks VALUES 
(1, '2023-10-01', 'Facebook', 'Toyota Corolla'),
(2, '2023-10-01', 'Google', 'Toyota Corolla'),
(3, '2023-10-02', 'Facebook', 'Mazda 6'),
(4, '2023-10-02', 'Direct', 'Toyota Corolla'),
(5, '2023-10-03', 'Google', 'Mazda 6');

INSERT INTO leads VALUES 
(101, 1, 'Jan Kowalski', 'Jazda próbna', '2023-10-02'),
(102, 2, 'Anna Nowak', 'Pytanie o ofertę', '2023-10-02'),
(103, 5, 'Piotr Wiśniewski', 'Jazda próbna', '2023-10-04');

INSERT INTO sales VALUES 
(501, 101, 95000.00, '2023-10-10'); -- Jan kupił auto

SELECT * FROM ad_clicks;

SELECT 
    t1.car_model AS Model_Auta,
    COUNT(t1.click_id) AS Liczba_Klikniec,
    COUNT(t3.sale_id) AS Liczba_Sprzedazy,
    -- Poniżej magia matematyki: (Sprzedaż / Kliknięcia) * 100
    ROUND((COUNT(t3.sale_id) * 100.0) / COUNT(t1.click_id), 2) AS Konwersja_Procent
FROM ad_clicks t1
LEFT JOIN leads t2 ON t1.click_id = t2.click_id
LEFT JOIN sales t3 ON t2.lead_id = t3.lead_id
GROUP BY t1.car_model;