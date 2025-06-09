page 76401 "Solic. Planif. Taller/Evento"
{
    ApplicationArea = all;
    Caption = 'View Assist. Workshop/Events';
    PageType = List;
    SourceTable = "Programac. Talleres y Eventos";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                    Visible = false;
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                    Visible = false;
                }
                field("Fecha de realizacion"; rec."Fecha de realizacion")
                {
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                }
                field("Nro. De asistentes reales"; rec."Nro. De asistentes reales")
                {
                }
                field("Horas dictadas"; rec."Horas dictadas")
                {
                    Visible = false;
                }
                field(Estado; rec.Estado)
                {
                }
                field("Hora de Inicio"; rec."Hora de Inicio")
                {
                    Visible = false;
                }
                field("Hora Final"; rec."Hora Final")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000044>")
            {
                Caption = 'Workshop - Event';
                action("<Action1000000047>")
                {
                    Caption = 'Assistance';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Asistentes Talleres y Eventos";
                    RunPageLink = "Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                                  "Tipo Evento" = FIELD("Tipo Evento"),
                                  Secuencia = FIELD(Secuencia),
                                  "Cod. Expositor" = FIELD(Expositor);

                    trigger OnAction()
                    var
                        CabPlanEvent: Record "Cab. Planif. Evento";
                        CabPlanEvent2: Record "Cab. Planif. Evento";
                        PlanEvent: Page "Lista Cab. Planif. Evento";
                    begin
                        /*
                        PlanEvent.RecibeParametros("Cod. Expositor","Tipo de Expositor","Cod. Evento",CabPlanEvent."Tipo Evento");
                        CabPlanEvent.RESET;
                        CabPlanEvent.SETRANGE("Cod. Taller - Evento","Cod. Evento");
                        IF CabPlanEvent.FINDFIRST THEN
                           PlanEvent.SETRECORD(CabPlanEvent);
                        
                        PlanEvent.RUNMODAL;
                        
                        CLEAR(PlanEvent);
                        */

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        CabPlanEvento.RESET;
        CabPlanEvento.SETRANGE("Cod. Taller - Evento","Cod. Taller - Evento");
        CabPlanEvento.SETRANGE(Expositor,Expositor);
        CabPlanEvento.SETRANGE(Secuencia,Secuencia);
        CabPlanEvento.SETRANGE("Tipo Evento","Tipo Evento");
        CabPlanEvento.FINDFIRST;
        CabPlanEvento.CALCFIELDS("Total registrados");
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.Validate("Cod. Taller - Evento", gCodTaller);
        rec.Validate("Tipo Evento", gTipoEvento);
        rec.Validate("Cod. Promotor", gCodPromotor);
        rec.Validate("Cod. Colegio", gCodColegio);
        rec.Validate(Expositor, gCodExpositor);
        rec.Validate("Tipo de Expositor", gTipoExpositor);

        rec.TestField("Cod. Colegio");
        rec.TestField("Cod. Promotor");
        rec.TestField(Expositor);
        rec.TestField("Cod. Taller - Evento");
    end;

    trigger OnOpenPage()
    begin
        rec.SetRange("Cod. Taller - Evento", gCodTaller);
        rec.SetRange("Tipo Evento", gTipoEvento);
        rec.SetRange("Cod. Promotor", gCodPromotor);
        rec.SetRange("Cod. Colegio", gCodColegio);
        rec.SetRange(Expositor, gCodExpositor);
        rec.SetRange("Tipo de Expositor", gTipoExpositor);
    end;

    var
        CabPlanEvento: Record "Cab. Planif. Evento";
        SelDoc: Page "Seleccionar Docentes";
        TotDocentes: Integer;
        TotSeleccionados: Integer;
        TotReg: Integer;
        gCodTaller: Code[20];
        gTipoEvento: Code[20];
        gCodPromotor: Code[20];
        gCodColegio: Code[20];
        gCodExpositor: Code[20];
        gTipoExpositor: Integer;


    procedure RecibeParametros(CodTaller: Code[20]; TipoEvento: Code[20]; CodPromotor: Code[20]; CodColegio: Code[20]; CodExpositor: Code[20]; TipoExpositor: Integer)
    begin
        gCodTaller := CodTaller;
        gTipoEvento := TipoEvento;
        gCodPromotor := CodPromotor;
        gCodColegio := CodColegio;
        gCodExpositor := CodExpositor;
        gTipoExpositor := TipoExpositor;
    end;


    procedure AbrirPagAsistentes()
    var
        ATE: Record "Asistentes Talleres y Eventos";
        ATE2: Record "Asistentes Talleres y Eventos";
        PagATE: Page "Asistentes Talleres y Eventos";
    begin
        //MESSAGE('%1',Rec);
        ATE.Reset;
        ATE.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
        ATE.SetRange("Tipo Evento", rec."Tipo Evento");
        ATE.SetRange(Secuencia, rec.Secuencia);
        ATE.SetRange("Cod. Expositor", rec.Expositor);
        ATE.SetRange("Fecha programacion", 0D);
        if ATE.FindSet then begin
            repeat
                Clear(ATE2);
                ATE2.TransferFields(ATE);
                ATE2."Fecha programacion" := rec."Fecha programacion";
                if ATE2.Insert(true) then;
            until ATE.Next = 0;
            Commit;
        end;

        ATE.Reset;
        ATE.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
        ATE.SetRange("Tipo Evento", rec."Tipo Evento");
        ATE.SetRange(Secuencia, rec.Secuencia);
        ATE.SetRange("Cod. Expositor", rec.Expositor);
        ATE.SetRange("Fecha programacion", rec."Fecha programacion");
        if ATE.FindFirst then;

        PagATE.SetTableView(ATE);
        PagATE.RunModal;
        Clear(PagATE);
    end;
}

