pageextension 50136 pageextension50136 extends "Sales Line FactBox"
{
    layout
    {
        modify("Item Availability")
        {
            Visible = false;
        }
        modify("Available Inventory")
        {
            Caption = 'Available Inventory';
            ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
        }
        modify(UnitofMeasureCode)
        {
            Caption = 'Unit of Measure Code';
        }
        addafter("Item Availability")
        {
            // field("STRSUBSTNO('(%1)',SalesInfoPaneMgtExt.CalcAvailability_BackOrder(Rec))"; StrSubstNo('(%1)', SalesInfoPaneMgtExt.CalcAvailability(Rec)))
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'Backorder Availa&bility';
            // }
        }
    }
    var
    // SalesInfoPaneMgtExt: Codeunit "Sales Info-Pane Management";
}

