report 76054 "Listado de prestamos personal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Listadodeprestamospersonal.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
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
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(intAntesNomina; intAntesNomina)
            {
                //Comentado DecimalPlaces = 2 : 2;
            }
            column(CantEmpl; CantEmpl)
            {
            }
            column(LinPerSal_Importe; LinPerSal.Importe)
            {
                DecimalPlaces = 2 : 2;
            }
            column(HistCabPrestamo__Importe_Pendiente____LinPerSal_Importe_; (HistCabPrestamo."Importe Pendiente" - LinPerSal.Importe))
            {
                DecimalPlaces = 2 : 2;
            }
            column(HistCabPrestamo__Importe_Pendiente_; HistCabPrestamo."Importe Pendiente")
            {
                DecimalPlaces = 2 : 2;
            }
            column(HistCabPrestamo__Importe_Original_; HistCabPrestamo."Importe Original")
            {
                DecimalPlaces = 2 : 2;
            }
            column(CantEmpl_Control39; CantEmpl)
            {
            }
            column(LinPerSal_Importe_Control41; LinPerSal.Importe)
            {
                DecimalPlaces = 2 : 2;
            }
            column(HistCabPrestamo__Importe_Pendiente__Control42; HistCabPrestamo."Importe Pendiente")
            {
                DecimalPlaces = 2 : 2;
            }
            column(ImportePte; ImportePte)
            {
                DecimalPlaces = 2 : 2;
            }
            column(HistCabPrestamo__Importe_Original__Control44; HistCabPrestamo."Importe Original")
            {
                DecimalPlaces = 2 : 2;
            }
            column(Listado_pr_stamos_personalCaption; Listado_pr_stamos_personalCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control9Caption; Control9CaptionLbl)
            {
            }
            column(Control12Caption; Control12CaptionLbl)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Original_Caption; "Histórico Cab. Préstamo".FieldCaption("Importe Original"))
            {
            }
            column(Importe_Pendiente____LinPerSal_Importe_Caption; Importe_Pendiente____LinPerSal_Importe_CaptionLbl)
            {
            }
            column(LinPerSal_Importe_Control19Caption; LinPerSal_Importe_Control19CaptionLbl)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Pendiente_Caption; Hist_rico_Cab__Pr_stamo__Importe_Pendiente_CaptionLbl)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Importe_Cuota_Caption; Hist_rico_Cab__Pr_stamo__Importe_Cuota_CaptionLbl)
            {
            }
            column(Hist_rico_Cab__Pr_stamo__No__Pr_stamo_Caption; "Histórico Cab. Préstamo".FieldCaption("No. Préstamo"))
            {
            }
            column(Hist_rico_Cab__Pr_stamo__Fecha_Inicio_Deducci_n_Caption; "Histórico Cab. Préstamo".FieldCaption("Fecha Inicio Deducción"))
            {
            }
            column(Total_de_empleadosCaption; Total_de_empleadosCaptionLbl)
            {
            }
            column(Total_de_empleadosCaption_Control40; Total_de_empleadosCaption_Control40Lbl)
            {
            }
            dataitem("Histórico Cab. Préstamo"; "Histórico Cab. Préstamo")
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Employee No.", Pendiente) WHERE(Pendiente = CONST(true));
                column(Hist_rico_Cab__Pr_stamo__Importe_Original_; "Importe Original")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__Importe_Cuota_; "Importe Cuota")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__Importe_Pendiente_; "Importe Pendiente")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(LinPerSal_Importe_Control19; LinPerSal.Importe)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Importe_Pendiente____LinPerSal_Importe_; ("Importe Pendiente" - LinPerSal.Importe))
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__No__Pr_stamo_; "No. Préstamo")
                {
                    //Comentado DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__Fecha_Inicio_Deducci_n_; "Fecha Inicio Deducción")
                {
                    //Comentado DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__Importe_Original__Control33; "Importe Original")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__Importe_Cuota__Control38; "Importe Cuota")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Importe_Pendiente_____Importe_Cuota_; "Importe Pendiente" + "Importe Cuota")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(LinPerSal_Importe_Control36; LinPerSal.Importe)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Hist_rico_Cab__Pr_stamo__Importe_Pendiente__Control35; "Importe Pendiente")
                {
                    DecimalPlaces = 2 : 2;
                }
                column("Histórico_Cab__Préstamo_Código_Empleado"; "Employee No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if AntesDespuesNomina = 1 then
                        ImportePte += "Importe Pendiente" + "Importe Cuota";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                HistCabPrestamo.Reset;
                HistCabPrestamo.SetRange("Employee No.", "No.");
                HistCabPrestamo.SetFilter("Fecha Inicio Deducción", '<%1', FechaFin);
                HistCabPrestamo.SetRange(Pendiente, true);
                if not HistCabPrestamo.FindFirst then
                    CurrReport.Skip;

                HistCabPrestamo.CalcFields("Importe Pendiente", "Importe Original");

                repeat
                    LinPerSal.Reset;
                    LinPerSal.SetRange("No. empleado", HistCabPrestamo."Employee No.");
                    LinPerSal.SetRange("Concepto salarial", HistCabPrestamo."Concepto Salarial");
                    if LinPerSal.FindFirst then begin
                        LinPerSal.Cantidad := 1;
                        LinPerSal.Importe := HistCabPrestamo."Importe Cuota";
                        LinPerSal."1ra Quincena" := HistCabPrestamo."1ra Quincena";
                        LinPerSal."2da Quincena" := HistCabPrestamo."2da Quincena";
                        //Para actualizar el monto en el esq. percepcion
                        if AplicaaNomina then
                            LinPerSal.Modify;
                    end;
                until HistCabPrestamo.Next = 0;
                CantEmpl += 1;
            end;

            trigger OnPreDataItem()
            begin

                /*CurrReport.CreateTotals(LinPerSal.Importe, HistCabPrestamo."Importe Original", HistCabPrestamo."Importe Pendiente",
                                        HistCabPrestamo."Importe Pendiente Cte.");*/

                ConfNominas.Get();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha inicio"; FechaInicio)
                {
                ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Fecha: Record Date;
                    begin
                        ConfEmpresa.FindFirst;

                        if ConfEmpresa."Tipo Pago Nomina" = ConfEmpresa."Tipo Pago Nomina"::Quincenal then begin
                            Dia := Date2DMY(FechaInicio, 1);
                            if (Dia <> 1) and (Dia <> 16) then
                                Error(Text002);

                            Mes := Date2DMY(FechaInicio, 2);
                            Año := Date2DMY(FechaInicio, 3);
                            if Dia = 1 then
                                FechaFin := DMY2Date(15, Mes, Año)
                            else begin
                                FechaInicio := DMY2Date(1, Mes, Año);
                                Fecha.Reset;
                                Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                                Fecha.SetRange("Period Start", FechaInicio);
                                if Fecha.FindFirst then
                                    FechaFin := NormalDate(Fecha."Period End");
                            end;
                        end
                        else begin
                            Dia := Date2DMY(FechaInicio, 1);
                            if Dia <> 1 then
                                Error(Text001);

                            Fecha.Reset;
                            Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                            Fecha.SetRange("Period Start", DMY2Date(Dia, Date2DMY(FechaInicio, 2), Date2DMY(FechaInicio, 3)));
                            if Fecha.FindFirst then
                                FechaFin := NormalDate(Fecha."Period End");
                        end;
                    end;
                }
                field("Fecha fin"; FechaFin)
                {
                ApplicationArea = All;
                    Editable = false;
                }
                field("Antes de nómina"; AntesDespuesNomina)
                {
                ApplicationArea = All;
                }
                field("Aplicar a nómina"; AplicaaNomina)
                {
                ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if AplicaaNomina and (AntesDespuesNomina = 1) then
                            Error('Solo se puede aplicar a nomina si selecciona\' +
                                   'la opcion de Antes de Nómina');
                    end;
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

    trigger OnPreReport()
    begin
        intAntesNomina := AntesDespuesNomina;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        ConfEmpresa: Record "Empresas Cotizacion";
        HistCabPrestamo: Record "Histórico Cab. Préstamo";
        LinPerSal: Record "Perfil Salarial";
        MesTrabajo: Integer;
        AnoTrabajo: Integer;
        FechaInicio: Date;
        FechaFin: Date;
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        CantEmpl: Integer;
        AplicaaNomina: Boolean;
        NoCuota: Integer;
        AntesDespuesNomina: Option "Antes de Nómina","Después de Nómina";
        ImportePte: Decimal;
        Dia: Integer;
        Mes: Integer;
        "Año": Integer;
        Text001: Label 'Starting date must be 1st day';
        Text002: Label 'Starting date mus be 1st or 16th day';
        intAntesNomina: Integer;
        Listado_pr_stamos_personalCaptionLbl: Label 'Listado préstamos personal';
        CurrReport_PAGENOCaptionLbl: Label 'página';
        Control9CaptionLbl: Label 'Nº';
        Control12CaptionLbl: Label 'Nombre completo';
        Importe_Pendiente____LinPerSal_Importe_CaptionLbl: Label 'Balance';
        LinPerSal_Importe_Control19CaptionLbl: Label 'Importe Cuota';
        Hist_rico_Cab__Pr_stamo__Importe_Pendiente_CaptionLbl: Label 'Importe pendiente';
        Hist_rico_Cab__Pr_stamo__Importe_Cuota_CaptionLbl: Label 'Cantidad Cuotas';
        Total_de_empleadosCaptionLbl: Label 'Total de empleados';
        Total_de_empleadosCaption_Control40Lbl: Label 'Total de empleados';
}

