page 76263 "Lin. Campos Requeridos"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Lin. Campos Req. Maestros";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Campo"; rec."No. Campo")
                {
                }
                field("Nombre Campo"; rec."Nombre Campo")
                {
                }
            }
        }
    }

    actions
    {
    }
}

