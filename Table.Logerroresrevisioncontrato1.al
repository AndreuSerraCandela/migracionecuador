table 56102 "Log errores revision contrato1"
{

    fields
    {
        field(1; "No. empleado"; Code[15])
        {
        }
        field(10; "Errores fecha inicio"; Integer)
        {
            Description = 'Contrato sin fecha de inicio establecida';
        }
        field(11; "Errores continuidad"; Integer)
        {
            Description = 'Error en la continuidad de los periodos de contrato';
        }
        field(12; "Errores por fecha final"; Integer)
        {
            Description = 'Si la fecha final sin valor (abierta) no es el último contrato entrado';
        }
        field(20; "Creado por proceso"; Boolean)
        {
        }
        field(21; Estado; Option)
        {
            OptionMembers = ,Errores,Ok;
        }
        field(30; Contratos; Integer)
        {
            CalcFormula = Count (Contratos WHERE ("No. empleado" = FIELD ("No. empleado")));
            FieldClass = FlowField;
            TableRelation = Contratos;
        }
        field(100; Observaciones; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No. empleado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Creado por proceso" := true;
    end;
}

