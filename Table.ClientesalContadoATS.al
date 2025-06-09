table 55006 "Clientes al Contado ATS"
{

    fields
    {
        field(1; "Tipo ID Cliente"; Option)
        {
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;
        }
        field(2; "ID Cliente"; Code[30])
        {
        }
        field(3; TipoComprobante; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Tipo ID Cliente", "ID Cliente", TipoComprobante)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

