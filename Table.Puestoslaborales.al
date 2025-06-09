table 76013 "Puestos laborales"
{
    Caption = 'Job type';
    DrillDownPageID = "Puestos laborares";
    LookupPageID = "Puestos laborares";

    fields
    {
        field(1; Codigo; Code[15])
        {
            Caption = 'Code';
        }
        field(2; Descripcion; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Cod. nivel"; Code[20])
        {
            Caption = 'Level code';
            DataClassification = ToBeClassified;
            TableRelation = "Nivel Cargo";
        }
        field(4; "Puesto Supervisor"; Code[20])
        {
            Caption = 'Supervisor position';
            TableRelation = "Puestos laborales".Codigo WHERE ("Cod. departamento" = FIELD ("Cod. departamento"));

            trigger OnValidate()
            var
                Empl: Record Employee;
            begin
                /*IF (xRec."Cod. Supervisor" <> "Cod. Supervisor") AND
                   ("Cod. Supervisor" <> '') THEN
                   BEGIN
                     Empl.SETCURRENTKEY("Job Type Code");
                     Empl.SETRANGE("Job Type Code",Código);
                     IF Empl.FINDSET(TRUE,FALSE) THEN
                        BEGIN
                         Empl."Cod. Supervisor" := "Cod. Supervisor";
                         Empl.MODIFY;
                        END;
                   END;
                   */

            end;
        }
        field(5; "Desc. puesto supervisor"; Text[150])
        {
            CalcFormula = Lookup ("Puestos laborales".Descripcion WHERE ("Cod. departamento" = FIELD ("Cod. departamento"),
                                                                        "Puesto Supervisor" = FIELD (Codigo)));
            Caption = 'Supervisor position name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Incluye Dias Feriados"; Boolean)
        {
            Caption = 'Include Hollidays';
        }
        field(7; Exento; Boolean)
        {
            Caption = 'Exempt';
            Description = 'Para Nomina PR';
        }
        field(8; "Total Empleados"; Integer)
        {
            CalcFormula = Count (Employee WHERE (Departamento = FIELD ("Cod. departamento"),
                                                "Job Type Code" = FIELD (Codigo),
                                                Status = CONST (Active)));
            Caption = 'Total Employee';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Metodo cálculo Ingresos"; Code[10])
        {
            Caption = 'Income calculation method';
            TableRelation = "Parametros Calculo Dias";
        }
        field(10; "Metodo calculo Paga Salario"; Option)
        {
            Caption = 'Salary pay calculation method';
            OptionCaption = 'Distributed,By period';
            OptionMembers = Distribuido,"Por período";
        }
        field(11; "Cod. departamento"; Code[20])
        {
            Caption = 'Department code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Departamentos;
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(14; "Maximo de posiciones"; Integer)
        {
            Caption = 'Maximum quantity';
            DataClassification = ToBeClassified;
        }
        field(15; "Control de asistencia"; Boolean)
        {
            Caption = 'Attendance control';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Cod. departamento", Codigo)
        {
            Clustered = true;
        }
        key(Key2; Descripcion, Codigo)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    trigger OnDelete()
    begin
        Emp.Reset;
        Emp.SetRange(Departamento, "Cod. departamento");
        Emp.SetRange("Job Type Code", Codigo);
        if Emp.FindFirst then
            Error(StrSubstNo(Err001, TableCaption, Codigo));
    end;

    trigger OnInsert()
    begin
        Emp.Reset;
        Emp.SetRange("Calcular Nomina", true);
        Emp.SetRange(Status, Emp.Status::Active);
        if Emp.FindFirst then begin
            PerfSal.Reset;
            PerfSal.SetRange("No. empleado", Emp."No.");
            if PerfSal.FindSet then
                repeat
                    PerfilSalarioxCargo.Init;
                    PerfilSalarioxCargo."Puesto de Trabajo" := Codigo;
                    PerfilSalarioxCargo."Concepto salarial" := PerfSal."Concepto salarial";
                    PerfilSalarioxCargo.Descripcion := PerfSal.Descripcion;
                    PerfilSalarioxCargo."Tipo concepto" := PerfSal."Tipo concepto";
                    PerfilSalarioxCargo."1ra Quincena" := PerfSal."1ra Quincena";
                    PerfilSalarioxCargo."2da Quincena" := PerfSal."2da Quincena";
                    if PerfilSalarioxCargo.Insert then;
                until PerfSal.Next = 0;
        end;
    end;

    var
        Emp: Record Employee;
        Err001: Label 'You can not delete %1 %2 because there are employees associated to it';
        PerfSal: Record "Perfil Salarial";
        PerfilSalarioxCargo: Record "Perfil Salario x Cargo";
        DimMgt: Codeunit DimensionManagement;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Puestos laborales", Codigo, FieldNumber, ShortcutDimCode);
        Modify;
    end;
}

