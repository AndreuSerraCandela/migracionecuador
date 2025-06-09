table 50120 "Serie Fiscal SIC"
{

    fields
    {
        field(1; Sucursal; Code[4])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Caja ID"; Code[5])
        {
            DataClassification = ToBeClassified;
        }
        field(3; IDNCF; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "NCF FISCAL"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; SIGLAS; Code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(6; INICIAL; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; FINAL; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "FECHA CADUCIDAD"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; ADVEERTENCIA; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; PROXIMO; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Sucursal, "Caja ID", IDNCF)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

