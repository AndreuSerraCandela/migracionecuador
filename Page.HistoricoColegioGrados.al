page 76242 "Historico Colegio - Grados"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historico Colegio - Grados";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
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
                field("Fecha Decision"; rec."Fecha Decision")
                {
                }
                field(Campana; rec.Campana)
                {
                }
            }
        }
    }

    actions
    {
    }
}

