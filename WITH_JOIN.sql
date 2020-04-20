WITH record_count_of_visit_data as (
  SELECT
    air_store_id
    ,visit_date
    ,count(*) as record_count
  FROM
    `kaggle_recruit_data.air_visit_data`
  GROUP BY
    air_store_id,
    visit_date
  ORDER BY
    record_count DESC,
    air_store_id ASC
)
SELECT
  A.air_store_id,
  CAST(A.visit_datetime AS DATE) AS visit_date,
  B.record_count
FROM
  kaggle_recruit_data.air_reserve A
LEFT OUTER JOIN
  record_count_of_visit_data B
ON
  A.air_store_id = B.air_store_id
  AND CAST(A.visit_datetime AS DATE) = B.visit_date