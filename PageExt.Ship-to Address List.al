pageextension 50040 pageextension50040 extends "Ship-to Address List"
{
    layout
    {
        modify("Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on "City(Control 25)".

        addafter("Code")
        {
            field("Customer No."; rec."Customer No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Contact)
        {
            field(Colonia; rec.Colonia)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

