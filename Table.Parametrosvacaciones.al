table 76334 "Parametros vacaciones"
{
    Caption = 'Vacation parameters';
    DataPerCompany = false;

    fields
    {
        field(1; Desde; Integer)
        {
            Caption = 'Years from';
            DataClassification = ToBeClassified;
        }
        field(2; "Cantidad de dias"; Integer)
        {
            Caption = 'Quantity of days';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Desde)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

