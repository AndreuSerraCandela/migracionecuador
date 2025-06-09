tableextension 50070 tableextension50070 extends "Excel Buffer"
{
    procedure SelectSheetsNameClient(FileName: Text; IStream: InStream): Text[250]
    var
        //[RunOnClient]
        //SheetNames: DotNet ArrayList;
        SheetNames: Record "Name/Value Buffer" temporary;
        SheetName: Text[250];
        SelectedSheetName: Text[250];
        SheetsList: Text[250];
        EndOfLoop: Integer;
        i: Integer;
        OptionNo: Integer;
    begin
        if FileName = '' then
            Error(Text001);

        //XlWrkBkReaderClient := XlWrkBkReaderClient.Open(FileName);
        /*         TempExcelBuffer.OpenExcelWithName(FileName); */

        //SheetNames := SheetNames.ArrayList(XlWrkBkReaderClient.SheetNames);
        TempExcelBuffer.GetSheetsNameListFromStream(IStream, SheetNames);
        //if not IsNull(SheetNames) then begin
        if SheetNames.FindFirst() then begin
            i := 0;
            EndOfLoop := SheetNames.Count;
            repeat
                //while i <= EndOfLoop do begin
                if i < EndOfLoop then begin
                    SheetName := SheetNames.Name;
                    if (SheetName <> '') and (StrLen(SheetsList) + StrLen(SheetName) < 250) then
                        SheetsList := SheetsList + SheetName + ','
                    else
                        i := EndOfLoop;
                    i := i + 1;
                end;
            until SheetNames.Next() = 0;
            if i > 1 then begin
                if SheetsList <> '' then begin
                    OptionNo := StrMenu(SheetsList, 1, SelectWorksheetMsg);
                    if OptionNo <> 0 then
                        SelectedSheetName := SelectStr(OptionNo, SheetsList);
                end
            end else
                SelectedSheetName := SheetName;
        end;

        QuitExcel;
        exit(SelectedSheetName);
    end;

    procedure FindAllSheetsNames(pwFileName: Text; IStream: InStream; var pwSheetNames: array[50] of Text[250]) Total: Integer
    var
        i: Integer;
        //SheetNames: DotNet ArrayList;
        SheetNames: Record "Name/Value Buffer" temporary;
    begin
        // FindAllSheetsNames
        // Devuelve el total de paginas que tiene el documento y las introduce todas en la matriz pwSheetNames
        // MdM JPT 25/08/2017

        Clear(pwSheetNames);

        if pwFileName = '' then
            Error(Text001);

        /*         TempExcelBuffer.OpenExcelWithName(pwFileName); */
        //XlWrkBkReader := XlWrkBkReader.Open(pwFileName);

        //SheetNames := SheetNames.ArrayList(XlWrkBkReader.SheetNames);
        TempExcelBuffer.GetSheetsNameListFromStream(IStream, SheetNames);
        //if not IsNull(SheetNames) then begin
        if SheetNames.FindFirst() then begin
            i := 0;
            Total := SheetNames.Count;
            if Total > ArrayLen(pwSheetNames) then
                Total := ArrayLen(pwSheetNames);
            repeat
                //while i < Total do begin
                if i < Total then begin
                    pwSheetNames[i + 1] := SheetNames.Name;
                    i += 1;
                end else
                    break;
            until SheetNames.Next() = 0;
        end;

        QuitExcel;
    end;

    //utilizar ReadSheet, procedimiento standar, cambia que no muestra el dialogo
    /*procedure ReadSheet2(pwSheetName: Text; pwVerDia: Boolean) 
    var
        ExcelBufferDialogMgt: Codeunit "Excel Buffer Dialog Management";
        CellData: DotNet CellData;
        Enumerator: DotNet IEnumerator;
        i: Integer;
        RowCount: Integer;
        LastUpdate: DateTime;
    begin
        // ReadSheet2
        // Igual que ReadSheet solo que no destruye la aplicación al terminar
        // Indicamos el nombre de la hoja a leer pwSheetName
        // y permitimos No enseñar la barra de progreso mediante pwVerDia
        // MdM JPT 25/08/2017

        if pwSheetName = '' then
            Error(Text002);


        if XlWrkBkReader.HasWorksheet(pwSheetName) then begin 
            XlWrkShtReader := XlWrkBkReader.GetWorksheetByName(pwSheetName);
        end else begin
            QuitExcel;
            Error(Text004, pwSheetName);
        end;

        LastUpdate := CurrentDateTime;
        if pwVerDia then
            ExcelBufferDialogMgt.Open(Text007);
        DeleteAll;

        Enumerator := XlWrkShtReader.GetEnumerator;
        RowCount := TempExcelBuffer.Count;
        while Enumerator.MoveNext do begin
            CellData := Enumerator.Current;
            if CellData.HasValue then begin
                Validate("Row No.", CellData.RowNumber);
                Validate("Column No.", CellData.ColumnNumber);
                ParseCellValue(CellData.Value, CellData.Format);
                Insert;
            end;

            i := i + 1;
            Commit;
            if pwVerDia then
                if not UpdateProgressDialog(ExcelBufferDialogMgt, LastUpdate, i, RowCount) then begin
                    QuitExcel;
                    Error(Text035)
                end;
        end;

        //QuitExcel;
        if pwVerDia then
            ExcelBufferDialogMgt.Close;
    end;*/

    local procedure UpdateProgressDialog(var ExcelBufferDialogManagement: Codeunit "Excel Buffer Dialog Management"; var LastUpdate: DateTime; CurrentCount: Integer; TotalCount: Integer): Boolean
    var
        CurrentTime: DateTime;
    begin
        // Refresh at 100%, and every second in between 0% to 100%
        // Duration is measured in miliseconds -> 1 sec = 1000 ms
        CurrentTime := CurrentDateTime;
        if (CurrentCount = TotalCount) or (CurrentTime - LastUpdate >= 1000) then begin
            LastUpdate := CurrentTime;
            if not ExcelBufferDialogManagement.SetProgress(Round(CurrentCount / TotalCount * 10000, 1)) then
                exit(false);
        end;

        exit(true)
    end;

    var
        //[RunOnClient]
        //XlWrkBkReaderClient: DotNet WorkbookReader;

        TempExcelBuffer: Record "Excel Buffer" temporary;
        SelectWorksheetMsg: Label 'Choose the Microsoft Excel worksheet.', Comment = '{Locked="Microsoft Excel"}';
        Text001: Label 'You must enter a file name.';
        Text002: Label 'You must enter an Excel worksheet name.', Comment = '{Locked="Excel"}';
        Text004: Label 'The Excel worksheet %1 does not exist.', Comment = '{Locked="Excel"}';
        Text007: Label 'Reading Excel worksheet...\\', Comment = '{Locked="Excel"}';
        Text035: Label 'The operation was canceled.';
}

