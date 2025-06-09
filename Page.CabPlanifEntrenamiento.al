#pragma implicitwith disable
page 76119 "Cab. Planif. Entrenamiento"
{
    ApplicationArea = all;
    Caption = 'Training schedule page';
    PageType = Card;
    SourceTable = "Cab. Entrenamiento";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. entrenamiento"; rec."No. entrenamiento")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update;
                    end;
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
                {
                }
                field("Titulo entrenamiento"; rec."Titulo entrenamiento")
                {
                }
                field("Tipo de Instructor"; rec."Tipo de Instructor")
                {
                }
                field("Cod. Instructor"; rec."Cod. Instructor")
                {
                }
                field("Nombre Instructor"; rec."Nombre Instructor")
                {
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                }
                field("Hora de Inicio"; rec."Hora de Inicio")
                {
                }
                field("Horas entrenamiento"; rec."Horas entrenamiento")
                {
                }
                field("Hora Final"; rec."Hora Final")
                {
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                }
                field("Total registrados"; rec."Total registrados")
                {
                }
                field("Asistentes reales"; rec."Asistentes reales")
                {
                }
                field("Area Curricular"; rec."Area Curricular")
                {
                }
                field(Sala; rec.Sala)
                {
                }
                field(Tipo; rec.Tipo)
                {
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                }
                group(Schedule)
                {
                    Caption = 'Schedule';
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
                }
            }
            part(Control1000000030; "Lin. Entrenamientos")
            {
                SubPageLink = "No. entrenamiento" = FIELD("No. entrenamiento"),
                              "Tipo entrenamiento" = FIELD("Tipo entrenamiento");
            }
            group(Control1000000031)
            {
                ShowCaption = false;
                field("Importe Gastos Entrenador"; rec."Importe Gastos Entrenador")
                {
                }
                field("Importe Gastos Impresion"; rec."Importe Gastos Impresion")
                {
                }
                field("Importe Atenciones"; rec."Importe Atenciones")
                {
                }
                field("Otros Importes"; rec."Otros Importes")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000038>")
            {
                Caption = 'Training';
                Image = DateRange;
                action(Agenda)
                {
                    Caption = 'Create Schedule';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LPEntrenamientos: Record "Lin. entrenamientos";
                        Fecha: Record Date;
                        Seq: Integer;
                        IndSkip: Boolean;
                    begin
                        Entrenamientos.Get(Rec."No. entrenamiento");
                        Entrenamientos.TestField("Hora de Inicio");
                        Entrenamientos.TestField("Hora Final");
                        Rec.TestField("Numero de sesiones");
                        if (not Rec.Domingos) and (not Rec.Lunes) and (not Rec.Martes) and (not Rec.Miercoles) and (not Rec.Jueves) and
                           (not Rec.Viernes) and (not Rec.Sabados) then
                            Error(Err001);

                        Fecha.Reset;
                        Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
                        Fecha.SetRange("Period Start", Rec."Fecha Inicio", CalcDate('+50D', Rec."Fecha Inicio"));
                        Fecha.FindSet;
                        repeat
                            IndSkip := false;
                            Clear(LPEntrenamientos);
                            LPEntrenamientos."No. entrenamiento" := Rec."No. entrenamiento";
                            LPEntrenamientos.Validate("Tipo entrenamiento", Rec."Tipo entrenamiento");
                            // LPEntrenamientos.VALIDATE("Cod. entrenamiento","Cod. entrenamiento");
                            LPEntrenamientos.Validate("Tipo de Instructor", Rec."Tipo de Instructor");
                            LPEntrenamientos.Validate("Cod. Instructor", Rec."Cod. Instructor");
                            LPEntrenamientos.Validate("Hora de Inicio", Rec."Hora de Inicio");
                            LPEntrenamientos.Validate("Hora Final", Rec."Hora Final");
                            // LPEntrenamientos."Asistentes esperados" := "Asistentes esperados";
                            //LPEntrenamientos.Secuencia := Secuencia;
                            if (Fecha."Period No." = 7) and (Rec.Domingos) then
                                LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                            else
                                if (Fecha."Period No." = 6) and (Rec.Sabados) then
                                    LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                                else
                                    if (Fecha."Period No." = 5) and (Rec.Viernes) then
                                        LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                                    else
                                        if (Fecha."Period No." = 4) and (Rec.Jueves) then
                                            LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                                        else
                                            if (Fecha."Period No." = 3) and (Rec.Miercoles) then
                                                LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                                            else
                                                if (Fecha."Period No." = 2) and (Rec.Martes) then
                                                    LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                                                else
                                                    if (Fecha."Period No." = 1) and (Rec.Lunes) then
                                                        LPEntrenamientos.Validate("Fecha programacion", Fecha."Period Start")
                                                    else
                                                        IndSkip := true;

                            //LPEntrenamientos.VALIDATE("Fecha de realizacion",LPEntrenamientos."Fecha programacion");

                            if not IndSkip then begin
                                LPEntrenamientos.Insert(true);
                                Seq += 1;
                            end;
                        until (Fecha.Next = 0) or (Seq >= Rec."Numero de sesiones");
                    end;
                }
            }
        }
    }

    var
        Entrenamientos: Record "Cab. Entrenamiento";
        Err001: Label 'Please select at least one day on which it will be taught';
}

#pragma implicitwith restore

