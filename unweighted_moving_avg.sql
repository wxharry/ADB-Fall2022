use adb;

DROP TABLE IF EXISTS trade;

CREATE TABLE trade (
	stocksymbol VARCHAR(255) NOT NULL,
	time INT NOT NULL,
	quantity INT NOT NULL,
	price INT NOT NULL
);

set global local_infile = 1;

LOAD DATA LOCAL INFILE 'trade_dev.csv' 
INTO TABLE trade 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

!SELECT * from trade;

SELECT stocksymbol, time,
avg(price) OVER(PARTITION BY stocksymbol ORDER BY time ROWS 4 PRECEDING)
FROM trade;


