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

SELECT person1, person2, friend_like.artist
FROM (
	SELECT person1, person2, artist
	FROM (
		SELECT *
		FROM friend as f1
		WHERE EXISTS (
			SELECT *
			FROM friend as f2
			WHERE f1.person1 = f2.person2 and f1.person2 = f2.person1
		)
	) as mutual_friend
	LEFT JOIN like_rel
	ON mutual_friend.person2 = like_rel.person
) AS friend_like
LEFT JOIN like_rel
ON friend_like.person1 = like_rel.person and friend_like.artist = like_rel.artist
WHERE like_rel.artist IS NULL
ORDER BY person1 ASC, person2 ASC, friend_like.artist ASC;
