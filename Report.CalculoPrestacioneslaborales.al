report 76149 "Calculo Prestaciones laborales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CalculoPrestacioneslaborales.rdlc';
    Caption = 'Calculation of labor benefits';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(MontoCesantia; MontoCesantia)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(DiasCesantia; DiasCesantia)
            {
                //DecimalPlaces = 2 : 2;
            }
            column(MontoPreaviso; MontoPreaviso)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(DiasPreaviso; DiasPreaviso)
            {
                //DecimalPlaces = 2 : 2;
            }
            column(Importe_SFS; ImporteSFS)
            {
            }
            column(Importe_AFP; ImporteAFP)
            {
            }
            column(Employee__Global_Dimension_2_Code_; Depto.Descripcion)
            {
            }
            column(Employee_Employee__Full_Name_; "Full Name")
            {
            }
            column(RegRegUdadCotiz__Nombre_Empresa_cotizaci_n_; RegRegUdadCotiz."Nombre Empresa cotizacinn")
            {
            }
            column(MontoRegalia; MontoRegalia)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(AcumuladoRegalia; AcumuladoRegalia)
            {
            }
            column(MontoVacaciones; MontoVacaciones)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(DiasVacaciones; DiasVacaciones)
            {
                //DecimalPlaces = 2 : 2;
            }
            column(MontoCesantia___MontoPreaviso____MontoRegalia___MontoVacaciones___MontoRestante; (MontoCesantia + MontoPreaviso) + MontoRegalia + MontoVacaciones + MontoRestante)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(Categor__Descripci_n_; Categor.Descripcion)
            {
            }
            column(Employee__Employment_Date_; Format("Employment Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(Employee__Termination_Date_; Format("Termination Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_ID; "Document ID")
            {
            }
            column(Causa_Salida; Contrato."Causa de la Baja")
            {
            }
            column(FORMAT_GAno______A_os_______FORMAT_GMes______Meses______FORMAT__GD_a_______D_as_; Format(GAno) + ' Años, ' + Format(GMes) + ' Meses, ' + Format(GDía) + ' Días')
            {
            }
            column(PromedioSalarioAnual; PromedioSalarioAnual)
            {
                AutoFormatType = 1;
            }
            column(PromedioSalarioMensual; PromedioSalarioMensual)
            {
                AutoFormatType = 1;
            }
            column(PromedioSalarioDiario; PromedioSalarioDiario)
            {
                AutoFormatType = 1;
            }
            column(Employee_Salario; UltimoSalario)
            {
                AutoFormatType = 1;
            }
            column(PromedioSalarioDiario_Control83; PromedioSalarioDiario)
            {
                AutoFormatType = 1;
            }
            column(PromedioSalarioDiario_Control88; PromedioSalarioDiario)
            {
                AutoFormatType = 1;
            }
            column(PromedioSalarioDiarioVac; PromedioSalarioDiarioVac)
            {
                AutoFormatType = 1;
            }
            column(DMY2DATE_1_DATE2DMY__Termination_Date__2__DATE2DMY__Termination_Date__3__; DMY2Date(1, Date2DMY("Termination Date", 2), Date2DMY("Termination Date", 3)))
            {
                //DecimalPlaces = 2 : 2;
            }
            column(Employee__Termination_Date__Control104; "Fin contrato")
            {
                //DecimalPlaces = 2 : 2;
            }
            column(Monto_Restante; MontoRestante)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(AvanceSalario; AvanceSalario)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(MontoaDeducir; MontoaDeducir)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(AvanceSalario___MontoaDeducir; AvanceSalario + MontoaDeducir)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(MontoCesantia___MontoPreaviso____MontoRegalia___MontoVacaciones___MontoRestante_____AvanceSalario___MontoaDeducir__; (MontoCesantia + MontoPreaviso + MontoRegalia + MontoVacaciones + MontoRestante) + (AvanceSalario + MontoaDeducir + ImporteAFP + ImporteSFS + OtrasDeducciones))
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(MontoCesantia___MontoPreaviso; MontoCesantia + MontoPreaviso)
            {
                AutoFormatType = 1;
                DecimalPlaces = 2 : 2;
            }
            column(Devolucion_ISR; DevolucionISR)
            {
            }
            column(Otras_Deducciones; OtrasDeducciones)
            {
            }
            column(II__CESANTIACaption; II__CESANTIACaptionLbl)
            {
            }
            column(RD_Caption; RD_CaptionLbl)
            {
            }
            column(D_asCaption; D_asCaptionLbl)
            {
            }
            column(I__PREAVISOCaption; I__PREAVISOCaptionLbl)
            {
            }
            column(Nombres_y_ApellidosCaption; Nombres_y_ApellidosCaptionLbl)
            {
            }
            column(V__REGALIACaption; V__REGALIACaptionLbl)
            {
            }
            column(III__VACACIONESCaption; III__VACACIONESCaptionLbl)
            {
            }
            column(Gerencia_de_Recursos_HumanosCaption; Gerencia_de_Recursos_HumanosCaptionLbl)
            {
            }
            column(LIQUIDACION_DE_PRESTACIONES_LABORALESCaption; LIQUIDACION_DE_PRESTACIONES_LABORALESCaptionLbl)
            {
            }
            column(DepartamentoCaption; DepartamentoCaptionLbl)
            {
            }
            column(CargoCaption; CargoCaptionLbl)
            {
            }
            column(Fecha_de_IngresoCaption; Fecha_de_IngresoCaptionLbl)
            {
            }
            column(Fecha_de_SalidaCaption; Fecha_de_SalidaCaptionLbl)
            {
            }
            column(Tiempo_TrabajadoCaption; Tiempo_TrabajadoCaptionLbl)
            {
            }
            column(Sueldo_devengado_en_el__ltimo_a_oCaption; Sueldo_devengado_en_el__ltimo_a_oCaptionLbl)
            {
            }
            column(Promedio_Mensual_RD_Caption; Promedio_Mensual_RD_CaptionLbl)
            {
            }
            column(Promedio_DiarioCaption; Promedio_DiarioCaptionLbl)
            {
            }
            column(Ultimo_Sueldo_Mensual_RD_Caption; Ultimo_Sueldo_Mensual_RD_CaptionLbl)
            {
            }
            column(DETALLES_DE_LIQUIDACION_DE_PRESTACIONES_LABORALESCaption; DETALLES_DE_LIQUIDACION_DE_PRESTACIONES_LABORALESCaptionLbl)
            {
            }
            column(SFS_Caption; SFSCaption)
            {
            }
            column(AFP_Caption; AFPCaption)
            {
            }
            column(D_asCaption_Control86; D_asCaption_Control86Lbl)
            {
            }
            column(RD_Caption_Control89; RD_Caption_Control89Lbl)
            {
            }
            column(D_asCaption_Control90; D_asCaption_Control90Lbl)
            {
            }
            column(RD_Caption_Control95; RD_Caption_Control95Lbl)
            {
            }
            column(TOTAL_LIQUIDACION_PRESTACIONES_LABORALESCaption; TOTAL_LIQUIDACION_PRESTACIONES_LABORALESCaptionLbl)
            {
            }
            column(IV__Salario_devengado_del_Caption; IV__Salario_devengado_del_CaptionLbl)
            {
            }
            column(alCaption; alCaptionLbl)
            {
            }
            column(RD_Caption_Control105; RD_Caption_Control105Lbl)
            {
            }
            column(RD_Caption_Control109; RD_Caption_Control109Lbl)
            {
            }
            column(TOTAL_DE_PAGOSCaption; TOTAL_DE_PAGOSCaptionLbl)
            {
            }
            column(RD_Caption_Control113; RD_Caption_Control113Lbl)
            {
            }
            column(Otras_DeduccionesCaption; Otras_DeduccionesCaptionLbl)
            {
            }
            column(RD_Caption_Control117; RD_Caption_Control117Lbl)
            {
            }
            column(Avance_SalariosCaption; Avance_SalariosCaptionLbl)
            {
            }
            column(RD_Caption_Control121; RD_Caption_Control121Lbl)
            {
            }
            column(TOTAL_DEDUCCIONESCaption; TOTAL_DEDUCCIONESCaptionLbl)
            {
            }
            column(NETO_A_PAGARCaption; NETO_A_PAGARCaptionLbl)
            {
            }
            column(RD_Caption_Control127; RD_Caption_Control127Lbl)
            {
            }
            column(RD_Caption_Control128; RD_Caption_Control128Lbl)
            {
            }
            column(Aprobado_porCaption; Aprobado_porCaptionLbl)
            {
            }
            column(FechaCaption; FechaCaptionLbl)
            {
            }
            column(MENOS__Caption; MENOS__CaptionLbl)
            {
            }
            column(Recibido_ConformeCaption; Recibido_ConformeCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(Pago_Dias_Adci_Captionlbl; PagoDiasAdi_Captionlbl)
            {
            }
            dataitem("Perfil Salarial"; "Perfil Salarial")
            {
                DataItemLink = "No. empleado" = FIELD("No.");
                DataItemTableView = SORTING("No. empleado", "Perfil salarial", "Concepto salarial") ORDER(Ascending) WHERE("Salario Base" = FILTER(true));

                trigger OnAfterGetRecord()
                begin
                    //Busco tipo de nomina regular
                    TiposdenominasReg.Reset;
                    TiposdenominasReg.SetRange("Tipo de nomina", TiposdenominasReg."Tipo de nomina"::Regular);
                    TiposdenominasReg.FindFirst;

                    HistLinNom.Reset;
                    HistLinNom.SetRange("No. empleado", Employee."No.");
                    HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
                    HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto Preaviso");
                    HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
                    if HistLinNom.FindLast then begin
                        PromedioSalarioMensual := Round(HistLinNom."Importe Base" * 23.83, 0.01);
                        PromedioSalarioAnual := PromedioSalarioMensual * 12;
                        PromedioSalarioDiario := HistLinNom."Importe Base";
                        UltimoSalario := 0;

                        HistCabNom.Reset;
                        HistCabNom.SetRange("No. empleado", Employee."No.");
                        HistCabNom.SetRange("Tipo de nomina", TiposdenominasReg.Codigo);
                        HistCabNom.FindLast;

                        HistLinNom.Reset;
                        HistLinNom.SetRange("No. empleado", Employee."No.");
                        HistLinNom.SetRange(Período, HistCabNom.Período);
                        HistLinNom.SetRange("Tipo de nomina", TiposdenominasReg.Codigo);
                        HistLinNom.SetRange("Salario Base", true);
                        HistLinNom.FindSet;
                        repeat
                            UltimoSalario += HistLinNom."Importe Base";
                        until HistLinNom.Next = 0;
                        CalcularDesdeHistorico := true;
                    end
                    else
                        if not Calculoenbaseultimosalario then
                            BuscaSalarioPromedio
                        else begin
                            Salario := Importe;
                            UltimoSalario := Importe;
                            HistLinNom.Reset;
                            HistLinNom.SetRange("No. empleado", Employee."No.");
                            HistLinNom.SetRange(Período, CalcDate('-1' + CDateSymbol, DMY2Date(1, Date2DMY(Employee."Termination Date", 2), Date2DMY(Employee."Termination Date", 3))),
                                                        Employee."Termination Date");
                            HistLinNom.SetRange("Salario Base", true);
                            if HistLinNom.FindSet then
                                repeat
                                    PromedioSalarioAnual += HistLinNom.Total;
                                until HistLinNom.Next = 0;

                            PromedioSalarioMensual := UltimoSalario;
                            /*
                            IF GAno > 0 THEN
                              MontoRegalia  := UltimoSalario / 12
                            ELSE
                              MontoRegalia  := UltimoSalario / 12 * GMes;
                            */
                            HistLinNom.Reset;
                            HistLinNom.SetRange("No. empleado", Employee."No.");
                            HistLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(Employee."Termination Date", 3)),
                                                        Employee."Termination Date");
                            HistLinNom.SetRange("Aplica para Regalia", true);
                            if HistLinNom.FindSet then
                                repeat
                                    MontoRegalia += HistLinNom.Total;
                                until HistLinNom.Next = 0;
                            MontoRegalia := MontoRegalia / 12;
                            PromedioSalarioDiario := PromedioSalarioMensual / 23.83;
                        end;

                    if (CalcularPreaviso) or (CalcularDesdeHistorico) then
                        CálculoPreaviso(MontoPreaviso);

                    if (CalcularCesantia) or (CalcularDesdeHistorico) then
                        CálculoCesantía(MontoCesantia);

                    if (not VacacionesPagadas) or (CalcularDesdeHistorico) then
                        CálculoVacaciones(MontoVacaciones);

                    //GRN IF "Pagar Regalía" THEN
                    if not Calculoenbaseultimosalario then
                        CálculoRegalia(MontoRegalia);

                    //IF DiasSalario <> 0 THEN
                    CompletivoUltSalarioNom(MontoRestante);


                    CalcularDtosLegales;


                    OtrasDeducciones := 0;
                    HistLinNom.Reset;
                    HistLinNom.SetRange("No. empleado", Employee."No.");
                    HistLinNom.SetRange("Tipo concepto", HistLinNom."Tipo concepto"::Deducciones);
                    HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
                    HistLinNom.SetFilter("Concepto salarial", '<>%1&<>%2', ConfNominas."Concepto AFP", ConfNominas."Concepto SFS");
                    HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
                    //ERROR('%1',HistLinNom.GETFILTERS);
                    if HistLinNom.FindSet then
                        repeat
                            OtrasDeducciones += HistLinNom.Total;
                        until HistLinNom.Next = 0;
                    MontoCalculoGral := Round((MontoPreaviso + MontoCesantia + MontoRegalia + MontoVacaciones + MontoRestante),
                                               ConfCG."Amount Rounding Precision");
                    //"Salida%"        := FORMAT(MontoCalculoGral);

                    //MontoCalculoCesantia := ROUND((MontoCesantia + MontoPreaviso), rCongCG."Amount Rounding Precision");
                    exit;

                end;

                trigger OnPreDataItem()
                begin
                    ConfCG.Get();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Categor.Get(Departamento, "Job Type Code");
                InicializaVariables;
                if "Termination Date" = 0D then
                    "Termination Date" := WorkDate;

                Depto.Get(Departamento);
                if not Bco.Get("Disponible 1") then
                    Bco.Init;

                RegRegUdadCotiz.Get(Company);

                AnoTrabajo := Date2DMY("Termination Date", 3);
                MesTrabajo := Date2DMY("Termination Date", 2);
                diaTrabajo := Date2DMY("Termination Date", 1);

                //Nomina CalculoFechas.CalculoEntreFechas(Employee."Employment Date", Employee."Termination Date", Anos, Meses, Dias);
                if not IncluirFechaSalida then
                    Dias -= 1;

                GAno := Anos;
                GMes := Meses;
                GDía := Dias;
            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
                ConfNominas.TestField("Concepto Preaviso");
                ConfNominas.TestField("Concepto Cesantia");

                Tiposdenominas.Reset;
                Tiposdenominas.SetRange("Tipo de nomina", Tiposdenominas."Tipo de nomina"::Prestaciones);
                Tiposdenominas.FindFirst;

                CalcularDesdeHistorico := false;
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
                field("Vacaciones pagadas"; VacacionesPagadas)
                {
                ApplicationArea = All;
                }
                field(CalcularPreaviso; CalcularPreaviso)
                {
                ApplicationArea = All;
                    Caption = 'Calculate Notificacion';
                }
                field(CalcularCesantia; CalcularCesantia)
                {
                ApplicationArea = All;
                    Caption = 'Calculate Censantía';
                }
                field("Pagar regalía"; "Pagar Regalía")
                {
                ApplicationArea = All;
                }
                field(Calculoenbaseultimosalario; Calculoenbaseultimosalario)
                {
                ApplicationArea = All;
                    Caption = 'Calculation based on last salary';
                }
                field(IncluirFechaSalida; IncluirFechaSalida)
                {
                ApplicationArea = All;
                    Caption = 'Include end date in calculation';
                }
                field("Días diferencia salario"; DiasSalario)
                {
                ApplicationArea = All;
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
        ConfCG: Record "General Ledger Setup";
        Categor: Record "Puestos laborales";
        RegRegUdadCotiz: Record "Empresas Cotizacion";
        Bco: Record Bancos;
        Fecha: Record Date;
        HistoricoSalarios: Record "Acumulado Salarios";
        Depto: Record Departamentos;
        Contrato: Record Contratos;
        HistCabNom: Record "Historico Cab. nomina";
        HistLinNom: Record "Historico Lin. nomina";
        PerfilSal: Record "Perfil Salarial";
        ConfNominas: Record "Configuracion nominas";
        Tiposdenominas: Record "Tipos de nominas";
        TiposdenominasReg: Record "Tipos de nominas";
        //CalculoFechas: Codeunit "Funciones Nomina"; //Nomina
        Salario: Decimal;
        "FechaCálculo": Date;
        GAno: Integer;
        GMes: Integer;
        "GDía": Integer;
        ImportePreaviso: Decimal;
        ImporteCesantia: Decimal;
        ImporteAFP: Decimal;
        ImporteSFS: Decimal;
        DevolucionISR: Decimal;
        DiasPreaviso: Integer;
        DiasCesantia: Integer;
        DiasVacaciones: Integer;
        MontoPreaviso: Decimal;
        MontoCesantia: Decimal;
        MontoRegalia: Decimal;
        AcumuladoRegalia: Decimal;
        MontoVacaciones: Decimal;
        VacacionesPagadas: Boolean;
        "Pagar Regalía": Boolean;
        CalcularPreaviso: Boolean;
        CalcularCesantia: Boolean;
        FechaProceso: Date;
        MesesRegalia: Integer;
        UltimoSalario: Decimal;
        PromedioSalarioAnual: Decimal;
        PromedioSalarioMensual: Decimal;
        PromedioSalarioDiario: Decimal;
        InicioAno: Date;
        MontoRestante: Decimal;
        AvanceSalario: Decimal;
        OtrasDeducciones: Decimal;
        DiasSalario: Integer;
        PromedioSalarioDRegalia: Decimal;
        ImporteSueldoAcumulado: Decimal;
        MesesAcumulado: Decimal;
        MontoaDeducir: Decimal;
        PromedioSalarioDiarioVac: Decimal;
        MontoCalculoGral: Decimal;
        MontoCalculoCesantia: Decimal;
        SalidaCesantia: Text[30];
        AnoTrabajo: Integer;
        MesTrabajo: Integer;
        diaTrabajo: Integer;
        DiasReg: Integer;
        CDateSymbol: Label 'Y';
        II__CESANTIACaptionLbl: Label 'II. CESANTIA';
        RD_CaptionLbl: Label 'RD$';
        D_asCaptionLbl: Label 'Días';
        I__PREAVISOCaptionLbl: Label 'I. PREAVISO';
        Nombres_y_ApellidosCaptionLbl: Label 'Full name';
        V__REGALIACaptionLbl: Label 'IV. REGALIA';
        III__VACACIONESCaptionLbl: Label 'III. VACACIONES';
        Gerencia_de_Recursos_HumanosCaptionLbl: Label 'Gerencia de Recursos Humanos';
        LIQUIDACION_DE_PRESTACIONES_LABORALESCaptionLbl: Label 'CALCULATION OF LABOR BENEFITS';
        DepartamentoCaptionLbl: Label 'Department';
        CargoCaptionLbl: Label 'Position';
        Fecha_de_IngresoCaptionLbl: Label 'Employment date';
        Fecha_de_SalidaCaptionLbl: Label 'Termination Date';
        Tiempo_TrabajadoCaptionLbl: Label 'Worked time';
        Sueldo_devengado_en_el__ltimo_a_oCaptionLbl: Label 'Acumulado Salario de Navidad';
        Promedio_Mensual_RD_CaptionLbl: Label 'Monthly average RD$';
        Promedio_DiarioCaptionLbl: Label 'Daily average';
        Ultimo_Sueldo_Mensual_RD_CaptionLbl: Label 'Last monthly salary RD$';
        DETALLES_DE_LIQUIDACION_DE_PRESTACIONES_LABORALESCaptionLbl: Label 'DETALLES DE LIQUIDACION DE PRESTACIONES LABORALES';
        D_asCaption_Control86Lbl: Label 'Días';
        RD_Caption_Control89Lbl: Label 'RD$';
        D_asCaption_Control90Lbl: Label 'Días';
        RD_Caption_Control95Lbl: Label 'RD$';
        TOTAL_LIQUIDACION_PRESTACIONES_LABORALESCaptionLbl: Label 'TOTAL LIQUIDACION PRESTACIONES LABORALES';
        IV__Salario_devengado_del_CaptionLbl: Label 'IV. Salario devengado del ';
        alCaptionLbl: Label 'al';
        RD_Caption_Control105Lbl: Label 'RD$';
        RD_Caption_Control109Lbl: Label 'RD$';
        TOTAL_DE_PAGOSCaptionLbl: Label 'TOTAL DE PAGOS';
        RD_Caption_Control113Lbl: Label 'RD$';
        Otras_DeduccionesCaptionLbl: Label 'Otras Deducciones';
        RD_Caption_Control117Lbl: Label 'RD$';
        Avance_SalariosCaptionLbl: Label 'Avance Salarios';
        RD_Caption_Control121Lbl: Label 'RD$';
        TOTAL_DEDUCCIONESCaptionLbl: Label 'TOTAL DEDUCCIONES';
        NETO_A_PAGARCaptionLbl: Label 'NETO A PAGAR';
        RD_Caption_Control127Lbl: Label 'RD$';
        RD_Caption_Control128Lbl: Label 'RD$';
        Aprobado_porCaptionLbl: Label 'Aprobado por';
        FechaCaptionLbl: Label 'Fecha';
        MENOS__CaptionLbl: Label 'MENOS :';
        Recibido_ConformeCaptionLbl: Label 'Recibido Conforme';
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        Calculoenbaseultimosalario: Boolean;
        SFSCaption: Label 'V. Seguro Familiar de Salud';
        AFPCaption: Label 'VI. Fondo de Pensiones';
        IncluirFechaSalida: Boolean;
        PagoDiasAdi_Captionlbl: Label 'Payment extra days worked';
        CalcularDesdeHistorico: Boolean;


    procedure "CálculoPreaviso"(var MontoPreaviso: Decimal)
    var
        FechaCalculo: Date;
        CantidadAnos: Integer;
    begin
        if Anos = 0 then
            if Meses > 0 then begin
                if (Meses >= 3) and (Meses < 6) then
                    DiasPreaviso := 7
                else
                    if (Meses >= 6) and (Meses < 12) then
                        DiasPreaviso := 14
                    else
                        if Meses = 12 then
                            DiasPreaviso := 28;
            end
            else
                if Anos > 0 then
                    DiasPreaviso := 28
                else
                    exit
        else
            DiasPreaviso := 28;

        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto Preaviso");
        //HistLinNom.SETRANGE(Período,Employee."Termination Date", CALCDATE('+45D',Employee."Termination Date"));
        if HistLinNom.FindLast then begin
            DiasPreaviso := HistLinNom.Cantidad;
            MontoPreaviso := HistLinNom.Total;
            //  MESSAGE('%',MontoPreaviso);
        end
        else
            MontoPreaviso := PromedioSalarioDiario * DiasPreaviso;
    end;


    procedure "CálculoCesantía"("LMontoCesantía": Decimal)
    var
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
    begin
        //Nomina CalculoFechas.CalculoEntreFechas(Employee."Employment Date", Employee."Termination Date", Anos, Meses, Dias);

        if Anos = 0 then
            if Meses > 0 then begin
                if (Meses >= 3) and (Meses < 6) then
                    DiasCesantia := 6
                else
                    if Meses >= 6 then
                        DiasCesantia := 13;
            end
            else
                exit
        else
            if (Anos >= 1) and (Anos < 5) then begin
                DiasCesantia := 21 * Anos;

                if ((Meses >= 3) and ((Meses <= 6) and (Dias = 0))) or
                   ((Meses >= 3) and (Meses < 6)) then
                    DiasCesantia += 6
                else
                    if (Meses >= 6) and (Dias > 0) then
                        DiasCesantia += 13;
            end
            else
                if Anos >= 5 then begin
                    if Employee."Employment Date" < DMY2Date(29, 5, 92) then
                        DiasCesantia := 15 * Anos
                    else
                        DiasCesantia := 23 * Anos;

                    if (Meses >= 3) and (Meses <= 6) then
                        DiasCesantia += 6
                    else
                        if Meses >= 7 then
                            DiasCesantia += 13;
                end;

        SalidaCesantia := Format(Round(PromedioSalarioDiario * DiasCesantia, 0.01));
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto Cesantia");
        HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
        if HistLinNom.FindFirst then begin
            DiasCesantia := HistLinNom.Cantidad;
            MontoCesantia := HistLinNom.Total;
        end
        else
            MontoCesantia := PromedioSalarioDiario * DiasCesantia;
    end;


    procedure "CálculoVacaciones"(var MontoVacaciones: Decimal)
    var
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
    begin
        //Vacaciones
        //Nomina CalculoFechas.CalculoEntreFechas(Employee."Employment Date", Employee."Termination Date", Anos, Meses, Dias);
        //Nomina DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Employee."No.", MesTrabajo, AnoTrabajo, MontoVacaciones, Employee."Employment Date", Employee."Fecha salida empresa");
        /*
        PromedioSalarioDiarioVac := "Perfil Salarial".Importe / 23.83;
        MontoVacaciones          := PromedioSalarioDiarioVac * DiasVacaciones;
        */
        MontoVacaciones := 0;
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Tipo concepto", HistLinNom."Tipo concepto"::Ingresos);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto Vacaciones");
        HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
        if HistLinNom.FindSet then
            repeat
                MontoVacaciones += HistLinNom.Total;
            until HistLinNom.Next = 0;

    end;


    procedure "CálculoRegalia"(var MontoRegalia: Decimal)
    var
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        FechaIni: Date;
    begin
        //Regalia
        if (Date2DMY(Employee."Employment Date", 3) < Date2DMY(WorkDate, 3)) and (Employee."Termination Date" = 0D) then begin
            FechaIni := DMY2Date(1, 1, Date2DMY(WorkDate, 3));
            //Nomina CalculoFechas.CalculoEntreFechas(FechaIni, Employee."Termination Date", Anos, Meses, Dias);
        end;
        /*else //Nomina
            CalculoFechas.CalculoEntreFechas(Employee."Employment Date", Employee."Termination Date", Anos, Meses, Dias);*/

        MesesRegalia := Meses;

        Employee.SetRange("Date Filter", DMY2Date(1, 1, Date2DMY(WorkDate, 3)), DMY2Date(31, 12, Date2DMY(WorkDate, 3)));

        Employee.CalcFields("Acumulado Salario");

        //message('%1 %2 %3 %4',employee."acumulado salario",promediosalariodregalia,montoregalia,dias);
        /*
        IF MesesRegalia < 12 THEN
           BEGIN
             MontoRegalia := Employee."Acumulado Salario";
             IF Dias <> 0 THEN
                MontoRegalia := PromedioSalarioDRegalia * Dias;
        
             MontoRegalia /= 12;
           END
        ELSE
           MontoRegalia := Employee."Acumulado Salario";
        */
        //Busco el acumulado de regalia en el periodo
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange(Período, DMY2Date(1, 1, Date2DMY(Employee."Termination Date", 3)),
                                    Employee."Termination Date");
        HistLinNom.SetRange("Aplica para Regalia", true);
        if HistLinNom.FindSet then
            repeat
                AcumuladoRegalia += HistLinNom.Total;
            until HistLinNom.Next = 0;

        MontoRegalia := AcumuladoRegalia / 12;

        DiasReg := Dias;

        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto Regalia");
        HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
        if HistLinNom.FindFirst then
            MontoRegalia := HistLinNom.Total

    end;


    procedure BuscaSalarioPromedio()
    var
        Periodo: array[12] of Decimal;
        Salarios: array[12] of Decimal;
        TotalTiempoTrabajado: Decimal;
        TotalPeriodo: Decimal;
        M: Integer;
        N: Integer;
    begin
        //Salario Promedio
        //Busco la ultima nomina regular
        HistCabNom.Reset;
        HistCabNom.SetRange("No. empleado", Employee."No.");
        HistCabNom.SetRange("Tipo de nomina", TiposdenominasReg.Codigo);
        HistCabNom.FindLast;
        /*
        PerfilSal.SETRANGE("No. empleado", Employee."No.");
        PerfilSal.SETRANGE("Tipo concepto", "Perfil Salarial"."Tipo concepto"::Ingresos);
        PerfilSal.SETRANGE("Salario Base", TRUE);
        IF PerfilSal.FINDLAST THEN
           UltimoSalario := PerfilSal.Importe;
        */
        UltimoSalario := 0;
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange(Período, HistCabNom.Período);
        HistLinNom.SetRange("Tipo de nomina", TiposdenominasReg.Codigo);
        HistLinNom.SetRange("Salario Base", true);
        HistLinNom.FindSet;
        repeat
            UltimoSalario += HistLinNom."Importe Base";
        until HistLinNom.Next = 0;

        Clear(Periodo);
        Clear(Salarios);
        M := 0;
        N := 0;
        PromedioSalarioAnual := 0;
        PromedioSalarioMensual := UltimoSalario;
        PromedioSalarioDiario := 0;
        TotalPeriodo := 0;
        MesesAcumulado := 12;


        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange(Período, CalcDate('-1' + CDateSymbol, DMY2Date(1, Date2DMY(Employee."Termination Date", 2), Date2DMY(Employee."Termination Date", 3))),
                                    Employee."Termination Date");
        HistLinNom.SetRange("Salario Base", true);
        if HistLinNom.FindSet then
            repeat
                PromedioSalarioAnual += HistLinNom.Total;
                ImporteSueldoAcumulado += HistLinNom.Total;
            until HistLinNom.Next = 0;
        /*
        
        HistoricoSalarios.RESET;
        HistoricoSalarios.SETRANGE("No. empleado", Employee."No.");
        HistoricoSalarios.SETRANGE("Fecha Hasta",CALCDATE('-1'+CDateSymbol,DMY2DATE(01,DATE2DMY(Employee."Termination Date",2),DATE2DMY(Employee."Termination Date",3))),
                                    Employee."Termination Date");
                                    //MESSAGE('%1',HistoricoSalarios.GETFILTERS);
        IF HistoricoSalarios.FINDSET THEN
          BEGIN
            WITH HistoricoSalarios DO
              REPEAT
                M := M + 1;
                IF "Fecha Hasta" <>0D THEN
                   Periodo[M]  := ("Fecha Hasta" - "Fecha Desde") / 30
                ELSE
                   Periodo[M]  := (Employee."Termination Date" - "Fecha Desde") / 30;
        
                Salarios[M] := Importe * Periodo[M];
        //        message('%1 %2 %3 %4',salarios[m],importe,periodo[m]);
              UNTIL HistoricoSalarios.NEXT = 0;
        
            FOR N := 1 TO M DO
              BEGIN
                PromedioSalarioAnual := PromedioSalarioAnual + Salarios[N];
                TotalPeriodo         := TotalPeriodo + Periodo[N];
              END;
        
            IF Calculoenbaseultimosalario THEN
               PromedioSalarioAnual := "Perfil Salarial".Importe;
            PromedioSalarioDRegalia  := UltimoSalario / 30;
        //GRN    PromedioSalarioMensual   := PromedioSalarioAnual / TotalPeriodo;
        //GRN    PromedioSalarioMensual   := ImporteSueldoAcumulado / MesesAcumulado / TotalPeriodo;
        //    MESSAGE('%1 %2 %3 %4',PromedioSalarioAnual,MesesAcumulado,PromedioSalarioAnual);
            PromedioSalarioMensual   := PromedioSalarioAnual / MesesAcumulado;
            PromedioSalarioDiario    := PromedioSalarioMensual / 23.83;
          END
        ELSE
        */
        begin
            if ImporteSueldoAcumulado <> 0 then begin
                PromedioSalarioAnual := ImporteSueldoAcumulado;
                PromedioSalarioMensual := ImporteSueldoAcumulado / MesesAcumulado;
                PromedioSalarioDRegalia := ImporteSueldoAcumulado / 12;
                PromedioSalarioDiario := PromedioSalarioMensual / 23.83;
            end
            else begin
                PromedioSalarioAnual := UltimoSalario;
                PromedioSalarioMensual := UltimoSalario;
                PromedioSalarioDRegalia := UltimoSalario / 12;
                PromedioSalarioDiario := PromedioSalarioMensual / 23.83;
                PromedioSalarioAnual := ImporteSueldoAcumulado;
            end
        end;

    end;


    procedure InicializaVariables()
    begin
        GAno := 0;
        GMes := 0;
        GDía := 0;
        PromedioSalarioAnual := 0;
        PromedioSalarioMensual := 0;
        PromedioSalarioDiario := 0;
        Salario := 0;
        ImportePreaviso := 0;
        ImporteCesantia := 0;
        DiasPreaviso := 0;
        DiasCesantia := 0;
        DiasVacaciones := 0;
        MontoPreaviso := 0;
        MontoCesantia := 0;
        MontoRegalia := 0;
        MontoVacaciones := 0;
        MesesRegalia := 0;
        AcumuladoRegalia := 0;
        OtrasDeducciones := 0;
    end;


    procedure InicioReporte(StatusVacacionesParam: Boolean; PagarRegaliaParam: Boolean; DiasSalarioNomParam: Integer; ImporteAcumuladoParam: Decimal; MesesAcumuladoParam: Decimal; MontoDeduccionesParam: Decimal; PorcCesantia: Decimal; PorcPreaviso: Decimal; ProcMontoGral: Decimal)
    begin
        VacacionesPagadas := StatusVacacionesParam;
        "Pagar Regalía" := PagarRegaliaParam;
        DiasSalario := DiasSalarioNomParam;
        ImporteSueldoAcumulado := ImporteAcumuladoParam;
        MesesAcumulado := MesesAcumuladoParam;
        MontoaDeducir := MontoDeduccionesParam;
    end;


    procedure CompletivoUltSalarioNom(var completivoultsalarionomina: Decimal)
    begin
        Employee.CalcFields(Salario);
        MontoRestante := Round(Employee.Salario / 23.83 * DiasSalario, 0.01);

        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Tipo concepto", HistLinNom."Tipo concepto"::Ingresos);
        HistLinNom.SetFilter("Concepto salarial", '<>%1&<>%2&<>%3&<>%4', ConfNominas."Concepto Regalia", ConfNominas."Concepto Vacaciones", ConfNominas."Concepto Cesantia", ConfNominas."Concepto Preaviso");
        HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
        if HistLinNom.FindSet then
            repeat
                MontoRestante += HistLinNom.Total;
            until HistLinNom.Next = 0;
    end;

    local procedure CalcularDtosLegales()
    var
        DeduccGob: Record "Tipos de Cotización";
    begin
        /*
        IF Employee."Excluído Cotización TSS" THEN
           EXIT;
        
        ConfNominas.GET();
        
        DeduccGob.RESET;
        DeduccGob.SETRANGE(Ano,AnoTrabajo);
        DeduccGob.SETFILTER("Porciento Empleado",'<>%1',0);
        IF DeduccGob.FINDSET THEN
           REPEAT
            IF ConfNominas."Concepto AFP" = DeduccGob.Código THEN
               ImporteAFP := (MontoVacaciones + MontoRestante) * DeduccGob."Porciento Empleado" /100
            ELSE
            IF ConfNominas."Concepto SFS" = DeduccGob.Código THEN
               ImporteSFS := (MontoVacaciones + MontoRestante) * DeduccGob."Porciento Empleado" /100;
           UNTIL DeduccGob.NEXT = 0;
        */
        ImporteAFP := Round(ImporteAFP, 0.01);
        ImporteSFS := Round(ImporteSFS, 0.01);

        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto SFS");
        HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
        if HistLinNom.FindFirst then
            ImporteSFS := HistLinNom.Total;

        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", Employee."No.");
        HistLinNom.SetRange("Tipo de nomina", Tiposdenominas.Codigo);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto AFP");
        HistLinNom.SetRange(Período, Employee."Termination Date", CalcDate('+45D', Employee."Termination Date"));
        if HistLinNom.FindFirst then
            ImporteAFP := HistLinNom.Total;

    end;
}

