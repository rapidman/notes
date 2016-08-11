select * from audt.customer_location where event_timestamp is not null
	and event_timestamp >= '2016-07-01 03:30:00'
	and event_timestamp <= '2016-07-01 03:40:00'
        and city_id in ('44')