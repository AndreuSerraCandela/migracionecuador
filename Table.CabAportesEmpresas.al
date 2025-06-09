table 76050 "Cab. Aportes Empresas"
{

    fields
    {
        field(1; "No. Documento"; Code[20])
        {
        }
        field(2; "Unidad cotización"; Code[20])
        {
        }
        field(3; "Período"; Date)
        {
        }
        field(4; "No. Contabilización"; Code[20])
        {
        }
        field(5; "Tipo Nomina"; Option)
        {
            OptionCaption = 'Regular,Christmas,Bonus,Tip,Rent';
            OptionMembers = Normal,"Regalía","Bonificación",Propina,Renta;
        }
        field(6; "Tipo de nomina"; Code[20])
        {
            Caption = 'Payroll type';
            DataClassification = ToBeClassified;
            TableRelation = "Tipos de nominas";
        }
        field(7; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            var
                Job: Record Job;
                Cust: Record Customer;
            begin
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Período", "Tipo de nomina")
        {
        }
        key(Key2; "No. Documento")
        {
            Clustered = true;
        }
        key(Key3; "Unidad cotización", "Período")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Err001);
    end;

    var
        Err001: Label 'Use Void Function';
        gCodEmp: Code[20];


    procedure Anular()
    var
        Cabnomina: Record "Historico Cab. nomina";
        LinCP: Record "Lin. Aportes Empresas";
        LinCP2: Record "Lin. Aportes Empresas";
        inicper: Date;
        finper: Date;
    begin
        LinCP.Reset;
        LinCP.SetRange(Período, Período);
        LinCP.SetRange("Tipo de nomina", "Tipo de nomina");
        if GetFilter("Job No.") <> '' then
            LinCP.SetRange("Job No.", "Job No.");
        if gCodEmp <> '' then
            LinCP.SetFilter("No. Empleado", gCodEmp);
        if LinCP.FindSet(true) then
            repeat
                LinCP2.Get(LinCP.Período, LinCP."Tipo de nomina", LinCP."No. Empleado", LinCP."Job No.", LinCP."No. orden");
                LinCP2.Delete;
            until LinCP.Next = 0;
        if gCodEmp = '' then
            Delete;
        if Delete then;
    end;


    procedure FiltroEmp(CodEmp: Code[20])
    begin
        gCodEmp := CodEmp;
    end;
}

