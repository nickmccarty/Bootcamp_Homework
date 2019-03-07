Sub Ticker_Grabber()

Dim ws As Worksheet

Dim Last_Row As Long

For Each ws In Worksheets

ws.Activate

Last_Row = Cells(Rows.Count, 1).End(xlUp).Row

For i = 2 To Last_Row

Next i

ws.Range("A2:A" & Last_Row).AdvancedFilter _
    Action:=xlFilterCopy, _
    CopyToRange:=ActiveSheet.Range("I1"), _
    Unique:=True

Cells(1, 9).Value = "Ticker"

Cells(1, 10).Value = "Total Stock Volume"

Next

End Sub
