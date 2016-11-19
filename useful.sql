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

************************************
//находим ИД драйвера
taxi=> select id from core.driver where ext_id='1e6313e5-7037-4706-a2e3-ac026ff7ff88';
  id  
------
 2735
(1 row)

//просмотр пэйчека
select p.completion_rate, pd.* from core.billing_paycheck p, core.billing_payday pd where p.driver_id=2735 and pd.id=p.payday_id order by pd.id desc;

//поездки драйвера за период
select order_start_date, order_end_date, driver_rating, final_driver_cost from orders.order_stat where driver_id=2735 and order_start_date between '2016-10-05 11:54:17' and '2016-10-05 12:16:32' order by order_id desc;

//кол-во поездок для CompletionRate
SELECT SUM(order_completed_cnt) AS order_completed_cnt, SUM(cust_before_arrive_cnt) AS cust_before_arrive_cnt, SUM(cust_before_trip_cnt) AS  cust_before_trip_cnt, SUM(drv_before_trip_cnt) AS drv_before_trip_cnt FROM (SELECT  CASE WHEN o.final_driver_cost > 175 AND o.sub_state = 'ORDER_COMPLETED' THEN 1 ELSE 0 END AS order_completed_cnt, CASE WHEN o.sub_state = 'CUSTOMER_CANCEL_BEFORE_ARRIVE' THEN 1 ELSE 0 END AS cust_before_arrive_cnt, CASE WHEN o.sub_state = 'CUSTOMER_CANCEL_BEFORE_TRIP' THEN 1 ELSE 0 END AS cust_before_trip_cnt, CASE WHEN o.final_driver_cost > 0 AND o.sub_state = 'DRIVER_CANCEL_BEFORE_TRIP' THEN 1 ELSE 0 END AS drv_before_trip_cnt FROM orders.order_stat o WHERE  o.driver_id = 474 AND o.launch_region_id = '11' AND (o.order_end_date >= '2016-10-07 08:31:10.693' AND o.order_end_date <= '2016-10-07 09:03:17.877') AND o.sub_state IN ('ORDER_COMPLETED', 'CUSTOMER_CANCEL_BEFORE_ARRIVE', 'CUSTOMER_CANCEL_BEFORE_TRIP', 'DRIVER_CANCEL_BEFORE_TRIP')) o


*************************
//гуппировка по ИД драйвера, SSN и validation_status 
//показывает сколько не уникальных SSN привязано конкретному юзеру
select * from 
    (select count(*) as cnt, doc.number, d.id, d.validation_status 
     from core.carrier c, core.driver d, core.document doc, core.document_type_catalog cat 
     where d.carrier_id = c.id and doc.carrier_id=c.id and doc.document_type_id=cat.id and cat.entity_type='SSN' 
     group by doc.number, d.id, d.validation_status 
     order by d.id
    ) t 
where t. cnt > 1;

//select SSN
select 
doc.number as ssn, w9.ssn as w9_ssn, d.id as drv_id, sp.email, d.last_login_ts, doc.id as doc_id, c.ssn_document_id, d.validation_status as driver_status, doc.status as doc_status
from core.carrier c, core.driver d, core.document doc, core.document_type_catalog cat, core.profile p, core.security_profile sp, core.w9_form w9
where 
	d.carrier_id = c.id and 
	doc.carrier_id=c.id and 
	doc.document_type_id=cat.id and 
	cat.entity_type='SSN' and 
	d.validation_status = 'ACTIVE' and
	p.profile_type = 'driver' and
	d.profile_id = p.id and
	p.security_profile_id = sp.id and
	p.w9_form_id = w9.id
order by doc.number, d.last_login_ts desc;


****revoke all************
revoke all on tablespace pg_default from public;
revoke all on tablespace pg_global  from public;
revoke all on database mydb from public cascade;
revoke all                   on schema myschema from public cascade;
revoke all on all tables     in schema myschema from public cascade;
revoke all on all sequences  in schema myschema from public cascade;
revoke all on all functions  in schema myschema from public cascade;
alter default privileges     in schema myschema revoke all on tables      from public cascade;
alter default privileges     in schema myschema revoke all on sequences   from public cascade;
alter default privileges     in schema myschema revoke all on functions   from public cascade;
alter default privileges     in schema myschema revoke all on types       from public cascade;

revoke all on database ustaxi_backup from rider_srv cascade;
revoke all                   on schema common from rider_srv cascade;
revoke all on all tables     in schema common from rider_srv cascade;
revoke all                   on schema core from rider_srv cascade;
revoke all on all tables     in schema core from rider_srv cascade;
revoke all on SEQUENCE   core.customer_device_imei_id_seq from rider_srv cascade;
drop USER  rider_srv;


--copy database
pg_dump ustaxi | psql ustaxi_backup

--create db
psql -U postgres -d ustaxi -f sql/create-catalog-model.sql
psql -U postgres -d ustaxi -f sql/create-model.sql
psql -U postgres -d ustaxi -f sql/create-audit-model.sql
psql -U postgres -d ustaxi -f sql/create-authentication-model.sql
psql -U postgres -d ustaxi -f sql/create-grant-users.sql
psql -U postgres -d ustaxi -f sql/sql-seed-data.sql
