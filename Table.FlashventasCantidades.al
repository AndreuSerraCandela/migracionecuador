table 50002 "Flash ventas (Cantidades)"
{

    fields
    {
        field(1; "Linea de negocio"; Code[20])
        {
        }
        field(2; "Grupo contable producto"; Code[20])
        {
        }
        field(3; "Cantidad netas Periodo 1"; Decimal)
        {
        }
        field(4; "Cantidad liquidas Periodo 1"; Decimal)
        {
        }
        field(5; "Cant. Not. cred. Netas Perd. 1"; Decimal)
        {
        }
        field(6; "Cant. Not. cred. Liq. Per. 1"; Decimal)
        {
        }
        field(7; "Cantidad Netas Periodo 2"; Decimal)
        {
        }
        field(8; "Cantidad Liquidas Periodo 2"; Decimal)
        {
        }
        field(9; "Cant. N. cred. Netas Perd. 2"; Decimal)
        {
        }
        field(10; "Cant N. cred. Liq. Perd. 2"; Decimal)
        {
        }
        field(11; "Cant. Netas Periodo 3"; Decimal)
        {
        }
        field(12; "Cant. Liquidas Periodo 3"; Decimal)
        {
        }
        field(13; "Cant. Notas cred. Net. Perd. 3"; Decimal)
        {
        }
        field(14; "Cant. Notas cred. Liq. Perd. 3"; Decimal)
        {
        }
        field(15; "Cant. Importe presup. liquido"; Decimal)
        {
        }
        field(16; "Cant. Netas periodo acumulado"; Decimal)
        {
        }
        field(17; "Cant. Liq. periodo acumulado"; Decimal)
        {
        }
        field(18; "Notas cred. periodo acumulado"; Decimal)
        {
        }
        field(19; "Cant. Importe presupuesto neto"; Decimal)
        {
        }
        field(20; "Presupuesto cant. liquida"; Decimal)
        {
        }
        field(21; "Cant. Imp. presp. liq. Dolares"; Decimal)
        {
        }
        field(22; "Cant. Imp. presp. Neto Dolares"; Decimal)
        {
        }
        field(23; "Presupuesto cant. neta"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Linea de negocio", "Grupo contable producto")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

