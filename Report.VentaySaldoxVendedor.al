report 56120 "Venta y Saldo x Vendedor"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                CalcFields = "Original Amt. (LCY)", "Remaining Amt. (LCY)";
                DataItemLink = "Salesperson Code" = FIELD(Code);
                DataItemTableView = SORTING("Salesperson Code", "Posting Date") WHERE("Document Type" = FILTER(Invoice | "Credit Memo"));

                trigger OnAfterGetRecord()
                begin
                    rCust.Get("Customer No.");
                    CalcFields("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                    "TMP: Ventas x Vend. - Zona"."Cod. Vendedor" := "Salesperson Code";
                    "TMP: Ventas x Vend. - Zona"."Cod. Zona" := rCust."Service Zone Code";
                    "TMP: Ventas x Vend. - Zona"."Monto Original" := "Original Amt. (LCY)";
                    "TMP: Ventas x Vend. - Zona"."Monto Pendiente" := "Remaining Amt. (LCY)";
                    "TMP: Ventas x Vend. - Zona"."Entry No." := "Entry No.";
                    "TMP: Ventas x Vend. - Zona".Insert;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", FechaIni, FechaFin);
                    SetRange("Date Filter", FechaIni, FechaFin);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, Code);
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                "TMP: Ventas x Vend. - Zona".DeleteAll;

                CounterTotal := Count;
                Window.Open(Text007);
            end;
        }
        dataitem("TMP: Ventas x Vend. - Zona"; "TMP: Ventas x Vend. - Zona")
        {
            DataItemTableView = SORTING("Cod. Vendedor", "Cod. Zona", "Entry No.");

            trigger OnPostDataItem()
            begin
                //GRN To open Excel
                /*       TempExcelBuffer.CreateBookAndOpenExcel('', Text006, '', CompanyName, UserId); */
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                NoCol := SZ.Count;

                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);

                //GRN Header Information from Company Info
                EnterCell(1, 1, UpperCase(CompanyName), true, false, false);
                EnterCell(2, 1, UpperCase(Text000), false, false, false);
                txtFiltro := UpperCase(GetFilters) + ', ' + Text011 + ' ' + Format(FechaIni) + '..' + Format(FechaFin);

                EnterCell(3, 1, txtFiltro, false, false, false);

                //Header Information for Detail
                EnterCell(5, 1, Text004, true, false, false);
                //EnterCell(5,02,Text001,TRUE,FALSE,FALSE);

                NoCol := 4;
                SZ.Find('-');
                repeat
                    EnterCell(5, NoCol, SZ.Description, true, false, false);
                    EnterCell(6, NoCol, Text001, true, false, false);
                    EnterCell(6, NoCol + 1, Text002, true, false, false);
                    Columna[NoCol] := SZ.Code;
                    NoCol += 2;
                until SZ.Next = 0;

                LineNo := 6;
                Clear(FechaIni);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FechaIni; FechaIni)
                {
                ApplicationArea = All;
                    Caption = 'Fecha inicial';
                }
                field(FechaFin; FechaFin)
                {
                ApplicationArea = All;
                    Caption = 'Fecha Final';
                }
                field(IdiomaOffice; IdiomaOffice)
                {
                ApplicationArea = All;
                    Caption = 'Idioma Office';
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

    trigger OnPostReport()
    begin
        "TMP: Ventas x Vend. - Zona".DeleteAll;
    end;

    var
        CompanyInfo: Record "Company Information";
        rCust: Record Customer;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        SZ: Record "Service Zone";
        Index: Integer;
        Index2: Integer;
        Text000: Label 'Report of Sales and Balance by Salesman';
        LineNo: Integer;
        Text001: Label 'Sale';
        Text002: Label 'Pending';
        Text004: Label 'Salesperson';
        Text005: Label 'TOTAL';
        Text006: Label 'SalesbySalesPerson';
        Text011: Label 'Dates Filter';
        DivisaLocal: Boolean;
        LinIni: Integer;
        LinFin: Integer;
        IdiomaOffice: Option English,"Español";
        Columna: array[50] of Code[20];
        Importe: array[50] of Decimal;
        Pendiente: array[50] of Decimal;
        i: Integer;
        FechaIni: Date;
        FechaFin: Date;
        txtFiltro: Code[800];
        NoCol: Integer;
        Filtro: Text[150];
        Window: Dialog;
        Counter: Integer;
        Text007: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        CounterTotal: Integer;
        VendAnt: Code[10];

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[150]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean)
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

    local procedure EnterFormula(RowNo: Integer; ColumnNo: Integer; CellValue: Text[150]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean; Formula: Text[250])
    begin
        TempExcelBuffer.Init;
        TempExcelBuffer.Validate("Row No.", RowNo);
        TempExcelBuffer.Validate("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := Formula;
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.Insert;
    end;
}

