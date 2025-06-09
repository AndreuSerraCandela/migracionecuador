page 76178 "Docentes - Aficiones"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Docente - Aficiones";

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
                field("Nombre Docente"; rec."Nombre Docente")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. aficion"; rec."Cod. aficion")
                {
                }
                field("Descripcion aficion"; rec."Descripcion aficion")
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

