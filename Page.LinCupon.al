page 56067 "Lin. Cupon"
{
    ApplicationArea = all;
    Caption = 'Coupon Line';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Lin. Cupon.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Precio Venta"; rec."Precio Venta")
                {
                }
                field("% Descuento"; rec."% Descuento")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Cantidad Pendiente"; rec."Cantidad Pendiente")
                {
                }
            }
        }
    }

    actions
    {
    }
}

