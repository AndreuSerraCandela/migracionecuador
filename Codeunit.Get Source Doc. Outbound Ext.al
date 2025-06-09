codeunit 55040 "Get Source Doc. Outbound Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnAfterFindWarehouseRequestForSalesOrder', '', false, false)]
    local procedure OnAfterFindWarehouseRequestForSalesOrderHandler(var WarehouseRequest: Record "Warehouse Request"; SalesHeader: Record "Sales Header")
    var
        WSL: Record "Warehouse Shipment Line";
        WSH: Record "Warehouse Shipment Header";
        WHSL: Record "Warehouse Shipment Line";
        SH: Record "Sales Header";
        TH: Record "Transfer Header";
        NoSeries: Record "No. Series";
        NoSeries2: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        Location: Record Location;
    begin
        WHSL.Reset();
        WHSL.SetRange("Source No.", SalesHeader."No.");
        WHSL.SetRange("Source Subtype", SalesHeader."Document Type");
        if WHSL.FindSet() then
            repeat
                if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                    GetLocation(SH."Location Code", Location);

                    WSH.Reset();
                    WSH.SetRange("No.", WHSL."No.");
                    if WSH.FindSet() then begin
                        WSH.Validate("Shipping Agent Code", Location."Cod. Transportista");
                        WSH.Validate("Fecha inicio transporte", WorkDate);
                        WSH.Validate("Fecha fin transporte", CalcDate(Location."Outbound Whse. Handling Time", WorkDate));
                        NoSeries.Reset();
                        NoSeries.SetRange("Tipo Documento", NoSeries."Tipo Documento"::Factura);
                        NoSeries.SetRange("Cod. Almacen", SH."Location Code");
                        if NoSeries.FindFirst() then;
                        NoSeries2.Reset();
                        NoSeries2.SetRange("Tipo Documento", NoSeries2."Tipo Documento"::Remision);
                        NoSeries2.SetRange("Cod. Almacen", SH."Location Code");
                        if NoSeries2.FindFirst() then begin
                            NoSeriesLine.Reset();
                            NoSeriesLine.SetRange("Series Code", NoSeries.Code);
                            if NoSeriesLine.FindFirst() then;
                            WSH."No. Serie NCF Factura" := NoSeries.Code;
                            WSH."No. Serie NCF Remision" := NoSeries2.Code;
                            WSH."Establecimiento Factura" := NoSeriesLine.Establecimiento;
                            WSH."Punto de Emision Factura" := NoSeriesLine."Punto de Emision";
                            SH.Validate("No. Serie NCF Facturas", WSH."No. Serie NCF Factura");
                            SH.Validate("No. Serie NCF Remision", WSH."No. Serie NCF Remision");
                            SH.Validate("Establecimiento Factura", WSH."Establecimiento Factura");
                            SH.Validate("Punto de Emision Factura", WSH."Punto de Emision Factura");
                            SH.Modify();
                        end;
                    end;

                    if TH.Get(WHSL."Source No.") then begin
                        TH.Validate("No. Serie Comprobante Fiscal", WSH."No. Serie NCF Remision");
                        TH.Modify();
                    end;

                    WSH.Modify();
                end;
            until WHSL.Next() = 0;
    end;

    local procedure GetLocation(LocationCode: Code[10]; var Location: Record Location)
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}
