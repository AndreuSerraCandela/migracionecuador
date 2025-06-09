codeunit 55019 "Events Purch.-Post"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        //+#37039
        IF (PurchaseHeader.Invoice) AND (PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::"Return Order", PurchaseHeader."Document Type"::"Credit Memo"]) AND (NOT PurchaseHeader.Correction) THEN
            PurchaseHeader.TESTFIELD("Tipo de Comprobante");
        //-#37039

        //001
        ConfSant.GET;
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) OR (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) THEN
            IF ConfSant."Forma Pago Oblig. en Compra" THEN
                PurchaseHeader.TESTFIELD("Payment Method Code");
        //001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnAfterValidatePostingAndDocumentDate(var PurchaseHeader: Record "Purchase Header")
    var
        cRetenciones: Codeunit "Proceso Retenciones";
        RetProv: Record "Proveedor - Retencion";
        RetDoc: Record "Retencion Doc. Proveedores";
        NoSeriesLine: Record "No. Series Line";
    begin
        // #209115 MdM
        cFunMdM.ContrlFechasDocC(PurchaseHeader);

        IF GenBusPostGrp.GET(PurchaseHeader."Gen. Bus. Posting Group") THEN; //028

        //027
        ValidaReq.Documento(38, PurchaseHeader."Document Type".AsInteger(), PurchaseHeader."No.");
        ValidaReq.Dimensiones(38, PurchaseHeader."No.", 1, PurchaseHeader."Document Type".AsInteger());
        //027

        //006
        IF NOT ConfSant."Permite Compras. Importe Cero" THEN BEGIN
            IF PurchaseHeader.Status = PurchaseHeader.Status::Open THEN
                CODEUNIT.RUN(CODEUNIT::"Release Purchase Document", PurchaseHeader);
            PurchaseHeader.CALCFIELDS("Amount Including VAT");
            PurchaseHeader.TESTFIELD("Amount Including VAT");
        END;
        //006

        //007
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") AND (PurchaseHeader."No. Validar Comprobante Rel." = FALSE) THEN BEGIN
            PurchaseHeader.TESTFIELD("No. Comprobante Fiscal Rel.");
            PIH.RESET;
            PIH.SETCURRENTKEY("No. Comprobante Fiscal");
            PIH.SETRANGE("No. Comprobante Fiscal", PurchaseHeader."No. Comprobante Fiscal Rel.");
            PIH.FINDFIRST;
        END;

        //030
        VendPostingGr.GET(PurchaseHeader."Vendor Posting Group");
        IF (NOT PurchaseHeader.Correction) AND (VendPostingGr."NCF Obligatorio") AND (PurchaseHeader.Invoice) THEN
            IF PurchaseHeader."Tipo de Comprobante" <> '03' THEN
                ValidaNoAut(PurchaseHeader);
        //030


        //+032
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) OR (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") THEN
            IF PurchaseHeader."Sustento del Comprobante" = '' THEN
                ERROR(Error009);
        //-032

        //+ATS170915
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) OR (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo") THEN
            IF PurchaseHeader."Tipo de Comprobante" IN ['01', '02', '04'] THEN
                PurchaseHeader.TESTFIELD("No. Autorizacion Comprobante");
        //-032

        //007
    end;

    //Pendiente no limpiar la variable metodo RunWithCheck linea 85
    /*TempInvoicePostBufferReverseCharge.RESET;
    TempInvoicePostBufferReverseCharge.DELETEALL;
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDocDropShipment', '', false, false)]
    local procedure OnAfterPostPurchaseDocDropShipment()
    begin
        // #209115
        cFunMdM.ContrlFechasMdMTmp(1);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCalcInvoice', '', false, false)]
    local procedure OnBeforeCalcInvoice(var PurchHeader: Record "Purchase Header")
    begin
        IF VendPostingGr.GET(PurchHeader."Vendor Posting Group") THEN; //028
        IF (NOT PurchHeader.Correction) AND (NOT VendPostingGr."Permite Emitir NCF") AND (VendPostingGr."NCF Obligatorio") AND (PurchHeader.Invoice)
        AND (PurchHeader."Tipo de Comprobante" <> '00') AND (PurchHeader."Tipo de Comprobante" <> '08') AND (PurchHeader."Tipo de Comprobante" <> '11')
        AND (PurchHeader."Tipo de Comprobante" <> '13') AND (PurchHeader."Tipo de Comprobante" <> '15') AND (PurchHeader."Tipo de Comprobante" <> '16')
        AND (PurchHeader."Tipo de Comprobante" <> '17') AND (PurchHeader."Tipo de Comprobante" <> '19') AND (PurchHeader."Tipo de Comprobante" <> '20')
        AND (PurchHeader."Tipo de Comprobante" <> '21') AND (PurchHeader."Tipo de Comprobante" <> '03') AND (PurchHeader."Tipo de Comprobante" <> '41') THEN
            PurchHeader.TESTFIELD("No. Comprobante Fiscal");
    end;

    //Pendiente eliminar metodo InsertTempInvoicePostBufferReverseCharge dentro del metodo PostPurchLine (va a quitarse posterior a la version 20)

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeIsItemChargeLineWithQuantityToInvoice', '', false, false)]
    local procedure OnBeforeIsItemChargeLineWithQuantityToInvoice(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; var IsHandled: Boolean; var Result: Boolean)
    begin
        Result := PurchHeader.Invoice AND (PurchLine."Qty. to Invoice" <> 0) AND (PurchLine.Amount <> 0);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnBeforeInitAmount', '', false, false)] //Pendiente validar que mantenga funcionalidad no se puso en OnPostItemJnlLineOnBeforeCopyDocumentFields por que no tenia la cantidad a facturar
    local procedure OnPostItemJnlLineOnBeforeInitAmount(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; var ItemJnlLine: Record "Item Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        //002++
        GLSetup.Get();
        IF (GLSetup."ITBIS al costo activo") AND (PurchHeader."Tipo ITBIS" = PurchHeader."Tipo ITBIS"::"ITBIS al costo") THEN BEGIN
            IF PurchLine."Qty. to Invoice" <> 0 THEN BEGIN
                ItemJnlLine."Unit Cost" := PurchLine.Amount * (1 + PurchLine."VAT %" / 100) / PurchLine."Qty. to Invoice";//QtyToBeInvoiced;
                PurchLine."Unit Cost (LCY)" := ItemJnlLine."Unit Cost";
                PurchLine."Unit Cost" := ItemJnlLine."Unit Cost";
                PurchLine.Amount := ItemJnlLine."Unit Cost" * PurchLine."Qty. to Invoice";//QtyToBeInvoiced;
                PurchLine.MODIFY;
            END;
        END;
        //002--
    end;

    //Pendiente validar modificación de variables (PreciseTotalChargeAmt, RoundedPrevTotalChargeAmt) en PostItemChargePerOrder 
    //no hay acceso a las variables TotalPurchLine, TotalPurchLineLCY

    //Pendiente validar modificación de campos (Amount, "Amount (ACY)") en PostItemTrackingItemChargePerOrder 
    //no hay acceso a las variables NonDistrItemJnlLine, OriginalAmt para poder sobreescribir el valor de los campos 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeTestPurchLineItemCharge', '', false, false)]
    local procedure OnBeforeTestPurchLineItemCharge(PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        IF PurchaseLine."Line Discount %" <> 100 THEN
            PurchaseLine.TESTFIELD(Amount);
        PurchaseLine.TESTFIELD("Job No.", '');

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterUpdateLastPostingNos', '', false, false)]
    local procedure OnAfterUpdateLastPostingNos(var PurchHeader: Record "Purchase Header")
    begin
        if PurchHeader.Invoice then
            PurchHeader."No. Comprobante Fiscal" := ''; //DSLoc1.02
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnUpdatePostingNosOnInvoiceOnBeforeSetPostingNo', '', false, false)]
    local procedure OnUpdatePostingNosOnInvoiceOnBeforeSetPostingNo(var PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        PurchHeader."Posting No." := NoSeriesMgt.GetNextNo(PurchHeader."Posting No. Series", PurchHeader."Posting Date", TRUE);

        //$031
        IF (PurchHeader."Tipo de Comprobante" = '03') OR ((PurchHeader."Tipo de Comprobante" = '41') AND (PurchHeader."No. Comprobante Fiscal" = '')) THEN BEGIN
            PurchHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(PurchHeader."No. Serie NCF Facturas", PurchHeader."Posting Date", TRUE);
            BuscaNoAutNCF(PurchHeader."No. Serie NCF Facturas", PurchHeader);
            ValidaNoNCF(PurchHeader."No. Comprobante Fiscal", 0, PurchHeader."No. Autorizacion Comprobante");
        END;
        //$031

        //DSLoc1.01 Fo the NCF Numbering Serie
        VendPostingGr.GET(PurchHeader."Vendor Posting Group");
        IF (VendPostingGr."Permite Emitir NCF") AND (PurchHeader."No. Comprobante Fiscal" = '') THEN BEGIN
            PurchHeader.TESTFIELD("VAT Registration No.");
            IF PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice] THEN
                PurchHeader.TESTFIELD("No. Serie NCF Facturas")
            ELSE
                IF (PurchHeader."Document Type" IN [PurchHeader."Document Type"::"Credit Memo", PurchHeader."Document Type"::"Return Order"])
                AND NOT (PurchHeader.Correction) THEN
                    PurchHeader.TESTFIELD("No. Serie NCF Abonos");

            IF (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::Invoice]) AND (PurchHeader."No. Comprobante Fiscal" = '') THEN BEGIN
                PurchHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(PurchHeader."No. Serie NCF Facturas", PurchHeader."Posting Date", TRUE);
                BuscaNoAutNCF(PurchHeader."No. Serie NCF Facturas", PurchHeader);
                ValidaNoNCF(PurchHeader."No. Comprobante Fiscal", 0, PurchHeader."No. Autorizacion Comprobante");
            END
            ELSE BEGIN
                IF (PurchHeader."No. Comprobante Fiscal" = '') AND NOT (PurchHeader.Correction) THEN BEGIN
                    PurchHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(PurchHeader."No. Serie NCF Abonos", PurchHeader."Posting Date", TRUE);
                    BuscaNoAutNCF(PurchHeader."No. Serie NCF Facturas", PurchHeader);
                    ValidaNoNCF(PurchHeader."No. Comprobante Fiscal", 1, PurchHeader."No. Autorizacion Comprobante");
                END;
            END
        END;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteApprovalEntries', '', false, false)]
    local procedure OnBeforeDeleteApprovalEntries(var PurchaseHeader: Record "Purchase Header")
    var
        RetDoc: Record "Retencion Doc. Proveedores";
        RetProv: Record "Proveedor - Retencion";
        cRetenciones: Codeunit "Proceso Retenciones";
    begin
        //DSLoc1.01 Para automatizar el posteo de las retenciones
        IF PurchaseHeader."Tipo de Comprobante" = '00' THEN
            PurchaseHeader.TESTFIELD("No. Serie NCF Retencion", '')
        ELSE
            IF PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::"Credit Memo" THEN BEGIN
                RetDoc.RESET;
                RetDoc.SETRANGE("Cód. Proveedor", PurchaseHeader."Buy-from Vendor No.");
                RetDoc.SETRANGE("Tipo documento", PurchaseHeader."Document Type");
                RetDoc.SETRANGE("No. documento", PurchaseHeader."No.");
                IF RetDoc.COUNT > 0 THEN
                    cRetenciones.RUN(PurchaseHeader)
                ELSE BEGIN
                    RetProv.RESET;
                    RetProv.SETRANGE("Cód. Proveedor", PurchaseHeader."Buy-from Vendor No.");
                    IF RetProv.COUNT > 0 THEN
                        ERROR(Error02, PurchaseHeader."Buy-from Vendor No.");
                END;
                //DSLoc1.01 End
            END;
    end;

    //Se elimino InsertTempInvoicePostBufferReverseCharge, GetPostingDate

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPrepareLineOnAfterFillInvoicePostingBuffer', '', false, false)]
    local procedure OnAfterFillInvoicePostBuffer(PurchLine: Record "Purchase Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary)
    var
        PurchHeader: Record "Purchase Header";
    begin
        //029 Inicio
        PurchHeader := PurchLine.GetPurchHeader();
        IF PurchHeader.Rappel THEN BEGIN
            PurchLine.TESTFIELD("Cod. Vendedor");
            PurchLine.TESTFIELD("Cod. Colegio");
        END;

        InvoicePostingBuffer."Cod. Vendedor" := PurchLine."Cod. Vendedor";
        InvoicePostingBuffer."Cod. Colegio" := PurchLine."Cod. Colegio";
        //029 Fin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInvoiceRoundingAmount', '', false, false)]
    local procedure OnAfterInvoiceRoundingAmount(var PurchaseLine: Record "Purchase Line"; InvoiceRoundingAmount: Decimal; PurchaseHeader: Record "Purchase Header")
    var
        VendPostingGr: Record "Vendor Posting Group";
    begin
        if InvoiceRoundingAmount <> 0 then begin
            VendPostingGr.Get(PurchaseHeader."Vendor Posting Group");
            PurchaseLine.VALIDATE("No.", VendPostingGr."Invoice Rounding Account");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header")
    begin
        //DSLoc1.01 To fill the NCF field in the G/L Entry
        GenJnlLine."No. Comprobante Fiscal" := PurchHeader."No. Comprobante Fiscal";
        GenJnlLine."Cod. Clasificacion Gasto" := PurchHeader."Cod. Clasificacion Gasto";
        //End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostBalancingEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnBeforePostBalancingEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLineLCY: Record "Purchase Line")
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
        VendLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
        VendLedgEntry.FindLast();
        //DSLoc1.01 To fill the NCF field in the G/L Entry
        GenJnlLine."No. Comprobante Fiscal" := PurchHeader."No. Comprobante Fiscal";
        GenJnlLine."Cod. Clasificacion Gasto" := PurchHeader."Cod. Clasificacion Gasto";
        //End

        //004 jpg++ para solo auntoliquidar monto faltante ya que la retencion se aplico
        RetencionDocProveedores.RESET;
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo" THEN
            RetencionDocProveedores.SETRANGE("Tipo documento", RetencionDocProveedores."Tipo documento"::"Credit Memo")
        ELSE
            RetencionDocProveedores.SETRANGE("Tipo documento", RetencionDocProveedores."Tipo documento"::Invoice);
        RetencionDocProveedores.SETRANGE("No. documento", PurchHeader."Posting No.");
        IF RetencionDocProveedores.FINDFIRST THEN BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");

            GenJnlLine.Amount := (VendLedgEntry."Remaining Amount" * -1) + VendLedgEntry."Remaining Pmt. Disc. Possible";
            GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
            VendLedgEntry.CALCFIELDS(Amount);
            IF VendLedgEntry.Amount = 0 THEN
                GenJnlLine."Amount (LCY)" := TotalPurchLineLCY."Amount Including VAT"
            ELSE
                GenJnlLine."Amount (LCY)" :=
                  (VendLedgEntry."Remaining Amt. (LCY)" * -1) +
                  ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible" / VendLedgEntry."Adjusted Currency Factor");
            CLEAR(GenJnlPostLine); //Pendiente no hay acceso a la variable, funciona si creo una de manera local? limpiar variable porque entry no toma numero el mismo de retencion
        END;
        //004 jpg-- para solo auntoliquidar monto faltante ya que la retencion se aplico
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCopyAndCheckItemChargeOnBeforeCheckIfEmpty', '', false, false)]
    local procedure OnCopyAndCheckItemChargeOnBeforeCheckIfEmpty(var TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        TempPurchaseLine.SETFILTER("Line Discount %", '<>100');
    end;

    //Pendiente No se puede modificar la variable FinalInvoice

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineJobConsumptionOnAfterItemLedgEntrySetFilters', '', false, false)]
    local procedure OnPostItemJnlLineJobConsumptionOnAfterItemLedgEntrySetFilters(var ItemLedgEntry: Record "Item Ledger Entry"; var PurchLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader := PurchLine.GetPurchHeader();
        ItemLedgEntry.SetRange("Document No.", PurchHeader."Last Return Shipment No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchInvHeaderInsert', '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        //DSLoc1.01 For the NCF, uncheck the Purch. Credit Memo to be Corrected
        IF PurchInvHeader."Applies-to Doc. No." <> '' THEN
            IF PurchCrMemoHeader.GET(PurchInvHeader."Applies-to Doc. No.") THEN
                IF (PurchCrMemoHeader."No. Comprobante Fiscal" <> '') AND (PurchHeader.Correction) THEN BEGIN
                    PurchCrMemoHeader."No. Comprobante Fiscal" := Text50060 + PurchCrMemoHeader."No. Comprobante Fiscal";
                    PurchCrMemoHeader.MODIFY;
                END;
        //DSLoc1.01 For the NCF, uncheck the Credit Memo to be Corrected
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        //+ATS
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) AND (PurchHeader."Tipo de Comprobante" = '41') THEN
            CopyFacturasReembolso(PurchHeader."Document Type".AsInteger(), PurchHeader."No.", PurchInvHeader."No.");
        //-ATS
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchCrMemoHeaderInsert', '', false, false)]
    local procedure OnBeforePurchCrMemoHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        //DSLoc1.01 For the NCF, uncheck the Purch. Invoice to be Corrected
        IF PurchCrMemoHdr."Applies-to Doc. No." <> '' THEN
            IF PurchInvHeader.GET(PurchCrMemoHdr."Applies-to Doc. No.") THEN
                IF (PurchInvHeader."No. Comprobante Fiscal" <> '') AND (PurchHeader.Correction) THEN BEGIN
                    PurchInvHeader."No. Comprobante Fiscal" := Text50060 + PurchInvHeader."No. Comprobante Fiscal";
                    PurchInvHeader.MODIFY;
                END;
        //DSLoc1.01 For the NCF, uncheck the Purch. Invoice to be Corrected
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfterPurchCrMemoHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    begin
        //+ATS
        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") AND (PurchHeader."Tipo de Comprobante" = '41') THEN
            CopyFacturasReembolso(PurchHeader."Document Type".AsInteger(), PurchHeader."No.", PurchCrMemoHdr."No.");
        //-ATS
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertCombinedSalesShipment', '', false, false)]
    local procedure OnAfterInsertCombinedSalesShipment(var SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        // #209115 MdM
        cFunMdM.ContrlFechasAlbV(SalesShipmentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckMandatoryFields', '', false, false)]
    local procedure OnAfterCheckMandatoryFields(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.TESTFIELD("Buy-from Address"); //#57339
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnBeforeCalculateVATAmounts', '', false, false)]
    local procedure OnBeforeCalculateVATAmountInBuffer(var IsHandled: Boolean)
    begin
        IsHandled := true;//Pendiente validar que cumpla con eliminar el metodo UpdateVATAmountsOnReverseChargeInvoicePostingBuffer se va a quitar en la version 20
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnBeforeInitGenJnlLine', '', false, false)]
    local procedure OnBeforePostInvoicePostBufferLine(InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; PurchHeader: Record "Purchase Header")
    var
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
    begin
        //Pendiente validar que mantenga la funcionalidad no se pudo eliminar el metodo anterior
        if Currency.get(PurchHeader."Currency Code") then;
        CASE InvoicePostingBuffer."VAT Calculation Type" OF
            InvoicePostingBuffer."VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                    VATPostingSetup.GET(
                      InvoicePostingBuffer."VAT Bus. Posting Group", InvoicePostingBuffer."VAT Prod. Posting Group");
                    InvoicePostingBuffer."VAT Amount" :=
                      ROUND(
                        InvoicePostingBuffer."VAT Base Amount" *
                        (1 - PurchHeader."VAT Base Discount %" / 100) * VATPostingSetup."VAT %" / 100);
                    InvoicePostingBuffer."VAT Amount (ACY)" :=
                      ROUND(
                        InvoicePostingBuffer."VAT Base Amount (ACY)" * (1 - PurchHeader."VAT Base Discount %" / 100) *
                        VATPostingSetup."VAT %" / 100, Currency."Amount Rounding Precision");
                END;
        END;
    end;

    //Pendiente en el metodo PostItemTracking no limpiar las variables 
    /*
    PreciseTotalChargeAmt := 0;
                PreciseTotalChargeAmtACY := 0;
                RoundedPrevTotalChargeAmt := 0;
                RoundedPrevTotalChargeAmtACY := 0;
    */

    LOCAL PROCEDURE ValidarInternacionalServicios(PHeader: Record "Purchase Header"; Interncional: Boolean) GenerarNCF: Boolean;
    VAR
        VatProduct: Record "VAT Product Posting Group";
        Pline: Record "Purchase Line";
        VatPostingSetup: Record "VAT Posting Setup";
        ServicioEncontrado: Boolean;
        Ms001: Label 'The lines in orders International Providers should be exempt from tax';//ESM=Las lineas en los pedidos de Proveedores Internacionales deben ser Exentas de Impuestos';
    BEGIN
        //DSLoc1.04
        IF Interncional = FALSE THEN
            EXIT(TRUE);

        Pline.RESET;
        Pline.SETRANGE("Document No.", PHeader."No.");
        Pline.SETRANGE("Document Type", PHeader."Document Type");

        IF Pline.FINDSET THEN
            REPEAT
                //VALIDAR QUE NO CONTENGA IMPUESTO
                VatPostingSetup.RESET;
                VatPostingSetup.SETRANGE("VAT Bus. Posting Group", Pline."VAT Bus. Posting Group");
                VatPostingSetup.SETRANGE("VAT Prod. Posting Group", Pline."VAT Prod. Posting Group");
                IF VatPostingSetup.FINDFIRST THEN
                    IF VatPostingSetup."VAT %" > 0 THEN
                        ERROR(Ms001);

                //VALIDAR QUE EXISTA ALGUN SERVICIO
                VatProduct.RESET;
                VatProduct.SETRANGE(Code, Pline."VAT Prod. Posting Group");
                IF VatProduct.FINDFIRST THEN
                    IF VatProduct."Tipo de bien-servicio" = VatProduct."Tipo de bien-servicio"::Servicios THEN
                        ServicioEncontrado := TRUE;

            UNTIL Pline.NEXT = 0;

        EXIT(ServicioEncontrado);
    END;

    PROCEDURE ValidaNoNCF(NCF: Code[30]; TipoDoc: Option Factura,Abono,Envio; NoAut: Code[20]): Boolean;
    VAR
        NoSerieLine: Record "No. Series Line";
        UltcuatroTXT: Text[30];
        UltCuatro: Decimal;
        Longitud: Integer;
        NCFaBuscar: Text[30];
        Encontrado: Boolean;
        TSH: Record "Transfer Shipment Header";
        SH: Record "Sales Header";
        UltimoNumero: Integer;
        UltimoNumerotxt: Text[30];
        NuevoNum: Integer;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    BEGIN
        IF TipoDoc = 0 THEN BEGIN
            PurchInvHeader.RESET;
            PurchInvHeader.SETRANGE("No. Comprobante Fiscal", NCF);
            PurchInvHeader.SETRANGE("No. Autorizacion Comprobante", NoAut);
            IF PurchInvHeader.FINDFIRST THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
        IF TipoDoc = 1 THEN BEGIN
            PurchCrMemoHeader.RESET;
            PurchCrMemoHeader.SETRANGE("No. Comprobante Fiscal", NCF);
            PurchCrMemoHeader.SETRANGE("No. Autorizacion Comprobante", NoAut);
            IF PurchCrMemoHeader.FINDFIRST THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    END;

    PROCEDURE BuscaNoAutNCF(NoSerieNCF: Code[20]; PurchHeader: Record "Purchase Header");
    BEGIN
        //Se busca el No. de Autorizacion. Santillana Ecuador
        NoSeriesLine.RESET;
        NoSeriesLine.SETRANGE("Series Code", NoSerieNCF);
        NoSeriesLine.SETFILTER("Starting No.", '<=%1', PurchHeader."No. Comprobante Fiscal");
        NoSeriesLine.SETFILTER("Ending No.", '>=%1', PurchHeader."No. Comprobante Fiscal");
        NoSeriesLine.FINDFIRST;
        IF (PurchHeader."Tipo de Comprobante" <> '03') AND (PurchHeader."Tipo de Comprobante" <> '41') THEN
            NoSeriesLine.TESTFIELD("No. Autorizacion");
        NoSeriesLine.TESTFIELD(Establecimiento);
        NoSeriesLine.TESTFIELD("Punto de Emision");
        NoSeriesLine.TESTFIELD("Tipo Comprobante");
        PurchHeader."No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
        //ATS REEMBOLSO
        IF ((NoSeriesLine."Permitir Comprobante Reembolso") AND (PurchHeader."Tipo de Comprobante" <> '41')) OR (NoSeriesLine."Permitir Comprobante Reembolso" = FALSE) THEN
            PurchHeader."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";
        //ATS REEMBOLSO
        PurchHeader.Establecimiento := NoSeriesLine.Establecimiento;
        PurchHeader."Punto de Emision" := NoSeriesLine."Punto de Emision";
    END;

    PROCEDURE ValidaNoAut(PH_Loc: Record "Purchase Header");
    VAR
        wNCF: Decimal;
        Inicial: Decimal;
        Final: Decimal;
        OK: Boolean;
    BEGIN
        //+#20150
        //Si es una factura electronica de compra no se tiene que validar el No.Autorizacion
        IF PH_Loc."Factura eletrónica" THEN
            EXIT;
        //-#20150

        IF (PH_Loc."Tipo de Comprobante" <> '00') AND (PH_Loc."Tipo de Comprobante" <> '08') AND (PH_Loc."Tipo de Comprobante" <> '11')
          AND (PH_Loc."Tipo de Comprobante" <> '13') AND (PH_Loc."Tipo de Comprobante" <> '15') AND (PH_Loc."Tipo de Comprobante" <> '16')
          AND (PH_Loc."Tipo de Comprobante" <> '17') AND (PH_Loc."Tipo de Comprobante" <> '19') AND (PH_Loc."Tipo de Comprobante" <> '20')
          AND (PH_Loc."Tipo de Comprobante" <> '21') THEN BEGIN
            PH_Loc.TESTFIELD("No. Comprobante Fiscal");
            EVALUATE(wNCF, PH_Loc."No. Comprobante Fiscal");
            AutProv.RESET;
            AutProv.SETRANGE("Cod. Proveedor", PH_Loc."Buy-from Vendor No.");
            AutProv.SETRANGE("No. Autorizacion", PH_Loc."No. Autorizacion Comprobante");
            AutProv.SETRANGE(Establecimiento, PH_Loc.Establecimiento);
            AutProv.SETRANGE("Punto de Emision", PH_Loc."Punto de Emision");

            //ATS REEMBOLSO
            IF PH_Loc."Tipo de Comprobante" = '41' THEN
                AutProv.SETRANGE("Permitir Comprobante Reembolso", TRUE)
            ELSE
                AutProv.SETRANGE("Tipo Comprobante", PH_Loc."Tipo de Comprobante");
            //ATS REEMBOLSO

            AutProv.SETFILTER("Fecha Autorizacion", '<=%1', PH_Loc."Posting Date");
            IF AutProv.Electronica = FALSE THEN
                AutProv.SETFILTER("Fecha Caducidad", '>%1', PH_Loc."Posting Date");
            IF (PH_Loc."Document Type" = PH_Loc."Document Type"::Invoice) OR
              (PH_Loc."Document Type" = PH_Loc."Document Type"::Order) THEN
                AutProv.SETRANGE(AutProv."Tipo Documento", AutProv."Tipo Documento"::Factura)
            ELSE
                AutProv.SETRANGE(AutProv."Tipo Documento", AutProv."Tipo Documento"::"Nota de Credito");
            AutProv.FINDFIRST;

            IF AutProv."Rango Inicio" <> '' THEN
                EVALUATE(Inicial, AutProv."Rango Inicio");
            IF AutProv."Rango Fin" <> '' THEN
                EVALUATE(Final, AutProv."Rango Fin");

            IF (Inicial <= wNCF) AND (Final >= wNCF) THEN
                OK := TRUE
            ELSE
                ERROR(Error004, PH_Loc."No. Comprobante Fiscal", AutProv.GETFILTERS);
        END;
    END;

    PROCEDURE ControlLineasReembolso(recPrmCab: Record "Purchase Header");
    VAR
        recLinCmp: Record "Purchase Line";
        recFactRespaldo: Record "Facturas de reembolso";
        Error011: Label '%1 no ingresado. Revise el detalle del reembolso.';
        Error002: Label 'Solo se permite que el Numero de Autorización tenga 10, 37 o 49 digitos. Revise el detalle del reembolso.';
    BEGIN
        //+#34843
        recFactRespaldo.RESET;
        recFactRespaldo.SETRANGE("Document Type", recPrmCab."Document Type");
        recFactRespaldo.SETRANGE("Document No.", recPrmCab."No.");
        IF NOT recFactRespaldo.FINDSET THEN
            ERROR(Err010);
        REPEAT
            //+#44893
            IF recFactRespaldo."Tipo ID" = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("Tipo ID")));
            IF recFactRespaldo."Tipo Comprobante" = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("Tipo Comprobante")));
            IF (recFactRespaldo."Base No Objeto IVA" = 0) AND (recFactRespaldo."Base Exenta IVA" = 0) AND (recFactRespaldo."Base 0" = 0) AND (recFactRespaldo."Base X" = 0) THEN
                ERROR(STRSUBSTNO(Error011, 'Importe de las bases'));
            //-#44893

            IF recFactRespaldo.RUC = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION(RUC)));
            IF recFactRespaldo."Establecimiento Comprobante" = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("Establecimiento Comprobante")));
            IF recFactRespaldo."Punto Emision Comprobante" = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("Punto Emision Comprobante")));
            IF recFactRespaldo."Numero Secuencial Comprobante" = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("Numero Secuencial Comprobante")));
            IF recFactRespaldo."Fecha Comprobante" = 0D THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("Fecha Comprobante")));
            IF recFactRespaldo."No. Autorización Comprobante" = '' THEN
                ERROR(STRSUBSTNO(Error011, recFactRespaldo.FIELDCAPTION("No. Autorización Comprobante")))
            ELSE
                IF (STRLEN(recFactRespaldo."No. Autorización Comprobante") <> 37) AND (STRLEN(recFactRespaldo."No. Autorización Comprobante") <> 49) AND (STRLEN(recFactRespaldo."No. Autorización Comprobante") <> 10) THEN
                    ERROR(Error002);

        UNTIL recFactRespaldo.NEXT = 0;

        //-#34843
    END;

    PROCEDURE CopyFacturasReembolso(DocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]);
    VAR
        recFactRespaldo2: Record "Facturas de reembolso";
        recFactRespaldo: Record "Facturas de reembolso";
    BEGIN
        //ATS
        recFactRespaldo.RESET;
        recFactRespaldo.SETRANGE("Document Type", DocumentType);
        recFactRespaldo.SETRANGE("Document No.", FromNumber);
        IF NOT recFactRespaldo.FINDSET THEN
            ERROR(Err010);
        REPEAT
            recFactRespaldo2.TRANSFERFIELDS(recFactRespaldo);
            recFactRespaldo2."Document No." := ToNumber;
            recFactRespaldo2.INSERT;
            recFactRespaldo.DELETE;
        UNTIL recFactRespaldo.NEXT = 0;
    END;


    var
        //Traducción francés NothingToPostErr, PostingPurchasesAndVATMsg, CannotInvoiceBeforeAssocSalesOrderErr, PurchaseAlreadyExistsErr
        //Traducción español ZeroDeferralAmtErr
        LinSerie: Record "No. Series Line";
        NoSeriesMgt: Codeunit "No. Series";
        cRetenciones: Codeunit "Proceso Retenciones";
        cuLocalizacion: Codeunit "Validaciones Localizacion";
        VendPostingGr: Record "Vendor Posting Group";
        Vend: Record Vendor;
        RetencionDocProveedores: Record "Historico Retencion Prov.";
        Err0016: Label '%1 can not be after %2 of the NCF serial no., corresponding values are %3 and %4';//ESP=%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4;ESM=%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4';
        ConfSant: Record "Config. Empresa";
        ValidaReq: Codeunit "Valida Campos Requeridos";
        GenBusPostGrp: Record "Gen. Business Posting Group";
        NoSeriesLine: Record "No. Series Line";
        PIH: Record "Purch. Inv. Header";
        AutProv: Record "Autorizaciones SRI Proveedores";
        Err001: Label 'You must select a %1 for Vendor no. %2';//ESP=Se debe seleccionar un %1 para Proveedor no. %2;ESM=Se debe seleccionar un %1 para Proveedor no. %2';
        Text50060: Label '"CORRECTION "';//ESP="CORRECCION ";ESM="CORRECCION "';
        Error02: Label 'At least one Retention/Detraction must be selected for Vendor %1';//ESM=Debe elegir al menos una retenci¢n para el Proveedor %1';
        Error004: Label 'El %1 no existe para %2';
        Error005: Label 'Debe indicar el no. de serie NCF de factura para las liquidaciones de compra.';
        Error006: Label 'No debe indicar No. de comprobante fiscal en liquidaciones de compra.';
        Error007: Label 'Debe indicar Establecimiento, Punto de Emisión, Número de comprobante y Autorización para las líneas de la factura tipo reembolso %1';
        Error009: Label 'Debe indicar el Sustento del Comprobante.';
        Err010: Label 'No se han ingresado las facturas de reembolso.';
        cFunMdM: Codeunit "Funciones MdM";

    /*
  Proyecto: Microsoft Dynamics Nav
  ---------------------------------
  AMS     : Agust¡n M‚ndez
  GRN     : Guillermo Rom n
  JPG     : John Peralta
  ------------------------------------------------------------------------
  No.         Firma       Fecha            Descripcion
  ------------------------------------------------------------------------
  DSLoc1.03   GRN         01/05/2018       Funcionalidad localizado RD
  DSLoc1.04   JPG         01/06/2019       Se acorto label Text50060 a CORREC y COPYSTR de 6-8 para copiar ultimos 8 Digitos
  DSLoc1.04   JPG         01/08/2019       General comprobante a internacionales si se le factura algun tipo de servicio y ningun tipo de impuesto
  004         JPG                          Autoliquidar monto faltante factura ya que retencion aplico parte
  002         JPG         11-11-2021        Para sumar ITBIS a costo mercancia

  DSLoc1.01   GRN/AMS    09/01/2009    Para adicionar funcionalidad de Retenciones y Localizacion DS.
  001         AMS        12/07/2012    Controlar que la forma de pago sea obligarotia en compras
  006         AMS        03/11/2012    Control de Importe compras en cero
  007         AMS        03/11/2012    Comprobante obligatorio
  027         AMS        28/10/2012    Valida Campos y Dimensiones Requeridas
  028         AMS        15/02/2013    No se controla Autorizacin SRI para aquellos proveedores que as¡
                                       lo indique su grupo contable negocio
  029         GRN        26/02/2013    Se insertaron datos del APS en InvPostingBuffer
  030         AMS        06/03/2013    Validacion No. de Autorizacio Proveedor
  $031        JML        14/01/2015    A¤ado controles para facturaci¢n electr¢nica
  #14564      JML        31/03/2015    Modificaciones ATS
  032         CAT        06/05/2015    Para todas las compras es obligatorio el sustento tributario
  033         CAT        25/05/2015    Se graban las facturas de respaldo (facturas de reembolso)
  #20150      CAT        12/06/2015    Si es una factura electronica podran digitar directamente el No. de Autorizaci¢n sin validar si existe el rango
  #34843      CAT        10/11/2015    No se permite registrar la compra si no se han cargado el detalle del reembolso.
  #37039      CAT        19/11/2015    Se exige que las notas de credito tengan ingresado el campo Tipo Comprobante
  #44893      CAT        03/02/2016    Control del contenido de los campos
  #57339      JMB        21/09/2016    A¤adido control para que el campo "Buy-from Address" no este vacio
  #209115     JPT        04/04/2019    MdM - Automatizar fecha entrada almacen y fecha comercialilzacion

  034         FES         24-Oct-2022  Funcionalidad no aplica en Santillana Ecuador
*/
}