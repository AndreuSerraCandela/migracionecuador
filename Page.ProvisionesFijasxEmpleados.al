page 76001 "Provisiones Fijas x Empleados"
{
    ApplicationArea = all;
    Caption = 'Fix provisino by Employee';
    PageType = List;
    SourceTable = "Distrib. Control de asis. Proy";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                    Visible = false;
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field("Hora registro"; rec."Hora registro")
                {
                }
            }
        }
    }

    actions
    {
    }
}

