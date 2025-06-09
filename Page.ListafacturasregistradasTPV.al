page 76294 "Lista facturas registradas TPV"
{
    ApplicationArea = all;
    Caption = 'Posted Sales Invoices';
    CardPageID = "Posted Sales Invoice";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Invoice Header";
    SourceTableView = SORTING("Posting Date")
                      WHERE("Venta TPV" = CONST(true));

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
                field("Posting Date"; rec."Posting Date")
                {
                    Visible = false;
                }
                field("Venta TPV"; rec."Venta TPV")
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                }
                field(Amount; rec.Amount)
                {

                    trigger OnDrillDown()
                    begin
                        rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {

                    trigger OnDrillDown()
                    begin
                        rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
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
                field("Salesperson Code"; rec."Salesperson Code")
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
                // field("Electronic Document Status"; rec."Electronic Document Status")
                // {
                // }
                // field("Date/Time Stamped"; rec."Date/Time Stamped")
                // {
                //     Visible = false;
                // }
                // field("Date/Time Sent"; rec."Date/Time Sent")
                // {
                //     Visible = false;
                // }
                // field("Date/Time Canceled"; rec."Date/Time Canceled")
                // {
                //     Visible = false;
                // }
                // field("Error Code"; rec."Error Code")
                // {
                //     Visible = false;
                // }
                // field("Error Description"; rec."Error Description")
                // {
                //     Visible = false;
                // }
                field("No. Printed"; rec."No. Printed")
                {
                }
                field("Document Date"; rec."Document Date")
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
                field("Shipment Date"; rec."Shipment Date")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
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
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        if rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Invoice Statistics", Rec, rec."No.");
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Invoice Stats.", Rec, rec."No.");
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        rec.ShowDimensions;
                    end;
                }
            }
        }
        area(processing)
        {
            group("&Electronic Document")
            {
                Caption = '&Electronic Document';
                action("S&end")
                {
                    Caption = 'S&end';
                    Ellipsis = true;
                    Image = SendTo;

                    // trigger OnAction()
                    // begin
                    //     rec.RequestStampEDocument;
                    // end;
                }
                action("Export E-Document as &XML")
                {
                    Caption = 'Export E-Document as &XML';
                    Image = ExportElectronicDocument;

                    // trigger OnAction()
                    // begin
                    //     rec.ExportEDocument;
                    // end;
                }
                action("&Cancel")
                {
                    Caption = '&Cancel';
                    Image = Cancel;

                    // trigger OnAction()
                    // begin
                    //     rec.CancelEDocument;
                    // end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    rec.Navigate;
                end;
            }
            action("Sales - Invoice")
            {
                Caption = 'Sales - Invoice';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //RunObject = Report "Sales Invoice";
            }
        }
        area(reporting)
        {
            action("Outstanding Sales Order Aging")
            {
                Caption = 'Outstanding Sales Order Aging';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //RunObject = Report "Outstanding Sales Order Aging";
            }
            action("Outstanding Sales Order Status")
            {
                Caption = 'Outstanding Sales Order Status';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                //RunObject = Report "Outstanding Sales Order Status";
            }
            action("Daily Invoicing Report")
            {
                Caption = 'Daily Invoicing Report';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                // RunObject = Report "Daily Invoicing Report";
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SetSecurityFilterOnRespCenter;
    end;
}

