report 76002 "Crea ED Empleados"
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

                ExcelBuf.Find('-');

                Evaluate(Fila, CopyStr(Cell1, 2, 5));

                // MESSAGE('%1 %2',Cell1);

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
                        field("Nombre fichero"; FileName)
                        {
                        ApplicationArea = All;
                            Caption = 'Workbook File Name';

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
                                /*                SheetName := ExcelBuf.SelectSheetsName(UploadedFileName) */
                            end;
                        }
                        group(Control1000000005)
                        {
                            ShowCaption = false;
                            field(Cell1; Cell1)
                            {
                            ApplicationArea = All;
                                Caption = 'Employee code Cell';
                            }
                            field(Cell2; Cell2)
                            {
                            ApplicationArea = All;
                                Caption = 'G/L Account Cell';
                            }
                            field(Cell3; Cell3)
                            {
                            ApplicationArea = All;
                                Caption = 'Amount Cell';
                            }
                            field(Cell4; Cell4)
                            {
                            ApplicationArea = All;
                                Caption = 'Dimension Code Cell';
                            }
                            field(Cell5; Cell5)
                            {
                            ApplicationArea = All;
                                Caption = 'Dimension Value Cell';
                            }
                            field(Cell6; Cell6)
                            {
                            ApplicationArea = All;
                                Caption = 'Balance Account';
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
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        Emp: Record Employee;
        DefDim: Record "Default Dimension";
        CodigoDiario: Code[20];
        CodigoSeccion: Code[20];
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
        Text003: Label '.xlsx';
        Cell3: Code[5];
        Cell4: Code[5];
        Cell5: Code[10];
        Cell6: Code[10];
        TotalRecNo: Integer;
        RecNo: Integer;
        Text006: Label 'Import Excel File';
        Text007: Label 'Analyzing Data...\\';
        NoLin: Integer;
        CodCuenta: Code[20];
        CodDim: Code[20];
        CodValorDim: Code[20];
        Fila: Integer;
        CtaContrapartida: Code[20];


    procedure RecibeParametros(CodDiario: Code[20]; CodSeccion: Code[20])
    begin
        CodigoDiario := CodDiario;
        CodigoSeccion := CodSeccion;
    end;

    local procedure ReadExcelSheet()
    begin
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
        Amt := 0;

        ExcelBuf.SetRange("Row No.", Fila, 9999999);

        if ExcelBuf.Find('-') then
            repeat

                RecNo := RecNo + 1;
                Window.Update(1, Round(RecNo / TotalRecNo * 10000, 1));
                Celda := ExcelBuf.xlColID + ExcelBuf.xlRowID;
                if Celda = Cell6 then begin
                    Evaluate(CtaContrapartida, ExcelBuf."Cell Value as Text");
                    Cell6 := IncStr(Cell6);
                end
                else
                    if Celda = Cell5 then begin
                        Evaluate(CodValorDim, ExcelBuf."Cell Value as Text");
                        Cell5 := IncStr(Cell5);
                    end
                    else
                        if Celda = Cell4 then begin
                            Evaluate(CodDim, ExcelBuf."Cell Value as Text");
                            Cell4 := IncStr(Cell4);
                        end
                        else
                            if Celda = Cell3 then begin
                                Evaluate(Amt, ExcelBuf."Cell Value as Text");
                                Cell3 := IncStr(Cell3);
                            end
                            else
                                if Celda = Cell2 then begin
                                    CodCuenta := ExcelBuf."Cell Value as Text";
                                    Cell2 := IncStr(Cell2);
                                end
                                else
                                    if Celda = Cell1 then begin
                                        CodEmpleado := ExcelBuf."Cell Value as Text";
                                        CodEmpleado := DelChr(CodEmpleado, '=', ', .');
                                        Cell1 := IncStr(Cell1);
                                    end;

                //    MESSAGE('%1 %2 %3 %4 %5 %6 %7 %8',ExcelBuf.xlRowID,CodEmpleado,Qty,Amt,Celda,Cell1,Cell2,Cell3);

                if (CodEmpleado <> '') and (CodCuenta <> '') and (Amt <> 0) and
                   (CodDim <> '') and (CodValorDim <> '') and (CtaContrapartida <> '') then begin
                    Emp.Get(CodEmpleado);
                    GenJnlLine2.Reset;
                    GenJnlLine2.SetRange("Journal Template Name", CodigoDiario);
                    GenJnlLine2.SetRange("Journal Batch Name", CodigoSeccion);
                    if not GenJnlLine2.FindLast then
                        GenJnlLine2."Line No." := 0;

                    NoLin := GenJnlLine2."Line No." + 1000;

                    Clear(GenJnlLine);
                    GenJnlLine."Journal Template Name" := CodigoDiario;
                    GenJnlLine."Journal Batch Name" := CodigoSeccion;
                    GenJnlLine."Line No." := NoLin;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine.Validate("Account No.", CodCuenta);
                    GenJnlLine.Validate("Posting Date", Today);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := 'NOMINA' + Format(Date2DMY(Today, 1)) + Format(Date2DMY(Today, 2)) +
                                                 Format(Date2DMY(Today, 3));
                    GenJnlLine.Description := Emp."Full Name";
                    GenJnlLine.Validate(Amount, Amt);
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine.Validate("Bal. Account No.", CtaContrapartida);

                    GenJnlLine.Insert(true);
                    /*
                            DefDim.RESET;
                            DefDim.SETRANGE("Table ID",5200);
                            DefDim.SETRANGE("No.",CodEmpleado);
                            IF DefDim.FINDSET THEN
                               REPEAT
                                CLEAR(JLD);
                                JLD."Table ID"              := 81;
                                JLD."Journal Template Name" := CodigoDiario;
                                JLD."Journal Batch Name"    := CodigoSeccion;
                                JLD."Journal Line No."      := GenJnlLine."Line No.";
                                JLD.VALIDATE("Dimension Code",DefDim."Dimension Code");
                                JLD.VALIDATE("Dimension Value Code",DefDim."Dimension Value Code");
                                JLD.INSERT(TRUE);
                               UNTIL DefDim.NEXT =0;

                             CLEAR(JLD);
                             JLD."Table ID"              := 81;
                             JLD."Journal Template Name" := CodigoDiario;
                             JLD."Journal Batch Name"    := CodigoSeccion;
                             JLD."Journal Line No."      := GenJnlLine."Line No.";
                             JLD.VALIDATE("Dimension Code",CodDim);
                             JLD.VALIDATE("Dimension Value Code",CodValorDim);
                             JLD.INSERT(TRUE);
                    */
                    Amt := 0;
                    CodEmpleado := '';
                    CodCuenta := '';
                    CodDim := '';
                    CodValorDim := '';
                end;

            until ExcelBuf.Next = 0;

        Window.Close;

    end;


    procedure UploadFile()
    var
        FileMgt: Codeunit "File Management";
        ClientFileName: Text[1024];
    begin
        /*         UploadedFileName := FileMgt.UploadFile(Text006, Text003); */
        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
    end;
}

