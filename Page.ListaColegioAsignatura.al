page 76275 "Lista Colegio - Asignatura"
{
    ApplicationArea = all;
    DataCaptionFields = "Codigo Colegio", "Descripcion Colegio";
    PageType = Card;
    SourceTable = "Datos Colegio - Asignatura";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Codigo Colegio"; rec."Codigo Colegio")
                {
                    Visible = false;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. local"; rec."Cod. local")
                {
                }
                field("Cod. Docente"; rec."Cod. Docente")
                {
                }
                field("Descripcion Colegio"; rec."Descripcion Colegio")
                {
                    Visible = false;
                }
                field("Nombre docente"; rec."Nombre docente")
                {
                }
                field("Cod. especialidad"; rec."Cod. especialidad")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("Fecha inscripcion CDS"; rec."Fecha inscripcion CDS")
                {
                }
                field("Cod. nivel de decision"; rec."Cod. nivel de decision")
                {
                }
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                }
                field("Descripcion puesto"; rec."Descripcion puesto")
                {
                }
                field(Observacion; rec.Observacion)
                {
                }
                field(Status; rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

