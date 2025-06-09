table 76081 Tokens
{
    Caption = 'Tokens';

    fields
    {
        field(1; Formula; Text[80])
        {
            Caption = 'Formula';
        }
        field(2; Puntero; Integer)
        {
            Caption = 'Pointer';
        }
        field(3; Token; Text[30])
        {
            Caption = 'Token';
        }
    }

    keys
    {
        key(Key1; Formula, Puntero)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

