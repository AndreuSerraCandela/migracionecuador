page 56015 "Cab. Hoja de Ruta Reg."
{
    ApplicationArea = all;
    Editable = false;
    PageType = Document;
    SourceTable = "Cab. Hoja de Ruta Reg.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. Hoja Ruta"; rec."No. Hoja Ruta")
                {
                }
                field("Cod. Transportista"; rec."Cod. Transportista")
                {
                }
                field("Nombre Chofer"; rec."Nombre Chofer")
                {
                }
                field(Ayudantes; rec.Ayudantes)
                {
                }
                field("Fecha Planificacion Transporte"; rec."Fecha Planificacion Transporte")
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
                field(Zona; rec.Zona)
                {
                }
                field(Hora; rec.Hora)
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Cantidad de cajas"; rec."Cantidad de cajas")
                {
                }
            }
            part(Control1000000011; "Lin. Hoja de Ruta Reg.")
            {
                SubPageLink = "No. Hoja Ruta" = FIELD ("No. Hoja Ruta");
                SubPageView = SORTING ("No. Hoja Ruta", "No. Linea")
                              ORDER(Ascending);
            }
        }
        area(factboxes)
        {
            systempart(Control1000000009; MyNotes)
            {
            }
            systempart(Control1000000010; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000014>")
            {
                Caption = 'Imprimir';
                action("<Action1000000013>")
                {
                    Caption = '&Resumido';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(CHRR);
                        REPORT.RunModal(56024, true, false, CHRR);
                    end;
                }
                action("<Action1000000015>")
                {
                    Caption = '&Detallado';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(CHRR);
                        REPORT.RunModal(56018, true, false, CHRR);
                    end;
                }
            }
        }
    }

    var
        CHRR: Record "Cab. Hoja de Ruta Reg.";
}

