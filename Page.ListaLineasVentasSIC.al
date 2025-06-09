page 50117 "Lista Lineas Ventas SIC"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Lineas Ventas SIC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("No. linea"; rec."No. linea")
                {
                }
                field("No. documento SIC"; rec."No. documento SIC")
                {
                }
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("Cod. Moneda"; rec."Cod. Moneda")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Importe descuento"; rec."Importe descuento")
                {
                }
                field("Precio de venta"; rec."Precio de venta")
                {
                }
                field("Unidad de medida"; rec."Unidad de medida")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Importe ITBIS Incluido"; rec."Importe ITBIS Incluido")
                {
                }
                field(codproducto; rec.codproducto)
                {
                }
                field(Transferido; rec.Transferido)
                {
                }
                field(ITBIS; rec.ITBIS)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

