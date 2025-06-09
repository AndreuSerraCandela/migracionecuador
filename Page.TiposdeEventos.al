page 76417 "Tipos de Eventos"
{
    ApplicationArea = all;

    PageType = Card;
    SourceTable = "Tipos de Eventos";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Ingresar grados"; rec."Ingresar grados")
                {
                }
                field("Ingresar libros a presentar"; rec."Ingresar libros a presentar")
                {
                }
            }
        }
    }

    actions
    {
    }
}

