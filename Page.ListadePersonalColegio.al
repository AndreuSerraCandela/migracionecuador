page 76285 "Lista de Personal Colegio"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Colegio - Lin. Jerarquia puest";

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
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Visible = false;
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                    Visible = false;
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                    Visible = false;
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                    Visible = false;
                }
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                }
                field("Nombre Empleado"; rec."Nombre Empleado")
                {
                }
                field("Cod. Cargo"; rec."Cod. Cargo")
                {
                }
                field("Descripcion Cargo"; rec."Descripcion Cargo")
                {
                }
            }
        }
    }

    actions
    {
    }
}

