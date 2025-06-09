page 76209 Expositores
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Expositores APS";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                }
                field(Name; rec.Name)
                {
                }
                field("Name 2"; rec."Name 2")
                {
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
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field("Territory Code"; rec."Territory Code")
                {
                }
                field("Language Code"; rec."Language Code")
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Search Name"; rec."Search Name")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("Ano inscripcion CDS"; rec."Ano inscripcion CDS")
                {
                }
                field("Ult. fecha activacion"; rec."Ult. fecha activacion")
                {
                }
            }
            group(Santillana)
            {
                Caption = 'Santillana';
                field("Fax No."; rec."Fax No.")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("E-Mail 2"; rec."E-Mail 2")
                {
                }
                field("Home Page"; rec."Home Page")
                {
                }
                field(Twitter; rec.Twitter)
                {
                }
                field(Facebook; rec.Facebook)
                {
                }
                field("BB Pin"; rec."BB Pin")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                }
                field("Date Filter"; rec."Date Filter")
                {
                }
                field("Cost (LCY)"; rec."Cost (LCY)")
                {
                }
                field("Se entrego carne"; rec."Se entrego carne")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Exhibitor")
            {
                Caption = '&Exhibitor';
                separator(Action1000000039)
                {
                }
                action("E&vents")
                {
                    Caption = 'E&vents';
                    Image = EditList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Expositores - Eventos";
                    RunPageLink = "Cod. Expositor" = FIELD ("No.");
                }
            }
        }
    }
}

