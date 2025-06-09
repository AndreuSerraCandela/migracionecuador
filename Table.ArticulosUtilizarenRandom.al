table 70008 "Articulos Utilizar en Random"
{

    fields
    {
        field(1; Codigo; Code[30])
        {
        }
        field(2; ISBN; Code[30])
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

