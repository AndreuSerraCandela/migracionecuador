pageextension 50015 pageextension50015 extends "Salespersons/Purchasers"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field(Ruta; rec.Ruta)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Dimensions-&Multiple")
        {
            ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
        }
        addafter("&Salesperson")
        {
            group("<Action20>")
            {
                Caption = '&Salesperson';
                action("<Action40>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Budget';

                    trigger OnAction()
                    begin
                        rec.TestField(Tipo, 0);
                        PptoVta.SetRange("Cod. Promotor", rec.Code);
                        fPptoVta.SetTableView(PptoVta);
                        fPptoVta.RunModal;
                        Clear(fPptoVta);
                    end;
                }
                action("<Action41>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sample Budget';

                    trigger OnAction()
                    begin
                        rec.TestField(Tipo, 0);
                        PptoMuestras.SetRange("Cod. Promotor", rec.Code);
                        fPptoMuestras.SetTableView(PptoMuestras);
                        fPptoMuestras.RunModal;
                        Clear(fPptoMuestras);
                    end;
                }
                action("<Action1000000003>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Levels';

                    trigger OnAction()
                    begin
                        rec.TestField(Tipo, 0);
                        Niveles.SetRange("Cod. Promotor", rec.Code);
                        fNiveles.SetTableView(Niveles);
                        fNiveles.RunModal;
                        Clear(fNiveles);
                    end;
                }
                group("<Action1000000004>")
                {
                    Caption = '&Planning';
                    action("<Action1000000005>")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Plan';
                        Image = EditReminder;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            /*
                            PlanifVisita.RESET;
                            PlanifVisita.SETRANGE("Cod. Promotor",Code);
                            IF NOT PlanifVisita.FINDFIRST THEN
                               BEGIN
                                CLEAR(PlanifVisita);
                                PlanifVisita.VALIDATE("Cod. Promotor",Code);
                                IF PlanifVisita.INSERT(TRUE) THEN
                                   COMMIT;
                               END;
                            
                            //PlanifVisita.SETRANGE("Cod. Promotor",Code);
                            fPlanifVisita.SETTABLEVIEW(PlanifVisita);
                            fPlanifVisita.RUNMODAL;
                            CLEAR(fPlanifVisita);
                            */

                            PlanifVisita.Reset;
                            PlanifVisita.SetRange("Cod. Promotor", rec.Code);
                            if PlanifVisita.FindSet then;

                            //PlanifVisita.SETRANGE("Cod. Promotor",Code);
                            fPlanifVisita.RecibeParametros(rec.Code);
                            //fPlanifVisita.SETTABLEVIEW(PlanifVisita);
                            fPlanifVisita.RunModal;
                            Clear(fPlanifVisita);

                        end;
                    }
                    action("<Action1000000006>")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Execution';
                        Image = Reminder;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            fPlanifVisitaEjec.RecibeParametros(rec.Code);
                            //fPlanifVisitaEjec.SETTABLEVIEW(PlanifVisitaEjec);
                            fPlanifVisitaEjec.RunModal;
                            Clear(fPlanifVisitaEjec);
                        end;
                    }
                    action("<Action1000000007>")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Consult';

                        trigger OnAction()
                        begin
                            PlanifVisitaEjec.Reset;
                            PlanifVisitaEjec.SetRange("Cod. Promotor", rec.Code);
                            if not PlanifVisitaEjec.FindFirst then begin
                                Clear(PlanifVisitaEjec);
                                PlanifVisitaEjec.Validate("Cod. Promotor", rec.Code);
                                if PlanifVisitaEjec.Insert(true) then
                                    Commit;
                            end;

                            //planifvisitaejec.SETRANGE("Cod. Promotor",Code);
                            fPlanifVisitaEjec.SetTableView(PlanifVisitaEjec);
                            fPlanifVisitaEjec.Editable := false;
                            fPlanifVisitaEjec.RunModal;
                            Clear(fPlanifVisitaEjec);
                        end;
                    }
                }
                separator(Action1000000002)
                {
                }
                action("<Action1000000010>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Technical Assistance Request';
                    Image = Replan;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SolAsist: Page "Lista Solicitudes T&E";
                    begin
                        SolAsist.RecibeParam(rec.Code);
                        SolAsist.RunModal;
                        Clear(SolAsist);
                    end;
                }
                separator(Action1000000000)
                {
                }
            }
        }
    }

    var
        PptoVta: Record "Promotor - Ppto Vtas";
        PptoMuestras: Record "Promotor - Ppto Muestras";
        Niveles: Record "Promotor - Niveles";
        PlanifVisita: Record "Cab. Planificacion";
        PlanifVisitaEjec: Record "Cab. Planificacion";
        EntregaMuestras: Record "Promotor - Entrega Muestras";
        Rutas: Record "Promotor - Rutas";
        fPptoVta: Page "Promotores - Ppto Vtas";
        fPptoMuestras: Page "Promotores - Ppto Muestras";
        fPlanifVisita: Page "Lista Planificacion Promotor";
        fPlanifVisitaEjec: Page "Lista Planificacion Ejecucion";
        fEntregaMuestras: Page "Promotor - Entrega de Muestras";
        fNiveles: Page "Promotor - Niveles";
        fRutas: Page "Promotor - Rutas";
        ConfUsuario: Record "User Setup";
}

