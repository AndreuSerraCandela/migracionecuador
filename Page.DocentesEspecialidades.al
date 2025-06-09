page 76179 "Docentes - Especialidades"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Docente - Especialidad";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
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

