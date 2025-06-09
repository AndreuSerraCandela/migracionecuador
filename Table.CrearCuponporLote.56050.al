table 56050 "Crear Cupon por Lote."
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
        field(5; "% Descuento Padre"; Decimal)
        {
            Caption = 'Discount %';
        }
        field(6; Cantidad; Integer)
        {
            Caption = 'Quantity';
        }
        field(7; "Cod. Colegio"; Code[20])
        {
            Caption = 'School code';
            TableRelation = Contact;
        }
        field(8; "Cod. Nivel"; Code[20])
        {
            Caption = 'Level Code';
        }
        field(9; "Cod. Promotor"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(10; Turno; Code[20])
        {

            trigger OnValidate()
            begin
                if ColAdop.Get("Cod. Colegio", "Cod. Nivel", "Cod. Promotor", Turno) then begin

                end;
            end;
        }
        field(11; "Campaña"; Code[20])
        {
            Caption = 'Campaing';
            TableRelation = Campaign;
        }
        field(12; "% Descuento Colegio"; Decimal)
        {
        }
        field(13; "Cod. Grado"; Code[20])
        {
            Caption = 'Grade Code';
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
        ColAdop: Record "Colegio - Nivel";
}

