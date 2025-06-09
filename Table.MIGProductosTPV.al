table 82511 "MIG Productos TPV"
{
    LookupPageID = "Lista Tipos de Tarjeta";

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; Descripcion; Text[250])
        {
        }
        field(3; ID; Integer)
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

