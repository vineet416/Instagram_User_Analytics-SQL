# A) Marketing Analysis:
use ig_clone;

# 1. Loyal User Reward: The marketing team wants to reward the most loyal users, i.e., those who have been using the platform from the longest time.
# Task: Identify the five oldest users on Instagram from the provided dataset.

SELECT *
	FROM users
ORDER BY 
	created_at ASC
LIMIT 5;

# 2. Inactive User Engagement: The team wants to encourage inactive users to start posting by sending them promotional emails.
# Task: Identify users who have never posted a single photo on Instagram.
SELECT 
	users.id, 
    users.username, photos.image_url
FROM 
	photos
RIGHT JOIN 
	users
ON 
	users.id = photos.user_id
WHERE 
	photos.user_id IS NULL;


# 4. Contest Winner Declaration: The team has organized a contest where the user with the most likes on a single photo wins.
# Task: Determine the winner of the contest and provide their details to the team.

SELECT 
    photos.user_id AS user_id,
    users.username,
    likes.photo_id AS photo_id,
    photos.image_url,
    COUNT(likes.user_id) AS total_likes
FROM
    likes
        INNER JOIN
    photos ON likes.photo_id = photos.id
        INNER JOIN
    users ON photos.user_id = users.id
GROUP BY likes.photo_id
ORDER BY total_likes DESC
LIMIT 1;


# 5. Hashtag Research: A partner brand wants to know the most popular hashtags to use in their posts to reach the most people.
# Task: Identify and suggest the top five most commonly used hashtags on the platform.

SELECT 
    tags.tag_name,
    photo_tags.tag_id,
    COUNT(photo_tags.photo_id) AS tag_count
FROM
    tags
        INNER JOIN
    photo_tags ON photo_tags.tag_id = tags.id
GROUP BY photo_tags.tag_id
ORDER BY tag_count DESC
LIMIT 5;


# 6. Top 4 most commonly used hashtags are (smile, beach, party, fun) And the are three hashtags at 5th place (food, lol, concert)
# Ad Campaign Launch: The team wants to know the best day of the week to launch ads.
# Task: Determine the day of the week when most users register on Instagram. Provide Insights on when to schedule an ad campaign.

SELECT 
	DAYNAME(created_at) AS day , COUNT(id) AS active_users_count
FROM 
	users
GROUP BY 
	day
LIMIT 1;


# B) Investor Metrics:

# 1. User Engagement: Investors want to know if users are still active and posting on Instagram or if the are making fewer posts.
# Task: Calculate the average number of posts per user on Instagram. Also, provide the total number of photos on Instagram divided by the total number of users.

SELECT
	(SELECT COUNT(photos.id) FROM photos) AS total_photos,
	(SELECT COUNT(users.id) FROM users) AS total_users,
	(SELECT COUNT(photos.id) FROM photos) / (SELECT COUNT(users.id) FROM users) AS avg_post_per_user;


# 2. Bots & Fake Accounts: Investors want to know if the platform is crowded with fake and dummy accounts.
# Task: Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user.
SELECT * FROM likes;
SELECT * FROM users;

SELECT 
	user_id , username, photos_liked
FROM 
	users
INNER JOIN (
	SELECT 
		likes.user_id, COUNT(likes.photo_id) AS photos_liked
	FROM 
		likes
	LEFT JOIN 
		photos ON photos.id = likes.photo_id
	GROUP BY 
		likes.user_id
	HAVING 
		photos_liked = MAX(photos.id)) AS bots
ON bots.user_id = users.id;