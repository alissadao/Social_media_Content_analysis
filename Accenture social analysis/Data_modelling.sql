---- Data Cleaning ---
-- TABLE 1: 
 SELECT * 
 FROM Content

 --- TASK 1: REMOVING UNRELATED COLUMNS
 ALTER TABLE Content
 DROP COLUMN column1

 ALTER TABLE Content
 DROP COLUMN User_ID

 SELECT * 
 FROM Content

 -- TASK 2: REMOVING ROWS WITH MISSING VALUES

 SELECT * 
 FROM Content
 WHERE Content_ID IS NULL

SELECT * 
FROM Content
WHERE Category IS NULL

SELECT * 
FROM Content
WHERE URL IS NULL

DELETE FROM Content
WHERE URL IS NULL

-- CHECK AGAIN

SELECT *  
FROM Content
WHERE URL IS NULL

-- NO NULL VALUES 

-- TASK 2: CHANGING THE DATA TYPE 

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Content'

ALTER TABLE Content
ALTER COLUMN Content_ID uniqueidentifier

-- CHECK AGAIN:
 
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Content'

-- ADDITIONAL TASKS: 
-- CHECK SPELLING

SELECT DISTINCT Category
FROM Content

-- RENAME COLUMN: From Type to Content Type

--- TABLE 2: 

SELECT * 
FROM Reactions

-- TASK 1: REMOVE UNRELATED COLUMN: 

ALTER TABLE Reactions 
DROP COLUMN column1

ALTER TABLE Reactions 
DROP COLUMN User_ID

-- TASK 2: DELETE ROWS WITH MISSING VALUE 

-- identify missing value: 

SELECT * 
FROM Reactions
WHERE Content_ID IS NULL

SELECT * 
FROM Reactions
WHERE Datetime IS NULL

-- NO NULL VALUES 

-- TASK 3: CHANGING THE DATA TYPE 

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Reactions'

ALTER TABLE Reactions
ALTER COLUMN Content_ID uniqueidentifier

-- check again

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Reactions'

-- TABLE 3:

SELECT * 
FROM ReactionTypes

-- TASK 1: REMOVE UNRELATED COLUMN: 
ALTER TABLE ReactionTypes
DROP COLUMN column1

-- TASK 2: REMOVE ROWS WITH MISSING VALUES
SELECT * 
FROM ReactionTypes

-- NO NULL VALUES

-- TASK 3: CHANGING THE DATA TYPE
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ReactionTypes'

ALTER TABLE ReactionTypes
ALTER COLUMN Score int

-- check again: 
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ReactionTypes'

WITH clean_data AS
(SELECT Content.Content_ID, Content.Content_type, Content.Category, Content.URL, Reactions.ReactionType, Reactions.Datetime, ReactionTypes.Sentiment, ReactionTypes.Score
FROM Content
INNER JOIN 
Reactions
ON Content.Content_ID = Reactions.Content_ID
INNER JOIN 
ReactionTypes
ON Reactions.ReactionType = ReactionTypes.ReactionType)

SELECT * 
INTO data_clean
FROM clean_data

SELECT * 
FROM data_clean

UPDATE data_clean
SET Content_type = LOWER(Content_type)

UPDATE data_clean
SET Category = LOWER(Category)

UPDATE data_clean
SET ReactionType = LOWER(ReactionType)

UPDATE data_clean
SET Sentiment = LOWER(Sentiment)

-- ADD UP THE FINAL SCORE FOR EACH CATEGORY

-- FIRST, LET'S SEE HOW MANY CATEGORY

SELECT DISTINCT Category
FROM data_clean

--animals
--education
--culture
--science
--studying
--veganism
--public speaking
--soccer
--food
--dogs
--tennis
--healthy eating
--cooking
--fitness
--travel
--technology

-- ADD UP THE SCORE: 
SELECT TOP 5 Category, SUM(Score) AS TotalScore
FROM data_clean
GROUP BY Category
ORDER BY SUM(Score) DESC 
--Category	TotalScore
--travel	53935
--science	53657
--healthy eating	52745
--animals	52443
--cooking	49681

-- TOP 5 REACTIONS OF THESE TOP 5 CATEGORIES:
SELECT TOP 5 Category, ReactionType, COUNT(ReactionType) AS num_of_reaction
FROM data_clean
GROUP BY Category, ReactionType
ORDER BY SUM(Score) DESC 
--Category	ReactionType	num_of_reaction
--cooking	super love	91
--travel	want	94
--science	adore	91
--animals	super love	87
--science	want	93

---What was the month with the most posts?

SELECT TOP 1 MONTH(Datetime) AS month, COUNT(Content_ID) AS num_of_content
FROM data_clean
GROUP BY MONTH(Datetime)
ORDER BY COUNT(Content_ID) DESC 
--month	num_of_content
--8	1612


---How many unique categories are there?

SELECT COUNT(DISTINCT Category) AS total_category
FROM data_clean

--total_category
--16