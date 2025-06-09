table 76209 "Expositores APS"
{
    Caption = 'Contact';
    DataCaptionFields = "No.", Name;
    DrillDownPageID = "Lista expositores";
    LookupPageID = "Lista expositores";

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
        field(5; Address; Text[60])
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
        field(8; "Phone No."; Text[50])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(10; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(11; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(12; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(14; Comment; Boolean)
        {
            CalcFormula = Exist("Rlshp. Mgt. Comment Line" WHERE("Table Name" = CONST(Contact),
                                                                  "No." = FIELD("No."),
                                                                  "Sub No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(16; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(17; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(18; "Document ID"; Code[20])
        {
            Caption = 'Document ID';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(19; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(20; "Post Code"; Code[20])
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
        field(21; County; Text[30])
        {
            Caption = 'State';
        }
        field(22; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(23; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(24; Twitter; Text[30])
        {
        }
        field(25; Facebook; Text[80])
        {
        }
        field(26; "BB Pin"; Text[10])
        {
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(28; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
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
            Editable = false;
        }
        field(31; "E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
        }
        field(32; "Se entrego carne"; Boolean)
        {
            Caption = 'Carnet delivered';
        }
        field(33; "Pertenece al CDS"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Pertenece al CDS" then
                    "Ult. fecha activacion" := Today;
            end;
        }
        field(34; "Ano inscripcion CDS"; Code[4])
        {
            Caption = 'Subscription year CDS';
            Numeric = true;
        }
        field(35; "Ult. fecha activacion"; Date)
        {
        }
        field(36; "Eventos Planif. Pendiente Pago"; Integer)
        {
            CalcFormula = Count("Cab. Planif. Evento" WHERE(Pagado = CONST(false),
                                                             Expositor = FIELD("No."),
                                                             Estado = FILTER(<> Anulado)));
            FieldClass = FlowField;

            trigger OnLookup()
            var
                pgCabPlanif: Page "Estado Pago Expo. Eve. Planif.";
                rCabPlanif: Record "Cab. Planif. Evento";
            begin

                rCabPlanif.SetRange(rCabPlanif.Expositor, "No.");
                rCabPlanif.SetRange(rCabPlanif.Pagado, false);
                pgCabPlanif.SetTableView(rCabPlanif);
                pgCabPlanif.Editable(false);
                pgCabPlanif.LookupMode(true);
                pgCabPlanif.Run;
            end;
        }
        field(37; "Eventos Planif. Pagados"; Integer)
        {
            CalcFormula = Count("Cab. Planif. Evento" WHERE(Pagado = CONST(true),
                                                             Expositor = FIELD("No."),
                                                             Estado = FILTER(<> Anulado)));
            FieldClass = FlowField;

            trigger OnLookup()
            var
                pgCabPlanif: Page "Estado Pago Expo. Eve. Planif.";
                rCabPlanif: Record "Cab. Planif. Evento";
            begin
                rCabPlanif.SetRange(rCabPlanif.Expositor, "No.");
                rCabPlanif.SetRange(rCabPlanif.Pagado, true);
                pgCabPlanif.SetTableView(rCabPlanif);
                pgCabPlanif.Editable(false);
                pgCabPlanif.LookupMode(true);
                pgCabPlanif.Run;
            end;
        }
        field(38; "Tiene Eventos Planif"; Boolean)
        {
            CalcFormula = Exist("Cab. Planif. Evento" WHERE(Expositor = FIELD("No."),
                                                             Estado = FILTER(<> Anulado)));
            FieldClass = FlowField;
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
        fieldgroup(DropDown; "No.", Name, City, "Document ID")
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
        Cont: Record "Commercial Setup";
        ContBusRel: Record "Contact Business Relation";
        PostCode: Record "Post Code";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "Change Log Management";
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
}

