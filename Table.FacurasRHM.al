table 59003 "Facuras RHM"
{

    fields
    {
        field(1; Documento; Code[20])
        {
        }
        field(2; "Fecha registro"; Date)
        {
        }
        field(3; Cliente; Code[20])
        {
        }
        field(4; Nombre; Text[100])
        {
        }
        field(5; "Importe Original"; Decimal)
        {
        }
        field(6; "Importe pendiente"; Decimal)
        {
        }
        field(7; "Importe RHM"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Documento)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

