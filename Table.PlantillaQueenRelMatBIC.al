table 70009 "Plantilla Queen Rel. Mat. BIC"
{

    fields
    {
        field(1; "Codigo Santillana"; Code[20])
        {
        }
        field(2; "Codigo BIC"; Code[20])
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

