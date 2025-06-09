pageextension 50076 pageextension50076 extends "Salesperson/Purchaser Card"
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Global Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        addafter("Next Task Date")
        {
            field("Sample Location code"; rec."Sample Location code")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Tipo; rec.Tipo)
            {
                ApplicationArea = Basic, Suite;
                ValuesAllowed = Vendedor, Cobrador, Supervisor;
            }
            field(Status; rec.Status)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Invoicing)
        {
            group(Communication)
            {
                Caption = 'Communication';
                field("Home Page"; rec."Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = URL;
                }
                field(Facebook; rec.Facebook)
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = URL;
                }
                field("E-Mail2"; rec."E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Twitter; rec.Twitter)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("BB Pin"; rec."BB Pin")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Vehicle; rec.Vehicle)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    actions
    {
        addafter(ActionGroupCRM)
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
                action("&Levels")
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
                    action(Plan)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Plan';
                        Image = EditReminder;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

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
                    action(Execution)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Execution';
                        Image = Reminder;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin
                            fPlanifVisitaEjec.RecibeParametros(rec.Code);
                            //fPlanifVisitaEjec.SETTABLEVIEW(PlanifVisitaEjec);
                            fPlanifVisitaEjec.RunModal;
                            Clear(fPlanifVisitaEjec);
                        end;
                    }
                    action(Consult)
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
                separator(Action1000000007)
                {
                }
                action("Technical Assistance Request")
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
                separator(Action1000000005)
                {
                }
                action(Rutas)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Route';

                    trigger OnAction()
                    begin
                        rec.TestField(Tipo, 0);
                        Rutas.SetRange("Cod. Promotor", rec.Code);
                        fRutas.SetTableView(Rutas);
                        fRutas.RunModal;
                        Clear(fRutas);
                    end;
                }
                action(Muestras)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Samples';

                    trigger OnAction()
                    begin
                        rec.TestField(Tipo, 0);
                        EntregaMuestras.SetRange("Cod. Promotor", rec.Code);
                        fEntregaMuestras.SetTableView(EntregaMuestras);
                        fEntregaMuestras.Editable := false;
                        fEntregaMuestras.RunModal;

                        Clear(fEntregaMuestras);
                    end;
                }
                separator(Action1000000002)
                {
                }
                action(Colegios)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&School';
                    RunObject = Page "Promotores - Lista de Colegios";
                    RunPageLink = "Cod. Promotor" = FIELD(Code);
                }
                action(Docentes)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Teachers';
                    RunObject = Page "Promotores - Docentes";
                    RunPageLink = "Cod. Promotor" = FIELD(Code);
                }
            }
        }
        addafter("Create &Interaction")
        {
            separator(Action1000000017)
            {
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


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*

    if ConfUsuario."Salespers./Purch. Code" <> '' then
       SetRange(Code,ConfUsuario."Salespers./Purch. Code")
    else
       SetRange(Code);
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    ConfUsuario.Get(UserId);
    */
    //end;
}

