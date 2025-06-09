report 56136 "Control Ventas"
{
    // 001 #139 RRT 27.12.2013 -> Para no crear una nueva clave sustituyo el orden original de la tabla "Value entry"
    //              SORTING(Item Category Code,Item No.,Valuation Date,Location Code,Variant Code,Drop Shipment) por
    //              SORTING(Item No.,Valuation Date,Location Code,Variant Code,Drop Shipment)

    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Item Category Code");
            RequestFilterFields = "No.", "Item Category Code";
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Valuation Date", "Location Code", "Variant Code", "Drop Shipment") ORDER(Ascending);
                RequestFilterFields = "Cod. Oferta", "Item No.", "Location Code", "Document No.", "Posting Date", "Salespers./Purch. Code";

                trigger OnAfterGetRecord()
                begin
                    //Filtro para Año Actual
                    Cant += "Invoiced Quantity" * -1;
                    VentasBrutas += "Sales Amount (Actual)";
                    Dto += "Discount Amount" * -1;
                    Valor += "Sales Amount (Actual)";
                    Costo += "Cost Amount (Actual)" * -1;

                    /*CantConsig         := 0;
                    VentasBrutasConsig := 0;
                    ValorConsig        := 0;
                    CostoConsig        := 0;
                    */

                end;

                trigger OnPostDataItem()
                begin

                    //Filtro para Año Anterior
                    rVE.Reset;
                    rVE.SetCurrentKey("Gen. Bus. Posting Group", "Item No.", "Location Code", "Document No.", "Posting Date", "Salespers./Purch. Code",
                                      "Source No.");
                    rVE.CopyFilters("Value Entry");
                    rVE.SetRange("Posting Date", CalcDate('-1' + CalcFecha, FechaIni), CalcDate('-1' + CalcFecha, FechaFin));
                    if rVE.Find('-') then
                        repeat
                            CantAnt += rVE."Invoiced Quantity" * -1;
                            VentasBrutasAnt += rVE."Sales Amount (Actual)";
                            DtoAnt += rVE."Discount Amount" * -1;
                            ValorAnt += rVE."Sales Amount (Actual)";
                            CostoAnt += rVE."Cost Amount (Actual)" * -1;
                        until rVE.Next = 0;

                    //Busco las lineas a consignacion
                    rSalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
                    rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::Order);
                    rSalesLine.SetRange(Type, rSalesLine.Type::Item);
                    rSalesLine.SetRange("No.", Item."No.");
                    rSalesLine.SetRange("Shipment Date", 0D, FechaFin);
                    //rSalesLine.SETRANGE("Tipo pedido",1); //Consignacion
                    rSalesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
                    rSalesLine.SetFilter("Location Code", GetFilter("Location Code"));
                    if rSalesLine.Find('-') then
                        repeat
                            CantConsig += rSalesLine."Outstanding Quantity";
                            VentasBrutasConsig += rSalesLine."Outstanding Amount" + rSalesLine."Line Discount Amount";
                            ValorConsig += rSalesLine."Outstanding Amount";
                            CostoConsig += rSalesLine."Unit Cost" * rSalesLine."Outstanding Quantity";
                        until rSalesLine.Next = 0;
                end;

                trigger OnPreDataItem()
                begin
                    FechaIni := GetRangeMin("Posting Date");
                    FechaFin := GetRangeMax("Posting Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                //GRN To open Excel
                /*           TempExcelBuffer.CreateBookAndOpenExcel('', Text010, '', CompanyName, UserId); */
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                TempExcelBuffer.DeleteAll;
                Clear(TempExcelBuffer);

                //GRN Header Information from Company Info
                EnterCell(1, 1, UpperCase(CompanyName), true, false, false);
                EnterCell(2, 1, UpperCase(Text000), false, false, false);
                EnterCell(3, 1, UpperCase(GetFilters), false, false, false);

                //Header Information for Detail
                EnterCell(5, 1, Text001, true, false, false);
                EnterCell(5, 8, Text002, true, false, false);
                EnterCell(5, 13, Text003, true, false, false);
                EnterCell(6, 1, Text004, true, false, false);
                EnterCell(6, 2, Text005, true, false, false);
                EnterCell(6, 3, Text006, true, false, false);
                EnterCell(6, 4, Text007, true, false, false);
                EnterCell(6, 5, Text008, true, false, false);
                EnterCell(6, 7, Text005, true, false, false);
                EnterCell(6, 8, Text006, true, false, false);
                EnterCell(6, 9, Text007, true, false, false);
                EnterCell(6, 10, Text008, true, false, false);
                EnterCell(6, 12, Text005, true, false, false);
                EnterCell(6, 13, Text006, true, false, false);
                EnterCell(6, 14, Text007, true, false, false);
                EnterCell(6, 15, Text008, true, false, false);

                LineNo := 6;
                Clear(FechaIni);

                CounterTotal := Count;
                Window.Open(Text009);
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        rVE: Record "Value Entry";
        rSalesLine: Record "Sales Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FechaIni: Date;
        FechaFin: Date;
        Text009: Label 'Processing Item  #1########## @2@@@@@@@@@@@@@';
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

