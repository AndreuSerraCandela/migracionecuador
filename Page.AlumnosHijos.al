page 76086 "Alumnos - Hijos"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Alumnos - Hijos";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("DNI Padre"; rec."DNI Padre")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
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
                field("Nombre Padre"; rec."Nombre Padre")
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
                field("Territory Code"; rec."Territory Code")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Post Code"; rec."Post Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Home Phone No."; rec."Home Phone No.")
                {
                }
                field("Born Date"; rec."Born Date")
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
                field("Nombre Colegio"; rec."Nombre Colegio")
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
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Ficha de Alumnos";
                    RunPageLink = Code = FIELD (Code);
                    ShortCutKey = 'Shift+F7';
                }
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

