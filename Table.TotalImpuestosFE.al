table 55009 "Total Impuestos FE"
{

    fields
    {
        field(10; "No. documento"; Code[20])
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
    }

    keys
    {
        key(Key1; "No. documento", Codigo, "Codigo Porcentaje")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

