table 56086 "% Provisión"
{
    // 001 CAT 20/02/14  #144 Configuración de los porcentajes de insolvencias


    fields
    {
        field(1; "Desde día"; Integer)
        {
        }
        field(2; "Descripción"; Text[30])
        {
        }
        field(3; "% Provisión"; Decimal)
        {
        }
        field(4; "Importe provisión"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Desde día")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

