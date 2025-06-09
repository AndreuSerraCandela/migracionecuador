table 76258 "Numeradores globales"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "No. serie empleados"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "No. serie candidatos"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "No. serie acciones"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Campo 1"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6; "Campo 2"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

