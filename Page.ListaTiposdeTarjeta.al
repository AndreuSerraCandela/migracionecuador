page 76313 "Lista Tipos de Tarjeta"
{
    ApplicationArea = all;
    CardPageID = "Ficha Tipos de Tajerta";
    Editable = false;
    PageType = List;
    SourceTable = "Tipos de Tarjeta";

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
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

    trigger OnInit()
    var

    begin


    end;
}

