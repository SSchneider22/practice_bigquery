## 本ページについて

### 概要：
筆者がよく使うSQLの句・式・関数についての簡単な説明と、実行可能なサンプルクエリを記載したものです。<br>
本ページ作成の目的は「筆者のためのDML文とDDL文のTIPSを作ること」なので、説明はかなり省いています。<br>
また、文章が稚拙な場合もあります。<br>
より詳細な説明は他のウェブサイトに載っていますので、<br>
本ページを利用される場合は「SQLの主要機能の一覧表・練習帳」としてご利用ください。

### 使用データ：
Kaggleのデータを使用しています。<br>
https://www.kaggle.com/c/recruit-restaurant-visitor-forecasting/data

### サンプルSQL実行環境
**「Bigqueryの標準SQL」**  を使用。 (KaggleからダウンロードしたCSVをアップロード。型はすべて自動割り当てを使用。) <br>
クレジットカードなど登録せずに無料で使用できるsandbox環境でも可能。（筆者はsandbox環境を使用。）<br>
https://cloud.google.com/bigquery/docs/sandbox?hl=ja

以下、私のサンプルクエリ実行時のデータセット等の情報を記します。
- データセット名：kaggle_recruit_data
- 各テーブル名：元のCSVの名称をそのまま使用

## SQLの種類
大きく以下の3種類に分けられる。
- DML(Data Manipulation Language)<br>
テーブルに対するデータの取得・追加・更新・削除を行う際に用いる。以下は例。
  - SELECT文：指定したテーブルから、レコードを抽出する。
  - INSERT文：指定したテーブルに対し、新しいレコードを登録する。
  - UPDATE文：指定したテーブルに対し、既存レコードの内容を変更する。
  - DELETE文：指定したテーブルに対し、既存レコードを削除する。

- DDL(Data Definition Language)<br>
データベースオブジェクトの生成や削除変更を行う際に用いる。以下は例。
  - CREATE TABLE文：クエリの内容に従い、新しいテーブルを作成する。
  - CREATE VIEW文：クエリの内容に従い、新しいビューを作成する。
  - DROP TABLE文：指定したテーブルを削除する。

- DCL(Data Control Language)<br>
トランザクションの制御を行う際に用いる。<br>
筆者が学習ベースにしているBigqueryではトランザクション処理をサポートしていないため、本ページでは扱う予定なし。
（Bigqueryは分析用途に特化しており、決済などのトランザクション処理が不可）


## 文 statement
1つの実行単位となる。 使用するDB製品によっては、末尾に「;」が必須。


## 主要な句 clause
主要な「句 clause」について説明。<br>
節ともいう。文、またはクエリの構成要素。
最低限、句で改行すると読みやすいクエリになる。

### SELECT句・FROM句
#### 説明
- SELECT句：抽出したい列名を指定する
- FROM句：抽出したいテーブル名を指定する
#### 例
1. 指定したテーブルの全ての列を取得

```
SELECT
  *
FROM
  `kaggle_recruit_data.air_reserve`
```

2. 指定したテーブルから、指定した列を取得
```
SELECT
  reserve_visitors,
  visit_datetime
FROM
  `kaggle_recruit_data.air_reserve`
```

3. 指定したテーブルから、指定した列を取得。ただし、レコードに重複がある場合は削除
```
SELECT DISTINCT
  reserve_visitors
FROM
  `kaggle_recruit_data.air_reserve`
```

4. 指定した列の名称を変更した上で取得
```
SELECT DISTINCT
  reserve_visitors AS vistor
FROM
  `kaggle_recruit_data.air_reserve`
```

### SQLで使用できる比較演算子(=,<,>など)
WHERE句やCASE式など、様々な場面で使用できる比較演算子の一覧です
| 演算子 | 内容       |
| ------ | ---------- |
| =      | 左項と右項が等しい     |
| <      | 左項が右項未満     |
| >      | 左項が右項より大きい     |
| <=     | 左項が右項以下       |
| >=     | 左項が右項以上       |
| <>, != | 左項と右項が等しくない |

