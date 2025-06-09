page 76292 "Lista expositores"
{
    ApplicationArea = all;

    Caption = 'Exhibitor List';
    CardPageID = Expositores;
    Editable = false;
    PageType = List;
    SourceTable = "Expositores APS";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field("Search Name"; rec."Search Name")
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
                field("Post Code"; rec."Post Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

