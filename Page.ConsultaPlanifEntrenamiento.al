page 76157 "Consulta Planif. Entrenamiento"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Programacion entrenamiento";

    layout
    {
        area(content)
        {
            repeater(Control1000000011)
            {
                ShowCaption = false;
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                    Visible = false;
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                    Visible = false;
                }
                field("Fecha de realizacion"; rec."Fecha de realizacion")
                {
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                }
                field("Nro. De asistentes reales"; rec."Nro. De asistentes reales")
                {
                }
                field("Horas dictadas"; rec."Horas dictadas")
                {
                    Visible = false;
                }
                field(Secuencia; rec.Secuencia)
                {
                    Visible = false;
                }
                field(Estado; rec.Estado)
                {
                }
                field("Hora de Inicio"; rec."Hora de Inicio")
                {
                    Visible = false;
                }
                field("Hora Final"; rec."Hora Final")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

