page 76295 "Lista Formas de Pago"
{
    ApplicationArea = all;
    // #373762, RRT, 27.05.2021: Crear la posibilildad de configurar un descuento por forma de pago.

    CardPageID = "Ficha Formas de Pago";
    Editable = false;
    PageType = List;
    SourceTable = "Formas de Pago";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Pago"; rec."ID Pago")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Icono Nav"; rec."Icono Nav")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Descuentos por forma de pago")
            {
                Image = Discount;
                RunObject = Page "Descuentos x forma de pago";
                RunPageLink = "ID Pago" = FIELD("ID Pago");
                RunPageView = SORTING("ID Pago", "No. Linea")
                              ORDER(Ascending);
            }
        }
    }

    trigger OnInit()
    var

        Error001: Label 'Función Sólo Disponible en Servidor Central';
    begin


    end;
}

