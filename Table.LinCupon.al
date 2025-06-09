table 56049 "Lin. Cupon."
{
    Caption = 'Coupon Lines';

    fields
    {
        field(1; "No. Cupon"; Code[20])
        {
            Caption = 'Coupon No.';
        }
        field(2; "Cod. Producto"; Code[20])
        {
            Caption = 'Coupon Code';
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

            trigger OnValidate()
            begin

                if rCabCupon.Get("No. Cupon") then begin
                    if rUserSetup.Get(UserId) then begin
                        if not rUserSetup."Permite modificar Cupon" then
                            rCabCupon.TestField(rCabCupon.Impreso, false);
                    end
                    else
                        rCabCupon.TestField(rCabCupon.Impreso, false);
                    "Cantidad Pendiente" := Cantidad;
                end;
            end;
        }
        field(7; "Cantidad Pendiente"; Integer)
        {
            Caption = 'Remaning Qty.';
        }
    }

    keys
    {
        key(Key1; "No. Cupon", "Cod. Producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        rConfSantillana.Get;
        rLinCupon.Reset;
        rLinCupon.SetRange("No. Cupon", "No. Cupon");
        if (rLinCupon.Count + 1) > rConfSantillana."Cantidad Lineas en Cupón" then
            Error(Error002);


        rCabCupon.Get("No. Cupon");
        rCabCupon.TestField("Descuento a Padres de Familia");
        Validate("% Descuento", rCabCupon."Descuento a Padres de Familia");

        cRep.Cupon("No. Cupon");
    end;

    trigger OnModify()
    begin
        rCabCupon.Get("No. Cupon");
        if rCabCupon.Impreso then
            Error(Error001);

        cRep.Cupon("No. Cupon");
    end;

    var
        rProducto: Record Item;
        rCabCupon: Record "Cab. Cupon.";
        Error001: Label 'Printed Coupon cannot be modified';
        rConfSantillana: Record "Config. Empresa";
        rLinCupon: Record "Lin. Cupon.";
        Error002: Label 'Lines Qty. exceed the qty. allowed for a Coupon';
        rUserSetup: Record "User Setup";
        cRep: Codeunit "Funciones Replicador DsPOS";
}

