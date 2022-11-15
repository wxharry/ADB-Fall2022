use adb;

DROP TABLE IF EXISTS friend;

CREATE TABLE friend (
	person1 int NOT NULL,
	person2 int NOT NULL
);

set global local_infile = 1;

LOAD DATA LOCAL INFILE 'friends.csv' 
INTO TABLE friend 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * from friend;

DROP TABLE IF EXISTS like_rel;

CREATE TABLE like_rel (
	person int NOT NULL,
	artist int NOT NULL
);

LOAD DATA LOCAL INFILE 'like.csv' 
INTO TABLE like_rel 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * from like_rel;

SELECT DISTINCT person1, person2, friend2_like.artist as artist
FROM (
	SELECT person1, person2, artist
	FROM friend
	LEFT JOIN like_rel
	ON friend.person2 = like_rel.person
) AS friend2_like
LEFT JOIN like_rel
ON friend2_like.person1 = like_rel.person and friend2_like.artist = like_rel.artist
WHERE like_rel.artist IS NULL
UNION
SELECT DISTINCT person2, person1, friend1_like.artist as artist
FROM (
	SELECT person1, person2, artist
	FROM friend
	LEFT JOIN like_rel
	ON friend.person1 = like_rel.person
) AS friend1_like
LEFT JOIN like_rel
ON friend1_like.person2 = like_rel.person and friend1_like.artist = like_rel.artist
WHERE like_rel.artist IS NULL;

-- 7308105 rows in set (21.19 sec)
