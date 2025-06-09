table 64840 "Last SourceCounter Numbers"
{

    fields
    {
        field(1; TableNumber; Integer)
        {
        }
        field(2; "Last SourceCounter"; BigInteger)
        {
        }
    }

    keys
    {
        key(Key1; TableNumber)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

