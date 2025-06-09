table 50001 "Presupuesto (Flash de ventas)"
{

    fields
    {
        field(1; "Grupo contable producto"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(2; "Cod. linea de negocio"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = CONST ('LINEA_NEGOCIO'));
        }
        field(3; "Presupuesto Importe Neto"; Decimal)
        {
        }
        field(4; "Presupuesto Importe liquido"; Decimal)
        {
        }
        field(5; "Presupuesto cant. neta"; Decimal)
        {
        }
        field(6; "Imp. presup. liquido Dolares"; Decimal)
        {
        }
        field(7; "Imp. presup. Neto Dolares"; Decimal)
        {
        }
        field(8; "Presupuesto cant. liquidas"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Grupo contable producto", "Cod. linea de negocio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

