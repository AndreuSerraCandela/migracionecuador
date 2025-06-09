table 76197 "Relacion Puestos - Proyectos"
{

    fields
    {
        field(1; "Job Type Code"; Code[20])
        {
            Caption = 'Job Type Code';
            NotBlank = true;
            TableRelation = "Puestos laborales";
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
        field(5; "Concepto Salarial"; Code[20])
        {
            Caption = 'Wedge code';
        }
        field(6; "Job Description"; Text[100])
        {
            CalcFormula = Lookup(Job.Description);
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
    }

    keys
    {
        key(Key1; "Job Type Code", "Job No.", "Job Task No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PerfilSalario: Record "Perfil Salarial";
        Err001: Label 'The top value allowed must be 100 for the %1';
}

