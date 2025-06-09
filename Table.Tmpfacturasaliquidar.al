table 86001 "Tmp facturas a liquidar"
{

    fields
    {
        field(10; "No. factura"; Code[20])
        {
        }
        field(20; "No. producto"; Code[20])
        {
        }
        field(30; "Cantidad liquidable"; Decimal)
        {
        }
        field(40; "No. linea"; Integer)
        {
        }
        field(50; "No. mov. producto"; Integer)
        {
        }
        field(60; Pendiente; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No. factura", "No. linea", "No. producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

