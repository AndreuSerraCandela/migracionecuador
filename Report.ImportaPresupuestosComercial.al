report 76014 "Importa Presupuestos Comercial"
{
    Caption = 'Importe Commercial Budget';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                ReadExcelSheet;
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
                                /*                 if IsServiceTier then
                                                    SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                                else
                                                    SheetName := ExcelBuf.SelectSheetsName(FileName); */
                            end;
                        }
                    }
                    group("Data Columns")
                    {
                        Caption = 'Data Columns';
                        field(Cell1; Cell1)
                        {
                            Caption = 'Salesperson Code Cell';
                            ApplicationArea = All;
                        }
                        field(Cell2; Cell2)
                        {
                            Caption = 'Item Code Cell';
                            ApplicationArea = All;
                        }
                        field(Cell3; Cell3)
                        {
                            Caption = 'Quantity Cell';
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
        PptoVentas: Record "Promotor - Ppto Vtas";
        PptoMuestras: Record "Promotor - Ppto Muestras";
        Celda: Code[6];
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Window: Dialog;
        Description: Text[50];
        Qty: Decimal;
        Amt: Decimal;
        CodPromotor: Code[20];
        Cell1: Code[6];
        Cell2: Code[6];
        Text0001: Label 'aaa';
        Text007: Label 'Analyzing Data...\\';
        Cell3: Code[6];
        TotalRecNo: Integer;
        RecNo: Integer;
        Text006: Label 'Import Excel File';
        NoLin: Integer;
        CodProd: Code[20];
        TipoPresupuesto: Option Ventas,Muestras;
        Err001: Label 'The columns of Salesperson and Items can''t contain blank cells, verify line no. %1';
        Linea: Integer;

    local procedure ReadExcelSheet()
    begin
        //if IsServiceTier then
        if UploadedFileName = '' then
            UploadFile
        else
            FileName := UploadedFileName;

        /*         ExcelBuf.OpenBook(FileName, SheetName); */
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
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);
        TotalRecNo := ExcelBuf.Count;
        RecNo := 0;

        if ExcelBuf.Find('-') then
            repeat
                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                Celda := ExcelBuf.xlColID + ExcelBuf.xlRowID;
                if Celda = Cell3 then begin
                    Evaluate(Qty, ExcelBuf."Cell Value as Text");
                    Cell3 := IncStr(Cell3);
                end
                else
                    if Celda = Cell2 then begin
                        CodProd := ExcelBuf."Cell Value as Text";
                        Cell2 := IncStr(Cell2);
                    end
                    else
                        if Celda = Cell1 then begin
                            CodPromotor := ExcelBuf."Cell Value as Text";
                            CodPromotor := DelChr(CodPromotor, '=', ', .');
                            Cell1 := IncStr(Cell1);
                        end;
                /*
                    IF ((CodPromotor = '') AND (COPYSTR(Cell1,1,1) = ExcelBuf.xlColID))  THEN
                       ERROR(Err001,Linea + 1);

                    IF ((CodProd = '') AND (COPYSTR(Cell2,1,1) = ExcelBuf.xlColID))  THEN
                       ERROR(Err001,Linea + 1);
                */
                if (CodPromotor = '') and (Celda = Cell1) then
                    Error(Err001, Linea + 1);

                if (CodProd = '') and (Celda = Cell2) then
                    Error(Err001, Linea + 1);

                if TipoPresupuesto = 0 then begin
                    PptoVentas.Reset;
                    PptoVentas.SetRange("Cod. Promotor", CodPromotor);
                    PptoVentas.SetRange("Cod. Producto", CodProd);
                    if PptoVentas.FindFirst then begin
                        PptoVentas.Validate("Cod. Promotor", CodPromotor);
                        PptoVentas.Validate("Cod. Producto", CodProd);
                        if Cell3 <> '' then
                            PptoVentas.Validate(Quantity, Qty);

                        PptoVentas.Modify;
                    end
                    else begin
                        PptoVentas.Validate("Cod. Promotor", CodPromotor);
                        PptoVentas.Validate("Cod. Producto", CodProd);
                        PptoVentas.Validate(Quantity, Qty);
                        PptoVentas.Insert;
                    end;
                end
                else begin
                    PptoMuestras.Reset;
                    PptoMuestras.SetRange("Cod. Promotor", CodPromotor);
                    PptoMuestras.SetRange("Cod. Producto", CodProd);
                    if PptoMuestras.FindFirst then begin
                        PptoMuestras.Validate("Cod. Promotor", CodPromotor);
                        PptoMuestras.Validate("Cod. Producto", CodProd);
                        if Cell3 <> '' then
                            PptoMuestras.Validate(Quantity, Qty);

                        PptoMuestras.Modify;
                    end
                    else begin
                        PptoMuestras.Validate("Cod. Promotor", CodPromotor);
                        PptoMuestras.Validate("Cod. Producto", CodProd);
                        PptoMuestras.Validate(Quantity, Qty);
                        PptoMuestras.Insert;
                    end;
                end;
            until ExcelBuf.Next = 0;

        Window.Close;

    end;


    procedure UploadFile()
    var
        CommonDialogMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
    begin
        //UploadedFileName := CommonDialogMgt.OpenFile(Text006,ClientFileName,2,'',0);
        /*         UploadedFileName := CommonDialogMgt.UploadFile(Text006, ClientFileName); */
        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;


    procedure RecibeParametros(TipoPpto: Option Ventas,Muestras)
    begin
        TipoPresupuesto := TipoPpto;
    end;
}

