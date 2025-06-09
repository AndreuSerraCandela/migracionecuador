page 76175 "Dimensiones Contabilizacion"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Dimensiones Contabilizacion";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Dimension"; rec."Cod. Dimension")
                {
                }
                field(Orden; rec.Orden)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Requerida; rec.Requerida)
                {
                }
                field("Validar en"; rec."Validar en")
                {
                }
            }
        }
    }

    actions
    {
    }
}

