page 56020 "Sales Header Movil."
{
    ApplicationArea = all;
    Editable = false;
    PageType = Document;
    SourceTable = "Sales Header Movil.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; rec."No.")
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                }
                field("Order Date"; rec."Order Date")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                }
            }
            part(Control1000000011; "Sales Line Movilidad")
            {
                SubPageLink = "Document Type" = FIELD ("Document Type"),
                              "Document No." = FIELD ("No.");
            }
        }
    }

    actions
    {
    }
}

