page 76398 "Solicitud - Libros a Presentar"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Solicitud - Libros presentar";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field("Descripción Producto"; rec."Descripción Producto")
                {
                }
                field("Horas por semana"; rec."Horas por semana")
                {
                }
                field("Año adopción"; rec."Año adopción")
                {
                }
            }
        }
    }

    actions
    {
    }
}

