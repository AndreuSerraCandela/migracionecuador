page 76399 "Solicitud -  Nivel Asistentes"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Solicitud -  Nivel Asistente";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Nivel"; rec."Cod. Nivel")
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

