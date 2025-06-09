page 76217 "Ficha de Alumnos"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Alumnos - Hijos";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; rec.Code)
                {
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Middle Name"; rec."Middle Name")
                {
                }
                field(Surname; rec.Surname)
                {
                }
                field(Sex; rec.Sex)
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
                    Caption = 'State / ZIP Code';
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Home Phone No."; rec."Home Phone No.")
                {
                }
                field("Cell Phone No."; rec."Cell Phone No.")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Home Page"; rec."Home Page")
                {
                }
                field(Facebook; rec.Facebook)
                {
                }
                field(Twitter; rec.Twitter)
                {
                }
                field("BB Pin"; rec."BB Pin")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Student")
            {
                Caption = '&Student';
                action("&Fathers")
                {
                    Caption = '&Fathers';
                    RunObject = Page "Lista Padres";
                    RunPageLink = DNI = FIELD ("DNI Padre");
                }
                action("&School")
                {
                    Caption = '&School';
                    RunObject = Page "Contact Card";
                    RunPageLink = "No." = FIELD ("Cod. Colegio");
                }
            }
        }
    }
}

