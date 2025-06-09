#pragma implicitwith disable
page 76105 "Asistentes entrenamientos"
{
    ApplicationArea = all;
    Caption = 'Training assistants';
    DataCaptionExpression = 'Titulo entrenamiento';
    PageType = List;
    SourceTable = "Asistentes entrenamientos";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. entrenamiento"; rec."No. entrenamiento")
                {
                    Visible = false;
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
                {
                    Visible = false;
                }
                field("Cod. entrenamiento"; rec."Cod. entrenamiento")
                {
                    Visible = false;
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Titulo entrenamiento"; rec."Titulo entrenamiento")
                {
                    Visible = false;
                }
                field("Tipo de Instructor"; rec."Tipo de Instructor")
                {
                    Visible = false;
                }
                field("Cod. Instructor"; rec."Cod. Instructor")
                {
                    Visible = false;
                }
                field("Nombre Instructor"; rec."Nombre Instructor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Nombre completo"; rec."Nombre completo")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                    Editable = false;
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field(Inscrito; rec.Inscrito)
                {
                }
                field(Notificado; rec.Notificado)
                {
                }
                field(Confirmado; rec.Confirmado)
                {
                }
                field(Asistio; rec.Asistio)
                {
                }
                field(Calificacion; rec.Calificacion)
                {
                }
            }
            group(Assistants)
            {
                Caption = 'Assistants';
                field(TotalInscritos; TotalInscritos)
                {
                    Caption = 'Total Enrolled';
                    Editable = false;
                }
                field(TotalAsistentes; TotalAsistentes)
                {
                    Caption = 'Total Attendees';
                    Editable = false;
                }
                field(Capacidad; Capacidad)
                {
                    Caption = 'Maximum capacity';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Empleado")
            {
                Caption = '&Empleado';
                action(Notify)
                {
                    Caption = 'Notify';
                    Image = SendConfirmation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        FuncEnt.EnviarNotificacion(Rec);
                    end;
                }
                separator(Action1000000026)
                {
                }
                action("Mark confirmation")
                {
                    Caption = 'Mark confirmation';
                    Image = Confirm;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                }
                separator(Action1000000028)
                {
                }
                action("Mark attendance")
                {
                    Caption = 'Mark attendance';
                    Image = Approve;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        HaceCalculos
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        HaceCalculos
    end;

    trigger OnModifyRecord(): Boolean
    begin
        HaceCalculos
    end;

    trigger OnOpenPage()
    begin
        HaceCalculos
    end;

    var
        CabEntrenamiento: Record "Cab. Entrenamiento";
        Asistentesentrenamientos: Record "Asistentes entrenamientos";
        FuncEnt: Codeunit "Funciones entrenamientos";
        TotalInscritos: Integer;
        TotalAsistentes: Integer;
        Capacidad: Integer;

    local procedure HaceCalculos()
    begin
        TotalInscritos := 0;
        TotalAsistentes := 0;
        Capacidad := 0;

        Asistentesentrenamientos.Reset;
        Asistentesentrenamientos.SetRange("No. entrenamiento", Rec."No. entrenamiento");
        if Asistentesentrenamientos.FindSet then
            TotalInscritos := Asistentesentrenamientos.Count;

        Asistentesentrenamientos.Reset;
        Asistentesentrenamientos.SetRange("No. entrenamiento", Rec."No. entrenamiento");
        Asistentesentrenamientos.SetRange(Asistio, true);
        if Asistentesentrenamientos.FindSet then
            TotalAsistentes := Asistentesentrenamientos.Count;

        CabEntrenamiento.SetFilter("No. entrenamiento", Rec.GetFilter("No. entrenamiento"));
        CabEntrenamiento.FindFirst;
        Capacidad := CabEntrenamiento."Asistentes esperados";
    end;
}

#pragma implicitwith restore

