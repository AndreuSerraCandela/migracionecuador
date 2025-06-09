table 70501 GL017
{

    fields
    {
        field(1; Codigo; Code[10])
        {
        }
        field(2; Descripcion; Text[200])
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

