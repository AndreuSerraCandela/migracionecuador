page 76279 "Lista Cxc Empleados"
{
    ApplicationArea = all;
    CardPageID = "CxC Empleados";
    PageType = List;
    SourceTable = "CxC Empleados";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Préstamo"; rec."No. Préstamo")
                {
                }
                field("Código Empleado"; rec."Código Empleado")
                {
                }
                field("Fecha Registro CxC"; rec."Fecha Registro CxC")
                {
                }
                field("Tipo CxC"; rec."Tipo CxC")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field(Cuotas; rec.Cuotas)
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field(Pendiente; rec.Pendiente)
                {
                }
                field("Tipo Contrapartida"; rec."Tipo Contrapartida")
                {
                }
                field("Cta. Contrapartida"; rec."Cta. Contrapartida")
                {
                }
            }
        }
    }

    actions
    {
    }
}

