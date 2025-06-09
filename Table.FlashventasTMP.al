table 50000 "Flash ventas (TMP)"
{

    fields
    {
        field(1; "Linea de negocio"; Code[20])
        {
        }
        field(2; "Grupo contable producto"; Code[20])
        {
        }
        field(3; "Netas Periodo 1"; Decimal)
        {
        }
        field(4; "liquidas Periodo 1"; Decimal)
        {
        }
        field(5; "Notas cred. Netas Preiodo 1"; Decimal)
        {
        }
        field(6; "Notas cred. Liquidas Preiodo 1"; Decimal)
        {
        }
        field(7; "Netas Periodo 2"; Decimal)
        {
        }
        field(8; "Liquidas Periodo 2"; Decimal)
        {
        }
        field(9; "Notas cred. Netas Preiodo 2"; Decimal)
        {
        }
        field(10; "Notas cred. Liquidas Preiodo 2"; Decimal)
        {
        }
        field(11; "Netas Periodo 3"; Decimal)
        {
        }
        field(12; "Liquidas Periodo 3"; Decimal)
        {
        }
        field(13; "Notas cred. Netas Preiodo 3"; Decimal)
        {
        }
        field(14; "Notas cred. Liquidas Preiodo 3"; Decimal)
        {
        }
        field(15; "Importe presupuesto liquido"; Decimal)
        {
        }
        field(16; "Netas periodo acumulado"; Decimal)
        {
        }
        field(17; "Luquidas periodo acumulado"; Decimal)
        {
        }
        field(18; "Notas cred. periodo acumulado"; Decimal)
        {
        }
        field(19; "Importe presupuesto neto"; Decimal)
        {
        }
        field(20; "Presupuesto Cantidades"; Decimal)
        {
        }
        field(21; "Imp. presup. liquido Dolares"; Decimal)
        {
        }
        field(22; "Imp. presup. Neto Dolares"; Decimal)
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

