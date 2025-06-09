report 76086 "Control tipo evento x Fecha"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ControltipoeventoxFecha.rdlc';

    dataset
    {
        dataitem(Eventos; "Programac. Talleres y Eventos")
        {
            DataItemTableView = SORTING("Fecha programacion", "Cod. Colegio");
            RequestFilterFields = "Cod. Colegio", "Fecha programacion", "Cod. Promotor", Expositor, "Tipo Evento";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Eventos__Fecha_programacion_; "Fecha programacion")
            {
            }
            column(Eventos__Nombre_Colegio_; "Nombre Colegio")
            {
            }
            column(Eventos__Tipo_Evento_; "Tipo Evento")
            {
            }
            column(Eventos__Description_Taller_; "Description Taller")
            {
            }
            column(TraerNombreExpositor; TraerNombreExpositor)
            {
            }
            column(Eventos__Nombre_Promotor_; "Nombre Promotor")
            {
            }
            column(TraerHoras; TraerHoras)
            {
            }
            column(Eventos__Asistentes_esperados_; "Asistentes esperados")
            {
            }
            column(Eventos__Nro__De_asistentes_reales_; "Nro. De asistentes reales")
            {
            }
            column(Eventos_Secuencia; intSecuencia)
            {
            }
            column(TraerDistrito; TraerDistrito)
            {
            }
            column(Eventos_Avisado; FormatCheckMark(Avisado))
            {
            }
            column(TraerTieneEquipo; FormatCheckMark(TraerTieneEquipo))
            {
            }
            column(intTotalEsperados; intTotalEsperados)
            {
            }
            column(intTotalReal; intTotalReal)
            {
            }
            column(Programac__Talleres_y_EventosCaption; Programac__Talleres_y_EventosCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Eventos__Fecha_programacion_Caption; FieldCaption("Nombre Colegio"))
            {
            }
            column(Eventos__Tipo_Evento_Caption; Eventos__Tipo_Evento_CaptionLbl)
            {
            }
            column(Eventos__Description_Taller_Caption; Eventos__Description_Taller_CaptionLbl)
            {
            }
            column(TraerNombreExpositorCaption; TraerNombreExpositorCaptionLbl)
            {
            }
            column(Eventos__Nombre_Promotor_Caption; FieldCaption("Nombre Promotor"))
            {
            }
            column(TraerHorasCaption; TraerHorasCaptionLbl)
            {
            }
            column(Avis_Caption; Avis_CaptionLbl)
            {
            }
            column(Espe_Caption; Espe_CaptionLbl)
            {
            }
            column(RealCaption; RealCaptionLbl)
            {
            }
            column(AsistentesCaption; AsistentesCaptionLbl)
            {
            }
            column(DistritoCaption; DistritoCaptionLbl)
            {
            }
            column(Equi_Caption; Equi_CaptionLbl)
            {
            }
            column(Eventos__Cod__Colegio_Caption; Eventos__Cod__Colegio_CaptionLbl)
            {
            }
            column(TOTAL_Caption; TOTAL_CaptionLbl)
            {
            }
            column(Eventos_Cod__Taller___Evento; "Cod. Taller - Evento")
            {
            }
            column(Eventos_Tipo_de_Expositor; "Tipo de Expositor")
            {
            }
            column(Eventos_Expositor; Expositor)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if "Fecha programacion" <> datFecha then begin
                    Clear(intTotalEsperados);
                    Clear(intTotalReal);
                    Clear(intSecuencia);
                    datFecha := "Fecha programacion";
                end;

                intTotalEsperados += Eventos."Asistentes esperados";
                intTotalReal += Eventos."Nro. De asistentes reales";

                intSecuencia += 1;
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
        datFecha: Date;
        intTotalEsperados: Integer;
        intTotalReal: Integer;
        intSecuencia: Integer;
        Programac__Talleres_y_EventosCaptionLbl: Label 'Control tipo evento';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        Eventos__Tipo_Evento_CaptionLbl: Label 'Tipo Ev.';
        Eventos__Description_Taller_CaptionLbl: Label 'Descripción';
        TraerNombreExpositorCaptionLbl: Label 'Nombre Expositor';
        TraerHorasCaptionLbl: Label 'Starting date';
        Avis_CaptionLbl: Label 'Avis.';
        Espe_CaptionLbl: Label 'Espe.';
        RealCaptionLbl: Label 'Real';
        AsistentesCaptionLbl: Label 'Asistentes';
        DistritoCaptionLbl: Label 'Distrito';
        Equi_CaptionLbl: Label 'Equi.';
        Eventos__Cod__Colegio_CaptionLbl: Label 'Fecha programación:';
        TOTAL_CaptionLbl: Label 'TOTAL:';


    procedure TraerNombreExpositor(): Text[100]
    var
        recDocente: Record Docentes;
        recVendor: Record Vendor;
    begin
        case Eventos."Tipo de Expositor" of
            Eventos."Tipo de Expositor"::Docente:
                begin
                    if recDocente.Get(Eventos.Expositor) then
                        exit(recDocente."Full Name");
                end;
            Eventos."Tipo de Expositor"::Proveedor:
                begin
                    if recVendor.Get(Eventos.Expositor) then
                        exit(recVendor.Name);
                end;
        end;
    end;


    procedure TraerHoras(): Text[60]
    begin
        if (Eventos."Hora de Inicio" <> 0T) or (Eventos."Hora Final" <> 0T) then
            exit(Format(Eventos."Hora de Inicio", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>') + ' A ' +
                 Format(Eventos."Hora Final", 0, '<Hours24,2><Filler Character,0>:<Minutes,2>'));
    end;


    procedure TraerDistrito(): Text[30]
    var
        recColegio: Record Contact;
    begin
        if recColegio.Get(Eventos."Cod. Colegio") then
            exit(recColegio.Distritos);
    end;


    procedure TraerTieneEquipo(): Boolean
    var
        recEquipo: Record "Equipos Talleres y Eventos";
    begin
        recEquipo.Reset;
        recEquipo.SetRange("Cod. Taller - Evento", Eventos."Cod. Taller - Evento");
        recEquipo.SetRange("Tipo Evento", Eventos."Tipo Evento");
        recEquipo.SetRange(Secuencia, Eventos.Secuencia);
        exit(recEquipo.FindFirst);
    end;


    procedure FormatCheckMark(blnPrmEntrada: Boolean): Text[2]
    begin
        if blnPrmEntrada then
            exit('ü');
    end;
}

