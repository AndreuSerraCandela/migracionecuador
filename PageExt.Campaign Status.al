pageextension 50073 pageextension50073 extends "Campaign Status"
{
    layout
    {
        addafter(Description)
        {
            field("Fecha Inicio"; rec."Fecha Inicio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Fin"; rec."Fecha Fin")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

