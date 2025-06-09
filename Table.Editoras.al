table 76219 Editoras
{
    DrillDownPageID = "Lista Editoras";
    LookupPageID = "Lista Editoras";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {

            trigger OnValidate()
            begin
                if "Search Name" = '' then
                    "Search Name" := Description;
            end;
        }
        field(3; "Search Name"; Code[100])
        {
        }
        field(4; Address; Text[60])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(6; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(7; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(8; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; County; Text[30])
        {
            Caption = 'State';
        }
        field(11; "Phone No."; Text[50])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Home Page"; Text[150])
        {
            ExtendedDatatype = URL;
        }
        field(13; Twitter; Text[30])
        {
            ExtendedDatatype = URL;
        }
        field(14; Facebook; Text[150])
        {
            ExtendedDatatype = URL;
        }
        field(15; Santillana; Boolean)
        {
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

    var
        PostCode: Record "Post Code";
}

