report 56530 "Importa desde Excel"
{
    Caption = 'Import from Excel';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Excel Buffer"; "Excel Buffer")
        {

            trigger OnAfterGetRecord()
            begin
                RecNo := RecNo + 1;
                Message(Text020, RecNo);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Import from")
                    {
                        Caption = 'Import from';
                        field(FileName; FileName)
                        {
                            Caption = 'Workbook File Name';
                            ApplicationArea = Basic, Suite;

                            trigger OnAssistEdit()
                            begin
                                UploadFile;
                            end;

                            trigger OnValidate()
                            begin
                                FileNameOnAfterValidate;

                            end;
                        }
                        field(SheetName; SheetName)
                        {
                            Caption = 'Worksheet Name';
                            ApplicationArea = Basic, Suite;

                            trigger OnAssistEdit()
                            begin
                                /*               if IsServiceTier then
                                                  SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                              else
                                                  SheetName := ExcelBuf.SelectSheetsName(FileName); */
                            end;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Description := Text005 + Format(WorkDate);
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        ExcelBuf.DeleteAll;
    end;

    trigger OnPreReport()
    var
        BusUnit: Record "Business Unit";
    begin

        ExcelBuf.DeleteAll;
        ExcelBuf.LockTable;

        //rConfigCompra.GET;

        //NoDocumento := NoSeriesMgt.GetNextNo(rConfigCompra."Invoice Nos.", 0D,TRUE);

        ReadExcelSheet;
        AnalyzeData;

        // InsertRecordHeader;
        if (LinesRowNo = 0) then begin
            TotalRecNo := maxrow - HeaderRowNo;    //  Solo se carga la tabla header, no lines
            InsertRecord(HeaderTableNo, TotalRecNo, HeaderRowNo, maxcolhead);
        end
        else begin
            TotalRecNo := 1;
            InsertRecord(HeaderTableNo, TotalRecNo, HeaderRowNo, maxcolhead);
            TotalRecNo := maxrow - LinesRowNo;
            InsertRecord(LineTableNo, TotalRecNo, LinesRowNo, maxcolline);

        end;

        ExcelBuf.DeleteAll;
    end;

    var
        Text000: Label 'You must specify a budget name to import to.';
        Text001: Label 'Do you want to create %1 %2.';
        Text002: Label '%1 %2 is blocked. You cannot import entries.';
        Text003: Label 'Are you sure you want to %1 for %2 %3.';
        Text004: Label '%1 table has been successfully updated with %2 entries.';
        Text005: Label 'Imported from Excel ';
        Text006: Label 'Import Excel File';
        Text007: Label 'Analyzing Data...\\';
        Text008: Label 'You cannot specify more than 8 dimensions in your Excel worksheet.';
        Text009: Label 'Principal:';
        Text010: Label 'G/L Account No.';
        Text011: Label 'The text Principal: can only be specified once in the Excel worksheet.';
        Text012: Label 'The dimensions specified by worksheet must be placed in the lines before the table.';
        Text013: Label 'Detalle:';
        Text014: Label 'Date';
        Text015: Label 'Error: The Field %1 in the Excel worksheet is not valid. %2 %3';
        Text016: Label 'Validando campo [%1:%2]: %3';
        Text017: Label 'Dimension 3';
        Text018: Label 'Inserting Data...\\';
        Text019: Label 'Dimension 5';
        Text020: Label '%1 %2 %3 %4 %5 %6';
        Text021: Label 'Dimension 7';
        Text022: Label 'Dimension 8';
        Text023: Label 'You cannot import the same information twice.\';
        Text024: Label 'The combination G/L Account No. - Dimensions - Date must be unique.';
        Text025: Label 'G/L Accounts have not been found in the Excel worksheet.';
        Text026: Label 'Dates have not been recognized in the Excel worksheet.';
        ExcelBuf: Record "Excel Buffer";
        ExcelBufAux: Record "Excel Buffer";
        HeaderExcelBuf: Record "Excel Buffer";
        HeaderTableNo: Integer;
        LineExcelBuf: Record "Excel Buffer";
        LineTableNo: Integer;
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        ToGLBudgetName: Code[10];
        DimCode: array[8] of Code[20];
        EntryNo: Integer;
        LastEntryNoBeforeImport: Integer;
        TotalRecNo: Integer;
        RecNo: Integer;
        Window: Dialog;
        Description: Text[50];
        ImportOption: Option "Replace entries","Add entries";
        Text027: Label 'Replace entries,Add entries';
        Text028: Label 'A filter has been used on the %1 when the budget was exported. When a filter on a dimension has been used, a column with the same dimension must be present in the worksheet imported. The column in the worksheet must specify the dimension value codes the program should use when importing the budget.';
        rConfigCompra: Record "Purchases & Payables Setup";
        NoLinea: Integer;
        NoDocumento: Code[20];
        HeaderRowNo: Integer;
        LinesRowNo: Integer;
        "Fields": Record "Field";
        PH: Record "Purchase Header";
        PL: Record "Purchase Line";
        RecRef: RecordRef;
        FielRef: FieldRef;
        NroCampo: Integer;
        NroIndex: Integer;
        row: Integer;
        col: Integer;
        maxrow: Integer;
        maxcolhead: Integer;
        maxcolline: Integer;
        Valida: Boolean;
        Text029: Label 'Error in format of data for BigInteger type field ';
        Text030: Label 'Sucesfully inserted %1 records in table %2.';

    local procedure ReadExcelSheet()
    begin
        //if IsServiceTier then
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;

        /*       ExcelBuf.OpenBook(FileName, SheetName); */
        ExcelBuf.ReadSheet;
    end;

    local procedure AnalyzeData()
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        OldRowNo: Integer;
        TestDateTime: DateTime;
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        TotalRecNo := ExcelBuf.Count;
        RecNo := 0;
        maxrow := 0;
        maxcolhead := 0;
        maxcolline := 0;

        //  --------------------------------------------------------------------- //
        //  Lee el contenido del archivo Excel y busca las lineas identificadoras //
        //   del encabezado y del detalle.                                        //
        //  --------------------------------------------------------------------- //
        if ExcelBuf.Find('-') then begin
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                //MESSAGE(text016,ExcelBuf."Row No.",ExcelBuf."Column No.",ExcelBuf."Cell Value as Text");

                // MESSAGE(TEXT016,TEXT009,STRPOS(UPPERCASE(ExcelBuf."Cell Value as Text"),Text009));
                case true of

                    // Busca Linea Encabezado cabecera: Principal:
                    (StrPos(UpperCase(ExcelBuf."Cell Value as Text"), UpperCase(Text009)) <> 0):
                        begin
                            if HeaderRowNo = 0 then begin
                                HeaderRowNo := ExcelBuf."Row No." + 1;
                                row := ExcelBuf."Row No.";
                                col := ExcelBuf."Column No." + 1;
                                ExcelBufAux.Get(row, col);
                                Evaluate(HeaderTableNo, ExcelBufAux."Cell Value as Text");
                                //MESSAGE(TEXT020, HeaderTableNo);
                            end else
                                Error(Text011);
                        end;

                    // Busca Linea Encabezado de Lineas si hay: Detalle:
                    (StrPos(UpperCase(ExcelBuf."Cell Value as Text"), UpperCase(Text013)) <> 0):
                        begin
                            if LinesRowNo = 0 then begin
                                LinesRowNo := ExcelBuf."Row No." + 1;
                                row := ExcelBuf."Row No.";
                                col := ExcelBuf."Column No." + 1;
                                ExcelBufAux.Get(row, col);
                                Evaluate(LineTableNo, ExcelBufAux."Cell Value as Text");
                                //MESSAGE(TEXT020, LineTableNo);

                            end else
                                Error(Text012);
                        end;


                end;

                if (ExcelBuf."Row No." > maxrow) then
                    maxrow := ExcelBuf."Row No.";
                if (ExcelBuf."Row No." = HeaderRowNo) then
                    if (ExcelBuf."Column No." > maxcolhead) then
                        maxcolhead := ExcelBuf."Column No.";
                if (ExcelBuf."Row No." = LinesRowNo) then
                    if (ExcelBuf."Column No." > maxcolline) then
                        maxcolline := ExcelBuf."Column No.";


            until ExcelBuf.Next = 0;
        end;

        //MESSAGE(TEXT020, 'MaxRow:', maxrow, 'maxcolline :', maxcolline);

        ValidaCampos(HeaderTableNo, HeaderExcelBuf, HeaderRowNo);

        if (LinesRowNo <> 0) then
            ValidaCampos(LineTableNo, LineExcelBuf, LinesRowNo);

        Window.Close;
    end;

    local procedure FormatData(TextToFormat: Text[250]): Text[250]
    var
        FormatInteger: Integer;
        FormatDecimal: Decimal;
        FormatDate: Date;
    begin
        case true of
            Evaluate(FormatInteger, TextToFormat):
                exit(Format(FormatInteger));
            Evaluate(FormatDecimal, TextToFormat):
                exit(Format(FormatDecimal));
            Evaluate(FormatDate, TextToFormat):
                exit(Format(FormatDate));
            else
                exit(TextToFormat);
        end;
    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
    begin
        /*    UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok); */
        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;


    procedure InsertRecord(TableNo: Integer; NroLineas: Integer; IniRowNo: Integer; NroMaxCol: Integer)
    var
        i_value: Integer;
        dec_value: Decimal;
        dat_value: Date;
        tim_value: Time;
        b_value: Boolean;
        bi_value: BigInteger;
        dattim_value: DateTime;
        datform_value: DateFormula;
        i: Integer;
        t250: Text[250];
    begin
        Window.Open(
          Text018 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        RecNo := 0;
        Valida := false;

        //MESSAGE(Text020, 'TableNo:', TableNo, 'NroLineas :', NroLineas, 'NroMaxCol :',NroMaxCol);


        // ------------------------------------------------------------------ //
        // Lee el contenido del archivo Excel y busca las lineas de data      //
        //  para insertar registro por registro                               //
        // ------------------------------------------------------------------ //

        RecRef.Open(TableNo);   // Tabla TableNo

        //MESSAGE(Text020, 'INSERTANDO : ', HeaderTableNo);

        Fields.Reset;

        for row := IniRowNo + 1 to IniRowNo + 1 + NroLineas - 1 do begin
            RecNo := RecNo + 1;
            Window.Update(1, Round(RecNo / NroLineas * 10000, 1));

            //MESSAGE(Text020, 'INSERTANDO FILA : ', RecNo, row, NroLineas);

            Clear(RecRef);
            RecRef.Open(TableNo);
            RecRef.Init;

            for col := 1 to NroMaxCol do begin
                //
                //  Busco el tipo de campo segun encabezado  //
                //

                //MESSAGE(Text020, 'INSERTANDO COLUMNA : ', col, maxcolhead);

                ExcelBufAux.Get(IniRowNo, col);
                //EVALUATE(HeaderTableNo,ExcelBufAux."Cell Value as Text");

                Fields.SetRange(TableNo, TableNo);
                Fields.SetFilter(Fields."Field Caption", CopyStr(
                            ExcelBufAux."Cell Value as Text",
                            1, MaxStrLen(Fields."Field Caption")));
                Fields.FindFirst;

                if ExcelBuf.Get(row, col) then begin
                    t250 := ExcelBuf."Cell Value as Text";
                    FielRef := RecRef.Field(Fields."No.");
                    //MESSAGE(Text020, 'REVISANDO CAMPO: ', row, col, FielRef.NUMBER, FielRef.CAPTION, t250);

                    case Format(FielRef.Type) of
                        'Text',
                        'Code':
                            begin
                                if Valida then
                                    FielRef.Validate(CopyStr(DelChr(t250, '<>', ' '), 1, FielRef.Length))
                                else
                                    FielRef.Value := CopyStr(DelChr(t250, '<>', ' '), 1, FielRef.Length);

                                //MESSAGE(Text020, 'REVISANDO text/code: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);
                            end;

                        'Option':
                            begin
                                i_value := EncuentraOption(FielRef, t250);
                                if i_value >= 0 then begin
                                    if Valida then
                                        FielRef.Validate(i_value)
                                    else
                                        FielRef.Value := i_value;

                                    //MESSAGE(Text020, 'REVISANDO Option: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                                end;
                            end;

                        'Integer':
                            begin
                                Evaluate(i_value, t250);
                                if Valida then
                                    FielRef.Validate(i_value)
                                else
                                    FielRef.Value := i_value;

                                //MESSAGE(Text020, 'REVISANDO Integer: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                            end;

                        'BigInteger':
                            begin
                                bi_value := calcBigInt(t250);
                                if Valida then
                                    FielRef.Validate(bi_value)
                                else
                                    FielRef.Value := bi_value;

                                //MESSAGE(Text020, 'REVISANDO BigInteger: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                            end;

                        'Decimal':
                            begin
                                dec_value := calcDecimal(t250);
                                if Valida then
                                    FielRef.Validate(dec_value)
                                else
                                    FielRef.Value := dec_value;

                                //MESSAGE(Text020, 'REVISANDO Decimal: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                            end;

                        'Date':
                            begin
                                Evaluate(dat_value, t250);
                                if Valida then
                                    FielRef.Validate(dat_value)
                                else
                                    FielRef.Value := dat_value;

                                //MESSAGE(Text020, 'REVISANDO Date: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE, dat_value);

                            end;

                        'Time':
                            begin
                                tim_value := calcTime(t250);
                                if Valida then
                                    FielRef.Validate(tim_value)
                                else
                                    FielRef.Value := tim_value;

                                //MESSAGE(Text020, 'REVISANDO Time: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                            end;

                        'DateTime':
                            begin
                                dattim_value := calcDateTime(t250, t250);
                                if Valida then
                                    FielRef.Validate(dattim_value)
                                else
                                    FielRef.Value := dattim_value;

                                //MESSAGE(Text020, 'REVISANDO DateTime: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                            end;

                        'DateFormula':
                            begin
                                Evaluate(datform_value, t250);
                                if Valida then
                                    FielRef.Validate(datform_value)
                                else
                                    FielRef.Value := datform_value;

                                //MESSAGE(Text020, 'REVISANDO BigInteger: ', ExcelBufAux."Cell Value as Text", t250, FielRef.VALUE);

                            end;

                        'Boolean':
                            begin
                                b_value := calcBool(t250);
                                if Valida then
                                    FielRef.Validate(b_value)
                                else
                                    FielRef.Value := b_value;

                                //MESSAGE(Text020, 'REVISANDO Boolean: ', ExcelBufAux."Cell Value as Text", FielRef.VALUE);

                            end;

                        else
                            FielRef.Value := FormatData(ExcelBuf."Cell Value as Text");
                    end;
                end;


            end;

            RecRef.Insert(true);
            RecRef.Close;

        end;  //  END FOR row

        Window.Close;

        // Mensaje de Finalizacion y reporte de numero de registros insertados //
        Message(Text030, RecNo, TableNo);
    end;


    procedure ValidaCampos(TableNo: Integer; LocExcelBuf: Record "Excel Buffer"; FilaHeader: Integer)
    begin

        // --------------------------------------------------------------------- //
        // Valida todos los campos del registro de la cabecera/detalle.          //
        // --------------------------------------------------------------------- //

        LocExcelBuf.SetRange("Row No.", FilaHeader);
        LocExcelBuf.FindSet;

        RecRef.Open(TableNo);    // Tabla 38: Purchase Header
        repeat                   // Revisa campo por campo (columnas excel) si es valido en la tabla.


            //MESSAGE(Text020, 'VALIDANDO : ',
            //      LocExcelBuf."Cell Value as Text", STRLEN(LocExcelBuf."Cell Value as Text"), LocExcelBuf."Row No.");


            Fields.Reset;
            Fields.SetRange(TableNo, TableNo);
            Fields.SetFilter(Fields."Field Caption", CopyStr(
                              LocExcelBuf."Cell Value as Text",
                              1, MaxStrLen(Fields."Field Caption")));

            if not Fields.FindFirst then
                if CopyStr(LocExcelBuf."Cell Value as Text",
                                1, MaxStrLen(Fields."Field Caption")) <> 'Cabecera Factura de Compra' then
                    Error(Text015, LocExcelBuf."Cell Value as Text", 'Tabla :', LineTableNo);


        until LocExcelBuf.Next = 0;
        RecRef.Close;
    end;

    local procedure EncuentraOption(var fieldRef: FieldRef; optionText: Text[30]): Integer
    var
        optionNo: Integer;
        optionList: Text[250];
    begin

        optionList := UpperCase(fieldRef.OptionCaption);

        optionNo := findTextInList(optionList, optionText, false);

        if optionNo >= 0 then
            exit(optionNo);

        optionList := removeDigits(optionText);
        if optionList <> '' then
            exit(-1);

        Evaluate(optionNo, optionText);
        exit(optionNo);
    end;

    local procedure findTextInList(list: Text[1024]; textToSearchFor: Text[250]; onlyFullMatch: Boolean): Integer
    var
        i: Integer;
        optionNo: Integer;
        beginOptionText: Integer;
        optionTextLen: Integer;
        optionListLen: Integer;
        textToSearchForLen: Integer;
        optionText: Text[250];
    begin
        textToSearchFor := UpperCase(textToSearchFor);
        textToSearchForLen := StrLen(textToSearchFor);

        optionListLen := StrLen(list);

        beginOptionText := 1;
        i := 1;

        while i < optionListLen do begin
            while (i <= optionListLen) and (list[i] <> ',') do
                i += 1;
            optionTextLen := i - beginOptionText;
            optionText := CopyStr(list, beginOptionText, optionTextLen);
            if onlyFullMatch then begin
                if UpperCase(optionText) = textToSearchFor then
                    exit(optionNo);
            end else
                if UpperCase(CopyStr(optionText, 1, textToSearchForLen)) = textToSearchFor then
                    exit(optionNo);
            optionNo += 1;
            i += 1;
            beginOptionText := i;
        end;

        optionText := '';
        exit(-1);
    end;


    procedure removeDigits(inTxt: Text[500]) retVal: Text[512]
    var
        thousandsSeparator: Text[1];
    begin
        thousandsSeparator := ',';
        //thousandsSeparator[1] := FORMAT(1000.0)[2];

        retVal := DelChr(inTxt, '<=>', '0123456789' + thousandsSeparator);
        exit(retVal)
    end;

    local procedure calcBigInt(txt: Code[50]) bi: BigInteger
    var
        i: Integer;
        tBase: Text[50];
        tExp: Text[30];
        d: Decimal;
    begin
        i := StrPos(txt, 'E');
        if i > 0 then begin
            tBase := CopyStr(txt, 1, i - 1);
            tExp := CopyStr(txt, i + 1);
            i := 1;
            case tExp[1] of
                '+':
                    tExp := CopyStr(tExp, 2);
                '-':
                    begin
                        Error(Text029, txt);
                    end;
            end;
            Evaluate(d, tExp);
            bi := Power(10, i * d);
            Evaluate(d, tBase);
            bi := d * bi;
            exit(bi);
        end;
        Evaluate(bi, txt);
    end;

    local procedure calcDecimal(txt: Code[50]) dec: Decimal
    var
        i: Integer;
        tBase: Text[50];
        tExp: Text[30];
        d: Decimal;
    begin
        i := StrPos(txt, 'E');
        if i > 0 then begin
            tBase := CopyStr(txt, 1, i - 1);
            tExp := CopyStr(txt, i + 1);
            i := 1;
            case tExp[1] of
                '+':
                    tExp := CopyStr(tExp, 2);
                '-':
                    begin
                        tExp := CopyStr(tExp, 2);
                        i := -1;
                    end;
            end;
            Evaluate(d, tExp);
            dec := Power(10, i * d);
            Evaluate(d, tBase);
            dec := d * dec;
            exit(dec);
        end;
        Evaluate(dec, txt);
    end;

    local procedure calcBool(BoolText: Text[250]): Boolean
    var
        b: Boolean;
    begin
        case LowerCase(BoolText) of
            LowerCase(StrSubstNo('%1', true)), 'true', 'y', 't', 'yes', '1', 'si', 'sí':
                exit(true);
            LowerCase(StrSubstNo('%1', false)), 'false', 'f', 'n', 'no', '0':
                exit(false);
        end;
        Evaluate(b, BoolText);
        exit(b);
    end;

    local procedure calcDateTime(DatTimText: Text[100]; DatTimText2: Text[100]): DateTime
    var
        ts: Text[2];
        dt: DateTime;
        tim: Time;
        dat: Date;
        dec: Decimal;
        day: Integer;
        i: Integer;
        bi: BigInteger;
    begin
        ts := ', ';
        //ts[1] := FORMAT(1000.0)[2];


        Evaluate(dat, DatTimText);

        DatTimText2 := DelChr(DatTimText2, '<=>', ts);
        Evaluate(dec, DatTimText2);
        i := Round(dec, 1, '<');
        tim := 000000T;
        tim := tim + Round((dec - i) * (1000 * 60 * 60 * 24), 1);

        dt := CreateDateTime(dat, tim);

        exit(dt);
    end;

    local procedure calcTime(TimeText: Text[100]): Time
    var
        ts: Text[2];
        tim: Time;
        i: Integer;
        dec: Decimal;
    begin
        ts := ', ';
        //ts[1] := FORMAT(1000.0)[2];

        TimeText := DelChr(TimeText, '<=>', ts);
        Evaluate(dec, TimeText);
        i := Round(dec, 1, '<');
        tim := 000000T;
        tim := tim + Round((dec - i) * (1000 * 60 * 60 * 24), 1);
        exit(tim);
    end;
}

