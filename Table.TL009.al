table 70504 TL009
{

    fields
    {
        field(1; Codigo; Code[20])
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

