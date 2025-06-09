page 76359 "Programac. Talleres y Eventos"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Programac. Talleres y Eventos";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Taller - Evento"; rec."Cod. Taller - Evento")
                {
                    Visible = false;
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                    Visible = false;
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                }
                field("Fecha de realizacion"; rec."Fecha de realizacion")
                {
                }
                field(Avisado; rec.Avisado)
                {
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                }
                field("Nro. De asistentes reales"; rec."Nro. De asistentes reales")
                {
                }
                field("Hora de Inicio"; rec."Hora de Inicio")
                {
                }
                field("Hora Final"; rec."Hora Final")
                {
                }
                field("Horas dictadas"; rec."Horas dictadas")
                {
                    Editable = false;
                }
                field("Horas Pedagógicas"; rec."Horas Pedagógicas")
                {
                }
                field(Expositor; rec.Expositor)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Nombre Expositor"; rec."Nombre Expositor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Fecha propuesta"; rec."Fecha propuesta")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Hora Inicio Propuesta"; rec."Hora Inicio Propuesta")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Hora Fin Propuesta"; rec."Hora Fin Propuesta")
                {
                    Editable = false;
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field(Observacion; rec.Observacion)
                {
                }
                field(Estado; rec.Estado)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Asistentes)
            {
                Caption = 'Asistentes';

                trigger OnAction()
                begin

                    Clear(pAsistentes);
                    rAsistentes.Reset;
                    rAsistentes.FilterGroup(2);
                    rAsistentes.SetRange("Cod. Taller - Evento", rec."Cod. Taller - Evento");
                    rAsistentes.SetRange("Tipo Evento", rec."Tipo Evento");
                    rAsistentes.SetRange(Secuencia, rec.Secuencia);
                    rAsistentes.SetRange("Cod. Expositor", rec.Expositor);
                    rAsistentes.SetRange(rAsistentes."No Linea Programac.", rec."No. Linea");
                    rAsistentes.FilterGroup(0);
                    pAsistentes.SetTableView(rAsistentes);
                    pAsistentes.RecibeProgEvento(rec."No. Linea");
                    pAsistentes.Run;
                end;
            }
        }
    }

    var
        rAsistentes: Record "Asistentes Talleres y Eventos";
        pAsistentes: Page "Asistentes Talleres y Eventos";
}

