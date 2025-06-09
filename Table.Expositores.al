table 76191 Expositores
{
    Caption = 'Exponent';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = IF (Tipo = CONST (Interno)) Employee."No."
            ELSE
            IF (Tipo = CONST (Externo)) Vendor."No.";

            trigger OnValidate()
            begin
                if Tipo = 0 then begin
                    Emp.Get("No.");
                    Name := Emp."Full Name";
                    "Document ID" := Emp."Document ID";
                    Address := Emp.Address;
                    "Address 2" := Emp."Address 2";
                    City := Emp.City;
                    "Search Name" := Emp."Search Name";
                    "Mobile Phone No." := Emp."Mobile Phone No.";
                    "Country/Region Code" := Emp."Country/Region Code";
                    County := Emp.County;
                    "Phone No." := Emp."Phone No.";
                    "E-Mail" := Emp."E-Mail";
                    "E-Mail 2" := Emp."Company E-Mail";
                end
                else begin
                    Vend.Get("No.");
                    Name := Vend.Name;
                    "Document ID" := Vend."VAT Registration No.";
                    Address := Vend.Address;
                    "Address 2" := Vend."Address 2";
                    City := Vend.City;
                    "Search Name" := Vend."Search Name";
                    //"Mobile Phone No." := Emp."Mobile Phone No.";
                    "Country/Region Code" := Vend."Country/Region Code";
                    County := Vend.County;
                    "Phone No." := Vend."Phone No.";
                    "E-Mail" := Vend."E-Mail";

                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
            DataClassification = ToBeClassified;
        }
        field(4; "Name 2"; Text[100])
        {
            Caption = 'Name 2';
            DataClassification = ToBeClassified;
        }
        field(5; Address; Text[60])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(8; "Phone No."; Text[50])
        {
            Caption = 'Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            DataClassification = ToBeClassified;
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            DataClassification = ToBeClassified;
            TableRelation = Territory;
        }
        field(11; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = ToBeClassified;
            TableRelation = Language;
        }
        field(12; Tipo; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Internal,External';
            OptionMembers = Interno,Externo;
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(14; Comment; Boolean)
        {
            CalcFormula = Exist ("Rlshp. Mgt. Comment Line" WHERE ("Table Name" = CONST (Contact),
                                                                  "No." = FIELD ("No."),
                                                                  "Sub No." = CONST (0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = ToBeClassified;
        }
        field(18; "Document ID"; Code[20])
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(19; Picture; BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(20; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(21; County; Text[30])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(22; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(23; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(24; Twitter; Text[30])
        {
            Caption = 'Twitter';
            DataClassification = ToBeClassified;
        }
        field(25; Facebook; Text[80])
        {
            Caption = 'Facebook';
            DataClassification = ToBeClassified;
        }
        field(26; "E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(29; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(30; "Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost ($)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Document ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Emp: Record Employee;
        Vend: Record Vendor;
        PostCode: Record "Post Code";
}

