table 76234 "Tabla trabajo Ranking"
{

    fields
    {
        field(1; "Campaña"; Code[4])
        {
        }
        field(2; "No. Orden"; Integer)
        {
        }
        field(3; "Cod. Colegio"; Code[20])
        {
        }
        field(4; "Nombre Colegio"; Text[100])
        {
        }
        field(5; Distrito; Text[30])
        {
        }
        field(6; Zona; Code[20])
        {
        }
        field(7; "CVM GN"; Code[3])
        {
        }
        field(8; "CVM TEXTO_GEN"; Code[3])
        {
        }
        field(9; "CVM TEXTO_INI"; Code[3])
        {
        }
        field(10; "CVM TEXTO_PRI"; Code[3])
        {
        }
        field(11; "CVM TEXTO_SEC"; Code[3])
        {
        }
        field(12; RICHMOND_GEN; Code[3])
        {
        }
        field(13; RICHMOND_INI; Code[3])
        {
        }
        field(14; RICHMOND_PRI; Code[3])
        {
        }
        field(15; RICHMOND_SEC; Code[3])
        {
        }
        field(16; "PLAN LECTOR_GEN"; Code[3])
        {
        }
        field(17; "PLAN LECTOR_INI"; Code[3])
        {
        }
        field(18; "PLAN LECTOR_PRI"; Code[3])
        {
        }
        field(19; "PLAN LECTOR_SEC"; Code[3])
        {
        }
        field(20; COMPARTIR_GEN; Code[3])
        {
        }
        field(21; COMPARTIR_INI; Code[3])
        {
        }
        field(22; COMPARTIR_PRI; Code[3])
        {
        }
        field(23; COMPARTIR_SEC; Code[3])
        {
        }
        field(24; "MONTO BRUTO_INI"; Decimal)
        {
        }
        field(25; "MONTO BRUTO_PRI"; Decimal)
        {
        }
        field(26; "MONTO BRUTO_SEC"; Decimal)
        {
        }
        field(27; "MONTO BRUTO_ING"; Decimal)
        {
        }
        field(28; "MONTO BRUTO_READ"; Decimal)
        {
        }
        field(29; "MONTO BRUTO_PLA"; Decimal)
        {
        }
        field(30; "MONTO BRUTO_LETI"; Decimal)
        {
        }
        field(31; "MONTO BRUTO_DICC"; Decimal)
        {
        }
        field(32; "MONTO BRUTO_BIBL"; Decimal)
        {
        }
        field(33; "MONTO TOTAL_ESPAÑOL"; Decimal)
        {
        }
        field(34; "MONTO TOTAL_INGLES"; Decimal)
        {
        }
        field(35; "MONTO TOTAL_PLAN LECTOR"; Decimal)
        {
        }
        field(36; "MONTO TOTAL_GENERAL"; Decimal)
        {
        }
        field(37; "PORC MONTO BRUTO_ESPAÑOL"; Integer)
        {
        }
        field(38; "PORC MONTO BRUTO_INGLES"; Integer)
        {
        }
        field(39; "PORC MONTO BRUTO_PLAN LECTOR"; Integer)
        {
        }
        field(40; "PORC MONTO BRUTO_GENERAL"; Integer)
        {
        }
        field(41; Tipo; Option)
        {
            OptionCaption = 'Colegio,Nido';
            OptionMembers = Colegio,Nido;
        }
        field(42; Estado; Option)
        {
            OptionCaption = ',Usuario,No Usuario';
            OptionMembers = ,Usuario,"No Usuario";
        }
        field(43; "MONTO BRUTO_GENERAL"; Decimal)
        {
        }
        field(44; Reporte; Option)
        {
            OptionCaption = 'General,CVM';
            OptionMembers = General,CVM;
        }
        field(45; FechaGen; Date)
        {
        }
        field(47; "Delegación"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Reporte, "Campaña", "Cod. Colegio")
        {
            Clustered = true;
        }
        key(Key2; Reporte, "Campaña", "Delegación", "MONTO TOTAL_GENERAL")
        {
        }
        key(Key3; Reporte, "Campaña", "Delegación", "CVM GN")
        {
        }
        key(Key4; Reporte, "Campaña", "Delegación", "No. Orden")
        {
        }
    }

    fieldgroups
    {
    }
}