### SQLで使用できる論理演算子(AND,ORなど)
| 演算子 | 内容                 |
| ------ | -------------------- |
| AND    | ●●かつ▲▲   |
| OR     | ●●または▲▲ |
| NOT    | ●●でない     |


### WHERE句
#### 説明
指定した列に対して、各種演算子を用いて条件を指定して、その条件に一致するレコードのみを抽出するための句

#### 例
1. 2016年以前のデータを取得したいとき

```
SELECT
  air_store_id,
  visit_datetime
FROM
  `kaggle_recruit_data.air_reserve`
WHERE
  visit_datetime < '2017-01-01'
```

2. 2017年1月1日～12月31日のデータを取得したいとき。

```
SELECT
  air_store_id,
  visit_datetime
FROM
  `kaggle_recruit_data.air_reserve`
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
  `kaggle_recruit_data.air_reserve`
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
  `kaggle_recruit_data.air_reserve`
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
  `kaggle_recruit_data.air_reserve`
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
  `kaggle_recruit_data.air_reserve`
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
  `kaggle_recruit_data.air_store_info`
WHERE
  air_area_name LIKE 'Tōkyō-to%'
/* LIKEは、「_」で何かしらの1文字が入る、という検索も可能*/
```

### ORDER BY句
#### 説明
レコードを指定した列で並び替えるための句
#### 例
1. レコードを昇順に並び替えて表示（並び替えキーは単一列）
```
SELECT DISTINCT
  reserve_visitors AS vistor
FROM
  `kaggle_recruit_data.air_reserve`
ORDER BY
  reserve_visitors ASC
```

2. レコードを降順に並び替えて表示（並び替えキーは単一列）
```
SELECT DISTINCT
  reserve_visitors AS vistor
FROM
  `kaggle_recruit_data.air_reserve`
ORDER BY
  reserve_visitors DESC
```

3. レコードをreserve_visitorsは昇順、visit_datetimeは降順に並び替えて表示
```
SELECT
  reserve_visitors,
  visit_datetime
FROM
  `kaggle_recruit_data.air_reserve`
ORDER BY
  reserve_visitors ASC, visit_datetime DESC
```


### JOIN句（INNER,OUTER,CROSS,など含む）
#### 説明
複数のテーブルを結合することが出来る句
#### 結合の種類一覧
よく使うのは、「左外部結合」と「内部結合」<br>
各結合の内容については、以下のURLが参考になる<br>
https://www.sejuku.net/blog/73650

| 名称             | 内容         |
| ---------------- | ------------ |
| LEFT OUTER JOIN  | 左外部結合   |
| RIGHT OUTER JOIN | 右外部結合   |
| FULL OUTER JOIN  | 完全外部結合 |
| INNER JOIN       | 内部結合     |
| CROSS JOIN       | 交差結合     |
#### 例
1. air_reserveに対して、air_store_infoを左外部結合<br>
   (予約データに対してお店の情報を付け足す、というイメージ)
```
SELECT
  R.air_store_id,
  R.reserve_visitors,
  S.air_genre_name,
  S.air_area_name
FROM
  `kaggle_recruit_data.air_reserve` R
LEFT OUTER JOIN
  `kaggle_recruit_data.air_store_info` S
ON
  R.air_store_id = S.air_store_id
```


### GROUP BY句・HAVING句
#### 説明
指定した条件と集計キーに応じて、結果を集計（複数レコードをまとめる）ことが出来る。<br>
GROUP BYで集計した結果に対して、WHERE句のような絞り込みを行いたい場合は、HAVING句を用いる。

#### 集計関数一覧
| 名称  | 内容                                         |
| ----- | -------------------------------------------- |
| SUM   | 集計された行の中で、指定した列の合計を出力   |
| MAX   | 集計された行の中で、指定した列の最大値を出力 |
| MIN   | 集計された行の中で、指定した列の最小値を出力 |
| AVG   | 集計された行の中で、指定した列の最小値を出力 |
| COUNT | 集計された行の数を出力                       |
#### 例
1. テーブル内のレコード総数を出力する
```
SELECT
  COUNT(*) AS record_count
FROM
  `kaggle_recruit_data.air_reserve`
```

