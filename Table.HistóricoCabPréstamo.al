table 76043 "Histórico Cab. Préstamo"
{
    DrillDownPageID = "Lista Mov. CxC Empleados";
    LookupPageID = "Lista Mov. CxC Empleados";

    fields
    {
        field(1; "No. Préstamo"; Code[20])
        {

            trigger OnValidate()
            begin
                ConfNominas.Get;
                if "No. Préstamo" = '' then begin
                    ConfNominas.TestField("No. serie CxC");
                    /*GestNoSerie.InitSeries(ConfNominas."No. serie reg. CxC", ConfNominas."No. serie reg. CxC", 0D,
                                          "No. Préstamo", ConfNominas."No. serie reg. CxC");*/
                    Rec."No. Préstamo" := GestNoSerie.GetNextNo(ConfNominas."No. serie reg. CxC", 0D, true);
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(3; "Fecha Registro CxC"; Date)
        {
        }
        field(4; "Tipo CxC"; Option)
        {
            Description = ' ,Préstamo,Factura';
            OptionMembers = " ","Préstamo",Factura;
        }
        field(5; "Importe Original"; Decimal)
        {
            CalcFormula = Sum("Histórico Lín. Préstamo"."Débito" WHERE("No. Préstamo" = FIELD("No. Préstamo")));
            Caption = 'Original Amount';
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(6; Cuotas; Integer)
        {
        }
        field(7; "No. Documento"; Code[20])
        {
        }
        field(8; Pendiente; Boolean)
        {
            Editable = true;
        }
        field(9; "Tipo Contrapartida"; Option)
        {
            Description = 'Cuenta,Cliente,Proveedor,Banco';
            OptionMembers = Cuenta,Cliente,Proveedor,Banco;
        }
        field(10; "Cta. Contrapartida"; Code[20])
        {
        }
        field(11; "Fecha Inicio Deducción"; Date)
        {
        }
        field(12; "Nro. Solicitud CK"; Code[20])
        {
        }
        field(13; "Importe Pendiente Cte."; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(14; "% Cuota"; Decimal)
        {
        }
        field(15; "No. Mov. Cliente"; Integer)
        {
        }
        field(16; "Importe Pendiente"; Decimal)
        {
            CalcFormula = Sum("Histórico Lín. Préstamo".Importe WHERE("No. Préstamo" = FIELD("No. Préstamo")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(17; "1ra Quincena"; Boolean)
        {
        }
        field(18; "2da Quincena"; Boolean)
        {
        }
        field(19; "Importe Cuota"; Decimal)
        {
        }
        field(20; "Concepto Salarial"; Code[20])
        {
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(21; "Motivo Prestamos"; Text[60])
        {
        }
        field(22; Correccion; Boolean)
        {
            Caption = 'Correction';
        }
        field(23; "Full name"; Text[150])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(24; "Motivo de cierre"; Text[250])
        {
            Caption = 'Cause of close';
        }
    }

    keys
    {
        key(Key1; "No. Préstamo")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", Pendiente)
        {
        }
        key(Key3; "Employee No.", "No. Préstamo")
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

