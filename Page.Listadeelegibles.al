page 76283 "Lista de elegibles"
{
    ApplicationArea = all;
    Caption = 'List of eligible';
    CardPageID = "Eligible Card";
    PageType = List;
    SourceTable = Elegibles;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
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
                field(Initials; rec.Initials)
                {
                }
                field("Job Title"; rec."Job Title")
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
                field("Post Code"; rec."Post Code")
                {
                }
                field(County; rec.County)
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Birth Date"; rec."Birth Date")
                {
                }
                field("Social Security No."; rec."Social Security No.")
                {
                }
                field(Gender; rec.Gender)
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field(Comment; rec.Comment)
                {
                }
                field("Last Date Modified"; rec."Last Date Modified")
                {
                }
                field("Global Dimension 1 Filter"; rec."Global Dimension 1 Filter")
                {
                }
                field("Global Dimension 2 Filter"; rec."Global Dimension 2 Filter")
                {
                }
                field(Extension; rec.Extension)
                {
                }
                field("URL Linkedin"; rec."URL Linkedin")
                {
                }
                field("URL Facebook"; rec."URL Facebook")
                {
                }
                field("Company E-Mail"; rec."Company E-Mail")
                {
                }
                field(Title; rec.Title)
                {
                }
                field("No. Series"; rec."No. Series")
                {
                }
                field("Full Name"; rec."Full Name")
                {
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field(Nacionalidad; rec.Nacionalidad)
                {
                }
                field("Lugar nacimiento"; rec."Lugar nacimiento")
                {
                }
                field("Estado civil"; rec."Estado civil")
                {
                }
                field("No. Seguridad Social"; rec."No. Seguridad Social")
                {
                }
                field("Experiencia 1"; rec."Experiencia 1")
                {
                }
                field("Experiencia 2"; rec."Experiencia 2")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Job Type Code"; rec."Job Type Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