2. air_store_id別に、reserve_visitorsの合計を出力
```
SELECT
  air_store_id,
  SUM(reserve_visitors) AS sum_reserve_visitors
FROM
  `kaggle_recruit_data.air_reserve`
GROUP BY
  air_store_id
```

3. air_store_id別の、reserve_visitorsの合計値が100以上のデータを出力
```
SELECT
  air_store_id,
  SUM(reserve_visitors) AS sum_reserve_visitors
FROM
  `kaggle_recruit_data.air_reserve`
GROUP BY
  air_store_id
HAVING
  sum_reserve_visitors >= 100
```

## 式 experssion

### CASE式
#### 説明
出力結果を式内で指定した条件で抽出結果を変えることができる式
#### ポイント
**必ず「ELSE」を入れること！！** 入れないと、条件に一致しない場合NULLになってしまう
#### 例
1. reserve_datetimeとvisit_datetimeの日付の差が1日以上、<br>
   つまり前日までに予約がされているならばTRUE、<br>
   そうでないならばFALSEを出力
```
SELECT
  hpg_store_id,
  visit_datetime,
  reserve_datetime,
  reserve_visitors,
  CASE WHEN TIMESTAMP_DIFF(visit_datetime, reserve_datetime, DAY) > 0 THEN TRUE
    ELSE FALSE
    END AS `RESERVED_BY_PREVIOUSDAY`
FROM
  `kaggle_recruit_data.hpg_reserve`
```



## 文字列関数

### LENGTH関数
#### 説明
指定した列の各データの文字数を返す関数
#### 例
1. hpg_genre_nameの文字数を出力
```
SELECT
  hpg_store_id,
  hpg_genre_name,
  LENGTH(hpg_genre_name) AS charcount_genre_name
FROM
  `kaggle_recruit_data.hpg_store_info`
```

### TRIM関数
#### 説明
指定した列のデータに対して、
- 引数無しの場合：左右のスペースを削除
- 引数ありの場合：削除したい文字を引数に入れ、その文字を削除する
#### 例
1. hpg_genre_nameのデータに含まれている「 style」を削除
```
SELECT
  hpg_store_id,
  hpg_genre_name,
  TRIM(hpg_genre_name, ' style') AS trim_genre_name
FROM
  `kaggle_recruit_data.hpg_store_info`
```

### REPLACE関数
#### 説明
指定した列のデータに対して、置換前と置換後の文字を指定して置き換える
#### 例
1. hpg_genre_nameのデータに含まれている「style」を「restaurant」に置換
```
SELECT
  hpg_store_id,
  hpg_genre_name,
  REPLACE(hpg_genre_name, 'style', 'restaurant') AS trim_genre_name
FROM
  `kaggle_recruit_data.hpg_store_info`
```

### SUBSTR関数
#### 説明
指定した列のデータに対して、文字列の一部を抽出する関数<br>
DB製品によって、関数名が異なるため注意。使い方は同じ
- SUBSTR : Bigquery,Oracle,PostgreSQL
- SUBSTERING : SQL Server,MySQL,Redshift
#### 例
1. hpg_store_idの1文字目～3文字目を抽出
```
SELECT
  hpg_store_id,
  hpg_genre_name,
  SUBSTR(hpg_store_id, 1,3) AS trim_genre_name
FROM
  `kaggle_recruit_data.hpg_store_info`
```

### CONCAT関数・||演算子
#### 説明
複数の文字列を連結することが出来る関数<br>
||を用いても連結が可能。DB製品によっては、どちらかしか用意されていない場合もあるため、要確認。
#### 例
1. air_store_idとair_genre_nameを、「_」を間に挟んで連結する。CONCAT関数を使用したとき。
```
SELECT
  air_store_id,
  air_genre_name,
  CONCAT(air_store_id,'_',air_genre_name)
FROM `kaggle_recruit_data.air_store_info`
```
2. air_store_idとair_genre_nameを、「_」を間に挟んで連結する。||演算子を使用したとき。
```
SELECT
  air_store_id,
  air_genre_name,
  air_store_id || '_' || air_genre_name
FROM `kaggle_recruit_data.air_store_info`
```


