pageextension 50121 pageextension50121 extends "Whse. Shipment Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (ImplicitType) on "Description(Control 30)".

        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        addafter(Control3)
        {
            field("Numero Guia"; rec."Numero Guia")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Nombre Guia"; rec."Nombre Guia")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
    }
    actions
    {
        modify(ItemTrackingLines)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
    }
}

