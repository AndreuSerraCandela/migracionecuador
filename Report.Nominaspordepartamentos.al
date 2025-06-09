report 76049 "Nominas por departamentos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Nominaspordepartamentos.rdlc';
    AdditionalSearchTerms = 'Payroll by department';
    //ApplicationArea = Basic, Suite, BasicHR;
    Caption = 'Payroll by department';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "Tipo de nomina", "Período", "No. empleado", "Forma de Cobro";
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
            column(Text002___CURRENTKEY; Text002 + CurrentKey)
            {
            }
            column(TextoEncabezado_1_; TextoEncabezado[1])
            {
            }
            column(TextoEncabezado_2_; TextoEncabezado[2])
            {
            }
            column(TextoEncabezado_3_; TextoEncabezado[3])
            {
            }
            column(TextoEncabezado_5_; TextoEncabezado[5])
            {
            }
            column(TextoEncabezado_4_; TextoEncabezado[4])
            {
            }
            column(TextoEncabezado_9_; TextoEncabezado[9])
            {
            }
            column(TextoEncabezado_8_; TextoEncabezado[8])
            {
            }
            column(TextoEncabezado_7_; TextoEncabezado[7])
            {
            }
            column(TextoEncabezado_6_; TextoEncabezado[6])
            {
            }
            column(TextoEncabezado_10_; TextoEncabezado[10])
            {
            }
            column(lbl_Salario; lblSalario)
            {
            }
            column("Histórico_Lín__nómina__No__empleado_"; "No. empleado")
            {
            }
            column("Histórico_Cab__nómina__Nombre"; "Full name")
            {
            }
            column(Employment_Date; Empleado."Employment Date")
            {
            }
            column(Job_Title; Empleado."Job Title")
            {
            }
            column(Salario; Salario)
            {
                AutoFormatType = 1;
            }
            column(Valor_1; Valor[1])
            {
                AutoFormatType = 1;
            }
            column(Valor_2; Valor[2])
            {
                AutoFormatType = 1;
            }
            column(Valor_4; Valor[4])
            {
                AutoFormatType = 1;
            }
            column(Valor_3; Valor[3])
            {
                AutoFormatType = 1;
            }
            column(Valor_5; Valor[5])
            {
                AutoFormatType = 1;
            }
            column(Valor_6; Valor[6])
            {
                AutoFormatType = 1;
            }
            column(Valor_7; Valor[7])
            {
                AutoFormatType = 1;
            }
            column(Valor_8; Valor[8])
            {
                AutoFormatType = 1;
            }
            column(Valor_9; Valor[9])
            {
                AutoFormatType = 1;
            }
            column(Valor_10; Valor[10])
            {
                AutoFormatType = 1;
            }
            column(TotalEmpleado; TotalIngresos + TotalDeducciones)
            {
                AutoFormatType = 1;
            }
            column(TotalIngresos___TotalDeducciones_Control1100058; TotalGral)
            {
                AutoFormatType = 1;
            }
            column(TotalEmpl; TotalEmpl)
            {
            }
            column(Valor_1__Control1000000119; Valor[1])
            {
                AutoFormatType = 1;
            }
            column(Valor_2__Control1000000120; Valor[2])
            {
                AutoFormatType = 1;
            }
            column(Valor_3__Control1000000121; Valor[3])
            {
                AutoFormatType = 1;
            }
            column(Valor_4__Control1000000122; Valor[4])
            {
                AutoFormatType = 1;
            }
            column(Valor_5__Control1000000123; Valor[5])
            {
                AutoFormatType = 1;
            }
            column(Valor_6__Control1000000124; Valor[6])
            {
                AutoFormatType = 1;
            }
            column(Valor_7__Control1000000125; Valor[7])
            {
                AutoFormatType = 1;
            }
            column(Valor_8__Control1000000126; Valor[8])
            {
                AutoFormatType = 1;
            }
            column(Valor_9__Control1000000127; Valor[9])
            {
                AutoFormatType = 1;
            }
            column(Valor_10__Control1000000128; Valor[10])
            {
                AutoFormatType = 1;
            }
            column(Payroll_s_ReportCaption; Payroll_s_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Histórico_Lín__nómina__No__empleado_Caption"; FieldCaption("No. empleado"))
            {
            }
            column("Histórico_Cab__nómina__NombreCaption"; Histórico_Cab__nómina__NombreCaptionLbl)
            {
            }
            column(TotalIngresos___TotalDeducciones_Control1100040Caption; TotalIngresos___TotalDeducciones_Control1100040CaptionLbl)
            {
            }
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            column(Prepared_by__Caption; Prepared_by__CaptionLbl)
            {
            }
            column(Reviwed_by__Caption; Reviwed_by__CaptionLbl)
            {
            }
            column(Authorized_by__Caption; Authorized_by__CaptionLbl)
            {
            }
            column("Histórico_Cab__nómina_Ano"; Ano)
            {
            }
            column("Histórico_Cab__nómina_Período"; Período)
            {
            }
            column("Histórico_Cab__nómina_Tipo_Nomina"; "Tipo Nomina")
            {
            }
            column(Employment_Date_Caption; Fecha_contratacion)
            {
            }
            column(Departamento; rDepto.Descripcion)
            {
            }
            column(Job_Title_Caption; Empleado.FieldCaption("Job Title"))
            {
            }

            trigger OnAfterGetRecord()
            begin

                TotalIngresos := 0;
                TotalDeducciones := 0;
                Clear(Valor);

                Empleado.Get("No. empleado");
                Empleado.CalcFields(Salario);
                if MuestraSalario then begin
                    lblSalario := Empleado.FieldCaption(Salario);
                    Salario := Empleado.Salario;
                end;

                if not rDepto.Get(Departamento) then
                    rDepto.Descripcion := Text004;

                if not rSubDepto.Get(Departamento, "Sub-Departamento") then
                    rSubDepto.Descripcion := Text004;

                TotalEmpl += 1;

                recLinNom.Reset;
                recLinNom.SetCurrentKey("No. empleado", "Tipo Nómina", Período, "No. Orden");
                recLinNom.SetRange("No. empleado", "No. empleado");
                recLinNom.SetRange("No. Documento", "No. Documento");
                recLinNom.SetRange("Tipo Nómina", "Tipo Nomina");
                recLinNom.SetRange(Período, Período);
                recLinNom.SetRange("Excluir de listados", false);
                if recLinNom.FindSet then
                    repeat

                        //To find individuals codes
                        rConfigListados.Reset;
                        rConfigListados.SetRange("ID Reporte", 76000);
                        rConfigListados.SetFilter("Concepto Salarial", '*' + recLinNom."Concepto salarial" + '*');
                        if rConfigListados.FindFirst then
                            Valor[rConfigListados."No. Columna"] += recLinNom.Total;

                        //Generic other codes columns
                        rConfigListados.Reset;
                        rConfigListados.SetRange("ID Reporte", 76000);
                        rConfigListados.SetFilter("Concepto Salarial", '*' + recLinNom."Concepto salarial" + '*');
                        if not rConfigListados.FindFirst then begin
                            rConfigListados.Reset;
                            rConfigListados.SetRange("ID Reporte", 76000);
                            case recLinNom."Tipo concepto" of
                                0: //Ingresos
                                    begin
                                        rConfigListados.SetRange("Otros Ingresos", true);
                                        rConfigListados.FindFirst;
                                        Valor[rConfigListados."No. Columna"] += recLinNom.Total;
                                    end
                                else begin
                                    rConfigListados.SetRange("Otras Deducciones", true);
                                    rConfigListados.FindFirst;
                                    Valor[rConfigListados."No. Columna"] += recLinNom.Total;
                                end;
                            end;
                        end;

                        //Total Incomes and total deductions
                        rConfigListados.Reset;
                        rConfigListados.SetRange("ID Reporte", 76000);
                        case recLinNom."Tipo concepto" of
                            0: //Ingresos
                                begin
                                    rConfigListados.SetRange("Total Ingresos", true);
                                    rConfigListados.FindFirst;
                                    Valor[rConfigListados."No. Columna"] += Round(recLinNom.Total, 0.01);
                                    TotalIngresos += Round(recLinNom.Total, 0.01);
                                    //         TotalIngresos                        += Total;
                                    TotalGral += Round(recLinNom.Total, 0.01);
                                end
                            else begin
                                rConfigListados.SetRange("Total Deducciones", true);
                                rConfigListados.FindFirst;
                                Valor[rConfigListados."No. Columna"] += Round(recLinNom.Total, 0.01);
                                TotalDeducciones += Round(recLinNom.Total, 0.01);
                                //         TotalDeducciones                     += Total;
                                TotalGral += Round(recLinNom.Total, 0.01);
                            end;
                        end;
                    until recLinNom.Next = 0;
            end;

            trigger OnPreDataItem()
            begin

                ConfEmpresa.FindFirst;
                MuestraSalario := true;
                if ConfEmpresa."Tipo Pago Nomina" <> ConfEmpresa."Tipo Pago Nomina"::Quincenal then
                    MuestraSalario := false;

                rConfigListados.Reset;
                rConfigListados.SetRange("ID Reporte", 76000);
                rConfigListados.Find('-');
                repeat
                    TextoEncabezado[rConfigListados."No. Columna"] := rConfigListados."Titulo Columna";
                until rConfigListados.Next = 0;
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
        Empleado: Record Employee;
        ConfEmpresa: Record "Empresas Cotizacion";
        rConfigListados: Record "Configuracion Listados";
        rDepto: Record Departamentos;
        rSubDepto: Record "Sub-Departamentos";
        recLinNom: Record "Historico Lin. nomina";
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
        Payroll_s_ReportCaptionLbl: Label 'Department Payroll''s Report ';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Histórico_Cab__nómina__NombreCaptionLbl": Label 'Name';
        TotalIngresos___TotalDeducciones_Control1100040CaptionLbl: Label 'Net Income';
        Grand_TotalCaptionLbl: Label 'Grand Total';
        Prepared_by__CaptionLbl: Label 'Prepared by :';
        Reviwed_by__CaptionLbl: Label 'Reviwed by :';
        Authorized_by__CaptionLbl: Label 'Authorized by :';
        TotalGral: Decimal;
        Fecha_contratacion: Label 'Hire date';
}

