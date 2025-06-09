codeunit 55042 "Whse Post Shipment Ext"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify', '', false, false)]
    procedure SetTransportDates(var SalesHeader: Record "Sales Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var ModifyHeader: Boolean; Invoice: Boolean)
    begin
        if (WarehouseShipmentHeader."Fecha inicio transporte" <> 0D) and (WarehouseShipmentHeader."Fecha inicio transporte" <> SalesHeader."Fecha inicio trans.") then begin
            SalesHeader."Fecha inicio trans." := WarehouseShipmentHeader."Fecha inicio transporte";
            ModifyHeader := true;
        end;
        if (WarehouseShipmentHeader."Fecha fin transporte" <> 0D) and (WarehouseShipmentHeader."Fecha fin transporte" <> SalesHeader."Fecha fin trans.") then begin
            SalesHeader."Fecha fin trans." := WarehouseShipmentHeader."Fecha fin transporte";
            ModifyHeader := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostSourceDocumentOnBeforePrintTransferShipment', '', false, false)]
    procedure PrintConsignmentTransfer(TransHeader: Record "Transfer Header")
    var
        ConfSant: Record "Config. Empresa";
        TransShptHeader: Record "Transfer Shipment Header";
    begin
        IF TransHeader."Pedido Consignacion" THEN BEGIN
            ConfSant.GET;
            IF ConfSant."ID Formato Imp. Consignacion" <> 0 THEN BEGIN
                TransShptHeader."No." := TransHeader."Last Shipment No.";
                TransShptHeader.SETRECFILTER;

                REPORT.RUNMODAL(ConfSant."ID Formato Imp. Consignacion", FALSE, FALSE, TransShptHeader);
            END;
        END;
    end;
}
