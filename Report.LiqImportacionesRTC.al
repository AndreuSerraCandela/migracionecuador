report 50027 "Liq. Importaciones RTC"
{
    Caption = 'Fill Import Calculation';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Order No." = FIELD("Order No.");
                DataItemTableView = SORTING("Document No.", "No.") WHERE(Type = CONST(Item), Quantity = FILTER(<> 0));
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Item No." = FIELD("No."), "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Item No.", "Posting Date");
                    dataitem("Value Entry"; "Value Entry")
                    {
                        DataItemLink = "Item Ledger Entry No." = FIELD("Entry No.");
                        DataItemTableView = SORTING("Item Ledger Entry No.", "Entry Type") WHERE("Item Charge No." = FILTER(<> ''));

                        trigger OnAfterGetRecord()
                        begin
                            case "Item Charge No." of
                                'PROD-IM-TR': //Gastos Flete
                                    ImpFlete += "Cost Amount (Actual)";
                                'PROD-IM-SG':       //Gastos Fac-Seg
                                    "ImpGastosFac-Seg" += "Cost Amount (Actual)";
                                'PROD-IM-DA': //Gastos Gestion Aduanal
                                    ImpGestAduanal += "Cost Amount (Actual)";
                                'PROD-IM-OT':      //Gastos Gravamen
                                    ImpGravamen += "Cost Amount (Actual)";
                            end;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    Importe := (Quantity * "Direct Unit Cost") * ("Line Discount %" / 100);
                    Importe := Quantity * "Direct Unit Cost" - Importe;
                    UCosto := 0;
                    Costo := 0;

                    if Item.Get("No.") then begin
                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                        ILE.SetRange("Item No.", "No.");
                        ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
                        ILE.SetRange("Variant Code", "Variant Code");
                        ILE.SetRange("Location Code", "Location Code");
                        ILE.SetRange("Posting Date", "Posting Date");
                        if ILE.FindFirst then begin
                            ILE.CalcFields("Cost Amount (Actual)");
                            Costo := Round(ILE."Cost Amount (Actual)" / ILE.Quantity, 0.01);
                        end;

                        tCosto += Costo;
                        CostoFOB += Item."Last Direct Cost";

                        ILE.Reset;
                        ILE.SetCurrentKey("Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
                        ILE.SetRange("Item No.", "No.");
                        ILE.SetRange("Entry Type", ILE."Entry Type"::Purchase);
                        ILE.SetRange("Variant Code", "Variant Code");
                        ILE.SetRange("Location Code", "Location Code");
                        ILE.SetRange("Posting Date", 0D, CalcDate('-1D', "Posting Date"));
                        if ILE.FindLast then begin
                            ILE.CalcFields("Cost Amount (Actual)");
                            UCosto := Round(ILE."Cost Amount (Actual)" / ILE.Quantity, 0.01);
                        end;
                    end;

                    MakeExcelDataBody;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Currency Code" <> '' then begin
                    ExchRate.Reset;
                    ExchRate.SetRange("Currency Code", "Currency Code");
                    ExchRate.SetRange("Starting Date", 0D, "Posting Date");
                    ExchRate.FindLast;
                    Tasa := ExchRate."Exchange Rate Amount" / "Currency Factor";
                end;
            end;

            trigger OnPostDataItem()
            begin
                //xlApp.Visible(TRUE);
                //if IsServiceTier then
                if UploadedFileName = '' then
                    UploadFile
                else
                    FileName := UploadedFileName;

                /*          TempExcelBuffer.OpenBook(FileName, SheetName);
                         TempExcelBuffer.UpdateBook(SheetName, ''); */

                TempExcelBuffer.UpdateBookStream(InSTR, SheetName, true);
            end;

            trigger OnPreDataItem()
            begin
                NoLin := 12;
                Seq := '00';
                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);

                ImpFlete := 0;
                "ImpGastosFac-Seg" := 0;
                ImpGestAduanal := 0;
                ImpGravamen := 0;

                //CurrReport.CreateTotals(ImpFlete, "ImpGastosFac-Seg", ImpGestAduanal, ImpGravamen);
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
                    field(FileName; FileName)
                    {
                    ApplicationArea = All;
                        Caption = 'Workbook File Name';

                        trigger OnAssistEdit()
                        begin
                            UploadFile;
                            //if IsServiceTier and (UploadedFileName <> '') then
                            FileName := Text003;

                            Message('a%1 b%2', FileName, UploadedFileName);
                        end;

                        trigger OnValidate()
                        begin
                            FileNameOnAfterValidate;
                        end;
                    }
                    field(SheetName; SheetName)
                    {
                    ApplicationArea = All;
                        Caption = 'Worksheet Name';
                        //Comentado OptionCaption = 'Worksheet Name';

                        trigger OnAssistEdit()
                        var
                            ExcelBuf: Record "Excel Buffer";
                        begin
                            /*              if IsServiceTier then
                                             SheetName := ExcelBuf.SelectSheetsName(UploadedFileName)
                                         else
                                             SheetName := ExcelBuf.SelectSheetsName(FileName); */
                        end;
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

    var
        ExchRate: Record "Currency Exchange Rate";
        Item: Record Item;
        ILE: Record "Item Ledger Entry";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text[250];
        UploadedFileName: Text[1024];
        SheetName: Text[250];
        Importe: Decimal;
        Tasa: Decimal;
        TotCostImp: Decimal;
        tTotal: Decimal;
        UCosto: Decimal;
        Costo: Decimal;
        tCosto: Decimal;
        CostoFOB: Decimal;
        NoCol: Integer;
        Text001: Label 'Filters';
        Text002: Label 'Update Workbook';
        Text006: Label 'MARKETING EXPENSES REPORT';
        Text007: Label 'IMPORTACION';
        Text017: Label 'Date';
        Text018: Label 'Company';
        Text019: Label 'Name';
        Text020: Label 'INFORMATION';
        Text021: Label 'Gran Total';
        NoLin: Integer;
        ColumnNo: Integer;
        ImpFlete: Decimal;
        "ImpGastosFac-Seg": Decimal;
        ImpGestAduanal: Decimal;
        ImpGravamen: Decimal;
        Seq: Code[5];
        Text003: Label 'The file was successfully uploaded to server';
        InSTR: InStream;


    procedure MakeExcelDataBody()
    begin

        NoCol := 0;
        IncrementaLin;
        IncrementaCol;
        //mESSAGE('%1 %2 %3 %4 %5',Col,NoCol,NoLin,Celda);
        Seq := IncStr(Seq);
        EnterCell(NoLin, NoCol, Seq, false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, "Purch. Rcpt. Line"."No.", false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, "Purch. Rcpt. Line".Description, false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format("Purch. Rcpt. Line".Quantity), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format("Purch. Rcpt. Line"."Unit Cost"), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format("Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Unit Cost"), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format(ImpFlete + "ImpGastosFac-Seg"), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, '=ROUND((F' + Format(NoLin) + '+G' + Format(NoLin) + '),3)', false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, '=H' + Format(NoLin) + '/D' + Format(NoLin), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format(ImpGravamen), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format(ImpGestAduanal), false, false, false);
        IncrementaCol;

        EnterCell(NoLin, NoCol, '=K' + Format(NoLin) + '+J' + Format(NoLin) + '+H' + Format(NoLin), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, '=L' + Format(NoLin) + '/D' + Format(NoLin), false, false, false);
        IncrementaCol;
        if "Purch. Rcpt. Line"."VAT %" <> 0 then
            EnterCell(NoLin, NoCol, 'SI', false, false, false)
        else
            EnterCell(NoLin, NoCol, 'NO', false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, Format("Purch. Rcpt. Line"."VAT %"), false, false, false);
        IncrementaCol;
        IncrementaCol;
        EnterCell(NoLin, NoCol, '=L' + Format(NoLin) + '+O' + Format(NoLin) + '+P' + Format(NoLin), false, false, false);
        IncrementaCol;
        EnterCell(NoLin, NoCol, '=Q' + Format(NoLin) + '/D' + Format(NoLin), false, false, false);
    end;


    procedure IncrementaCol()
    var
        x: Integer;
        i: Integer;
        c: Char;
    begin
        //Incrementa la linea para cada columna
        NoCol += 1;
    end;


    procedure IncrementaLin()
    begin
        //Incrementa la linea para cada columna
        NoLin += 1;
    end;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean)
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.Insert;
    end;


    procedure UploadFile()
    var
        CommonDialogMgt: Codeunit "File Management";
    begin
        //Comentado UploadedFileName := CommonDialogMgt.OpenFileDialog(Text002, FileName, '');
        FileName := UploadedFileName;
    end;

    local procedure FileNameOnAfterValidate()
    begin
        UploadFile;
        //if IsServiceTier and (UploadedFileName <> '') then
        FileName := Text003;
    end;
}

