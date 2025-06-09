#pragma implicitwith disable
page 76120 "Cab. Planif. Evento"
{
    ApplicationArea = all;
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
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                }
                field(Lunes; rec.Lunes)
                {
                }
                field(Martes; rec.Martes)
                {
                }
                field(Miercoles; rec.Miercoles)
                {
                }
                field(Jueves; rec.Jueves)
                {
                }
                field(Viernes; rec.Viernes)
                {
                }
                field(Sabados; rec.Sabados)
                {
                }
                field(Domingos; rec.Domingos)
                {
                }
                field("Total registrados"; rec."Total registrados")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Estado; rec.Estado)
                {
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
                action("Create Schedule")
                {
                    Caption = 'Create Schedule';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ProgTyE: Record "Programac. Talleres y Eventos";
                        Seq: Integer;
                        IndSkip: Boolean;
                    begin
                        Evento.Get(Rec."Tipo Evento", Rec."Cod. Taller - Evento");
                        Evento.TestField("Horas programadas");

                        Rec.TestField("Numero de sesiones");

                        Fecha.Reset;
                        Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
                        Fecha.SetRange("Period Start", Rec."Fecha Inicio", CalcDate('+50D', Rec."Fecha Inicio"));
                        //Fecha.SETRANGE("Period end",calcdate('+50D',"Fecha Inicio"));
                        Fecha.FindSet;
                        repeat
                            IndSkip := false;
                            Clear(ProgTyE);
                            ProgTyE.Validate("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
                            ProgTyE.Validate("Tipo Evento", Rec."Tipo Evento");
                            ProgTyE.Validate("Tipo de Expositor", Rec."Tipo de Expositor");
                            ProgTyE.Validate(Expositor, Rec.Expositor);
                            ProgTyE."Asistentes esperados" := Rec."Asistentes esperados";
                            ProgTyE.Secuencia := Rec.Secuencia;
                            if (Fecha."Period No." = 7) and (Rec.Domingos) then
                                ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                            else
                                if (Fecha."Period No." = 6) and (Rec.Sabados) then
                                    ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                                else
                                    if (Fecha."Period No." = 5) and (Rec.Viernes) then
                                        ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                                    else
                                        if (Fecha."Period No." = 4) and (Rec.Jueves) then
                                            ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                                        else
                                            if (Fecha."Period No." = 3) and (Rec.Miercoles) then
                                                ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                                            else
                                                if (Fecha."Period No." = 2) and (Rec.Martes) then
                                                    ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                                                else
                                                    if (Fecha."Period No." = 1) and (Rec.Lunes) then
                                                        ProgTyE.Validate("Fecha programacion", Fecha."Period Start")
                                                    else
                                                        IndSkip := true;

                            ProgTyE.Validate("Fecha de realizacion", ProgTyE."Fecha programacion");
                            ProgTyE."Horas dictadas" := Evento."Horas programadas";

                            if not IndSkip then begin
                                ProgTyE.Insert(true);
                                Seq += 1;
                            end;
                        until (Fecha.Next = 0) or (Seq >= Rec."Numero de sesiones");
                    end;
                }
                action(Materiales)
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
                        MatTyE.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
                        MatTyE.SetRange("Tipo Evento", Rec."Tipo Evento");
                        MatTyE.SetRange(Expositor, Rec.Expositor);
                        MatTyE.SetRange(Secuencia, Rec.Secuencia);
                        if not MatTyE.FindFirst then begin
                            MatTyE2.Reset;
                            MatTyE2.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
                            MatTyE2.SetRange("Tipo Evento", Rec."Tipo Evento");
                            MatTyE2.SetRange(Secuencia, 0);
                            if MatTyE2.FindSet then
                                repeat
                                    Clear(MatTyE);
                                    MatTyE.TransferFields(MatTyE2);
                                    MatTyE.Expositor := Rec.Expositor;
                                    MatTyE."Tipo de Expositor" := Rec."Tipo de Expositor";
                                    MatTyE.Secuencia := Rec.Secuencia;
                                    MatTyE.Insert(true);
                                until MatTyE2.Next = 0;
                            Commit;
                        end;

                        Clear(MatTyE);
                        MatTyE.SetRange("Cod. Taller - Evento", Rec."Cod. Taller - Evento");
                        MatTyE.SetRange("Tipo Evento", Rec."Tipo Evento");
                        MatTyE.SetRange(Expositor, Rec.Expositor);
                        MatTyE.SetRange("Tipo de Expositor", Rec."Tipo de Expositor");
                        MatTyE.SetRange(Secuencia, Rec.Secuencia);

                        PgMatTyE.SetTableView(MatTyE);
                        PgMatTyE.RunModal;
                        Clear(PgMatTyE);
                    end;
                }
                action(Asistentes)
                {
                    Caption = 'Asistentes';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Asistentes Talleres y Eventos";
                    RunPageLink = "Cod. Taller - Evento" = FIELD("Cod. Taller - Evento"),
                                  "Tipo Evento" = FIELD("Tipo Evento"),
                                  Secuencia = FIELD(Secuencia),
                                  "Cod. Expositor" = FIELD(Expositor);
                    Visible = false;
                }
                action("Distribution per Cost Centre")
                {
                    Caption = 'Distribution per Cost Centre';
                    Image = GLAccountBalance;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        GpoNegDistrib: Page "Grupos de Negocio - Distrib.";
                    begin

                        Rec.TestField("Cod. Taller - Evento");
                        Rec.TestField("Tipo Evento");
                        Rec.TestField(Expositor);
                        Rec.TestField(Secuencia);

                        GpoNegDistrib.RecibeParametros('', '', Rec."Cod. Taller - Evento", Rec."Tipo Evento", Rec.Expositor, Rec.Secuencia, false, true, '');
                        GpoNegDistrib.RunModal;
                    end;
                }
            }
        }
    }

    var
        Fecha: Record Date;
        Evento: Record Eventos;
}

#pragma implicitwith restore

