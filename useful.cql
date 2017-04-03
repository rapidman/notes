copy predict_session_reg to '/tmp/2/predict_session_reg.csv';
copy predict_input_reg to '/tmp/2/predict_input_reg.csv';
copy predict_output_reg to '/tmp/2/predict_output_reg.csv';


truncate ustaxi.predict_session_reg;
truncate ustaxi.predict_input_reg;
truncate ustaxi.predict_output_reg;


COPY ustaxi.predict_session_reg FROM '/tmp/2/predict_session_reg.csv' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;

COPY ustaxi.predict_input_reg FROM '/tmp/2/predict_input_reg.csv' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
COPY ustaxi.predict_output_reg FROM '/tmp/2/predict_output_reg.csv' WITH DELIMITER=',' AND HEADER=FALSE AND INGESTRATE=10000;
