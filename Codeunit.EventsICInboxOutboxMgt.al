codeunit 55033 "Events ICInboxOutboxMgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeCheckICSalesDocumentAlreadySent', '', false, false)]
    local procedure OnBeforeCheckICSalesDocumentAlreadySent(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeCheckICPurchaseDocumentAlreadySent', '', false, false)]
    local procedure OnBeforeCheckICPurchaseDocumentAlreadySent(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeOutBoxTransactionInsert', '', false, false)]
    local procedure OnBeforeOutBoxTransactionInsert(var ICOutboxTransaction: Record "IC Outbox Transaction"; SalesHeader: Record "Sales Header")
    begin
        //001+
        ICOutboxTransaction."No. Comprobante Fiscal" := SalesHeader."No. Comprobante Fiscal";
        ICOutboxTransaction."No. Comprobante Fiscal Rel." := SalesHeader."No. Comprobante Fiscal Rel.";
        ICOutboxTransaction."Punto de Emision Factura" := SalesHeader."Punto de Emision Factura";
        ICOutboxTransaction."Establecimiento Factura" := SalesHeader."Establecimiento Factura";
        ICOutboxTransaction."Tipo de Comprobante" := SalesHeader."Tipo de Comprobante";
        ICOutboxTransaction."Factura eletrónica" := TRUE;
        //001-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnAfterICOutBoxSalesHeaderTransferFields', '', false, false)]
    local procedure OnAfterICOutBoxSalesHeaderTransferFields(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesHeader: Record "Sales Header")
    begin
        //001++
        ICOutBoxSalesHeader."No. Comprobante Fiscal" := SalesHeader."No. Comprobante Fiscal";
        ICOutBoxSalesHeader."No. Comprobante Fiscal Rel." := SalesHeader."No. Comprobante Fiscal Rel.";
        ICOutBoxSalesHeader."Factura eletrónica" := TRUE;
        //001--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesInvTransOnBeforeOutboxTransactionInsert', '', false, false)]
    local procedure OnCreateOutboxSalesInvTransOnBeforeOutboxTransactionInsert(var OutboxTransaction: Record "IC Outbox Transaction")
    var
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        SalesInvHdr.Get(OutboxTransaction."Document No.");
        //001+
        OutboxTransaction."No. Comprobante Fiscal" := SalesInvHdr."No. Comprobante Fiscal";
        OutboxTransaction."No. Comprobante Fiscal Rel." := SalesInvHdr."No. Comprobante Fiscal Rel.";
        OutboxTransaction."Punto de Emision Factura" := SalesInvHdr."Punto de Emision Factura";
        OutboxTransaction."Establecimiento Factura" := SalesInvHdr."Establecimiento Factura";
        OutboxTransaction."Tipo de Comprobante" := SalesInvHdr."Tipo de Comprobante";
        OutboxTransaction."Factura eletrónica" := TRUE;
        //001+-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesInvTransOnAfterTransferFieldsFromSalesInvHeader', '', false, false)]
    local procedure OnCreateOutboxSalesInvTransOnAfterTransferFieldsFromSalesInvHeader(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesInvHdr: Record "Sales Invoice Header")
    begin
        //001+ ++
        IF ICOutBoxSalesHeader."No. Comprobante Fiscal" = '' THEN BEGIN
            ICOutBoxSalesHeader."No. Comprobante Fiscal" := SalesInvHdr."No. Comprobante Fiscal"
        END;

        IF ICOutBoxSalesHeader."No. Comprobante Fiscal Rel." = '' THEN BEGIN
            ICOutBoxSalesHeader."No. Comprobante Fiscal Rel." := SalesInvHdr."No. Comprobante Fiscal Rel.";
        END;
        ICOutBoxSalesHeader."Factura eletrónica" := TRUE;
        //001-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesCrMemoTransOnBeforeOutboxTransactionInsert', '', false, false)]
    local procedure OnCreateOutboxSalesCrMemoTransOnBeforeOutboxTransactionInsert(var OutboxTransaction: Record "IC Outbox Transaction")
    var
        SalesCrMHdr: Record "Sales Cr.Memo Header";
    begin
        SalesCrMHdr.Get(OutboxTransaction."Document No.");
        //13/Julio/2024
        //001+
        OutboxTransaction."No. Comprobante Fiscal" := SalesCrMHdr."No. Comprobante Fiscal";
        OutboxTransaction."No. Comprobante Fiscal Rel." := SalesCrMHdr."No. Comprobante Fiscal Rel.";
        OutboxTransaction."Punto de Emision Factura" := SalesCrMHdr."Punto de Emision Factura";
        OutboxTransaction."Establecimiento Factura" := SalesCrMHdr."Establecimiento Factura";
        OutboxTransaction."Tipo de Comprobante" := SalesCrMHdr."Tipo de Comprobante";
        OutboxTransaction."Factura eletrónica" := TRUE;
        //001+-
        //13/Julio/2024
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxSalesCrMemoTransOnAfterTransferFieldsFromSalesCrMemoHeader', '', false, false)]
    local procedure OnCreateOutboxSalesCrMemoTransOnAfterTransferFieldsFromSalesCrMemoHeader(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesCrMemoHdr: Record "Sales Cr.Memo Header")
    begin
        //13/Julio/2024
        //001+ ++
        IF ICOutBoxSalesHeader."No. Comprobante Fiscal" = '' THEN BEGIN
            ICOutBoxSalesHeader."No. Comprobante Fiscal" := SalesCrMemoHdr."No. Comprobante Fiscal"
        END;

        IF ICOutBoxSalesHeader."No. Comprobante Fiscal Rel." = '' THEN BEGIN
            ICOutBoxSalesHeader."No. Comprobante Fiscal Rel." := SalesCrMemoHdr."No. Comprobante Fiscal Rel."
        END;
        ICOutBoxSalesHeader."Factura eletrónica" := TRUE;
        //001-
        //13/Julio/2024
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreateOutboxPurchDocTransOnBeforeOutboxTransactionInsert', '', false, false)]
    local procedure OnCreateOutboxPurchDocTransOnBeforeOutboxTransactionInsert(var OutboxTransaction: Record "IC Outbox Transaction"; PurchaseHeader: Record "Purchase Header")
    begin
        //001+
        OutboxTransaction."No. Comprobante Fiscal" := PurchaseHeader."No. Comprobante Fiscal";
        OutboxTransaction."No. Comprobante Fiscal Rel." := PurchaseHeader."No. Comprobante Fiscal Rel.";
        OutboxTransaction."Establecimiento Factura" := PurchaseHeader.Establecimiento;
        OutboxTransaction."Punto de Emision Factura" := PurchaseHeader."Punto de Emision";
        OutboxTransaction."Tipo de Comprobante" := PurchaseHeader."Tipo de Comprobante";
        OutboxTransaction."Factura eletrónica" := TRUE;
        //001-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnCreatePurchDocumentOnBeforeSetICDocDimFilters', '', false, false)]
    local procedure OnCreatePurchDocumentOnBeforeSetICDocDimFilters(var PurchHeader: Record "Purchase Header"; var ICInboxPurchHeader: Record "IC Inbox Purchase Header")
    begin
        //001+
        PurchHeader."No. Comprobante Fiscal" := ICInboxPurchHeader."No. Comprobante Fiscal";
        PurchHeader."No. Comprobante Fiscal Rel." := ICInboxPurchHeader."No. Comprobante Fiscal Rel.";
        PurchHeader.Establecimiento := ICInboxPurchHeader.Establecimiento;
        PurchHeader."Punto de Emision" := ICInboxPurchHeader."Punto de Emision";
        PurchHeader."Tipo de Comprobante" := ICInboxPurchHeader."Tipo de Comprobante";
        PurchHeader."Factura eletrónica" := TRUE; //13/07/2024+
        PurchHeader."Vendor Invoice No." := ICInboxPurchHeader."No. Comprobante Fiscal";//001+
        //001--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeICInboxTransInsert', '', false, false)]
    local procedure OnBeforeICInboxTransInsert(ICOutboxTransaction: Record "IC Outbox Transaction"; var ICInboxTransaction: Record "IC Inbox Transaction")
    begin
        //001+
        ICInboxTransaction."No. Comprobante Fiscal" := ICOutboxTransaction."No. Comprobante Fiscal";
        ICInboxTransaction."No. Comprobante Fiscal Rel." := ICOutboxTransaction."No. Comprobante Fiscal Rel.";
        ICInboxTransaction."Establecimiento Factura" := ICOutboxTransaction."Establecimiento Factura";
        ICInboxTransaction."Punto de Emision Factura" := ICOutboxTransaction."Punto de Emision Factura";
        ICInboxTransaction."Tipo de Comprobante" := ICOutboxTransaction."Tipo de Comprobante";
        ICInboxTransaction."Factura eletrónica" := TRUE;
        //001-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", 'OnBeforeICInboxPurchHeaderInsert', '', false, false)]
    local procedure OnBeforeICInboxPurchHeaderInsert(var ICInboxPurchaseHeader: Record "IC Inbox Purchase Header"; ICOutboxSalesHeader: Record "IC Outbox Sales Header")
    begin
        //001+
        ICInboxPurchaseHeader."No. Comprobante Fiscal" := ICOutboxSalesHeader."No. Comprobante Fiscal";
        ICInboxPurchaseHeader."No. Comprobante Fiscal Rel." := ICOutboxSalesHeader."No. Comprobante Fiscal Rel.";
        ICInboxPurchaseHeader.Establecimiento := ICOutboxSalesHeader."Establecimiento Factura";
        ICInboxPurchaseHeader."Punto de Emision" := ICOutboxSalesHeader."Punto de Emision Factura";
        ICInboxPurchaseHeader."Tipo de Comprobante" := ICOutboxSalesHeader."Tipo de Comprobante";
        ICInboxPurchaseHeader."Factura eletrónica" := TRUE;//ICOutboxSalesHeader."Factura eletr¢nica";
        ICInboxPurchaseHeader."Vendor Invoice No." := ICOutboxSalesHeader."No. Comprobante Fiscal";
        //001-
    end;

    //Pendiente en metodo AssignCurrencyCodeInOutBoxDoc quitar las líneas  
    /*if ICPartner."Inbox Type" = ICPartner."Inbox Type"::"File Location" then begin
                GetGLSetup();
                CurrencyCode := GLSetup.GetCurrencyCode('');
            end;*/

    //Se eliminaron los metodos CheckICSalesDocumentAlreadySent, CheckICPurchaseDocumentAlreadySent

    /*
       Proyecto: Implementacion Business Central

       LDP: Luis Jose De La Cruz Paredes
       ------------------------------------------------------------------------
       No.       Fecha          Firma              Descripcion
       ------------------------------------------------------------------------
       001     05/06/2024     LDP                SANTINAV-5893: Intercompa¤ias- datos en pedidos de compra y devoluciones de compra
    */
}