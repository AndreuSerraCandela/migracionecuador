page 56023 "PreSales Order List"
{
    ApplicationArea = all;
    // Proyecto: Implementacion Microsoft Dynamics Nav
    // AMS     : Agustin Mendez
    // GRN     : Guillermo Roman
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     09-Agosto-12     AMS          Imprimir el estado de cuenta del cliente


    Caption = 'Pre Pedidos venta';
    CardPageID = "Sales Order PreSales";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Order),
                            "Pre pedido" = CONST(true));
    UsageCategory = Lists;

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
                field("Creado por usuario"; rec."Creado por usuario")
                {
                    Editable = false;
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
                field(Amount; rec.Amount)
                {
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
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
                field("Requested Delivery Date"; rec."Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Fecha Recepcion"; rec."Fecha Recepcion")
                {
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
                field("Payment Discount %"; rec."Payment Discount %")
                {
                    Visible = false;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {
                    Visible = false;
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Visible = false;
                }
                field("Shipping Advice"; rec."Shipping Advice")
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
            group("O&rder")
            {
                Caption = 'O&rder';
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
                        PAGE.RunModal(PAGE::"Sales Order Statistics", Rec);
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
                action("S&hipments")
                {
                    Caption = 'S&hipments';
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action(Invoices)
                {
                    Caption = 'Invoices';
                    Image = Invoice;
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Order No." = FIELD("No.");
                    RunPageView = SORTING("Order No.");
                }
                action("Prepa&yment Invoices")
                {
                    Caption = 'Prepa&yment Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
                }
                action("Prepayment Credi&t Memos")
                {
                    Caption = 'Prepayment Credi&t Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    RunPageLink = "Prepayment Order No." = FIELD("No.");
                    RunPageView = SORTING("Prepayment Order No.");
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
                action("A&pprovals")
                {
                    Caption = 'A&pprovals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header", rec."Document Type", rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                separator(Action1102601015)
                {
                }
                action("Whse. Shipment Lines")
                {
                    Caption = 'Whse. Shipment Lines';
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = CONST(37),
                                                         "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    Caption = 'In&vt. Put-away/Pick Lines';
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document" = CONST("Sales Order"),
                                  "Source No." = FIELD("No.");
                    RunPageView = SORTING("Source Document", "Source No.", "Location Code");
                }
                separator(Action1102601018)
                {
                }
                action("Pla&nning")
                {
                    Caption = 'Pla&nning';

                    trigger OnAction()
                    var
                        SalesPlanForm: Page "Sales Order Planning";
                    begin
                        SalesPlanForm.SetSalesOrder(rec."No.");
                        SalesPlanForm.RunModal;
                    end;
                }
                action("Order &Promising")
                {
                    Caption = 'Order &Promising';

                    trigger OnAction()
                    var
                        OrderPromisingLine: Record "Order Promising Line" temporary;
                    begin
                        OrderPromisingLine.SetRange("Source Type", rec."Document Type");
                        OrderPromisingLine.SetRange("Source ID", rec."No.");
                        PAGE.RunModal(PAGE::"Order Promising Lines", OrderPromisingLine);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create &Whse. Shipment")
                {
                    Caption = 'Create &Whse. Shipment';

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromSalesOrder(Rec);

                        if not rec.Find('=><') then
                            rec.Init;
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        rec.CreateInvtPutAwayPick;

                        if not rec.Find('=><') then
                            rec.Init;
                    end;
                }
                separator(Action1102601045)
                {
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        "Release Sales Document": Codeunit "Release Sales Document";
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
                        "Release Sales Document": Codeunit "Release Sales Document";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN; //MIGEC
                        ApprovalMgt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(rec.RecordId);
                    end;
                }
                separator(Action1102601048)
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
                separator(Action1102601051)
                {
                }
                action("<Action1000000000>")
                {
                    Caption = '&Customer Statement';
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        //001
                        if SH.Get(rec."Document Type", rec."No.") then begin
                            Cust.Reset;
                            Cust.SetRange(Cust."No.", SH."Bill-to Customer No.");
                            Cust.FindFirst;
                            REPORT.RunModal(10072, true, true, Cust);
                        end
                        else
                            REPORT.RunModal(10072, true, true, Cust);
                        //001
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
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN //MIGEC
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then begin
                            //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                            if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                Error(StrSubstNo(Text001, rec."Document Type", rec."No."))
                            else begin
                                //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                                if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                    Error(StrSubstNo(Text002, rec."Document Type", rec."No."))
                                else
                                    CODEUNIT.Run(CODEUNIT::"Sales-Post (Yes/No)", Rec);
                            end;
                        end;
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(Rec,PurchaseHeader) THEN //MIGEC
                        if ApprovalMgt.PrePostApprovalCheckSales(Rec) then begin
                            //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                            if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                Error(StrSubstNo(Text001, rec."Document Type", rec."No."))
                            else begin
                                //IF ApprovalMgt.TestSalesPrepayment(Rec) THEN //MIGEC
                                if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                                    Error(StrSubstNo(Text002, rec."Document Type", rec."No."))
                                else
                                    CODEUNIT.Run(CODEUNIT::"Sales-Post + Print", Rec);
                            end;
                        end;
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Order Confirmation")
                {
                    Caption = 'Order Confirmation';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                    end;
                }
                action("Work Order")
                {
                    Caption = 'Work Order';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Work Order");
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Sales Reservation Avail.")
            {
                Caption = 'Sales Reservation Avail.';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Sales Reservation Avail.";
            }
        }
    }

    var
        DocPrint: Codeunit "Document-Print";
        ReportPrint: Codeunit "Test Report-Print";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        Usage: Option "Order Confirmation","Work Order";
        Text001: Label 'There are non posted Prepayment Amounts on %1 %2.';
        Text002: Label 'There are unpaid Prepayment Invoices related to %1 %2.';
        Cust: Record Customer;
        SH: Record "Sales Header";
}

