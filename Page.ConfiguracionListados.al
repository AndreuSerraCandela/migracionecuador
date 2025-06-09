page 76054 "Configuracion Listados"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Configuracion Listados";

    layout
    {
        area(content)
        {
            repeater(Control1100000)
            {
                ShowCaption = false;
                field("ID Reporte"; rec."ID Reporte")
                {
                }
                field("Nombre Reporte"; rec."Nombre Reporte")
                {
                }
                field("No. Columna"; rec."No. Columna")
                {
                }
                field("Titulo Columna"; rec."Titulo Columna")
                {
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                }
                field("Otros Ingresos"; rec."Otros Ingresos")
                {
                }
                field("Otras Deducciones"; rec."Otras Deducciones")
                {
                }
                field("Total Ingresos"; rec."Total Ingresos")
                {
                }
                field("Total Deducciones"; rec."Total Deducciones")
                {
                }
            }
        }
    }

    actions
    {
    }
}

