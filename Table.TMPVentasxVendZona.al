table 50005 "TMP: Ventas x Vend. - Zona"
{

    fields
    {
        field(1; "Cod. Vendedor"; Code[10])
        {
        }
        field(2; "Cod. Zona"; Code[10])
        {
        }
        field(3; "Entry No."; Integer)
        {
        }
        field(4; "Monto Original"; Decimal)
        {
        }
        field(5; "Monto Pendiente"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Vendedor", "Cod. Zona", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

