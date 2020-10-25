SELECT        movie_id, revenue, budget, original_language, popularity, release_date, CASE WHEN (YEAR(a.release_date) > 2017) THEN (YEAR(a.release_date) - 100) ELSE (YEAR(a.release_date)) END AS release_year, 
                         MONTH(release_date) AS release_month, (CASE WHEN month(release_date) IN (3, 4, 5) THEN 'spring' WHEN month(release_date) IN (6, 7, 8) THEN 'summer' WHEN month(release_date) IN (9, 10, 11) 
                         THEN 'fall' ELSE 'winter' END) AS seasonality, (CASE WHEN [runtime] <= 60 THEN 'short' WHEN [runtime] <= 120 THEN 'med' ELSE 'long' END) AS runtime_cat, status,
                             (SELECT        COUNT(1) AS Expr1
                               FROM            dbo.movie_keywords
                               WHERE        (movie_id = a.movie_id)) AS keyword_cnt,
                             (SELECT        COUNT(1) AS Expr1
                               FROM            dbo.movie_collection
                               WHERE        (movie_id = a.movie_id)) AS sw_collection,
                             (SELECT        COUNT(DISTINCT producor_id) AS Expr1
                               FROM            dbo.movie_producer_date_revenue
                               WHERE        (movie_id = a.movie_id)
                               GROUP BY movie_id) AS producers_cnt,
                             (SELECT        COUNT(1) AS Expr1
                               FROM            dbo.movie_countries
                               WHERE        (movie_id = a.movie_id)) AS countries_cnt, CASE WHEN
                             ((SELECT        iso_639_1
                                 FROM            movie_languages
                                 WHERE        movie_id = a.movie_id AND iso_639_1 = 'en') = 'en') THEN (1) ELSE (0) END AS lang_US, CASE WHEN
                             ((SELECT        iso_639_1
                                 FROM            movie_languages
                                 WHERE        movie_id = a.movie_id AND iso_639_1 = 'fr') = 'fr') THEN (1) ELSE (0) END AS lang_FR, CASE WHEN
                             ((SELECT        iso_639_1
                                 FROM            movie_languages
                                 WHERE        movie_id = a.movie_id AND iso_639_1 = 'ru') = 'ru') THEN (1) ELSE (0) END AS lang_RU, CASE WHEN
                             ((SELECT        iso_639_1
                                 FROM            movie_languages
                                 WHERE        movie_id = a.movie_id AND iso_639_1 = 'es') = 'es') THEN (1) ELSE (0) END AS lang_ES, CASE WHEN
                             ((SELECT        iso_639_1
                                 FROM            movie_languages
                                 WHERE        movie_id = a.movie_id AND iso_639_1 = 'ja') = 'ja') THEN (1) ELSE (0) END AS lang_JA,
                             (SELECT        COUNT(1) AS Expr1
                               FROM            dbo.movie_keywords AS movie_keywords_1
                               WHERE        (movie_id = a.movie_id)) AS keywords_cnt,
                             (SELECT DISTINCT COUNT(1) AS Expr1
                               FROM            dbo.movie_actor_date_revenue
                               WHERE        (release_date < a.release_date) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_17
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 0)))) AS actor0_movies_cnt,
                             (SELECT DISTINCT COUNT(1) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_16
                               WHERE        (release_date BETWEEN DATEADD(YEAR, - 5, a.release_date) AND DATEADD(DAY, - 1, a.release_date)) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_15
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 0)))) AS actor0_movies_5y_cnt,
                             (SELECT DISTINCT COUNT(1) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_14
                               WHERE        (release_date < a.release_date) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_13
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 1)))) AS actor1_movies_cnt,
                             (SELECT DISTINCT COUNT(1) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_12
                               WHERE        (release_date BETWEEN DATEADD(YEAR, - 5, a.release_date) AND DATEADD(DAY, - 1, a.release_date)) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_11
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 1)))) AS actor1_movies_5y_cnt,
                             (SELECT DISTINCT COUNT(1) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_10
                               WHERE        (release_date < a.release_date) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_9
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 2)))) AS actor2_movies_cnt,
                             (SELECT DISTINCT COUNT(1) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_8
                               WHERE        (release_date BETWEEN DATEADD(YEAR, - 5, a.release_date) AND DATEADD(DAY, - 1, a.release_date)) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_7
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 2)))) AS actor2_movies_5y_cnt,
                             (SELECT        MAX(CASE WHEN (e.gender = 1) THEN (1) ELSE (0) END) AS Expr1
                               FROM            dbo.movie_cast AS d LEFT OUTER JOIN
                                                         dbo.actors_dim AS e ON d.actor_id = e.actor_id
                               WHERE        (d.movie_id = a.movie_id) AND (d.[order] = 0)) AS sw_female_actor0,
                             (SELECT        MAX(CASE WHEN (e.gender = 1) THEN (1) ELSE (0) END) AS Expr1
                               FROM            dbo.movie_cast AS d LEFT OUTER JOIN
                                                         dbo.actors_dim AS e ON d.actor_id = e.actor_id
                               WHERE        (d.movie_id = a.movie_id) AND (d.[order] = 1)) AS sw_female_actor1,
                             (SELECT        MAX(CASE WHEN (e.gender = 1) THEN (1) ELSE (0) END) AS Expr1
                               FROM            dbo.movie_cast AS d LEFT OUTER JOIN
                                                         dbo.actors_dim AS e ON d.actor_id = e.actor_id
                               WHERE        (d.movie_id = a.movie_id) AND (d.[order] = 2)) AS sw_female_actor2,
                             (SELECT        MAX(CASE WHEN (e.gender = 2) THEN (1) ELSE (0) END) AS Expr1
                               FROM            dbo.movie_cast AS d LEFT OUTER JOIN
                                                         dbo.actors_dim AS e ON d.actor_id = e.actor_id
                               WHERE        (d.movie_id = a.movie_id) AND (d.[order] = 0)) AS sw_male_actor0,
                             (SELECT        MAX(CASE WHEN (e.gender = 2) THEN (1) ELSE (0) END) AS Expr1
                               FROM            dbo.movie_cast AS d LEFT OUTER JOIN
                                                         dbo.actors_dim AS e ON d.actor_id = e.actor_id
                               WHERE        (d.movie_id = a.movie_id) AND (d.[order] = 1)) AS sw_male_actor1,
                             (SELECT        MAX(CASE WHEN (e.gender = 2) THEN (1) ELSE (0) END) AS Expr1
                               FROM            dbo.movie_cast AS d LEFT OUTER JOIN
                                                         dbo.actors_dim AS e ON d.actor_id = e.actor_id
                               WHERE        (d.movie_id = a.movie_id) AND (d.[order] = 2)) AS sw_male_actor2,
                             (SELECT        MAX(revenue) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_6
                               WHERE        (release_date < a.release_date) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_5
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 0))) AND (revenue IS NOT NULL)) AS actor0_prev_revenue,
                             (SELECT        MAX(revenue) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_4
                               WHERE        (release_date < a.release_date) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_3
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 1))) AND (revenue IS NOT NULL)) AS actor1_prev_revenue,
                             (SELECT        MAX(revenue) AS Expr1
                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_2
                               WHERE        (release_date < a.release_date) AND (actor_id =
                                                             (SELECT        TOP (1) actor_id
                                                               FROM            dbo.movie_actor_date_revenue AS movie_actor_date_revenue_1
                                                               WHERE        (movie_id = a.movie_id) AND ([order] = 2))) AND (revenue IS NOT NULL)) AS actor2_prev_revenue
FROM            dbo.movies AS a