report 76255 "Genera archivo Fondos de Res."
{
    Caption = 'Generates file reserve funds';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "Período", "Tipo de nomina";

            trigger OnAfterGetRecord()
            begin
                ConfNomina.Get();
                ConfNomina.TestField("Codeunit Archivos Electronicos");
                "Tipo Archivo" := 4;
                CODEUNIT.Run(ConfNomina."Codeunit Archivos Electronicos", "Historico Cab. nomina");
                CurrReport.Break;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ConfNomina: Record "Configuracion nominas";
        Empresa: Record "Empresas Cotizacion";
        Err001: Label 'Missing Bank''s information from Company Setup';
        Err002: Label 'The process will be canceled \the bank account is missing for employee %1';
        Text001: Label 'Payroll period ';
        Text002: Label 'Text documents (*.txt) |*.txt|Word Documents (*.doc*)|*.doc*|All files (*.*)|*.*';
}

