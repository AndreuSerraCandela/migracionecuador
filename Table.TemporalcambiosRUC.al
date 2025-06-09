table 76074 "Temporal cambios RUC"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "RUC existente"; Code[30])
        {
        }
        field(3; "TD existente"; Text[30])
        {
        }
        field(4; "TD _nuevo"; Code[30])
        {
        }
        field(5; "RUC _nuevo"; Text[30])
        {
        }
        field(10; "Fecha registro"; Date)
        {
        }
        field(20; Procesado; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

