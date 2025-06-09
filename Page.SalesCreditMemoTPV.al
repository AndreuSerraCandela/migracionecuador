page 55015 "Sales Credit Memo - TPV"
{
    ApplicationArea = all;
    Caption = 'Sales Credit Memo';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER("Credit Memo"),
                            "para que compilar pages" = FILTER('1'));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; rec."Sell-to Contact No.")
                {
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("Sell-to Phone"; rec."Sell-to Phone")
                {
                }
                field("Ship-to Phone"; rec."Ship-to Phone")
                {
                }
                field("Sell-to Address"; rec."Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2"; rec."Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to City"; rec."Sell-to City")
                {
                }
                field("Sell-to County"; rec."Sell-to County")
                {
                    Caption = 'Sell-to State / ZIP Code';
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                    Importance = Promoted;
                }
                field("Document Date"; rec."Document Date")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                    Importance = Promoted;
                }
                field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
                {
                }
                field("No. Serie NCF Abonos"; rec."No. Serie NCF Abonos")
                {
                }
                field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
                {
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                    Caption = 'Location';
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                    Caption = 'Issue Point';
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Campaign No."; rec."Campaign No.")
                {
                    Importance = Additional;
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {
                    Importance = Additional;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                    Importance = Additional;
                }
                field(Status; rec.Status)
                {
                    Importance = Promoted;
                }
            }
            part(SalesLines; "Sales Cr. Memo Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; rec."Bill-to Contact No.")
                {
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                }
                field("Bill-to County"; rec."Bill-to County")
                {
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date"; rec."Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %"; rec."Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; rec."Pmt. Discount Date")
                {
                    Importance = Additional;
                }
                field("Tax Area Code"; rec."Tax Area Code")
                {
                    Importance = Promoted;
                }
                field("Tax Liable"; rec."Tax Liable")
                {
                    Importance = Promoted;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    Importance = Promoted;
                }
                field("Ship-to Address"; rec."Ship-to Address")
                {
                    Importance = Additional;
                }
                field("Ship-to Phone2"; rec."Ship-to Phone")
                {
                }
                field("Ship-to Address 2"; rec."Ship-to Address 2")
                {
                    Importance = Additional;
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                }
                field("Ship-to County"; rec."Ship-to County")
                {
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Importance = Additional;
                }
                // field("Ship-to UPS Zone"; rec."Ship-to UPS Zone")
                // {
                // }
                field("Location Code"; rec."Location Code")
                {
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Importance = Promoted;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; rec."Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(rec."Currency Code", rec."Currency Factor", rec."Posting Date");
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
                field("EU 3-Party Trade"; rec."EU 3-Party Trade")
                {
                }
                field("Transaction Type"; rec."Transaction Type")
                {
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                }
                field("Transport Method"; rec."Transport Method")
                {
                }
                field("Exit Point"; rec."Exit Point")
                {
                }
                field("Area"; rec.Area)
                {
                }
            }
            group(Application)
            {
                Caption = 'Application';
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {
                }
                field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
                {
                }
                field("Applies-to ID"; rec."Applies-to ID")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No."),
                              Status = CONST(Open);
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Cr. Memo")
            {
                Caption = '&Cr. Memo';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        rec.CalcInvDiscForHeader;
                        Commit;
                        if rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Statistics", Rec);
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Order Stats.", Rec)
                    end;
                }
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(DATABASE::"Sales Header", rec."Document Type", rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action171)
                {
                }
                action("Credit Cards Transaction Lo&g Entries")
                {
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    /*RunObject = Page Page829; No existe ya esa pagina en Nav tampoco
                    RunPageLink = Field2 = FIELD ("Document Type"),
                                  Field3 = FIELD ("No."),
                                  Field4 = FIELD ("Bill-to Customer No.");*/
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Calculate &Invoice Discount")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action113)
                {
                }
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Sales Header Apply", Rec);
                    end;
                }
                separator(Action126)
                {
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    Caption = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                separator(Action128)
                {
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                action("Get Posted Doc&ument Lines to Reverse")
                {
                    Caption = 'Get Posted Doc&ument Lines to Reverse';
                    Ellipsis = true;
                    Image = ReverseLines;

                    trigger OnAction()
                    begin
                        /* GetPstdDocLinesToRevere; */
                    end;
                }
                separator(Action141)
                {
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN; //MIGEC
                        if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                            ApprovalMgt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN; //MIGEC
                        ApprovalMgt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(rec.RecordId);
                    end;
                }
                separator(Action130)
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
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
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                            CODEUNIT.Run(CODEUNIT::"Sales-Post (Yes/No)", Rec);
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
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then
                            CODEUNIT.Run(CODEUNIT::"Sales-Post + Print", Rec);
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Credit Memos", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(rec.ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec."Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            rec.FilterGroup(2);
            rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            rec.FilterGroup(0);
        end;
    end;

    var
        Salessetup: Record "Sales & Receivables Setup";
        ChangeExchangeRate: Page "Change Exchange Rate";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;
}

