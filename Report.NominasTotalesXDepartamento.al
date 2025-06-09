report 76114 "Nominas Totales X Departamento"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NominasTotalesXDepartamento.rdlc';
    Caption = '<Nominas por Totales por Departamento>';

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Tipo Nomina", "Período", "No. empleado", "Forma de Cobro";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(Payroll_s_ReportCaption; Payroll_s_ReportCaptionLbl)
            {
            }
            dataitem("Historico Lin. nomina"; "Historico Lin. nomina")
            {
                DataItemLink = "No. empleado" = FIELD("No. empleado"), "No. Documento" = FIELD("No. Documento"), "Tipo Nómina" = FIELD("Tipo Nomina"), "Período" = FIELD("Período");
                DataItemTableView = SORTING("No. empleado", "Tipo Nómina", "Período", "No. Orden") WHERE("Excluir de listados" = CONST(false));
                column(TextoEncabezadoTotales; "Historico Lin. nomina".Descripción)
                {
                }
                column(ValorTotales; "Historico Lin. nomina".Total)
                {
                }
                column(Departamento; rDepto.Descripcion)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin

                rDepto.Reset;
                if not rDepto.Get(Departamento) then
                    rDepto.Descripcion := Text004;
                /*
                IF NOT rSubDepto.GET(Departamento,"Sub-Departamento") THEN
                  rSubDepto.Descripcion := Text004;
                  */

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
        rDepto: Record Departamentos;
        TextoEncabezado: array[20] of Text[60];
        Valor: array[20] of Decimal;
        TotalIngresos: Decimal;
        TotalDeducciones: Decimal;
        TotalEmpl: Integer;
        Text002: Label 'Order :';
        Text003: Label 'Total %1 %2';
        Text004: Label '-*- Doesn''t exist -*-';
        MuestraSalario: Boolean;
        lblSalario: Text[30];
        Salario: Decimal;
        Text005: Label 'Total';
        Payroll_s_ReportCaptionLbl: Label 'Total Department Payroll''s Report ';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Histórico_Cab__nómina__NombreCaptionLbl": Label 'Name';
        TotalIngresos___TotalDeducciones_Control1100040CaptionLbl: Label 'Net Income';
        Grand_TotalCaptionLbl: Label 'Grand Total';
        Prepared_by__CaptionLbl: Label 'Prepared by :';
        Reviwed_by__CaptionLbl: Label 'Reviwed by :';
        Authorized_by__CaptionLbl: Label 'Authorized by :';
        TotalGral: Decimal;
        Fecha_contratacion: Label 'Hire date';
        ValorTotales: Decimal;
        TextoEncabezadoTotales: Text;
}

