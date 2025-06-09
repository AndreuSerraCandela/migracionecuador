pageextension 50058 pageextension50058 extends "Shipping Agents"
{
    layout
    {
        addafter("Account No.")
        {
            field(Placa; rec.Placa)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo id."; rec."Tipo id.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

