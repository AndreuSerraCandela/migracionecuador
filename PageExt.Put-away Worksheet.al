pageextension 50126 pageextension50126 extends "Put-away Worksheet"
{
    layout
    {
        modify(CurrentLocationCode)
        {
            ToolTip = 'Specifies the location that is set up to use directed put-away.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
    }
    actions
    {
        modify("Item &Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify("Delete Qty. to Handle")
        {
            Caption = 'Delete Qty. to Handle';
        }
    }
}

