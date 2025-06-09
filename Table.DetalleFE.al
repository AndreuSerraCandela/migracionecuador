table 55010 "Detalle FE"
{
    // #57011    13/09/2016    JMB     :     Modificamos el numero de decimal a (3) en el campo precio unitario.


    fields
    {
        field(10; "No. documento"; Code[20])
        {
        }
        field(15; "No. linea"; Integer)
        {
        }
        field(20; "Codigo Principal"; Code[25])
        {
        }
        field(30; "Codigo Auxiliar"; Code[25])
        {
        }
        field(40; Descripcion; Text[250])
        {
        }
        field(50; Cantidad; Decimal)
        {
        }
        field(60; "Precio Unitario"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            Description = '#57011';
        }
        field(70; Descuento; Decimal)
        {
        }
        field(80; "Precio Total Sin Impuesto"; Decimal)
        {
        }
        field(90; "Detalle adicional 1"; Text[30])
        {
            Caption = 'Detalle adicional';
        }
        field(100; "Detalle adicional 2"; Text[30])
        {
            Caption = 'Detalle adicional';
        }
        field(110; "Detalle adicional 3"; Text[30])
        {
            Caption = 'Detalle adicional';
        }
        field(111; "Precio Total Con Impuesto"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No. documento", "No. linea")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

