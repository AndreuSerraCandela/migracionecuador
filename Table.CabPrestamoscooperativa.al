table 76153 "Cab. Prestamos cooperativa"
{
    Caption = 'Cooperative loan header';
    DrillDownPageID = "Lista Mov. CxC Empleados";
    LookupPageID = "Lista Mov. CxC Empleados";

    fields
    {
        field(1; "No. Prestamo"; Code[20])
        {
            Caption = 'Loan no.';

            trigger OnValidate()
            begin

                if "No. Prestamo" <> xRec."No. Prestamo" then begin
                    ConfNominas.Get;
                    ConfNominas.TestField("No. serie Sol. Prest. Coop.");
                    NoSeriesMgt.TestManual(ConfNominas."No. serie Sol. Prest. Coop.");
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = "Miembros cooperativa";

            trigger OnValidate()
            begin
                Employee.Get("Employee No.");
                Miembroscooperativa.Get("Employee No.");
                "Tipo de miembro" := Miembroscooperativa."Tipo de miembro";
            end;
        }
        field(3; "No. afiliado"; Date)
        {
            Caption = 'Affiliate code';
            Enabled = false;
        }
        field(4; "Tipo de miembro"; Option)
        {
            Caption = 'Member type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Member, Partner';
            OptionMembers = Miembro,Socio;
        }
        field(5; "Tipo prestamo"; Code[20])
        {
            Caption = 'Loan type';
            TableRelation = "Datos adicionales RRHH".Code WHERE("Tipo registro" = CONST("Tipo de préstamo"));
        }
        field(6; Importe; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
        }
        field(7; "% Interes"; Decimal)
        {
            Caption = 'Interest rate';
            MaxValue = 100;
        }
        field(8; "Cantidad de Cuotas"; Integer)
        {
            Caption = 'Fees quantities';
        }
        field(9; "Fecha Inicio Deduccion"; Date)
        {
            Caption = 'Deduction Start Date';
        }
        field(10; "1ra Quincena"; Boolean)
        {
            Caption = '1st half';
        }
        field(11; "2da Quincena"; Boolean)
        {
            Caption = '2nd half';
        }
        field(12; "Motivo Prestamo"; Text[60])
        {
            Caption = 'Reason for loan';
        }
        field(13; "Full name"; Text[150])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            Caption = 'Full name';
            FieldClass = FlowField;
        }
        field(14; "Concepto Salarial"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
    }

    keys
    {
        key(Key1; "No. Prestamo")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "No. Prestamo")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No. Prestamo" = '' then begin
            ConfNominas.Get;
            ConfNominas.TestField("No. serie Sol. Prest. Coop.");
            //NoSeriesMgt.InitSeries(ConfNominas."No. serie Sol. Prest. Coop.", ConfNominas."No. serie Sol. Prest. Coop.", 0D, "No. Prestamo", ConfNominas."No. serie Sol. Prest. Coop.");
            Rec."No. Prestamo" := NoSeriesMgt.GetNextNo(ConfNominas."No. serie Sol. Prest. Coop.");
        end;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        Miembroscooperativa: Record "Miembros cooperativa";
        Employee: Record Employee;
        NoSeriesMgt: Codeunit "No. Series";

    procedure AssistEdit(): Boolean
    begin
        ConfNominas.Get;
        ConfNominas.TestField("No. serie Sol. Prest. Coop.");
        if NoSeriesMgt.LookupRelatedNoSeries(ConfNominas."No. serie Sol. Prest. Coop.", ConfNominas."No. serie Sol. Prest. Coop.", ConfNominas."No. serie Sol. Prest. Coop.") then begin
            NoSeriesMgt.GetNextNo("No. Prestamo");
            exit(true);
        end;
    end;
}