## 数学関数
公式ドキュメントは以下<br>
https://cloud.google.com/bigquery/docs/reference/standard-sql/mathematical_functions?hl=ja#sign

### 基本的な数学関数
少し説明がわかりづらいROUNDとTRUNC以外は、以下の表にまとめる。

|項目|SQLでの演算子・関数名|使い方|
|-|-|-|
|足し算|+|(数値型)+(数値型)|
|引き算|-|(数値型)-(数値型)|
|掛け算|* |(数値型)*(数値型)|
|割り算|/|(数値型)/(数値型)|
|余剰の計算|MOD()|MOD(X,Y) --> XをYで割った余りを返す|
|絶対値|ABS()|ABS(X) --> Xの絶対値を返す|
|三角関数|SIN(),COS(),TAN()|SIN(X) --> Xのサインを返す(-1~1)|
|指数関数|EXP()|EXP(X) --> eのX乗を返す|
|自然対数|LN()|LN(X) --> Xの自然対数（eを底とする対数）を返す|
|常用対数|LOG10()|LOG10(X) --> 10を底とする対数を返す|
|べき乗|POW(),POWER()|POW(X,Y) --> XをY乗した値を返す|
|平方根|SQRT()|SQRT(X) --> Xの平方根を返す|
|符号の出力(-1,0,+1を出力)|SIGN()|SIGN(X) --> Xの符号を返す|

### ROUND関数
#### 説明
指定した列のデータに対して、指定桁で四捨五入する関数
#### 例
1. latitudeを、少数第一位で四捨五入
```
SELECT
  latitude,
  ROUND(latitude, 0) AS ROUND_latitude
FROM
  `kaggle_recruit_data.hpg_store_info`
```

### TRUNC関数
#### 説明
指定した列のデータに対して、指定桁で切り捨てる関数
#### 例
1. latitudeを、少数第一位で切り捨て
```
SELECT
  latitude,
  TRUNC(latitude, 0) AS ROUND_latitude
FROM
  `kaggle_recruit_data.hpg_store_info`
```



## 日付・時間(DATE/TIME/DATETIME/TIMESTAMP)関数

### 日時に関する4つの型
日時に関しては、Bigqueryでは4つの型がある。(他のDB製品ではYEARなどもあるらしい)<br>
TIMESTAMP型の末尾の「+00」は、UTCを軸にどれだけ時差があるかを示している<br>
|型名|サンプル|
|-|-|
|DATE|2016-12-25|
|TIME|05:30:00|
|DATETIME|2016-12-25 05:30:00|
|TIMESTAMP|2016-12-25 05:30:00+00|
<br>
DATETIME型とTIMESTAMP型、どちらを使うかだが、MySQLでのTIMESTAMP型は2038年問題があるため、
筆者個人の意見としては、特別な事情がない限り「DATETIME型を使うべき」と考えます。


### 日時関数を使用する際の”part”について
日時関数では、年・月・日・時・分など、どの部分(part)を使うのか指定する場合がある<br>
このpartについて、代表的なものを下記にまとめる<br>
(以下はBigqueryにおけるpartを記載。他のDB製品では異なるかもしれないため、要確認)
|part|内容|
|-|-|
|YEAR|年|
|QUARTER|3か月ごとのクォーター 1~4 (1月が開始月)|
|MONTH|月|
|WEEK|週番号0~53 (日曜日が開始日)|
|WEEK(MONDAY)|週番号0~53 (月曜日が開始日、曜日は変更可能)|
|DAYOFYEAR|該当年の365or366日の内の何日目 (1月1日が開始日)|
|DAY|日|
|HOUR|時|
|MINUTE|分|
|SECOND|秒|

### 参考URL
日時関数関係は公式ドキュメントを見ると、より詳細なオプションが記載されている
https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions?hl=ja
https://cloud.google.com/bigquery/docs/reference/standard-sql/time_functions?hl=ja
https://cloud.google.com/bigquery/docs/reference/standard-sql/datetime_functions?hl=ja
https://cloud.google.com/bigquery/docs/reference/standard-sql/timestamp_functions?hl=ja

