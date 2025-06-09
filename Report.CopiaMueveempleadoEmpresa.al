report 76412 "Copia-Mueve empleado Empresa"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                /*Empl.GET(AEmpl);
                //Empl.TESTFIELD("Job Type Code");
                EsqSalFrom.SETRANGE("No. empleado","No.");
                IF EsqSalFrom.FINDSET(FALSE,FALSE) THEN
                   REPEAT
                    EsqSalTo.COPY(EsqSalFrom);
                    EsqSalTo."No. empleado" := AEmpl;
                    EsqSalTo.Cargo          := Empl."Job Type Code";
                    EsqSalTo.Cantidad       := 0;
                    EsqSalTo.Importe        := 0;
                    EsqSalTo.INSERT(TRUE);
                   UNTIL EsqSalFrom.NEXT = 0;
                */

            end;

            trigger OnPreDataItem()
            begin
                if CompanyName = Empresa then
                    Error(Err001);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Empresa; Empresa)
                {
                ApplicationArea = All;
                    TableRelation = Company;
                }
                field(accion; Accion)
                {
                ApplicationArea = All;
                    Caption = 'Action';
                    OptionCaption = 'Copy,Move';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Empl: Record Employee;
        PerfilSal: Record "Perfil Salarial";
        PerfilSalTo: Record "Perfil Salarial";
        EmpTo: Record Employee;
        Contrato: Record Contratos;
        ContratoTo: Record Contratos;
        Banco: Record "Distrib. Ingreso Pagos Elect.";
        BancoTo: Record "Distrib. Ingreso Pagos Elect.";
        HistCabNom: Record "Historico Cab. nomina";
        HistCabNomTo: Record "Historico Cab. nomina";
        HistLinNom: Record "Historico Lin. nomina";
        HistLinNomTo: Record "Historico Lin. nomina";
        Vacac: Record "Historico Vacaciones";
        VacacTo: Record "Historico Vacaciones";
        SaldoISR: Record "Saldos a favor ISR";
        SaldoISRTo: Record "Saldos a favor ISR";
        MovAct: Record "Mov. actividades OJO";
        MovActTo: Record "Mov. actividades OJO";
        HistSal: Record "Acumulado Salarios";
        HistSalTo: Record "Acumulado Salarios";
        AltAddr: Record "Alternative Address";
        AltAddrTo: Record "Alternative Address";
        Qualif: Record "Employee Qualification";
        QualifTo: Record "Employee Qualification";
        Ausencia: Record "Employee Relative";
        AusenciaTo: Record "Employee Relative";
        RecDiv: Record "Misc. Article Information";
        RecDivTo: Record "Misc. Article Information";
        InfConf: Record "Confidential Information";
        InfConfTo: Record "Confidential Information";
        Accion: Option Copiar,Mover;
        Empresa: Text[80];
        Err001: Label 'Destination company must be different from the actual company';
}

