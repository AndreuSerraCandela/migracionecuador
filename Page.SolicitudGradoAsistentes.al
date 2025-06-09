page 76397 "Solicitud - Grado Asistentes"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Solicitud -  Grado Asistente";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field("No. Asistentes"; rec."No. Asistentes")
                {
                }
            }
        }
    }

    actions
    {
    }
}