### CURRENT_(DATE/TIME/DATETIME/TIMESTAMP)関数
#### 説明
現在の日時をTIMESTAMP型で取得する関数
同様の関数として、CURRENT_DATE、CURRENT_TIME、CURRENT_DATETIMEなどがある
#### 例
```
SELECT
  CURRENT_TIMESTAMP()
```

### EXTRACT関数
#### 説明
日時データ(DATE型,TIME型,DATETIME型,TIMESTAMP型)から、part部に指定した内容を取得する関数
#### 例
1. DATE型のデータからから「日(DAY)」を取得
```
SELECT EXTRACT(DAY FROM  DATE('2018-07-15')) /*15*/
```
2. TIMESTAMP型であるvisit_datetimeから、「時(HOUR)」を取得
```
SELECT
  air_store_id,
  visit_datetime,
  EXTRACT(HOUR FROM visit_datetime) AS hour_of_visit_datetime
FROM
  `kaggle_recruit_data.air_reserve`
```

### (DATE/TIME/DATETIME/TIMESTAMP)_DIFF関数
#### 説明
2つの同じ型の日時データ(DATE型,TIME型,DATETIME型,TIMESTAMP型)を与えることで、それらの差分値を取得する関数<br>
使用するDBによって、表記と使い方が異なるため要確認。<br>
以下は、「DATE_DIFF」の例
- DATE_DIFF：Bigquery,
- DATEDIFF：MySQL,SQL Server,Redshift
- 同じ日時型同士の引き算：PostgreSQL,Oracle
#### 例
1. どちらもTIMESTAMP型の、visit_datetimeとreserve_datetimeの日差(DAY)を取得
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  TIMESTAMP_DIFF(visit_datetime, reserve_datetime, DAY) AS day_diff
FROM
  `kaggle_recruit_data.air_reserve`
```
2. DATE型のvisit_dateと、CURRENT_DATE()で今日の日付をDATE型で取得したときの、月差(MONTH)を取得
```
SELECT
  air_store_id,
  visit_date,
  DATE_DIFF(visit_date, CURRENT_DATE(), MONTH) AS month_diff
FROM
  `kaggle_recruit_data.air_visit_data`
```

### (DATE/TIME/DATETIME/TIMESTAMP)_ADD関数
#### 説明
日時データ(DATE型,TIME型,DATETIME型,TIMESTAMP型)に対して、指定した数値を加算した日時を取得する関数。<br>
使用するDBによって、表記と使い方が異なるため要確認。<br>
以下は、「DATE_ADD」の例
- DATE_ADD：Bigquery,MySQL
- DATEADD：SQL Server,Redshift
- DATEADD関数無し、個別に演算作る必要あり：PostgreSQL,Oracle
#### 例
1. TIMESTAMP型のreserve_datetimeに、1日加算した値を出力
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  TIMESTAMP_ADD(reserve_datetime, INTERVAL 1 DAY) AS reserve_datetime_add1day
FROM
  `kaggle_recruit_data.air_reserve`
```

2. TIMESTAMP型のreserve_datetimeに、1か月加算した値を出力(TIMESTAMP型はpart:MONTHに対応していないため、DATE()でDATE型へ変換が必要)
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  DATE_ADD(DATE(reserve_datetime), INTERVAL 1 MONTH) AS reserve_datetime_add1month
FROM
  `kaggle_recruit_data.air_reserve`
```

### (DATE/TIME/DATETIME/TIMESTAMP)_SUB関数
#### 説明
日時データ(DATE型,TIME型,DATETIME型,TIMESTAMP型)に対して、指定した数値を減算した日時を取得する関数。<br>
使用するDBによって、表記と使い方が異なるため要確認。<br>
以下は、「DATE_SUB」の例
- DATE_SUB：Bigquery,MySQL
- DATESUB関数無し、DATEADDのINTERVALを負にして対応：SQL Server,Redshift
- DATESUB関数無し、個別に演算作る必要あり：PostgreSQL,Oracle
#### 例
1. TIMESTAMP型のreserve_datetimeに、1週間減算した値を出力(TIMESTAMP型はpart:WEEKに対応していないため、DATE()でDATE型へ変換が必要)
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  DATE_SUB(DATE(reserve_datetime), INTERVAL 1 WEEK) AS reserve_datetime_sub1week
FROM
  `kaggle_recruit_data.air_reserve`
```

