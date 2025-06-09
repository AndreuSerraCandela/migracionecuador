report 76219 "Solicitud asi. tec. pedagogica"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Solicitudasitecpedagogica.rdlc';
    Caption = 'Solicitud de asistencia técnica pedagogica';

    dataset
    {
        dataitem(Solicitud; "Solicitud de Taller - Evento")
        {
            DataItemTableView = SORTING("No. Solicitud");
            RequestFilterFields = "No. Solicitud";
            column(USERID; UserId)
            {
            }

            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Solicitud_Observaciones; Observaciones)
            {
            }
            column(Solicitud__Tipo_de_Evento_; "Tipo de Evento")
            {
            }
            column(Solicitud__Cod__evento_; "Cod. evento")
            {
            }
            column(Solicitud_Descripcion; Descripcion)
            {
            }
            column(Solicitud__Cod__Expositor_; "Cod. Expositor")
            {
            }
            column(Solicitud__Nombre_expositor_; "Nombre expositor")
            {
            }
            column(Solicitud__No__Solicitud_; "No. Solicitud")
            {
            }
            column(Solicitud__Fecha_Solicitud_; "Fecha Solicitud")
            {
            }
            column(TraerDescripcionTipoEvento; TraerDescripcionTipoEvento)
            {
            }
            column(Solicitud__No__asistentes_; "Asistentes Esperados")
            {
            }
            column(Solicitud__Cod__promotor_; "Cod. promotor")
            {
            }
            column(Solicitud__Nombre_promotor_; "Nombre promotor")
            {
            }
            column(Solicitud_Status; Status)
            {
            }
            column(Solicitud__Cod__Colegio_; "Cod. Colegio")
            {
            }
            column(Solicitud__Nombre_Colegio_; "Nombre Colegio")
            {
            }
            column(TraerDescripcionLocal; TraerDescripcionLocal)
            {
            }
            column(TraerDescripcionTurno; TraerDescripcionTurno)
            {
            }
            column(Solicitud_Referencia; Referencia)
            {
            }
            column(Solicitud__Cod__Docente_responsable_; "Cod. Docente responsable")
            {
            }
            column(Solicitud__Nombre_responsable_; "Nombre responsable")
            {
            }
            column(Phone_Docente_________Cell_Docente_; "Telefono Responsable" + ', ' + "Celular Responsable")
            {
            }
            column(Solicitud__Objetivo_promotor_; "Objetivo promotor")
            {
            }
            column(texDistrito; texDistrito)
            {
            }
            column(Solicitud__Cod__Nivel_; "Cod. Nivel")
            {
            }
            column(texDireccion; texDireccion)
            {
            }
            column(Telefono_________No__celular_; "Telefono 1 Colegio" + ', ' + "No. celular responsable")
            {
            }
            column(Solicitud_Delegacion; Delegacion)
            {
            }
            column("Solicitud_de_aistencia_técnica_pedagógicaCaption"; Solicitud_de_aistencia_técnica_pedagógicaCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Solicitud__Tipo_de_Evento_Caption; Solicitud__Tipo_de_Evento_CaptionLbl)
            {
            }
            column(ObservacionesCaption; ObservacionesCaptionLbl)
            {
            }
            column(Datos_del_responsableCaption; Datos_del_responsableCaptionLbl)
            {
            }
            column(Datos_del_colegioCaption; Datos_del_colegioCaptionLbl)
            {
            }
            column(Datos_del_promotorCaption; Datos_del_promotorCaptionLbl)
            {
            }
            column(Solicitud__Cod__evento_Caption; Solicitud__Cod__evento_CaptionLbl)
            {
            }
            column(Solicitud__Cod__Expositor_Caption; Solicitud__Cod__Expositor_CaptionLbl)
            {
            }
            column(Datos_del_eventoCaption; Datos_del_eventoCaptionLbl)
            {
            }
            column(Datos_de_solicitudCaption; Datos_de_solicitudCaptionLbl)
            {
            }
            column(Solicitud__No__Solicitud_Caption; Solicitud__No__Solicitud_CaptionLbl)
            {
            }
            column(Solicitud__Fecha_Solicitud_Caption; Solicitud__Fecha_Solicitud_CaptionLbl)
            {
            }
            column(Solicitud__No__asistentes_Caption; Solicitud__No__asistentes_CaptionLbl)
            {
            }
            column(Solicitud__Cod__promotor_Caption; Solicitud__Cod__promotor_CaptionLbl)
            {
            }
            column(Solicitud__Nombre_promotor_Caption; Solicitud__Nombre_promotor_CaptionLbl)
            {
            }
            column(Solicitud_StatusCaption; Solicitud_StatusCaptionLbl)
            {
            }
            column(Solicitud__Cod__Colegio_Caption; Solicitud__Cod__Colegio_CaptionLbl)
            {
            }
            column(Solicitud__Nombre_Colegio_Caption; Solicitud__Nombre_Colegio_CaptionLbl)
            {
            }
            column(TraerDescripcionLocalCaption; TraerDescripcionLocalCaptionLbl)
            {
            }
            column(TraerDescripcionTurnoCaption; TraerDescripcionTurnoCaptionLbl)
            {
            }
            column(Solicitud_ReferenciaCaption; Solicitud_ReferenciaCaptionLbl)
            {
            }
            column(Solicitud__Cod__Docente_responsable_Caption; Solicitud__Cod__Docente_responsable_CaptionLbl)
            {
            }
            column(Solicitud__Nombre_responsable_Caption; Solicitud__Nombre_responsable_CaptionLbl)
            {
            }
            column(Phone_Docente_________Cell_Docente_Caption; Phone_Docente_________Cell_Docente_CaptionLbl)
            {
            }
            column(Solicitud__Objetivo_promotor_Caption; Solicitud__Objetivo_promotor_CaptionLbl)
            {
            }
            column("Descripción_Caption"; Descripción_CaptionLbl)
            {
            }
            column(texDistritoCaption; texDistritoCaptionLbl)
            {
            }
            column(Solicitud__Cod__Nivel_Caption; Solicitud__Cod__Nivel_CaptionLbl)
            {
            }
            column(texDireccionCaption; texDireccionCaptionLbl)
            {
            }
            column(Telefono_________No__celular_Caption; Telefono_________No__celular_CaptionLbl)
            {
            }
            column(Solicitud_DelegacionCaption; Solicitud_DelegacionCaptionLbl)
            {
            }
            dataitem(Programacion; "Programac. Talleres y Eventos")
            {
                DataItemLink = "Tipo Evento" = FIELD("Tipo de Evento"), "Cod. Taller - Evento" = FIELD("Cod. evento");
                DataItemTableView = SORTING("Cod. Taller - Evento", "Tipo Evento", "Tipo de Expositor", Expositor, "Fecha programacion", Secuencia);
                column(Programacion__Fecha_programacion_; "Fecha programacion")
                {
                }
                column(Programacion__Hora_de_Inicio_; "Hora de Inicio")
                {
                }
                column(Programacion__Hora_Final_; "Hora Final")
                {
                }
                column(Programacion__Hora_Final_Caption; FieldCaption("Hora Final"))
                {
                }
                column(Programacion__Hora_de_Inicio_Caption; FieldCaption("Hora de Inicio"))
                {
                }
                column(Programacion__Fecha_programacion_Caption; Programacion__Fecha_programacion_CaptionLbl)
                {
                }
                column(HorarioCaption; HorarioCaptionLbl)
                {
                }
                column(Programacion_Cod__Taller___Evento; "Cod. Taller - Evento")
                {
                }
                column(Programacion_Tipo_Evento; "Tipo Evento")
                {
                }
                column(Programacion_Tipo_de_Expositor; "Tipo de Expositor")
                {
                }
                column(Programacion_Expositor; Expositor)
                {
                }
                column(Programacion_Secuencia; Secuencia)
                {
                }
            }
            dataitem(Asistentes; "Asistentes Talleres y Eventos")
            {
                DataItemLink = "Tipo Evento" = FIELD("Tipo de Evento"), "Cod. Taller - Evento" = FIELD("Cod. evento");
                DataItemTableView = SORTING("No. Solicitud", "Cod. Taller - Evento", "Cod. Expositor", Secuencia, "Cod. Docente");
                column(Asistentes__Cod__Docente_; "Cod. Docente")
                {
                }
                column(Asistentes__Nombre_Docente_; "Nombre Docente")
                {
                }
                column(TraerNivelDocente; TraerNivelDocente)
                {
                }
                column(AsistentesCaption; AsistentesCaptionLbl)
                {
                }
                column(Asistentes__Cod__Docente_Caption; Asistentes__Cod__Docente_CaptionLbl)
                {
                }
                column(Asistentes__Nombre_Docente_Caption; Asistentes__Nombre_Docente_CaptionLbl)
                {
                }
                column(TraerNivelDocenteCaption; TraerNivelDocenteCaptionLbl)
                {
                }
                column(Asistentes_No__Solicitud; "No. Solicitud")
                {
                }
                column(Asistentes_Cod__Taller___Evento; "Cod. Taller - Evento")
                {
                }
                column(Asistentes_Cod__Expositor; "Cod. Expositor")
                {
                }
                column(Asistentes_Secuencia; Secuencia)
                {
                }
                column(Asistentes_Fecha_programacion; "Fecha programacion")
                {
                }
                column(Asistentes_Tipo_Evento; "Tipo Evento")
                {
                }
            }
            dataitem(Material; "Materiales Talleres y Eventos")
            {
                DataItemLink = "Tipo Evento" = FIELD("Tipo de Evento"), "Cod. Taller - Evento" = FIELD("Cod. evento");
                DataItemTableView = SORTING("Cod. Taller - Evento", "Tipo Evento", Secuencia, "Line no.") WHERE("Tipo de Material" = CONST(Producto));
                column(Material__Codigo_Material_; "Codigo Material")
                {
                }
                column(Material__Description_Material_; "Description Material")
                {
                }
                column(TraerGradoMaterial; TraerGradoMaterial)
                {
                }
                column(Material__Description_Material_Caption; Material__Description_Material_CaptionLbl)
                {
                }
                column(Material__Codigo_Material_Caption; Material__Codigo_Material_CaptionLbl)
                {
                }
                column(GradoCaption; GradoCaptionLbl)
                {
                }
                column(MaterialCaption; MaterialCaptionLbl)
                {
                }
                column(Material_Cod__Taller___Evento; "Cod. Taller - Evento")
                {
                }
                column(Material_Tipo_Evento; "Tipo Evento")
                {
                }
                column(Material_Secuencia; Secuencia)
                {
                }
                column(Material_Line_no_; "Line no.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(texDistrito);
                Clear(texDireccion);

                if recColegio.Get("Cod. Colegio") then begin
                    texDistrito := recColegio.Distritos;
                    texDireccion := recColegio.Address + ' ' + recColegio."Address 2";
                end;
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
        PageConst: Label 'Pág.';
        recColegio: Record Contact;
        texDistrito: Text[100];
        texDireccion: Text[250];
        "Solicitud_de_aistencia_técnica_pedagógicaCaptionLbl": Label 'Solicitud de Asistencia Técnica Pedagógica';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        Solicitud__Tipo_de_Evento_CaptionLbl: Label 'Tipo Evento:';
        ObservacionesCaptionLbl: Label 'Observaciones';
        Datos_del_responsableCaptionLbl: Label 'Datos del responsable';
        Datos_del_colegioCaptionLbl: Label 'Datos del colegio';
        Datos_del_promotorCaptionLbl: Label 'Datos del promotor';
        Solicitud__Cod__evento_CaptionLbl: Label 'Código:';
        Solicitud__Cod__Expositor_CaptionLbl: Label 'Expositor:';
        Datos_del_eventoCaptionLbl: Label 'Datos del evento';
        Datos_de_solicitudCaptionLbl: Label 'Datos de solicitud';
        Solicitud__No__Solicitud_CaptionLbl: Label 'Nº Solicitud:';
        Solicitud__Fecha_Solicitud_CaptionLbl: Label 'Fecha:';
        Solicitud__No__asistentes_CaptionLbl: Label 'Asistentes esperados:';
        Solicitud__Cod__promotor_CaptionLbl: Label 'Código:';
        Solicitud__Nombre_promotor_CaptionLbl: Label 'Nombre:';
        Solicitud_StatusCaptionLbl: Label 'Estado:';
        Solicitud__Cod__Colegio_CaptionLbl: Label 'Código:';
        Solicitud__Nombre_Colegio_CaptionLbl: Label 'Nombre:';
        TraerDescripcionLocalCaptionLbl: Label 'Local:';
        TraerDescripcionTurnoCaptionLbl: Label 'Turno:';
        Solicitud_ReferenciaCaptionLbl: Label 'Referencia:';
        Solicitud__Cod__Docente_responsable_CaptionLbl: Label 'Código:';
        Solicitud__Nombre_responsable_CaptionLbl: Label 'Nombre:';
        Phone_Docente_________Cell_Docente_CaptionLbl: Label 'Teléfono:';
        Solicitud__Objetivo_promotor_CaptionLbl: Label 'Objetivo:';
        "Descripción_CaptionLbl": Label 'Descripción:';
        texDistritoCaptionLbl: Label 'Distrito:';
        Solicitud__Cod__Nivel_CaptionLbl: Label 'Nivel:';
        texDireccionCaptionLbl: Label 'Dirección:';
        Telefono_________No__celular_CaptionLbl: Label 'Teléfono:';
        Solicitud_DelegacionCaptionLbl: Label 'Delegación:';
        Programacion__Fecha_programacion_CaptionLbl: Label 'Fecha prog.';
        HorarioCaptionLbl: Label 'Horario';
        AsistentesCaptionLbl: Label 'Asistentes';
        Asistentes__Cod__Docente_CaptionLbl: Label 'Cód. Docente';
        Asistentes__Nombre_Docente_CaptionLbl: Label 'Nombre';
        TraerNivelDocenteCaptionLbl: Label 'Nivel';
        Material__Description_Material_CaptionLbl: Label 'Descriptión';
        Material__Codigo_Material_CaptionLbl: Label 'Código';
        GradoCaptionLbl: Label 'Grado';
        MaterialCaptionLbl: Label 'Material';


    procedure TraerGradoMaterial(): Code[20]
    var
        recProducto: Record Item;
    begin
        if Material."Tipo de Material" = Material."Tipo de Material"::Producto then
            if recProducto.Get(Material."Codigo Material") then
                exit(recProducto."Nivel Escolar (Grado)");
    end;


    procedure TraerDescripcionTurno(): Text[100]
    var
        recTurno: Record "Datos auxiliares";
    begin
        if recTurno.Get(recTurno."Tipo registro"::Turnos, Solicitud."Cod. Turno") then
            exit(recTurno.Descripcion);
    end;


    procedure TraerDescripcionLocal(): Text[250]
    var
        recLocal: Record "Contact Alt. Address";
    begin
        if recLocal.Get(Solicitud."Cod. Colegio", Solicitud."Cod. Local") then
            exit(recLocal.Code + ' - ' + recLocal."Company Name" + ' - ' + recLocal.Address + ' - ' + recLocal.City);
    end;


    procedure TraerDescripcionNivel(): Text[100]
    var
        recNivel: Record "Nivel Educativo APS";
    begin
        if recNivel.Get(Solicitud."Cod. Nivel") then
            exit(recNivel.Descripción);
    end;


    procedure TraerDescripcionTipoEvento(): Text[100]
    var
        recTipoEvento: Record "Tipos de Eventos";
    begin
        if recTipoEvento.Get(Solicitud."Tipo de Evento") then
            exit(recTipoEvento.Descripcion);
    end;


    procedure TraerNivelDocente(): Text[100]
    var
        recDocente: Record Docentes;
        recNivel: Record "Nivel Educativo APS";
    begin
        if recDocente.Get(Asistentes."Cod. Docente") then
            if recNivel.Get(recDocente."Nivel Docente") then
                exit(recNivel.Descripción);
    end;
}

