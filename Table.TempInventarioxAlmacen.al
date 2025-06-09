table 50900 "Temp Inventario x Almacen"
{

    fields
    {
        field(1; Producto; Code[20])
        {
        }
        field(2; Almacen; Code[20])
        {
        }
        field(3; Existencias; Decimal)
        {
        }
        field(4; Consignacion; Boolean)
        {
        }
        field(5; "Coste unitario"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Producto, Almacen)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

