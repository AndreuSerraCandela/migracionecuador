report 76258 "Importa datos empleados"
{
    Caption = 'Import Employee data';
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
                group(Control1000000001)
                {
                    ShowCaption = false;
                    group("Import from")
                    {
                        Caption = 'Import from';
                        field(FileName; FileName)
                        {
                            Caption = 'Workbook File Name';
                            ApplicationArea = All;
                            trigger OnAssistEdit()
                            begin
                                UploadFile;
                            end;
                        }
                        field(SheetName; SheetName)
                        {
                        ApplicationArea = All;
                            Caption = 'Worksheet Name';

                            trigger OnAssistEdit()
                            begin
                                /*                 if IsServiceTier then
                                                    SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                                else
                                                    SheetName := ExcelBuf.SelectSheetsName(FileName); */
                            end;
                        }
                        field(ConceptoSal; ConceptoSal)
                        {
                        ApplicationArea = All;
                            Caption = 'Wedge''s Concept';
                            TableRelation = "Conceptos salariales";
                        }
                        group(Control1000000005)
                        {
                            ShowCaption = false;
                            field(Cell3; Cell3)
                            {
                            ApplicationArea = All;
                                Caption = 'Employee code cell';
                            }
                            field(Cell1; Cell1)
                            {
                            ApplicationArea = All;
                                Caption = 'Quantity Cell';
                            }
                            field(Cell2; Cell2)
                            {
                            ApplicationArea = All;
                                Caption = 'Amount Cell';
                            }
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
        ExcelBuf: Record "Excel Buffer";
        PerfilSal: Record "Perfil Salarial";
        Celda: Code[5];
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Window: Dialog;
        Description: Text[50];
        Qty: Decimal;
        Amt: Decimal;
        CodEmpleado: Code[20];
        Cell1: Code[5];
        Cell2: Code[5];
        Text0001: Label 'aaa';
        Text007: Label 'Analyzing Data...\\';
        Cell3: Code[5];
        TotalRecNo: Integer;
        RecNo: Integer;
        Text006: Label 'Import Excel File';
        NoLin: Integer;
        CodProd: Code[20];
        ConceptoSal: Code[20];

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
                if Celda = Cell1 then begin
                    Evaluate(Qty, ExcelBuf."Cell Value as Text");
                    Cell1 := IncStr(Cell1);
                end
                else
                    if Celda = Cell2 then begin
                        Evaluate(Amt, ExcelBuf."Cell Value as Text");
                        Cell2 := IncStr(Cell2);
                    end
                    else
                        if Celda = Cell3 then begin
                            CodEmpleado := ExcelBuf."Cell Value as Text";
                            CodEmpleado := DelChr(CodEmpleado, '=', ', .');
                            Cell3 := IncStr(Cell3);
                        end;

                //    MESSAGE('%1 %2 %3 %4 %5 %6 %7 %8',CodEmpleado,Qty,Amt,Celda,Cell1,Cell2,Cell3);

                if CodEmpleado <> '' then begin
                    PerfilSal.Reset;
                    PerfilSal.SetRange("No. empleado", CodEmpleado);
                    PerfilSal.SetRange("Concepto salarial", ConceptoSal);
                    if PerfilSal.FindFirst then begin
                        if Cell1 <> '' then
                            PerfilSal.Validate(Cantidad, Qty);

                        if (Cell2 <> '') and (Cell1 = '') then begin
                            PerfilSal.Validate(Cantidad, 1);
                            if PerfilSal."Formula calculo" = '' then
                                PerfilSal.Validate(Importe, Amt);
                        end
                        else
                            if Cell2 <> '' then begin
                                PerfilSal.Validate(Cantidad, Qty);
                                if PerfilSal."Formula calculo" = '' then
                                    PerfilSal.Validate(Importe, Amt);
                            end;

                        PerfilSal.Modify;
                    end;
                end;
            until ExcelBuf.Next = 0;

        Window.Close;
    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
        ExcelFileExtensionTok: Label '.xlsx', Locked = true;
    begin
        /*        UploadedFileName := FileMgt.UploadFile(Text006, ExcelFileExtensionTok); */
        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;
}

