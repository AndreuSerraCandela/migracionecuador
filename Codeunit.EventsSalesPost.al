codeunit 55017 "Events Sales-Post"
{
    Permissions =
                tabledata "Bank Account" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        lrFiltMdM: Record "Conf.Filtros Tipologias MdM";
    begin
        //#44738:Inicio
        ValidaLineas(SalesHeader);
        //#44738:Fin

        //015

        SalesHeader.TESTFIELD("VAT Registration No.");

        //027
        ValidaReq.Documento(36, SalesHeader."Document Type".AsInteger(), SalesHeader."No.");
        ValidaReq.Dimensiones(36, SalesHeader."No.", 1, SalesHeader."Document Type".AsInteger());
        //027

        //022
        ConfSantillana.GET;
        IF (ConfSantillana."NCF en Remision de Ventas") AND (NOT SalesHeader."Pedido Consignacion")
            AND (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order") AND (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo") AND
            (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) THEN BEGIN
            SalesHeader.TESTFIELD("No. Serie NCF Remision");
        END;
        //022

        ActCedulaRUC(SalesHeader);//029

        //+#34853
        IF (SalesHeader.Invoice) AND (SalesHeader.Exportación) THEN BEGIN
            SalesHeader.TESTFIELD("Tipo Exportacion");
            IF SalesHeader."Tipo Exportacion" IN [SalesHeader."Tipo Exportacion"::"02", SalesHeader."Tipo Exportacion"::"03"] THEN BEGIN
                SalesHeader.TESTFIELD("Fecha embarque");
                SalesHeader.TESTFIELD("Valor FOB");
            END;
        END;
        //-#34853

        //012
        IF ConfSantillana."Funcionalidad NCF Activa" THEN BEGIN
            IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") THEN BEGIN
                SalesHeader.TESTFIELD("No. Comprobante Fiscal Rel.");
                SalesHeader.TESTFIELD("Establecimiento Fact. Rel");                                    //$031
                SalesHeader.TESTFIELD("Punto de Emision Fact. Rel.");                                  //
                ValidaNoNCFRel(SalesHeader."Establecimiento Fact. Rel", SalesHeader."Punto de Emision Fact. Rel.", SalesHeader."No. Comprobante Fiscal Rel.");
            END;
        END;
        //012

        //019
        IF SalesHeader.Invoice = FALSE THEN BEGIN
            IF ConfSantillana."Funcionalidad Imp. Fiscal Act." THEN BEGIN
                SalesHeader.TESTFIELD("VAT Registration No.");
                SalesHeader.TESTFIELD("Sell-to Customer Name");
                IF UserSetUp.GET(USERID) THEN BEGIN
                    UserSetUp.TESTFIELD("Puerto Imp. Fiscal");
                    UserSetUp.TESTFIELD("Velocidad Imp. Fiscal");
                END
                ELSE
                    ERROR(Err002, USERID);
            END;
        END;
        //019

        //#38359
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice:
                BEGIN
                    IF SalesHeader."No. Serie NCF Facturas" <> '' THEN BEGIN
                        recNoSeries.GET(SalesHeader."No. Serie NCF Facturas");
                        IF recNoSeries."Facturacion electronica" THEN
                            ControlesFacturaElectronica(SalesHeader);
                    END;
                END;
            SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo":
                BEGIN
                    IF SalesHeader."No. Serie NCF Abonos" <> '' THEN BEGIN
                        recNoSeries.GET(SalesHeader."No. Serie NCF Abonos");
                        IF recNoSeries."Facturacion electronica" THEN
                            ControlesFacturaElectronica(SalesHeader);
                    END;
                END;
        END;
        //#38359
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnAfterValidatePostingAndDocumentDate(var SalesHeader: Record "Sales Header")
    begin
        // #209115 MdM
        cFunMdM.ContrlFechasDocV(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckTotalInvoiceAmount', '', false, false)]
    local procedure OnBeforeCheckTotalInvoiceAmount(SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempSalesLineGlobal: Record "Sales Line" temporary;
        TotalInvoiceAmountNegativeErr: Label 'The total amount for the invoice must be 0 or greater.';
    begin
        SalesPost.FillTempLines(SalesHeader, TempSalesLineGlobal);
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order] then begin
            TempSalesLineGlobal.CalcVATAmountLines(1, SalesHeader, TempSalesLineGlobal, TempVATAmountLine);
            if TempVATAmountLine.GetTotalAmountInclVAT() < 0 then
                Error(TotalInvoiceAmountNegativeErr);
        end;

        IsHandled := true;
    end;

    //Pendiente en el metodo ProcessPostingLines eliminar línea SalesTaxCalculate.SetTotalTaxAmountRounding(SalesHeader."Sales Tax Amount Rounding");
    //En el mismo metodo mostrar la ventana de progreso si GUIALLOWED
    /*
    IF NOT HideProgressWindow THEN
    IF GUIALLOWED THEN //007
    Window.UPDATE(2,LineCount);
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSendICDocument', '', false, false)]
    local procedure OnBeforeSendICDocument(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeUpdateHandledICInboxTransaction', '', false, false)]
    local procedure OnBeforeUpdateHandledICInboxTransaction(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeMakeInventoryAdjustment', '', false, false)]
    local procedure OnRunOnBeforeMakeInventoryAdjustment(var SalesHeader: Record "Sales Header")
    begin
        //017 GRN To create a Purchase Order with the Sales Item
        ConfSantillana.GET;
        IF ConfSantillana."Crea Ped. Compra de Muestras" THEN BEGIN
            IF SalesHeader.Invoice AND (SalesHeader."Tipo de Venta" = SalesHeader."Tipo de Venta"::Muestras) THEN
                IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) THEN
                    CreatePurchOrder(SalesHeader);
        END;
        //017
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', false, false)] //Pendiente validar que mantenga la funcionalidad
    local procedure OnAfterFinalizePosting(var SalesHeader: Record "Sales Header")
    begin
        //+#842
        ConfSantillana.GET();
        IF ConfSantillana."ID Codeunit email packing" <> 0 THEN
            CODEUNIT.RUN(ConfSantillana."ID Codeunit email packing", SalesHeader);
        //-#842
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        // #209115 MdM
        cFunMdM.ContrlFechasMdMTmp(2);

        //LDP-034+-

        //LDP //13/02/2024
        ConfSantillana.GET;
        IF ConfSantillana."Liquidar Factura TPV" THEN BEGIN//025+-
            IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
               (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) AND
               (SalesHeader."Venta TPV" = TRUE) THEN
                RegistrarCobrosSGT;  //10/01/2023 +- Proceso liquidaci¢n vs mejorada.
        END;

        IF ConfSantillana."Liquidar Nota Credito TPV" THEN BEGIN//025+-
            IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR
               (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")) AND
               (SalesHeader."Venta TPV" = TRUE) THEN
                RegistrarCobrosSGT;  //10/01/2023 +- Proceso liquidaci¢n vs mejorada.
        END;
        //LDP //13/02/2024
        //LDP-034--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckMandatoryHeaderFields', '', false, false)]
    local procedure OnBeforeCheckMandatoryHeaderFields(var SalesHeader: Record "Sales Header")
    begin
        ConfSantillana.GET();
        ConfSantillana.TESTFIELD(Country);
        ParamPais.GET(ConfSantillana.Country);
        IF ParamPais."Control Lin. por Factura" THEN BEGIN
            ParamPais.TESTFIELD("Cantidad Lin. por factura");
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            IF (SalesLine.COUNT > ParamPais."Cantidad Lin. por factura") AND
               (ParamPais."Cantidad Lin. por factura" <> 0) THEN
                ERROR(Err001, SalesHeader."No.", SalesHeader.FIELDCAPTION("Document Type"), SalesHeader."Document Type");

            SalesHeader.TESTFIELD("Collector Code");

            IF ParamPais."Formato Doc. Vtas. por cliente" THEN //005
               BEGIN
                CustPostingGr.GET(SalesHeader."Customer Posting Group");
                ControlLinxDoc.SETRANGE(Country, ConfSantillana.Country);
                IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN
                    ControlLinxDoc.SETRANGE("Sales Report ID", CustPostingGr."Invoice Report ID")
                ELSE
                    ControlLinxDoc.SETRANGE("Sales Report ID", CustPostingGr."Credit Memo Report ID");

                IF ControlLinxDoc.FINDFIRST THEN BEGIN
                    IF (SalesLine.COUNT > ControlLinxDoc."Maximun line number") AND
                       (ControlLinxDoc."Maximun line number" <> 0) THEN
                        ERROR(Err001, SalesHeader."No.", SalesHeader.FIELDCAPTION("Document Type"), SalesHeader."Document Type");
                END;
            END;
        END;
    end;

    //Pendiente quitar validación en el metodo CheckSalesDocument
    /*
    if GLSetup."PAC Environment" <> GLSetup."PAC Environment"::Disabled then begin
        TestField("Payment Method Code", ErrorInfo.Create());
        //SalesSetup.TestField("Shipment on Invoice", ErrorInfo.Create());
    end;
    y añadir GUIALLOWED
    IF GUIALLOWED THEN //007
          IF NOT HideProgressWindow THEN
            InitProgressWindow(SalesHeader);
    */

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', false, false)] //Pendiente validar que mantenga la funcionalidad de no modificar el campo
    // local procedure OnAfterCheckSalesDoc(var SalesHeader: Record "Sales Header")
    // begin
    //     IF SalesHeader."Prepmt. Include Tax" THEN
    //         SalesHeader."Prepmt Sales Tax Round Amt 2" := SalesHeader."Prepmt. Sales Tax Rounding Amt";
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeUpdatePostingNos', '', false, false)] //Pendiente validar que mantenga la funcionalidad de no modificar el campo
    // local procedure OnBeforeUpdatePostingNos(var SalesHeader: Record "Sales Header")
    // begin
    //     IF SalesHeader."Prepmt. Include Tax" THEN
    //         SalesHeader."Prepmt. Sales Tax Rounding Amt" := SalesHeader."Prepmt Sales Tax Round Amt 2";
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeLockTables', '', false, false)] //Pendiente para qeu utiliza el Modify Header
    local procedure OnBeforeLockTables(var SalesHeader: Record "Sales Header")
    begin
        SendICDocument(SalesHeader);
        UpdateHandledICInboxTransaction(SalesHeader);
    end;

    local procedure UpdateHandledICInboxTransaction(SalesHeader: Record "Sales Header")
    var
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
        Customer: Record Customer;
    begin
        if SalesHeader."IC Direction" = SalesHeader."IC Direction"::Incoming then begin
            HandledICInboxTrans.SetRange("Document No.", SalesHeader."IC Reference Document No.");
            Customer.Get(SalesHeader."Sell-to Customer No.");
            HandledICInboxTrans.SetRange("IC Partner Code", Customer."IC Partner Code");
            HandledICInboxTrans.LockTable();
            if HandledICInboxTrans.FindFirst() then begin
                HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
                HandledICInboxTrans.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnAfterTestUpdatedSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnAfterTestUpdatedSalesLine(var SalesLine: Record "Sales Line"; var EverythingInvoiced: Boolean; var IsHandled: Boolean)
    begin
        SalesLine.CheckLocationOnWMS; //4721 SANTINAV-4721 validar almacen

        //+#57189
        IF SalesLine."Cantidad pendiente BO" <> 0 THEN
            EverythingInvoiced := FALSE
        ELSE
            //-#57189
            IF SalesLine."Qty. to Invoice" + SalesLine."Quantity Invoiced" <> SalesLine.Quantity THEN
                EverythingInvoiced := FALSE;

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; PostingSalesLine: Record "Sales Line")
    begin
        //016
        SalesInvLine."Requested Delivery Date" := PostingSalesLine."Requested Delivery Date";
        //016
    end;

    //Pendiente eliminar esta línea del metodo PostGLAndCustomer 
    //"Sales Tax Amount Rounding" := SalesTaxCalculate.GetTotalTaxAmountRounding;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostItemChargeLine', '', false, false)]
    local procedure OnBeforePostItemChargeLine(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        IF NOT (SalesLine.Amount <> 0) THEN
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemJnlLinePrepareJournalLineOnBeforeCalcItemJnlAmounts', '', false, false)]
    local procedure OnPostItemJnlLinePrepareJournalLineOnBeforeCalcItemJnlAmounts(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var ItemJnlLine: Record "Item Journal Line")
    begin
        //001
        IF ItemJnlLine."Importe Cons. bruto Inicial" = 0 THEN BEGIN
            DescuentoVenta := 0;

            ItemJnlLine."Precio Unitario Cons. Inicial" := SalesLine."Unit Price";
            ItemJnlLine."Descuento % Cons. Inicial" := SalesLine."Line Discount %";
            ItemJnlLine."Importe Cons. bruto Inicial" := (SalesLine."Unit Price" * (SalesLine."Qty. to Ship"));

            DescuentoVenta := ABS((ItemJnlLine."Importe Cons. bruto Inicial" * SalesLine."Line Discount %") / 100);

            ItemJnlLine."Importe Cons Neto Inicial" := (ItemJnlLine."Importe Cons. bruto Inicial" + (DescuentoVenta));
            ItemJnlLine."No. Mov. Prod. Cosg. a Liq." := SalesLine."No. Mov. Prod. Cosg. a Liq.";
            ItemJnlLine."Pedido Consignacion" := SalesHeader."Pedido Consignacion";
        END;
    end;

    //Pendiente metodo PostItemChargePerOrder

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeTestSalesLineItemCharge', '', false, false)]
    local procedure OnBeforeTestSalesLineItemCharge(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        IF SalesLine."Line Discount %" <> 100 THEN
            SalesLine.TESTFIELD(Amount);
        SalesLine.TESTFIELD("Job No.", '');
        SalesLine.TESTFIELD("Job Contract Entry No.", 0);

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateShippingNo', '', false, false)]
    local procedure OnAfterUpdateShippingNo(PreviewMode: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if not PreviewMode then begin
            //$030- Si es facturaci¢n electr¢nica el comprobante se asigna en el registro de la remisi¢n, no en la impresi¢n.
            ConfSantillana.GET;
            //+#514701
            //IF (ConfSantillana."NCF en Remision de Ventas") AND  (NOT "Pedido Consignacion") THEN BEGIN
            IF (ConfSantillana."NCF en Remision de Ventas") AND (NOT SalesHeader."Pedido Consignacion") AND (NOT SalesHeader."Venta TPV") THEN BEGIN
                //-#514701
                SalesHeader.TESTFIELD("No. Serie NCF Remision");
                recNoSeries.GET(SalesHeader."No. Serie NCF Remision");
                IF recNoSeries."Facturacion electronica" THEN BEGIN
                    SalesHeader."No. Comprobante Fisc. Remision" := NoSeriesMgt.GetNextNo(SalesHeader."No. Serie NCF Remision", SalesHeader."Posting Date", TRUE);
                    BuscaNoAutNCFRemision(SalesHeader."No. Serie NCF Remision", SalesHeader);

                    //$030 Campos obligatorios si es facturaci¢n electr¢nica.
                    SalesHeader.TESTFIELD("Shipping Agent Code");
                    recTransportista.GET(SalesHeader."Shipping Agent Code");
                    recTransportista.TESTFIELD(Name);
                    recTransportista.TESTFIELD("Tipo id.");
                    recTransportista.TESTFIELD("VAT Registration No.");
                    recTransportista.TESTFIELD(Placa);

                    SalesHeader.TESTFIELD("Fecha inicio trans.");
                    SalesHeader.TESTFIELD("Fecha fin trans.");

                    SalesHeader.TESTFIELD("Ship-to Name");
                    SalesHeader.TESTFIELD("Ship-to Address");

                    IF SalesHeader."Fecha inicio trans." > SalesHeader."Fecha fin trans." THEN  //$032
                        ERROR(Error08);
                END;
            END;
            //030-
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeUpdatePostingNo', '', false, false)]
    local procedure OnBeforeUpdatePostingNo(PreviewMode: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if not PreviewMode then begin
            //DSLoc1.01 For the NCF Number+
            ConfSantillana.GET;
            IF ConfSantillana."Funcionalidad NCF Activa" THEN BEGIN
                IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) AND (NOT SalesHeader.Correction) THEN BEGIN
                    SalesHeader.TESTFIELD("No. Serie NCF Facturas");
                    SalesHeader.TESTFIELD("Establecimiento Factura");
                    SalesHeader.TESTFIELD("Punto de Emision Factura");
                END
                ELSE
                    IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"]) AND (NOT SalesHeader.Correction) THEN BEGIN
                        SalesHeader.TESTFIELD("No. Serie NCF Abonos");
                    END;

                IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) AND (NOT SalesHeader.Correction) THEN BEGIN
                    IF SalesHeader."No. Comprobante Fiscal" = '' THEN BEGIN
                        SalesHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(SalesHeader."No. Serie NCF Facturas", SalesHeader."Posting Date", TRUE);
                        BuscaNoAutNCF(SalesHeader."No. Serie NCF Facturas", SalesHeader); //Santillana Ecuador
                                                                                          //+#43088
                        ValidaNoComprobanteFiscal(SalesHeader."No. Comprobante Fiscal");
                        //-#43088

                    END;
                    IF ValidaNoNCF(SalesHeader."No. Serie NCF Facturas", SalesHeader."No. Comprobante Fiscal", 0, SalesHeader."No. Autorizacion Comprobante", SalesHeader."Establecimiento Factura", SalesHeader."Punto de Emision Factura") THEN
                        ERROR(Err003, SalesInvHeader."No.");
                END
                ELSE
                    IF (SalesHeader."No. Comprobante Fiscal" = '') THEN BEGIN
                        IF NOT SalesHeader.Correction THEN BEGIN
                            SalesHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(SalesHeader."No. Serie NCF Abonos", SalesHeader."Posting Date", TRUE);
                            BuscaNoAutNCF(SalesHeader."No. Serie NCF Abonos", SalesHeader);//Santillana Ecuador
                            IF ValidaNoNCF(SalesHeader."No. Serie NCF Abonos", SalesHeader."No. Comprobante Fiscal", 1, SalesHeader."No. Autorizacion Comprobante", SalesHeader."Establecimiento Factura", SalesHeader."Punto de Emision Factura") THEN
                                ERROR(Err004, SalesCrMemoHeader."No.");
                            //+#43088
                            ValidaNoComprobanteFiscal(SalesHeader."No. Comprobante Fiscal");
                            //-#43088
                        END;
                    END
                    ELSE
                        IF SalesHeader.Correction THEN
                            ERROR(error001);
            END;
            //DSLoc1.01 For the NCF Number-
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdatePostingNos', '', false, false)]
    local procedure OnAfterUpdatePostingNos(var SalesHeader: Record "Sales Header")
    begin
        //Ecuador+
        IF SalesHeader.Invoice THEN//038+-
          BEGIN
            IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)) AND
              (SalesHeader.Correction = FALSE) THEN BEGIN
                SalesHeader.CALCFIELDS("NCF en Historico");
                SalesHeader.TESTFIELD("NCF en Historico", FALSE);
            END;
        END;
        //Ecuador-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateLastPostingNos', '', false, false)]
    local procedure OnAfterUpdateLastPostingNos(var SalesHeader: Record "Sales Header")
    begin
        IF SalesHeader.Invoice THEN BEGIN
            SalesHeader."Ultimo. No. NCF" := SalesHeader."No. Comprobante Fiscal";//DSLoc1.01
            SalesHeader."No. Comprobante Fiscal" := '';//DSLoc1.01
        END;
    end;

    //Pendiente eliminar línea en el metodo DeleteAfterPosting
    //EInvoiceMgt.DeleteCFDITransportOperatorsAfterPosting(DATABASE::"Sales Header", SalesHeader."Document Type", SalesHeader."No.");

    //En metodo FinalizePosting añadir GUIALLOWED al cerrar la ventana

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterResetTempLines', '', false, false)]
    local procedure OnAfterResetTempLines(var TempSalesLineLocal: Record "Sales Line" temporary)
    begin
        TempSalesLineLocal.SETFILTER("Line Discount %", '<>100'); //Pendiente validar que no afecte en otro lafo ya que se llama el proceso desde varios lugares 
    end;

    //Pendiente en metodo TransferReservToItemJnlLine cambiar línea 4840, 4841
    /*
    IF NOT HasSpecificTracking(SalesOrderLine."No.") AND HasInvtPickLine(SalesOrderLine) THEN
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,TRUE)
        ELSE
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
    */

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeTempPrepmtSalesLineModify', '', false, false)]
    // local procedure OnBeforeTempPrepmtSalesLineModify(var TempPrepmtSalesLine: Record "Sales Line" temporary; SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary)
    // var
    //     PrepmtAmtToDeduct: Decimal;
    // begin
    //     PrepmtAmtToDeduct :=
    //               TempPrepmtSalesLine."Prepmt Amt to Deduct" +
    //               SalesPost.InsertedPrepmtVATBaseToDeduct(
    //                 SalesHeader, TempSalesLine, TempPrepmtSalesLine."Line No.", TempPrepmtSalesLine."Unit Price", TempPrepmtSalesLine.CalcAmountIncludingTax(SalesLine."Prepmt Amt to Deduct"));
    //     // IF SalesHeader."Prepmt. Include Tax" THEN
    //     //     TempPrepmtSalesLine.VALIDATE(
    //     //       "Unit Price",
    //     //       TempPrepmtSalesLine."Unit Price" + TempSalesLine."Prepmt Amt to Deduct" * (1 + TempSalesLine."VAT %" / 100))
    //     // ELSE
    //     //     TempPrepmtSalesLine.VALIDATE(
    //     //             "Unit Price", TempPrepmtSalesLine."Unit Price" + TempSalesLine."Prepmt Amt to Deduct");
    //     // IF SalesHeader."Prepmt. Include Tax" THEN
    //     //     TempPrepmtSalesLine."Prepmt Amt to Deduct" += TempSalesLine.CalcAmountIncludingTax(TempSalesLine."Prepmt Amt to Deduct")
    //     // ELSE
    //         TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeTempPrepmtSalesLineInsert', '', false, false)]
    local procedure OnBeforeTempPrepmtSalesLineInsert(var TempPrepmtSalesLine: Record "Sales Line" temporary; SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary)
    var
        PrepmtAmtToDeduct: Decimal;
    begin
        //PrepmtAmtToDeduct := SalesPost.InsertedPrepmtVATBaseToDeduct(SalesHeader, TempSalesLine, TempPrepmtSalesLine."Line No.", 0, TempSalesLine.CalcAmountIncludingTax(TempSalesLine."Prepmt Amt to Deduct"));
        // IF SalesHeader."Prepmt. Include Tax" THEN BEGIN
        //     IF TempSalesLine.IsFinalInvoice THEN begin
        //         TempPrepmtSalesLine.VALIDATE(
        //           "Unit Price", TempSalesLine."Prepmt. Amount Inv. Incl. VAT" - TempSalesLine."Prepmt Amt to Deduct");
        //         TempPrepmtSalesLine."Prepmt Amt to Deduct" :=
        //         TempSalesLine."Prepmt. Amount Inv. Incl. VAT" - TempSalesLine."Prepmt Amt to Deduct";
        //     end ELSE begin
        //         TempPrepmtSalesLine.VALIDATE("Unit Price", TempSalesLine."Prepmt Amt to Deduct" * (1 + TempSalesLine."VAT %" / 100));
        //         TempPrepmtSalesLine."Prepmt Amt to Deduct" := TempSalesLine.CalcAmountIncludingTax(TempSalesLine."Prepmt Amt to Deduct");
        //     end;
        // end;
    end;

    //Pendiente en metodo CreatePrepaymentLines agregar esta línea ya que no hay acceso a la variable  TotalSalesLineLCY
    /*
    IF Is100PctPrepmtInvoice(TempPrepmtSalesLine) THEN
        TotalSalesLineLCY."Prepayment %" := 100;
    */

    //Pendiente en el metodo AdjustPrepmtAmountLCY no se tiene acceso a la variable FinalInvoice ni exsiten
    // suscripciones para saltarla la creación/modificacion de la tabla temporal

    //Pendiente línea a añadir en el metodo AddSalesTaxLineToSalesTaxCalc después de linea 5753 se encuentra obsoleto 
    //SalesTaxCalculate.SetPrepmtPosting(TempSalesLineForSalesTax."Prepayment %" <> 0); se encuentra obsoleto

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesTaxToGL', '', false, false)]
    // local procedure OnBeforePostSalesTaxToGL(SalesHeader: Record "Sales Header"; SalesTaxAmountLine: Record "Sales Tax Amount Line"; var GenJnlLine: Record "Gen. Journal Line")
    // var
    //     TaxJurisdiction: Record "Tax Jurisdiction";
    //     TaxArea: Record "Tax Area";
    // begin
    //     //Le resta ya que no se puede igualar a cero la variable al inicio del metodo 
    //     //Si los filtros contrarios se cumplen ya se igualo a cero por lo que no se resta el valor de SalesHeader."Sales Tax Amount Rounding" 
    //     if TaxArea.get(SalesHeader."Tax Area Code") then;
    //     if TaxJurisdiction.Code = SalesTaxAmountLine."Tax Jurisdiction Code" then begin
    //         TaxJurisdiction.Get(SalesTaxAmountLine."Tax Jurisdiction Code");
    //         if TaxArea."Country/Region" <> TaxArea."Country/Region"::CA then begin
    //             GenJnlLine."VAT Amount (LCY)" := GenJnlLine."VAT Amount (LCY)" - SalesHeader."Sales Tax Amount Rounding";
    //         end;
    //     end;
    // end;

    //Pendiente modificar en el metodo PostSalesTaxToGL
    //Lineas 6873-6882
    /*
     IF SalesHeader.Invoice AND SalesHeader."Prepmt. Include Tax" AND
           ((TotalSalesLineLCY."Prepayment %" <> 0) OR (SalesHeader."Prepayment %" <> 0)) AND
           (SalesHeader."Currency Code" = '') AND (NewAmountIncludingVAT <> 0) AND
           (TotalTaxAmount <> 0) AND
           (TotalSalesLineLCY."Amount Including VAT" <> NewAmountIncludingVAT)
        THEN BEGIN
          TaxRoundingAmount := NewAmountIncludingVAT - TotalSalesLineLCY."Amount Including VAT";
          TaxRoundingFullPrepmt :=
            (ABS(NewAmountIncludingVAT) <= GLSetup."Amount Rounding Precision") AND (TotalSalesLineLCY."Prepayment %" = 100);
          IF NOT TaxRoundingFullPrepmt THEN
            PostSalesTaxToGLRounding(SalesHeader,TaxRoundingAmount,TaxRoundingAmount)
          ELSE BEGIN
            PostSalesTaxToGLRounding(SalesHeader,-TaxRoundingAmount,-TaxRoundingAmount);
            TotalSalesLine.Amount := 0;
            TotalSalesLineLCY.Amount := 0;
            TotalSalesLine."Amount Including VAT" := 0;
            TotalSalesLineLCY."Amount Including VAT" := 0;
          END;
        END;
    */
    //Linea 6885
    //IF (TotalTaxAmount <> 0) AND NOT TaxRoundingFullPrepmt THEN BEGIN

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeGetCountryCode', '', false, false)]
    local procedure OnBeforeGetCountryCode(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var CountryRegionCode: Code[10]; var IsHandled: Boolean)
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        CountryRegionCode := GetCountryRegionCode(
                SalesLine."Sell-to Customer No.",
                SalesShipmentHeader."Ship-to Code",
                SalesShipmentHeader."Sell-to Country/Region Code");

        IsHandled := true;
    end;

    local procedure GetCountryRegionCode(CustNo: Code[20]; ShipToCode: Code[10]; SellToCountryRegionCode: Code[10]) Result: Code[10]
    var
        ShipToAddress: Record "Ship-to Address";
    begin
        if ShipToCode <> '' then begin
            ShipToAddress.Get(CustNo, ShipToCode);
            exit(ShipToAddress."Country/Region Code");
        end;
        exit(SellToCountryRegionCode);
    end;

    LOCAL PROCEDURE HasSpecificTracking(ItemNo: Code[20]): Boolean;
    VAR
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    BEGIN
        Item.GET(ItemNo);
        IF Item."Item Tracking Code" <> '' THEN BEGIN
            ItemTrackingCode.GET(Item."Item Tracking Code");
            EXIT(ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking");
        END;
    END;

    LOCAL PROCEDURE HasInvtPickLine(SalesLine: Record "Sales Line"): Boolean;
    VAR
        WhseActivityLine: Record "Warehouse Activity Line";
    BEGIN
        WhseActivityLine.SETRANGE("Activity Type", WhseActivityLine."Activity Type"::"Invt. Pick");
        WhseActivityLine.SETRANGE("Source Type", DATABASE::"Sales Line");
        WhseActivityLine.SETRANGE("Source Subtype", SalesLine."Document Type");
        WhseActivityLine.SETRANGE("Source No.", SalesLine."Document No.");
        WhseActivityLine.SETRANGE("Source Line No.", SalesLine."Line No.");
        EXIT(NOT WhseActivityLine.ISEMPTY);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertShipmentHeader', '', false, false)]
    // local procedure OnAfterInsertShipmentHeader(SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header")
    // var
    //     CFDITransportOperator: Record "CFDI Transport Operator";
    // begin
    //     CFDITransportOperator.SetRange("Document Table ID", DATABASE::"Sales Header");
    //     CFDITransportOperator.SetRange("Document Type", SalesHeader."Document Type");
    //     CFDITransportOperator.SetRange("Document No.", SalesShipmentHeader."No.");
    //     if CFDITransportOperator.FindSet() then
    //         CFDITransportOperator.DeleteAll();
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeReturnRcptHeaderInsert', '', false, false)]
    local procedure OnBeforeReturnRcptHeaderInsert(SalesHeader: Record "Sales Header")
    begin
        //028+
        ConfSantillana.GET;
        IF (ConfSantillana."NCF en Remision de Ventas") AND (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") THEN BEGIN
            IF SalesHeader.Correction THEN BEGIN
                SalesHeader.TESTFIELD("No. documento Rem. a Anular");
                SalesHeader.TESTFIELD("No. Correlativo Rem. a Anular");
                SSH.RESET;
                SSH.SETRANGE("No.", SalesHeader."No. documento Rem. a Anular");
                SSH.FINDFIRST;
                SSH."No. Correlativo Rem. Anulado" := SSH."No. Comprobante Fisc. Remision";
                SSH."Remision Anulada" := TRUE;
                NCFAnulados.INIT;
                NCFAnulados."No. documento" := SSH."No.";
                NCFAnulados."No. Comprobante Fiscal" := SSH."No. Comprobante Fisc. Remision";
                NCFAnulados."Fecha anulacion" := WORKDATE;
                NCFAnulados."Tipo Documento" := NCFAnulados."Tipo Documento"::"Remision Ventas";
                NCFAnulados.INSERT;
                SSH."No. Comprobante Fisc. Remision" := txt009;
                SSH.MODIFY;
            END;
        END;
        //028-
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnInsertInvoiceHeaderOnAfterSalesInvHeaderTransferFields', '', false, false)]
    // local procedure OnInsertInvoiceHeaderOnAfterSalesInvHeaderTransferFields(SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    // var
    //     CFDITransportOperator: Record "CFDI Transport Operator";
    // begin
    //     //028 - Anulacion de Notas de credito por Correccion de factura
    //     IF SalesHeader.Correction THEN BEGIN
    //         SalesHeader.TESTFIELD("No. Nota Credito a Anular");
    //         SalesHeader.TESTFIELD("Correlativo NCR a Anular");
    //         SCMH.GET(SalesHeader."No. Nota Credito a Anular");
    //         NCFAnulados.INIT;
    //         NCFAnulados."No. documento" := SCMH."No.";
    //         NCFAnulados."No. Comprobante Fiscal" := SCMH."No. Comprobante Fiscal";
    //         NCFAnulados."Fecha anulacion" := WORKDATE;
    //         NCFAnulados."Tipo Documento" := NCFAnulados."Tipo Documento"::"Credit Memo";
    //         NCFAnulados.INSERT;
    //         SCMH."No. Comprobante Fiscal" := txt009;
    //         SCMH.MODIFY;
    //     END;
    //     //028

    //     //016
    //     SalesInvoiceHeader."Fecha entrega requerida" := SalesHeader."Requested Delivery Date";
    //     //016
    // end;

    LOCAL PROCEDURE SendICDocument(VAR SalesHeader: Record "Sales Header");
    VAR
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        ModifyHeader: Boolean;
    BEGIN
        IF SalesHeader."Send IC Document" AND (SalesHeader."IC Status" = SalesHeader."IC Status"::New) AND (SalesHeader."IC Direction" = SalesHeader."IC Direction"::Outgoing) AND
           (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order"])
        THEN BEGIN
            ICInboxOutboxMgt.SendSalesDoc(SalesHeader, TRUE);
            SalesHeader."IC Status" := SalesHeader."IC Status"::Pending;
            ModifyHeader := TRUE;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertDropOrderPurchRcptHeader', '', false, false)]
    local procedure OnAfterInsertDropOrderPurchRcptHeader(var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        // #209115 MdM
        cFunMdM.ContrlFechasAlbC(PurchRcptHeader);
    end;

    //Pendiente no se puede eliminar la línea 8205 en el metodo PostInvoicePostBuffer
    //TempInvoicePostBuffer.ApplyRoundingForFinalPosting();

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostItemTracking', '', false, false)]
    local procedure OnBeforePostItemTracking(SalesHeader: Record "Sales Header"; var TrackingSpecificationExists: Boolean; var TempTrackingSpecification: Record "Tracking Specification" temporary;
                        RemQtyToBeInvoiced: Decimal; TempItemLedgEntryNotInvoiced: Record "Item Ledger Entry" temporary; HasATOShippedNotInvoiced: Boolean; var IsHandled: Boolean)
    var
        QtyToInvoiceBaseInTrackingSpec: Decimal;
        ShouldProcessReceipt: Boolean;
        ShouldPostItemTrackingForReceipt: Boolean;
        ShouldPostItemTrackingForShipment: Boolean;
    begin
        if TrackingSpecificationExists then begin
            TempTrackingSpecification.CalcSums("Qty. to Invoice (Base)");
            QtyToInvoiceBaseInTrackingSpec := TempTrackingSpecification."Qty. to Invoice (Base)";
            if not TempTrackingSpecification.FindFirst() then
                TempTrackingSpecification.Init();
        end;

        ShouldProcessReceipt := SalesLine.IsCreditDocType();
        if ShouldProcessReceipt then begin
            ShouldPostItemTrackingForReceipt :=
                (Abs(RemQtyToBeInvoiced) > Abs(SalesLine."Return Qty. to Receive")) or
                (Abs(RemQtyToBeInvoiced) >= Abs(QtyToInvoiceBaseInTrackingSpec)) and
                (QtyToInvoiceBaseInTrackingSpec <> 0);
            if ShouldPostItemTrackingForReceipt then
                SalesPost.PostItemTrackingForReceipt(
                  SalesHeader, SalesLine, TrackingSpecificationExists, TempTrackingSpecification);

            SalesPost.PostItemTrackingCheckReturnReceipt(SalesLine, RemQtyToBeInvoiced);
        end else begin
            ShouldPostItemTrackingForShipment :=
              (Abs(RemQtyToBeInvoiced) > Abs(SalesLine."Qty. to Ship")) or
              (Abs(RemQtyToBeInvoiced) >= Abs(QtyToInvoiceBaseInTrackingSpec)) and
              (QtyToInvoiceBaseInTrackingSpec <> 0);
            if ShouldPostItemTrackingForShipment then
                SalesPost.PostItemTrackingForShipment(
                  SalesHeader, SalesLine, TrackingSpecificationExists, TempTrackingSpecification,
                  TempItemLedgEntryNotInvoiced, HasATOShippedNotInvoiced);

            //SalesPost.PostItemTrackingCheckShipment(SalesLine, RemQtyToBeInvoiced);
        end;

        IsHandled := true;
    end;

    PROCEDURE CreatePurchOrder(SalesHeader: Record "Sales Header");
    VAR
        SL: Record "Sales Line";
        PurchOrderHdr: Record "Purchase Header";
        PurchOrderLin: Record "Purchase Line";
        Item: Record Item;
    BEGIN
        //GRN To create a Purchase Order with the Sales Item
        ConfSantillana.GET();
        ConfSantillana.TESTFIELD("Proveedor Muestras");
        PurchOrderHdr.INIT;
        PurchOrderHdr."Document Type" := PurchOrderHdr."Document Type"::Order;
        PurchOrderHdr.INSERT(TRUE);
        PurchOrderHdr.VALIDATE("Buy-from Vendor No.", ConfSantillana."Proveedor Muestras");
        PurchOrderHdr.VALIDATE("Posting Date", SalesHeader."Posting Date");
        PurchOrderHdr.MODIFY;

        SL.SETRANGE("Document Type", SalesHeader."Document Type");
        SL.SETRANGE("Document No.", SalesHeader."No.");
        SL.SETRANGE(Type, SL.Type::Item);
        SL.SETFILTER("No.", '<>%1', '');
        SL.SETFILTER("Qty. to Invoice", '<>%1', 0);
        SL.FINDSET;
        REPEAT
            Item.GET(SL."No.");
            Item.TESTFIELD("Vendor No.");
            PurchOrderLin.INIT;
            PurchOrderLin."Document Type" := PurchOrderLin."Document Type"::Order;
            PurchOrderLin."Document No." := PurchOrderHdr."No.";
            PurchOrderLin."Line No." := SL."Line No.";
            PurchOrderLin.VALIDATE("Buy-from Vendor No.", Item."Vendor No.");
            PurchOrderLin.Type := PurchOrderLin.Type::Item;
            PurchOrderLin.VALIDATE("No.", SL."No.");
            PurchOrderLin.VALIDATE("Location Code", SL."Location Code");
            PurchOrderLin.VALIDATE("Unit of Measure", SL."Unit of Measure");
            PurchOrderLin.VALIDATE(Quantity, SL.Quantity);
            PurchOrderLin.VALIDATE("Direct Unit Cost", SL."Unit Cost (LCY)");
            PurchOrderLin.INSERT(TRUE);
            PurchOrderLin.VALIDATE("Shortcut Dimension 1 Code", SL."Shortcut Dimension 1 Code");
            PurchOrderLin.VALIDATE("Shortcut Dimension 2 Code", SL."Shortcut Dimension 2 Code");
            PurchOrderLin.MODIFY;
        UNTIL SL.NEXT = 0;
    END;

    PROCEDURE ValidaNoNCF(codPrmSerie: Code[20]; NCF: Code[30]; TipoDoc: Option Factura,Abono,Envio; NoAut: Code[20]; Estab: Code[3]; PuntoEm: Code[3]): Boolean;
    VAR
        recSerie: Record "No. Series";
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
    BEGIN
        //030
        IF recSerie.GET(codPrmSerie) THEN
            IF recSerie."Facturacion electronica" THEN
                EXIT(FALSE);
        //030

        IF TipoDoc = 0 THEN BEGIN
            SalesInvHeader.RESET;
            SalesInvHeader.SETRANGE("No. Comprobante Fiscal", NCF);
            SalesInvHeader.SETRANGE("No. Autorizacion Comprobante", NoAut);
            SalesInvHeader.SETRANGE("Establecimiento Factura", Estab);
            SalesInvHeader.SETRANGE("Punto de Emision Factura", PuntoEm);
            IF SalesInvHeader.FINDFIRST THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
        IF TipoDoc = 1 THEN BEGIN
            SalesCrMemoHeader.RESET;
            SalesCrMemoHeader.SETRANGE("No. Comprobante Fiscal", NCF);
            SalesCrMemoHeader.SETRANGE("No. Autorizacion Comprobante", NoAut);
            SalesCrMemoHeader.SETRANGE("Establecimiento Factura", Estab);
            SalesCrMemoHeader.SETRANGE("Punto de Emision Factura", PuntoEm);
            IF SalesCrMemoHeader.FINDFIRST THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;

        IF TipoDoc = 2 THEN BEGIN
            Encontrado := FALSE;
            TSH.RESET;
            TSH.SETRANGE("No. Comprobante Fiscal", NCF);
            TSH.SETRANGE("No. Autorizacion Comprobante", NoAut);
            IF TSH.FINDFIRST THEN
                Encontrado := TRUE;

            SSH.RESET;
            SSH.SETRANGE("No. Comprobante Fisc. Remision", NCF);
            SSH.SETRANGE("No. Autorizacion Comprobante", NoAut);
            IF SSH.FINDFIRST THEN
                Encontrado := TRUE;
            EXIT(Encontrado);
        END;
    END;

    PROCEDURE BuscaNoAutNCF(NoSerieNCF: Code[20]; VAR SalesHeader: Record "Sales Header");
    BEGIN
        //Se busca el No. de Autorizacion. Santillana Ecuador
        NoSeriesLine.RESET;
        NoSeriesLine.SETRANGE("Series Code", NoSerieNCF);
        NoSeriesLine.SETFILTER("Starting No.", '<=%1', SalesHeader."No. Comprobante Fiscal");
        NoSeriesLine.SETFILTER("Ending No.", '>=%1', SalesHeader."No. Comprobante Fiscal");
        NoSeriesLine.SETRANGE(Establecimiento, SalesHeader."Establecimiento Factura");
        NoSeriesLine.SETRANGE("Punto de Emision", SalesHeader."Punto de Emision Factura");
        NoSeriesLine.FINDFIRST;
        NoSeriesLine.CALCFIELDS("Facturacion electronica");         //$030
        IF NOT NoSeriesLine."Facturacion electronica" THEN          //
            NoSeriesLine.TESTFIELD("No. Autorizacion");
        NoSeriesLine.TESTFIELD("Tipo Comprobante");
        SalesHeader."No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
        SalesHeader."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";
    END;

    PROCEDURE ValidaNoNCFRel(codPrmEst: Code[3]; codPrmPunto: Code[3]; codPrmNCF: Code[20]);
    VAR
        SCMH: Record "Sales Cr.Memo Header";
        SIH: Record "Sales Invoice Header";
    BEGIN
        //Comentado mientras registran devoluciones que no est n en Navision
        /*
         //Que no lo tenga otra nota de credito
        SCMH.RESET;
        SCMH.SETCURRENTKEY("No. Comprobante Fiscal Rel.");
        SCMH.SETRANGE("No. Comprobante Fiscal Rel.",NCFR);
        IF SCMH.FINDFIRST THEN
          ERROR(Err006,SCMH."No.");

        //Que exista en alguna factura
        SIH.RESET;
        SIH.SETCURRENTKEY("No. Comprobante Fiscal");
        SIH.SETRANGE("No. Comprobante Fiscal",NCFR);
        IF NOT SIH.FINDFIRST THEN
          ERROR(Error07);
         */

        //$031
        SIH.RESET;
        SIH.SETCURRENTKEY("No. Comprobante Fiscal");
        SIH.SETRANGE("No. Comprobante Fiscal", codPrmNCF);
        SIH.SETRANGE("Establecimiento Factura", codPrmEst);
        SIH.SETRANGE("Punto de Emision Factura", codPrmPunto);
        IF NOT SIH.FINDFIRST THEN
            ERROR(Error07);
        //$031
    END;

    PROCEDURE ActCedulaRUC(SH_Loc: Record "Sales Header");
    VAR
        CedRuc: Record "Cedulas/RUC";
    BEGIN
        CedRuc.INIT;
        CedRuc.VALIDATE("Cedula/Ruc", SH_Loc."VAT Registration No.");

        IF SH_Loc."Bill-to Name" <> '' THEN
            CedRuc.VALIDATE(Nombre, SH_Loc."Bill-to Name");

        IF SH_Loc."Bill-to Address" <> '' THEN
            CedRuc.VALIDATE(Direccion, SH_Loc."Bill-to Address");

        IF SH_Loc."No. Telefono (Obsoleto)" <> '' THEN
            CedRuc.VALIDATE(Telefono, SH_Loc."No. Telefono (Obsoleto)");

        IF NOT CedRuc.INSERT(TRUE) THEN
            CedRuc.MODIFY(TRUE);
    END;

    PROCEDURE BuscaNoAutNCFRemision(NoSerieNCF: Code[20]; VAR SalesHeader: Record "Sales Header");
    BEGIN
        //Se busca el No. de Autorizacion. Santillana Ecuador
        NoSeriesLine.RESET;
        NoSeriesLine.SETRANGE("Series Code", NoSerieNCF);
        NoSeriesLine.SETFILTER("Starting No.", '<=%1', SalesHeader."No. Comprobante Fisc. Remision");
        NoSeriesLine.SETFILTER("Ending No.", '>=%1', SalesHeader."No. Comprobante Fisc. Remision");
        NoSeriesLine.FINDFIRST;
        NoSeriesLine.CALCFIELDS("Facturacion electronica");       //$001
        IF NOT NoSeriesLine."Facturacion electronica" THEN        //
            NoSeriesLine.TESTFIELD("No. Autorizacion");
        NoSeriesLine.TESTFIELD(Establecimiento);
        NoSeriesLine.TESTFIELD("Punto de Emision");
        NoSeriesLine.TESTFIELD("Tipo Comprobante");
        SalesHeader."No. Autorizacion Remision" := NoSeriesLine."No. Autorizacion";
        SalesHeader."Tipo Comprobante Remision" := NoSeriesLine."Tipo Comprobante";
        SalesHeader."Establecimiento Remision" := NoSeriesLine.Establecimiento;
        SalesHeader."Punto de Emision Remision" := NoSeriesLine."Punto de Emision";
    END;

    PROCEDURE ControlesFacturaElectronica(recPmrVta: Record "Sales Header");
    VAR
        recLinVta: Record "Sales Line";
        ErrorL001: Label 'El documento %1 %2 no puede tener líneas con cantidad negativa.';
        ErrorL002: Label 'El documento %1 %3 no puede tener líneas con precios negativos.';
        ErrorL003: Label 'El documento %1 %3 no puede tener líneas con importes negativos.';
    BEGIN
        //No puede haber l¡neas con:  cantidades negativas, precios negativos o importes negativos.
        recLinVta.RESET;
        recLinVta.SETRANGE("Document Type", recPmrVta."Document Type");
        recLinVta.SETRANGE("Document No.", recPmrVta."No.");
        recLinVta.SETFILTER(Type, '<>%1', recLinVta.Type::" ");
        IF recLinVta.FINDSET THEN
            REPEAT

                IF recLinVta.Quantity < 0 THEN
                    ERROR(ErrorL001, FORMAT(recPmrVta."Document Type"), recPmrVta."No.");

                IF recLinVta."Unit Price" < 0 THEN
                    ERROR(ErrorL002, FORMAT(recPmrVta."Document Type"), recPmrVta."No.");

                IF recLinVta."Amount Including VAT" < 0 THEN
                    ERROR(ErrorL003, FORMAT(recPmrVta."Document Type"), recPmrVta."No.");

            UNTIL recLinVta.NEXT = 0;
    END;

    PROCEDURE ValidaNoComprobanteFiscal(prmNoCompFiscal: Code[19]);
    VAR
        Texto001: Label 'El campo No. Comprobante Fiscal debe contener 9 dígitos.';
    BEGIN
        //+#43088
        IF prmNoCompFiscal <> '' THEN
            IF STRLEN(prmNoCompFiscal) <> 9 THEN
                ERROR(Texto001);
        //-#43088
    END;

    PROCEDURE ValidaLineas(pSalesHeader: Record "Sales Header");
    VAR
        lrSalesLines: Record "Sales Line";
        lErrorXMLSize: Label 'El tamaño del fichero del comprobante electronico supera el máximo permitido.';
    BEGIN
        //44738:Inicio
        CASE pSalesHeader."Document Type" OF
            pSalesHeader."Document Type"::Invoice:
                BEGIN
                    lrSalesLines.RESET;
                    lrSalesLines.SETRANGE(lrSalesLines."Document Type", pSalesHeader."Document Type");
                    lrSalesLines.SETRANGE(lrSalesLines."Document No.", pSalesHeader."No.");
                    IF lrSalesLines.COUNT > 400 THEN
                        ERROR(lErrorXMLSize);
                END;
        END;
        //#44738:Fin
    END;

    PROCEDURE TestDeleteHeader(SalesHeader: Record "Sales Header"; VAR SalesShptHeader: Record "Sales Shipment Header"; VAR SalesInvHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR ReturnRcptHeader: Record "Return Receipt Header"; VAR SalesInvHeaderPrePmt: Record "Sales Invoice Header"; VAR SalesCrMemoHeaderPrePmt: Record "Sales Cr.Memo Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SourceCodeSetup: Record "Source Code Setup";
    BEGIN
        CLEAR(SalesShptHeader);
        CLEAR(SalesInvHeader);
        CLEAR(SalesCrMemoHeader);
        CLEAR(ReturnRcptHeader);
        SalesSetup.GET;

        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Deleted Document");
        SourceCode.GET(SourceCodeSetup."Deleted Document");

        IF (SalesHeader."Shipping No. Series" <> '') AND (SalesHeader."Shipping No." <> '') THEN BEGIN
            SalesShptHeader.TRANSFERFIELDS(SalesHeader);
            SalesShptHeader."No." := SalesHeader."Shipping No.";
            SalesShptHeader."Posting Date" := TODAY;
            SalesShptHeader."User ID" := USERID;
            SalesShptHeader."Source Code" := SourceCode.Code;
        END;

        IF (SalesHeader."Return Receipt No. Series" <> '') AND (SalesHeader."Return Receipt No." <> '') THEN BEGIN
            ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
            ReturnRcptHeader."No." := SalesHeader."Return Receipt No.";
            ReturnRcptHeader."Posting Date" := TODAY;
            ReturnRcptHeader."User ID" := USERID;
            ReturnRcptHeader."Source Code" := SourceCode.Code;
        END;

        IF (SalesHeader."Posting No. Series" <> '') AND
           ((SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) AND
            (SalesHeader."Posting No." <> '') OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) AND
            (SalesHeader."No. Series" = SalesHeader."Posting No. Series"))
        THEN BEGIN
            SalesInvHeader.TRANSFERFIELDS(SalesHeader);
            IF SalesHeader."Posting No." <> '' THEN
                SalesInvHeader."No." := SalesHeader."Posting No.";
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN BEGIN
                SalesInvHeader."Pre-Assigned No. Series" := SalesHeader."No. Series";
                SalesInvHeader."Pre-Assigned No." := SalesHeader."No.";
            END ELSE BEGIN
                SalesInvHeader."Pre-Assigned No. Series" := '';
                SalesInvHeader."Pre-Assigned No." := '';
                SalesInvHeader."Order No. Series" := SalesHeader."No. Series";
                SalesInvHeader."Order No." := SalesHeader."No.";
            END;
            SalesInvHeader."Posting Date" := TODAY;
            SalesInvHeader."User ID" := USERID;
            SalesInvHeader."Source Code" := SourceCode.Code;
        END;

        IF (SalesHeader."Posting No. Series" <> '') AND
           ((SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"]) AND
            (SalesHeader."Posting No." <> '') OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND
            (SalesHeader."No. Series" = SalesHeader."Posting No. Series"))
        THEN BEGIN
            SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
            IF SalesHeader."Posting No." <> '' THEN
                SalesCrMemoHeader."No." := SalesHeader."Posting No.";
            SalesCrMemoHeader."Pre-Assigned No. Series" := SalesHeader."No. Series";
            SalesCrMemoHeader."Pre-Assigned No." := SalesHeader."No.";
            SalesCrMemoHeader."Posting Date" := TODAY;
            SalesCrMemoHeader."User ID" := USERID;
            SalesCrMemoHeader."Source Code" := SourceCode.Code;
        END;
        IF (SalesHeader."Prepayment No. Series" <> '') AND (SalesHeader."Prepayment No." <> '') THEN BEGIN
            SalesHeader.TESTFIELD("Document Type", SalesHeader."Document Type"::Order);
            SalesInvHeaderPrePmt.TRANSFERFIELDS(SalesHeader);
            SalesInvHeaderPrePmt."No." := SalesHeader."Prepayment No.";
            SalesInvHeaderPrePmt."Order No. Series" := SalesHeader."No. Series";
            SalesInvHeaderPrePmt."Prepayment Order No." := SalesHeader."No.";
            SalesInvHeaderPrePmt."Posting Date" := TODAY;
            SalesInvHeaderPrePmt."Pre-Assigned No. Series" := '';
            SalesInvHeaderPrePmt."Pre-Assigned No." := '';
            SalesInvHeaderPrePmt."User ID" := USERID;
            SalesInvHeaderPrePmt."Source Code" := SourceCode.Code;
            SalesInvHeaderPrePmt."Prepayment Invoice" := TRUE;
        END;

        IF (SalesHeader."Prepmt. Cr. Memo No. Series" <> '') AND (SalesHeader."Prepmt. Cr. Memo No." <> '') THEN BEGIN
            SalesHeader.TESTFIELD("Document Type", SalesHeader."Document Type"::Order);
            SalesCrMemoHeaderPrePmt.TRANSFERFIELDS(SalesHeader);
            SalesCrMemoHeaderPrePmt."No." := SalesHeader."Prepmt. Cr. Memo No.";
            SalesCrMemoHeaderPrePmt."Prepayment Order No." := SalesHeader."No.";
            SalesCrMemoHeaderPrePmt."Posting Date" := TODAY;
            SalesCrMemoHeaderPrePmt."Pre-Assigned No. Series" := '';
            SalesCrMemoHeaderPrePmt."Pre-Assigned No." := '';
            SalesCrMemoHeaderPrePmt."User ID" := USERID;
            SalesCrMemoHeaderPrePmt."Source Code" := SourceCode.Code;
            SalesCrMemoHeaderPrePmt."Prepayment Credit Memo" := TRUE;
        END;
    END;

    PROCEDURE RegistrarCobrosSGT();
    VAR
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MontoIva: Decimal;
        MedPagoSIC: Record "Medios de Pago SIC";
        NoFactura: Code[20];
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    BEGIN
        NoLin := 0;
        dImporte := 0;
        ImporteNeto := 0;
        SIH2.RESET;
        SIH2.SETRANGE("No.", SalesInvHeader."No.");
        IF SIH2.FINDFIRST THEN;

        MediosdePagoMG.RESET;
        MediosdePagoMG.SETCURRENTKEY("Tipo documento", "No. documento", "No. documento SIC");
        MediosdePagoMG.SETRANGE("Tipo documento", 1, 2);//LDP-DsPOS+-
        MediosdePagoMG.SETRANGE("No. documento", SIH2."External Document No.");//01/01/2024 //LDP+-
        MediosdePagoMG.SETRANGE("No. documento SIC", SIH2."No. Documento SIC");
        MediosdePagoMG.SETFILTER(Importe, '<>%1', 0);//0-LDP+-
        IF MediosdePagoMG.FINDSET THEN BEGIN
            REPEAT
                NoLin += 10000;
                ConfMediosdepagos.GET(MediosdePagoMG."Cod. medio de pago");
                //035--

                Bancostienda.RESET;
                Bancostienda.SETRANGE("Cod. Tienda", SalesInvHeader.Tienda);//LDP-DSPOS+-
                Bancostienda.SETRANGE("Cod. Divisa", '');//MediosdePagoMG."Cod. divisa"
                IF Bancostienda.FINDFIRST THEN;
                Bancostienda.TESTFIELD("Cod. Banco");

                //30/12/2024 //LDP+ Validar si existe la línea de pago y que no la inserte nueva vez
                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE("Document Type", BankAccountLedgerEntry."Document Type"::Payment);
                BankAccountLedgerEntry.SETRANGE("Document No.", SIH2."No.");
                BankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
                IF NOT BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                    //30/12/2023 //LDP- Validar si existe la l¡nea de pago y que no la inserte nueva vez

                    //ConfMediosdepagos.TESTFIELD("Account No.");
                    GenJnlLine.INIT;
                    GenJnlLine."Line No." := NoLin;
                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine."Document No." := SalesInvHeader."No.";
                    GenJnlLine."Posting Date" := SalesInvHeader."Posting Date";
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Account No.", SalesInvHeader."Sell-to Customer No.");
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", Bancostienda."Cod. Banco");
                    //GenJnlLine.VALIDATE("Bal. Account No.",Conceptos.Codigo);
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO(Msg001, SalesInvHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MAXSTRLEN(GenJnlLine.Description));
                    GenJnlLine.VALIDATE("Credit Amount", MediosdePagoMG.Importe);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    //GenJnlLine.VALIDATE("Credit Amount",SalesInvoiceLine."Amount Including VAT");
                    //MESSAGE('%1',dImporte);
                    GenJnlLine.VALIDATE("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                    GenJnlLine.VALIDATE("Applies-to Doc. No.", SalesInvHeader."No.");
                    //GenJnlLine.VALIDATE("Dimension Set ID" ,SIH."Dimension Set ID");
                    GenJnlLine."Salespers./Purch. Code" := SalesInvHeader."Salesperson Code";
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");
                    GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", SalesInvHeader."Shortcut Dimension 2 Code");
                    GenJnlLine.VALIDATE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");//034+-
                    GenJnlLine.VALIDATE("External Document No.", SIH2."External Document No.");//034+-

                    OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                    OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                    OldCustLedgEntry.SETRANGE("Customer No.", SalesInvHeader."Sell-to Customer No.");
                    OldCustLedgEntry.SETRANGE(Open, TRUE);//10/01/2023 //LDP+-
                                                          //OldCustLedgEntry.SETRANGE(Open,TRUE);
                    IF OldCustLedgEntry.FINDFIRST THEN BEGIN
                        OldCustLedgEntry.Open := TRUE;
                        OldCustLedgEntry."Forma de Pago" := ConfMediosdepagos."Cod. Forma Pago";//LDP-DSPOS+- Para que la forma de pago del pago sea la misma que la del documento registrado.
                        OldCustLedgEntry.MODIFY(TRUE);
                    END;
                    GenJnlPostLine.RunWithCheck(GenJnlLine);
                END;
            UNTIL MediosdePagoMG.NEXT = 0;

            SIH.RESET;
            SIH.SETRANGE("No.", SalesInvHeader."No.");
            IF SIH.FINDFIRST THEN BEGIN
                SIH."Liquidado TPV" := TRUE;
                SIH.MODIFY;
            END;

        END ELSE BEGIN
            //008
            SIH2.RESET;
            SIH2.SETRANGE("No.", SalesCrMemoHeader."Anula a Documento");//035+-
                                                                        //SIH2.SETRANGE("Location Code",SalesCrMemoHeader."Location Code");
            IF SIH2.FINDFIRST THEN;
            //01/01/2024+ //LDP
            MediosdePagoMG.SETCURRENTKEY("Tipo documento", "No. documento", "No. documento SIC");
            MediosdePagoMG.SETRANGE("Tipo documento", 1, 2);//LDP-DsPOS+-
            MediosdePagoMG.SETRANGE("No. documento", SalesCrMemoHeader."External Document No.");//01/01/2024 //LDP+-
            MediosdePagoMG.SETRANGE("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");
            MediosdePagoMG.SETFILTER(Importe, '<>%1', 0);
            //01/01/2024- //LDP


            IF MediosdePagoMG.FINDSET THEN BEGIN
                REPEAT
                    NoLin += 10000;
                    ConfMediosdepagos.GET(MediosdePagoMG."Cod. medio de pago");//035+-
                    Bancostienda.RESET;
                    Bancostienda.SETRANGE("Cod. Tienda", SalesCrMemoHeader.Tienda);
                    Bancostienda.SETRANGE("Cod. Divisa", SalesCrMemoHeader."Currency Code");//035+- 14-12-2023
                    IF Bancostienda.FINDFIRST THEN;
                    Bancostienda.TESTFIELD("Cod. Banco");

                    //30/12/2024 //LDP+ Validar si existe la l¡nea de pago y que no la inserte nueva vez
                    BankAccountLedgerEntry.RESET;
                    BankAccountLedgerEntry.SETRANGE("Document Type", BankAccountLedgerEntry."Document Type"::Refund);
                    BankAccountLedgerEntry.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                    BankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
                    IF NOT BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                        //30/12/2023 //LDP- Validar si existe la l¡nea de pago y que no la inserte nueva vez
                        //ConfMediosdepagos.TESTFIELD("Account No.");
                        GenJnlLine.INIT;
                        GenJnlLine."Line No." := NoLin;
                        //GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                        GenJnlLine."Document No." := SalesCrMemoHeader."No.";
                        GenJnlLine."Posting Date" := SalesCrMemoHeader."Posting Date";
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE("Account No.", SalesCrMemoHeader."Sell-to Customer No.");
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Bal. Account No.", Bancostienda."Cod. Banco");
                        //GenJnlLine.VALIDATE("Bal. Account No.",Conceptos.Codigo);
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO(Msg001, SalesCrMemoHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MAXSTRLEN(GenJnlLine.Description));
                        GenJnlLine.VALIDATE(Amount, MediosdePagoMG.Importe);
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                        //GenJnlLine.VALIDATE("Credit Amount",SalesInvoiceLine."Amount Including VAT");
                        //MESSAGE('%1',dImporte);

                        //026+ //31/01/2024 //LDP // A solictud, el reembolso debe afectar la NCR.
                        GenJnlLine.VALIDATE("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
                        GenJnlLine.VALIDATE("Applies-to Doc. No.", SalesCrMemoHeader."No.");
                        GenJnlLine.VALIDATE("External Document No.", SalesCrMemoHeader."External Document No.");

                        GenJnlLine."Currency Factor" := SalesCrMemoHeader."Currency Factor";
                        GenJnlLine."Salespers./Purch. Code" := SalesCrMemoHeader."Salesperson Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SalesCrMemoHeader."Shortcut Dimension 1 Code");
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", SalesCrMemoHeader."Shortcut Dimension 2 Code");
                        GenJnlLine.VALIDATE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");//035+- Se inserta la forma de pago.

                        OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                        OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                        OldCustLedgEntry.SETRANGE("Customer No.", SalesCrMemoHeader."Sell-to Customer No.");
                        OldCustLedgEntry.SETRANGE(Open, TRUE);//035+-
                        IF OldCustLedgEntry.FINDFIRST THEN BEGIN
                            OldCustLedgEntry.Positive := FALSE;
                            OldCustLedgEntry.Open := TRUE;//035+-
                            OldCustLedgEntry.MODIFY(TRUE);
                        END;
                        GenJnlPostLine.RunWithCheck(GenJnlLine);
                    END;
                UNTIL MediosdePagoMG.NEXT = 0;
                //01/01/2024+ //LDP
                SCRM.RESET;
                SCRM.SETRANGE("No.", SalesCrMemoHeader."No.");
                IF SCRM.FINDFIRST THEN BEGIN
                    SCRM."Liquidado TPV" := TRUE;
                    SCRM.MODIFY;
                END;
                //01/01/2024+ //LDP
            END;
        END;
    END;

    PROCEDURE RegistrarCobrosTPVManual(NumeroDocumento: Code[20]);
    VAR
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MontoIva: Decimal;
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        Error001: Label 'No existen líneas Medios de Pagos en tabla "Medios de Pagos SIC"';
        CantLineasPago: Integer;
        SalesInvHeader: Record "Sales Invoice Header";
    BEGIN
        NoLin := 0;
        dImporte := 0;
        ImporteNeto := 0;
        CantLineasPago := 0;
        SIH2.RESET;
        SIH2.SETRANGE("No.", NumeroDocumento);
        IF SIH2.FINDFIRST THEN;

        MediosdePagoMG.RESET;
        MediosdePagoMG.SETCURRENTKEY("Tipo documento", "No. documento", "No. documento SIC");//01/01/2024 //LDP+
        MediosdePagoMG.SETRANGE("Tipo documento", 1, 2);//LDP-DsPOS+-
        MediosdePagoMG.SETRANGE("No. documento", SIH2."External Document No.");
        MediosdePagoMG.SETRANGE("No. documento SIC", SIH2."No. Documento SIC");
        CantLineasPago := MediosdePagoMG.COUNT;
        MediosdePagoMG.SETFILTER("Cod. medio de pago", '<>%1&<>%2', '', '99');
        IF (MediosdePagoMG.FINDSET) AND (SIH2."Venta TPV" = TRUE) AND (SIH2."No." <> '') THEN BEGIN
            REPEAT
                NoLin += 10000;
                ConfMediosdepagos.GET(MediosdePagoMG."Cod. medio de pago");
                IF ConfMediosdepagos.Credito THEN
                    EXIT;

                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", SIH2."No.");
                SalesInvoiceLine.CALCSUMS("Amount Including VAT");

                Bancostienda.RESET;
                Bancostienda.SETRANGE("Cod. Tienda", SIH2.Tienda);//LDP-DSPOS+-
                Bancostienda.SETRANGE("Cod. Divisa", '');//MediosdePagoMG."Cod. divisa"
                IF Bancostienda.FINDFIRST THEN;

                Bancostienda.TESTFIELD("Cod. Banco");
                //30/12/2024 //LDP+ Validar si existe la l¡nea de pago y que no la inserte nueva vez
                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE("Document No.", SIH2."No.");
                BankAccountLedgerEntry.SETRANGE("Document Type", BankAccountLedgerEntry."Document Type"::Payment);
                BankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
                IF NOT BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                    //30/12/2023 //LDP- Validar si existe la l¡nea de pago y que no la inserte nueva vez
                    GenJnlLine.INIT;
                    GenJnlLine."Line No." := NoLin;
                    GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine."Document No." := SIH2."No.";
                    GenJnlLine."Posting Date" := SIH2."Posting Date";
                    GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.VALIDATE("Account No.", SIH2."Sell-to Customer No.");
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", Bancostienda."Cod. Banco");
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO(Msg001, SalesInvHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MAXSTRLEN(GenJnlLine.Description));
                    GenJnlLine.VALIDATE("Credit Amount", MediosdePagoMG.Importe);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine.VALIDATE("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                    GenJnlLine.VALIDATE("Applies-to Doc. No.", SIH2."No.");
                    GenJnlLine."Salespers./Purch. Code" := SIH2."Salesperson Code";
                    GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SIH2."Shortcut Dimension 1 Code");
                    GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", SIH2."Shortcut Dimension 2 Code");

                    OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                    OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                    OldCustLedgEntry.SETRANGE("Customer No.", SIH2."Sell-to Customer No.");
                    OldCustLedgEntry.SETRANGE(Open, TRUE);
                    IF OldCustLedgEntry.FINDFIRST THEN BEGIN
                        OldCustLedgEntry.Open := TRUE;
                        OldCustLedgEntry."Forma de Pago" := ConfMediosdepagos."Cod. Forma Pago";//LDP-DSPOS+- Para que la forma de pago del pago sea la misma que la del documento registrado.
                        OldCustLedgEntry.MODIFY(TRUE);
                    END;

                    GenJnlPostLine.RunWithCheck(GenJnlLine);
                END;
            UNTIL MediosdePagoMG.NEXT = 0;
            SIH.RESET;
            SIH.SETRANGE("No.", SIH2."No.");
            IF SIH.FINDFIRST THEN BEGIN
                SIH."Liquidado TPV" := TRUE;
                SIH.MODIFY;
            END;
        END ELSE BEGIN
            //008
            CantLineasPago := 0;
            SIH2.RESET;
            SalesCrMemoHeader.RESET;
            SalesCrMemoHeader.SETRANGE("No.", NumeroDocumento);
            IF SalesCrMemoHeader.FINDFIRST THEN;

            SIH2.SETRANGE("No.", SalesCrMemoHeader."Anula a Documento");
            IF SIH2.FINDFIRST THEN;

            MediosdePagoMG.RESET;
            MediosdePagoMG.SETCURRENTKEY("Tipo documento", "No. documento SIC", "No. documento"); //LDP-DsPOS+- //01/01/2024 //LDP+
            MediosdePagoMG.SETRANGE("Tipo documento", 1, 2);//LDP-DsPOS+-
            MediosdePagoMG.SETRANGE("No. documento SIC", SalesCrMemoHeader."No. Documento SIC");//20/12/2023 //LDP+-
            MediosdePagoMG.SETRANGE("No. documento", SalesCrMemoHeader."External Document No.");//20/12/2023 //LDP+-
                                                                                                //MediosdePagoMG.SETRANGE("Location Code",SIH2."Location Code");
            CantLineasPago := MediosdePagoMG.COUNT;
            MediosdePagoMG.SETFILTER("Cod. medio de pago", '<>%1&<>%2', '', '99');
            IF MediosdePagoMG.FINDSET THEN BEGIN
                REPEAT
                    NoLin += 10000;
                    Bancostienda.RESET;
                    Bancostienda.SETRANGE("Cod. Tienda", SalesCrMemoHeader.Tienda);
                    IF Bancostienda.FINDFIRST THEN;


                    //LDP- 21/12/2023
                    //30/12/2024 //LDP+ Validar si existe la l¡nea de pago y que no la inserte nueva vez
                    BankAccountLedgerEntry.RESET;
                    BankAccountLedgerEntry.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                    BankAccountLedgerEntry.SETRANGE("Document Type", BankAccountLedgerEntry."Document Type"::Refund);
                    BankAccountLedgerEntry.SETRANGE("Forma de Pago", ConfMediosdepagos."Cod. Forma Pago");
                    IF NOT BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                        //30/12/2023 //LDP- Validar si existe la l¡nea de pago y que no la inserte nueva vez

                        Bancostienda.TESTFIELD("Cod. Banco");
                        GenJnlLine.INIT;
                        GenJnlLine."Line No." := NoLin;
                        GenJnlLine."Document No." := SalesCrMemoHeader."No.";
                        GenJnlLine."Posting Date" := SalesCrMemoHeader."Posting Date";
                        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
                        GenJnlLine.VALIDATE("Account No.", SalesCrMemoHeader."Sell-to Customer No.");
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Bal. Account No.", Bancostienda."Cod. Banco");
                        GenJnlLine.Description := COPYSTR(STRSUBSTNO(Msg001, SalesCrMemoHeader."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MAXSTRLEN(GenJnlLine.Description));
                        GenJnlLine.VALIDATE(Amount, MediosdePagoMG.Importe);
                        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;

                        //026+ //31/01/2024 //LDP // A solictud, el reembolso debe afectar la NCR.
                        GenJnlLine.VALIDATE("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
                        GenJnlLine.VALIDATE("Applies-to Doc. No.", SalesCrMemoHeader."No.");
                        GenJnlLine.VALIDATE("External Document No.", SalesCrMemoHeader."External Document No.");

                        GenJnlLine."Currency Factor" := SalesCrMemoHeader."Currency Factor";
                        GenJnlLine."Salespers./Purch. Code" := SalesCrMemoHeader."Salesperson Code";
                        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SalesCrMemoHeader."Shortcut Dimension 1 Code");
                        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", SalesCrMemoHeader."Shortcut Dimension 2 Code");

                        OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                        OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                        OldCustLedgEntry.SETRANGE("Customer No.", SalesCrMemoHeader."Sell-to Customer No.");//20/12/2023 //LDP+-
                        OldCustLedgEntry.SETRANGE(Open, TRUE);
                        IF OldCustLedgEntry.FINDFIRST THEN BEGIN
                            OldCustLedgEntry.Positive := FALSE;
                            OldCustLedgEntry.Positive := TRUE; //20/12/2023 //LDP+-
                            OldCustLedgEntry.MODIFY(TRUE);
                        END;

                        GenJnlPostLine.RunWithCheck(GenJnlLine);
                    END;
                UNTIL MediosdePagoMG.NEXT = 0;
                //LDP+ //01/01/2023
                SCRM.RESET;
                SCRM.SETRANGE("No.", SalesCrMemoHeader."No.");
                IF SCRM.FINDFIRST THEN BEGIN
                    SCRM."Liquidado TPV" := TRUE;
                    SCRM.MODIFY;
                END;
                //LDP- //01/01/2023
            END;
            IF CantLineasPago = 0 THEN
                ERROR(Error001);
        END;
    END;

    PROCEDURE DesliquidaFacturaTPV(_SalesHeader: Record 36);
    VAR
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        CantRegistros: Integer;
        I: Integer;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    BEGIN
        DetailedCustLedgEntry.RESET;
        DetailedCustLedgEntry.SETRANGE("Customer No.", _SalesHeader."Sell-to Customer No.");
        DetailedCustLedgEntry.SETRANGE("Document No.", _SalesHeader."Applies-to Doc. No.");
        DetailedCustLedgEntry.SETRANGE(DetailedCustLedgEntry."Entry Type", DetailedCustLedgEntry."Entry Type"::Application);
        DetailedCustLedgEntry.SETRANGE(DetailedCustLedgEntry."Document Type", DetailedCustLedgEntry."Document Type"::Payment);
        DetailedCustLedgEntry.SETRANGE(DetailedCustLedgEntry."Initial Document Type", DetailedCustLedgEntry."Initial Document Type"::Payment);
        DetailedCustLedgEntry.SETFILTER(DetailedCustLedgEntry.Amount, '>%1', 0);
        DetailedCustLedgEntry.SETRANGE(Unapplied, FALSE);
        DetailedCustLedgEntry.SETASCENDING("Entry No.", FALSE);
        CantRegistros := DetailedCustLedgEntry.COUNT;
        IF DetailedCustLedgEntry.FINDSET() THEN BEGIN
            REPEAT
            /*          IF (GenJnlCheckLine.DateNotAllowed(DetailedCustLedgEntry."Posting Date")) THEN // 12/12/2023 //LDP - Si la fecha de contabilidad esta cerrada, se env¡a con al fecha abierta de la nota de credito para liquidar.
                         CustEntryApplyPostedEntries.PostUnApplyCustomer(DetailedCustLedgEntry, DetailedCustLedgEntry."Document No.", _SalesHeader."Posting Date")
                     ELSE
                         CustEntryApplyPostedEntries.PostUnApplyCustomer(DetailedCustLedgEntry, DetailedCustLedgEntry."Document No.", DetailedCustLedgEntry."Posting Date"); */
            UNTIL DetailedCustLedgEntry.NEXT = 0;
        END;

    END;


    var
        //NothingToPostErr,PostingSalesAndVATMsg Traducción Francés
        //ZeroDeferralAmtErr Traducción español
        SalesPost: Codeunit "Sales-Post";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        cuLocalizacion: Codeunit "Validaciones Localizacion";
        CustPostingGr: Record "Customer Posting Group";
        NoSeriesMgt: Codeunit "No. Series";
        LinSerie: Record "No. Series Line";
        Err0016: Label '%1 can not be after %2 of the NCF serial no., corresponding values are %3 and %4';//;ESP=%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4;ESM=%1 no puede ser posterior a %2 del numerador de NCF, los valores correspondientes son %3 y %4';
        Err0017: Label 'The %1 could not be generated, please retry Register Order.';//;ESP=No se pudo generar el %1 favor volver a intentar Registrar Pedido.;ESM=No se pudo generar el %1 favor volver a intentar Registrar Pedido.';
        ConfSantillana: Record "Config. Empresa";
        ControlLinxDoc: Record "Config. Max. Lineas Reportes";
        rPagosTPV: Record "Tipos de Tarjeta";
        rSalesLine: Record "Sales Line";
        wCambio: Decimal;
        v1: Decimal;
        v2: Decimal;
        v3: Decimal;
        v4: Decimal;
        v5: Decimal;
        rSalesHeader: Record "Sales Header";
        PrecioConduceVenta: Decimal;
        DescuentoVenta: Decimal;
        rConfTPV: Record "Configuracion General DsPOS";
        UserSetUp: Record "User Setup";
        ValidaReq: Codeunit "Valida Campos Requeridos";
        SSH: Record "Sales Shipment Header";
        SCMH: Record "Sales Cr.Memo Header";
        NoSeriesLine: Record "No. Series Line";
        Err001: Label 'Document %1 exceed the amount of line allowed for %2 %3';//ESP=El documento %1 sobrepasa el l¡mite de l¡neas permitidas para %2 %3;ESM=El documento %1 sobrepasa el l¡mite de l¡neas permitidas para %2 %3';
        Err002: Label 'You must indicate the Port number and the Speed for the Fiscal Printer in the User Setup table for the user %1';//ESM=Debe indicar el Puerto y la Velocidad de la impresora Fiscal en la configuraci¢n de usuarios para el usuario %1';
        Err003: Label 'Correlative number already exists y Invoice %1';//ESM=N£mero de Correlativo ya existe en Factura %1';
        Err004: Label 'Correlative number already exists y Credit Memo %1';//ESM=N£mero de Correlativo ya existe en Abono %1';
        _Err005: Label 'Correlative number already exists y Shipment %1';//ESM=N£mero de Correlativo ya existe en Remisi¢n %1';
        error001: Label 'You cannot assing NCF for Correction Credit Memo';//ESM=Para Nota de crédito corrección no debe asignarse número de comprobante';
        txt009: Label 'ANULADO';
        Err006: Label 'Related NCF already exist in the Credit Memo %1';//ESM=No. Comprobante Relacionado ya existe en la Nota de Cr‚dito %1';
        Error07: Label 'NCF Related does not exist in any invoice';//ESM=Establecimiento, Punto de emisión y No. Comprobante Relacionado no existe en ninguna factura registrada';
        Error08: Label 'La fecha de inicio de transporte no puede ser posterior a la fecha de fin.';
        cFunMdM: Codeunit "Funciones MdM";
        CantLin: Integer;
        ParamPais: Record "Parametros Loc. x País";
        SIH: Record "Sales Invoice Header";
        NCFAnulados: Record "NCF Anulados";
        cEnvioMailCli: Codeunit "Email packing";
        recNoSeries: Record "No. Series";
        recTransportista: Record "Shipping Agent";
        SalesLine: Record "Sales Line";
        SourceCode: Record "Source Code";

    /*
      fProyecto: Microsoft Dynamics Nav
      ---------------------------------
      AMS     : Agust¡n M‚ndez
      GRN     : Guillermo Rom n
      FES     : Fausto Serrata
      ------------------------------------------------------------------------
      No.         Firma       Fecha            Descripcion
      ------------------------------------------------------------------------
      DSLoc1.03   GRN         01/05/2018       Funcionalidad localizado RD
      DSLoc1.02
      DSLoc1.01

      DSLoc1.01   04/07/2011      GRN           Para adicionar funcionalidad Facturacion con limite de lineas - Guatemala y NCF
      001         13/07/2011      AMS           Asignacion de No. de factura a pago TPV al registrar en linea.
      002         13/07/2011      AMS           Datos POS
      003         14/07/2011      AMS           Se inserta el Cambio antes de registrar la factura.
      004         15/07/2011      AMS           Importe y Precio Consignacion
      005         19/08/2011      GRN           Para adicionar funcionalidad Facturacion con limite de lineas
                                                por ID del reporte - El Salvador
      006         01/09/2011      AMS           Se actualiza la cantidad pendiente del Cupon
      007         03/10/2011      AMS           Para utilizar con el NAS
      008         03/10/2011      AMS           En caso de ser pedido TPV se evita la pregunta de "Enviar y Facturar"
      009         03/10/2011      AMS           Para pder replicar las lineas de facturas de ventas a las lineas de
                                                pedidos de venta.
      010         05/10/2011      AMS           Para los pedidos TPV la fecha de registro siempre ser  la fecha de trabajo
      011         24/01/2011      GRN           Para desmarcar la seleccion de re facturar
      012         02/03/2011      AMS           Para la fact. elect. es obligatorio que la Nota de Cr‚dito tenga el No. Fact. Rel.
      013         06/03/2012      AMS           Registro de ventas con la fecha del dia
      014         02/04/2012      AMS           Se pasa al mov. producto el dato si aplica para derecho de autor.
      015         02/07/2012      AMS           Se controla que no se pueda registrar sin RNC
      016         02/07/2012      AMS           Se lleva el campo "Fecha de Entrega requerida" al historico de factura.
      017         06/07/2012      AMS           Se llevan datos a las tablas de movimientos
      018         12/07/12        AMS           Para crear ordenes de compra con lineas de venta
      019         31/07/12        AMS           Validacion Imp. Fiscal Panama
      022         18/09/12        AMS           Se controla el No. de Serie de Remision de venta en el caso de que esta funcionalidad est‚
                                                activada.
      027         28/10/12        AMS           Valida Campos y Dimensiones Requeridas
      028         29/10/12        AMS           Anulacion de Remision NCF
      029         14/03/12        AMS           Actualizacion archivo de Cedulas/Ruc
      #842        05/02/13        CAT           Envio mail al cliente con los datos del envio del pedido
      $030        08/01/15        JML           Cambios en control de NCF para facturaci¢n electr¢nica.
                                                Cuando la serie es de Facturaci¢n electr¢nica no tiene autorizaci¢n.
                                                Si es facturaci¢n electr¢nica el comprobante se asigna en el registro de la remisi¢n, no en la impresi¢n.
      $031        14/01/15        JML           A¤ado campo Establecimiento y punto de emison relacionados. Son obligatiros para la FE.
      $032        10/03/15        JML           Nuevo control fechas de transporte
      #30531      09/09/2015      FAA           Mover dato de campo a la tabla 81

      #34853      12/11/2015      CAT           Controles en el registro de facturas de exportaci¢n
      #38359      30/11/2015      JML           Nuevos controles para facturaci¢n electr¢nica
      #43088      26/01/16        CAT           Se valida campo "No. Comprobante Fiscal" tenga 9 digitos.
      #44738      02/02/2016      MOI           Se limita el numero de lineas de las facturas a la hora de registrar.

      #57189      28/10/2016      PLB           Al facturar un pedido, si ten¡a back orders, pero la cantidad estaba facturada, borraba el pedido
    #209115     04/04/2019      JPT           MdM - Automatizar fecha entrada almacen y fecha comercialilzacion

      033         24-Oct-2022     FES           Funcionalidad no aplica en Santillana Ecuador. Migraci¢n a Bussiness Central

    #514701     30-Dic-2022     RRT           Adaptaciones para DsPos.

      034         29-05-2023      LDP           Integracion DSPOS: Se registran los cobros de documentos POS.
      4721        07/08/2023      jpg           SANTINAV-4721    Copiar l¡neas - facturas y notas de cr‚dito ventas - gesti¢n de movimientos de almac‚n
      035         28/08/2023      LDP           Mejoras integracion Ds-POS se desliquida la factura antes de registrar la nota de cr‚dito.
      036         04/09/2023      LDP           Para indicar desliquidar y liquidar facturas TPV se realice autom tico o no.
      037         21/11/2023      LDP           Para evitar error al liquidar notas documentos DSPOS.
      038         28/11/2023      LDP           Para solucionar error de NCF por Testfield en documentos de distintos POS.
      039         31/01/2024      LDP           Para que no se desliquide la factura en notas de credito,mov contables, ser n: Pago contra factura, reembolso contra ncr.
    */
}