SET GLOBAL local_infile=1;

DROP TABLE IF EXISTS trade_fractal;
CREATE TABLE trade_fractal (
    stocksymbol VARCHAR(255) NOT NULL, 
    time INT, 
    quantity INT, 
    price INT
);


LOAD DATA LOCAL INFILE "trade_fractal.csv"
INTO TABLE trade_fractal
FIELDS TERMINATED BY ","
IGNORE 1 LINES;

DROP TABLE IF EXISTS trade_uniform;
CREATE TABLE trade_uniform (
    stocksymbol VARCHAR(255) NOT NULL, 
    time INT, 
    quantity INT, 
    price INT
);

LOAD DATA LOCAL INFILE "trade_uniform.csv"
INTO TABLE trade_uniform
FIELDS TERMINATED BY ","
IGNORE 1 LINES;

/* Use Distinct */
SELECT DISTINCT stocksymbol, time, quantity, price
FROM trade_fractal;

/* Eliminate unneeded Distinct */
SELECT stocksymbol, time, quantity, price
FROM trade_fractal;


/* Without Covering Indexes */
SELECT stocksymbol
FROM trade_fractal
WHERE price > 100;

CREATE INDEX price_stocksymbol ON trade (price, stocksymbol);

/* Use Covering Indexes */
SELECT stocksymbol
FROM trade_fractal
WHERE price > 100;

