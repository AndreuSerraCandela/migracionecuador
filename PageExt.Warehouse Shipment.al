pageextension 50120 pageextension50120 extends "Warehouse Shipment"
{
    layout
    {
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        addafter("Sorting Method")
        {
            field("No. Serie NCF Remision"; rec."No. Serie NCF Remision")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Remission Series No.';

                trigger OnValidate()
                begin
                    //001
                    rec.CalcFields("Siguiente No. NCF Rem.");
                    ProximoNo := (rec."Siguiente No. NCF Rem.");
                    ProximoNo := IncStr(ProximoNo);
                    //001
                end;
            }
            field(ProximoNo; ProximoNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next Correlative No.';
                Editable = false;
            }
            field("No. Serie NCF Factura"; rec."No. Serie NCF Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Establecimiento Factura"; rec."Establecimiento Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision Factura"; rec."Punto de Emision Factura")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ProximoNo_Fact; ProximoNo_Fact)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Next Correlative No.';
                Editable = false;
            }
        }
        addafter("Shipment Method Code")
        {
            field("Fecha inicio transporte"; rec."Fecha inicio transporte")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha fin transporte"; rec."Fecha fin transporte")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify("Re&open")
        {
            ToolTip = 'Reopen the document for additional warehouse activity.';
        }
        modify("Autofill Qty. to Ship")
        {
            Caption = 'Autofill Qty. to Ship';
        }
        modify("Delete Qty. to Ship")
        {
            Caption = 'Delete Qty. to Ship';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
    }

    var
        "***Santillana***": Integer;
        ProximoNo: Code[20];
        ProximoNo_Fact: Code[20];
        SH: Record "Sales Header";
        WSL: Record "Warehouse Shipment Line";
        WHSL: Record "Warehouse Shipment Line";
        TH: Record "Transfer Header";
        NoSeries: Record "No. Series";
        NoSeries2: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        Location: Record Location;
        WSH: Record "Warehouse Shipment Header";


    trigger OnAfterGetRecord()
    var
        ProximoNo: Code[20];
        ProximoNo_Fact: Code[20];
    begin
        // Inicializar variables
        ProximoNo := '';
        ProximoNo_Fact := '';

        // Buscar si el pedido tiene reservado el No. de Comprobante Fiscal
        WSL.Reset;
        WSL.SetRange("No.", rec."No.");
        if WSL.FindFirst then begin
            if WSL."Source Document" = WSL."Source Document"::"Sales Order" then
                if SH.Get(1, WSL."Source No.") then
                    if SH."No. Comprobante Fiscal" <> '' then
                        ProximoNo_Fact := SH."No. Comprobante Fiscal";
        end;

        // Calcular el siguiente número de NCF Remisión
        rec.CalcFields("Siguiente No. NCF Rem.");
        ProximoNo := rec."Siguiente No. NCF Rem.";
        ProximoNo := IncStr(ProximoNo);

        // Si no hay un No. de Comprobante Fiscal, calcular el siguiente número de NCF Factura
        if ProximoNo_Fact = '' then begin
            rec.CalcFields("Siguiente No. NCF Fact.");
            ProximoNo_Fact := rec."Siguiente No. NCF Fact.";
            ProximoNo_Fact := IncStr(ProximoNo_Fact);
        end;
    end;

    trigger OnOpenPage()
    begin
        // Validar si el usuario es un empleado de almacén
        rec.ErrorIfUserIsNotWhseEmployee;

        // Procesar líneas de envío de almacén
        WHSL.Reset;
        WHSL.SetRange("No.", rec."No.");
        if WHSL.FindSet then
            repeat
                if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                    // Obtener la ubicación
                    rec.GetLocation(rec."Location Code");

                    // Configurar series de documentos para Factura y Remisión
                    NoSeries.Reset;
                    NoSeries.SetRange("Tipo Documento", NoSeries."Tipo Documento"::Factura);
                    NoSeries.SetRange("Cod. Almacen", SH."Location Code");
                    if NoSeries.FindFirst then;

                    NoSeries2.Reset;
                    NoSeries2.SetRange("Tipo Documento", NoSeries2."Tipo Documento"::Remision);
                    NoSeries2.SetRange("Cod. Almacen", SH."Location Code");
                    if NoSeries2.FindFirst then begin
                        NoSeriesLine.Reset;
                        NoSeriesLine.SetRange("Series Code", NoSeries2.Code);
                        if NoSeriesLine.FindFirst then;

                        WSH.Reset;
                        WSH.SetRange("No.", rec."No.");
                        if WSH.FindSet then;

                        // Asignar valores a la cabecera de envío de almacén
                        WSH."No. Serie NCF Factura" := NoSeries.Code;
                        WSH."No. Serie NCF Remision" := NoSeries2.Code;
                        WSH."Establecimiento Factura" := NoSeriesLine.Establecimiento;
                        WSH."Punto de Emision Factura" := NoSeriesLine."Punto de Emision";
                        WSH.Validate("Shipping Agent Code", Location."Cod. Transportista");
                        WSH.Validate("Fecha inicio transporte", WorkDate);
                        WSH.Validate("Fecha fin transporte", CalcDate(Location."Outbound Whse. Handling Time", WorkDate));
                        WSH.Modify;

                        // Actualizar valores en la cabecera de ventas
                        SH."No. Serie NCF Facturas" := WSH."No. Serie NCF Factura";
                        SH."No. Serie NCF Remision" := WSH."No. Serie NCF Remision";
                        SH."Establecimiento Factura" := WSH."Establecimiento Factura";
                        SH."Punto de Emision Factura" := WSH."Punto de Emision Factura";
                        SH.Modify;
                    end;
                end;

                // Procesar transferencias
                if TH.Get(WHSL."Source No.") then begin
                    TH.Validate(TH."No. Serie Comprobante Fiscal", rec."No. Serie NCF Remision");
                    TH.Modify;
                end;
            until WHSL.Next = 0;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}

