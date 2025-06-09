table 76086 "Alumnos - Hijos"
{
    DrillDownPageID = "Alumnos - Hijos";
    LookupPageID = "Alumnos - Hijos";

    fields
    {
        field(1; "DNI Padre"; Code[20])
        {
            NotBlank = true;
            TableRelation = Padres;

            trigger OnValidate()
            begin
                if "DNI Padre" <> '' then begin
                    Father.Get("DNI Padre");
                    if Confirm(Msg001, true) then begin
                        Address := Father.Address;
                        "Address 2" := Father."Address 2";
                        Validate(City, Father.City);
                        Validate("Post Code", Father."Post Code");
                        Validate(County, Father.County);
                    end;
                    "Nombre Padre" := Father."Second Last Name";
                end;
            end;
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(3; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(4; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(5; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(6; Surname; Text[30])
        {
            Caption = 'Surname';
        }
        field(7; "Nombre Padre"; Text[60])
        {
            Caption = 'Father''s name';
        }
        field(8; Sex; Option)
        {
            OptionCaption = 'Female,Male';
            OptionMembers = Femenino,Masculino;
        }
        field(9; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(10; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(11; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", true);
            end;
        }
        field(12; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(14; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(15; County; Text[30])
        {
            Caption = 'State';
        }
        field(16; "Home Phone No."; Text[50])
        {
            Caption = 'Home Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(17; "Born Date"; Date)
        {
        }
        field(18; "Home Page"; Text[150])
        {
        }
        field(19; Twitter; Text[30])
        {
        }
        field(20; Facebook; Text[150])
        {
        }
        field(21; "BB Pin"; Code[10])
        {
        }
        field(22; "Nombre Colegio"; Text[60])
        {
        }
        field(23; "Cell Phone No."; Text[50])
        {
            Caption = 'Cell Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(25; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
    }

    keys
    {
        key(Key1; "DNI Padre", "Cod. Colegio", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Father: Record Padres;
        PostCode: Record "Post Code";
        Msg001: Label 'Do you wish to copy the address from the father?';
        Text033: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.Find('-') then
            MapMgt.SetupDefault
        else
            Message(Text033);
    end;
}

