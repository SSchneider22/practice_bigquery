#---------------
#-- make_dataset
#-- Reference:https://cloud.google.com/bigquery/docs/datasets
#---------------
# OK:cmd,Google Cloud SDK Shell, Gitbash
bq mk -d kaggle_recruit_data

# OK:cmd,Google Cloud SDK Shell   NG:Gitbash
bq --location=us-east1 mk -d --description "This is practice data from Kaggle recruit competition" kaggle_recruit_data

# OK:Gitbash
start bq --location=us-east1 mk -d --description "This is practice data from Kaggle recruit competition" kaggle_recruit_data


