pageextension 50056 pageextension50056 extends "Vendor Bank Account List"
{
    layout
    {
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Currency Code")
        {
            ToolTip = 'Specifies the relevant currency code for the bank account.';
        }
        addfirst(Control1)
        {
            field("Vendor No."; rec."Vendor No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Cuenta"; rec."Tipo Cuenta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Banco Receptor"; rec."Banco Receptor")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

