# 🎬 Digital Media & Streaming Analytics (SQL Portfolio Project)

Hey! This is a SQL portfolio project where I built and queried a relational database (`digital_media_db`) for a streaming platform. The goal was to practice everything from basic queries to advanced analytics like JOINs, window functions, and CTEs to find out what content performs best.

---

## 🗄️ Database Structure
The database consists of a few interconnected master and mapping tables:
* **`titles`**: Basic info about movies and TV shows (ID, name, type, release year).
* **`genres` & `title_genres`**: Categories and their mapping.
* **`actors` & `title_cast`**: Cast details linked to specific titles.
* **`user_ratings`**: User reviews and score breakdowns.

---

## 🛠️ What I Practiced & Covered
I broke this project down from basic to advanced levels:
1. **Basics:** Filtering data (`WHERE`, `LIKE`, `DISTINCT`, `ORDER BY`).
2. **Intermediate:** Combining multiple tables using 2-table and 3-table `INNER JOIN`s, grouping data (`GROUP BY`), and adding conditional tags using `CASE WHEN` (like labelling titles as *Super Hit* or *Hit* based on ratings).
3. **Advanced:** Using Window Functions (`DENSE_RANK()` with `PARTITION BY`) to rank movies and TV shows separately, and Common Table Expressions (`WITH` clause / CTEs) to pull out only the top-ranked content.

---

## 💡 Quick Insights from the Data
* **Top Content:** *Dark Horizons* (TV Show) and *Stranger Chronicles* (Movie) came out on top with the highest average user scores (8.75 to 9.00).
* **Popular Genres:** Thriller and Sci-Fi make up a large chunk of the catalog.
* **Main Cast:** Actors like Cillian Murphy and Pedro Pascal appear across multiple top-rated titles.

---

## 💻 Sample Advanced Query (CTE & Window Function)
Here is a query I wrote to grab just the #1 top-rated movie and TV show using a CTE:

```sql
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