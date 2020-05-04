# SQL_REFERENCE

## 概要：
SQLの各種句や式の説明とサンプルを記載したものです。

## 使用データ：
https://www.kaggle.com/c/recruit-restaurant-visitor-forecasting/data

## サンプルSQL実行環境
Bigquery を使用 (ダウンロードしたCSVをアップロードしています) <br>
以下、私のクエリ実行時の環境を記載。
- プロジェクトID：bigquery-trial-243206
- データセット名：kaggle_recruit_data
- 各テーブル名：元のCSVの名称をそのまま使用

# 文 statement
1つの実行単位となる。
製品によって、末尾に「;」が必須

## SELECT文
### 説明
クエリの条件に一致するレコードを出力するための文

## INSERT文
### 説明

## UPDATE文
### 説明

## DELETE文
### 説明





# 主要な「句」 clause
節ともいう。文、またはクエリの構成要素。
最低限、句で改行すると読みやすいクエリになる。

## SELECT句
### 説明
対象となるレコードを選択する句
### 例
1. 指定したテーブルの全ての列を取得

```
SELECT
  *
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
```

2. 指定したテーブルから、指定した列を取得
```
SELECT
  reserve_visitors,
  visit_datetime
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
```

3. 指定したテーブルから、指定した列を取得。ただし、レコードに重複がある場合は削除する
```
SELECT DISTINCT
  reserve_visitors
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
```

4. 指定した列の名称を変更した上で取得。
```
SELECT DISTINCT
  reserve_visitors AS vistor
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
```



## WHERE句
### 説明
指定した列に対して、各種演算子を用いて条件を指定して、その条件に一致するレコードのみを抽出するための句

### WHERE句で使用できる比較演算子

|演算子|内容|
|-|-|
|=	|等しい|
|<	|小さい|
|>	|大きい|
|<=	|以下|
|>=	|以上|
|<>, !=	|等しくない|

### WHERE句で使用できる論理演算子
|演算子|内容|
|-|-|
|AND	|論理積，　○○かつ○○|
|NOT	|否定，　○○でない|
|OR	    |論理和，　○○または○○|

### 例
1. 2016年以前のデータを取得したいとき
```
SELECT
  air_store_id,
  visit_datetime
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
WHERE
  visit_datetime < '2017-01-01'
```

2. 2017年1月1日～12月31日のデータを取得したいとき。visit_datetimeはTIMESTAMP
```
SELECT
  air_store_id,
  visit_datetime
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
WHERE
  visit_datetime BETWEEN '2017-01-01' AND '2017-12-31'
```

3. reserve_visitorsが2,4,9のデータのみ取得したいとき
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_visitors
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
WHERE
  reserve_visitors IN (2, 4, 9)
```

4. reserve_visitorsが2,4,9「以外」かつ2017年1月1日～12月31日のデータのみ取得したいとき
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_visitors
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
WHERE
  reserve_visitors NOT IN (2, 4, 9)
  AND (visit_datetime BETWEEN '2017-01-01' AND '2017-12-31')
```

5. NULL値を持つデータを取得したいとき
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_visitors
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
WHERE
  reserve_visitors IS NULL
```

6. NULL値でないデータを取得したいとき
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_visitors
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
WHERE
  reserve_visitors IS NOT NULL
```

7. ワイルドカードを用いて、前半部分一致で検索したいとき<br>
   （以下の例では、air_area_nameが「Tōkyō-to」から始まるレコードを抽出）
```
SELECT
  air_store_id,
  air_genre_name,
  air_area_name
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_store_info`
WHERE
  air_area_name LIKE 'Tōkyō-to%'
/* LIKEは、「_」で何かしらの1文字が入る、という検索も可能*/
```

## ORDER BY句
### 説明
レコードを指定した列で並び替えるための句
### 例
1. レコードを昇順に並び替えて表示（並び替えキーは単一列）
```
SELECT DISTINCT
  reserve_visitors AS vistor
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
ORDER BY
  reserve_visitors ASC
```

2. レコードを降順に並び替えて表示（並び替えキーは単一列）
```
SELECT DISTINCT
  reserve_visitors AS vistor
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
ORDER BY
  reserve_visitors DESC
```

3. レコードをreserve_visitorsは昇順、visit_datetimeは降順に並び替えて表示
```
SELECT
  reserve_visitors,
  visit_datetime
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
ORDER BY
  reserve_visitors ASC, visit_datetime DESC
```


## JOIN句（INNER,OUTER,CROSS,など含む）
### 説明
複数のテーブルを結合することが出来る句
### 結合の種類一覧
よく使うのは、「左外部結合」と「内部結合」。<br>
各結合の内容については、以下のURLが参考になる。<br>
https://www.sejuku.net/blog/73650

|名称|内容|
|-|-|
|LEFT OUTER JOIN|左外部結合
|RIGHT OUTER JOIN|右外部結合
|FULL OUTER JOIN|完全外部結合
|INNER JOIN|内部結合
|CROSS JOIN|交差結合
### 例
1. air_reserveに対して、air_store_infoを左外部結合する。<br>
   (予約データに対してお店の情報を付け足す、というイメージ)
```
SELECT
  R.air_store_id,
  R.reserve_visitors,
  S.air_genre_name,
  S.air_area_name
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve` R
LEFT OUTER JOIN
  `bigquery-trial-243206.kaggle_recruit_data.air_store_info` S
ON
  R.air_store_id = S.air_store_id
```


## GROUP BY句
### 説明
指定した条件と集計キーに応じて、結果を集計（複数レコードをまとめる）ことが出来る
### 集計関数一覧
|名称|内容|
|-|-|
|SUM|集計された行の中で、指定した列の合計を出力
|MAX|集計された行の中で、指定した列の最大値を出力
|MIN|集計された行の中で、指定した列の最小値を出力
|AVG|集計された行の中で、指定した列の最小値を出力
|COUNT|集計された行の数を出力
### 例
1. air_store_id別に、reserve_visitorsの合計を出力
```
SELECT
  air_store_id,
  SUM(reserve_visitors) AS sum_reserve_visitors
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
GROUP BY
  air_store_id
```

2. テーブル内のレコード総数を出力する
```
SELECT
  COUNT(*) AS record_count
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
```

# 式 experssion

## CASE式
### 説明
出力結果を式内で指定した条件で抽出結果を変えることができる式
### ポイント
**必ず「ELSE」を入れること！！**入れないと、条件に一致しない場合NULLになってしまう
### 例


# 文字列関数

## LENGTH関数
### 説明
指定した列の長さを返す関数
### 例

## TRIM関数　など、他にもたくさんある。https://qiita.com/tatsuya4150/items/69c2c9d318e5b93e6ccd#except





# 副問合せ sub-query



# 分析関数 (主にWINDOW関数)











# サンプル sample

## サンプル句
### 説明
～～～～～～～、するための句
### 例
1. ～～～～～～、のデータを取得したいとき
```
SELECT
  air_store_id
FROM
  `bigquery-trial-243206.kaggle_recruit_data.air_reserve`
```
