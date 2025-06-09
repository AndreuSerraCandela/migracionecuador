table 76077 "Hist. Cab. Prest. cooperativa"
{
    Caption = 'Cooperative loan header';
    DrillDownPageID = "Lista Hist. Prest. Cooperativa";
    LookupPageID = "Lista Hist. Prest. Cooperativa";

    fields
    {
        field(1; "No. Prestamo"; Code[20])
        {
            Caption = 'Loan no.';

            trigger OnValidate()
            begin
                ConfNominas.Get;
                if "No. Prestamo" = '' then begin
                    ConfNominas.TestField("No. serie CxC");
                    /*GestNoSerie.InitSeries(ConfNominas."No. serie reg. CxC", ConfNominas."No. serie reg. CxC", 0D,
                                          "No. Prestamo", ConfNominas."No. serie reg. CxC");*/
                    Rec."No. Prestamo" := GestNoSerie.GetNextNo(ConfNominas."No. serie reg. CxC", 0D, true)
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
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
            DataClassification = ToBeClassified;
            TableRelation = "Datos adicionales RRHH" WHERE("Tipo registro" = CONST("Tipo de préstamo"));
        }
        field(6; Importe; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
        }
        field(7; "% Interes"; Decimal)
        {
            Caption = 'Interest rate';
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
            Caption = 'Wage Code';
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(15; "Importe Pendiente"; Decimal)
        {
            CalcFormula = Sum("Mov. cooperativa".Importe WHERE("No. documento" = FIELD("No. Prestamo"),
                                                                "Tipo transaccion" = FILTER(> Aporte)));
            Caption = 'Remaining amount';
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(16; Pendiente; Boolean)
        {
            Caption = 'Open';
            Editable = true;
        }
        field(17; "Motivo de cierre"; Text[250])
        {
            Caption = 'Reason to close';
        }
        field(18; "No. Solicitud prestamo"; Code[20])
        {
            Caption = 'Loan Serial No.';
            DataClassification = ToBeClassified;
        }
        field(25; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Paused,Completed';
            OptionMembers = Activo,Pausado,Completado;
        }
        field(26; "Fecha de pausa"; Date)
        {
            Caption = 'Pause date';
            DataClassification = ToBeClassified;
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
        key(Key3; "Employee No.", "Fecha Inicio Deduccion")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ConfNominas: Record "Configuracion nominas";
        GestNoSerie: Codeunit "No. Series";
}

