table 50800 Prueba
{

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; "Codigo 2"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
        key(Key2; "Codigo 2")
        {
        }
    }

    fieldgroups
    {
    }
}

