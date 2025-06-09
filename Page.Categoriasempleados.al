page 76131 "Categorias empleados"
{
    ApplicationArea = all;
    Caption = 'Employee Category';
    PageType = List;
    SourceTable = "Datos adicionales RRHH";
    SourceTableView = SORTING("Tipo registro", Code)
                      WHERE("Tipo registro" = CONST("Categoría"));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Code"; rec.Code)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var

    begin
    end;

    var
        Mail: Codeunit Mail;

        FechaIni: Date;
        FechaFin: Date;
        MapPointVisible: Boolean;
}