### (DATE/TIME/DATETIME/TIMESTAMP)_TRUNC関数
#### 説明
日時データ(DATE型,TIME型,DATETIME型,TIMESTAMP型)に対して、型は変換せずに、指定したpartの粒度の中で最も小さい値に変換する関数。<br>
月初、月末の日付を取得する時に便利。<br>
使用するDBによって、表記と使い方が異なるため要確認。<br>
以下は、「DATE_TRUNC」の例
- DATE_TRUNC：Bigquery,Redshift,PostgreSQL
- TRUNC：Oracle
- DATE_TRUNC関数無し、個別に演算作る必要あり：MySQL,SQL Server
#### 例
1. reserve_date_timeをその年月の中で最も小さい日付に変換する。
   (例：2016-10-31 --> 2016-10-01)
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  DATE_TRUNC(DATE(reserve_datetime), MONTH) AS firstday_reserve_datetime_month
FROM
  `kaggle_recruit_data.air_reserve`
```

2. reserve_date_timeをその日付が該当する週の中での1日目(デフォルトである日曜日)に変換する。
   (例：2016-10-14 --> 2016-10-09)
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  DATE_TRUNC(DATE(reserve_datetime), WEEK) AS firstday_reserve_datetime_week
FROM
  `kaggle_recruit_data.air_reserve`
```

3. reserve_date_timeをその日付が該当する週の中での1日目(月曜日に変更)に変換する。
   (例：2016-10-14 --> 2016-10-10)
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  DATE_TRUNC(DATE(reserve_datetime), WEEK(MONDAY)) AS firstday_reserve_datetime_week
FROM
  `kaggle_recruit_data.air_reserve`
```


### FORMAT_(DATE/TIME/DATETIME/TIMESTAMP)関数
#### 説明
日時データ(DATE型,TIME型,DATETIME型,TIMESTAMP型)に対して、指定したフォーマットに変換する関数
このフォーマットについて、代表的なものを下記にまとめる<br>
|フォーマット|内容|
|-|-|
|"%A"|その日時の曜日(Fridayなど)|
|"%B"|その日時の月(Decemberなど)|
|"%F"|YYYY-MM-DD|
<br>
上記以外にもたくさんのフォーマットがある、下記公式ドキュメントを参照。<br>
https://cloud.google.com/bigquery/docs/reference/standard-sql/functions-and-operators?hl=ja#supported_format_elements_for_timestamp

<br>
<br>
使用するDBによって、表記と使い方が異なるため要確認。<br>
以下は、「FORMAT_DATE」の例

- FORMAT_DATE：Bigquery
- DATE_FORMAT：MySQL
- FORMAT関数などを駆使して、個別に作る必要あり：SQL Server,Redshift,PostgreSQL,Oracle

#### 例
1. reserve_datetimeを「YYYY-MM-DD weekday」の表記に変換
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  FORMAT_TIMESTAMP("%F %A", reserve_datetime) AS date_weekday
FROM
  `kaggle_recruit_data.air_reserve`
```


## 型変換関数

### CAST関数
#### 説明
型の変換を行う関数。型の一覧は以下の公式ドキュメントを見る。<br>
https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_rules?hl=ja#coercion

#### 例
1. reserve_datetimeをSTRING型に変換する
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  CAST(reserve_datetime AS STRING) AS str_reserve_datetime
FROM
  `kaggle_recruit_data.air_reserve`
```

2. latitude(FLOAT型)をINT64型に変換する。latitudeの少数第一位で四捨五入された結果が出力される。
```
SELECT
  latitude,
  CAST(latitude AS INT64) AS INT64_latitude
FROM `kaggle_recruit_data.air_store_info`
```

## 集合演算子（複数のクエリの和・差・積）

### UNION句
#### 説明
和集合。2つのクエリの結果を縦に繋げて出力
Bigqueryの場合は、UNIONだけではエラーになるため、以下のどちらかを選択
- UNION DISTINCT ： レコードに重複があれば、削除する
- UNION ALL ： レコードに重複があっても、削除しない
#### 例
1. air_area_nameが「Tōkyō-to」から始まるレコードと、air_genre_nameが「Dining bar」であるレコードを繋げて出力。DISTINCTで重複レコードは削除
```
SELECT
  *
