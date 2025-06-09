report 56035 "Importa Lin. Compras"
{
    Caption = 'Import Purch. Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                ReadExcelSheet;
                Commit;
                AnalyzeData;
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
                        field(File_Name; FileName)
                        {
                            Caption = 'Workbook File Name';
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                UploadFile;
                            end;

                            trigger OnValidate()
                            begin
                                FileNameOnAfterValidate;
                            end;
                        }
                        field(Sheet_Name; SheetName)
                        {
                            Caption = 'Worksheet Name';
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                /*               if IsServiceTier then
                                                  SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                              else
                                                  SheetName := ExcelBuf.SelectSheetsName(FileName); */
                            end;
                        }
                        field(DimensionProveedor; DimProv)
                        {
                            Caption = 'Vendor Dim. Code';
                            TableRelation = Dimension;
                            ApplicationArea = All;
                        }
                    }
                    group("Data Columns")
                    {
                        Caption = 'Data Columns';
                        field(Cell_1; Cell1)
                        {
                            Caption = 'Item/G/L Account Code Cell';
                            ApplicationArea = All;
                        }
                        field(Cell_2; Cell2)
                        {
                            Caption = 'Quantity Cell';
                            ApplicationArea = All;
                        }
                        field(Cell_3; Cell3)
                        {
                            Caption = 'Direct Unit cost Cell';
                            ApplicationArea = All;
                        }
                        field(Cell_4; Cell4)
                        {
                            Caption = 'Employee Cell';
                            ApplicationArea = All;
                        }
                        field(Cell_5; Cell5)
                        {
                            Caption = 'Vendor Cell';
                            ApplicationArea = All;
                        }
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        NoLin := 1000;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        PL: Record "Purchase Line";
        PL2: Record "Purchase Line";
        Item: Record Item;
        GLAcc: Record "G/L Account";
        Empl: Record Employee;
        DefDim: Record "Default Dimension";
        Celda: Code[5];
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Window: Dialog;
        Description: Text[50];
        CodProducto: Code[20];
        Cantidad: Decimal;
        Empleado: Code[20];
        Prov: Code[20];
        DimProv: Code[20];
        Costo: Decimal;
        Cell1: Code[5];
        Cell2: Code[5];
        Text0001: Label 'aaa';
        Text007: Label 'Analyzing Data...\\';
        Cell3: Code[5];
        Cell4: Code[5];
        Cell5: Code[5];
        TotalRecNo: Integer;
        RecNo: Integer;
        Text006: Label 'Import Excel File';
        NoLin: Integer;
        CodProd: Code[20];
        TipoDocumento: Integer;
        NoDocumento: Code[20];
        Err001: Label 'The code %1 doesn''t exist either as Item or G/L Account';
        FilaAnt: Integer;
        FirstTime: Boolean;
        UltimaFila: Integer;
        UltimaCelda: Code[20];
        Err002: Label 'Cost can''t be zero, check line %1';
        Err003: Label 'Quantity can''t be zero, check line %1';
        Err004: Label 'G/L Account or Item code can''t be blank, check line %1';
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;


    procedure RecibeParametros(TipoDoc: Integer; NoDoc: Code[20])
    begin
        TipoDocumento := TipoDoc;
        NoDocumento := NoDoc;
    end;

    local procedure ReadExcelSheet()
    begin
        //if IsServiceTier then
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;

        FirstTime := true;

        /*    ExcelBuf.OpenBook(FileName, SheetName); */
        ExcelBuf.ReadSheet;
    end;

    local procedure AnalyzeData()
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        BudgetBuf: Record "Budget Buffer";
        TempBudgetBuf: Record "Budget Buffer" temporary;
        HeaderRowNo: Integer;
        CountDim: Integer;
        TestDate: Date;
        OldRowNo: Integer;
        DimRowNo: Integer;
        DimCode3: Code[20];
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        TotalRecNo := ExcelBuf.Count;
        RecNo := 0;
        FilaAnt := 0;
        if ExcelBuf.FindLast then
            UltimaFila := ExcelBuf."Row No.";

        if ExcelBuf.Find('-') then
            repeat
                if FirstTime then begin
                    FirstTime := false;
                    FilaAnt := ExcelBuf."Row No.";
                end;

                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                Celda := ExcelBuf.xlColID + ExcelBuf.xlRowID;
                if Celda = Cell1 then begin
                    Evaluate(CodProducto, ExcelBuf."Cell Value as Text");
                    Cell1 := IncStr(Cell1);
                    if not Item.Get(CodProducto) then
                        if not GLAcc.Get(CodProducto) then
                            Error(Err001, CodProducto);
                end;

                if Celda = Cell2 then begin
                    Evaluate(Cantidad, ExcelBuf."Cell Value as Text");
                    Cell2 := IncStr(Cell2);
                    if Cantidad = 0 then
                        Error(Err003, ExcelBuf."Row No.");
                end;

                if Celda = Cell3 then begin
                    Evaluate(Costo, ExcelBuf."Cell Value as Text");
                    Cell3 := IncStr(Cell3);
                    if Costo = 0 then
                        Error(Err002, ExcelBuf."Row No.");
                end;

                if Celda = Cell4 then
                    Evaluate(Empleado, ExcelBuf."Cell Value as Text");

                if Celda = Cell5 then
                    Evaluate(Prov, ExcelBuf."Cell Value as Text");

                if (CodProducto <> '') and (Cantidad <> 0) and (Costo <> 0) and (FilaAnt < ExcelBuf."Row No.") then begin
                    FilaAnt := ExcelBuf."Row No.";
                    Cell4 := IncStr(Cell4);
                    Cell5 := IncStr(Cell5);
                    PL2.Reset;
                    PL2.SetRange("Document Type", TipoDocumento);
                    PL2.SetRange("Document No.", NoDocumento);
                    if not PL2.FindLast then
                        PL2."Line No." := 0;

                    PL2."Line No." += 1000;

                    PL.Init;
                    PL."Document Type" := GetDocumentType(TipoDocumento);
                    PL."Document No." := NoDocumento;
                    PL."Line No." := PL2."Line No.";

                    if Item.Get(CodProducto) then
                        PL.Type := PL.Type::Item
                    else
                        PL.Type := PL.Type::"G/L Account";
                    PL.Validate("No.", CodProducto);
                    PL.Validate(Quantity, Cantidad);
                    PL.Validate("Direct Unit Cost", Costo);
                    PL.Insert(true);

                    Clear(TempDimSetEntry);
                    if Empleado <> '' then begin
                        if Empl.Get(Empleado) then begin
                            PL.Description := CopyStr(Empl."Full Name", 1, 60);
                            PL.Modify;

                            DefDim.Reset;
                            DefDim.SetRange("Table ID", 5200);
                            DefDim.SetRange("No.", Empleado);
                            DefDim.SetRange("Value Posting", 2); //Igual a codigo
                            if DefDim.FindSet then
                                repeat
                                    DimVal.Get(DefDim."Dimension Code", DefDim."Dimension Value Code");
                                    TempDimSetEntry.Init;
                                    TempDimSetEntry."Dimension Code" := DefDim."Dimension Code";
                                    TempDimSetEntry."Dimension Value Code" := DefDim."Dimension Value Code";
                                    TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                                    TempDimSetEntry.Insert;
                                until DefDim.Next = 0;
                        end;
                    end;

                    if Prov <> '' then begin
                        DimVal.Get(DimProv, Prov);
                        TempDimSetEntry.Init;
                        TempDimSetEntry."Dimension Code" := DimProv;
                        TempDimSetEntry."Dimension Value Code" := Prov;
                        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                        TempDimSetEntry.Insert;
                    end;

                    PL."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
                    PL.Modify;

                    CodProducto := '';
                    Empleado := '';
                    Prov := '';
                    Cantidad := 0;
                    Costo := 0;
                end;
            until ExcelBuf.Next = 0;

        Cell1 := CopyStr(Cell1, 1, 1) + Format(UltimaFila);
        Cell2 := CopyStr(Cell2, 1, 1) + Format(UltimaFila);
        Cell3 := CopyStr(Cell3, 1, 1) + Format(UltimaFila);
        Cell4 := CopyStr(Cell4, 1, 1) + Format(UltimaFila);
        Cell5 := CopyStr(Cell5, 1, 1) + Format(UltimaFila);

        ExcelBuf.SetRange("Row No.", UltimaFila);
        if ExcelBuf.FindLast then
            UltimaCelda := ExcelBuf.xlColID + ExcelBuf.xlRowID;

        ExcelBuf.Reset;
        ExcelBuf.SetRange("Row No.", UltimaFila);
        if ExcelBuf.Find('-') then
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                Celda := ExcelBuf.xlColID + ExcelBuf.xlRowID;
                if Celda = Cell1 then begin
                    Evaluate(CodProducto, ExcelBuf."Cell Value as Text");
                    Cell1 := IncStr(Cell1);
                    if not Item.Get(CodProducto) then
                        if not GLAcc.Get(CodProducto) then
                            Error(Err001, CodProducto);
                end;

                if Celda = Cell2 then begin
                    Evaluate(Cantidad, ExcelBuf."Cell Value as Text");
                    Cell2 := IncStr(Cell2);
                    if Cantidad = 0 then
                        Error(Err003, ExcelBuf."Row No.");
                end;

                if Celda = Cell3 then begin
                    Evaluate(Costo, ExcelBuf."Cell Value as Text");
                    Cell3 := IncStr(Cell3);
                    if Costo = 0 then
                        Error(Err002, ExcelBuf."Row No.");
                end;

                if Celda = Cell4 then begin
                    Evaluate(Empleado, ExcelBuf."Cell Value as Text");
                    Cell4 := IncStr(Cell4);
                end;

                if Celda = Cell5 then begin
                    Evaluate(Prov, ExcelBuf."Cell Value as Text");
                    Cell5 := IncStr(Cell5);
                end;

                if (CodProducto <> '') and (Cantidad <> 0) and (Costo <> 0) and (UltimaCelda = ExcelBuf.xlColID + ExcelBuf.xlRowID) then begin
                    PL2.Reset;
                    PL2.SetRange("Document Type", TipoDocumento);
                    PL2.SetRange("Document No.", NoDocumento);
                    if not PL2.FindLast then
                        PL2."Line No." := 0;

                    PL2."Line No." += 1000;

                    PL.Init;
                    PL."Document Type" := GetDocumentType(TipoDocumento);
                    PL."Document No." := NoDocumento;
                    PL."Line No." := PL2."Line No.";

                    if Item.Get(CodProducto) then
                        PL.Type := PL.Type::Item
                    else
                        PL.Type := PL.Type::"G/L Account";
                    PL.Validate("No.", CodProducto);
                    PL.Validate(Quantity, Cantidad);
                    PL.Validate("Direct Unit Cost", Costo);
                    PL.Insert(true);
                    Clear(TempDimSetEntry);
                    if Empleado <> '' then begin
                        if Empl.Get(Empleado) then begin
                            PL.Description := CopyStr(Empl."Full Name", 1, 60);
                            PL.Modify;

                            DefDim.Reset;
                            DefDim.SetRange("Table ID", 5200);
                            DefDim.SetRange("No.", Empleado);
                            DefDim.SetRange("Value Posting", 2); //Igual a codigo
                            if DefDim.FindSet then
                                repeat
                                    DimVal.Get(DefDim."Dimension Code", DefDim."Dimension Value Code");
                                    TempDimSetEntry.Init;
                                    TempDimSetEntry."Dimension Code" := DefDim."Dimension Code";
                                    TempDimSetEntry."Dimension Value Code" := DefDim."Dimension Value Code";
                                    TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                                    TempDimSetEntry.Insert;

                                until DefDim.Next = 0;
                        end;
                    end;
                    if Prov <> '' then begin
                        DimVal.Get(DimProv, Prov);
                        TempDimSetEntry.Init;
                        TempDimSetEntry."Dimension Code" := DimProv;
                        TempDimSetEntry."Dimension Value Code" := Prov;
                        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
                        TempDimSetEntry.Insert;

                    end;
                    PL."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
                    PL.Modify;

                end;
            until ExcelBuf.Next = 0;

        Window.Close;
    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
    begin
        /*      UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok); */

        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;

    local procedure GetDocumentType(DocTypeInt: Integer) DocType: Enum "Purchase Document Type"
    var
        myInt: Integer;
    begin
        case DocTypeInt of
            0:
                Exit(DocType::Quote);
            1:
                Exit(DocType::Order);
            2:
                Exit(DocType::Invoice);
            3:
                Exit(DocType::"Credit Memo");
            4:
                Exit(DocType::"Blanket Order");
            5:
                Exit(DocType::"Return Order");
        end;

    end;
}

