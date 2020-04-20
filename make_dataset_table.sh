#---------------
#-- make_dataset
#-- Reference:https://cloud.google.com/bigquery/docs/datasets
#---------------

# simple zone automatically set "US(multi-region)"
bq mk -d kaggle_recruit_data

# select zone, description   NG:Gitbash
bq --location=us-east1 mk -d --description "This is practice data from Kaggle recruit competition" kaggle_recruit_data2

# (ex.GitBash)
start bq --location=us-east1 mk -d --description "This is practice data from Kaggle recruit competition" kaggle_recruit_data
bq --location=us-east1 mk -d kaggle_recruit_data2

#---------------
#-- make_table
#-- Reference:https://cloud.google.com/bigquery/docs/loading-data-local?hl=ja
#---------------

# from local file (--autodetect means "automatically detect scheme")
bq load \
    --autodetect \
    --source_format=CSV \
    kaggle_recruit_data.air_reserve \
    ./data/recruit_restaurant_visitor_forecasting/air_reserve.csv



#---------------
#-- delete_dataset
#-- Reference:https://cloud.google.com/bigquery/docs/managing-datasets?hl=ja#deleting_datasets
#---------------
bq rm -r -d kaggle_recruit_data


#---------------
#-- meke_partition_table
#-- Reference:https://cloud.google.com/bigquery/docs/creating-column-partitions?hl=ja#cli_1
#---------------
bq query \
    --destination_table kaggle_recruit_data.air_reserve_partition \
    --time_partitioning_field visit_datetime \
    --use_legacy_sql=false \
    '
    SELECT *
    FROM `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
    '

bq query --destination_table kaggle_recruit_data.air_reserve_partition --time_partitioning_field visit_datetime --time_partitioning_type=DAY --use_legacy_sql=false 'SELECT air_store_id FROM bigquery-trial-243206.kaggle_recruit_data.air_reserve'


bq query --destination_table bigquery-trial-243206:mydataset.mypartitionedtable --time_partitioning_field timestamp_of_crash --use_legacy_sql=false 'SELECT       state_number,       state_name,       day_of_crash,       month_of_crash,       year_of_crash,       latitude,       longitude,       manner_of_collision,       number_of_fatalities,       timestamp_of_crash     FROM       `bigquery-public-data`.nhtsa_traffic_fatalities.accident_2016     LIMIT       100'
