page 56012 "Sales Line Movilidad"
{
    ApplicationArea = all;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Line Movil.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; rec.Type)
                {
                }
                field("No."; rec."No.")
                {
                }
                field("Location Code"; rec."Location Code")
                {
                }
                field("Posting Group"; rec."Posting Group")
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field("Outstanding Quantity"; rec."Outstanding Quantity")
                {
                }
                field("Qty. to Invoice"; rec."Qty. to Invoice")
                {
                }
                field("Qty. to Ship"; rec."Qty. to Ship")
                {
                }
                field("Unit Price"; rec."Unit Price")
                {
                }
                field("VAT %"; rec."VAT %")
                {
                }
                field("Line Discount %"; rec."Line Discount %")
                {
                }
                field("Line Discount Amount"; rec."Line Discount Amount")
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Amount Including VAT"; rec."Amount Including VAT")
                {
                }
                field("Quantity Shipped"; rec."Quantity Shipped")
                {
                }
                field("Quantity Invoiced"; rec."Quantity Invoiced")
                {
                }
                field("Shipped Not Invoiced"; rec."Shipped Not Invoiced")
                {
                }
            }
        }
    }

    actions
    {
    }
}

