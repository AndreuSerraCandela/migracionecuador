page 76277 "Lista Colegio - Docentes"
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Colegio", "Nombre colegio", "Nombre docente";
    PageType = List;
    SourceTable = "Colegio - Docentes";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                    Visible = false;
                }
                field(City; rec.City)
                {
                    Editable = false;
                }
                field("Distrito colegio"; rec."Distrito colegio")
                {
                    Editable = false;
                }
                field("Nombre colegio"; rec."Nombre colegio")
                {
                    Editable = false;
                }
                field("Cod. Docente"; rec."Cod. Docente")
                {
                }
                field("Nombre docente"; rec."Nombre docente")
                {
                    Editable = false;
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                    DrillDownPageID = "Lista Puestos";
                }
                field("Descripcion Cargo"; rec."Descripcion Cargo")
                {
                    Editable = false;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                    Editable = false;
                }
                field("Docente - Phone No."; rec."Docente - Phone No.")
                {
                }
                field("Docente - Tipo documento"; rec."Docente - Tipo documento")
                {
                    Caption = 'Tipo documento';
                }
                field("Docente - Document ID"; rec."Docente - Document ID")
                {
                }
                field("Docente - E-Mail"; rec."Docente - E-Mail")
                {
                }
                field("Docente - Mobile Phone No."; rec."Docente - Mobile Phone No.")
                {
                }
                field("Docente - E-Mail 2"; rec."Docente - E-Mail 2")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field("Nivel decision"; rec."Nivel decision")
                {
                }
                field(Principal; rec.Principal)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&School")
            {
                Caption = '&School';
                action("&School Card")
                {
                    Caption = '&School Card';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No." = FIELD("Cod. Colegio");
                    ShortCutKey = 'Shift+F5';
                }
            }
            group("&Teacher")
            {
                Caption = '&Teacher';
                action("&Teacher Card")
                {
                    Caption = '&Teacher Card';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Docentes;
                    RunPageLink = "No." = FIELD("Cod. Docente");
                }
                action(Adoption)
                {
                    Caption = 'Adoption';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Estad: Page "Adopciones - Colegio - MRK 2";
                    begin
                        Estad.RecibeParametros(rec."Cod. Docente", rec."Cod. Colegio");
                        Estad.Run;
                        Clear(Estad);
                    end;
                }
                separator(Action1000000009)
                {
                }
                action("<Action1000000010>")
                {
                    Caption = 'Ranking por CVM';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RankingDocente: Page "Adopciones - Colegio - MRK 2";
                    begin
                        rec.TestField("Cod. Colegio");
                        rec.TestField("Cod. Docente");
                        RankingDocente.RecibeParametros(rec."Cod. Docente", rec."Cod. Colegio");
                        RankingDocente.Run;
                        Clear(RankingDocente);
                    end;
                }
            }
        }
    }
}

