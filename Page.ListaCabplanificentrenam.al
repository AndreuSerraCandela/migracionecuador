page 76273 "Lista Cab. planific.  entrenam"
{
    ApplicationArea = all;
    Caption = 'Training schedule list';
    CardPageID = "Cab. Planif. Entrenamiento";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Entrenamiento";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. entrenamiento"; rec."No. entrenamiento")
                {
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
                {
                }
                field("Titulo entrenamiento"; rec."Titulo entrenamiento")
                {
                }
                field("Tipo de Instructor"; rec."Tipo de Instructor")
                {
                }
                field("Cod. Instructor"; rec."Cod. Instructor")
                {
                }
                field("Nombre Instructor"; rec."Nombre Instructor")
                {
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                }
                field(Lunes; rec.Lunes)
                {
                }
                field(Martes; rec.Martes)
                {
                }
                field(Miercoles; rec.Miercoles)
                {
                }
                field(Jueves; rec.Jueves)
                {
                }
                field(Viernes; rec.Viernes)
                {
                }
                field(Sabados; rec.Sabados)
                {
                }
                field(Domingos; rec.Domingos)
                {
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                }
                field("Total registrados"; rec."Total registrados")
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("No. serie"; rec."No. serie")
                {
                }
                field("Asistentes reales"; rec."Asistentes reales")
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
        area(factboxes)
        {
            part(Control1000000005; "Asist. Ent - Empleados Factbox")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No. entrenamiento" = FIELD ("No. entrenamiento"),
                              Inscrito = CONST (true);
            }
        }
    }

    actions
    {
    }
}

