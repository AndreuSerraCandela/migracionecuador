table 70006 "Estados GL101"
{

    fields
    {
        field(1; "Código"; Code[10])
        {
        }
        field(2; "Descripción"; Text[40])
        {
        }
    }

    keys
    {
        key(Key1; "Código")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

