pageextension 50031 pageextension50031 extends "Apply Customer Entries"
{
    //Permissions = TableData "Cust. Ledger Entry" = rm;

    layout
    {
        modify("ApplyingCustLedgEntry.""Document No.""")
        {
            ToolTip = 'Specifies the document number of the entry to be applied.';
        }
        modify(ApplyingDescription)
        {
            ToolTip = 'Specifies the description of the entry to be applied.';
        }
        modify(AppliesToID)
        {
            ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
        }
        modify("Debit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits.';
        }
        modify("Credit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent credits.';
        }
        modify(ApplnAmountToApply)
        {
            Caption = 'Appln. Amount to Apply';
        }
        modify("Global Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Global Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify(ApplnRounding)
        {
            ToolTip = 'Specifies the rounding difference when you apply entries in different currencies to one another. The amount is in the currency represented by the code in the Currency Code field.';
        }
        modify(AppliedAmount)
        {
            ToolTip = 'Specifies the sum of the amounts in the Amount to Apply field, Pmt. Disc. Amount field, and the Rounding. The amount is in the currency represented by the code in the Currency Code field.';
        }
        modify(ControlBalance)
        {
            ToolTip = 'Specifies any extra amount that will remain after the application.';
        }

        modify("Amount to Apply")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
            begin
                //+#34829
                if (bDiarioRet) and (Rec."ID Retencion Venta" <> '') then
                    Rec.TestField("Amount to Apply", Rec."Importe Ret. Renta a liquidar" + Rec."Importe Ret. IVA a liquidar");
                //-#34839
            end;
        }

        addafter("Posting Date")
        {
            field("ID Retencion Venta"; rec."ID Retencion Venta")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    //001
                    ConfSant.Get;
                    ConfSant.TestField("% Retencion Vta.");
                    rec.CalcFields("Original Amount");
                    //+#34822
                    //VALIDATE("Amount to Apply",(("Original Amount" * ConfSant."% Retencion Vta.")/100));
                    if rec."ID Retencion Venta" <> '' then
                        rec.Validate("Importe Ret. Renta a liquidar", Round((rec."Original Amount" * ConfSant."% Retencion Vta.") / 100, AmountRoundingPrecision))
                    else begin
                        rec."Importe Ret. Renta a liquidar" := 0;
                        rec."Importe Ret. IVA a liquidar" := 0;
                        rec.Validate("Amount to Apply", 0);
                    end;
                    //-#34822
                    //001
                end;
            }
            field("Importe Retencion Venta"; rec."Importe Retencion Venta")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Document Type")
        {
            field("External Document No. 2"; rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Document No.")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Salesperson Code"; rec."Salesperson Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(ApplnAmountToApply)
        {
            field("Importe Ret. Renta a liquidar"; rec."Importe Ret. Renta a liquidar")
            {
                ApplicationArea = Basic, Suite;
                Visible = bDiarioRet;
            }
            field("Importe Ret. IVA a liquidar"; rec."Importe Ret. IVA a liquidar")
            {
                ApplicationArea = Basic, Suite;
                Visible = bDiarioRet;
            }
        }
    }
    actions
    {
        modify("Applied E&ntries")
        {
            ToolTip = 'View the ledger entries that have been applied to this record.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify("Set Applies-to ID")
        {
            ToolTip = 'Set the Applies-to ID field on the posted entry to automatically be filled in with the document number of the entry in the journal.';
        }
        modify("Post Application")
        {
            ToolTip = 'Define the document number of the ledger entry to use to perform the application. In addition, you specify the Posting Date for the application.';
        }
        modify(ShowDocumentAttachment)
        {
            ToolTip = 'View documents or images that are attached to the posted invoice or credit memo.';
        }
    }

    var
        GJL: Record "Gen. Journal Line";
        GJL1: Record "Gen. Journal Line";
        ConfSant: Record "Config. Empresa";
        NoLinea: Integer;
        GJB: Record "Gen. Journal Batch";
        bDiarioRet: Boolean;

    trigger OnClosePage()
    begin
        //+#34822
        if GJB.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            if GJB."Seccion Retencion Venta" then begin
                CustLedgEntry.Reset;
                CustLedgEntry.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                CustLedgEntry.SetRange("Customer No.", Rec."Customer No.");
                CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                CustLedgEntry.SetRange(Open, true);
                CustLedgEntry.SetFilter("ID Retencion Venta", '<>%1', '');
                if CustLedgEntry.FindSet then begin
                    ConfSant.Get;
                    ConfSant.TestField("Cta. Retencion Vta.");
                    ConfSant.TestField("Cta. Retención Vta. IVA");
                    repeat
                        if CustLedgEntry."Importe Ret. Renta a liquidar" <> 0 then begin
                            GJL.Reset;
                            GJL.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GJL.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            if GJL.FindLast then
                                NoLinea := GJL."Line No."
                            else
                                NoLinea := 0;

                            NoLinea += 10000;
                            GJL1.Init;
                            GJL1.Validate("Journal Template Name", GenJnlLine."Journal Template Name");
                            GJL1.Validate("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GJL1.Validate("Line No.", NoLinea);
                            GJL1.Validate("Account Type", GenJnlLine."Account Type");
                            GJL1.Validate("Account No.", GenJnlLine."Account No.");
                            GJL1.Validate("Posting Date", GenJnlLine."Posting Date");
                            GJL1.Validate("Document Type", GenJnlLine."Document Type");
                            GJL1.Validate("Document No.", GenJnlLine."Document No.");
                            GJL1.Validate("Tipo Retención", GJL1."Tipo Retención"::Renta);
                            GJL1.Validate("Applies-to Doc. Type", CustLedgEntry."Document Type");
                            GJL1.Validate("Applies-to Doc. No.", CustLedgEntry."Document No.");
                            GJL1.Validate("ID Retencion Venta", CustLedgEntry."ID Retencion Venta");
                            GJL1.Validate("Credit Amount", CustLedgEntry."Importe Ret. Renta a liquidar");
                            GJL1.Validate("Salespers./Purch. Code", GenJnlLine."Salespers./Purch. Code");
                            GJL1.Validate("Collector Code", GenJnlLine."Collector Code");
                            GJL1.Validate(Agencia, GenJnlLine.Agencia);
                            GJL1.Insert(true);
                            CustLedgEntry."Importe Ret. Renta a liquidar" := 0;
                            CustLedgEntry.Modify;
                        end;

                        if CustLedgEntry."Importe Ret. IVA a liquidar" <> 0 then begin
                            GJL.Reset;
                            GJL.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GJL.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            if GJL.FindLast then
                                NoLinea := GJL."Line No."
                            else
                                NoLinea := 0;

                            NoLinea += 10000;
                            GJL1.Init;
                            GJL1.Validate("Journal Template Name", GenJnlLine."Journal Template Name");
                            GJL1.Validate("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GJL1.Validate("Line No.", NoLinea);
                            GJL1.Validate("Account Type", GenJnlLine."Account Type");
                            GJL1.Validate("Account No.", GenJnlLine."Account No.");
                            GJL1.Validate("Posting Date", GenJnlLine."Posting Date");
                            GJL1.Validate("Document Type", GenJnlLine."Document Type");
                            GJL1.Validate("Document No.", GenJnlLine."Document No.");
                            GJL1.Validate("Tipo Retención", GJL1."Tipo Retención"::IVA);
                            GJL1.Validate("Applies-to Doc. Type", CustLedgEntry."Document Type");
                            GJL1.Validate("Applies-to Doc. No.", CustLedgEntry."Document No.");
                            GJL1.Validate("ID Retencion Venta", CustLedgEntry."ID Retencion Venta");
                            GJL1.Validate("Credit Amount", CustLedgEntry."Importe Ret. IVA a liquidar");
                            GJL1.Validate("Salespers./Purch. Code", GenJnlLine."Salespers./Purch. Code");
                            GJL1.Validate("Collector Code", GenJnlLine."Collector Code");
                            GJL1.Validate(Agencia, GenJnlLine.Agencia);
                            GJL1.Insert(true);
                            CustLedgEntry."Importe Ret. IVA a liquidar" := 0;
                            CustLedgEntry.Modify;
                        end;
                    until CustLedgEntry.Next = 0;
                end;
            end;
        //+#34822
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //+#34822
        bDiarioRet := false;
        if GJB.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") then
            bDiarioRet := GJB."Seccion Retencion Venta";
        //-#34822
    end;
}

