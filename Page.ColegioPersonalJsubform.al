page 76142 "Colegio - Personal J. subform"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Colegio - Docentes";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Nombre colegio"; rec."Nombre colegio")
                {
                    Visible = false;
                }
                field("Aplica Jerarquia Puestos"; rec."Aplica Jerarquia Puestos")
                {
                }
                field("Cod. Docente"; rec."Cod. Docente")
                {
                }
                field("Nombre docente"; rec."Nombre docente")
                {
                    Editable = false;
                }
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                    Editable = false;
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                }
            }
        }
    }

    actions
    {
    }
}

