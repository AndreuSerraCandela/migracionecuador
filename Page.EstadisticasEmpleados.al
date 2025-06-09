page 76040 "Estadisticas Empleados"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field("Full Name"; rec."Full Name")
            {
                Editable = false;
            }
            field("Date Filter"; rec."Date Filter")
            {
            }
            field("Dias Vacaciones"; rec."Dias Vacaciones")
            {
                Editable = false;
            }
            group(General)
            {
                Caption = 'General';
                part(Income; "Estadistica Ingresos-Descuento")
                {
                    Caption = 'Income';
                    SubPageLink = "No. empleado" = FIELD("No."),
                                  "Tipo concepto" = CONST(Ingresos),
                                  "Filtro Fecha" = FIELD("Date Filter");
                }
                part(Deductions; "Estadistica Ingresos-Descuento")
                {
                    Caption = 'Deductions';
                    SubPageLink = "No. empleado" = FIELD("No."),
                                  "Tipo concepto" = CONST(Deducciones),
                                  "Filtro Fecha" = FIELD("Date Filter");
                }
            }
        }
    }

    actions
    {
    }


}

