table 76028 "CxC Empleados"
{
    DrillDownPageID = "Lista Cxc Empleados";
    LookupPageID = "Lista Cxc Empleados";

    fields
    {
        field(1; "No. Préstamo"; Code[20])
        {

            trigger OnValidate()
            begin
                if "No. Préstamo" <> xRec."No. Préstamo" then begin
                    ConfNominas.Get;
                    GestNoSerie.TestManual(TraeCodNoSerie);
                    "No. Préstamo" := '';
                end;
            end;
        }
        field(2; "Código Empleado"; Code[20])
        {
            TableRelation = Employee WHERE("Calcular Nomina" = CONST(true));

            trigger OnValidate()
            begin
                Empl.Get("Código Empleado");
                if Empl."Termination Date" <> 0D then
                    Error(Err002, "Código Empleado");
            end;
        }
        field(3; "Fecha Registro CxC"; Date)
        {
        }
        field(4; "Tipo CxC"; Option)
        {
            Description = ' ,Préstamo,Factura';
            OptionMembers = " ","Préstamo",Factura;
        }
        field(5; Importe; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(6; Cuotas; Integer)
        {

            trigger OnValidate()
            begin
                if "% a deducir de Ingresos" <> 0 then
                    Error(Err004);

                "Importe Cuota" := Round(Importe / Cuotas, 0.01);
            end;
        }
        field(7; "No. Documento"; Code[20])
        {

            trigger OnLookup()
            begin

                Empl.Get("Código Empleado");
                //IF "Tipo CxC" = "Tipo CxC"::Factura THEN
                //   BEGIN
                Empl.TestField("Codigo Cliente");
                CLE.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
                CLE.SetRange("Customer No.", Empl."Codigo Cliente");
                CLE.SetRange(Open, true);
                if CLE.FindFirst then begin
                    LiqMovsClientes.LookupMode(true);
                    LiqMovsClientes.SetTableView(CLE);
                    LiqMovsClientes.SetRecord(CLE);
                    if LiqMovsClientes.RunModal = ACTION::LookupOK then begin
                        LiqMovsClientes.GetCustLedgEntry(CLE);
                        "No. Documento" := CLE."Document No.";
                        Importe := CLE."Remaining Amount";
                        "No. Mov. Cliente" := CLE."Entry No.";
                    end;
                end;
                //   END;

                Clear(LiqMovsClientes);
            end;
        }
        field(8; Pendiente; Boolean)
        {
            Editable = true;
        }
        field(9; "Tipo Contrapartida"; Option)
        {
            Description = 'Cuenta,Cliente,Proveedor,Banco';
            OptionMembers = Cuenta,Cliente,Proveedor,Banco;

            trigger OnValidate()
            begin
                case "Tipo Contrapartida" of
                    "Tipo Contrapartida"::Cliente:
                        begin
                            Empl.Get("Código Empleado");
                            "Cta. Contrapartida" := Empl."Codigo Cliente";
                        end;
                end;
            end;
        }
        field(10; "Cta. Contrapartida"; Code[20])
        {
            TableRelation = IF ("Tipo Contrapartida" = CONST(Cuenta)) "G/L Account"
            ELSE
            IF ("Tipo Contrapartida" = CONST(Cliente)) Customer
            ELSE
            IF ("Tipo Contrapartida" = CONST(Proveedor)) Vendor
            ELSE
            IF ("Tipo Contrapartida" = CONST(Banco)) "Bank Account";

            trigger OnValidate()
            begin
                if "Cta. Contrapartida" = '' then
                    exit;

                case "Tipo Contrapartida" of
                    "Tipo Contrapartida"::Cuenta:
                        CGCta.Get("Cta. Contrapartida");
                    "Tipo Contrapartida"::Cliente:
                        begin
                            Clie.Get("Cta. Contrapartida");
                            Clie.TestField(Blocked, 0);
                        end;
                    "Tipo Contrapartida"::Proveedor:
                        begin
                            Prov.Get("Cta. Contrapartida");
                            Prov.TestField(Blocked, 0);
                        end;
                end;
            end;
        }
        field(11; "Fecha Inicio Deducción"; Date)
        {
        }
        field(12; "Nro. Solicitud CK"; Code[20])
        {
        }
        field(13; "Importe Pendiente Cte."; Decimal)
        {
            FieldClass = Normal;
        }
        field(14; "% a deducir de Ingresos"; Decimal)
        {

            trigger OnValidate()
            begin
                if Cuotas <> 0 then
                    Error(Err003);
            end;
        }
        field(15; "No. Mov. Cliente"; Integer)
        {
        }
        field(16; "Concepto Salarial"; Code[20])
        {
            TableRelation = "Conceptos salariales".Codigo;
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
        field(20; "Motivo Prestamos"; Text[60])
        {
        }
        field(21; "Full name"; Text[150])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Código Empleado")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No. Préstamo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ConfNominas.Get;
        if "No. Préstamo" = '' then begin
            ConfNominas.Get;
            ConfNominas.TestField("No. serie CxC");
            //GestNoSerie.InitSeries(ConfNominas."No. serie CxC", ConfNominas."No. serie CxC", 0D, "No. Préstamo", ConfNominas."No. serie CxC");
            Rec."No. Préstamo" := GestNoSerie.GetNextNo(ConfNominas."No. serie CxC");
        end;
        Pendiente := true;
    end;

    var
        Empl: Record Employee;
        CLE: Record "Cust. Ledger Entry";
        LinEsqPercep: Record "Perfil Salarial";
        LiqMovsClientes: Page "Apply Customer Entries";
        CGCta: Record "G/L Account";
        Clie: Record Customer;
        Prov: Record Vendor;
        ConfNominas: Record "Configuracion nominas";
        GestNoSerie: Codeunit "No. Series";
        Err001: Label 'You must specify as Balance Account a Bank or Vendor';
        Err002: Label 'You can''t do loans to this employee, %1 is already out of the company';
        Err003: Label 'You can''t specify Loan payment when Discount % is used';
        Err004: Label 'You can''t specify  Discount % when Loan paymen is used';


    procedure AsistEdic(CxCEmpleadosAnt: Record "CxC Empleados"): Boolean
    begin
        ConfNominas.Get;
        TestNoSerie;
        if GestNoSerie.LookupRelatedNoSeries(TraeCodNoSerie, CxCEmpleadosAnt."No. Préstamo", "No. Préstamo") then begin
            ConfNominas.Get;
            TestNoSerie;
            GestNoSerie.GetNextNo("No. Préstamo");
            exit(true);
        end;
    end;

    local procedure TestNoSerie(): Boolean
    begin
        case "Tipo CxC" of
            "Tipo CxC"::"Préstamo":
                ConfNominas.TestField("No. serie CxC");
        end;
    end;

    local procedure TraeCodNoSerie(): Code[10]
    begin
        case "Tipo CxC" of
            "Tipo CxC"::"Préstamo":
                exit(ConfNominas."No. serie CxC");
        end;
    end;
}

