page 76030 "Ficha Formas de Pago"
{
    ApplicationArea = all;
    // #373762, RRT, 27.05.2021: Crear la posibilildad de configurar un descuento por forma de pago.

    SourceTable = "Formas de Pago";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ID Pago"; rec."ID Pago")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Efectivo Local"; rec."Efectivo Local")
                {
                    Caption = 'Cash in Local Currency';
                }
                field("Abre cajon"; rec."Abre cajon")
                {
                }
                field("Cod. divisa"; rec."Cod. divisa")
                {
                }
                field("Tipo Tarjeta"; rec."Tipo Tarjeta")
                {
                }
                field("Realizar recuento"; rec."Realizar recuento")
                {
                }
                field("Icono Nav"; rec."Icono Nav")
                {
                    Caption = 'Icono';
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
                RunPageLink = "ID Pago" = FIELD ("ID Pago");
                RunPageView = SORTING ("ID Pago", "No. Linea")
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

