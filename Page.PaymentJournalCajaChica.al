page 55008 "Payment Journal Caja Chica"
{
    ApplicationArea = all;
    // #43088    CAT   26/01/2016    Campos "Tipo de identificador", "Pago a Residente"

    AutoSplitKey = true;
    Caption = 'Payment Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    GenJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Document Date"; rec."Document Date")
                {
                    Visible = false;
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document No."; rec."Document No.")
                {
                }
                field("Account Type"; rec."Account Type")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                    end;
                }
                field("Account No."; rec."Account No.")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; rec.Description)
                {
                }
                field(Beneficiario; rec.Beneficiario)
                {
                }
                field("Tipo de Comprobante"; rec."Tipo de Comprobante")
                {
                }
                field("RUC/Cedula"; rec."RUC/Cedula")
                {
                    Visible = false;
                }
                field("Sustento del Comprobante"; rec."Sustento del Comprobante")
                {
                    Visible = false;
                }
                field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
                {
                    Visible = false;
                }
                field(Establecimiento; rec.Establecimiento)
                {
                    Visible = false;
                }
                field("Punto de Emision"; rec."Punto de Emision")
                {
                    Visible = false;
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("Fecha Caducidad"; rec."Fecha Caducidad")
                {
                    Visible = false;
                }
                field("Cod. Retencion"; rec."Cod. Retencion")
                {
                    Visible = false;
                }
                field("Salespers./Purch. Code"; rec."Salespers./Purch. Code")
                {
                    Visible = false;
                }
                field("Campaign No."; rec."Campaign No.")
                {
                    Visible = false;
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(rec."Currency Code", rec."Currency Factor", rec."Posting Date");
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Gen. Posting Type"; rec."Gen. Posting Type")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Collector Code"; rec."Collector Code")
                {
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Debit Amount"; rec."Debit Amount")
                {
                    Visible = false;
                }
                field("Credit Amount"; rec."Credit Amount")
                {
                    Visible = false;
                }
                field(Amount; rec.Amount)
                {
                }
                field("VAT Amount"; rec."VAT Amount")
                {
                    Visible = false;
                }
                field("VAT Base Amount"; rec."VAT Base Amount")
                {
                }
                field("VAT Difference"; rec."VAT Difference")
                {
                    Visible = false;
                }
                field("Bal. VAT Amount"; rec."Bal. VAT Amount")
                {
                    Visible = false;
                }
                field("Bal. VAT Difference"; rec."Bal. VAT Difference")
                {
                    Visible = false;
                }
                field("Bal. Account Type"; rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; rec."Bal. Account No.")
                {

                    trigger OnValidate()
                    begin
                        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
                        rec.ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type"; rec."Bal. Gen. Posting Type")
                {
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group"; rec."Bal. Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Bal. Gen. Prod. Posting Group"; rec."Bal. Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Bal. VAT Bus. Posting Group"; rec."Bal. VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group"; rec."Bal. VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                    end;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                    end;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                    end;

                    trigger OnValidate()
                    begin

                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
                {
                }
                field("Applies-to ID"; rec."Applies-to ID")
                {
                    Visible = false;
                }
                field(GetAppliesToDocDueDate; rec.GetAppliesToDocDueDate)
                {
                    Caption = 'Applies-to Doc. Due Date';
                }
                field("Bank Payment Type"; rec."Bank Payment Type")
                {
                }
                field("Check Printed"; rec."Check Printed")
                {
                    Visible = false;
                }
                field("Reason Code"; rec."Reason Code")
                {
                    Visible = false;
                }
                field("Source Type"; rec."Source Type")
                {
                }
                field("Source No."; rec."Source No.")
                {
                }
                field("Tipo de Identificador"; rec."Tipo de Identificador")
                {
                }
                field("Pago a"; rec."Pago a")
                {
                }
                field("Excluir Informe ATS"; rec."Excluir Informe ATS")
                {
                }
            }
            group(Control24)
            {
                ShowCaption = false;
                fixed(Control1903561801)
                {
                    ShowCaption = false;
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName; AccName)
                        {
                            Editable = false;
                        }
                    }
                    group("Bal. Account Name")
                    {
                        Caption = 'Bal. Account Name';
                        field(BalAccName; BalAccName)
                        {
                            Caption = 'Bal. Account Name';
                            Editable = false;
                        }
                    }
                    group(Control1900545401)
                    {
                        Caption = 'Balance';
                        field(Balance; Balance + rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            AutoFormatType = 1;
                            Caption = 'Balance';
                            Editable = false;
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field(TotalBalance; TotalBalance + rec."Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            AutoFormatType = 1;
                            Caption = 'Total Balance';
                            Editable = false;
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000014; "Dimension Set Entries FactBox")
            {
                SubPageLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group("&Payments")
            {
                Caption = '&Payments';
                action("Suggest Vendor Payments")
                {
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CreateVendorPmtSuggestion.SetGenJnlLine(Rec);
                        CreateVendorPmtSuggestion.RunModal;
                        Clear(CreateVendorPmtSuggestion);
                    end;
                }
                action("P&review Check")
                {
                    Caption = 'P&review Check';
                    RunObject = Page "Check Preview";
                    RunPageLink = "Journal Template Name" = FIELD("Journal Template Name"),
                                  "Journal Batch Name" = FIELD("Journal Batch Name"),
                                  "Line No." = FIELD("Line No.");
                }
                action("Print Check")
                {
                    Caption = 'Print Check';
                    Ellipsis = true;
                    Image = PrintCheck;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        GenJnlLine.Reset;
                        GenJnlLine.Copy(Rec);
                        GenJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                        GenJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                        DocPrint.PrintCheck(GenJnlLine);
                        CODEUNIT.Run(CODEUNIT::"Adjust Gen. Journal Balance", Rec);
                    end;
                }
                group("Electronic Payments")
                {
                    Caption = 'Electronic Payments';
                    action("E&xport")
                    {
                        Caption = 'E&xport';
                        Ellipsis = true;
                        Image = Export;

                        trigger OnAction()
                        begin
                            GenJnlLine.Reset;
                            GenJnlLine := Rec;
                            GenJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                            GenJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                            REPORT.RunModal(REPORT::"Export Electronic Payments", true, false, GenJnlLine);
                        end;
                    }
                    action(Void)
                    {
                        Caption = 'Void';
                        Ellipsis = true;
                        Image = VoidElectronicDocument;

                        trigger OnAction()
                        begin
                            GenJnlLine.Reset;
                            GenJnlLine := Rec;
                            GenJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                            GenJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                            // Clear(VoidTransmitElecPayments);
                            // VoidTransmitElecPayments.SetUsageType(1);   // Void
                            // VoidTransmitElecPayments.SetTableView(GenJnlLine);
                            // VoidTransmitElecPayments.RunModal;
                        end;
                    }
                    action(Transmit)
                    {
                        Caption = 'Transmit';
                        Ellipsis = true;
                        Image = TransmitElectronicDoc;

                        trigger OnAction()
                        begin
                            GenJnlLine.Reset;
                            GenJnlLine := Rec;
                            GenJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                            GenJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                            // Clear(VoidTransmitElecPayments);
                            // VoidTransmitElecPayments.SetUsageType(2);   // Transmit
                            // VoidTransmitElecPayments.SetTableView(GenJnlLine);
                            // VoidTransmitElecPayments.RunModal;
                        end;
                    }
                }
                action("Void Check")
                {
                    Caption = 'Void Check';
                    Image = VoidCheck;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        rec.TestField("Bank Payment Type", rec."Bank Payment Type"::"Computer Check");
                        rec.TestField("Check Printed", true);
                        if Confirm(Text000, false, rec."Document No.") then
                            CheckManagement.VoidCheck(Rec);
                    end;
                }
                action("Void &All Checks")
                {
                    Caption = 'Void &All Checks';

                    trigger OnAction()
                    begin
                        if Confirm(Text001, false) then begin
                            GenJnlLine.Reset;
                            GenJnlLine.Copy(Rec);
                            GenJnlLine.SetRange("Bank Payment Type", rec."Bank Payment Type"::"Computer Check");
                            GenJnlLine.SetRange("Check Printed", true);
                            if GenJnlLine.Find('-') then
                                repeat
                                    GenJnlLine2 := GenJnlLine;
                                    CheckManagement.VoidCheck(GenJnlLine2);
                                until GenJnlLine.Next = 0;
                        end;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                }
                action("Insert Conv. $ Rndg. Lines")
                {
                    Caption = 'Insert Conv. $ Rndg. Lines';
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action(Reconcile)
                {
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", Rec);
                        CurrentJnlBatchName := rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
        DoAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        TotalBalanceVisible := true;
        BalanceVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateBalance;
        rec.SetUpNewLine(xRec, Balance, BelowxRec);
        Clear(ShortcutDimCode);
        if not VoidWarningDisplayed then begin
            GenJnlTemplate.Get(rec."Journal Template Name");
            if not GenJnlTemplate."Force Doc. Balance" then
                Message(USText001);
            VoidWarningDisplayed := true;
        end;

    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin

        BalAccName := '';
        OpenedFromBatch := (rec."Journal Batch Name" <> '') and (rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := rec."Journal Batch Name";
            GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        GenJnlManagement.TemplateSelection(PAGE::"Payment Journal", Enum::"Gen. Journal Template Type"::Payments, false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
        VoidWarningDisplayed := false;
    end;

    var
        Text000: Label 'Void Check %1?';
        Text001: Label 'Void all printed checks?';
        ChangeExchangeRate: Page "Change Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GLReconcile: Page Reconciliation;
        CreateVendorPmtSuggestion: Report "Suggest Vendor Payments";
        // VoidTransmitElecPayments: Report "Void/Transmit Elec. Payments";
        GenJnlManagement: Codeunit GenJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        CheckManagement: Codeunit CheckManagement;
        CurrentJnlBatchName: Code[10];
        AccName: Text[50];
        BalAccName: Text[50];
        Balance: Decimal;
        TotalBalance: Decimal;
        ShowBalance: Boolean;
        ShowTotalBalance: Boolean;
        VoidWarningDisplayed: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        USText001: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';

        BalanceVisible: Boolean;

        TotalBalanceVisible: Boolean;

        BinVisible: Boolean;
        GJB: Record "Gen. Journal Batch";

    local procedure UpdateBalance()
    begin
        GenJnlManagement.CalcBalance(
          Rec, xRec, Balance, TotalBalance, ShowBalance, ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        GenJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure DoAfterGetCurrRecord()
    begin
        xRec := Rec;
        GenJnlManagement.GetAccounts(Rec, AccName, BalAccName);
        UpdateBalance;
    end;


    procedure ActivaCampos()
    begin
    end;
}

