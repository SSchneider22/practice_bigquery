SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  reserve_visitors,
  SUM(reserve_visitors) OVER (PARTITION BY air_store_id, EXTRACT(YEAR FROM visit_datetime), EXTRACT(MONTH FROM visit_datetime))
FROM
  `kaggle_recruit_data.air_reserve`