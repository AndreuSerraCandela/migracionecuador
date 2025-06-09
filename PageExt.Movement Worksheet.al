pageextension 50125 pageextension50125 extends "Movement Worksheet"
{
    layout
    {
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
    }
    actions
    {
        modify(ItemTrackingLines)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify("Delete Qty. to Handle")
        {
            Caption = 'Delete Qty. to Handle';
        }
        modify("Get Bin Content")
        {
            ToolTip = 'Use a function to create transfer lines with items to put away or pick based on the actual content in the specified bin.';
        }
    }
    var
        "***Santillana***": Integer;
        ItemDesc: Integer;
}

