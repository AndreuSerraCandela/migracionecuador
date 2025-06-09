table 59001 "tmp ctas"
{

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; Entrada; Boolean)
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

