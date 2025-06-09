table 76068 "Configuracion Listados"
{

    fields
    {
        field(1; "ID Reporte"; Integer)
        {
            /*             TableRelation = Object.ID WHERE (Type = CONST (Report)); */
        }
        field(2; "No. Columna"; Integer)
        {
        }
        field(3; "Titulo Columna"; Text[30])
        {
        }
        field(4; "Concepto Salarial"; Code[250])
        {
            TableRelation = "Conceptos salariales".Codigo;
            ValidateTableRelation = false;
        }
        field(5; "Total Ingresos"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Total Ingresos" and "Total Deducciones" then
                    "Total Deducciones" := false;
            end;
        }
        field(6; "Total Deducciones"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Total Ingresos" and "Total Deducciones" then
                    "Total Ingresos" := false;
            end;
        }
        field(7; "Otros Ingresos"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Otros Ingresos" and "Otras Deducciones" then
                    "Otras Deducciones" := false;
            end;
        }
        field(8; "Otras Deducciones"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Otros Ingresos" and "Otras Deducciones" then
                    "Otros Ingresos" := false;
            end;
        }
        field(9; "Nombre Reporte"; Text[150])
        {
            // Removed CalcFormula using Object virtual table as it's not supported in Cloud.
            Editable = false;
            // Optionally, you can populate this field via AL code elsewhere if needed.
        }
    }

    keys
    {
        key(Key1; "ID Reporte", "No. Columna")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

