page 76385 "Seguridad Usuarios RH"
{
    ApplicationArea = all;
    Caption = 'HR User security';
    PageType = List;
    SourceTable = "Seguridad Usuarios RH";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("User ID"; rec."User ID")
                {

                    trigger OnValidate()
                    begin
                        rec.CalcFields("Full name");
                    end;
                }
                field("Full name"; rec."Full name")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Revisado por"; rec."Revisado por")
                {
                }
                field("Autorizado por"; rec."Autorizado por")
                {
                }
                field("Visualiza salario"; rec."Visualiza salario")
                {
                    Importance = Additional;
                }
                field("Visualiza Calc. Nomina"; rec."Visualiza Calc. Nomina")
                {
                    Importance = Additional;
                }
            }
        }
    }

    actions
    {
    }
}

