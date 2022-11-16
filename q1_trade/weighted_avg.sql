use adb;

DROP TABLE IF EXISTS trade;

CREATE TABLE trade (
	stocksymbol VARCHAR(255) NOT NULL,
	time INT NOT NULL,
	quantity INT NOT NULL,
	price INT NOT NULL
);

set global local_infile = 1;

LOAD DATA LOCAL INFILE 'trade.csv' 
INTO TABLE trade 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * from trade;

select stocksymbol, sum(quantity * price)/sum(quantity) as weighted_average_price from trade group by stocksymbol;

