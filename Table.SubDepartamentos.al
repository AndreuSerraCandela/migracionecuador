table 76172 "Sub-Departamentos"
{
    Caption = 'Sub department';
    DataPerCompany = false;
    DrillDownPageID = "Sub-Departamento";
    LookupPageID = "Sub-Departamento";

    fields
    {
        field(1; "Cod. Departamento"; Code[20])
        {
            Caption = 'Department code';
            TableRelation = Departamentos;
        }
        field(2; Codigo; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
        field(4; "Total Empleados"; Integer)
        {
            CalcFormula = Count (Employee WHERE (Departamento = FIELD ("Cod. Departamento"),
                                                "Sub-Departamento" = FIELD (Codigo)));
            Caption = 'Total Employees';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Cod. Departamento", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }
}

