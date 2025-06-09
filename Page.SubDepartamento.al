page 76403 "Sub-Departamento"
{
    ApplicationArea = all;
    Caption = 'Sub-Department';
    PageType = List;
    SourceTable = "Sub-Departamentos";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Departamento"; rec."Cod. Departamento")
                {
                    Visible = false;
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Total Empleados"; rec."Total Empleados")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

