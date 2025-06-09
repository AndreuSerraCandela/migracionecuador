table 70515 "Producto-Cod. Descuento"
{

    fields
    {
        field(1; "Cod. Producto"; Code[20])
        {
        }
        field(2; "Cod. Descuento"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

