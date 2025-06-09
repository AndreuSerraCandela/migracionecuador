table 76256 "Relacion Empleados - Proyectos"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then
                    "Full name" := Employee."Full Name";
            end;
        }
        field(2; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            var
                Job: Record Job;
            begin
            end;
        }
        field(3; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(4; "Job Line Type"; Option)
        {
            Caption = 'Job Line Type';
            OptionCaption = ' ,Schedule,Contract,Both Schedule and Contract';
            OptionMembers = " ",Schedule,Contract,"Both Schedule and Contract";
        }
        field(5; "Job Unit Price"; Decimal)
        {
            BlankZero = true;
            Caption = 'Job Unit Price';
        }
        field(6; "Job Description"; Text[100])
        {
            CalcFormula = Lookup(Job.Description WHERE("No." = FIELD("Job No.")));
            Caption = 'Job Description';
            FieldClass = FlowField;
        }
        field(7; "Job Task Name"; Text[100])
        {
            CalcFormula = Lookup("Job Task".Description WHERE("Job No." = FIELD("Job No."),
                                                               "Job Task No." = FIELD("Job Task No.")));
            Caption = 'Job Task No.';
            FieldClass = FlowField;
        }
        field(8; "% to distribute"; Decimal)
        {
            Caption = '% to distribute';

            trigger OnValidate()
            var
                RelEmp_Job: Record "Relacion Empleados - Proyectos";
                TotDistrib: Decimal;
            begin
                TotDistrib := 0;

                RelEmp_Job.Reset;
                RelEmp_Job.SetRange("Employee No.", "Employee No.");
                RelEmp_Job.SetFilter("Job No.", '<>%1', "Job No.");
                if RelEmp_Job.FindSet then
                    repeat
                        TotDistrib += RelEmp_Job."% to distribute";
                    until RelEmp_Job.Next = 0;

                TotDistrib += "% to distribute";

                if TotDistrib > 100 then
                    Error(StrSubstNo(Err001, FieldCaption("% to distribute")));
            end;
        }
        field(9; "Concepto salarial"; Code[20])
        {
            Caption = 'Wage Code';
            TableRelation = "Conceptos salariales".Codigo;

            trigger OnValidate()
            begin
                if ConcepSalar.Get("Concepto salarial") then
                    "Descripción concepto" := ConcepSalar.Descripcion;
            end;
        }
        field(10; Precio; Decimal)
        {
            Caption = 'Unit price';
        }
        field(11; "Full name"; Text[60])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Full name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Descripción concepto"; Text[60])
        {
            Caption = 'Wage description';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Job No.", "Job Task No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PerfilSalario.Reset;
        PerfilSalario.SetRange("No. empleado", "Employee No.");
        PerfilSalario.SetRange("Salario Base", true);
        if PerfilSalario.FindFirst then
            "Job Unit Price" := PerfilSalario.Importe;
    end;

    var
        PerfilSalario: Record "Perfil Salarial";
        Err001: Label 'The top value allowed must be 100 for the %1';
        Employee: Record Employee;
        ConcepSalar: Record "Conceptos salariales";
}

