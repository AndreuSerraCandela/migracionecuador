pageextension 50088 pageextension50088 extends Dimensions
{
    layout
    {
        modify("Code")
        {
            ToolTip = 'Specifies the code for the dimension.';
        }
        modify(Name)
        {
            ToolTip = 'Specifies the name of the dimension code.';
        }
        addafter("Consolidation Code")
        {
            field("Tipo MdM"; rec."Tipo MdM")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                Editable = false;
                Visible = false;
            }
        }
    }
    actions
    {
        modify("Dimension &Values")
        {
            ToolTip = 'View or edit the dimension values for the current dimension.';
        }
    }
}

