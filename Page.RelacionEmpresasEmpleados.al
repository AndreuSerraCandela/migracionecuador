page 76375 "Relacion Empresas Empleados"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Relacion Empresas Empleados";

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
                field(Empresa; rec.Empresa)
                {
                }
                field("Cod. Empleado en empresa"; rec."Cod. Empleado en empresa")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        rEmpresa: Record Company;
        iSecuencia: Integer;
}

