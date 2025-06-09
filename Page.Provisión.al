page 56086 "% Provisión"
{
    ApplicationArea = all;
    // 001 CAT 20/02/14  #144 Configuración de los porcentajes de insolvencias

    PageType = List;
    SourceTable = "% Provisión";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Desde día"; rec."Desde día")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field("% Provisión"; rec."% Provisión")
                {
                }
                field("Importe provisión"; rec."Importe provisión")
                {
                }
            }
        }
    }

    actions
    {
    }
}

