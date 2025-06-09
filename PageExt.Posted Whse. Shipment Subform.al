pageextension 50122 pageextension50122 extends "Posted Whse. Shipment Subform"
{
    layout
    {
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        addafter("Shipping Advice")
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
}

