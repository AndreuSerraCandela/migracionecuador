page 89305 "_Sales Order List"
{
    ApplicationArea = all;
    Caption = 'Sales Orders';
    CardPageID = "Sales Order";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = WHERE ("Document Type" = CONST (Order));

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
                field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
                {
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
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
                field("VAT Registration No."; rec."VAT Registration No.")
                {
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
                field("Requested Delivery Date"; rec."Requested Delivery Date")
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
                field("Amount Including VAT"; rec."Amount Including VAT")
                {
                }
            }
        }
    }

    actions
    {
    }
}

