page 76303 "Lista Padres"
{
    ApplicationArea = all;

    Caption = 'List of parents';
    CardPageID = "Ficha Padres";
    DataCaptionFields = DNI, "First Name";
    Editable = false;
    PageType = List;
    SourceTable = Padres;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(DNI; rec.DNI)
                {
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Middle Name"; rec."Middle Name")
                {
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
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
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("Dia Nacimiento"; rec."Dia Nacimiento")
                {
                }
                field("Mes Nacimiento"; rec."Mes Nacimiento")
                {
                }
                field("Ano Nacimiento"; rec."Ano Nacimiento")
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
                field("Cantidad Hijos INI"; rec."Cantidad Hijos INI")
                {
                }
                field("Cantidad Hijos PRI"; rec."Cantidad Hijos PRI")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Father")
            {
                Caption = '&Father';
                action("&Interest area")
                {
                    Caption = '&Interest area';
                    RunObject = Page "Areas de interes padres";
                    RunPageLink = "DNI Padre" = FIELD(DNI);
                }
                action("&Children")
                {
                    Caption = '&Children';
                    RunObject = Page "Alumnos - Hijos";
                    RunPageLink = "DNI Padre" = FIELD(DNI);
                }
            }
        }
    }
}

