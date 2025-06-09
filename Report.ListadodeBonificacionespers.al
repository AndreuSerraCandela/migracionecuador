report 76038 "Listado de Bonificaciones pers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadodeBonificacionespers.rdlc';
    Caption = 'Employee Bonification''s Report';

    dataset
    {
        dataitem(Employee; Employee)
        {
            CalcFields = Salario;
            DataItemTableView = WHERE("Fecha salida empresa" = FILTER(0D), "Calcular Nomina" = CONST(true));
            RequestFilterFields = "No.", "Calcular Nomina", "Global Dimension 1 Code";
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
            column(TIME; Time)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
            }
            column(Employee_Departamento; Departamento)
            {
            }
            column(MontoVacaciones; MontoVacaciones)
            {
            }
            column(Employee_Salario; Salario)
            {
            }
            column(MontoVacaciones_Control1000000001; MontoVacaciones)
            {
            }
            column(CantEmpl; CantEmpl)
            {
            }
            column(MontoVacaciones_Control22; MontoVacaciones)
            {
            }
            column(MontoVacaciones_Control1000000005; MontoVacaciones)
            {
            }
            column(Employee_Bonification_s_ReportCaption; Employee_Bonification_s_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Employee__Full_Name_Caption; FieldCaption("Full Name"))
            {
            }
            column(Employee__Employment_Date_Caption; FieldCaption("Employment Date"))
            {
            }
            column(Employee_DepartamentoCaption; Employee_DepartamentoCaptionLbl)
            {
            }
            column(MontoVacacionesCaption; MontoVacacionesCaptionLbl)
            {
            }
            column(Employee_SalarioCaption; FieldCaption(Salario))
            {
            }
            column(MontoVacaciones_Control1000000001Caption; MontoVacaciones_Control1000000001CaptionLbl)
            {
            }
            column(Total_de_empleadosCaption; Total_de_empleadosCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Employment Date" = 0D then
                    Error(Err001, FieldCaption("Employment Date"), TableCaption, "No.");
                /*
                CalculoFechas.CálculoEntreFechas("Employment Date", FechaFin,Anos, Meses, Dias);
                IF Meses = 0 THEN
                   Meses := 1;
                */

                //Comentado DiasVacaciones := CalculoFechas.CalculoMontoBonificacion("No.", AnoTrabajo, MontoVacaciones, DMY2Date(31, 12, AnoTrabajo));
                MontoVacaciones := DiasVacaciones;

                CantEmpl += 1;

                //Para actualizar el monto en el esq. percepcion
                if AplicaaNomina then begin
                    LinPerfSalarial2.SetRange("No. empleado", "No.");
                    LinPerfSalarial2.SetRange("Concepto salarial", ConceptoVac);
                    if LinPerfSalarial2.Find('-') then begin
                        LinPerfSalarial2.Cantidad := 1;
                        LinPerfSalarial2.Importe := Round(MontoVacaciones, 0.01);
                        LinPerfSalarial2.Modify;
                    end;
                end;

            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
                Fecha.Reset;
                Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
                Fecha.SetRange(Fecha."Period Start", DMY2Date(1, 12, AnoTrabajo));
                if Fecha.FindFirst then
                    FechaFin := NormalDate(Fecha."Period End");

                //CurrReport.CreateTotals(MontoVacaciones);
            end;
        }
    }

    requestpage
    {
        Caption = 'Employee''s bonification report';

        layout
        {
            area(content)
            {
                field("Año a generar"; AnoTrabajo)
                {
                ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if (AnoTrabajo = 0) or (AnoTrabajo < 1900) then
                            Error('Introduzca un año válido por favor');
                    end;
                }
                field("Concepto salarial bonifación"; ConceptoVac)
                {
                ApplicationArea = All;
                    TableRelation = "Conceptos salariales".Codigo;
                }
                field("Aplicar a nómina"; AplicaaNomina)
                {
                ApplicationArea = All;
                }
                field(TipoImporte; TipoImporte)
                {
                ApplicationArea = All;
                    Caption = 'Standard,Amount to distribute';

                    trigger OnValidate()
                    begin
                        ImporteEditable := TipoImporte = TipoImporte::"Proporcional sobre importe";
                    end;
                }
                field(ImporteDistribuir; ImporteDistribuir)
                {
                ApplicationArea = All;
                    Caption = 'Amount to distribute';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ImporteEditable := TipoImporte = TipoImporte::"Proporcional sobre importe";
        end;
    }

    labels
    {
    }

    var
        ConfNominas: Record "Configuracion nominas";
        Fecha: Record Date;
        LinPerfSalarial: Record "Perfil Salarial";
        LinPerfSalarial2: Record "Perfil Salarial";
        ConceptoVac: Code[20];
        MesTrabajo: Integer;
        AnoTrabajo: Integer;
        FechaFin: Date;
        //Comentado CalculoFechas: Codeunit "Funciones Nomina";
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        CantEmpl: Integer;
        DiasVacaciones: Decimal;
        MontoVacaciones: Decimal;
        AplicaaNomina: Boolean;
        Err001: Label 'Configure %1 to %2 %3';
        SalDiario: Decimal;
        Employee_Bonification_s_ReportCaptionLbl: Label 'Employee Bonification''s Report';
        CurrReport_PAGENOCaptionLbl: Label 'página';
        Employee_DepartamentoCaptionLbl: Label 'Departamento';
        MontoVacacionesCaptionLbl: Label 'Bonification Amount';
        MontoVacaciones_Control1000000001CaptionLbl: Label 'Total Bonification';
        Total_de_empleadosCaptionLbl: Label 'Total de empleados';
        ImporteDistribuir: Decimal;
        TipoImporte: Option "Estándar","Proporcional sobre importe";
        ImporteEditable: Boolean;
}

