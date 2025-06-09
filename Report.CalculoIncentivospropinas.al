report 76028 "Calculo Incentivos/propinas"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CalculoIncentivospropinas.rdlc';
    Caption = 'Calculate Incentives/tips';
    ProcessingOnly = false;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") WHERE("Incentivos/Puntos" = FILTER(<> 0), "Calcular Nomina" = CONST(true));
            RequestFilterFields = "No.";
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(PrecioPto__Monto_a_Distribuir_; PrecioPto."Monto a Distribuir")
            {
            }
            column(PrecioPto__Fecha_Ult__Corte_; PrecioPto."Fecha Ult. Corte")
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(Employee__Incentivos_Puntos_; "Incentivos/Puntos")
            {
            }
            column(LinPerfSal_Importe; LinPerfSal.Importe)
            {
                DecimalPlaces = 2 : 2;
            }
            column(DiasTrabajados; DiasTrabajados)
            {
            }
            column(Employee__Fecha_salida_empresa_; "Fecha salida empresa")
            {
            }
            column(FechaIniAusencia; FechaIniAusencia)
            {
            }
            column(FechaFinAusencia; FechaFinAusencia)
            {
            }
            column(blnMostrar; blnMostrar)
            {
            }
            column(Employee__Incentivos_Puntos__Control7; "Incentivos/Puntos")
            {
            }
            column(LinPerfSal_Importe_Control15; LinPerfSal.Importe)
            {
            }
            column(Diferencia; Diferencia)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Employee__Full_Name_Caption; Employee__Full_Name_CaptionLbl)
            {
            }
            column(Employee__Incentivos_Puntos_Caption; Employee__Incentivos_Puntos_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Incentive_Tips_DistributionCaption; Incentive_Tips_DistributionCaptionLbl)
            {
            }
            column(Importe_a_Distribuir_Caption; Importe_a_Distribuir_CaptionLbl)
            {
            }
            column(ImporteCaption; ImporteCaptionLbl)
            {
            }
            column(DiasTrabajadosCaption; DiasTrabajadosCaptionLbl)
            {
            }
            column(Fecha_de_Cancelaci_nCaption; Fecha_de_Cancelaci_nCaptionLbl)
            {
            }
            column(Fecha_Ult__CorteCaption; Fecha_Ult__CorteCaptionLbl)
            {
            }
            column(FechaIniAusenciaCaption; FechaIniAusenciaCaptionLbl)
            {
            }
            column(FechaFinAusenciaCaption; FechaFinAusenciaCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Diferencia_Caption; Diferencia_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Contador := Contador + 1;
                Ventana.Update(1, Round(Contador / AModificar, 1));

                blnMostrar := true;

                DiasTrabajados := 15;
                DiasAusencia := 0;
                FechaIniAusencia := 0D;
                FechaFinAusencia := 0D;

                /*
                Ausencia.RESET;
                Ausencia.SETRANGE("Employee No.", "No.");
                //GRN rAusencia.SETRANGE("Cód. causa ausencia", ConfNomina."Incidencias Ausencia Propinas");
                Ausencia.SETRANGE("From Date", PrecioPto."Fecha Ult. Corte", PrecioPto."Fecha de Corte");
                Ausencia.SETFILTER(Quantity,'<>%1',0);
                IF Ausencia.FIND('-') THEN
                   REPEAT
                    IF "Fecha salida empresa" >= Ausencia."To Date" THEN
                       BEGIN
                        FechaIniAusencia := Ausencia."From Date";
                        FechaFinAusencia := Ausencia."To Date";
                        DiasAusencia := FechaFinAusencia - FechaIniAusencia +1;
                       END
                    ELSE
                    IF "Fecha salida empresa" =0D THEN
                       BEGIN
                        FechaIniAusencia := Ausencia."From Date";
                        FechaFinAusencia := Ausencia."To Date";
                        DiasAusencia := FechaFinAusencia - FechaIniAusencia +1 ;
                       END;
                   UNTIL Ausencia.NEXT = 0;
                
                IF "Employment Date" > PrecioPto."Fecha de Corte" THEN
                   IF "Employment Date" <= PrecioPto."Fecha de Corte" THEN
                      DiasTrabajados := PrecioPto."Fecha de Corte" - "Employment Date"+1;
                
                IF "Fecha salida empresa" <>0D THEN
                   IF "Fecha salida empresa" <= PrecioPto."Fecha de Corte" THEN
                      BEGIN
                        DiasTrabajados := "Fecha salida empresa" - PrecioPto."Fecha Ult. Corte" +1;
                
                        IF DiasTrabajados < 0 THEN
                           DiasTrabajados := 1
                        ELSE
                        IF "Fecha salida empresa" <= PrecioPto."Fecha de Corte" THEN
                           DiasTrabajados := DiasTrabajados - 1;
                      END;
                
                DiasTrabajados := DiasTrabajados - DiasAusencia;
                IF DiasTrabajados < 0 THEN
                   DiasTrabajados := 1;
                
                //PtosEmpleados   := "Incentivos/Puntos" * DiasTrabajados;
                */
                PtosEmpleados := "Incentivos/Puntos";
                MontoPropina := 0;

                //IF DiasTrabajados > 0 THEN
                //GRN   MontoPropina    := "TotalPropDistrib." / 15 * PtosEmpleados;

                MontoPropina := Round("Incentivos/Puntos" / TotalPtos * "TotalPropDistrib.", 0.01);

                LinPerfSal.Reset;
                LinPerfSal.SetCurrentKey("No. empleado", "Concepto salarial");
                LinPerfSal.SetRange("No. empleado", "No.");
                LinPerfSal.SetRange("Concepto salarial", ConceptoSalarial);
                if LinPerfSal.Find('-') then begin
                    LinPerfSal.Importe := MontoPropina;
                    LinPerfSal.Cantidad := 1;
                    LinPerfSal.Modify;
                end
                else
                    //   CurrReport.SKIP;
                    blnMostrar := false;


                /*   ERROR(Err003,"No. empleado",LinPerfSal.FIELDCAPTION("Concepto salarial"),conceptosalarial,
                         LinPerfSal.TABLECAPTION);
                */

                Diferencia := PrecioPto."Monto a Distribuir" - LinPerfSal.Importe;

            end;

            trigger OnPostDataItem()
            begin
                Ventana.Close;
            end;

            trigger OnPreDataItem()
            begin
                if ConceptoSalarial = '' then
                    Error(Err002);
                if (FechaIni = 0D) or (FechaFin = 0D) then
                    Error(Err001);

                ConfNomina.FindFirst;

                // Busca el record correspondiente al periodo de nomina que se va a generar
                PrecioPto.Reset;
                PrecioPto.SetRange("Concepto Salarial", ConceptoSalarial);
                PrecioPto.SetRange("Fecha de Corte", FechaIni, FechaFin);
                PrecioPto.FindFirst;

                TotalPtos := 0;
                TotalDias := 0;
                PromedioPtos := 0;

                // Filtra a los empleados que les toca propina aunque no estén dentro del periodo
                // normal de la nómina. Si está después de la fecha de corte de la propina se
                // incluye dentro del presente pago de nominas.
                Empleado.Reset;
                Empleado.SetFilter("Fecha salida empresa", '> %1 & <= %2 | > %3 | = %4',
                                   DMY2Date(1, Date2DMY(PrecioPto."Fecha Ult. Corte", 2), Date2DMY(PrecioPto."Fecha Ult. Corte", 3)), PrecioPto."Fecha de Corte",
                                   PrecioPto."Fecha de Corte", 0D);
                Empleado.SetFilter("Employment Date", '<= %1', PrecioPto."Fecha de Corte");
                Empleado.SetFilter("Calcular Nomina", '=%1', true);
                Empleado.Find('-');
                AModificar := Count;

                Ventana.Open(Msg001);

                AModificar := AModificar / 10000;
                Contador := 0;

                repeat
                    DiasTrabajados := 15;
                    DiasAusencia := 0;
                    FechaIniAusencia := 0D;
                    FechaFinAusencia := 0D;

                    /*
                    Ausencia.RESET;
                    Ausencia.SETRANGE("Employee No.", "No.");
                    Ausencia.SETRANGE(Ausencia."From Date", PrecioPto."Fecha Ult. Corte", PrecioPto."Fecha de Corte");
                    Ausencia.SETFILTER(Ausencia.Quantity,'<>%1',0);
                    IF Ausencia.FIND('-') THEN
                        REPEAT
                        IF "Fecha salida empresa" >= Ausencia."To Date" THEN
                            BEGIN
                            FechaIniAusencia := Ausencia."From Date";
                            FechaFinAusencia := Ausencia."To Date";
                            DiasAusencia     := FechaFinAusencia - FechaIniAusencia +1 ;
                            END
                        ELSE
                        IF "Fecha salida empresa" =0D THEN
                            BEGIN
                            FechaIniAusencia := Ausencia."From Date";
                            FechaFinAusencia := Ausencia."To Date";
                            DiasAusencia     := FechaFinAusencia - FechaIniAusencia +1 ;
                            END;
                        UNTIL Ausencia.NEXT = 0;

                        IF "Employment Date" > PrecioPto."Fecha Ult. Corte" THEN
                            IF "Employment Date" <= PrecioPto."Fecha de Corte" THEN
                                DiasTrabajados := PrecioPto."Fecha de Corte" - "Employment Date"+1;

                        IF "Fecha salida empresa" <> 0D THEN
                            IF "Fecha salida empresa" <= PrecioPto."Fecha de Corte" THEN
                                BEGIN
                                DiasTrabajados := "Fecha salida empresa" - PrecioPto."Fecha Ult. Corte" +1;
                                IF DiasTrabajados < 0 THEN
                                    DiasTrabajados := 1
                                ELSE
                                IF "Fecha salida empresa" <= PrecioPto."Fecha de Corte" THEN
                                    DiasTrabajados := DiasTrabajados - 1;
                                END;
                                */
                    DiasTrabajados := DiasTrabajados - DiasAusencia;
                    if DiasTrabajados < 0 then
                        DiasTrabajados := 1;

                    //     TotalPtos := TotalPtos + ("Incentivos/Puntos" * DiasTrabajados);

                    TotalPtos := TotalPtos + "Incentivos/Puntos";
                until Empleado.Next = 0;

                PromedioPtos := TotalPtos / 15;
                //GRN "TotalPropDistrib." := PrecioPto."Monto a Distribuir"/PromedioPtos;
                "TotalPropDistrib." := PrecioPto."Monto a Distribuir";


                /*GRN
                MESSAGE('Promedio ptos %1',PromedioPtos);
                MESSAGE('Total puntos %1',TotalPtos);
                MESSAGE('Total a distrib. %1', "TotalPropDistrib.");
                
                
                Empleado.RESET;
                Empleado.SETFILTER("Fecha salida empresa",'> %1 & <= %2 | > %3 | = %4',
                                   PrecioPto."Fecha Ult. Corte",PrecioPto."Fecha de Corte",
                                   PrecioPto."Fecha de Corte",0D);
                Empleado.SETFILTER("Fecha Ingreso empresa",'<= %1',PrecioPto."Fecha de Corte");
                Empleado.SETRANGE("Calcular Nomina", TRUE);
                Empleado.FINDfirst;
                */
                ConfNomina.Get();
                //ConfNomina.TESTFIELD("Incidencias Ausencia Propinas");
                //ConfNomina.TESTFIELD("Concepto Salarial Incentivos");
                //CurrReport.CreateTotals(LinPerfSal.Importe, "Incentivos/Puntos", PromedioPtos);

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field("Concepto salarial"; ConceptoSalarial)
                {
                    ApplicationArea = All;
                    TableRelation = "Conceptos salariales".Codigo;

                }
                field("Fecha inicio"; FechaIni)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Dia := Date2DMY(FechaIni, 1);
                        if (Dia <> 1) and (Dia <> 16) then
                            Error('La fecha Inicial debe ser día 1 o día 16');
                        Mes := Date2DMY(FechaIni, 2);
                        Año := Date2DMY(FechaIni, 3);
                        if Dia = 1 then
                            FechaFin := DMY2Date(15, Mes, Año)
                        else begin
                            Inicio := DMY2Date(1, Mes, Año);
                            Fecha.Reset;
                            Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                            Fecha.SetRange("Period Start", Inicio);
                            if Fecha.Find('-') then
                                FechaFin := NormalDate(Fecha."Period End");
                        end;
                    end;
                }
                field("Fecha final"; FechaFin)
                {
                    ApplicationArea = All;
                    Editable = false;

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
        Empleado: Record Employee;
        PrecioPto: Record "Incentivos/Propinas";
        Ausencia: Record "Employee Absence";
        ConfNomina: Record "Configuracion nominas";
        Fecha: Record Date;
        LinPerfSal: Record "Perfil Salarial";
        ImporteTotal: Decimal;
        Ventana: Dialog;
        AModificar: Decimal;
        Contador: Decimal;
        Dia: Integer;
        Mes: Integer;
        "Año": Integer;
        Inicio: Date;
        DiasTrabajados: Integer;
        DiasAusencia: Integer;
        Diferencia: Decimal;
        PromedioPtos: Decimal;
        TotalPtos: Decimal;
        TotalDias: Decimal;
        "TotalPropDistrib.": Decimal;
        PtosEmpleados: Decimal;
        MontoPropina: Decimal;
        FechaIni: Date;
        FechaFin: Date;
        FechaIniAusencia: Date;
        FechaFinAusencia: Date;
        Msg001: Label 'Processing ...          \\    @1@@@@@@@@@@@@@    \';
        Err001: Label 'Specify Initial and Final Dates';
        ConceptoSalarial: Code[10];
        Err002: Label 'Specify Wage code for Incentive/Tip';
        Err003: Label 'Employee # %1 doesn''t have %2 %3 in %4';
        blnMostrar: Boolean;
        Employee__Full_Name_CaptionLbl: Label 'Apellidos y nombres';
        Employee__Incentivos_Puntos_CaptionLbl: Label 'Incentivos / Puntos';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Incentive_Tips_DistributionCaptionLbl: Label 'Incentive/Tips Distribution';
        Importe_a_Distribuir_CaptionLbl: Label 'Importe a Distribuir:';
        ImporteCaptionLbl: Label 'Importe';
        DiasTrabajadosCaptionLbl: Label 'Días Cotizados';
        Fecha_de_Cancelaci_nCaptionLbl: Label 'Fecha de Cancelación';
        Fecha_Ult__CorteCaptionLbl: Label 'Fecha Ult. Corte';
        FechaIniAusenciaCaptionLbl: Label 'Fecha Inicio Ausencia';
        FechaFinAusenciaCaptionLbl: Label 'Fecha Fin Ausencia';
        TotalCaptionLbl: Label 'Total';
        Diferencia_CaptionLbl: Label 'Diferencia:';
}

