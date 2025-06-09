report 56119 "Control Ventas 2"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("Customer Posting Group");
            RequestFilterFields = "Customer Posting Group", "No.";
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Source No." = FIELD("No.");
                DataItemTableView = SORTING("Source Type", "Source No.", "Cod. Oferta", "Posting Date") WHERE("Source Type" = FILTER(Customer));
                RequestFilterFields = "Source No.", "Cod. Oferta", "Item No.", "Location Code", "Document No.", "Posting Date", "Salespers./Purch. Code";

                trigger OnAfterGetRecord()
                begin
                    //Filtro para Año Actual
                    Cant += "Invoiced Quantity" * -1;
                    VentasBrutas += "Sales Amount (Actual)";
                    Dto += "Discount Amount" * -1;
                    Valor += "Sales Amount (Actual)";
                    Costo += "Cost Amount (Actual)" * -1;

                    if Detallado then begin
                        LineNo += 1;
                        if not rItem.Get("Item No.") then
                            rItem.Init;
                        EnterCell(LineNo, 1, "Item No.", false, false, false);
                        EnterCell(LineNo, 2, rItem.Description, false, false, false);
                        EnterCell(LineNo, 5, Format("Invoiced Quantity"), false, false, false);
                        EnterCell(LineNo, 6, Format("Sales Amount (Actual)" + "Discount Amount"), false, false, false);
                        EnterCell(LineNo, 7, Format("Sales Amount (Actual)"), false, false, false);
                        EnterCell(LineNo, 8, Format("Cost Amount (Actual)"), false, false, false);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    FechaIni := GetRangeMin("Posting Date");
                    FechaFin := GetRangeMax("Posting Date");
                    if PrimeraVezD then begin
                        PrimeraVezD := false;
                        EnterCell(3, 1, UpperCase(Customer.GetFilters) + ', ' + UpperCase(GetFilters), false, false, false);
                    end;

                    //CurrReport.CreateTotals(Cant, VentasBrutas, Valor, Costo, Dto, CantAnt, VentasBrutasAnt, ValorAnt, CostoAnt, DtoAnt);
                    //CurrReport.CreateTotals(CantConsig, VentasBrutasConsig, ValorConsig, CostoConsig);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not PrimeraVez then begin
                    Counter := Counter + 1;
                    Window.Update(1, "No.");
                    Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                //GRN To open Excel
                /*                 TempExcelBuffer.CreateBookAndOpenExcel('', Text010, '', CompanyName, UserId); */
            end;

            trigger OnPreDataItem()
            begin
                PrimeraVez := true;
                PrimeraVezD := true;
                CompanyInfo.Get();
                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);
                CounterTotal := Count;

                if PrimeraVez then begin
                    PrimeraVez := false;

                    //GRN Header Information from Company Info
                    EnterCell(1, 1, UpperCase(CompanyName), true, false, false);
                    EnterCell(2, 1, UpperCase(Text000), false, false, false);
                    //GRN    EnterCell(3,1,UPPERCASE(GETFILTERS),FALSE,FALSE,FALSE);

                    //Header Information for Detail
                    EnterCell(5, 1, Text001, true, false, false);
                    EnterCell(5, 13, Text002, true, false, false);
                    EnterCell(5, 18, Text003, true, false, false);

                    EnterCell(6, 1, Text004, true, false, false);

                    EnterCell(6, 5, Text005, true, false, false);
                    EnterCell(6, 6, Text006, true, false, false);
                    EnterCell(6, 7, Text007, true, false, false);
                    EnterCell(6, 8, Text008, true, false, false);

                    EnterCell(6, 10, Text005, true, false, false);
                    EnterCell(6, 11, Text006, true, false, false);
                    EnterCell(6, 12, Text007, true, false, false);
                    EnterCell(6, 13, Text008, true, false, false);

                    EnterCell(6, 15, Text005, true, false, false);
                    EnterCell(6, 16, Text006, true, false, false);
                    EnterCell(6, 17, Text007, true, false, false);
                    EnterCell(6, 18, Text008, true, false, false);

                    LineNo := 6;
                    Clear(FechaIni);


                    Window.Open(Text009);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Detallado; Detallado)
                {
                ApplicationArea = All;
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
        CompanyInfo: Record "Company Information";
        rCust: Record Customer;
        rVE: Record "Value Entry";
        rSalesLine: Record "Sales Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        rItem: Record Item;
        FechaIni: Date;
        FechaFin: Date;
        Text009: Label 'Processing Customer  #1########## @2@@@@@@@@@@@@@';
        Text010: Label 'Sales Control';
        Text000: Label 'Sales Control';
        Text001: Label 'Current Year Sales';
        Text002: Label 'Last Year Sales';
        Text003: Label 'Consignation''s Sales';
        Text004: Label 'Name';
        Text005: Label 'Quantity';
        Text006: Label 'GROSS Sales';
        Text007: Label 'Value';
        Text008: Label 'COST';
        CalcFecha: Label 'Y';
        GpoContAnt: Code[20];
        Cant: Decimal;
        VentasBrutas: Decimal;
        Valor: Decimal;
        Costo: Decimal;
        CantAnt: Decimal;
        VentasBrutasAnt: Decimal;
        ValorAnt: Decimal;
        CostoAnt: Decimal;
        CantConsig: Decimal;
        VentasBrutasConsig: Decimal;
        ValorConsig: Decimal;
        CostoConsig: Decimal;
        LineNo: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        Dto: Decimal;
        DtoAnt: Decimal;
        DtoConsig: Decimal;
        Detallado: Boolean;
        PrimeraVez: Boolean;
        PrimeraVezD: Boolean;

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
}

