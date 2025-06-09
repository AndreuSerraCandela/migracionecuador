table 76225 Padres
{
    DrillDownPageID = "Lista Padres";
    LookupPageID = "Lista Padres";

    fields
    {
        field(1; DNI; Code[20])
        {
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                Validate("Full name");
            end;
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';

            trigger OnValidate()
            begin
                Validate("Full name");
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Surname';

            trigger OnValidate()
            begin
                Validate("Full name");
            end;
        }
        field(5; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';

            trigger OnValidate()
            begin
                Validate("Full name");
            end;
        }
        field(6; Sex; Option)
        {
            OptionCaption = 'Female,Male';
            OptionMembers = Femenino,Masculino;
        }
        field(7; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(8; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(9; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(11; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(12; "Post Code"; Code[20])
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
        field(13; County; Text[30])
        {
            Caption = 'State';
        }
        field(14; "Home Phone No."; Text[50])
        {
            Caption = 'Home Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "Tipo documento"; Code[10])
        {
            TableRelation = "Tipos de documentos personales";
        }
        field(16; "Dia Nacimiento"; Integer)
        {
            MaxValue = 31;
            MinValue = 1;

            trigger OnValidate()
            begin
                if ("Dia Nacimiento" <> 0) and ("Mes Nacimiento" <> 0) and ("Ano Nacimiento" <> 0) then
                    "Fecha Nacimiento" := DMY2Date("Dia Nacimiento", "Mes Nacimiento", "Ano Nacimiento");
            end;
        }
        field(17; "Mes Nacimiento"; Integer)
        {
            MaxValue = 12;
            MinValue = 1;
        }
        field(18; "Ano Nacimiento"; Integer)
        {
        }
        field(19; "Home Page"; Text[150])
        {
            ExtendedDatatype = URL;
        }
        field(20; Twitter; Text[30])
        {
            ExtendedDatatype = URL;
        }
        field(21; Facebook; Text[150])
        {
            ExtendedDatatype = URL;
        }
        field(22; "BB Pin"; Code[10])
        {
        }
        field(23; "Cantidad Hijos INI"; Integer)
        {
        }
        field(24; "Cantidad Hijos PRI"; Integer)
        {
        }
        field(25; "Cantidad Hijos SEC"; Integer)
        {
        }
        field(26; "Areas de Interes"; Integer)
        {
            CalcFormula = Count("Areas de interes padres" WHERE("DNI Padre" = FIELD(DNI)));
            FieldClass = FlowField;
        }
        field(27; "Cant. Hijos"; Integer)
        {
            CalcFormula = Count("Alumnos - Hijos" WHERE("DNI Padre" = FIELD(DNI)));
            FieldClass = FlowField;
        }
        field(28; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(29; "E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
        }
        field(30; "Cell Phone No."; Text[50])
        {
            Caption = 'Cell Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(31; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
        }
        field(32; "Full name"; Text[150])
        {
            Caption = 'Full name';
            Editable = false;

            trigger OnValidate()
            begin
                "Full name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name" + ' ' + "Second Last Name";
            end;
        }
        field(33; "Grado INI"; Code[20])
        {
        }
        field(34; "Fecha Nacimiento"; Date)
        {
        }
        field(35; "Fecha creacion"; Date)
        {
        }
        field(36; "Ult. Fecha Actualizacion"; Date)
        {
        }
        field(37; "Grado PRI"; Code[20])
        {
        }
        field(38; "Grado SEC"; Code[20])
        {
        }
        field(39; Status; Option)
        {
            OptionCaption = ' ,Inactive';
            OptionMembers = " ",Inactivo;
        }
    }

    keys
    {
        key(Key1; DNI)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Fecha creacion" := Today;
    end;

    trigger OnModify()
    begin
        "Ult. Fecha Actualizacion" := Today;
    end;

    var
        PostCode: Record "Post Code";
        Col: Record Contact;
        Text033: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        DA: Record "Datos auxiliares";


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.Find('-') then
            MapMgt.MakeSelection(DATABASE::Contact, GetPosition)
        else
            Message(Text033);
    end;
}

