-- 1. Tabela z wyświetleniami ogłoszeń (góra lejka sprzedażowego)
CREATE TABLE ad_clicks (
    click_id INT PRIMARY KEY,
    date DATE,
    source VARCHAR(50), -- np. Facebook, Google, Direct
    car_model VARCHAR(50)
);

-- 2. Tabela z potencjalnymi klientami (środek lejka sprzedażowego)
CREATE TABLE leads (
    lead_id INT PRIMARY KEY,
    click_id INT, -- Klucz obcy łączący z kliknięciem
    customer_name VARCHAR(100),
    lead_type VARCHAR(50), -- 'Jazda próbna', 'Pytanie o ofertę'
    contact_date DATE
);

-- 3. Tabela ze sprzedażą (dół lejka sprzedażowego)
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    lead_id INT, -- Klucz obcy łączący z leadem
    sale_amount DECIMAL(10, 2),
    sale_date DATE
);

-- DANE PRZYKŁADOWE
-- Wstawienie danych, żeby było co analizować
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

-- Wyświetlenie tabeli z górą lejka
SELECT * FROM ad_clicks; 

-- Wersja 1
-- Łączenie tabel i przeliczenie konwersji
SELECT 
    t1.car_model AS model_auta,
    COUNT(t1.click_id) AS liczba_klikniec,
    COUNT(t3.sale_id) AS liczba_sprzedazy,
    -- Poniżej obliczenia arytmetyczne: (sprzedaż / kliknięcia) * 100
    ROUND((COUNT(t3.sale_id) * 100.0) / COUNT(t1.click_id), 2) AS konwersja_procent
FROM ad_clicks t1
LEFT JOIN leads t2 ON t1.click_id = t2.click_id
LEFT JOIN sales t3 ON t2.lead_id = t3.lead_id
GROUP BY t1.car_model;

-- Wersja 2; poprawiona, żeby uniknąć duplikatów
SELECT 
    t1.car_model AS Model_Auta,
    -- Użycie DISTINCT, aby policzyć unikalne kliknięcia
    -- (bo jedno kliknięcie mogło wygenerować kilka leadów, co sztucznie zawyżałoby wynik)
    COUNT(DISTINCT t1.click_id) AS Liczba_Unikalnych_Klikniec,
    
    -- Przeliczenie unikalnych transakcji sprzedaży
    COUNT(DISTINCT t3.sale_id) AS Liczba_Sprzedazy,
    
    -- Poprawiony wzór na konwersję
    ROUND((COUNT(DISTINCT t3.sale_id) * 100.0) / COUNT(DISTINCT t1.click_id), 2) AS Konwersja_Procent
FROM ad_clicks t1
LEFT JOIN leads t2 ON t1.click_id = t2.click_id
LEFT JOIN sales t3 ON t2.lead_id = t3.lead_id
GROUP BY t1.car_model;
