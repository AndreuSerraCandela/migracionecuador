page 76281 "Lista de Docentes"
{
    ApplicationArea = all;

    Caption = 'List of Teachers';
    CardPageID = Docentes;
    Editable = false;
    PageType = List;
    SourceTable = Docentes;
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
                field("No. 2"; rec."No. 2")
                {
                }
                field("Search Name"; rec."Search Name")
                {
                }
                field("Full Name"; rec."Full Name")
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
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                }
                field(Twitter; rec.Twitter)
                {
                }
                field(Facebook; rec.Facebook)
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Usuario creación"; rec."Usuario creación")
                {
                }
            }
        }
        area(factboxes)
        {
            part(PlanifEventLP; "Consulta Asist. Taller/Evento")
            {
                Editable = false;
                SubPageLink = "Cod. Docente" = FIELD("No.");
            }
            part(Control1000000033; "Colegios -  Docentes ListPart")
            {
                Editable = false;
                SubPageLink = "Cod. Docente" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000031>")
            {
                Caption = '&Teacher';
                separator(Action1000000012)
                {
                }
                action("<Action1000000078>")
                {
                    Caption = '&Schools';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Lista Colegio - Docentes";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("<Action1000000022>")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    /*      RunPageLink = "Table Name" = CONST ("15"),
                                       "No." = FIELD ("No."); */
                }
                action("<Action1000000101>")
                {
                    Caption = '&Salesperson';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Promotores - Docentes";
                    RunPageLink = "Codigo Docente" = FIELD("No.");
                }
                action("<Action1000000085>")
                {
                    Caption = 'Hobbies';
                    RunObject = Page "Docentes - Aficiones";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                separator(Action1000000004)
                {
                }
                action("<Action1000000010>")
                {
                    Caption = '&Specialities';
                    RunObject = Page "Docentes - Especialidades";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                separator(Action1000000022)
                {
                }
            }
            group("<Action1000000017>")
            {
                Caption = '&Historics';
                action("<Action1000000015>")
                {
                    Caption = 'CDS History';
                    RunObject = Page "Historico Docentes - CDS";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("<Action1000000007>")
                {
                    Caption = 'Teacher - Hobbies History';
                    RunObject = Page "Hist. Docentes - Aficiones";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("<Action1000000019>")
                {
                    Caption = 'Teacher - Specialties History';
                    RunObject = Page "Hist. Docentes - Espec.";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("<Action1000000021>")
                {
                    Caption = 'School - Teacher History';
                    RunObject = Page "Hist Colegio - Docentes";
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush;
    end;

    var
        Docente: Record Docentes;

    local procedure LookupOKOnPush()
    begin
        CurrPage.SetSelectionFilter(Docente);
    end;
}

