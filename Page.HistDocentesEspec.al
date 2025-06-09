page 76241 "Hist. Docentes - Espec."
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Hist. Docente - Especialidad";

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
                field("Cod. Docente"; rec."Cod. Docente")
                {
                    Visible = false;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Especialidad"; rec."Cod. Especialidad")
                {
                }
                field("Descripcion especialidad"; rec."Descripcion especialidad")
                {
                    Editable = false;
                }
                field("Cod. grado"; rec."Cod. grado")
                {
                }
                field("Nombre Docente"; rec."Nombre Docente")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

