table 51011 "Crear Cupon por Lote"
{
    Caption = 'Coupon Lines';

    fields
    {
        field(2; "Cod. Producto"; Code[20])
        {
            Caption = 'Coupon Code';
            NotBlank = false;
            TableRelation = Item;

            trigger OnValidate()
            begin
                rProducto.Get("Cod. Producto");
                Descripcion := rProducto.Description;
            end;
        }
        field(3; Descripcion; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Precio Venta"; Decimal)
        {
            Caption = 'Sales Price';
        }
        field(5; "% Descuento"; Decimal)
        {
            Caption = 'Discount %';
        }
        field(6; Cantidad; Integer)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "Cod. Producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rProducto: Record Item;
        rCabCupon: Record "Cab. Cupon.";
        Error001: Label 'Printed Coupon cannot be modified';
}

