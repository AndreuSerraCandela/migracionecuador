codeunit 50002 "Events Pages"
{
    // .-.-.-.-.-.- Events for Apply Customer Entries Page .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Page, Page::"Apply Customer Entries", 'OnSetCustApplIdOnAfterCheckAgainstApplnCurrency', '', false, false)]
    local procedure OnBeforeSetCustEntryApplID(CustLedgerEntry: Record "Cust. Ledger Entry"; CalcType: Option; ApplyingCustLedgEntry: Record "Cust. Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line")
    var
        RaiseError: Boolean;
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PageACE: Page "Apply Customer Entries";
        EarlierPostingDateErr: Label 'You cannot apply and post an entry to an entry with an earlier posting date.\\Instead, post the document of type %1 with the number %2 and then apply it to the document of type %3 with the number %4.', Comment = '%1 - document type, %2 - document number,%3 - document type,%4 - document number';
    begin
        if CalcType = 1 then begin
            RaiseError := ApplyingCustLedgEntry."Posting Date" < CustLedgerEntry."Posting Date";
            if RaiseError then
                Error(
                  EarlierPostingDateErr, ApplyingCustLedgEntry."Document Type", ApplyingCustLedgEntry."Document No.",
                  CustLedgerEntry."Document Type", CustLedgerEntry."Document No.");
        end;

        if ApplyingCustLedgEntry."Entry No." <> 0 then
            GenJnlApply.CheckAgainstApplnCurrency(
              PageACE.GetApplnCurrencyCode(), CustLedgerEntry."Currency Code", GenJnlLine."Account Type"::Customer, true);
    end;

    // .-.-.-.-.-.- Events for Check Ledger Entries Page .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Page, Page::"Check Ledger Entries", 'OnBeforeOnOpenPage', '', false, false)]
    local procedure OnBeforeOnOpenPage(sender: Page "Check Ledger Entries")
    var
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        sender.GetRecord(CheckLedgerEntry);
    end;

    // .-.-.-.-.-.- Events for Posted Sales Invoice Page .-.-.-.-.-.-.
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice", 'OnBeforeSalesInvHeaderPrintRecords', '', false, false)]
    local procedure OnBeforeSalesInvHeaderPrintRecords(var SalesInvHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
    var
        ConfigSantillana: Record "Config. Empresa";
    begin
        //001
        ConfigSantillana.GET;
        IF NOT ConfigSantillana."Funcionalidad Imp. Fiscal Act." THEN BEGIN
            BEGIN
                SalesInvHeader.PrintRecords(TRUE);
            END;
        END
        ELSE BEGIN
            SalesInvHeader.CALCFIELDS("Amount Including VAT");
            IF SalesInvHeader."Amount Including VAT" <> 0 THEN BEGIN
                ConfigSantillana.TESTFIELD("Copia Fact. Imp. Fiscal Panama");
                REPORT.RUNMODAL(ConfigSantillana."Copia Fact. Imp. Fiscal Panama", TRUE, FALSE, SalesInvHeader);
            END
            ELSE BEGIN
                ConfigSantillana.TESTFIELD("Impresion Muestras");
                REPORT.RUNMODAL(ConfigSantillana."Impresion Muestras", TRUE, FALSE, SalesInvHeader);
            END;
        END;
        //001
        IsHandled := true;
    end;

    var
        myInt: Integer;
}