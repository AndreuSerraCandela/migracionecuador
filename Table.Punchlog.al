table 76391 "Punch log"
{

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Fecha registro"; Date)
        {
        }
        field(3; "Hora registro"; Time)
        {
        }
        field(4; "No. tarjeta"; Code[10])
        {
        }
        field(5; "ID Equipo"; Code[10])
        {
        }
        field(6; Procesado; Boolean)
        {
        }
        field(7; "Full name"; Text[60])
        {
            CalcFormula = Lookup (Employee."Full Name" WHERE ("No." = FIELD ("Cod. Empleado")));
            Caption = 'Full Name';
            FieldClass = FlowField;
        }
        field(8; "Job Title"; Text[60])
        {
            CalcFormula = Lookup (Employee."Job Title" WHERE ("No." = FIELD ("Cod. Empleado")));
            Caption = 'Job Title';
            FieldClass = FlowField;
        }
        field(9; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                if "Job No." = '' then begin
                    Validate("Job Task No.", '');
                end;

                Job.Get("Job No.");
                Job.TestBlocked;
                Job.TestField("Bill-to Customer No.");
                Cust.Get(Job."Bill-to Customer No.");
                Validate("Job Task No.", '');
            end;
        }
        field(10; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE ("Job No." = FIELD ("Job No."));

            trigger OnValidate()
            var
                JobTask: Record "Job Task";
            begin
                TestField("Job No.");
                if "Job Task No." <> '' then begin
                    JobTask.Get("Job No.", "Job Task No.");
                    JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado", "Fecha registro", "Hora registro")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Job: Record Job;
        Cust: Record Customer;
}

