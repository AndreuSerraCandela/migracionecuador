page 76228 "Ficha Vendedor"
{
    ApplicationArea = all;
    DelayedInsert = true;
    SourceTable = Vendedores;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Tienda; rec.Tienda)
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Nombre; rec.Nombre)
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

        Error001: Label 'Función Sólo disponible en Servidor Central';
    begin


    end;
}

