#pragma implicitwith disable
page 76162 "Contact List APS"
{
    ApplicationArea = all;
    Caption = 'Contact List';
    DataCaptionFields = "Company No.";
    Editable = false;
    PageType = List;
    SourceTable = Contact;
    SourceTableView = SORTING("Company Name", "Company No.", Type, Name);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field(Name; rec.Name)
                {
                }
                field("Company Name"; rec."Company Name")
                {
                    Visible = false;
                }
                field("Post Code"; rec."Post Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                    Visible = false;
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                    Visible = false;
                }
                field("Fax No."; rec."Fax No.")
                {
                    Visible = false;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                }
                field("Territory Code"; rec."Territory Code")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                    Visible = false;
                }
                field("Language Code"; rec."Language Code")
                {
                    Visible = false;
                }
                field("Search Name"; rec."Search Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontact")
            {
                Caption = 'C&ontact';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F5';
                }
                action("Relate&d Contacts")
                {
                    Caption = 'Relate&d Contacts';
                    RunObject = Page "Contact List";
                    RunPageLink = "Company No." = FIELD("Company No.");
                }
                group("Comp&any")
                {
                    Caption = 'Comp&any';
                    action("Business Relations")
                    {
                        Caption = 'Business Relations';
                        RunObject = Page "Contact Business Relations";
                        RunPageLink = "Contact No." = FIELD("Company No.");
                    }
                    action("Industry Groups")
                    {
                        Caption = 'Industry Groups';
                        RunObject = Page "Contact Industry Groups";
                        RunPageLink = "Contact No." = FIELD("Company No.");
                    }
                    action("Web Sources")
                    {
                        Caption = 'Web Sources';
                        RunObject = Page "Contact Web Sources";
                        RunPageLink = "Contact No." = FIELD("Company No.");
                    }
                }
                group("P&erson")
                {
                    Caption = 'P&erson';
                    action("Job Responsibilities")
                    {
                        Caption = 'Job Responsibilities';

                        trigger OnAction()
                        var
                            ContJobResp: Record "Contact Job Responsibility";
                        begin
                            Rec.TestField(Type, Rec.Type::Person);
                            ContJobResp.SetRange("Contact No.", Rec."No.");
                            PAGE.RunModal(PAGE::"Contact Job Responsibilities", ContJobResp);
                        end;
                    }
                }
                action("Mailing &Groups")
                {
                    Caption = 'Mailing &Groups';
                    RunObject = Page "Contact Mailing Groups";
                    RunPageLink = "Contact No." = FIELD("No.");
                }
                action("Pro&files")
                {
                    Caption = 'Pro&files';

                    trigger OnAction()
                    var
                        ProfileManagement: Codeunit ProfileManagement;
                    begin
                        ProfileManagement.ShowContactQuestionnaireCard(Rec, '', 0);
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Contact Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    RunObject = Page "Contact Picture";
                    RunPageLink = "No." = FIELD("No.");
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Contact),
                                  "No." = FIELD("No."),
                                  "Sub No." = CONST(0);
                }
                group("Alternati&ve Address")
                {
                    Caption = 'Alternati&ve Address';
                    action(Action46)
                    {
                        Caption = 'Card';
                        Image = EditLines;
                        RunObject = Page "Contact Alt. Address Card";
                        RunPageLink = "Contact No." = FIELD("No.");
                    }
                    action("Date Ranges")
                    {
                        Caption = 'Date Ranges';
                        RunObject = Page "Contact Alt. Addr. Date Ranges";
                        RunPageLink = "Contact No." = FIELD("No.");
                    }
                }
                separator(Action48)
                {
                    Caption = '', Locked = true;
                }
                action("Interaction Log E&ntries")
                {
                    Caption = 'Interaction Log E&ntries';
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact Company No.", "Contact No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Postponed &Interactions")
                {
                    Caption = 'Postponed &Interactions';
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact Company No.", "Contact No.");
                }
                action("T&o-dos")
                {
                    Caption = 'T&o-dos';
                    RunObject = Page "Task List";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No.")),
                                  "System To-do Type" = FILTER("Contact Attendee");
                    RunPageView = SORTING("Contact Company No.", "Contact No.");
                }
                group("Oppo&rtunities")
                {
                    Caption = 'Oppo&rtunities';
                    action(List)
                    {
                        Caption = 'List';
                        RunObject = Page "Opportunity List";
                        RunPageLink = "Contact Company No." = FIELD("Company No."),
                                      "Contact No." = FILTER(<> ''),
                                      "Contact No." = FIELD(FILTER("Lookup Contact No."));
                        RunPageView = SORTING("Contact Company No.", "Contact No.");
                    }
                }
                action("Segmen&ts")
                {
                    Caption = 'Segmen&ts';
                    Image = Segment;
                    RunObject = Page "Contact Segment List";
                    RunPageLink = "Contact Company No." = FIELD("Company No."),
                                  "Contact No." = FILTER(<> ''),
                                  "Contact No." = FIELD(FILTER("Lookup Contact No."));
                    RunPageView = SORTING("Contact No.", "Segment No.");
                }
                separator(Action52)
                {
                    Caption = '', Locked = true;
                }
                action("Sales &Quotes")
                {
                    Caption = 'Sales &Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quote";
                    RunPageLink = "Sell-to Contact No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Contact No.");
                }
                separator(Action69)
                {
                }
                action("C&ustomer/Vendor/Bank Acc.")
                {
                    Caption = 'C&ustomer/Vendor/Bank Acc.';

                    trigger OnAction()
                    var
                        LinkToTable: Enum "Contact Business Relation Link To Table";
                    begin
                        Rec.ShowBusinessRelation(LinkToTable::" ", true); //Pendiente checar que se cumpla con la funcionalidad anterior
                        //ShowCustVendBank; Code Modification on "ShowCustVendBank(PROCEDURE 12)".TableExt.Contact
                    end;
                }
                separator(Action1000000000)
                {
                }
            }
            group("&School")
            {
                Caption = '&School';
                action("&Branch")
                {
                    Caption = '&Branch';
                    RunObject = Page "Lista Colegio - Delegaciones";
                    RunPageLink = "No. Solicitud" = FIELD("No.");
                }
                action("&Teachers")
                {
                    Caption = '&Teachers';
                    RunObject = Page "Lista Colegio - Docentes";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                action("&Levels")
                {
                    Caption = '&Levels';
                    RunObject = Page "Colegio - Nivel";
                    RunPageLink = "Cod. Colegio" = FIELD("No."),
                                  City = FIELD(City),
                                  County = FIELD(County),
                                  "Post Code" = FIELD("Post Code");
                }
                action("&Grades")
                {
                    Caption = '&Grades';
                    RunObject = Page "Colegio - Grados";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                action("&Class")
                {
                    Caption = '&Class';
                    RunObject = Page "Lista Colegio - Asignatura";
                    RunPageLink = "Codigo Colegio" = FIELD("No.");
                    Visible = false;
                }
                action("&Adoptions")
                {
                    Caption = '&Adoptions';
                    RunObject = Page "Colegio - Adopciones";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                separator(Action1000000009)
                {
                }
                action("&Gift")
                {
                    Caption = '&Gift';
                    RunObject = Page "Atenciones Colegios";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
                separator(Action1000000013)
                {
                }
                action("&Fathers")
                {
                    Caption = '&Fathers';
                    RunObject = Page "Lista Padres";
                    RunPageLink = "Home Page" = FIELD("No.");
                }
                action("&Students")
                {
                    Caption = '&Students';
                    RunObject = Page "Alumnos - Hijos";
                    RunPageLink = "Cod. Colegio" = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Make &Phone Call")
                {
                    Caption = 'Make &Phone Call';

                    trigger OnAction()
                    var
                        TAPIManagement: Codeunit TAPIManagement;
                    begin
                        TAPIManagement.DialContCustVendBank(DATABASE::Contact, Rec."No.", Rec."Phone No.", '');
                    end;
                }
                action("Launch &Web Source")
                {
                    Caption = 'Launch &Web Source';

                    trigger OnAction()
                    var
                        ContactWebSource: Record "Contact Web Source";
                    begin
                        ContactWebSource.SetRange("Contact No.", Rec."Company No.");
                        if PAGE.RunModal(PAGE::"Web Source Launch", ContactWebSource) = ACTION::LookupOK then
                            ContactWebSource.Launch;
                    end;
                }
                action("Print Cover &Sheet")
                {
                    Caption = 'Print Cover &Sheet';

                    trigger OnAction()
                    var
                        Cont: Record Contact;
                    begin
                        Cont := Rec;
                        Cont.SetRecFilter;
                        REPORT.Run(REPORT::"Contact - Cover Sheet", true, false, Cont);
                    end;
                }
                group("Create as")
                {
                    Caption = 'Create as';
                    action(Customer)
                    {
                        Caption = 'Customer';

                        trigger OnAction()
                        begin
                            Rec.CreateCustomer;
                            //CreateCustomer(ChooseCustomerTemplate); create ChooseCustomerTemplate in Customer Table
                        end;
                    }
                    action(Vendor)
                    {
                        Caption = 'Vendor';

                        trigger OnAction()
                        begin
                            Rec.CreateVendor;
                        end;
                    }
                    action(Bank)
                    {
                        Caption = 'Bank';

                        trigger OnAction()
                        begin
                            Rec.CreateBankAccount;
                        end;
                    }
                }
                group("Link with existing")
                {
                    Caption = 'Link with existing';
                    action(Action63)
                    {
                        Caption = 'Customer';

                        trigger OnAction()
                        begin
                            Rec.CreateCustomerLink;
                        end;
                    }
                    action(Action64)
                    {
                        Caption = 'Vendor';

                        trigger OnAction()
                        begin
                            Rec.CreateVendorLink;
                        end;
                    }
                    action(Action65)
                    {
                        Caption = 'Bank';

                        trigger OnAction()
                        begin
                            Rec.CreateBankAccountLink;
                        end;
                    }
                }
            }
            action("Create &Interact")
            {
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.CreateInteraction;
                end;
            }
        }
        area(creation)
        {
            action("New Sales Quote")
            {
                Caption = 'New Sales Quote';
                Image = Quote;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Sales Quote";
                RunPageLink = "Sell-to Contact No." = FIELD("No.");
                RunPageMode = Create;
            }
        }
        area(reporting)
        {
            action("Contact Cover Sheet")
            {
                Caption = 'Contact Cover Sheet';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";

                trigger OnAction()
                begin
                    Cont := Rec;
                    Cont.SetRecFilter;
                    REPORT.Run(REPORT::"Contact - Cover Sheet", true, false, Cont);
                end;
            }
            action("Contact Company Summary")
            {
                Caption = 'Contact Company Summary';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Contact - Company Summary";
            }
            action("Contact Labels")
            {
                Caption = 'Contact Labels';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Contact - Labels";
            }
            action("Questionnaire Handout")
            {
                Caption = 'Questionnaire Handout';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Questionnaire - Handouts";
            }
            action("Sales Cycle Analysis")
            {
                Caption = 'Sales Cycle Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Sales Cycle - Analysis";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        NoOnFormat;
        NameOnFormat;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin

        exit(Rec.Next(Steps));
    end;

    trigger OnOpenPage()
    begin
        User.Get(UserId);
        RutaProm.Reset;
        RutaProm.SetRange("Cod. Promotor", User."Salespers./Purch. Code");
        RutaProm.FindSet;
        repeat
            ColNivel.Reset;
            ColNivel.SetRange(Ruta, RutaProm."Cod. Ruta");
            ColNivel.SetRange("Cod. Colegio", Rec."No.");
            if not ColNivel.FindFirst then
                Rec.Next(1);
        until RutaProm.Next = 0;
    end;

    var
        Cont: Record Contact;
        RutaProm: Record "Promotor - Rutas";
        ColNivel: Record "Colegio - Nivel";
        User: Record "User Setup";
        "No.Emphasize": Boolean;
        NameEmphasize: Boolean;
        NameIndent: Integer;

    local procedure NoOnFormat()
    begin
        if Rec.Type = Rec.Type::Company then
            "No.Emphasize" := true;
    end;

    local procedure NameOnFormat()
    begin
        if Rec.Type = Rec.Type::Company then
            NameEmphasize := true
        else begin
            Cont.SetCurrentKey("Company Name", "Company No.", Type, Name);
            if (Rec."Company No." <> '') and (not Rec.HasFilter) and (not Rec.MarkedOnly) and (Rec.CurrentKey = Cont.CurrentKey)
            then
                NameIndent := 1;
        end;
    end;
}

#pragma implicitwith restore