FROM
  `kaggle_recruit_data.air_store_info`
WHERE
  air_area_name LIKE 'Tōkyō-to%'
UNION DISTINCT
SELECT
  *
FROM
  `kaggle_recruit_data.air_store_info`
WHERE
  air_genre_name = 'Dining bar'
```

### EXCEPT句
#### 説明
差集合。1つ目の結果から、2つ目の結果と重複するレコードを取り除いて出力。<br>
2つのクエリがあって、それぞれ同じ結果を算出するはずなのに結果が異なる場合、その差分分析などに便利。<br>
Bigqueryの場合は、EXCEPTだけではエラーになるため、「EXCEPT DISTINCT」と記述する。
#### 例
1. air_area_nameが「Tōkyō-to」から始まり、air_genre_nameが「Dining bar」ではないレコードを出力。<br>
   （この例は1つのSELECT文だけでもWHERE ~ AND ~で書くことが出来ます、良い例ではないです）
```
SELECT
  *
FROM
  `kaggle_recruit_data.air_store_info`
WHERE
  air_area_name LIKE 'Tōkyō-to%'
EXCEPT DISTINCT
SELECT
  *
FROM
  `kaggle_recruit_data.air_store_info`
WHERE
  air_genre_name = 'Dining bar'
```

### INTERSECT句
#### 説明
積集合。1つ目の結果と2つ目の結果が重複するレコードを出力。<br>
2つ異なるクエリがあって、それぞれの結果から重複するレコードを確認したいときに便利。<br>
Bigqueryの場合は、INTERSECTだけではエラーになるため、「INTERSECT DISTINCT」と記述する。

#### 例
1. air_area_nameが「Tōkyō-to」から始まり、air_genre_nameが「Dining bar」であるレコードを出力。<br>
  （この例は1つのSELECT文だけでもWHERE ~ AND ~で書くことが出来ます、良い例ではないです）
```
SELECT
  *
FROM
  `kaggle_recruit_data.air_store_info`
WHERE
  air_area_name LIKE 'Tōkyō-to%'
INTERSECT DISTINCT
SELECT
  *
FROM
  `kaggle_recruit_data.air_store_info`
WHERE
  air_genre_name = 'Dining bar'
```


## 副問合せ(サブクエリ)
あるクエリの結果を用いて、別のクエリを実行したいときに使用するのが副問合せ、サブクエリとも言う。<br>
FROM句の中で書くことも出来るが、可読性が落ちる場合が多いため、WITH句で書くことを推奨。

### 単一行副問合せ
#### 説明
サブクエリが出力する結果を1列1レコードとして用いる手法のこと。
#### 例
1. reserve_visitorsが、reserve_visitors全レコード平均値以上であるレコードを出力する
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  reserve_visitors
FROM
  `kaggle_recruit_data.air_reserve`
WHERE
  reserve_visitors >= (
    SELECT
      AVG(reserve_visitors)
    FROM
      `kaggle_recruit_data.air_reserve`
  )
```

### WITH句
#### 説明
サブクエリを主となるSELECT文の中に書くのではなく、外に出して書くことが出来るようになるのがWITH句。<br>
- WITH句を用いるメリット
  - クエリのネストが深くならないので、クエリの可読性が上がる
  - 同じサブクエリを何度も使いたい場合、1度WITH句で定義することで使いまわせる

<br>
また、一度WITH句では複数のサブクエリが定義可能であり、同じクエリ内の後続で定義するサブクエリでは、事前に定義されているサブクエリが使用可能。文章ではわかりづらいため、以下の例3でも実践する。

#### 例
1. reserve_visitorsが、reserve_visitors全レコード平均値以上であるレコードを出力する（WITH句ver）
```
WITH avg_reserve_visitors AS (
  SELECT
    AVG(reserve_visitors) AS avg_reserve_visitors
  FROM
    `kaggle_recruit_data.air_reserve`
)
SELECT
  A.air_store_id,
  A.visit_datetime,
  A.reserve_datetime,
  A.reserve_visitors
FROM
  `kaggle_recruit_data.air_reserve` A,
  avg_reserve_visitors SUB
WHERE
  reserve_visitors >= SUB.avg_reserve_visitors
```

