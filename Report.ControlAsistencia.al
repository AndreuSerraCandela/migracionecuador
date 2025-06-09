report 76366 "Control Asistencia"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ControlAsistencia.rdlc';

    dataset
    {
        dataitem("Cab. Planif. Evento"; "Cab. Planif. Evento")
        {
            RequestFilterFields = "Cod. Taller - Evento", Expositor, Secuencia, "Tipo Evento";
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cab__Planif__Evento__Cod__Taller___Evento_; "Cod. Taller - Evento")
            {
            }
            column(Cab__Planif__Evento__Tipo_Evento_; "Tipo Evento")
            {
            }
            column(Cab__Planif__Evento_Expositor; Expositor)
            {
            }
            column(Cab__Planif__Evento_Secuencia; Secuencia)
            {
            }
            column(informeCaption; informeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cab__Planif__Evento__Cod__Taller___Evento_Caption; FieldCaption("Cod. Taller - Evento"))
            {
            }
            column(Cab__Planif__Evento__Tipo_Evento_Caption; FieldCaption("Tipo Evento"))
            {
            }
            column(Cab__Planif__Evento_ExpositorCaption; FieldCaption(Expositor))
            {
            }
            column(Cab__Planif__Evento_SecuenciaCaption; FieldCaption(Secuencia))
            {
            }
            dataitem("Programac. Talleres y Eventos"; "Programac. Talleres y Eventos")
            {
                DataItemLink = "Cod. Taller - Evento" = FIELD ("Cod. Taller - Evento"), Expositor = FIELD (Expositor), Secuencia = FIELD (Secuencia);
                DataItemTableView = SORTING ("Cod. Taller - Evento", "Tipo Evento", "Tipo de Expositor", Expositor, "Fecha programacion", Secuencia);
                column(Programac__Talleres_y_Eventos__Fecha_programacion_; "Fecha programacion")
                {
                }
                column(Programac__Talleres_y_Eventos__Asistentes_esperados_; "Asistentes esperados")
                {
                }
                column(Programac__Talleres_y_Eventos__Hora_de_Inicio_; "Hora de Inicio")
                {
                }
                column(Programac__Talleres_y_Eventos__Hora_Final_; "Hora Final")
                {
                }
                column(Programac__Talleres_y_Eventos__Fecha_programacion_Caption; FieldCaption("Fecha programacion"))
                {
                }
                column(Programac__Talleres_y_Eventos__Asistentes_esperados_Caption; FieldCaption("Asistentes esperados"))
                {
                }
                column(Programac__Talleres_y_Eventos__Hora_de_Inicio_Caption; FieldCaption("Hora de Inicio"))
                {
                }
                column(Programac__Talleres_y_Eventos__Hora_Final_Caption; FieldCaption("Hora Final"))
                {
                }
                column(Programac__Talleres_y_Eventos_Cod__Taller___Evento; "Cod. Taller - Evento")
                {
                }
                column(Programac__Talleres_y_Eventos_Tipo_Evento; "Tipo Evento")
                {
                }
                column(Programac__Talleres_y_Eventos_Tipo_de_Expositor; "Tipo de Expositor")
                {
                }
                column(Programac__Talleres_y_Eventos_Expositor; Expositor)
                {
                }
                column(Programac__Talleres_y_Eventos_Secuencia; Secuencia)
                {
                }
                dataitem("Asistentes Talleres y Eventos"; "Asistentes Talleres y Eventos")
                {
                    DataItemLink = "Cod. Taller - Evento" = FIELD ("Cod. Taller - Evento"), "Cod. Expositor" = FIELD (Expositor), Secuencia = FIELD (Secuencia), "Fecha programacion" = FIELD ("Fecha programacion");
                    DataItemTableView = SORTING ("No. Solicitud", "Cod. Taller - Evento", "Cod. Expositor", Secuencia, "Cod. Docente");
                    column(Asistentes_Talleres_y_Eventos_Confirmado; Confirmado)
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos__Cod__Docente_; "Cod. Docente")
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos__Nombre_Docente_; "Nombre Docente")
                    {
                    }
                    column(FORMAT_Confirmado_; Format(Confirmado))
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_Asistio; Asistio)
                    {
                    }
                    column(FORMAT_Inscrito_; Format(Inscrito))
                    {
                    }
                    column(num_; num)
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_ConfirmadoCaption; FieldCaption(Confirmado))
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos__Cod__Docente_Caption; FieldCaption("Cod. Docente"))
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos__Nombre_Docente_Caption; FieldCaption("Nombre Docente"))
                    {
                    }
                    column(FORMAT_Confirmado_Caption; FORMAT_Confirmado_CaptionLbl)
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_AsistioCaption; FieldCaption(Asistio))
                    {
                    }
                    column(FORMAT_Inscrito_Caption; FORMAT_Inscrito_CaptionLbl)
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_No__Solicitud; "No. Solicitud")
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_Cod__Taller___Evento; "Cod. Taller - Evento")
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_Cod__Expositor; "Cod. Expositor")
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_Secuencia; Secuencia)
                    {
                    }
                    column(Asistentes_Talleres_y_Eventos_Fecha_programacion; "Fecha programacion")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        num += 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(num);
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                if "Cab. Planif. Evento".GetFilter("Cab. Planif. Evento"."Cod. Taller - Evento") = '' then
                    Error(Error001, "Cab. Planif. Evento".FieldCaption("Cab. Planif. Evento"."Cod. Taller - Evento"));
                if "Cab. Planif. Evento".GetFilter("Cab. Planif. Evento".Expositor) = '' then
                    Error(Error001, "Cab. Planif. Evento".FieldCaption("Cab. Planif. Evento".Expositor));
                if "Cab. Planif. Evento".GetFilter("Cab. Planif. Evento".Secuencia) = '' then
                    Error(Error001, "Cab. Planif. Evento".FieldCaption("Cab. Planif. Evento".Secuencia));
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        num: Integer;
        Error001: Label 'Se requiere introducir un valor de %1';
        informeCaptionLbl: Label 'Control Asistencia';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        FORMAT_Confirmado_CaptionLbl: Label 'Label1000000019';
        FORMAT_Inscrito_CaptionLbl: Label 'Label1000000029';
}

