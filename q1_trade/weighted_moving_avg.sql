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

SELECT stocksymbol, time,
	sum(price * quantity) OVER w  / sum(quantity) OVER w as weighted_moving_avg
FROM trade
WINDOW w AS (PARTITION BY stocksymbol ORDER BY time ROWS 9 PRECEDING)
ORDER BY time;


