table 56045 Produccion
{

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; Descripcion; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

