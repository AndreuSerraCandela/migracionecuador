page 76256 "Horas Extras(Disponible)"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Control de asistencia";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field("Hora registro"; rec."Hora registro")
                {
                }
                field("No. tarjeta"; rec."No. tarjeta")
                {
                }
                field("ID Equipo"; rec."ID Equipo")
                {
                }
            }
        }
    }

    actions
    {
    }
}

