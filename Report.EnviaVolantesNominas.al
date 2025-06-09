report 76067 "Envia Volantes Nominas"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(HisCabNomina; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "No. empleado", "Período", "Tipo de nomina";

            trigger OnAfterGetRecord()
            begin

                Emp.Get("No. empleado");
                ConfEmpresa.Get(Emp.Company);
                if (Emp."E-Mail" = '') and (Emp."Company E-Mail" = '') then
                    CurrReport.Skip;

                Contador := Contador + 1;
                Ventana.Update(1, "No. empleado");
                Ventana.Update(2, Round(Contador / Contador2 * 10000, 1));

                ConfEmpresa.TestField("ID  Volante Pago");
                CU.GetReport(ConfEmpresa."ID  Volante Pago", "No. empleado");
                CU.Run(HisCabNomina);
            end;

            trigger OnPostDataItem()
            begin
                Ventana.Close;
            end;

            trigger OnPreDataItem()
            begin
                Ventana.Open(Text003);
                Contador := 0;
                Contador2 := Count;
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
        ConfEmpresa: Record "Empresas Cotizacion";
        Emp: Record Employee;
        CU: Codeunit "Imprime en PDF";
        Text003: Label 'Processing Employee #1########## \@2@@@@@@@@@@@@@';
        Ventana: Dialog;
        Contador: Decimal;
        Contador2: Decimal;
}

