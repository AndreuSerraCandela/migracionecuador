page 56008 "Mov. Prod. Por Clientes"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Item Ledger Entry";
    SourceTableView = SORTING ("Entry No.")
                      ORDER(Ascending)
                      WHERE ("Source Type" = FILTER (Customer));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; rec."Item No.")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Source No."; rec."Source No.")
                {
                }
                field("Document No."; rec."Document No.")
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Location Code"; rec."Location Code")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field("Sales Amount (Actual)"; rec."Sales Amount (Actual)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

