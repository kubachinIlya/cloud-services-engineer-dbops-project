# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"


## Создание базы данных и пользователя

Для выполнения миграций и автотестов была создана БД `store` и пользователь `store_user`:
GRANT CONNECT ON DATABASE store TO store_user;
GRANT USAGE, CREATE ON SCHEMA public TO store_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO store_user;

 

## По теме сосисок

Запрос на подсчет сосисок проданных за каждый день:
EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
SUM(quantity) AS quantity_sold,
date_created AS date_of_sale
FROM orders AS o
INNER JOIN order_product AS op
    ON op.order_id = o.id
WHERE o.date_created > NOW() - INTERVAL '7 DAY'  AND  o.status = 'shipped' 
GROUP BY date_created;

 
Время без индексов - Time: 37252.847 ms (00:37.253)
Время с индексами - Time: 82805.893 ms (01:22.806)

------------------------ ЗАПРОС БЕЗ ИНДЕКСОВ

store=# \timing
Timing is on.
store=# SELECT
SUM(quantity) AS quantity_sold,
date_created AS date_of_sale
FROM orders AS o
LEFT JOIN order_product AS op
    ON op.order_id = o.id
WHERE o.status = 'shipped' AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY date_created;
 quantity_sold | date_of_sale
---------------+--------------
        941182 | 2026-05-06
        939225 | 2026-05-07
        946249 | 2026-05-08
        935516 | 2026-05-09
        934470 | 2026-05-10
        948388 | 2026-05-11
        473922 | 2026-05-12
(7 rows)

Time: 37252.847 ms (00:37.253)

                                                                               QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize GroupAggregate  (cost=266099.96..266123.02 rows=91 width=12) (actual time=36560.281..36614.078 rows=7 loops=1)
   Group Key: o.date_created
   Buffers: shared hit=10511 read=116919
   ->  Gather Merge  (cost=266099.96..266121.20 rows=182 width=12) (actual time=36560.268..36614.062 rows=21 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=10511 read=116919
         ->  Sort  (cost=265099.94..265100.17 rows=91 width=12) (actual time=36505.643..36505.647 rows=7 loops=3)
               Sort Key: o.date_created
               Sort Method: quicksort  Memory: 25kB
               Buffers: shared hit=10511 read=116919
               Worker 0:  Sort Method: quicksort  Memory: 25kB
               Worker 1:  Sort Method: quicksort  Memory: 25kB
               ->  Partial HashAggregate  (cost=265096.07..265096.98 rows=91 width=12) (actual time=36505.051..36505.056 rows=7 loops=3)
                     Group Key: o.date_created
                     Batches: 1  Memory Usage: 24kB
                     Buffers: shared hit=10495 read=116919
                     Worker 0:  Batches: 1  Memory Usage: 24kB
                     Worker 1:  Batches: 1  Memory Usage: 24kB
                     ->  Parallel Hash Right Join  (cost=148292.35..264590.84 rows=101045 width=8) (actual time=19788.918..36481.883 rows=80088 loops=3)
                           Hash Cond: (op.order_id = o.id)
                           Buffers: shared hit=10495 read=116919
                           ->  Parallel Seq Scan on order_product op  (cost=0.00..105361.13 rows=4166613 width=12) (actual time=14.575..15174.947 rows=3333333 loops=3)
                                 Buffers: shared hit=10089 read=53606
                           ->  Parallel Hash  (cost=147029.29..147029.29 rows=101045 width=12) (actual time=19768.921..19768.922 rows=80088 loops=3)
                                 Buckets: 262144  Batches: 1  Memory Usage: 13376kB
                                 Buffers: shared hit=382 read=63313
                                 ->  Parallel Seq Scan on orders o  (cost=0.00..147029.29 rows=101045 width=12) (actual time=18.228..19723.408 rows=80088 loops=3)
                                       Filter: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
                                       Rows Removed by Filter: 3253245
                                       Buffers: shared hit=382 read=63313
 Planning:
   Buffers: shared hit=16
 Planning Time: 0.347 ms
 JIT:
   Functions: 54
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 2.766 ms, Inlining 0.000 ms, Optimization 1.194 ms, Emission 46.870 ms, Total 50.830 ms
 Execution Time: 36615.221 ms
(39 rows)

Time: 36616.337 ms (00:36.616)



------------------------ ТУТ НИЖЕ ОПТИМИЗИРОВАННЫЙ ЗАПРОС (индексами)





