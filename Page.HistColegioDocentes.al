#pragma implicitwith disable
page 76239 "Hist Colegio - Docentes"
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Colegio", "Nombre colegio", "Nombre docente";
    Editable = false;
    PageType = List;
    SourceTable = "Hist. Colegio - Docentes";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Campana; rec.Campana)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
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
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                    DrillDownPageID = "Lista Puestos";
                }
                field("Nombre Cargo"; rec."Nombre Cargo")
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
                    Visible = false;

                    trigger OnAction()
                    var
                        Estad: Page "Adopciones - Colegio - MRK 2";
                    begin
                        Estad.RecibeParametros(Rec."Cod. Docente", Rec."Cod. Colegio");
                        Estad.Run;
                        Clear(Estad);
                    end;
                }
                separator(Action1000000009)
                {
                }
                action("Ranking por CVM")
                {
                    Caption = 'Ranking por CVM';
                    Image = AdjustEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RankingDocente: Page "Hist Adopciones-Colegio-Docent";
                    begin
                        Rec.TestField("Cod. Colegio");
                        Rec.TestField("Cod. Docente");

                        /*
                        RankingDocente.RecibeParametros("Cod. Docente","Cod. Colegio");
                        RankingDocente.RUN;
                        CLEAR(RankingDocente);
                        */

                    end;
                }
            }
        }
    }
}

#pragma implicitwith restore

