table 76037 "Prestaciones masivas"
{
    Caption = 'Mass disengagements';

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            Caption = 'Employee no.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Empl.Get("Cod. Empleado");
                "Full name" := Empl."Full Name";
                "Document Type" := Empl."Document Type";
                "Document ID" := Empl."Document ID";
                Departamento := Empl.Departamento;
                "Job Type Code" := Empl."Job Type Code";
                "Job Title" := Empl."Job Title";
                "Employment Date" := Empl."Employment Date";
                Status := Empl.Status;


                CalcularPrestaciones;
            end;
        }
        field(2; "Full name"; Text[60])
        {
            Caption = 'Nombre completo';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'SS,Passport,Green card,Work Permission';
            OptionMembers = "Cédula",Pasaporte,"Tarj.residen.comunitario","Perm.Trabajo",,"N.I.Extranjero","N.I.F.";
        }
        field(4; "Document ID"; Text[15])
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Departamento; Code[20])
        {
            CaptionClass = '4,1,1';
            Caption = 'Department';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Departamentos WHERE(Inactivo = CONST(false));
        }
        field(6; "Desc. Departamento"; Text[70])
        {
            CalcFormula = Lookup(Departamentos.Descripcion WHERE(Codigo = FIELD(Departamento)));
            Caption = 'Descripción Departamento';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Job Type Code"; Code[15])
        {
            Caption = 'Cod. Cargo';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Puestos laborales".Codigo WHERE("Cod. departamento" = FIELD(Departamento));

            trigger OnValidate()
            var
                Contract: Record Contratos;
            begin
            end;
        }
        field(8; "Job Title"; Text[60])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Status; Enum "Employee Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            //OptionCaption = 'Active,Inactive,Terminated';
            //OptionMembers = Active,Inactive,Terminated;
        }
        field(11; "Importe Dias trabajados"; Decimal)
        {
            Caption = 'Working days remaining amount ';
            DataClassification = ToBeClassified;
        }
        field(12; "Importe Vacaciones"; Decimal)
        {
            Caption = 'Vacation''s amount';
            DataClassification = ToBeClassified;
        }
        field(13; "Importe Preaviso"; Decimal)
        {
            Caption = 'Notice amount';
            DataClassification = ToBeClassified;
        }
        field(14; "Importe Cesantia"; Decimal)
        {
            Caption = 'Unemployment Amount';
            DataClassification = ToBeClassified;
        }
        field(15; "Importe Regalia"; Decimal)
        {
            Caption = 'Christmas salary';
            DataClassification = ToBeClassified;
        }
        field(16; "Importe Otros"; Decimal)
        {
            Caption = 'Other amounts';
            DataClassification = ToBeClassified;
        }
        field(17; "Importe AFP"; Decimal)
        {
            Caption = 'AFP Amount';
            DataClassification = ToBeClassified;
        }
        field(18; "Importe SFS"; Decimal)
        {
            Caption = 'SFS Amount';
            DataClassification = ToBeClassified;
        }
        field(19; "Importe ISR"; Decimal)
        {
            Caption = 'ISR Amount';
            DataClassification = ToBeClassified;
        }
        field(20; "Importe AFP patronal"; Decimal)
        {
            Caption = 'Company''s AFP Amount';
            DataClassification = ToBeClassified;
        }
        field(21; "Importe SFS patronal"; Decimal)
        {
            Caption = 'Company''s SFS Amount';
            DataClassification = ToBeClassified;
        }
        field(22; "Importe SRL"; Decimal)
        {
            Caption = 'SRL Amount';
            DataClassification = ToBeClassified;
        }
        field(23; "Importe INFOTEP"; Decimal)
        {
            Caption = 'INFOTEP Amount';
            DataClassification = ToBeClassified;
        }
        field(24; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            DataClassification = ToBeClassified;
            TableRelation = "Grounds for Termination";

            trigger OnValidate()
            var
                GroundsforTermination: Record "Grounds for Termination";
            begin
                ConfNomina.Get();
                ConfNomina.TestField("Codeunit calculo nomina");
            end;
        }
        field(25; "Termination Date"; Date)
        {
            Caption = 'Termination Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcularPrestaciones;
            end;
        }
        field(30; Comentario; Text[150])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(31; "Dias preaviso"; Integer)
        {
            Caption = 'Notice days';
            DataClassification = ToBeClassified;
        }
        field(32; "Dias cesantia"; Integer)
        {
            Caption = 'Layoff days';
            DataClassification = ToBeClassified;
        }
        field(33; "Salario empleado"; Decimal)
        {
            Caption = 'Employee salary';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ConfNomina: Record "Configuracion nominas";
        Empl: Record Employee;
        CalculoPrestLotes: Codeunit "Calculo prestaciones lotes";


    procedure CalcularPrestaciones()
    begin
        if not Empl.Get("Cod. Empleado") then
            exit;
        "Importe Cesantia" := CalculoPrestLotes.CalculoCesantia(Empl, "Dias cesantia", "Termination Date");
        "Importe Preaviso" := CalculoPrestLotes.CalculoPreaviso(Empl, "Dias preaviso", "Termination Date");
        "Importe Regalia" := CalculoPrestLotes.CalculoRegaliaPrest(Empl);
        "Importe Vacaciones" := CalculoPrestLotes.CalculoVacaciones(Empl);
        "Importe Dias trabajados" := CalculoPrestLotes.VerificaRetroactivo(Empl);
    end;
}

