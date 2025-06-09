page 76167 "Descuentos x forma de pago"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Descuento x forma de pago";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID Pago"; rec."ID Pago")
                {
                    Editable = false;
                }
                field("No. Linea"; rec."No. Linea")
                {
                }
                field(Activo; rec.Activo)
                {
                }
                field("Fecha inicio"; rec."Fecha inicio")
                {
                }
                field("Fecha final"; rec."Fecha final")
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field("% Descuento linea"; rec."% Descuento linea")
                {
                }
            }
        }
    }

    actions
    {
    }
}

