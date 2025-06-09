page 76064 "Beneficios empleados"
{
    ApplicationArea = all;
    Caption = 'Employee benefits';
    PageType = List;
    SourceTable = "Beneficios empleados";

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
                field("Tipo Beneficio"; rec."Tipo Beneficio")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Importe; rec.Importe)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ConfNominas.Get();
        CurrPage.Editable := not ConfNominas."Usar Acciones de personal";
    end;

    var
        ConfNominas: Record "Configuracion nominas";
}

