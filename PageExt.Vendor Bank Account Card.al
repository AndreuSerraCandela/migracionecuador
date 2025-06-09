pageextension 50055 pageextension50055 extends "Vendor Bank Account Card"
{
    layout
    {
        modify("Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Currency Code")
        {
            ToolTip = 'Specifies the relevant currency code for the bank account.';
        }
        modify("SWIFT Code")
        {
            Importance = Standard;
        }

        addfirst(Transfer)
        {
            field("Bank Branch No.2"; rec."Bank Branch No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the bank branch.';
            }
            field("Bank Account No.2"; rec."Bank Account No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number used by the bank for the bank account.';
            }
            field("Transit No.2"; rec."Transit No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a bank identification number of your own choice.';
            }
        }
        addafter("SWIFT Code")
        {
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

