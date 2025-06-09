page 76339 "Parametros vacaciones"
{
    ApplicationArea = all;
    Caption = 'Vacation parameters';
    PageType = List;
    SourceTable = "Parametros vacaciones";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Desde; rec.Desde)
                {
                }
                field("Cantidad de dias"; rec."Cantidad de dias")
                {
                }
            }
        }
    }

    actions
    {
    }
}

