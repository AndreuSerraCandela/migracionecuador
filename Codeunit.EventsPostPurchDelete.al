codeunit 55025 "Events PostPurch-Delete"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PostPurch-Delete", 'OnBeforeInitDeleteHeader', '', false, false)]
    local procedure OnBeforeInitDeleteHeader(var PurchHeader: Record "Purchase Header")
    begin
        //DSLoc1.04
        IF PurchHeader."No. Serie NCF Facturas" = '' THEN
            PurchHeader."No. Comprobante Fiscal" := '';

        PurchHeader."No. Comprobante Fiscal Rel." := '';
    end;

    /*
     DSLoc1.04  JPG 22-11-2021  no llevar ncf a historico borrador eliminados
    */
}