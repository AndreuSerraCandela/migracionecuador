pageextension 50118 pageextension50118 extends "Item Analysis View Entries"
{
    layout
    {
        modify("Dimension 1 Value Code")
        {
            ToolTip = 'Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 1 on the analysis view card.';
        }
        modify("Dimension 2 Value Code")
        {
            ToolTip = 'Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 2 on the analysis view card.';
        }
        modify("Dimension 3 Value Code")
        {
            ToolTip = 'Specifies the dimension value you selected for the analysis view dimension that you defined as Dimension 3 on the analysis view card.';
        }
        addafter("Invoiced Quantity")
        {
            field("Analysis Area"; rec."Analysis Area")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

