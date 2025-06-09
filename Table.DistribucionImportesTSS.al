table 76253 "Distribucion Importes TSS"
{
    Caption = 'SS amount distribution';

    fields
    {
        field(1; Ano; Integer)
        {
            Caption = 'Year';
        }
        field(2; "Concepto Salarial"; Code[20])
        {
            Caption = 'Wage code';
            TableRelation = "Conceptos salariales";
        }
        field(3; "No. orden"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Order no.';
            Editable = false;
        }
        field(4; "Importe Maximo"; Decimal)
        {
            Caption = 'Maximun amount';
            DecimalPlaces = 2 : 2;
        }
        field(5; "Importe retencion"; Decimal)
        {
            Caption = 'Retention amount';
            DecimalPlaces = 2 : 2;
        }
        field(6; "% Retencion"; Decimal)
        {
            Caption = 'Retention %';
            DecimalPlaces = 2 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1; Ano, "Concepto Salarial", "No. orden")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

