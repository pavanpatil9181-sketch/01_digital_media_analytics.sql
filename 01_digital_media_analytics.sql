USE digital_media_db;

WITH TopRatedContent AS (
    SELECT 
        t.type,
        t.title_name,
        ROUND(AVG(r.user_score), 2) AS avg_score,
        DENSE_RANK() OVER (
            PARTITION BY t.type 
            ORDER BY AVG(r.user_score) DESC
        ) AS type_rank
    FROM titles t
    INNER JOIN user_ratings r ON t.title_id = r.title_id
    GROUP BY t.type, t.title_name
)
SELECT 
    type,
    title_name,
    avg_score,
    type_rank
FROM TopRatedContent
WHERE type_rank = 1;