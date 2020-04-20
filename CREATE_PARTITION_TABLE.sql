#テーブルを年ごとに作るパーティション
CREATE TABLE `bigquery-trial-243206.kaggle_recruit_data.air_visit_data_2017_2`
PARTITION BY visit_date
OPTIONS (
       partition_expiration_days=59
       )
AS
SELECT
  air_store_id,
  visit_date,
  visitors
FROM
   `bigquery-trial-243206.kaggle_recruit_data.air_visit_data`
WHERE
  visit_date between "2017-01-01" and "2017-12-31"


#SELECTの書き方、テーブル名の末尾に*を入れる
SELECT *
FROM `bigquery-trial-243206.kaggle_recruit_data.air_visit_data_*` LIMIT 1000