codeunit 76056 "Pre Sales-Order to Order"
{
    // DSLoc1.01   GRN     04/07/2011    Para adicionar funcionalidad Facturacion con limite de lineas - Guatemala
    // #825 CAT  09/01/14  No se eliminan los comentarios del prepedido hasta que esten generados todos los pedidos
    // #13586    FAA   13/03/2015  Se tranpasa la información a los dos campos nuevos creados table 36, 56303 y 56304
    // 
    // #71176  JPT 29/06/2017 Fecha Aprobacion Pedido .Este campo se debe llenar solo al momento de convertirse de un Pre Pedido a Pedido tanto para venta como transferencia tomando la fecha en la que se esta ejecutando
    //                        siendo este un valor no editable y fijo, cabe recalcar que este campo debe viajar como referencia al histórico de facturas de venta y guía de remisión para su trazabilidad.

    TableNo = "Sales Header";

    trigger OnRun()
    var
        Result: Decimal;
    begin
        Rec.TestField("Pre pedido", true);

        //DSLoc1.01
        ConfigSantillana.Get();
        if ConfigSantillana."Vendedor Obligatorio" then
            Rec.TestField("Salesperson Code");

        ConfigSantillana.TestField(Country);
        if ConfigSantillana."Control Lin. por Factura" then
            ConfigSantillana.TestField("Cantidad Lin. por factura");

        ValidaReq.Documento(36, Rec."Document Type".AsInteger(), Rec."No.");
        ValidaReq.Dimensiones(36, Rec."No.", 1, Rec."Document Type".AsInteger());

        //ParamPais.GET(ConfigSantillana.Country);
        //IF ParamPais."Control Lin. por Factura" THEN
        //   ParamPais.TESTFIELD("Cantidad Lin. por factura");

        // *** End ***

        Cust.Get(Rec."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, Rec."Document Type"::Order, true, false);
        Rec.CalcFields("Amount Including VAT");
        SalesOrderHeader := Rec;
        SalesQuoteHeader := Rec;

        if GuiAllowed and not HideValidationDialog then
            /*   CustCheckCreditLimit.SalesHeaderCheck(SalesOrderHeader); */

        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;

        //#13586++
        SalesOrderHeader."Fecha Aprobacion" := Today;
        SalesOrderHeader."Hora Aprobacion" := Time;
        //#13586--

        SalesQuoteLine.Reset;
        SalesQuoteLine.SetRange("Document Type", Rec."Document Type");
        SalesQuoteLine.SetRange("Document No.", Rec."No.");
        //SalesQuoteLine.SETRANGE(Type,SalesQuoteLine.Type::Item); //AMS para que funcione tambien para cuentas
        //SalesQuoteLine.SETFILTER("No.",'<>%1','');  //Para que tome en cuenta las lineas de descripcion adicional
        if SalesQuoteLine.FindSet then
            repeat
                ContLin += 1;
                if (SalesQuoteLine."Outstanding Quantity" > 0) then begin
                    SalesLine := SalesQuoteLine;
                    SalesLine.Validate("Reserved Qty. (Base)", 0);
                    SalesLine."Line No." := 0;
                    if GuiAllowed and not HideValidationDialog then begin
                        ItemCheckAvail.SalesLineCheck(SalesLine);
                    end;
                end;
            until SalesQuoteLine.Next = 0;


        ConfigSantillana.TestField("Cantidad Lin. por factura");
        Result := ContLin / ConfigSantillana."Cantidad Lin. por factura" mod 1;
        if Result <> 0 then
            for i := 1 to Round(ContLin / ConfigSantillana."Cantidad Lin. por factura", 1, '<') + 1 do
                CrearCabecera
        else
            for i := 1 to Round(ContLin / ConfigSantillana."Cantidad Lin. por factura", 1, '<') do
                CrearCabecera;

        //inicio #825
        SalesCommentLine.SetRange("Document Type", Rec."Document Type");
        SalesCommentLine.SetRange("No.", Rec."No.");
        if SalesCommentLine.FindFirst then
            SalesCommentLine.DeleteAll;
        //FIN #825

        Rec.DeleteLinks;
        Rec.Delete;

        SalesQuoteLine.Reset;
        SalesQuoteLine.SetRange("Document Type", Rec."Document Type");
        SalesQuoteLine.SetRange("Document No.", Rec."No.");
        SalesQuoteLine.DeleteAll;

        Commit;
        /*    Clear(CustCheckCreditLimit); */
        Clear(ItemCheckAvail);
    end;

    var
        Text000: Label 'An Open Opportunity is linked to this quote.\';
        Text001: Label 'It has to be closed before an Order can be made.\';
        Text002: Label 'Do you wish to close this Opportunity now?';
        Text003: Label 'Wizard Aborted';
        SalesQuoteLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        /*  CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit"; */
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        DocDim: Codeunit DimensionManagement;
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        HideValidationDialog: Boolean;
        Text004: Label 'The Opportunity has not been closed. The program has aborted making the Order.';
        SalesDocLineComment: Record "Sales Comment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        ContLin: Integer;
        "*** DSLoc1.01 ***": Integer;
        SalesQuoteHeader: Record "Sales Header";
        ParamPais: Record "Parametros Loc. x País";
        Seq: Integer;
        i: Integer;
        OldSalesCommentLine: Record "Sales Comment Line";
        Cust: Record Customer;
        "*** Santillana ***": Integer;
        ConfigSantillana: Record "Config. Empresa";
        NoLin: Integer;
        ValidaReq: Codeunit "Valida Campos Requeridos";
        ReleaseSalesDoc: Codeunit "Release Sales Document";


    procedure GetSalesOrderHeader(var SalesHeader2: Record "Sales Header")
    begin
        SalesHeader2 := SalesOrderHeader;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure CrearCabecera()
    var
        CantLin: Integer;
    begin
        Seq += 1;
        CantLin := 0;
        SalesOrderHeader."No. Printed" := 0;
        SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
        SalesOrderHeader."No." := SalesQuoteHeader."No." + '-' + Format(Seq);
        Clear(SalesOrderHeader."Pre pedido");
        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        SalesOrderHeader."Dimension Set ID" := SalesQuoteHeader."Dimension Set ID";
        SalesOrderHeader."Order Date" := SalesOrderHeader."Order Date";
        if SalesOrderHeader."Posting Date" <> 0D then
            SalesOrderHeader."Posting Date" := SalesOrderHeader."Posting Date";
        SalesOrderHeader."Document Date" := SalesOrderHeader."Document Date";
        SalesOrderHeader."Shipment Date" := SalesOrderHeader."Shipment Date";
        SalesOrderHeader."Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
        SalesOrderHeader."Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
        //SalesOrderHeader."Date Sent" := 0D;
        //SalesOrderHeader."Time Sent" := 0T;

        //SalesOrderHeader."Location Code" := SalesOrderHeader."Location Code";
        SalesOrderHeader."Location Code" := SalesQuoteHeader."Location Code";
        SalesOrderHeader."Outbound Whse. Handling Time" := SalesOrderHeader."Outbound Whse. Handling Time";
        SalesOrderHeader."Ship-to Name" := SalesOrderHeader."Ship-to Name";
        SalesOrderHeader."Ship-to Name 2" := SalesOrderHeader."Ship-to Name 2";
        SalesOrderHeader."Ship-to Address" := SalesOrderHeader."Ship-to Address";
        SalesOrderHeader."Ship-to Address 2" := SalesOrderHeader."Ship-to Address 2";
        SalesOrderHeader."Ship-to City" := SalesOrderHeader."Ship-to City";
        SalesOrderHeader."Ship-to Post Code" := SalesOrderHeader."Ship-to Post Code";
        SalesOrderHeader."Ship-to County" := SalesOrderHeader."Ship-to County";
        SalesOrderHeader."Ship-to Country/Region Code" := SalesOrderHeader."Ship-to Country/Region Code";
        SalesOrderHeader."Ship-to Contact" := SalesOrderHeader."Ship-to Contact";
        SalesOrderHeader."Reason Code" := SalesOrderHeader."Reason Code";

        SalesOrderHeader."Prepayment %" := Cust."Prepayment %";
        if SalesOrderHeader."Posting Date" = 0D then
            SalesOrderHeader."Posting Date" := WorkDate;

        SalesOrderHeader.Modify;

        SalesQuoteLine.Reset;
        SalesQuoteLine.SetRange("Document Type", SalesQuoteHeader."Document Type");
        SalesQuoteLine.SetRange("Document No.", SalesQuoteHeader."No.");
        if NoLin <> 0 then
            SalesQuoteLine.SetFilter("Line No.", '%1..', NoLin);

        if SalesQuoteLine.FindSet then
            repeat
                CantLin += 1;
                NoLin := SalesQuoteLine."Line No.";

                if CantLin > ConfigSantillana."Cantidad Lin. por factura" then begin
                    //inicio #825
                    SalesCommentLine.SetRange("Document Type", SalesQuoteLine."Document Type");
                    SalesCommentLine.SetRange("No.", SalesQuoteHeader."No.");
                    if not SalesCommentLine.IsEmpty then begin
                        SalesCommentLine.LockTable;
                        if SalesCommentLine.FindSet then
                            repeat
                                OldSalesCommentLine := SalesCommentLine;
                                SalesCommentLine."Document Type" := SalesOrderHeader."Document Type";
                                SalesCommentLine."No." := SalesOrderHeader."No.";
                                SalesCommentLine.Insert;
                                SalesCommentLine := OldSalesCommentLine;
                            until SalesCommentLine.Next = 0;
                    end;
                    //fin #825
                    ReleaseSalesDoc.PerformManualRelease(SalesOrderHeader);
                    exit;
                end;
                SalesOrderLine := SalesQuoteLine;
                SalesOrderLine."Document Type" := SalesOrderHeader."Document Type";
                SalesOrderLine."Document No." := SalesOrderHeader."No.";
                ReserveSalesLine.TransferSaleLineToSalesLine(
                  SalesQuoteLine, SalesOrderLine, SalesQuoteLine."Outstanding Qty. (Base)");
                SalesOrderLine."Shortcut Dimension 1 Code" := SalesQuoteLine."Shortcut Dimension 1 Code";
                SalesOrderLine."Shortcut Dimension 2 Code" := SalesQuoteLine."Shortcut Dimension 2 Code";

                if Cust."Prepayment %" <> 0 then
                    SalesOrderLine."Prepayment %" := Cust."Prepayment %";
                PrepmtMgt.SetSalesPrepaymentPct(SalesOrderLine, SalesOrderHeader."Posting Date");
                SalesOrderLine.Validate("Prepayment %");
                SalesOrderLine."Dimension Set ID" := SalesQuoteLine."Dimension Set ID";
                SalesOrderLine.Insert;

                ReserveSalesLine.VerifyQuantity(SalesOrderLine, SalesQuoteLine);

                if SalesOrderLine.Reserve = SalesOrderLine.Reserve::Always then begin
                    SalesOrderLine.AutoReserve;
                end;

            until SalesQuoteLine.Next = 0;

        SalesSetup.Get;

        if SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" then begin
            SalesOrderHeader."Posting Date" := 0D;
            SalesOrderHeader.Modify;
        end;

        SalesCommentLine.SetRange("Document Type", SalesQuoteLine."Document Type");
        SalesCommentLine.SetRange("No.", SalesQuoteHeader."No.");
        if not SalesCommentLine.IsEmpty then begin
            SalesCommentLine.LockTable;
            if SalesCommentLine.FindSet then
                repeat
                    OldSalesCommentLine := SalesCommentLine;
                    //inicio #825
                    //- SalesCommentLine.DELETE;
                    //fin #825
                    SalesCommentLine."Document Type" := SalesOrderHeader."Document Type";
                    SalesCommentLine."No." := SalesOrderHeader."No.";
                    SalesCommentLine.Insert;
                    SalesCommentLine := OldSalesCommentLine;
                until SalesCommentLine.Next = 0;
        end;
        SalesOrderHeader.CopyLinks(SalesQuoteHeader);

        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetRange("Document Type", SalesQuoteHeader."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.", SalesQuoteHeader."No.");
        while ItemChargeAssgntSales.FindFirst do begin
            ItemChargeAssgntSales.Delete;
            ItemChargeAssgntSales."Document Type" := SalesOrderHeader."Document Type";
            ItemChargeAssgntSales."Document No." := SalesOrderHeader."No.";
            if not (ItemChargeAssgntSales."Applies-to Doc. Type" in
                    [ItemChargeAssgntSales."Applies-to Doc. Type"::Shipment,
                     ItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt"])
            then begin
                ItemChargeAssgntSales."Applies-to Doc. Type" := SalesOrderHeader."Document Type";
                ItemChargeAssgntSales."Applies-to Doc. No." := SalesOrderHeader."No.";
            end;
            ItemChargeAssgntSales.Insert;
        end;
        ReleaseSalesDoc.PerformManualRelease(SalesOrderHeader);
    end;
}

