table 76113 "Payroll - Job Journal Line"
{
    Caption = 'Payroll - Job Journal';

    fields
    {
        field(1; "Journal Template Name"; Code[20])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Payroll - Job Journal Template";
        }
        field(2; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Payroll - Job Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(3; "Line no."; Integer)
        {
        }
        field(4; "No. empleado"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Empleados.Get("No. empleado");
                Empleados.TestField("Resource No.");
                Empleados.TestField("Distribuir salario en proyecto", false);

                "Apellidos y Nombre" := Empleados."Full Name";
                "Puesto trabajo" := Empleados."Job Type Code";

                Validate("Resource No.", Empleados."Resource No.");
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                //Busco la tarifa para esa operacion
                //VALIDATE(Operacion);
            end;
        }
        field(6; "Puesto trabajo"; Code[20])
        {
            Editable = false;
        }
        field(7; "Apellidos y Nombre"; Text[60])
        {
            Editable = false;
        }
        field(8; "Job No."; Code[20])
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
        field(9; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

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
        field(10; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;

            trigger OnValidate()
            begin
                Res.Get("Resource No.");
                "Unit of Measure Code" := Res."Base Unit of Measure";
            end;
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
                ConceptoSal.Get("Concepto salarial");
                "Tipo concepto" := ConceptoSal."Tipo concepto";
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

            trigger OnValidate()
            begin
                Amount := "Precio Costo" * Quantity;
            end;
        }
        field(17; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;

            trigger OnValidate()
            begin
                "Precio Costo" := Amount / Quantity;
            end;
        }
        field(18; "Tipo Tarifa"; Option)
        {
            Caption = 'Working type';
            Description = 'Precio fijo,Precio variable';
            Editable = false;
            OptionMembers = "Precio fijo","Precio variable";
        }
        field(19; "Precio Costo"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                Validate(Quantity);
            end;
        }
        field(20; "Inicio Período"; Date)
        {

            trigger OnValidate()
            begin
                "Fin Período" := CalcDate('PM', "Fin Período");
            end;
        }
        field(21; "Fin Período"; Date)
        {
        }
        field(22; "Work Type Code"; Code[20])
        {
            Caption = 'Work Type Code';
            TableRelation = "Price List Line"."Work Type Code" WHERE("Asset Type" = CONST(Resource),
                                                                    "Product No." = FIELD("Resource No."));

            trigger OnValidate()
            var
                ResPrices: Record "Price List Line";
            begin
                if ("Work Type Code" = '') and (xRec."Work Type Code" <> '') then begin
                    Res.Get("Resource No.");
                    "Unit of Measure Code" := Res."Base Unit of Measure";
                    Validate("Unit of Measure Code");
                    "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                end;

                if WorkType.Get("Work Type Code") then begin
                    ResPrices.Reset;
                    ResPrices.SetRange("Asset Type", ResPrices."Asset Type"::Resource); // Resource
                    ResPrices.SetRange("Product No.", "Resource No.");
                    ResPrices.SetRange("Work Type Code", "Work Type Code");
                    ResPrices.FindFirst;

                    if WorkType."Unit of Measure Code" <> '' then begin
                        "Unit of Measure Code" := WorkType."Unit of Measure Code";
                        if ResUnitofMeasure.Get("Resource No.", "Unit of Measure Code") then
                            "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                    end
                    else begin
                        Res.Get("Resource No.");
                        "Unit of Measure Code" := Res."Base Unit of Measure";
                        Validate("Unit of Measure Code");
                        "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                    end;

                    Validate("Precio Costo", ResPrices."Direct Unit Cost");
                end;
            end;
        }
        field(23; "Document No."; Code[20])
        {
        }
        field(24; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(25; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line no.")
        {
            Clustered = true;
        }
        key(Key2; "Journal Template Name", "Journal Batch Name", "No. empleado")
        {
        }
        key(Key3; "Journal Template Name", "Journal Batch Name", "Posting Date", "No. empleado")
        {
        }
        key(KeyReports; "Concepto salarial")
        {
        }        
    }

    fieldgroups
    {
    }

    var
        Job: Record Job;
        Cust: Record Customer;
        Res: Record Resource;
        ResUnitofMeasure: Record "Resource Unit of Measure";
        Empresa: Record "Empresas Cotizacion";
        Empleados: Record Employee;
        WorkType: Record "Work Type";
        DimMgt: Codeunit DimensionManagement;
}

