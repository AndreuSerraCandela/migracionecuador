table 76220 "Micro empresario"
{
    Caption = 'Contact';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Captura Cantidad";
    LookupPageID = "Captura Cantidad";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[100])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(9; "Phone No."; Text[50])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(29; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(38; Comment; Boolean)
        {
            CalcFormula = Exist("Rlshp. Mgt. Comment Line" WHERE("Table Name" = CONST(Contact),
                                                                  "No." = FIELD("No."),
                                                                  "Sub No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
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
        field(92; County; Text[30])
        {
            Caption = 'State';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(5050; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Company,Person';
            OptionMembers = Company,Person;

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then begin
                    Modify;
                end;
            end;
        }
        field(5051; "Company No."; Code[20])
        {
            Caption = 'Company No.';
            TableRelation = Contact WHERE(Type = CONST(Company));

            trigger OnValidate()
            var
                Opp: Record Opportunity;
                OppEntry: Record "Opportunity Entry";
                Todo: Record "To-do";
                InteractLogEntry: Record "Interaction Log Entry";
                SegLine: Record "Segment Line";
                SalesHeader: Record "Sales Header";
                ChangeLogMgt: Codeunit "Change Log Management";
                RecRef: RecordRef;
                xRecRef: RecordRef;
            begin
            end;
        }
        field(5052; "Company Name"; Text[70])
        {
            Caption = 'Company Name';
            Editable = false;
        }
        field(5053; "Lookup Contact No."; Code[20])
        {
            Caption = 'Lookup Contact No.';
            Editable = false;
            TableRelation = Contact;
        }
        field(5054; "First Name"; Text[30])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                //Name := CalculatedName;
                //ProcessNameChange;
            end;
        }
        field(5055; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';

            trigger OnValidate()
            begin
                //Name := CalculatedName;
                //ProcessNameChange;
            end;
        }
        field(5056; Surname; Text[30])
        {
            Caption = 'Surname';

            trigger OnValidate()
            begin
                //Name := CalculatedName;
                //ProcessNameChange;
            end;
        }
        field(5058; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(5059; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(5060; "Extension No."; Text[30])
        {
            Caption = 'Extension No.';
        }
        field(5061; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(5062; Pager; Text[30])
        {
            Caption = 'Pager';
        }
        field(5063; "Organizational Level Code"; Code[10])
        {
            Caption = 'Organizational Level Code';
            TableRelation = "Organizational Level";
        }
        field(5064; "Exclude from Segment"; Boolean)
        {
            Caption = 'Exclude from Segment';
        }
        field(5073; "External ID"; Code[20])
        {
            Caption = 'External ID';
        }
        field(5100; "Correspondence Type"; Option)
        {
            Caption = 'Correspondence Type';
            OptionCaption = ' ,Hard Copy,E-Mail,Fax';
            OptionMembers = " ","Hard Copy","E-Mail",Fax;
        }
        field(5101; "Salutation Code"; Code[10])
        {
            Caption = 'Salutation Code';
            TableRelation = Salutation;
        }
        field(5104; "Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
        }
        field(5105; "E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
        }
        field(50000; "% Descuento Cupon"; Decimal)
        {
            Caption = 'Coupon Discount %';
        }
        field(56000; "Tipo de colegio"; Code[10])
        {
        }
        field(56001; "Nivel Escolar"; Code[10])
        {
        }
        field(56002; "Tipo educacion"; Code[10])
        {
        }
        field(56003; "Orden religiosa"; Code[10])
        {
        }
        field(56004; Bilingue; Boolean)
        {
        }
        field(56005; "Sistema educativo"; Code[10])
        {
        }
        field(56006; Plan; Code[10])
        {
        }
        field(56007; Turno; Code[10])
        {
        }
        field(56008; Gerencia; Code[10])
        {
        }
        field(56009; Delegado; Code[10])
        {
        }
        field(56010; Asesor; Code[10])
        {
        }
        field(56011; Ruta; Code[10])
        {
        }
        field(56012; "Canal de compra"; Code[10])
        {
        }
        field(56013; "Nombre canal"; Text[30])
        {
        }
        field(56015; Comisionista; Code[20])
        {
        }
        field(56016; "Fecha decision"; Date)
        {
        }
        field(56017; "Fecha lista"; Date)
        {
        }
        field(56018; Periodo; Code[10])
        {
        }
        field(56019; Grupo; Code[10])
        {
        }
        field(56020; "Tipo de texto"; Code[10])
        {
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
        key(Key3; "Company Name", "Company No.", Type, Name)
        {
        }
        key(Key4; "Company No.")
        {
        }
        key(Key5; "Territory Code")
        {
        }
        key(Key6; "Salesperson Code")
        {
        }
        key(Key7; "VAT Registration No.")
        {
        }
        key(Key8; Name)
        {
        }
        key(Key9; City)
        {
        }
        key(Key10; "Post Code")
        {
        }
        key(Key11; "Phone No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, Type, City, "Post Code", "Phone No.")
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
    end;

    trigger OnModify()
    begin
        //OnModify(xRec);
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
        RMSetup: Record "Marketing Setup";
        Cont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        PostCode: Record "Post Code";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        DuplMgt: Codeunit DuplicateManagement;
        ChangeLogMgt: Codeunit "Change Log Management";
        UpdateCustVendBank: Codeunit "CustVendBank-Update";
        CampaignMgt: Codeunit "Campaign Target Group Mgt";
        ContChanged: Boolean;
        SkipDefaults: Boolean;
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


    procedure OnModifyUPG(xRec: Record Contact)
    var
        OldCont: Record Contact;
    begin
    end;


    procedure AssistEdit(OldCont: Record "Productos Equivalentes"): Boolean
    begin
        /*WITH Cont DO BEGIN
          Cont := Rec;
          RMSetup.GET;
          RMSetup.TESTFIELD("Contact Nos.");
          IF NoSeriesMgt.SelectSeries(RMSetup."Contact Nos.",OldCont."No. Series","No. Series") THEN BEGIN
            RMSetup.GET;
            RMSetup.TESTFIELD("Contact Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Cont;
            EXIT(TRUE);
          END;
        END;
         */

    end;


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

