page 76133 "Colegio - Adopciones"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Historico Adopciones";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Campana; rec.Campana)
                {
                }
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Cod. producto"; rec."Cod. producto")
                {
                }
                field(Seccion; rec.Seccion)
                {
                }
                field("Cod. Equiv. Santillana"; rec."Cod. Equiv. Santillana")
                {
                }
                field("Descripcion Equiv. Santillana"; rec."Descripcion Equiv. Santillana")
                {
                }
                field("Nombre Editorial"; rec."Nombre Editorial")
                {
                }
                field("Nombre Libro"; rec."Nombre Libro")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                }
                field("Descripcion Grado"; rec."Descripcion Grado")
                {
                }
                field("Fecha Adopcion"; rec."Fecha Adopcion")
                {
                }
                field("Cantidad Alumnos"; rec."Cantidad Alumnos")
                {
                }
                field("% Dto. Padres de familia"; rec."% Dto. Padres de familia")
                {
                }
                field("% Dto. Colegio"; rec."% Dto. Colegio")
                {
                }
                field("% Dto. Docente"; rec."% Dto. Docente")
                {
                }
                field("% Dto. Feria Padres de familia"; rec."% Dto. Feria Padres de familia")
                {
                }
                field("% Dto. Feria Colegio"; rec."% Dto. Feria Colegio")
                {
                }
                field("Cod. Motivo perdida adopcion"; rec."Cod. Motivo perdida adopcion")
                {
                }
                field("Cod. Libro Equivalente"; rec."Cod. Libro Equivalente")
                {
                }
                field("Adopciones Camp. Anterior"; rec."Adopciones Camp. Anterior")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                }
                field(Adopcion; rec.Adopcion)
                {
                }
                field("Adopcion anterior"; rec."Adopcion anterior")
                {
                }
                field(Santillana; rec.Santillana)
                {
                }
                field("Ano adopcion"; rec."Ano adopcion")
                {
                }
                field("Item - Item Category Code"; rec."Item - Item Category Code")
                {
                }
                field("Item - Product Group Code"; rec."Item - Product Group Code")
                {
                }
                field("Item - Grado"; rec."Item - Grado")
                {
                }
            }
        }
    }

    actions
    {
    }
}

