page 76392 "Shift schedule"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Shift schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Codigo turno"; rec."Codigo turno")
                {
                    Visible = false;
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Hora Inicio"; rec."Hora Inicio")
                {
                }
                field("Hora Fin"; rec."Hora Fin")
                {
                }
            }
        }
    }

    actions
    {
    }
}

