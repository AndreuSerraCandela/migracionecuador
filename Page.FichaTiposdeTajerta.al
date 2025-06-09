page 76227 "Ficha Tipos de Tajerta"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Tipos de Tarjeta";

    layout
    {
        area(content)
        {
            group(Control1000000001)
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
        Error001: Label 'Función Sólo Disponible en Servidor Central';

    begin

    end;
}

