/* pageextension 50128 pageextension50128 extends "Item Bin Contents"
{
    layout
    {
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        addafter("Zone Code")
        {
 /*            field("Pick Qty."; "Pick Qty.")
            {
            }
            field("Put-away Qty."; "Put-away Qty.")
            {
            }
            field("Item Description"; "Item Description")
            {
            } 
        }
    }
}
 
*/