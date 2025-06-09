codeunit 50119 "Sales-Post + Print SIC_BC"
{
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  001     24-03-2023      LDP      Registro firmas DSPOS por lote.

    TableNo = "Sales Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Copy(Rec);
        Code(SalesHeader);
        Rec := SalesHeader;
    end;

    var
        ShipInvoiceQst: Label '&Ship,&Invoice,Ship &and Invoice';
        PostAndPrintQst: Label 'Do you want to post and print the %1?', Comment = '%1 = Document Type';
        PostAndEmailQst: Label 'Do you want to post and email the %1?', Comment = '%1 = Document Type';
        ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
        SendReportAsEmail: Boolean;
        i: Integer;


    procedure PostAndEmail(var ParmSalesHeader: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        SendReportAsEmail := true;
        SalesHeader.Copy(ParmSalesHeader);
        Code(SalesHeader);
        ParmSalesHeader := SalesHeader;
    end;

    local procedure "Code"(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        /*         SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue"; */
        HideDialog: Boolean;
    begin
        HideDialog := true;

        /*
        OnBeforeConfirmPost(SalesHeader,HideDialog);
        IF NOT HideDialog THEN
          IF NOT ConfirmPost(SalesHeader) THEN
            EXIT;
        */

        /*   SalesSetup.Get;
          if SalesSetup."Post & Print with Job Queue" and not SendReportAsEmail then
              /*  SalesPostViaJobQueue.EnqueueSalesDoc(SalesHeader) */
        /*    else begin
               if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
                   CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesHeader);
               end else begin
                   CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesHeader);
               end;
               GetReport(SalesHeader);
           end; */

        OnAfterPost(SalesHeader);
        Commit;

    end;

    procedure GetReport(var SalesHeader: Record "Sales Header")
    begin
        //LDP+-
        /*
        WITH SalesHeader DO
          CASE "Document Type" OF
            "Document Type"::Invoice:
              BEGIN
                //IF Ship THEN
                //  PrintShip(SalesHeader);
        //        IF Invoice THEN
        //          PrintInvoice(SalesHeader);
              END;
            //"Document Type"::Invoice:
              //PrintInvoice(SalesHeader);
            //LDP-001+-
            {
            "Document Type"::"Return Invoice":
              BEGIN
               { IF Receive THEN // NO IMPRIMIR DEVOLUCIONES AUTOMATICAMENTE
                  PrintReceive(SalesHeader);
                IF Invoice THEN
                  PrintCrMemo(SalesHeader);}
              END;
            }
            //LDP-001+-
            "Document Type"::"Credit Memo":
              BEGIN
              //PrintCrMemo(SalesHeader);
              END;
          END;
          */
        //LDP--

    end;

    local procedure ConfirmPost(var SalesHeader: Record "Sales Header"): Boolean
    var
        Selection: Integer;
    begin
        //LDP+-
        /*
        WITH SalesHeader DO BEGIN
          CASE "Document Type" OF
            "Document Type"::Invoice:
              BEGIN
                Selection := STRMENU(ShipInvoiceQst,3);
                IF Selection = 0 THEN
                  EXIT(FALSE);
                Ship := Selection IN [1,3];
                Invoice := Selection IN [2,3];
              END;
            //LDP-001+-
            {
            "Document Type"::"Return Invoice":
              BEGIN
                Selection := STRMENU(ReceiveInvoiceQst,3);
                IF Selection = 0 THEN
                  EXIT(FALSE);
                Receive := Selection IN [1,3];
                Invoice := Selection IN [2,3];
              END
             }
             //LDP-001+-
            ELSE
              IF NOT CONFIRM(ConfirmationMessage,FALSE,"Document Type") THEN
                EXIT(FALSE);
          END;
          "Print Posted Documents" := TRUE;
        END;
        EXIT(TRUE);
        //LDP+-
        */

    end;

    local procedure ConfirmationMessage(): Text
    begin
        if SendReportAsEmail then
            exit(PostAndEmailQst);
        exit(PostAndPrintQst);
    end;

    local procedure PrintReceive(SalesHeader: Record "Sales Header")
    var
        ReturnRcptHeader: Record "Return Receipt Header";
    begin
        ReturnRcptHeader."No." := SalesHeader."Last Return Receipt No.";
        if ReturnRcptHeader.Find then;
        ReturnRcptHeader.SetRecFilter;

        if SendReportAsEmail then
            ReturnRcptHeader.EmailRecords(true)
        else
            ReturnRcptHeader.PrintRecords(false);
    end;

    local procedure PrintInvoice(SalesHeader: Record "Sales Header")
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        if SalesHeader."Last Posting No." = '' then
            SalesInvHeader."No." := SalesHeader."No."
        else
            SalesInvHeader."No." := SalesHeader."Last Posting No.";
        SalesInvHeader.Find;
        SalesInvHeader.SetRecFilter;

        ///JERM
        //TestPrintMult.TestPirint(SalesInvHeader."No.");
        ///JERM
        //
        //
        // IF SendReportAsEmail THEN
        //  SalesInvHeader.EmailRecords(TRUE)
        // ELSE;
        //  // ++ YFC
        //  //SalesInvHeader.PrintRecords(FALSE);
        //  BEGIN
        //    FOR i := 1 TO 2 DO
        //      BEGIN
        //        CASE i OF
        //          1: BEGIN
        //               FacturaventaKettleSanchez.RecibirValores('Original');
        //               FacturaventaKettleSanchez.RecibePedido(SalesInvHeader."No.");
        //
        //             END;
        //          2: BEGIN
        //               FacturaventaKettleSanchez.RecibirValores('Copia Original');
        //               FacturaventaKettleSanchez.RecibePedido(SalesInvHeader."No.");
        //
        //             END;
        //        END;
        //        FacturaventaKettleSanchez.RUN;
        //    // REPORT.RUNMODAL(50010,FALSE,FALSE,RecVarToPrint);
        //      //CLEAR(FacturaventaKettleSanchez);
        //      END;
        //    //REPORT.RUNMODAL(50032,FALSE,FALSE,RecVarToPrint);
        //    FacturaventaKettleSVS20.RecibePedido(SalesInvHeader."No.");
        //    FacturaventaKettleSVS20.RUN;
        //  END;

        // --
    end;

    local procedure PrintShip(SalesHeader: Record "Sales Header")
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader."No." := SalesHeader."Last Shipping No.";
        if SalesShptHeader.Find then;
        SalesShptHeader.SetRecFilter;

        if SendReportAsEmail then
            SalesShptHeader.EmailRecords(true)
        else
            SalesShptHeader.PrintRecords(false);
    end;

    local procedure PrintCrMemo(SalesHeader: Record "Sales Header")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        if SalesHeader."Last Posting No." = '' then
            SalesCrMemoHeader."No." := SalesHeader."No."
        else
            SalesCrMemoHeader."No." := SalesHeader."Last Posting No.";
        SalesCrMemoHeader.Find;
        SalesCrMemoHeader.SetRecFilter;

        if SendReportAsEmail then
            SalesCrMemoHeader.EmailRecords(true)
        else
            SalesCrMemoHeader.PrintRecords(false);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean)
    begin
    end;
}

