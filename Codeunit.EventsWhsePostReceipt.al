codeunit 55041 "Events Whse.-Post Receipt"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCode', '', false, false)]
    local procedure OnAfterCode(WarehouseReceiptLine: Record "Warehouse Receipt Line")
    begin
        // #967 - Lo vaciamos para evitar que el usuario vuelva a duplicar el mismo numero de
        // documento en caso de recepciones parciales
        WarehouseReceiptLine.MODIFYALL("Nº Documento Proveedor", '');
        // #967
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterWhseRcptLineSetFilters', '', false, false)]
    local procedure OnAfterWhseRcptLineSetFilters(WarehouseReceiptLine: Record "Warehouse Receipt Line")
    begin
        if WarehouseReceiptLine.Find('-') then
            repeat
                // #967
                IF (WarehouseReceiptLine."Nº Documento Proveedor" = '') AND (WarehouseReceiptLine."Qty. to Receive" <> 0) THEN
                    LinSinNoDoc := TRUE;
            // #967
            until WarehouseReceiptLine.Next() = 0;

        // #967
        IF LinSinNoDoc THEN
            IF NOT CONFIRM(Text005, FALSE) THEN
                ERROR(Text006);
        // #967
    end;

    //Pendiente en el metodo InitSourceDocumentHeader quitar los metodos SetCalledFromWhseDoc

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostedWhseRcptLineInsert', '', false, false)]
    local procedure OnBeforePostedWhseRcptLineInsert(WarehouseReceiptLine: Record "Warehouse Receipt Line"; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        rPurchHeader: Record "Purchase Header";
    begin
        // #967
        IF WarehouseReceiptLine."Source Document" = WarehouseReceiptLine."Source Document"::"Purchase Order" THEN
            IF rPurchHeader.GET(rPurchHeader."Document Type"::Order, WarehouseReceiptLine."Source No.") THEN BEGIN
                PostedWhseReceiptLine."Nº Proveedor" := rPurchHeader."Buy-from Vendor No.";
            END;
        // #967
    end;



    var
        //Traducción Frances Text001
        Text004: Label 'is not within your range of allowed posting dates';//ESM=no est  dentro del periodo de fechas de registro permitidas;FRC=n''est pas dans l''intervalle de dates de report permis;ENC=is not within your range of allowed posting dates';
        Text005: Label 'Se han encontrado líneas sin Número Documento Proveedor\¨Desea Continuar?';
        Text006: Label 'Proceso cancelado a petición del usuario';
        LinSinNoDoc: Boolean;

    /*
  Proyecto: Implementacion Microsoft Dynamics Nav
  AMS     : Agustin Mendez
  GRN     : Guillermo Roman
  AML     : Toni Moll
  ------------------------------------------------------------------------
  No.     Fecha           Firma         Descripcion
  ------------------------------------------------------------------------
  #967    11/12/2013      AML         #967 - Formato ingresos Bodega
    */
}