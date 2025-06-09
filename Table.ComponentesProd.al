table 50135 "Componentes Prod."
{

    fields
    {
        field(1; "Código"; Code[20])
        {
        }
        field(2; "Descripción"; Text[30])
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

