table 76039 "Tabla retencion ISR"
{
    DataPerCompany = false;
    LookupPageID = "Beneficios puestos laborales";

    fields
    {
        field(1; Ano; Code[4])
        {
        }
        field(2; "No. orden"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(3; "Importe Máximo"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(4; "Importe retención"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(5; "% Retención"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(Key1; Ano, "No. orden")
        {
            Clustered = true;
        }
        key(Key2; Ano, "Importe Máximo")
        {
        }
    }

    fieldgroups
    {
    }
}

