table 76141 Comisionistas
{
    Caption = 'Contact';
    DataCaptionFields = "No.", Name;
    LookupPageID = "Contact List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    RMSetup.Get;
                    NoSeriesMgt.TestManual(RMSetup."Contact Nos.");
                    "No. Series" := '';
                end;
            end;
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
                if "Company No." = xRec."Company No." then
                    exit;

                xRecRef.GetTable(Rec);

                TestField(Type, Type::Person);

                SegLine.SetCurrentKey("Contact No.");
                SegLine.SetRange("Contact No.", "No.");
                if SegLine.Find('-') then
                    Error(Text012, FieldCaption("Company No."));

                /*
                IF Cont.GET("Company No.") THEN
                  InheritCompanyToPersonData(Cont,xRec."Company No." = '')
                ELSE
                  CLEAR("Company Name");
                
                IF Cont.GET("No.") THEN BEGIN
                  IF xRec."Company No." <> '' THEN BEGIN
                    Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Opp.SETRANGE("Contact Company No.",xRec."Company No.");
                    Opp.SETRANGE("Contact No.","No.");
                    Opp.MODIFYALL("Contact No.",xRec."Company No.");
                    OppEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    OppEntry.SETRANGE("Contact Company No.",xRec."Company No.");
                    OppEntry.SETRANGE("Contact No.","No.");
                    OppEntry.MODIFYALL("Contact No.",xRec."Company No.");
                    Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Todo.SETRANGE("Contact Company No.",xRec."Company No.");
                    Todo.SETRANGE("Contact No.","No.");
                    Todo.MODIFYALL("Contact No.",xRec."Company No.");
                    InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    InteractLogEntry.SETRANGE("Contact Company No.",xRec."Company No.");
                    InteractLogEntry.SETRANGE("Contact No.","No.");
                    InteractLogEntry.MODIFYALL("Contact No.",xRec."Company No.");
                    ContBusRel.RESET;
                    ContBusRel.SETCURRENTKEY("Link to Table","No.");
                    ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                    ContBusRel.SETRANGE("Contact No.",xRec."Company No.");
                    SalesHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
                    SalesHeader.SETRANGE("Sell-to Contact No.","No.");
                    IF ContBusRel.FIND('-') THEN
                      SalesHeader.SETRANGE("Sell-to Customer No.",ContBusRel."No.")
                    ELSE
                      SalesHeader.SETRANGE("Sell-to Customer No.",'');
                    IF SalesHeader.FIND('-') THEN
                      REPEAT
                        SalesHeader."Sell-to Contact No." := xRec."Company No.";
                        IF SalesHeader."Sell-to Contact No." = SalesHeader."Bill-to Contact No." THEN
                          SalesHeader."Bill-to Contact No." := xRec."Company No.";
                        SalesHeader.MODIFY;
                      UNTIL SalesHeader.NEXT = 0;
                    SalesHeader.RESET;
                    SalesHeader.SETCURRENTKEY("Bill-to Contact No.");
                    SalesHeader.SETRANGE("Bill-to Contact No.","No.");
                    SalesHeader.MODIFYALL("Bill-to Contact No.",xRec."Company No.");
                  END ELSE BEGIN
                    Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Opp.SETRANGE("Contact Company No.",'');
                    Opp.SETRANGE("Contact No.","No.");
                    Opp.MODIFYALL("Contact Company No.","Company No.");
                    OppEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    OppEntry.SETRANGE("Contact Company No.",'');
                    OppEntry.SETRANGE("Contact No.","No.");
                    OppEntry.MODIFYALL("Contact Company No.","Company No.");
                    Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Todo.SETRANGE("Contact Company No.",'');
                    Todo.SETRANGE("Contact No.","No.");
                    Todo.MODIFYALL("Contact Company No.","Company No.");
                    InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    InteractLogEntry.SETRANGE("Contact Company No.",'');
                    InteractLogEntry.SETRANGE("Contact No.","No.");
                    InteractLogEntry.MODIFYALL("Contact Company No.","Company No.");
                  END;
                  IF CurrFieldNo <> 0 THEN BEGIN
                    MODIFY;
                    RecRef.GETTABLE(Rec);
                    ChangeLogMgt.LogModification(RecRef,xRecRef);
                  END;
                END;
                */

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

            trigger OnValidate()
            begin
                if Type = Type::Company then
                    "Lookup Contact No." := ''
                else
                    "Lookup Contact No." := "No.";
            end;
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
        field(5065; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5066; "Next To-do Date"; Date)
        {
            CalcFormula = Min("To-do".Date WHERE("Contact Company No." = FIELD("Company No."),
                                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                  Closed = CONST(false),
                                                  "System To-do Type" = CONST("Contact Attendee")));
            Caption = 'Next To-do Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5067; "Last Date Attempted"; Date)
        {
            CalcFormula = Max("Interaction Log Entry".Date WHERE("Contact Company No." = FIELD("Company No."),
                                                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                  "Initiated By" = CONST(Us),
                                                                  Postponed = CONST(false)));
            Caption = 'Last Date Attempted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5068; "Date of Last Interaction"; Date)
        {
            CalcFormula = Max("Interaction Log Entry".Date WHERE("Contact Company No." = FIELD("Company No."),
                                                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                  "Attempt Failed" = CONST(false),
                                                                  Postponed = CONST(false)));
            Caption = 'Date of Last Interaction';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5069; "No. of Job Responsibilities"; Integer)
        {
            CalcFormula = Count("Contact Job Responsibility" WHERE("Contact No." = FIELD("No.")));
            Caption = 'No. of Job Responsibilities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5070; "No. of Industry Groups"; Integer)
        {
            CalcFormula = Count("Contact Industry Group" WHERE("Contact No." = FIELD("Company No.")));
            Caption = 'No. of Industry Groups';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5071; "No. of Business Relations"; Integer)
        {
            CalcFormula = Count("Contact Business Relation" WHERE("Contact No." = FIELD("Company No.")));
            Caption = 'No. of Business Relations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5072; "No. of Mailing Groups"; Integer)
        {
            CalcFormula = Count("Contact Mailing Group" WHERE("Contact No." = FIELD("No.")));
            Caption = 'No. of Mailing Groups';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5073; "External ID"; Code[20])
        {
            Caption = 'External ID';
        }
        field(5074; "No. of Interactions"; Integer)
        {
            CalcFormula = Count("Interaction Log Entry" WHERE("Contact Company No." = FIELD("Company No."),
                                                               Canceled = CONST(false),
                                                               "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                               Date = FIELD("Date Filter"),
                                                               Postponed = CONST(false)));
            Caption = 'No. of Interactions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5076; "Cost (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Interaction Log Entry"."Cost (LCY)" WHERE("Contact Company No." = FIELD("Company No."),
                                                                          Canceled = CONST(false),
                                                                          "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                          Date = FIELD("Date Filter"),
                                                                          Postponed = CONST(false)));
            Caption = 'Cost ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5077; "Duration (Min.)"; Decimal)
        {
            CalcFormula = Sum("Interaction Log Entry"."Duration (Min.)" WHERE("Contact Company No." = FIELD("Company No."),
                                                                               Canceled = CONST(false),
                                                                               "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                               Date = FIELD("Date Filter"),
                                                                               Postponed = CONST(false)));
            Caption = 'Duration (Min.)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5078; "No. of Opportunities"; Integer)
        {
            CalcFormula = Count("Opportunity Entry" WHERE(Active = CONST(true),
                                                           "Contact Company No." = FIELD("Company No."),
                                                           "Estimated Close Date" = FIELD("Date Filter"),
                                                           "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                           "Action Taken" = FIELD("Action Taken Filter")));
            Caption = 'No. of Opportunities';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5079; "Estimated Value (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Opportunity Entry"."Estimated Value (LCY)" WHERE(Active = CONST(true),
                                                                                 "Contact Company No." = FIELD("Company No."),
                                                                                 "Estimated Close Date" = FIELD("Date Filter"),
                                                                                 "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                                 "Action Taken" = FIELD("Action Taken Filter")));
            Caption = 'Estimated Value ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5080; "Calcd. Current Value (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Opportunity Entry"."Calcd. Current Value (LCY)" WHERE(Active = CONST(true),
                                                                                      "Contact Company No." = FIELD("Company No."),
                                                                                      "Estimated Close Date" = FIELD("Date Filter"),
                                                                                      "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                                                      "Action Taken" = FIELD("Action Taken Filter")));
            Caption = 'Calcd. Current Value ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5082; "Opportunity Entry Exists"; Boolean)
        {
            CalcFormula = Exist("Opportunity Entry" WHERE(Active = CONST(true),
                                                           "Contact Company No." = FIELD("Company No."),
                                                           "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                                           "Sales Cycle Code" = FIELD("Sales Cycle Filter"),
                                                           "Sales Cycle Stage" = FIELD("Sales Cycle Stage Filter"),
                                                           "Salesperson Code" = FIELD("Salesperson Filter"),
                                                           "Campaign No." = FIELD("Campaign Filter"),
                                                           "Action Taken" = FIELD("Action Taken Filter"),
                                                           "Estimated Value (LCY)" = FIELD("Estimated Value Filter"),
                                                           "Calcd. Current Value (LCY)" = FIELD("Calcd. Current Value Filter"),
                                                           "Completed %" = FIELD("Completed % Filter"),
                                                           "Chances of Success %" = FIELD("Chances of Success % Filter"),
                                                           "Probability %" = FIELD("Probability % Filter"),
                                                           "Estimated Close Date" = FIELD("Date Filter"),
                                                           "Close Opportunity Code" = FIELD("Close Opportunity Filter")));
            Caption = 'Opportunity Entry Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5083; "To-do Entry Exists"; Boolean)
        {
            CalcFormula = Exist("To-do" WHERE("Contact Company No." = FIELD("Company No."),
                                               "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                               "Team Code" = FIELD("Team Filter"),
                                               "Salesperson Code" = FIELD("Salesperson Filter"),
                                               "Campaign No." = FIELD("Campaign Filter"),
                                               Date = FIELD("Date Filter"),
                                               Status = FIELD("To-do Status Filter"),
                                               Priority = FIELD("Priority Filter"),
                                               Closed = FIELD("To-do Closed Filter")));
            Caption = 'To-do Entry Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5084; "Salesperson Filter"; Code[10])
        {
            Caption = 'Salesperson Filter';
            FieldClass = FlowFilter;
            TableRelation = "Salesperson/Purchaser";
        }
        field(5085; "Campaign Filter"; Code[20])
        {
            Caption = 'Campaign Filter';
            FieldClass = FlowFilter;
            TableRelation = Campaign;
        }
        field(5087; "Action Taken Filter"; Option)
        {
            Caption = 'Action Taken Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Next,Previous,Updated,Jumped,Won,Lost';
            OptionMembers = " ",Next,Previous,Updated,Jumped,Won,Lost;
        }
        field(5088; "Sales Cycle Filter"; Code[10])
        {
            Caption = 'Sales Cycle Filter';
            FieldClass = FlowFilter;
            TableRelation = "Sales Cycle";
        }
        field(5089; "Sales Cycle Stage Filter"; Integer)
        {
            Caption = 'Sales Cycle Stage Filter';
            FieldClass = FlowFilter;
            TableRelation = "Sales Cycle Stage".Stage WHERE("Sales Cycle Code" = FIELD("Sales Cycle Filter"));
        }
        field(5090; "Probability % Filter"; Decimal)
        {
            Caption = 'Probability % Filter';
            DecimalPlaces = 1 : 1;
            FieldClass = FlowFilter;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5091; "Completed % Filter"; Decimal)
        {
            Caption = 'Completed % Filter';
            DecimalPlaces = 1 : 1;
            FieldClass = FlowFilter;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5092; "Estimated Value Filter"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Estimated Value Filter';
            FieldClass = FlowFilter;
        }
        field(5093; "Calcd. Current Value Filter"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Calcd. Current Value Filter';
            FieldClass = FlowFilter;
        }
        field(5094; "Chances of Success % Filter"; Decimal)
        {
            Caption = 'Chances of Success % Filter';
            DecimalPlaces = 0 : 0;
            FieldClass = FlowFilter;
            MaxValue = 100;
            MinValue = 0;
        }
        field(5095; "To-do Status Filter"; Enum "Task Status")
        {
            Caption = 'To-do Status Filter';
            FieldClass = FlowFilter;
            //OptionCaption = 'Not Started,In Progress,Completed,Waiting,Postponed';
            //OptionMembers = "Not Started","In Progress",Completed,Waiting,Postponed;
        }
        field(5096; "To-do Closed Filter"; Boolean)
        {
            Caption = 'To-do Closed Filter';
            FieldClass = FlowFilter;
        }
        field(5097; "Priority Filter"; Option)
        {
            Caption = 'Priority Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Low,Normal,High';
            OptionMembers = Low,Normal,High;
        }
        field(5098; "Team Filter"; Code[10])
        {
            Caption = 'Team Filter';
            FieldClass = FlowFilter;
            TableRelation = Team;
        }
        field(5099; "Close Opportunity Filter"; Code[10])
        {
            Caption = 'Close Opportunity Filter';
            FieldClass = FlowFilter;
            TableRelation = "Close Opportunity Code";
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
        field(5102; "Search E-Mail"; Code[80])
        {
            Caption = 'Search E-Mail';
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
        field(56014; Microempresario; Code[20])
        {
            TableRelation = "Cab. Identificación Devolución";
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
        key(Key8; "Search E-Mail")
        {
        }
        key(Key9; Name)
        {
        }
        key(Key10; City)
        {
        }
        key(Key11; "Post Code")
        {
        }
        key(Key12; "Phone No.")
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
        /*
        CreditCards.DeleteByContact(Rec);
        
        Todo.SETCURRENTKEY("Contact Company No.","Contact No.",Closed,Date);
        Todo.SETRANGE("Contact Company No.","Company No.");
        Todo.SETRANGE("Contact No.","No.");
        Todo.SETRANGE(Closed,FALSE);
        IF Todo.FIND('-') THEN
          ERROR(Text000,TABLECAPTION,"No.");
        
        SegLine.SETCURRENTKEY("Contact No.");
        SegLine.SETRANGE("Contact No.","No.");
        IF SegLine.FIND('-') THEN
          ERROR(Text001,TABLECAPTION,"No.");
        
        Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
        Opp.SETRANGE("Contact Company No.","Company No.");
        Opp.SETRANGE("Contact No.","No.");
        Opp.SETRANGE(Status,Opp.Status::"Not Started",Opp.Status::"In Progress");
        IF Opp.FIND('-') THEN
          ERROR(Text002,TABLECAPTION,"No.");
        
        CASE Type OF
          Type::Company: BEGIN
            ContBusRel.SETRANGE("Contact No.","No.");
            ContBusRel.DELETEALL;
            ContIndustGrp.SETRANGE("Contact No.","No.");
            ContIndustGrp.DELETEALL;
            ContactWebSource.SETRANGE("Contact No.","No.");
            ContactWebSource.DELETEALL;
            DuplMgt.RemoveContIndex(Rec,FALSE);
            InteractLogEntry.SETCURRENTKEY("Contact Company No.");
            InteractLogEntry.SETRANGE("Contact Company No.", "No.");
            IF InteractLogEntry.FIND('-') THEN
              REPEAT
                CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
                CLEAR(InteractLogEntry."Contact Company No.");
                CLEAR(InteractLogEntry."Contact No.");
                InteractLogEntry.MODIFY;
              UNTIL InteractLogEntry.NEXT = 0;
        
            Cont.RESET;
            Cont.SETCURRENTKEY("Company No.");
            Cont.SETRANGE("Company No.","No.");
            Cont.SETRANGE(Type,Type::Person);
            IF Cont.FIND('-') THEN
              REPEAT
                RecRef.GETTABLE(Cont);
                Cont.DELETE(TRUE);
                ChangeLogMgt.LogDeletion(RecRef);
              UNTIL Cont.NEXT = 0;
        
            Opp.RESET;
            Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
            Opp.SETRANGE("Contact Company No.","Company No.");
            Opp.SETRANGE("Contact No.","No.");
            IF Opp.FIND('-') THEN
              REPEAT
                CLEAR(Opp."Contact No.");
                CLEAR(Opp."Contact Company No.");
                Opp.MODIFY;
              UNTIL Opp.NEXT = 0;
        
            Todo.RESET;
            Todo.SETCURRENTKEY("Contact Company No.");
            Todo.SETRANGE("Contact Company No.","Company No.");
            IF Todo.FIND('-') THEN
              REPEAT
                CLEAR(Todo."Contact No.");
                CLEAR(Todo."Contact Company No.");
                Todo.MODIFY;
              UNTIL Todo.NEXT = 0;
            SearchWordDetail.RESET;
            SearchWordDetail.SETCURRENTKEY("No.","Sub No.","Table Name");
            SearchWordDetail.SETRANGE("No.","No.");
            SearchWordDetail.SETFILTER(
              "Table Name",'%1|%2|%3',
              SearchWordDetail."Table Name"::"Interaction Log Entry",
              SearchWordDetail."Table Name"::"To-do",
              SearchWordDetail."Table Name"::Opportunity);
            IF SearchWordDetail.FIND('-') THEN BEGIN
              REPEAT
                SearchWordDetail.RENAME(
                  SearchWordDetail."Search Word Entry No.",
                  '',
                  SearchWordDetail."Sub No.",
                  SearchWordDetail."Table Name",
                  SearchWordDetail."Field No.",
                  SearchWordDetail."Word Position");
              UNTIL SearchWordDetail.NEXT = 0;
            END;
          END;
        
          Type::Person: BEGIN
            ContJobResp.SETRANGE("Contact No.", "No.");
            ContJobResp.DELETEALL;
        
            InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
            InteractLogEntry.SETRANGE("Contact Company No.","Company No.");
            InteractLogEntry.SETRANGE("Contact No.","No.");
            InteractLogEntry.MODIFYALL("Contact No.","Company No.");
        
            Opp.RESET;
            Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
            Opp.SETRANGE("Contact Company No.","Company No.");
            Opp.SETRANGE("Contact No.","No.");
            Opp.MODIFYALL("Contact No.","Company No.");
        
            Todo.RESET;
            Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
            Todo.SETRANGE("Contact Company No.","Company No.");
            Todo.SETRANGE("Contact No.","No.");
            Todo.MODIFYALL("Contact No.","Company No.");
            SearchWordDetail.RESET;
            SearchWordDetail.SETCURRENTKEY("No.","Sub No.","Table Name");
            SearchWordDetail.SETRANGE("No.","No.");
            SearchWordDetail.SETFILTER(
              "Table Name",'%1|%2|%3',
              SearchWordDetail."Table Name"::"Interaction Log Entry",
              SearchWordDetail."Table Name"::"To-do",
              SearchWordDetail."Table Name"::Opportunity);
            IF SearchWordDetail.FIND('-') THEN BEGIN
              REPEAT
                SearchWordDetail.RENAME(
                  SearchWordDetail."Search Word Entry No.",
                  "Company No.",
                  SearchWordDetail."Sub No.",
                  SearchWordDetail."Table Name",
                  SearchWordDetail."Field No.",
                  SearchWordDetail."Word Position");
              UNTIL SearchWordDetail.NEXT = 0;
            END;
          END;
        END;
        
        ContMailingGrp.SETRANGE("Contact No.","No.");
        ContMailingGrp.DELETEALL;
        
        ContProfileAnswer.SETRANGE("Contact No.","No.");
        ContProfileAnswer.DELETEALL;
        
        RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::Contact);
        RMCommentLine.SETRANGE("No.","No.");
        RMCommentLine.SETRANGE("Sub No.",0);
        IF RMCommentLine.FIND('-') THEN
          REPEAT
            SearchManagement.DeleteCommentDetails(
              RMCommentLine."No.",
              RMCommentLine."Line No.");
          UNTIL RMCommentLine.NEXT = 0;
        RMCommentLine.DELETEALL;
        
        ContAltAddr.SETRANGE("Contact No.","No.");
        ContAltAddr.DELETEALL;
        
        ContAltAddrDateRange.SETRANGE("Contact No.","No.");
        ContAltAddrDateRange.DELETEALL;
        SearchManagement.DeleteContactDetails("No.");
        
        //Replicador
        rRec.GETTABLE(Rec);
        cuReplicatorFun.OnDelete(rRec);
        //Replicador
        */

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
        NoSeriesMgt: Codeunit "No. Series";
        ChangeLogMgt: Codeunit "Change Log Management";
        UpdateCustVendBank: Codeunit "CustVendBank-Update";
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


    procedure AssistEdit(OldCont: Record "Cab. Identificación Devolución"): Boolean
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

