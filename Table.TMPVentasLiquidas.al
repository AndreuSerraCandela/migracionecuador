table 50137 "TMP: Ventas Liquidas"
{

    fields
    {
        field(1; "Nivel Educativo"; Code[20])
        {
            //TableRelation = Table50133;
        }
        field(2; "Grupo Contable Producto"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(3; Ventas; Decimal)
        {
        }
        field(4; Notas; Decimal)
        {
        }
        field(5; Neto; Decimal)
        {
        }
        field(6; Costo; Decimal)
        {
        }
        field(7; "Ventas P-1"; Decimal)
        {
            Description = 'p-1=periodo igual del año proximo anterior';
        }
        field(8; "Notas P-1"; Decimal)
        {
        }
        field(9; "Neto P-1"; Decimal)
        {
        }
        field(10; "Costo P-1"; Decimal)
        {
        }
        field(11; "Ventas A-1"; Decimal)
        {
            Description = 'a-1=todo el año proximo anterior';
        }
        field(12; "Notas A-1"; Decimal)
        {
        }
        field(13; "Neto A-1"; Decimal)
        {
        }
        field(14; "Costo A-1"; Decimal)
        {
        }
        field(15; "Ventas Actual"; Decimal)
        {
        }
        field(16; "Notas Actual"; Decimal)
        {
        }
        field(17; "Neto Actual"; Decimal)
        {
        }
        field(18; "Costo Actual"; Decimal)
        {
        }
        field(19; "Ppto Anual"; Decimal)
        {
        }
        field(20; "Costo Notas"; Decimal)
        {
        }
        field(21; "Costo Notas P-1"; Decimal)
        {
        }
        field(22; "Costo Notas A-1"; Decimal)
        {
        }
        field(23; "Costo Notas Actual"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Grupo Contable Producto", "Nivel Educativo")
        {
            Clustered = true;
        }
        key(Key2; "Nivel Educativo")
        {
        }
    }

    fieldgroups
    {
    }
}

