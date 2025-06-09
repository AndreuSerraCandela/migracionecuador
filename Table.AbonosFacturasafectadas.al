table 50016 "Abonos - Facturas afectadas"
{

    fields
    {
        field(1; "No. Abono"; Code[20])
        {
        }
        field(2; "Fecha Abono"; Date)
        {
        }
        field(3; "No factura"; Code[20])
        {
        }
        field(4; "Fecha Factura"; Date)
        {
        }
        field(5; "No. Doc. Ext Abono"; Code[20])
        {
        }
        field(6; "Importe Abono"; Decimal)
        {
        }
        field(7; "Importe Factura"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "No. Abono", "No factura")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

