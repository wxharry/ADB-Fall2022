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

SELECT * from trade;

SELECT stocksymbol, max(price - minium) as max_profit
FROM (
SELECT stocksymbol, time,
	price,
	min(price) OVER w as minium
FROM trade
WINDOW w AS (PARTITION BY stocksymbol ORDER BY time ROWS UNBOUNDED PRECEDING)
ORDER BY time) as x
GROUP BY stocksymbol
ORDER BY stocksymbol;


