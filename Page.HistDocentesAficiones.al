page 76240 "Hist. Docentes - Aficiones"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Hist. Docente - Aficiones";

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

