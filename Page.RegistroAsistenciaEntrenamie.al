page 76374 "Registro Asistencia Entrenamie"
{
    ApplicationArea = all;
    Caption = 'Training Attendance Registration';
    PageType = List;
    SourceTable = "Cab. Entrenamiento";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cod. Instructor"; rec."Cod. Instructor")
                {
                    Editable = false;
                }
                field("Nombre Instructor"; rec."Nombre Instructor")
                {
                    Editable = false;
                }
                field("No. entrenamiento"; rec."No. entrenamiento")
                {
                    Editable = false;
                }
                field("Titulo entrenamiento"; rec."Titulo entrenamiento")
                {
                    Editable = false;
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
                {
                    Editable = false;
                }
                field(Disponible; rec.Disponible)
                {
                    Editable = false;
                }
                field(Sala; rec.Sala)
                {
                    Editable = false;
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                    Editable = false;
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                    Editable = false;
                }
                field(Lunes; rec.Lunes)
                {
                    Editable = false;
                }
                field(Martes; rec.Martes)
                {
                    Editable = false;
                }
                field(Miercoles; rec.Miercoles)
                {
                    Editable = false;
                }
                field(Jueves; rec.Jueves)
                {
                    Editable = false;
                }
                field(Viernes; rec.Viernes)
                {
                    Editable = false;
                }
                field(Sabados; rec.Sabados)
                {
                    Editable = false;
                }
                field(Domingos; rec.Domingos)
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(ContultaAsist; "Consulta Planif. Entrenamiento")
            {
                Caption = 'Training Attendance Registration';
                Editable = false;
                ShowFilter = false;
                SubPageLink = "No. entrenamiento" = FIELD ("No. entrenamiento"),
                              "Tipo entrenamiento" = FIELD ("Tipo entrenamiento"),
                              "Cod. Instructor" = FIELD ("Cod. Instructor");
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
                action("Register Assistants")
                {
                    Caption = 'Register Assistants';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //CurrPage.ConsultaPLanTyE.FORM.AbrirPagAsistentes;
                        /*
                        rCabPlanif.RESET;
                        rCabPlanif.FILTERGROUP(2);
                        rCabPlanif.SETRANGE(rCabPlanif."Cod. Taller - Evento","Cod. Taller - Evento");
                        rCabPlanif.SETRANGE(rCabPlanif.Expositor, Expositor);
                        rCabPlanif.SETRANGE(rCabPlanif.Secuencia, Secuencia);
                        rCabPlanif.FILTERGROUP(0);
                        IF "No. Solicitud" <> '' THEN BEGIN
                          pProgColegio.SETTABLEVIEW(rCabPlanif);
                          pProgColegio.RUNMODAL;
                        END
                        ELSE BEGIN
                          pProgEditorial.SETTABLEVIEW(rCabPlanif);
                          pProgEditorial.RUNMODAL;
                        END;
                        */


                        //CurrPage.ConsultaPLanTyE.FORM.GETRECORD("ProgT&E");
                        //MESSAGE('%1',aa);

                    end;
                }
            }
        }
    }
}

