table 76066 Elegibles
{
    // Version       USERID    Fecha       Descripcion
    // //DSNOM1.01   GRN       25/12/2008  Modificaciones para manejar modulo de nominas

    Caption = 'Eligibles';
    DataCaptionFields = "No.", "First Name", "Last Name";
    DataPerCompany = false;
    DrillDownPageID = "Lista de elegibles";
    LookupPageID = "Lista de elegibles";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                Validate("Lugar nacimiento");
            end;
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';

            trigger OnValidate()
            begin
                Validate("Lugar nacimiento");
            end;
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                Validate("Lugar nacimiento");
            end;
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Initials)) or ("Search Name" = '') then
                    "Search Name" := Initials;
            end;
        }
        field(6; "Job Title"; Text[50])
        {
            Caption = 'Job Title';
        }
        field(7; "Search Name"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(8; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(10; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", true);
                //GRN PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", true);
                //GRN PostCode.ValidatePostCode(City,"Post Code");
            end;
        }
        field(12; County; Text[30])
        {
            Caption = 'State';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(19; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(21; "Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(22; Gender; Enum "Employee Gender")
        {
            Caption = 'Gender';
            //OptionCaption = ' ,Female,Male';
            //OptionMembers = " ",Female,Male;
        }
        field(23; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(24; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(Employee),
                                                                     "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(27; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(28; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(29; Extension; Text[30])
        {
            Caption = 'Extension';
        }
        field(30; "URL Linkedin"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "URL Facebook"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Company E-Mail"; Text[80])
        {
            Caption = 'Company E-Mail';
        }
        field(33; Title; Text[30])
        {
            Caption = 'Title';
        }
        field(34; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(35; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';

            trigger OnValidate()
            begin
                Validate("Lugar nacimiento");
            end;
        }
        field(36; "Full Name"; Text[50])
        {
            Caption = 'Full Name';

            trigger OnValidate()
            begin
                "Lugar nacimiento" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name" + ' ' + Nacionalidad;
            end;
        }
        field(37; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'SS,Passport,Residence ID,Work Permission';
            OptionMembers = "Cédula",Pasaporte,"Tarj. residencia","Permiso de Trabajo";
        }
        field(38; "Document ID"; Text[15])
        {
            Caption = 'Document ID';

            trigger OnValidate()
            begin
                Candidato.Reset;
                Candidato.SetFilter("No.", '<>%1', "No.");
                Candidato.SetRange("Document ID", "Document ID");
                if Candidato.FindFirst then
                    Error(StrSubstNo(Err003, FieldCaption("Document Type"), Candidato."No.", Candidato."Full Name"));
                /* 
                                if "Document Type" = "Document Type"::"Cédula" then
                                    if not FuncNominas.ValidarCedula(DelChr("Document ID", '=', '-')) then
                                        Error(StrSubstNo(Err004, "Document Type")); */
            end;
        }
        field(40; Nacionalidad; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(41; "Lugar nacimiento"; Text[30])
        {
        }
        field(42; "Estado civil"; Option)
        {
            Description = 'Soltero/a,Casado/a,Viudo/a,Separado/a,Divorciado/a';
            OptionMembers = "Soltero/a","Casado/a","Viudo/a","Separado/a","Divorciado/a";
        }
        field(44; "No. Seguridad Social"; Code[10])
        {
        }
        field(45; "Experiencia 1"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Experiencia 2"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(47; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Elegible,Descartado,Contratado';
            OptionMembers = Elegible,Descartado,Contratado;
        }
        field(76044; "Job Type Code"; Code[15])
        {
            Caption = 'Job type code';
            DataClassification = ToBeClassified;
            TableRelation = "Puestos laborales".Codigo;

            trigger OnValidate()
            var
                Contract: Record Contratos;
            begin

                Cargo.Reset;
                Cargo.SetRange(Codigo, "Job Type Code");
                if Cargo.FindFirst then begin
                    "Job Title" := Cargo.Descripcion;
                    //     "Cod. Supervisor" := Cargo."Cod. Supervisor";
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Last Name", "Phone No.")
        {
        }
    }

    trigger OnDelete()
    var
        Contrato: Record Contratos;
        PerfilSal: Record "Perfil Salarial";
        HistNom: Record "Historico Cab. nomina";
    begin
        AlternativeAddr.SetRange("Employee No.", "No.");
        AlternativeAddr.DeleteAll;

        EmployeeQualification.SetRange("Employee No.", "No.");
        EmployeeQualification.DeleteAll;

        Relative.SetRange("Employee No.", "No.");
        Relative.DeleteAll;

        MiscArticleInformation.SetRange("Employee No.", "No.");
        MiscArticleInformation.DeleteAll;

        ConfidentialInformation.SetRange("Employee No.", "No.");
        ConfidentialInformation.DeleteAll;

        HumanResComment.SetRange("No.", "No.");
        HumanResComment.DeleteAll;

        DimMgt.DeleteDefaultDim(DATABASE::Employee, "No.");
    end;

    trigger OnInsert()
    begin
        //Para cuando el numerador de empleados es comun a las empresas
        ConfNominas.Get();
        if (ConfNominas."Habilitar numeradores globales") and ("No." = '') then begin
            Numeradorescomunes.FindFirst;
            Numeradorescomunes.TestField("No. serie candidatos");
            "No." := IncStr(Numeradorescomunes."No. serie candidatos");
            Numeradorescomunes."No. serie candidatos" := "No.";
            Numeradorescomunes.Modify;
        end
        else
            if "No." = '' then begin
                HumanResSetup.Get;
                HumanResSetup.TestField("Candidate Nos.");
                //NoSeriesMgt.InitSeries(HumanResSetup."Candidate Nos.", xRec."No. Series", 0D, "No.", "No. Series");
                Rec."No. series" := HumanResSetup."Candidate Nos.";
                if NoSeriesMgt.AreRelated(HumanResSetup."Candidate Nos.", xRec."No. Series") then
                    Rec."No. Series" := xRec."No. Series";
                Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series");
            end;

        DimMgt.UpdateDefaultDim(
          DATABASE::Employee, "No.",
          "Global Dimension 1 Filter", "Global Dimension 2 Filter");
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Candidato: Record Elegibles;
        Cargo: Record "Puestos laborales";
        Res: Record Resource;
        PostCode: Record "Post Code";
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Confidential Information";
        HumanResComment: Record "Human Resource Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ConfNominas: Record "Configuracion nominas";
        Numeradorescomunes: Record "Numeradores globales";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Err001: Label 'This Account No. already exist for candidate %1';
        Err002: Label 'This employee has posted payroll, you can not delete it';
        /*     FuncNominas: Codeunit "Funciones Nomina"; */
        Err003: Label 'This %1 already exist for the candidate %2 %3';


    procedure AssistEdit(OldEmployee: Record Elegibles): Boolean
    begin
        /*
        WITH Employee DO BEGIN
          Employee := Rec;
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Candidate Nos.");
          IF NoSeriesMgt.SelectSeries(HumanResSetup."Candidate Nos.",OldEmployee."Telefono caso emergencia","Telefono caso emergencia") THEN
        BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Employee Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Employee;
            EXIT(TRUE);
          END;
        END;
        */
        Candidato := Rec;
        HumanResSetup.Get;
        HumanResSetup.TestField("Candidate Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(HumanResSetup."Candidate Nos.", OldEmployee."No. Series", Candidato."No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Employee Nos.");
            NoSeriesMgt.GetNextNo(Candidato."No.");
            Rec := Candidato;
            exit(true);
        end;

    end;


    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("First Name" + ' ' + "Last Name")
        else
            exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Employee, "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.Find('-') then
            MapMgt.SetupDefault
        else
            Message(Text000);
    end;
}

