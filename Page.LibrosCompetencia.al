page 76262 "Libros Competencia"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Libros Competencia";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                    TableRelation = Editoras;
                }
                field("Cod. Libro"; rec."Cod. Libro")
                {
                }
                field(Nivel; rec.Nivel)
                {
                }
                field(Description; rec.Description)
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Cod. Libro Santillana"; rec."Cod. Libro Santillana")
                {
                }
                field("Description Santillana"; rec."Description Santillana")
                {
                    Editable = false;
                }
                field("Nombre Editorial"; rec."Nombre Editorial")
                {
                    Visible = false;
                }
                field(Precio; rec.Precio)
                {
                }
                field("Año Edición"; rec."Año Edición")
                {
                }
                field("Año Uso"; rec."Año Uso")
                {
                }
            }
        }
    }

    actions
    {
    }
}

