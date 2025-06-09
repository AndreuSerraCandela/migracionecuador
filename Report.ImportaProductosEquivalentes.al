report 76034 "Importa Productos Equivalentes"
{
    Caption = 'Import Equivalent items';
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
                                /*                  if IsServiceTier then
                                                     SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                                 else
                                                     SheetName := ExcelBuf.SelectSheetsName(FileName); */
                            end;
                        }
                    }
                    group("Data Columns")
                    {
                        Caption = 'Data Columns';
                        field(Cell_1; Cell1)
                        {
                            Caption = 'Item Code Cell';
                            ApplicationArea = All;
                        }
                        field(Cell_2; Cell2)
                        {
                            Caption = 'Equivalent Item Code Cell';
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
        PL: Record "Productos Equivalentes";
        PL2: Record "Productos Equivalentes";
        Celda: Code[6];
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Window: Dialog;
        Description: Text[50];
        CodProducto: Code[20];
        Cantidad: Decimal;
        CodProdEq: Code[20];
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
        TipoDocumento: Integer;
        NoDocumento: Code[20];


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

        /*       ExcelBuf.OpenBook(FileName, SheetName); */
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
                if Celda = Cell1 then begin
                    Evaluate(CodProducto, ExcelBuf."Cell Value as Text");
                    Cell1 := IncStr(Cell1);
                end
                else
                    if Celda = Cell2 then begin
                        Evaluate(CodProdEq, ExcelBuf."Cell Value as Text");
                        Cell2 := IncStr(Cell2);
                    end;
                //    MESSAGE('a%1 b%2 c%3 d%4 e%5',Celda,Cell1,Cell2,CodProducto,CodProdEq);
                if (CodProducto <> '') and (CodProdEq <> '') then begin
                    /*
                     PL2.RESET;
                     PL2.SETRANGE("Document Type",TipoDocumento);
                     PL2.SETRANGE("Document No.",NoDocumento);
                     IF NOT PL2.FINDLAST THEN
                        PL2."Line No." := 0;

                     PL2."Line No." += 1000;

                     PL.INIT;
                     PL."Document Type" := TipoDocumento;
                     PL."Document No."  := NoDocumento;
                     PL."Line No."      := PL2."Line No.";
                     PL.Type            := PL.Type::Item;
                     PL.VALIDATE("No.",CodProducto);
                     PL.VALIDATE(Quantity,Cantidad);
                     PL.VALIDATE("Direct Unit Cost",Costo);
                     PL.INSERT(TRUE);
                    END;
                   */
                    Clear(PL);
                    PL.Validate("Cod. Producto", CodProducto);
                    PL.Validate("Cod. Producto Anterior", CodProdEq);
                    if PL.Insert then;

                    Clear(CodProducto);
                    Clear(CodProdEq);
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
}

