page 55014 "Sales Credit Memos POS"
{
    ApplicationArea = all;
    Caption = 'Sales Credit Memos';
    CardPageID = "Sales Credit Memo - TPV";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = CONST("Credit Memo"),
                            "para que compilar pages" = CONST('1'));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; rec."Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                    Visible = false;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    Visible = false;
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Visible = false;
                }
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Visible = false;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    Visible = false;
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; rec."Ship-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
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
                field("Location Code"; rec."Location Code")
                {
                    Visible = true;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    Visible = false;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                    Visible = false;
                }
                field("Document Date"; rec."Document Date")
                {
                    Visible = false;
                }
                field("Campaign No."; rec."Campaign No.")
                {
                    Visible = false;
                }
                field(Status; rec.Status)
                {
                    Visible = false;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                    Visible = false;
                }
                field("Due Date"; rec."Due Date")
                {
                    Visible = false;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Visible = false;
                }
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
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
                        PAGE.RunModal(PAGE::"Sales Statistics", Rec);
                    end;
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
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
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
                separator(Action1102601016)
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
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
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Credit Memos", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        ReportPrint: Codeunit "Test Report-Print";
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
}

