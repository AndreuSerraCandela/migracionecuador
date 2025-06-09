table 76375 "Mov. actividades OJO"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(4; "No. empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Puesto trabajo"; Code[20])
        {
        }
        field(7; "Apellidos y Nombre"; Text[60])
        {
            Editable = false;
        }
        field(8; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(9; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate()
            var
                JobTask: Record "Job Task";
            begin
            end;
        }
        field(10; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(11; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnLookup()
            var
                ItemUnitOfMeasure: Record "Item Unit of Measure";
                ResourceUnitOfMeasure: Record "Resource Unit of Measure";
                UnitOfMeasure: Record "Unit of Measure";
                Resource: Record Resource;
                "Filter": Text;
            begin
            end;

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
            end;
        }
        field(12; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(13; "Job Task Name"; Text[60])
        {
            Caption = 'Job Task Name';
            Editable = false;
        }
        field(14; "Concepto salarial"; Code[20])
        {
            TableRelation = "Conceptos salariales";

            trigger OnValidate()
            var
                ConceptoSal: Record "Conceptos salariales";
            begin
            end;
        }
        field(15; "Tipo concepto"; Option)
        {
            Description = 'Ingresos,Deducciones';
            Editable = false;
            OptionMembers = Ingresos,Deducciones;
        }
        field(16; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 2 : 2;
        }
        field(17; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
        }
        field(18; "Tipo Tarifa"; Option)
        {
            Caption = 'Working type';
            Description = 'Precio fijo,Precio variable';
            Editable = false;
            OptionMembers = "Precio fijo","Precio variable";
        }
        field(19; "Precio Tarifa"; Decimal)
        {
        }
        field(20; "Inicio Período"; Date)
        {
        }
        field(21; "Fin Período"; Date)
        {
        }
        field(22; "Work Type Code"; Code[20])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";
        }
        field(23; "Working Center"; Code[20])
        {
        }
        field(24; "Document No."; Code[20])
        {
        }
        field(25; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(26; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Job No.", "Job Task No.", "No. empleado", "Working Center", "Posting Date")
        {
        }
        key(Key3; "Concepto salarial")
        {
        }
    }

    fieldgroups
    {
    }
}

