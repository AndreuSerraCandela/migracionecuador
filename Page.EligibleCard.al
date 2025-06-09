#pragma implicitwith disable
page 76194 "Eligible Card"
{
    ApplicationArea = all;
    Caption = 'Eligible Card';
    PageType = Card;
    SourceTable = Elegibles;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("First Name"; rec."First Name")
                {
                    Importance = Promoted;
                }
                field("Middle Name"; rec."Middle Name")
                {
                    Caption = 'Middle Name/Initials';
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                }
                field(Initials; rec.Initials)
                {
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Job Type Code"; rec."Job Type Code")
                {
                }
                field("Job Title"; rec."Job Title")
                {
                    Importance = Promoted;
                }
                field(Address; rec.Address)
                {
                }
                field("Address 2"; rec."Address 2")
                {
                }
                field(City; rec.City)
                {
                }
                field(County; rec.County)
                {
                    Caption = 'State/ZIP Code';
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Search Name"; rec."Search Name")
                {
                }
                field(Gender; rec.Gender)
                {
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {
                    Importance = Promoted;
                }
                field("Phone No."; rec."Phone No.")
                {
                    Importance = Promoted;
                }
                field(Status; rec.Status)
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                    Importance = Promoted;
                }
                field("Phone No.2"; rec."Phone No.")
                {
                }
                field(Extension; rec.Extension)
                {
                    Importance = Promoted;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    Importance = Promoted;
                }
                field("URL Linkedin"; rec."URL Linkedin")
                {
                }
                field("URL Facebook"; rec."URL Facebook")
                {
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field("Birth Date"; rec."Birth Date")
                {
                    Importance = Promoted;
                }
                field("Social Security No."; rec."Social Security No.")
                {
                    Importance = Promoted;
                }
            }
            group(Experience)
            {
                Caption = 'Experience';
                field("Experiencia 1"; rec."Experiencia 1")
                {
                    MultiLine = true;
                }
                field("Experiencia 2"; rec."Experiencia 2")
                {
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                }
                separator(Action61)
                {
                }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    Image = Map;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        MapPointVisible := true;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        if not MapMgt.TestSetup then
            MapPointVisible := false;
    end;

    var
        MapPointVisible: Boolean;
}

#pragma implicitwith restore

