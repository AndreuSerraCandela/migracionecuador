table 76173 "Conceptos formula"
{
    Caption = 'Wedge formulation';

    fields
    {
        field(1; Concepto; Code[20])
        {
        }
        field(2; Formula; Text[80])
        {
        }
        field(3; Valor; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(Key1; Concepto)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

