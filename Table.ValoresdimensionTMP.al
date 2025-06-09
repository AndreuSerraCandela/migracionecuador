table 50010 "Valores dimension TMP"
{

    fields
    {
        field(1; Codigo; Code[10])
        {
        }
        field(2; nombre; Text[100])
        {
        }
        field(3; identar; Integer)
        {
        }
        field(4; "Tipo Valor Dimension"; Text[30])
        {
        }
        field(5; sumatorio; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

