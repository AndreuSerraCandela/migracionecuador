table 76034 Docentes
{
    Caption = 'Teacher';
    DataCaptionFields = "No.", "Full Name";
    DrillDownPageID = "Lista de Docentes";
    LookupPageID = "Lista de Docentes";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    APSSetup.Get;
                    NoSeriesMgt.TestManual(APSSetup."No. Serie Profesores");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "No. 2"; Code[20])
        {
        }
        field(3; "Full Name"; Text[70])
        {
            Caption = 'Full Name';

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name" + ' ' + "Second Last Name";
            end;
        }
        field(4; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
        }
        field(5; "Name 2"; Text[100])
        {
            Caption = 'Name 2';
        }
        field(6; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(7; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Work No."; Text[30])
        {
            Caption = 'Telex No.';
        }
        field(11; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(12; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(13; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(14; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(15; Comment; Boolean)
        {
            CalcFormula = Exist("Rlshp. Mgt. Comment Line" WHERE("Table Name" = CONST(Contact),
                                                                  "No." = FIELD("No."),
                                                                  "Sub No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(17; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(18; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(19; "Document ID"; Text[20])
        {
            Caption = 'Document ID';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                if "Document ID" <> '' then begin
                    Docente.Reset;
                    Docente.SetFilter("No.", '<>%1', "No.");
                    Docente.SetRange("Tipo documento", "Tipo documento");
                    Docente.SetRange("Document ID", "Document ID");
                    if Docente.FindFirst then
                        Error(Text034, FieldCaption("Document ID"), "Document ID", TableCaption, Docente."No.");
                end;
            end;
        }
        field(20; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(21; "Post Code"; Code[20])
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
        field(22; County; Text[30])
        {
            Caption = 'State';
        }
        field(23; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(24; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(25; Twitter; Text[30])
        {
            ExtendedDatatype = URL;
        }
        field(26; Facebook; Text[80])
        {
            ExtendedDatatype = URL;
        }
        field(27; "BB Pin"; Text[10])
        {
        }
        field(28; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(29; "Job Title"; Text[60])
        {
            Caption = 'Job Title';
        }
        field(30; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(31; "Extension No."; Text[30])
        {
            Caption = 'Extension No.';
        }
        field(32; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(33; Pager; Text[30])
        {
            Caption = 'Pager';
        }
        field(34; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(35; "External ID"; Code[20])
        {
            Caption = 'External ID';
        }
        field(36; "Salesperson Filter"; Code[10])
        {
            Caption = 'Salesperson Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
        field(37; "Campaign Filter"; Code[20])
        {
            Caption = 'Campaign Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            TableRelation = Campaign;
        }
        field(38; "Action Taken Filter"; Option)
        {
            Caption = 'Action Taken Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            OptionCaption = ' ,Next,Previous,Updated,Jumped,Won,Lost';
            OptionMembers = " ",Next,Previous,Updated,Jumped,Won,Lost;
        }
        field(39; "Sales Cycle Filter"; Code[10])
        {
            Caption = 'Sales Cycle Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            TableRelation = "Sales Cycle";
        }
        field(40; "Sales Cycle Stage Filter"; Integer)
        {
            Caption = 'Sales Cycle Stage Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            TableRelation = "Sales Cycle Stage".Stage WHERE("Sales Cycle Code" = FIELD("Sales Cycle Filter"));
        }
        field(41; "To-do Status Filter"; Option)
        {
            Caption = 'To-do Status Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            OptionCaption = 'Not Started,In Progress,Completed,Waiting,Postponed';
            OptionMembers = "Not Started","In Progress",Completed,Waiting,Postponed;
        }
        field(42; "To-do Closed Filter"; Boolean)
        {
            Caption = 'To-do Closed Filter';
            Enabled = false;
            FieldClass = FlowFilter;
        }
        field(43; "Priority Filter"; Option)
        {
            Caption = 'Priority Filter';
            Enabled = false;
            FieldClass = FlowFilter;
            OptionCaption = 'Low,Normal,High';
            OptionMembers = Low,Normal,High;
        }
        field(44; "Customer no."; Code[20])
        {
            Caption = 'Customer No.';
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
        field(45; "Correspondence Type"; Option)
        {
            Caption = 'Correspondence Type';
            OptionCaption = ' ,Hard Copy,E-Mail,Fax';
            OptionMembers = " ","Hard Copy","E-Mail",Fax;
        }
        field(46; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
        }
        field(47; "Search E-Mail"; Code[100])
        {
            Caption = 'Search E-Mail';
        }
        field(48; "Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
        }
        field(49; "E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
        }
        field(50; "% Descuento Cupon"; Decimal)
        {
            Caption = 'Coupon Discount %';
        }
        field(51; "Tipo de colegio"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Tipos de colegios"));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Tipos de colegios");
                if "Tipo de colegio" <> '' then
                    DA.SetRange(Codigo, "Tipo de colegio");

                DA.FindFirst;
            end;
        }
        field(52; "Nivel Escolar"; Code[10])
        {
        }
        field(53; "Tipo educacion"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Tipo de educacion"));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Tipo de educacion");
                if "Tipo de colegio" <> '' then
                    DA.SetRange(Codigo, "Tipo de colegio");

                DA.FindFirst;
            end;
        }
        field(54; "Orden religiosa"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Orden religiosa"));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Orden religiosa");
                if "Orden religiosa" <> '' then
                    DA.SetRange(Codigo, "Orden religiosa");

                DA.FindFirst;
            end;
        }
        field(55; Bilingue; Boolean)
        {
        }
        field(56; "Sistema educativo"; Code[10])
        {
        }
        field(57; Plan; Code[10])
        {
        }
        field(58; Sexo; Option)
        {
            Caption = 'Sex';
            OptionCaption = 'Female,Male';
            OptionMembers = Femenino,Masculino;
        }
        field(59; "Nivel Docente"; Code[20])
        {
            Caption = 'Teacher''s level';
            TableRelation = "Nivel Educativo APS";
        }
        field(60; "Usuario Lectores en red"; Boolean)
        {
        }
        field(61; "Recibe correos"; Boolean)
        {
        }
        field(62; "Recibe llamadas"; Boolean)
        {
        }
        field(63; "Recibe email"; Boolean)
        {
        }
        field(64; Jubilado; Boolean)
        {
        }
        field(65; "Dia Nacimiento"; Integer)
        {
            MaxValue = 31;
            MinValue = 1;
        }
        field(66; "Job Type Code"; Code[20])
        {
            Caption = 'Job Type Code';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Puestos de trabajo"));

            trigger OnValidate()
            begin
                if "Job Type Code" <> '' then begin
                    JobType.SetRange("Tipo registro", JobType."Tipo registro"::"Puestos de trabajo");
                    JobType.SetRange(Codigo, "Job Type Code");
                    JobType.FindFirst;
                    "Job Title" := JobType.Descripcion;
                end;
            end;
        }
        field(67; "Pertenece al CDS"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Pertenece al CDS" then
                    "Ult. fecha activacion" := Today;
            end;
        }
        field(68; "Mes Nacimiento"; Integer)
        {
            MaxValue = 12;
            MinValue = 1;
        }
        field(69; "Ano Nacimiento"; Integer)
        {
            Caption = 'Born year';
            MaxValue = 2450;
            MinValue = 1950;
        }
        field(70; "Ano inscripcion CDS"; Code[4])
        {
            Caption = 'Subscription year CDS';
            Numeric = true;
        }
        field(71; "Cod. CDS"; Code[20])
        {
        }
        field(76; Hijos; Boolean)
        {
        }
        field(77; "Frecuencia uso email"; Option)
        {
            OptionMembers = Diario,"Fines de semana","Menos de una vez por semana";
        }
        field(78; "Nivel decision"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Nivel de decisión"));

            trigger OnValidate()
            begin
                if "Nivel decision" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Nivel de decisión");
                    DA.SetRange(Codigo, "Nivel decision");
                    DA.FindFirst;
                end;
            end;
        }
        field(79; "Envio correspondencia"; Option)
        {
            OptionCaption = 'School,Self';
            OptionMembers = Colegio,Particular;
        }
        field(80; "Situacion general"; Option)
        {
            OptionCaption = 'Active,Inactive';
            OptionMembers = Activo,Inactivo;
        }
        field(81; "Tipo documento"; Code[20])
        {
            TableRelation = "Tipos de documentos personales";
        }
        field(82; "Tipo de contacto"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Tipos de contactos"));

            trigger OnValidate()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Tipos de contactos");
                DA.SetRange(Codigo, "Tipo de contacto");
                if DA.FindFirst then
                    "Desc Tipo de contacto" := DA.Descripcion;
            end;
        }
        field(83; "Ult. fecha activacion"; Date)
        {
        }
        field(84; "Se entrego carne"; Boolean)
        {
            Caption = 'Carnet delivered';
        }
        field(85; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(86; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(87; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(88; "Second Last Name"; Text[30])
        {
            Caption = 'Second Last Name';

            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(89; Status; Option)
        {
            OptionCaption = ' ,Inactive';
            OptionMembers = " ",Inactivo;
        }
        field(90; "Desc Tipo de contacto"; Text[60])
        {
            Caption = 'Type of contact description';
            Editable = false;
        }
        field(91; "Referencia Direccion"; Text[100])
        {
        }
        field(92; "Cod. Proveedor"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if "Cod. Proveedor" <> '' then begin
                    Vend.Get("Cod. Proveedor");
                    "Document ID" := Vend."VAT Registration No.";
                    "Full Name" := Vend.Name;
                    Address := Vend.Address;
                    "Address 2" := Vend."Address 2";
                    City := Vend.City;
                    "Phone No." := Vend."Phone No.";
                    //    "Work No." := vend."Work No.";
                    "Territory Code" := Vend."Territory Code";
                    "Language Code" := Vend."Language Code";
                    "Country/Region Code" := Vend."Country/Region Code";
                    "Post Code" := Vend."Post Code";
                    County := Vend.County;
                    "E-Mail" := Vend."E-Mail";
                    "Home Page" := Vend."Home Page";
                    //    "Extension No." := vend."Extension No.";
                    //    "Mobile Phone No." := vend."Mobile Phone No.";
                    /*
                    VALIDATE("Distrito Code",Vend."Distrito Code");
                    VALIDATE(Departamento,Vend.Departamento);
                    VALIDATE(Distritos,Distritos);
                    VALIDATE(Provincia,Vend.Provincia);
                    */
                end;

            end;
        }
        field(93; "Cod. Cliente"; Code[20])
        {
            TableRelation = Customer;
        }
        field(94; Expositor; Boolean)
        {
        }
        field(95; "Usuario creación"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Full Name")
        {
        }
        key(Key3; Initials, "Job Title", "No. 2")
        {
        }
        key(Key4; "Document ID")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Full Name", "Document ID", "Pertenece al CDS")
        {
        }
    }

    trigger OnDelete()
    var
        Todo: Record "To-do";
        SegLine: Record "Segment Line";
        ContIndustGrp: Record "Contact Industry Group";
        ContactWebSource: Record "Contact Web Source";
        ContJobResp: Record "Contact Job Responsibility";
        ContMailingGrp: Record "Contact Mailing Group";
        ContProfileAnswer: Record "Contact Profile Answer";
        RMCommentLine: Record "Rlshp. Mgt. Comment Line";
        ContAltAddr: Record "Contact Alt. Address";
        ContAltAddrDateRange: Record "Contact Alt. Addr. Date Range";
        InteractLogEntry: Record "Interaction Log Entry";
        Opp: Record Opportunity;
        CampaignTargetGrMgt: Codeunit "Campaign Target Group Mgt";
    begin
        //CreditCards.DeleteByContact(Rec);
        ColDoc.SetRange("Cod. Docente", "No.");
        if ColDoc.FindFirst then
            Error(StrSubstNo(Text035, ColDoc.TableCaption));
    end;

    trigger OnInsert()
    begin
        APSSetup.Get;
        if "No." = '' then begin
            APSSetup.TestField("No. Serie Profesores");
            //NoSeriesMgt.InitSeries(APSSetup."No. Serie Profesores", xRec."No. Series", 0D, "No.", "No. Series");
            Rec."No. series" := APSSetup."No. Serie Profesores";
            if NoSeriesMgt.AreRelated(APSSetup."No. Serie Profesores", xRec."No. Series") then
                Rec."No. Series" := xRec."No. Series";
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series");
        end;
        "Ano inscripcion CDS" := Format(APSSetup.Campana);

        "Usuario creación" := UserId;
    end;

    trigger OnModify()
    begin
        ColDocente.Reset;
        ColDocente.SetRange("Cod. Docente", "No.");
        if ColDocente.FindSet(true) then
            repeat
                ColDocente."Nombre docente" := "Full Name";
                ColDocente."Apellido paterno" := "Last Name";
                ColDocente."Pertenece al CDS" := "Pertenece al CDS";
                ColDocente.Modify;
            until ColDocente.Next = 0;
    end;

    var
        Text000: Label 'You cannot delete the %2 record of the %1 because there are one or more to-dos open.';
        Text001: Label 'You cannot delete the %2 record of the %1 because the contact is assigned one or more unlogged segments.';
        Text002: Label 'You cannot delete the %2 record of the %1 because one or more opportunities are in not started or progress.';
        Text003: Label '%1 cannot be changed because one or more interaction log entries are linked to the contact.';
        Text005: Label '%1 cannot be changed because one or more to-dos are linked to the contact.';
        Text006: Label '%1 cannot be changed because one or more opportunities are linked to the contact.';
        Text007: Label '%1 cannot be changed because there are one or more related people linked to the contact.';
        Text009: Label 'The %2 record of the %1 has been created.';
        Text010: Label 'The %2 record of the %1 is not linked with any other table.';
        APSSetup: Record "Commercial Setup";
        Docente: Record Docentes;
        JobType: Record "Datos auxiliares";
        PostCode: Record "Post Code";
        ColDoc: Record "Colegio - Docentes";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        NoSeriesMgt: Codeunit "No. Series";
        ChangeLogMgt: Codeunit "Change Log Management";
        Text012: Label 'You cannot change %1 because one or more unlogged segments are assigned to the contact.';
        Text019: Label 'The %2 record of the %1 already has the %3 with %4 %5.';
        Text020: Label 'Do you want to create a contact %1 %2 as a customer using a customer template?';
        Text021: Label 'You have to set up formal and informal salutation formulas in %1  language for the %2 contact.';
        HideValidationDialog: Boolean;
        Text022: Label 'The creation of the customer has been aborted.';
        Text029: Label 'The total length of first name, middle name and surname is %1 character(s)longer than the maximum length allowed for the Name field.';
        Text032: Label 'The length of %1 is %2 character(s)longer than the maximum length allowed for the %1 field.';
        Text033: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        rRec: RecordRef;
        DA: Record "Datos auxiliares";
        Text034: Label 'There is al ready a %1 %2 associated with %3 %4';
        territory: Record Territory;
        PostCodeRec: Record "Post Code";
        PostCodeForm: Page "Post Codes";
        formTerritory: Page Territories;
        RECcOUNTRY: Record "Country/Region";
        ColDocente: Record "Colegio - Docentes";
        Text035: Label 'There are records associated with this Teacher, review them in %1';


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.Find('-') then
            MapMgt.MakeSelection(DATABASE::Docentes, GetPosition)
        else
            Message(Text033);
    end;


    procedure AssistEdit(OldCont: Record Docentes): Boolean
    begin
        Docente := Rec;
        APSSetup.Get;
        APSSetup.TestField("No. Serie Profesores");
        if NoSeriesMgt.LookupRelatedNoSeries(APSSetup."No. Serie Profesores", OldCont."No. Series", "No. Series") then begin
            APSSetup.Get;
            APSSetup.TestField("No. Serie Profesores");
            NoSeriesMgt.GetNextNo("No.");
            Rec := Docente;
            exit(true);
        end;
    end;


    procedure GetApellidosNombre(): Text[250]
    begin
        exit("Last Name" + ' ' + "Second Last Name" + ', ' + "First Name" + ' ' + "Middle Name");
    end;
}

