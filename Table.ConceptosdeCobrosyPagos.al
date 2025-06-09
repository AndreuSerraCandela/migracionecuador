table 50136 "Conceptos de Cobros y Pagos"
{

    fields
    {
        field(1; "Codigo Concepto"; Code[20])
        {
        }
        field(2; Descripcion; Text[60])
        {
        }
        field(3; Tipo; Option)
        {
            OptionMembers = Cobro,Pago;
        }
    }

    keys
    {
        key(Key1; "Codigo Concepto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

