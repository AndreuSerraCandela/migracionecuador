table 70510 TL010
{

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; Descripcion; Text[100])
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

