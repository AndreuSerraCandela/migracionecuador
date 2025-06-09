table 55011 "Impuestos FE"
{

    fields
    {
        field(10; "No. documento"; Code[20])
        {
        }
        field(15; "No. linea"; Integer)
        {
        }
        field(20; Codigo; Code[1])
        {
        }
        field(30; "Codigo Porcentaje"; Code[4])
        {
        }
        field(40; "Base Imponible"; Decimal)
        {
        }
        field(50; Tarifa; Decimal)
        {
        }
        field(60; Valor; Decimal)
        {
        }
        field(200; Subtotal; Decimal)
        {
            Description = 'Informativo, para la impresión';
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

