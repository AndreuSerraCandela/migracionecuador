page 76266 "Lin. Entrenamientos"
{
    ApplicationArea = all;
    Caption = 'Training lines';
    PageType = ListPart;
    SourceTable = "Lin. entrenamientos";

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
                field(Disponible; rec.Disponible)
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
                    Visible = false;
                }
                field(Avisado; rec.Avisado)
                {
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field("Fecha programacion"; rec."Fecha programacion")
                {
                }
                field("Nro. De asistentes reales"; rec."Nro. De asistentes reales")
                {
                }
                field(Observacion; rec.Observacion)
                {
                }
                field(Objetivo; rec.Objetivo)
                {
                }
                field("Descripcion observacion"; rec."Descripcion observacion")
                {
                }
                field(Secuencia; rec.Secuencia)
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Hora de Inicio"; rec."Hora de Inicio")
                {
                }
                field("Hora Final"; rec."Hora Final")
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Asistentes)
                {
                    Caption = 'Attendees';
                    Image = ContactPerson;
                    RunObject = Page "Asistentes entrenamientos";
                    RunPageLink = "No. entrenamiento" = FIELD("No. entrenamiento"),
                                  "Fecha programacion" = FIELD("Fecha programacion");
                }
            }
        }
    }

    var
        AsistentesEnt: Record "Asistentes entrenamientos";
        pAsistentesEnt: Page "Asistentes entrenamientos";
}

