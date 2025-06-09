page 76107 "Asis. Visitas Consultor/Asesor"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Asis. Visitas Asesor/Consultor";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fecha programación"; rec."Fecha programación")
                {
                }
                field("Cod. Docente"; rec."Cod. Docente")
                {
                }
                field("Nombre Docente"; rec."Nombre Docente")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field(Inscrito; rec.Inscrito)
                {
                }
                field(Confirmado; rec.Confirmado)
                {
                }
                field(Asistio; rec.Asistio)
                {
                }
            }
        }
    }

    actions
    {
    }
}