2. air_visit_dataのair_store_id別のレコード数を、air_reserveテーブルに左外部結合する
```
WITH record_count_of_visit_data AS (
  SELECT
    air_store_id,
    count(*) AS record_count
  FROM
    `kaggle_recruit_data.air_visit_data`
  GROUP BY
    air_store_id
)
SELECT
  A.air_store_id,
  A.visit_datetime,
  A.reserve_datetime,
  A.reserve_visitors,
  B.record_count
FROM
  `kaggle_recruit_data.air_reserve` A
LEFT OUTER JOIN
  record_count_of_visit_data B
ON
  A.air_store_id = B.air_store_id
```

3. air_visit_dataのvisitorsが、visitorsの全レコード平均値以上であるデータの中で、air_store_id別にレコード数を集計する。その後、この集計したレコード数を、air_reserveテーブルに左外部結合する
```
WITH avg_visitors_tbl AS (
  SELECT
    AVG(visitors) AS avg_visitors
  FROM
    `kaggle_recruit_data.air_visit_data`
),record_count_of_visit_data AS (
  SELECT
    A.air_store_id,
    count(*) AS record_count
  FROM
    `kaggle_recruit_data.air_visit_data` A,
    avg_visitors_tbl SUB1
  WHERE
    A.visitors >= SUB1.avg_visitors
  GROUP BY
    air_store_id
)
SELECT
  B.air_store_id,
  B.visit_datetime,
  B.reserve_datetime,
  B.reserve_visitors,
  C.record_count
FROM
  `kaggle_recruit_data.air_reserve` B
LEFT OUTER JOIN
  record_count_of_visit_data C
ON
  B.air_store_id = C.air_store_id
```

### EXISTS句
#### 説明

#### 例
1. aaaa
```

```

### ALL句
#### 説明

#### 例
1. aaaa
```

```



## 分析関数 (主にWINDOW関数)
### WINDOWS関数
#### 説明
あるテーブル内でGROUP BYを用いたような集計値を、元のテーブルのレコード数を変更することなく、元テーブルに1列追加することができる関数。<br>
例えば、「該当レコードの売上値/該当レコードが含まれる年の売上合計値」のようなデータが欲しいときに便利。<br>
WINDOW関数がないと、この「該当レコードの売上値/該当レコードが含まれる年の売上合計値」は記述に手間がかかる上、可読性も落ちてしまう。<br>
以下は、WINDOW関数がない場合の手順例。
1. 年間の売上合計値を集計するクエリをGROUP BYを用いて作る
2. 前工程で作成したクエリをサブクエリとして、元テーブルに対して左外部結合させるクエリを書く。

#### 例
1. air_store_id、visit_datetimeの年、visit_datetimeの月、この3項目別にreserve_visitorsの集計値をとり、新しくvisitors_summary_YYMMとして1列付与する
```
SELECT
  air_store_id,
  visit_datetime,
  reserve_datetime,
  reserve_visitors,
  SUM(reserve_visitors) OVER (PARTITION BY air_store_id, EXTRACT(YEAR FROM visit_datetime), EXTRACT(MONTH FROM visit_datetime)) AS visitors_summary_YYMM
FROM
  `kaggle_recruit_data.air_reserve`
```


## その他DML(Data Manipulation Language)
Bigqueryにおける公式ドキュメントは下記URLを参照。
https://cloud.google.com/bigquery/docs/reference/standard-sql/dml-syntax?hl=ja

### INSERT文
#### 説明

### UPDATE文
#### 説明

### DELETE文
#### 説明


## DDL(Data Definition Language)
Bigqueryにおける公式ドキュメントは下記URLを参照。
https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language?hl=ja


## サンプル sample

### サンプル句
#### 説明
～～～～～～～、するための句
#### 例
1. ～～～～～～、のデータを取得したいとき
```
SELECT
  air_store_id
FROM
  `kaggle_recruit_data.air_reserve`
```
