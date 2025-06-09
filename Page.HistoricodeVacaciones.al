page 76244 "Historico de Vacaciones"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Historico Vacaciones";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. empleado"; rec."No. empleado")
                {
                    Visible = false;
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                }
                field("Fecha Fin"; rec."Fecha Fin")
                {
                }
                field(Dias; rec.Dias)
                {
                }
                field("Tipo calculo"; rec."Tipo calculo")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

