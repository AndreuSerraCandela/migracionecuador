page 76138 "Colegio - Grados"
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Colegio";
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Colegio - Grados";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Visible = false;
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field(Seccion; rec.Seccion)
                {
                }
                field("Cantidad Secciones"; rec."Cantidad Secciones")
                {
                }
                field("Cantidad Alumnos"; rec."Cantidad Alumnos")
                {
                }
                field("Cantidad Docentes"; rec."Cantidad Docentes")
                {
                }
                field("Lista Utiles"; rec."Lista Utiles")
                {
                }
                field("Lista Competencia"; rec."Lista Competencia")
                {
                }
                field("Horas Ingles"; rec."Horas Ingles")
                {
                }
            }
        }
    }

    actions
    {
    }
}

