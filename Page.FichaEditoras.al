page 76219 "Ficha Editoras"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = Editoras;

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
                field(Description; rec.Description)
                {
                }
                field("Search Name"; rec."Search Name")
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
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; rec."Phone No.")
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
                field(Santillana; rec.Santillana)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Editor)
            {
                Caption = 'Editor';
                action(books)
                {
                    Caption = 'books';
                    RunObject = Page "Libros Competencia";
                    RunPageLink = "Cod. Editorial" = FIELD (Code);
                }
            }
        }
    }
}

