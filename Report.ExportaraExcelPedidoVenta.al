report 56002 "Exportar a Excel Pedido Venta"
{
    //  Proyecto: Implementacion Microsoft Dynamics Nav
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  001     15-22-2023       LDP      SANTINAV-4179

    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {

            trigger OnAfterGetRecord()
            begin

                SalesLine.Reset;
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst then begin
                    repeat
                        if PrintToExcel then
                            MakeExcelSalesLineDataBody;
                    until SalesLine.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SHNo := GetFilter("No.");
                //MakeExcelSalesHeaderDataHeader;
                MakeExcelSalesHeaderDataBody;
                MakeExcelSalesLineDataHeader;
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

    trigger OnInitReport()
    begin
        PrintToExcel := true;
    end;

    trigger OnPostReport()
    begin
        if PrintToExcel then
            CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll;
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        PrintToExcel: Boolean;
        Text007: Label 'Reporte Pedido Venta Excel';
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SHNo: Code[20];

    local procedure MakeExcelSalesHeaderDataHeader()
    begin
        ExcelBuffer.AddColumn("Sales Header".FieldCaption("No."), false, '', true, false, true, '25', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header".FieldCaption("Sell-to Customer No."), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Sales Header".FieldCaption("Sell-to Customer Name"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelSalesHeaderDataBody()
    begin
        SalesHeader.SetRange("No.", SHNo);
        if SalesHeader.FindFirst then;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Sales Header".FieldCaption("No."), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Sales Header".FieldCaption("Sell-to Customer No."), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Sell-to Customer No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Sales Header".FieldCaption("Sell-to Customer Name"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Sell-to Customer Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
    end;

    local procedure MakeExcelSalesLineDataHeader()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(SalesLine.FieldCaption(Type), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("No."), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption(Description), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("Cantidad Solicitada"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption(Quantity), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("Porcentaje Cant. Aprobada"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("Location Code"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("Unit Price"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("Amount Including VAT"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption("Line Discount %"), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.FieldCaption(Amount), false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
    end;


    procedure MakeExcelSalesLineDataBody()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(SalesLine.Type, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Cantidad Solicitada", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Porcentaje Cant. Aprobada", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Location Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Unit Price", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Amount Including VAT", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine."Line Discount %", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesLine.Amount, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelInfo()
    begin
    end;


    procedure CreateExcelBook()
    begin
        /*         ExcelBuffer.CreateBookAndOpenExcel('', Text007, Text007, CompanyName, UserId); */
        Error('');
    end;
}

