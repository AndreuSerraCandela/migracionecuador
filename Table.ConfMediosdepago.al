table 50121 "Conf. Medios de pago"
{
    DrillDownPageID = "Conf. Medios de pagos";
    LookupPageID = "Conf. Medios de pagos";

    fields
    {
        field(1; "Cod. med. pago"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Credito; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Account Type" = CONST ("G/L Account")) "G/L Account" WHERE ("Account Type" = CONST (Posting),
                                                                                          Blocked = CONST (false))
            ELSE
            IF ("Account Type" = CONST (Customer)) Customer
            ELSE
            IF ("Account Type" = CONST (Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST ("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST ("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST ("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type" = CONST (Employee)) Employee;
        }
        field(5; Descripcion; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Cod. Forma Pago"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(7; "ID Agrupacion"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Cod. med. pago")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. med. pago", Descripcion, "Account Type", "Account No.", "Cod. Forma Pago")
        {
        }
    }
}

