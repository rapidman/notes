copy predict_session_reg to '/tmp/2/predict_session_reg.csv';
copy predict_input_reg to '/tmp/2/predict_input_reg.csv';
copy predict_output_reg to '/tmp/2/predict_output_reg.csv';


truncate ustaxi.predict_session_reg;
truncate ustaxi.predict_input_reg;
truncate ustaxi.predict_output_reg;


COPY ustaxi.predict_session_reg FROM '/tmp/2/predict_session_reg.csv' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;

COPY ustaxi.predict_input_reg FROM '/tmp/2/predict_input_reg.csv' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY ustaxi.predict_output_reg FROM '/tmp/2/predict_output_reg.csv' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;

//hazelcast persistence
copy hazel_cache_order_timer to '/tmp/hazel_cache_order_timer';
copy hazel_cache_order_customer_info to '/tmp/hazel_cache_order_customer_info';
copy hazel_cache_order_lost_stuff to '/tmp/hazel_cache_order_lost_stuff';
copy hazel_cache_order_tariff_info to '/tmp/hazel_cache_order_tariff_info';
copy hazel_cache_order_order to '/tmp/hazel_cache_order_order';
copy hazel_cache_order_searching_bean to '/tmp/hazel_cache_order_searching_bean';
copy hazel_cache_order_customer_order to '/tmp/hazel_cache_order_customer_order';
copy hazel_cache_order_assignment_driver to '/tmp/hazel_cache_order_assignment_driver';
copy hazel_cache_order_customer_cancel to '/tmp/hazel_cache_order_customer_cancel';
copy hazel_cache_order_gen_cache to '/tmp/hazel_cache_order_gen_cache';
copy hazel_cache_order_driver_accept to '/tmp/hazel_cache_order_driver_accept';

COPY hazel_cache_order_timer FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_timer' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_customer_info FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_customer_info' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_lost_stuff FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_lost_stuff' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_tariff_info FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_tariff_info' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_order FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_order' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_searching_bean FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_searching_bean' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_customer_order FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_customer_order' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_assignment_driver FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_assignment_driver' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_customer_cancel FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_customer_cancel' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_gen_cache FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_gen_cache' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY hazel_cache_order_driver_accept FROM '/home/timur/workspace/dump/cqlsh/hazel_cache_order_driver_accept' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
