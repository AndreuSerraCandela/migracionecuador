table 56008 "Estado productos"
{
    DrillDownPageID = "Cab. Hoja de Ruta";
    LookupPageID = "Cab. Hoja de Ruta";

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

