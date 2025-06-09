table 70010 "Relacion Material Ambito"
{

    fields
    {
        field(1; "Codigo Santillana"; Code[20])
        {
        }
        field(2; "Codigo Ambito"; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Codigo Santillana")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

