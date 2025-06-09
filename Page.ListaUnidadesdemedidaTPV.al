page 76052 "Lista Unidades de medida TPV"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Item Unit of Measure";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; rec."Item No.")
                {
                }
                field("Code"; rec.Code)
                {
                }
                field("Qty. per Unit of Measure"; rec."Qty. per Unit of Measure")
                {
                }
            }
        }
    }

    actions
    {
    }
}

