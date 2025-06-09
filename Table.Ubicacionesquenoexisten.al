table 50500 "Ubicaciones que no existen"
{

    fields
    {
        field(1; "Cod. Ubicacion"; Code[50])
        {
        }
        field(2; "Cod. Almacen"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Ubicacion", "Cod. Almacen")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

