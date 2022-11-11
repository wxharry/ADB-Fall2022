use adb;

DROP TABLE IF EXISTS friend;

CREATE TABLE friend (
	person1 VARCHAR(10) NOT NULL,
	person2 VARCHAR(10) NOT NULL
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
	person VARCHAR(10) NOT NULL,
	artist VARCHAR(10) NOT NULL
);

LOAD DATA LOCAL INFILE 'like.csv' 
INTO TABLE like_rel 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- SELECT * from like_rel;

SELECT friend_like.person1, friend_like.person2, friend_like.artist
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
LEFT JOIN (
	SELECT person1, person2, artist
	FROM (
		SELECT *
		FROM friend as f1
		WHERE EXISTS (
			SELECT *
			FROM friend as f2
			WHERE f1.person1 = f2.person2 and f1.person2 = f2.person1
		)
	) as mutual_friend1
	LEFT JOIN like_rel
	ON mutual_friend1.person1 = like_rel.person
)AS user_like
ON friend_like.person1 = user_like.person1 and friend_like.person2 = user_like.person2 and friend_like.artist = user_like.artist
WHERE user_like.artist IS NULL;


