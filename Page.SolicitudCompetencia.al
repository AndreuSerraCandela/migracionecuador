page 76395 "Solicitud - Competencia"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Solicitud - Competencia";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                }
                field("Cod. Libro"; rec."Cod. Libro")
                {
                }
                field(Nivel; rec.Nivel)
                {
                }
                field(Description; rec.Description)
                {
                    Editable = false;
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                    Editable = false;
                }
                field("Nombre Editorial"; rec."Nombre Editorial")
                {
                    Editable = false;
                }
                field("Horas a la semana"; rec."Horas a la semana")
                {
                }
                field("Año Adopción"; rec."Año Adopción")
                {
                }
            }
        }
    }

    actions
    {
    }
}

