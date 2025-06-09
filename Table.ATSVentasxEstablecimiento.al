table 56079 "ATS Ventas x Establecimiento"
{

    fields
    {
        field(10; "Cod.Establecimiento"; Code[20])
        {
            Caption = 'Cod.Establecimiento';
        }
        field(11; "Ventas Establecimiento"; Decimal)
        {
            Caption = 'Ventas Establecimiento';
        }
        field(12; "Mes -  Periodo"; Integer)
        {
            Caption = 'Mes -  Periodo';
        }
        field(13; "Año - Periodo"; Integer)
        {
            Caption = 'Año - Periodo';
        }
    }

    keys
    {
        key(Key1; "Cod.Establecimiento")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

