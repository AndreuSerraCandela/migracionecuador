codeunit 76041 "Gen. Jnl.-Post+Print Rec-Ing"
{
    // Proyecto: Microsoft Dynamics Nav 2009
    // AMS     : Agustin Mendez
    // --------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     15-Enero-09     AMS           Para poder encontrar el ultimo
    //                                       Doc. Banco para imprimir el Recibo
    //                                       de ingreso

    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlLine.Copy(Rec);
        Code;
        Rec.Copy(GenJnlLine);
    end;

    var
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines and print the report(s)?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        GLReg: Record "G/L Register";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
        "**001***": Integer;
        rBankAcc: Record "Bank Account Ledger Entry";
        rMovCont: Record "G/L Entry";

    local procedure "Code"()
    begin
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate."Force Posting Report" or
           (GenJnlTemplate."Cust. Receipt Report ID" = 0) and (GenJnlTemplate."Vendor Receipt Report ID" = 0)
        then
            GenJnlTemplate.TestField("Posting Report ID");
        if GenJnlTemplate.Recurring and (GenJnlLine.GetFilter("Posting Date") <> '') then
            GenJnlLine.FieldError("Posting Date", Text000);

        if not Confirm(Text001, false) then
            exit;

        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GenJnlPostBatch.Run(GenJnlLine);

        if GLReg.Get(GenJnlLine."Line No.") then begin
            if GenJnlTemplate."Cust. Receipt Report ID" <> 0 then begin
                CustLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
                //001 REPORT.RUN(GenJnlTemplate."Cust. Receipt Report ID",FALSE,FALSE,CustLedgEntry);
            end;
            if GenJnlTemplate."Vendor Receipt Report ID" <> 0 then begin
                VendLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
                REPORT.Run(GenJnlTemplate."Vendor Receipt Report ID", false, false, VendLedgEntry);
            end;
            //001 IF GenJnlTemplate."Posting Report ID" <> 0 THEN BEGIN
            //001  GLReg.SETRECFILTER;
            //001  REPORT.RUN(GenJnlTemplate."Posting Report ID",FALSE,FALSE,GLReg);
            //001 END;
        end;
        //001
        if rMovCont.Get(GLReg."To Entry No.") then begin
            rBankAcc.Reset;
            rBankAcc.SetRange(rBankAcc."Bank Account No.", rMovCont."Bal. Account No.");
            rBankAcc.SetRange(rBankAcc."Posting Date", rMovCont."Posting Date");
            rBankAcc.SetRange(rBankAcc."Document Type", rMovCont."Document Type");
            rBankAcc.SetRange(rBankAcc."Document No.", rMovCont."Document No.");
            Commit;
            REPORT.Run(76042, true, false, rBankAcc);
        end;
        //001


        if GenJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = GenJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004,
                  GenJnlLine."Journal Batch Name");

        if not GenJnlLine.Find('=><') or (TempJnlBatchName <> GenJnlLine."Journal Batch Name") then begin
            GenJnlLine.Reset;
            GenJnlLine.FilterGroup(2);
            GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine.FilterGroup(0);
            GenJnlLine."Line No." := 1;
        end;
    end;
}

