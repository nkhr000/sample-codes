# 累積値の日・週・月フィルター作成

## やりたいこと

- 1つのグラフ上で月、週、日単位の表示
- 表示する値は、日単位の累積数値（その日の契約数など）
- 累積数値のため、週単位の表示では、その週の最終日（土曜）の値を表示（Sumは行わない）
- 累積数値のため、月単位の表示では、その月の月末の値を表示（Sumは行わない）

## 実現方法

1. パラメータ作成：SelectUnit
  - リストに右記を設定：1-day, 2-week, 3-month, 4-year
2. 上記1で作成したパラメータをコントロールに追加
3. 横軸（時間）用の計算フィールドを作成: ComputeDate
  - 1-dayの場合は時間は日付単位をそのまま表示（データが日単位の累積になっているため）
  - 2-week～4-yearの場合は、時間はSelectUnitに応じて丸める
```
ifelse(
${SelectUnit} = '1-day',  {target_date},
${SelectUnit} = '2-week', truncDate("WK", {target_date}),
${SelectUnit} = '3-month',truncDate("MM", {target_date})
NULL
)
```
4. 縦軸（累計値）の計算フィールドを作成: ComputeVal
  - 2-weekの場合は、レコードの日付が週単位の最終日の累積値を表示
  - 3-monthの場合は、レコードの日付が末日の累積値を表示
```
ifelse(
${SelectList} = '1-day',   val,
${SelectList} = '2-week',  ifelse(extract("WD", {target_date}) = 7, val, 0),
${SelectList} = '3-month', 
    ifelse(extract("DD", {target_date}) = extract("DD",
              addDateTime(-1,"DD",addDateTime(1,"MM",truncDate("MM", {target_date})))), val, 0),
0
)
```
5. 計算フィールドをグラフの縦軸と横軸に設定
   