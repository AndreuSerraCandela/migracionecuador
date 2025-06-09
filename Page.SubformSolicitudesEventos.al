page 76407 "Subform Solicitudes Eventos"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Solicitud de Taller - Evento";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Cod. evento"; rec."Cod. evento")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Expositor"; rec."Cod. Expositor")
                {
                }
                field(Sala; rec.Sala)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Fecha Solicitud"; rec."Fecha Solicitud")
                {
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                }
                field("Telefono 1 Colegio"; rec."Telefono 1 Colegio")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Asistentes Esperados"; rec."Asistentes Esperados")
                {
                }
                field(Observaciones; rec.Observaciones)
                {
                }
                field("Cod. Docente responsable"; rec."Cod. Docente responsable")
                {
                }
                field("Nombre responsable"; rec."Nombre responsable")
                {
                }
                field("No. celular responsable"; rec."No. celular responsable")
                {
                }
                field("Objetivo promotor"; rec."Objetivo promotor")
                {
                }
                field("Descripcion evento"; rec."Descripcion evento")
                {
                }
                field("Evento programado"; rec."Evento programado")
                {
                }
                field("Fecha invitacion"; rec."Fecha invitacion")
                {
                }
                field("Horas programadas"; rec."Horas programadas")
                {
                }
                field("Asistentes Reales"; rec."Asistentes Reales")
                {
                }
                field("Eventos programados"; rec."Eventos programados")
                {
                }
                field("Importe Gasto Expositor"; rec."Importe Gasto Expositor")
                {
                }
                field("Importe Gasto mensajeria"; rec."Importe Gasto mensajeria")
                {
                }
                field("ImporteGastos Impresion"; rec."ImporteGastos Impresion")
                {
                }
                field("Importe Utiles"; rec."Importe Utiles")
                {
                }
                field("Importe Atenciones"; rec."Importe Atenciones")
                {
                }
                field("Otros Importes"; rec."Otros Importes")
                {
                }
                field("No. Series"; rec."No. Series")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

