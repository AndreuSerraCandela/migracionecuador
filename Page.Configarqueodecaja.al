page 76152 "Config. arqueo de caja"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Billetes y Monedas Divisa";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. divisa"; rec."Cod. divisa")
                {
                }
                field(Tipo; rec.Tipo)
                {
                }
                field(Importe; rec.Importe)
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

