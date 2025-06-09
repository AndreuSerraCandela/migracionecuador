table 55005 "Documentos por Cliente ATS"
{

    fields
    {
        field(1; "Tipo ID Cliente"; Code[10])
        {
        }
        field(2; "ID Cliente"; Code[30])
        {
        }
        field(3; TipoComprobante; Code[20])
        {
        }
        field(4; NumroComprobantes; Integer)
        {
        }
        field(5; BaseNoGraIva; Decimal)
        {
        }
        field(6; BaseImponible; Decimal)
        {
        }
        field(7; BaseImpGrav; Decimal)
        {
        }
        field(8; MontoIva; Decimal)
        {
        }
        field(9; ValorRetIva; Decimal)
        {
        }
        field(10; ValorRetRenta; Decimal)
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

