table 76048 "Billetes y Monedas Divisa"
{
    Caption = 'Billetes y Monedas Divisa';

    fields
    {
        field(10; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(20; Tipo; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Coin,Note,Roll';
            OptionMembers = Moneda,Billete;
        }
        field(30; Importe; Decimal)
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Cod. divisa", Tipo, Importe)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

