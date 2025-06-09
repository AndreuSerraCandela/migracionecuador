page 76225 "Ficha Padres"
{
    Caption = 'Father Card';
    PageType = Card;
    SourceTable = Padres;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DNI; rec.DNI)
                {
                }
                field("Tipo documento"; rec."Tipo documento")
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
                    Caption = 'Sex';
                    ValuesAllowed = Femenino, Masculino;
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
                field("Territory Code"; rec."Territory Code")
                {
                }
                field("Salutation Code"; rec."Salutation Code")
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
                field("Fecha Nacimiento"; rec."Fecha Nacimiento")
                {
                }
                field("Cantidad Hijos INI"; rec."Cantidad Hijos INI")
                {
                }
                field("Grado INI"; rec."Grado INI")
                {
                }
                field("Cantidad Hijos PRI"; rec."Cantidad Hijos PRI")
                {
                }
                field("Grado PRI"; rec."Grado PRI")
                {
                }
                field("Cantidad Hijos SEC"; rec."Cantidad Hijos SEC")
                {
                }
                field("Grado SEC"; rec."Grado SEC")
                {
                }
                field("Fecha creacion"; rec."Fecha creacion")
                {
                    Editable = false;
                }
                field("Ult. Fecha Actualizacion"; rec."Ult. Fecha Actualizacion")
                {
                    Editable = false;
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
                field("E-Mail 2"; rec."E-Mail 2")
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
            group("&Father")
            {
                Caption = '&Father';
                action("&Interest area")
                {
                    Caption = '&Interest area';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Areas de interes padres";
                    RunPageLink = "DNI Padre" = FIELD(DNI);
                }
                action("&Children")
                {
                    Caption = '&Children';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Alumnos - Hijos";
                    RunPageLink = "DNI Padre" = FIELD(DNI);
                }
                separator(Action1000000038)
                {
                }
            }
        }
    }
}

