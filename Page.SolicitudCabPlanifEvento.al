page 76394 "Solicitud -Cab. Planif. Evento"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Cab. Planif. Evento";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Editable = false;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Editable = false;
                }
                field(Expositor; rec.Expositor)
                {
                    Editable = false;
                }
                field(Secuencia; rec.Secuencia)
                {
                    Editable = false;
                }
                field("Description Tipo evento"; rec."Description Tipo evento")
                {
                    Editable = false;
                }
                field("Description Taller"; rec."Description Taller")
                {
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                    Editable = false;
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                    Editable = false;
                    StyleExpr = TRUE;
                }
            }
            part(SubFormPTyE; "Programac. Talleres y Eventos")
            {
                SubPageLink = "Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                              "Tipo Evento" = FIELD("Tipo Evento"),
                              "Tipo de Expositor" = FIELD("Tipo de Expositor"),
                              Expositor = FIELD(Expositor),
                              Secuencia = FIELD(Secuencia);
                SubPageView = SORTING("Cod. Taller - Evento", "Tipo Evento", "Tipo de Expositor", Expositor);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000038>")
            {
                Caption = '&Event';
                action("<Action1000000039>")
                {
                    Caption = 'Materiales';
                    Image = CalculateInventory;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        MatTyE: Record "Materiales Talleres y Eventos";
                        MatTyE2: Record "Materiales Talleres y Eventos";
                        PgMatTyE: Page "Materiales Talleres y Eventos";
                    begin
                        MatTyE.Reset;
                        MatTyE.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
                        MatTyE.SetRange("Tipo Evento", rec."Tipo Evento");
                        MatTyE.SetRange(Expositor, rec.Expositor);
                        MatTyE.SetRange(Secuencia, rec.Secuencia);
                        if not MatTyE.FindFirst then begin
                            MatTyE2.Reset;
                            MatTyE2.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
                            MatTyE2.SetRange("Tipo Evento", rec."Tipo Evento");
                            MatTyE2.SetRange(Secuencia, 0);
                            if MatTyE2.FindSet then
                                repeat
                                    Clear(MatTyE);
                                    MatTyE.TransferFields(MatTyE2);
                                    MatTyE.Expositor := rec.Expositor;
                                    MatTyE."Tipo de Expositor" := rec."Tipo de Expositor";
                                    MatTyE.Secuencia := rec.Secuencia;
                                    MatTyE.Insert(true);
                                until MatTyE2.Next = 0;
                            Commit;
                        end;

                        Clear(MatTyE);
                        MatTyE.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
                        MatTyE.SetRange("Tipo Evento", rec."Tipo Evento");
                        MatTyE.SetRange(Secuencia, rec.Secuencia);
                        MatTyE.SetRange(Expositor, rec.Expositor);
                        MatTyE.SetRange("Tipo de Expositor", rec."Tipo de Expositor");
                        PgMatTyE.SetTableView(MatTyE);
                        PgMatTyE.RunModal;
                        Clear(PgMatTyE);
                    end;
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rProg: Record "Programac. Talleres y Eventos";
        rSol: Record "Solicitud de Taller - Evento";
    begin
        /*
        IF "No. Solicitud" <> '' THEN BEGIN
          rSol.GET("No. Solicitud");
          rSol."Asistentes Reales" := 0;
          rProg.SETRANGE("Cod. Taller - Evento","Cod. Taller - Evento");
          rProg.SETRANGE("Tipo Evento","Tipo Evento");
          rProg.SETRANGE("Tipo de Expositor","Tipo de Expositor");
          rProg.SETRANGE(rProg.Expositor,Expositor);
          rProg.SETRANGE(Secuencia, Secuencia);
          IF rProg.FINDFIRST THEN BEGIN
             REPEAT
               rSol."Asistentes Reales" := rSol."Asistentes Reales" + rProg."Nro. De asistentes reales";
             UNTIL rProg.NEXT=0;
             rSol.MODIFY;
          END;
        END;
        */

    end;

    var
        Fecha: Record Date;
        Evento: Record Eventos;
}

