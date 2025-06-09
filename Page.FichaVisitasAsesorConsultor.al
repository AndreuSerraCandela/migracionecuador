#pragma implicitwith disable
page 76229 "Ficha Visitas Asesor/Consultor"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Cab. Visita Asesor/Consultor";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = wMod;
                field("No. Visita Asesor/Consultor"; rec."No. Visita Asesor/Consultor")
                {
                    Caption = 'No. Visita';
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Hora Registro"; rec."Hora Registro")
                {
                }
                field("Usuario Registro"; rec."Usuario Registro")
                {
                }
                field("Cod. Asesor/Consultor"; rec."Cod. Asesor/Consultor")
                {
                }
                field("Nombre Asesor/Consultor"; rec."Nombre Asesor/Consultor")
                {
                }
                field("Tipo Visita"; rec."Tipo Visita")
                {

                    trigger OnValidate()
                    begin
                        ControlesTipoVisita;
                    end;
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                    Editable = wEditSolicitud;
                }
                field("Grupo Negocio"; rec."Grupo Negocio")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Dirección Colegio"; rec."Dirección Colegio")
                {
                }
                field("Distrito Colegio"; rec."Distrito Colegio")
                {
                }
                field("Teléfono 1 Colegio"; rec."Teléfono 1 Colegio")
                {
                }
                field("Teléfono 2 Colegio"; rec."Teléfono 2 Colegio")
                {
                }
                field("Delegación"; rec.Delegación)
                {
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("No. Asistentes Esperados"; rec."No. Asistentes Esperados")
                {
                }
                field("No. Asistentes Reales"; rec."No. Asistentes Reales")
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Fecha Próxima Visita"; rec."Fecha Próxima Visita")
                {
                }
                field("Cód. Objetivo Visita"; rec."Cód. Objetivo Visita")
                {
                }
                field("Desc. Objetivo Visita"; rec."Desc. Objetivo Visita")
                {
                }
                field("Comentarios Visita"; rec."Comentarios Visita")
                {
                }
            }
            group("Datos Contacto")
            {
                Caption = 'Datos Contacto';
                Editable = wMod;
                field("Tipo Persona Contacto"; rec."Tipo Persona Contacto")
                {

                    trigger OnValidate()
                    begin
                        ControlesCDS;
                    end;
                }
                field("Cod. Persona Contacto"; rec."Cod. Persona Contacto")
                {
                    Editable = wCDS;
                }
                field("Nombre Persona Contacto"; rec."Nombre Persona Contacto")
                {
                    Editable = NOT wCDS;
                }
                field("Cod. Cargo Persona Contacto"; rec."Cod. Cargo Persona Contacto")
                {
                    Editable = NOT wCDS;
                }
                field("Desc. Cargo Persona Contacto"; rec."Desc. Cargo Persona Contacto")
                {
                }
                field("Teléfono 1 Persona Contacto"; rec."Teléfono 1 Persona Contacto")
                {
                    Editable = NOT wCDS;
                }
                field("Teléfono 2 Persona Contacto"; rec."Teléfono 2 Persona Contacto")
                {
                    Editable = NOT wCDS;
                }
                field("E-mail Persona Contacto"; rec."E-mail Persona Contacto")
                {
                    Editable = NOT wCDS;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("<Action1000000038>")
            {
                Caption = 'Visita';
                action("Registrar fecha y horarios")
                {
                    Caption = 'Registrar fecha y horarios';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Prog. Visitas Asesor/Consultor";
                    RunPageLink = "No. Visita" = FIELD("No. Visita Asesor/Consultor");
                }
                action("&Assistance")
                {
                    Caption = '&Assistance';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        pAsistentes: Page "Visitas A/C - Selec. Docentes";
                        rProg: Record "Prog. Visitas Asesor/Consultor";
                        Err001: Label 'Antes de inscribir docentes, tiene que registrar las fechas y horario de la visita.';
                    begin
                        Rec.TestField("No. Visita Asesor/Consultor");
                        Rec.TestField("Cod. Colegio");

                        rProg.Reset;
                        rProg.SetRange(rProg."No. Visita", Rec."No. Visita Asesor/Consultor");
                        if not rProg.FindFirst then
                            Error(Err001);
                        pAsistentes.RecibeParametros(Rec."No. Visita Asesor/Consultor", Rec."Cod. Colegio", '');
                        pAsistentes.Run;
                        Clear(pAsistentes);
                    end;
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
                        GpoNegDistrib: Page "Visitas A/C - Grupos Negocio";
                    begin
                        Rec.TestField("No. Visita Asesor/Consultor");
                        Rec.TestField("Cod. Colegio");
                        GpoNegDistrib.RecibeParametros(Rec."No. Visita Asesor/Consultor", Rec.Estado = Rec.Estado::Programada);
                        GpoNegDistrib.RunModal;
                    end;
                }
                action("Nivel Asistente")
                {
                    Caption = 'Nivel Asistente';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Visita A/C - Descr. Asistentes";
                    RunPageLink = "No. Visita" = FIELD("No. Visita Asesor/Consultor"),
                                  Tipo = CONST(Nivel);
                }
                action("Grado Asistente")
                {
                    Caption = 'Grado Asistente';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Visita A/C - Descr. Asistentes";
                    RunPageLink = "No. Visita" = FIELD("No. Visita Asesor/Consultor"),
                                  Tipo = CONST(Grado);
                }
                action("Especialidad Asistente")
                {
                    Caption = 'Especialidad Asistente';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Visita A/C - Descr. Asistentes";
                    RunPageLink = "No. Visita" = FIELD("No. Visita Asesor/Consultor"),
                                  Tipo = CONST(Especialidad);
                }
                action(Ranking)
                {
                    Caption = 'Ranking';
                    Image = ResourcePrice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        pgRanking: Page "Ranking CVM";
                    begin
                        Rec.TestField("Cod. Colegio");
                        pgRanking.CalcularRanking(Rec."Cod. Colegio");
                        pgRanking.Run;
                        Clear(pgRanking);
                    end;
                }
                action("Ejecutar Visita")
                {
                    Caption = 'Ejecutar Visita';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = wCambEstado;

                    trigger OnAction()
                    begin

                        Rec.TestField("Cod. Colegio");
                        Rec.TestField("Cod. promotor");
                        Rec.TestField("Cod. Asesor/Consultor");

                        ValidaDistrCC;

                        ValidaFechaHorarios;

                        Rec.Estado := Rec.Estado::Ejecutada;

                        ActControles;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ActControles;
    end;

    var
        wCambEstado: Boolean;
        wMod: Boolean;
        wCDS: Boolean;
        wEditSolicitud: Boolean;


    procedure ActControles()
    begin

        wMod := true;
        if Rec.Estado = Rec.Estado::Ejecutada then
            wMod := false;

        wCambEstado := false;
        if Rec.Estado = Rec.Estado::Programada then
            wCambEstado := true;

        ControlesCDS;

        ControlesTipoVisita;
    end;


    procedure ValidaDistrCC()
    var
        Distr: Record "Visitas A/C-Dis. Centros Costo";
        Err001: Label 'Debe realizar la distribución de los centros de costo';
        Err002: Label 'No se ha realizado la distribución de los centros de costo correctamente';
        Porc: Decimal;
    begin

        Distr.SetRange(Distr."No. Visita Consultor/Asesor", Rec."No. Visita Asesor/Consultor");
        if not Distr.FindSet then
            Error(Err001);

        repeat
            Porc += Distr.Porcentaje;
        until Distr.Next = 0;

        if Porc <> 100 then
            Error(Err002);
    end;


    procedure ValidaFechaHorarios()
    var
        rProg: Record "Prog. Visitas Asesor/Consultor";
        rProg2: Record "Prog. Visitas Asesor/Consultor";
        Err001: Label 'No se ha realizado el registro de fechas y horario de visitas.';
        Err002: Label 'Revise el registro de fechas y horario de visitas. No se permite solapamientos.';
        Err003: Label 'Revise el registro de fechas y horario de visitas. Es obligatorio ingresar la fecha, hora de inicio y hora fin.';
    begin

        rProg.SetRange(rProg."No. Visita", Rec."No. Visita Asesor/Consultor");
        if not rProg.FindSet then
            Error(Err001);
        repeat

            if (rProg."Fecha Programada" = 0D) or (rProg."Hora Inicio Programada" = 0T) or (rProg."Hora Fin Programada" = 0T) then
                Error(Err003);

            rProg2.Reset;
            rProg2.SetRange("No. Visita", rProg."No. Visita");
            rProg2.SetFilter("No. Linea", '<>%1', rProg."No. Linea");
            rProg2.SetRange("Fecha Programada", rProg."Fecha Programada");
            rProg2.SetFilter("Hora Inicio Programada", '<%1', rProg."Hora Fin Programada");
            rProg2.SetFilter("Hora Fin Programada", '>%1', rProg."Hora Inicio Programada");
            if rProg2.FindSet then
                Error(Err002);

        until rProg.Next = 0;
    end;


    procedure ControlesCDS()
    begin

        wCDS := false;
        if Rec."Tipo Persona Contacto" = Rec."Tipo Persona Contacto"::CDS then
            wCDS := true;
    end;


    procedure ControlesTipoVisita()
    begin

        wEditSolicitud := false;
        if Rec."Tipo Visita" = Rec."Tipo Visita"::Solicitada then
            wEditSolicitud := true;
    end;


    procedure Act_AsistentesReales()
    var
        rAsis: Record "Asis. Visitas Asesor/Consultor";
        Asist: Integer;
    begin
        /*
        Asist := 0;
        IF "No. Visita Asesor/Consultor" <> '' THEN BEGIN
          rAsis.SETRANGE("No. Visita","No. Visita Asesor/Consultor");
         "No. Asistentes Reales" := rAsis.COUNT;
        END;
        */

    end;
}

#pragma implicitwith restore

