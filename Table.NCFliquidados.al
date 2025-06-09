table 76057 "NCF liquidados"
{

    fields
    {
        field(1; NCF; Text[30])
        {
        }
        field(2; Importe; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; NCF)
        {
            Clustered = true;
        }
        key(Key2; Importe)
        {
        }
    }

    fieldgroups
    {
    }
}

