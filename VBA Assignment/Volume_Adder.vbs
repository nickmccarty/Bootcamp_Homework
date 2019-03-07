Sub Volume_Adder()

Dim ws As Worksheet

Dim Last_Row As Long

For Each ws In Worksheets

ws.Activate

Last_Row = Cells(Rows.Count, 1).End(xlUp).Row

For j = 2 To Last_Row

ws.Range("J" & j).Formula = "=SUMIF(A:A, I" & j & ",G:G)"

Next j

Next

End Sub
