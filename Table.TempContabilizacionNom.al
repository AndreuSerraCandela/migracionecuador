table 76010 "Temp Contabilizacion Nom."
{

    fields
    {
        field(1; "Tipo Cuenta"; Integer)
        {
        }
        field(2; "No. Cuenta"; Code[20])
        {
        }
        field(3; "No. Linea"; Integer)
        {
        }
        field(4; Descripcion; Text[60])
        {
        }
        field(5; Importe; Decimal)
        {
        }
        field(6; "Cod. Dim 1"; Code[20])
        {
        }
        field(7; "Valor Dim 1"; Text[20])
        {
        }
        field(8; "Cod. Dim 2"; Code[20])
        {
        }
        field(9; "Valor Dim 2"; Text[20])
        {
        }
        field(10; "Cod. Dim 3"; Code[20])
        {
        }
        field(11; "Valor Dim 3"; Text[20])
        {
        }
        field(12; "Cod. Dim 4"; Code[20])
        {
        }
        field(13; "Valor Dim 4"; Text[20])
        {
        }
        field(14; "Cod. Dim 5"; Code[20])
        {
        }
        field(15; "Valor Dim 5"; Text[20])
        {
        }
        field(16; "Cod. Dim 6"; Code[20])
        {
        }
        field(17; "Valor Dim 6"; Text[20])
        {
        }
        field(18; "Importe Db"; Decimal)
        {
        }
        field(19; "Importe Cr"; Decimal)
        {
        }
        field(20; "Importe Db CK"; Decimal)
        {
        }
        field(21; "Importe Cr CK"; Decimal)
        {
        }
        field(22; Step; Integer)
        {
        }
        field(23; "Cod. Empleado"; Code[20])
        {
        }
        field(24; "No. Documento"; Code[20])
        {
        }
        field(25; "Dimension Set ID"; Integer)
        {
        }
        field(26; "Forma de Cobro"; Option)
        {
            Description = ' ,Efectivo,Cheque,Transferencia Banc.';
            OptionMembers = " ",Efectivo,Cheque,"Transferencia Banc.";
        }
        field(27; Concepto; Code[20])
        {
        }
        field(28; Contrapartida; Boolean)
        {
        }
        field(29; "Job code"; Code[20])
        {
        }
        field(30; "Job task"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Step, "No. Cuenta", "Cod. Empleado", "Valor Dim 1", "Valor Dim 2", "Valor Dim 3", "Valor Dim 4", "Valor Dim 5", "Valor Dim 6", "No. Linea", "Forma de Cobro")
        {
            Clustered = true;
        }
        key(Key2; "No. Cuenta", "Valor Dim 1", "Valor Dim 2", "Valor Dim 3", "Valor Dim 4", "Valor Dim 5", "Valor Dim 6")
        {
        }
        key(Key3; "Tipo Cuenta", "No. Cuenta", "No. Linea", Step)
        {
        }
    }

    fieldgroups
    {
    }
}

