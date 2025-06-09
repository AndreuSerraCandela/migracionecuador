page 76287 "Lista de Tipos de enventos"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Tipos de Eventos";

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
            }
        }
    }

    actions
    {
    }
}

