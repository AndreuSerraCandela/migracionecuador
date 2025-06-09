table 56040 "Contactos Proveedores"
{
    Caption = 'Vendor Contact';
/*     DrillDownPageID = 53516;
    LookupPageID = 53516; */

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Job position"; Text[30])
        {
            Caption = 'Job position';
        }
        field(5; "E-mail"; Text[50])
        {
            Caption = 'E-mail';
            ExtendedDatatype = EMail;
        }
        field(6; Phone; Text[30])
        {
            Caption = 'Phone';
            ExtendedDatatype = PhoneNo;
        }
        field(7; Extension; Text[10])
        {
            Caption = 'Extension';
        }
        field(8; "Cell Phone"; Text[30])
        {
            Caption = 'Cell Phone';
            ExtendedDatatype = PhoneNo;
        }
        field(9; Fax; Text[30])
        {
            Caption = 'Fax';
            ExtendedDatatype = PhoneNo;
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

