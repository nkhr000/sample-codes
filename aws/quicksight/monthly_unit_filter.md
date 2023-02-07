# Monthly集計値の日付型フィルター作成

## やりたいこと

- Monthlyで集計されている値を、日付型フィルター（カレンダー）で選択できるようにしたい
- 日付フィルターを利用する場合、Data Typeはdatetimeとするため、月集計では2022/03/01のような1日設定となる
- 2022/03/21など1日以外のカレンダー日付を選択した場合も、2022/03/01とみなすようにしたい

## 実現方法

1. 開始日（startMonth)と終了日(endMonth)のパラメータを作成
2. 作成したパラメータをコントロールに追加
3. 計算フィールド（フィルター用）で月単位フィルターの動作を定義
   - startMonth～endMonthまでの指定期間に、record_datetimeが含まれていれば1、含まれていなければ0を設定
   - startMonthはendMonthよりも小さい月を指定していなければ0を設定
```
ifelse(
    ((truncDate("MM", ${startMonth}) <= truncDate("MM", record_datetime))
    AND
    (truncDate("MM", ${endMonth}) >= truncDate("MM", record_datetime)))
    AND
    (${startMonth} <= ${endMonth}),
    1,
    0
)
```
4. 上記3で作成した計算フィールドをフィルターに追加
5. フィルターの絞り込み条件として「次と等しい」、「1」、「Nullを含む」を選択