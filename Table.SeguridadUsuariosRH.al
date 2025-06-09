table 76414 "Seguridad Usuarios RH"
{
    Caption = 'HR User permission';
    DrillDownPageID = "Seguridad Usuarios RH";
    LookupPageID = "Seguridad Usuarios RH";

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = User."User Name";

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                if User.Get("User ID") then
                    "Full name" := User."Full Name"
                else
                    "Full name" := '';
            end;
        }
        field(2; "Full name"; Text[60])
        {
            Caption = 'Full name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Revisado por"; Boolean)
        {
            Caption = 'Alloow Reviewed by';
        }
        field(4; "Autorizado por"; Boolean)
        {
            Caption = 'Allow Authorized by';
        }
        field(7; "E-Mail"; Text[100])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(8; "Visualiza salario"; Boolean)
        {
            Caption = 'Salary visible';
            DataClassification = ToBeClassified;
        }
        field(9; "Visualiza Calc. Nomina"; Boolean)
        {
            Caption = 'Calc payroll visible';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "User ID", "Full name")
        {
        }
    }

    var
        User: Record User;
}

