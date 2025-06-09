page 76290 "Lista Editoras"
{
    ApplicationArea = all;

    Caption = 'List of publishers';
    CardPageID = "Ficha Editoras";
    PageType = List;
    SourceTable = Editoras;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                ShowCaption = false;
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
            group("&Editor")
            {
                Caption = '&Editor';
                action("&Card")
                {
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Ficha Editoras";
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F7';
                    Visible = false;
                }
                separator(Action1000000036)
                {
                }
            }
        }
    }
}

