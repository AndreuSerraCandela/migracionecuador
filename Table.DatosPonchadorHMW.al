table 50109 "DatosPonchador HMW"
{
    Caption = 'Time attendance log';
    DataPerCompany = false;
    LinkedObject = true;

    fields
    {
        field(1; IdUser; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            SQLDataType = Integer;
        }
        field(2; RecordTime; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; MachineNumber; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; IdentificationNumber; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Name; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; ProximityCard; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; CodigoBC; Code[20])
        {
            DataClassification = ToBeClassified;
            SQLDataType = Integer;
        }
    }

    keys
    {
        key(Key1; IdUser, RecordTime)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

