-- Check size of tables and objects in PostgreSQL database
-- https://wiki-bsse.ethz.ch/display/ITDOC/Check+size+of+tables+and+objects+in+PostgreSQL+database

SELECT
   relname as "Table",
   pg_size_pretty(pg_total_relation_size(relid)) As "Size",
   pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as "External Size"
   FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;


-- Tables size
 SELECT *, pg_size_pretty(total_bytes) AS total
, pg_size_pretty(index_bytes) AS INDEX
, pg_size_pretty(toast_bytes) AS toast
, pg_size_pretty(table_bytes) AS TABLE
FROM (
SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes FROM (
SELECT c.oid,nspname AS table_schema, relname AS TABLE_NAME
, c.reltuples AS row_estimate
, pg_total_relation_size(c.oid) AS total_bytes
, pg_indexes_size(c.oid) AS index_bytes
, pg_total_relation_size(reltoastrelid) AS toast_bytes
FROM pg_class c
LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE relkind = 'r'
) a
) a;


SELECT count(pid), usename FROM pg_stat_activity group by usename;
 count |       usename        
-------+----------------------
     1 | public_api_app
     1 | manager_gateway_app
     4 | tick_app
    71 | core_app
    15 | driver_gateway_app
     4 | notify_app
     4 | guarantee_app
     2 | heatmap_app
    25 | customer_app
     9 | postgres
    16 | teller_app
     3 | priority_app
    15 | customer_gateway_app
    10 | billing_app
     2 | predict_srv
     
 #fullscan    
 select schemaname, relname, seq_scan from pg_stat_all_tables order by seq_scan desc
[9:05:31] Timur: Message removed.
[9:05:42] Timur: вот интересная статистика по фуллсканам
[9:06:02] Timur: лидеры:
[9:06:03] Timur:      schemaname     |               relname               | seq_scan  
--------------------+-------------------------------------+-----------
 orders             | order_state_audit                   | 141445121
 pg_catalog         | pg_namespace                        |  92525249
 core               | country_catalog                     |  62566908
 core               | vehicle_brand_catalog               |  58032266
 core               | city_catalog                        |  39263359
 core               | region_catalog                      |  38451141
 core               | vehicle_type_catalog                |  29867075
 core               | region                              |  26335330
 core               | document_type_catalog               |  21932363
 core               | profile                             |  19938314
 core               | car_class                           |  16060146
 core               | region_car_class                    |  15966037
 core               | toll_stat                           |  13786428
 core               | vehicle_color_catalog               |  13127737
 core               | user_role                           |  11339778
 core               | guarantee                           |   9273305
 core               | promo_code_type                     |   9137503
 core               | client_version_catalog              |   8717838
 pg_catalog         | pg_class                            |   8341004
 core               | geo_guarantee_dump                  |   7855632
 core               | news                                |   7287349
 core               | billing_payday                      |   6620396
 orders             | order_stat                          |   6475152
 core               | activated_promo_code                |   6387044
 pg_catalog         | pg_attribute                        |   6149464
 core               | training                            |   4636864
     


Describe table
\d+ tablename

copy (Select id_data From participants) To '/tmp/test.csv' With CSV;

# index usage
select schemaname || '.' || relname as table,
indexrelname as index,
pg_size_pretty(pg_relation_size(i.indexrelid)) as index_size,
idx_scan as index_scans
from pg_stat_user_indexes ui
join pg_index i on ui.indexrelid = i.indexrelid
where not indisunique and idx_scan < 50 and pg_relation_size(relid) > 5 * 819
order by pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) desc, 
pg_relation_size(i.indexrelid) desc;

//поиск неиспользуемых индексов
select schemaname || '.' || relname as table,
indexrelname as index,
pg_size_pretty(pg_relation_size(i.indexrelid)) as index_size,
idx_scan as index_scans
from pg_stat_user_indexes ui
join pg_index i on ui.indexrelid = i.indexrelid
where not indisunique and idx_scan < 50 and pg_relation_size(relid) > 5 * 819
order by pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) desc, 
pg_relation_size(i.indexrelid) desc;

//поиск дуппликатов индексов
select a.indrelid::regclass, a.indexrelid::regclass, b.indexrelid::regclass
from (select *, array_to_string(indkey, ' ') as cols from pg_index) a join 
	(select *, array_to_string(indkey, ' ') as cols from pg_index) b on
(a.indrelid = b.indrelid and a.indexrelid > b.indexrelid  and
	( (a.cols like b.cols || '%' and coalesce(substr(a.cols, length(b.cols) + 1,1), ' ') = ' ' ) or
	  (b.cols like a.cols || '%' and coalesce(substr(b.cols, length(a.cols) + 1,1), ' ') = ' ' )
	)
) order by indrelid;

