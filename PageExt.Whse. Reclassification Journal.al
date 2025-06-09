pageextension 50127 pageextension50127 extends "Whse. Reclassification Journal"
{
    layout
    {
        modify(Description)
        {
            ToolTip = 'Specifies the description of the item.';

            //Unsupported feature: Property Modification (ImplicitType) on "Description(Control 10)".

        }
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
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
    }
}

