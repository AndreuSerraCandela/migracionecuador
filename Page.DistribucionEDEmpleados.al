page 76177 "Distribucion ED Empleados"
{
    ApplicationArea = all;
    Caption = 'Employee JE distribution';
    PageType = List;
    SourceTable = "Distribucion ED empleados";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee no."; rec."Employee no.")
                {
                    Visible = false;
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                    Visible = false;
                }
                field("Dimension Code"; rec."Dimension Code")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
                field("% a distribuir"; rec."% a distribuir")
                {
                }
            }
        }
    }

    actions
    {
    }
}

