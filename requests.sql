--COPY languages FROM 'C:\SQL\languages_pop\languages.csv' DELIMITER ';' CSV HEADER ENCODING 'windows-1251';

--1.

/*SELECT l.language_name, COUNT(v.id) AS vacancy_count
FROM languages l
JOIN vacancies v ON (v.vac_name ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
    OR (v.snippet_req ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
GROUP BY l.language_name
ORDER BY vacancy_count DESC;*/

--2.

/*WITH VacancyAverages AS (SELECT v.id, l.language_name, l.difficulty, (COALESCE(v.salary_from, v.salary_to) + COALESCE(v.salary_to, v.salary_from)) / 2 AS avg_every_salary
FROM vacancies v
JOIN languages L ON (v.vac_name ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
    OR (v.snippet_req ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
WHERE v.currency = 'RUR')

SELECT language_name, difficulty, ROUND(AVG(avg_every_salary)) AS salary_avg
FROM VacancyAverages
GROUP BY language_name, difficulty
ORDER BY salary_avg DESC, difficulty;*/

--3.

/*SELECT l.language_name, v.experience_name, COUNT(v.id) AS vacancy_count
FROM vacancies v
JOIN languages l ON (v.vac_name ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
OR (v.snippet_req ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
GROUP BY l.language_name, v.experience_name
ORDER BY vacancy_count DESC, l.language_name ;*/

--4.

/*SELECT language_name, repos, stars
FROM repos_counter
ORDER BY repos DESC;*/

--5.

/*SELECT l.language_name, COUNT(f.id) AS topics_count
FROM languages l
JOIN forum_discussions f ON (f.tags ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)    
GROUP BY l.language_name
ORDER BY topics_count DESC;*/

--6.

/*SELECT l.language_name, EXTRACT (YEAR FROM creation_date) AS creation_year, COUNT(*) AS topics_count
FROM languages l
JOIN forum_discussions f ON (f.tags ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' WHEN l.language_name = 'C' THEN format('(^|\y)%s($|\y)', 'C') ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)    
WHERE EXTRACT (YEAR FROM creation_date) < 2024
GROUP BY l.language_name, creation_year
ORDER BY l.language_name, creation_year DESC;*/

--7.

/*SELECT l.language_name, l.difficulty, CAST(SUM(f.answer_count) AS FLOAT)/COUNT(f.id) AS avg_answers_for_topic
FROM languages l
JOIN forum_discussions f ON (f.tags ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)    
GROUP BY l.language_name, l.difficulty
ORDER BY avg_answers_for_topic DESC;*/

--8.

/*SELECT language_name,date,trend_value
FROM trends
ORDER BY language_name, date;*/


--9.

/*SELECT language_name,difficulty,supported_ide,speed,memory
FROM languages;*/

--10.

/*WITH VacancyCounts AS (SELECT l.language_name, COUNT(v.id) AS vacancy_count FROM languages l
 	JOIN vacancies v ON (v.vac_name ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
    OR (v.snippet_req ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
    GROUP BY l.language_name),
RepoCounts AS (SELECT language_name,repos AS repo_count FROM repos_counter),
ForumCounts AS (SELECT l.language_name, COUNT(f.id) AS forum_count FROM languages l
    JOIN forum_discussions f ON (f.tags ~* CASE WHEN l.language_name = 'C++' THEN 'C\+\+' WHEN l.language_name = 'C#' THEN 'C\#' ELSE format('(^|\y)%s($|\y)', regexp_replace(l.language_name, '([$.*+?()[\]{}\|\^])', '\\\\\1', 'g')) END)
    GROUP BY l.language_name),
TrendSums AS (SELECT language_name, SUM(trend_value) AS total_trend_value FROM trends GROUP BY language_name),
RankedData AS (SELECT vc.language_name,vc.vacancy_count,rc.repo_count,fc.forum_count,ts.total_trend_value,
    RANK() OVER (ORDER BY vc.vacancy_count DESC) AS vacancy_rank, RANK() OVER (ORDER BY rc.repo_count DESC) AS repo_rank,
    RANK() OVER (ORDER BY fc.forum_count DESC) AS forum_rank, RANK() OVER (ORDER BY ts.total_trend_value DESC) AS trend_rank
    FROM VacancyCounts vc
    JOIN RepoCounts rc ON vc.language_name = rc.language_name
	JOIN ForumCounts fc ON vc.language_name = fc.language_name
    JOIN TrendSums ts ON vc.language_name = ts.language_name),
ScoredData AS (SELECT language_name,vacancy_count,repo_count,forum_count,total_trend_value,
	CASE WHEN vacancy_rank <= 15 THEN 16 - vacancy_rank ELSE 0 END +
    CASE WHEN repo_rank <= 15 THEN 16 - repo_rank ELSE 0 END +
	CASE WHEN forum_rank <= 15 THEN 16 - forum_rank ELSE 0 END +
	CASE WHEN trend_rank <= 15 THEN 16 - trend_rank ELSE 0 END AS total_score
    FROM RankedData)
SELECT language_name, total_score
FROM ScoredData
ORDER BY total_score DESC;*/





--0. P.S. Если бы было достаточно данных
/*SELECT
    language_name,
    EXTRACT(YEAR FROM pushed_at) AS push_year,
    COUNT(*) AS repo_count
FROM repos_detailed
WHERE language_name IS NOT NULL
GROUP BY language_name, push_year
ORDER BY language_name, push_year;*/





















