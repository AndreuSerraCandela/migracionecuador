codeunit 76062 "Registrar nomina CR"
{
    TableNo = "Perfil Salarial";

    trigger OnRun()
    begin
        GlobalRec.Copy(Rec);
        CODIGO;
        Rec.Copy(GlobalRec);
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        ConceptosSal: Record "Conceptos salariales";
        GlobalRec: Record "Perfil Salarial";
        DfltDimension: Record "Default Dimension";
        RegEmpCotiz: Record "Empresas Cotizacion";
        Calendar: Record Calendario;
        Empleado: Record Employee;
        PerfilSal: Record "Perfil Salarial";
        PerfilSalImp: Record "Perfil Salarial";
        Fecha: Record Date;
        CabNomina: Record "Historico Cab. nomina";
        LinNomina: Record "Historico Lin. nomina";
        Contrato: Record Contratos;
        Ausencia: Record "Income tax Employee parameters";
        CurrExchange: Record "Currency Exchange Rate";
        CalcDias: Record "Parametros Calculo Dias";
        Cargos: Record "Puestos laborales";
        DtosPend: Record "Descuentos pendientes";
        recTmpDimEntry: Record "Dimension Set Entry" temporary;
        cduDim: Codeunit DimensionManagement;
        Generar: Boolean;
        "Período": Integer;
        PerInici: Date;
        PerFinal: Date;
        Tipcalculo: Integer;
        dia: Integer;
        Mes1: Integer;
        Ano: Integer;
        InicioPer: Date;
        FinPer: Date;
        "DiasAusencia100%": Decimal;
        FechaIniAusencia: Date;
        FechaFinAusencia: Date;
        LinTabla: Integer;
        TotalAusencia: Decimal;
        TotalISR: array[3, 3] of Decimal;
        TotalIngresos: Decimal;
        TotalDescuentos: Decimal;
        IngresoSalario: Decimal;
        ImporteLinea: Decimal;
        DiasMes: Integer;
        "%Cot": Decimal;
        ImporteTotal: Decimal;
        ImporteBaseImp: Decimal;
        PrimeraQ: Boolean;
        SegundaQ: Boolean;
        ImporteCotizacion: Decimal;
        Err001: Label '%1 is an invalid number to calculate the payroll for Employee %2';
        ImporteCotizacionRec: Decimal;
        Err002: Label 'Starting Date must be day 1st or 16th';
        NoDocNomin: Code[20];
        ImpFactura: Decimal;


    procedure CODIGO()
    begin
        ConfNominas.Get();
        ConfNominas.TestField("Concepto ISR");

        Contrato.Reset;
        Contrato.SetRange("No. empleado", GlobalRec."No. empleado");
        Contrato.SetRange(Activo, true);
        Contrato.FindFirst;

        PrimeraQ := false;
        SegundaQ := false;
        ImporteCotizacion := 0;
        ImporteTotal := 0;
        "%Cot" := 0;
        ImporteBaseImp := 0;
        TotalIngresos := 0;
        TotalDescuentos := 0;

        DtosPend.Reset;
        DtosPend.SetRange("Cod. Empleado", GlobalRec."No. empleado");
        DtosPend.DeleteAll;

        //     with GlobalRec do begin
        //         Empleado.Get("No. empleado");

        //         PerInici := GlobalRec."Inicio Periodo";
        //         PerFinal := GlobalRec."Fin Período";
        //         dia := Date2DMY(PerInici, 1);
        //         if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
        //             if (dia <> 1) and (dia <> 16) then
        //                 Error(Err002);
        //         Mes := Date2DMY(PerInici, 2);
        //         Ano := Date2DMY(PerInici, 3);

        //         if (Empleado."Fecha salida empresa" <> 0D) and (Empleado."Fecha salida empresa" < PerInici) and
        //            (Empleado."Calcular Nomina") then begin
        //             if Contrato."Fecha finalización" = 0D then begin
        //                 Empleado."Calcular Nomina" := false;
        //                 Empleado."Fin contrato" := Empleado."Fecha salida empresa";
        //                 Empleado.Modify;

        //                 Contrato."Fecha finalización" := Empleado."Fecha salida empresa";
        //                 Contrato.Finalizado := true;
        //                 Contrato.Modify;
        //                 exit;
        //             end;
        //         end;

        //         //Para calcular el ingreso por Bono de Antigueda antes de empezar a calcular la nomina.
        //         CalculaBonoAntiguedad(Empleado."Employment Date", PerFinal);
        //         CalculaDiasVacaciones;

        //         CrearCabecera;
        //         // --------------------

        //         PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        //         PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        //         PerfilSal.SetFilter(Cantidad, '<>0');
        //         PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Ingresos);

        //         if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
        //             if dia = 1 then begin
        //                 if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal then
        //                     PerfilSal.SetRange("1ra Quincena", true);

        //                 PrimeraQ := true;
        //             end
        //             else begin
        //                 if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal then
        //                     PerfilSal.SetRange("2da Quincena", true);

        //                 SegundaQ := true;
        //             end;

        //         if PerfilSal.FindSet() then
        //             repeat
        //                 //Para la bonificacion
        //                 if GlobalRec."Tipo Nomina" = 2 then begin
        //                     CalculoBonificacion;
        //                     CalcularDtosLegales;
        //                     if not ConfNominas."Impuestos manuales" then
        //                         CalcularISR;
        //                     exit;
        //                 end;

        //                 //Para la Regalia
        //                 if GlobalRec."Tipo Nomina" = 1 then begin
        //                     CalculoRegalia;
        //                     exit;
        //                 end;

        //                 CalcularIngresos;
        //             until PerfilSal.Next = 0;

        //         //GRN Elimino Cabecera de los empleados que no tengan ingresos o deducciones
        //         CabNomina.CalcFields("Total Ingresos");
        //         if CabNomina."Total Ingresos" = 0 then begin
        //             DfltDimension.Reset;
        //             DfltDimension.SetRange("Table ID", 5200);
        //             DfltDimension.SetRange("No.", GlobalRec."No. empleado");
        //             if DfltDimension.FindSet() then
        //                 repeat
        //                     DfltDimension.Delete;
        //                 until DfltDimension.Next = 0;

        //             CabNomina.Delete;
        //         end;

        //         PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Deducciones);
        //         if PerfilSal.FindSet() then
        //             repeat
        //                 //Para la bonificacion
        //                 if GlobalRec."Tipo Nomina" = 2 then begin
        //                     CalculoBonificacion;
        //                     exit;
        //                 end;

        //                 //Para la Regalia
        //                 if GlobalRec."Tipo Nomina" = 1 then begin
        //                     CalculoRegalia;
        //                     exit;
        //                 end;

        //                 CalcularPrestamos;
        //                 CalcularDescuentos;
        //             until PerfilSal.Next = 0;

        //         if Empleado."Calcular Nomina" then begin
        //             CalcularDtosLegales;
        //             //      IF NOT Empleado."Excluído Cotización SFS" THEN
        //             if not ConfNominas."Impuestos manuales" then
        //                 CalcularISR;
        //         end;

        //         if Empleado."Fecha salida empresa" <> 0D then begin
        //             if Contrato."Fecha finalización" = 0D then begin
        //                 Empleado."Calcular Nomina" := false;
        //                 Empleado."Fin contrato" := Empleado."Fecha salida empresa";
        //                 Empleado.Modify;

        //                 Contrato."Fecha finalización" := Empleado."Fecha salida empresa";
        //                 Contrato.Finalizado := true;
        //                 Contrato.Modify;
        //             end;
        //         end;
        //     end;
        // 
    end;


    procedure CrearCabecera()
    var
        CompanyTaxes: Record "Cab. Aportes Empresas";
        GestNoSer: Codeunit "No. Series";
    begin
        Contrato.SetRange("No. empleado", Empleado."No.");
        Contrato.SetRange(Finalizado, false);
        Contrato.FindFirst;

        CabNomina.Reset;
        CabNomina.SetRange(Período, GlobalRec."Inicio Periodo");
        CabNomina.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        if not CabNomina.FindFirst then
            CabNomina.Init;

        if CabNomina."No. Documento" = '' then begin
            ConfNominas.TestField("No. serie nominas");
            GestNoSer.GetNextNo(ConfNominas."No. serie nominas");
        end;

        //Create Payroll Header
        CabNomina."No. empleado" := GlobalRec."No. empleado";
        CabNomina.Ano := Ano;
        CabNomina.Período := GlobalRec."Inicio Periodo";
        CabNomina."Tipo Nomina" := GlobalRec."Tipo Nomina";
        CabNomina."Empresa cotización" := GlobalRec."Empresa cotizacion";
        CabNomina."Centro trabajo" := Empleado."Working Center";
        CabNomina."Salario Mínimo" := ConfNominas."Salario Minimo";
        CabNomina.Inicio := GlobalRec."Inicio Periodo";
        CabNomina.Fin := GlobalRec."Fin Período";
        CabNomina."Fecha Entrada" := Empleado."Employment Date";
        if (Contrato."Fecha finalización" <> 0D) and (Empleado."Fecha salida empresa" = 0D) then
            CabNomina."Fecha Salida" := Contrato."Fecha finalización"
        else
            CabNomina."Fecha Salida" := Empleado."Fecha salida empresa";
        CabNomina."Full name" := Empleado."Full Name";
        CabNomina.Cargo := Empleado."Job Type Code";
        CabNomina."Tipo Empleado" := Empleado."Tipo Empleado";
        CabNomina.Banco := Empleado."Disponible 1";
        CabNomina."Tipo Cuenta" := Empleado."Disponible 2";
        CabNomina.Cuenta := Empleado.Cuenta;
        CabNomina."Forma de Cobro" := Empleado."Forma de Cobro";
        CabNomina.Validate("Shortcut Dimension 1 Code", Empleado."Global Dimension 1 Code");
        CabNomina.Validate("Shortcut Dimension 2 Code", Empleado."Global Dimension 2 Code");
        CabNomina.Departamento := Empleado.Departamento;
        CabNomina."Sub-Departamento" := Empleado."Sub-Departamento";

        recTmpDimEntry.DeleteAll;
        InsertarDimTempDef(5200);
        CabNomina."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);

        CabNomina.Insert;


        //Create Company's Taxes Header
        CompanyTaxes."No. Documento" := CabNomina."No. Documento";
        CompanyTaxes."Unidad cotización" := CabNomina."Empresa cotización";
        CompanyTaxes.Período := CabNomina.Período;
        if CompanyTaxes.Insert then;
    end;


    procedure CalcularIngresos()
    var
        LinNominasES: Record "Historico Lin. nomina";
        Incidencias: Record "Employee Absence";
        Incidencias2: Record "Employee Absence";
        CauseAbs: Record "Cause of Absence";
        MovNovAD: Record "Tipos de acciones personal";
        MovNovAD2: Record "Tipos de acciones personal";
        HistVac: Record "Historico Vacaciones";
        ImporteIncid: Decimal;
        DiasIncid: Decimal;
        DiasPago: Decimal;
        CantidadDiasEnt: Decimal;
        CantidadDiasSal: Decimal;
        DiasAusencia: Decimal;
        DiasCal: Decimal;
        FechaFinal: Date;
        DiasMes: Integer;
    begin
        CantidadDiasEnt := 0;
        CantidadDiasSal := 0;
        DiasPago := 0;
        DiasIncid := 0;
        DiasCal := 0;

        if (PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Ingresos) and
           (PerfilSal."Tipo Nomina" = GlobalRec."Tipo Nomina") then begin
            PerfilSal.TestField(Cantidad);
            PerfilSal.TestField(Importe);

            ImporteTotal := PerfilSal.Cantidad * Round(PerfilSal.Importe);
            ImporteBaseImp := ImporteTotal;

            if PerfilSal."Currency Code" <> '' then
                if ConfNominas."Tasa Cambio Calculo Divisa" <> 0 then begin
                    ImporteTotal := Round(PerfilSal.Importe) * ConfNominas."Tasa Cambio Calculo Divisa";
                    ImporteBaseImp := ImporteTotal;
                end
                else begin
                    CurrExchange.SetRange("Currency Code", PerfilSal."Currency Code");
                    CurrExchange.SetRange("Starting Date", 0D, PerFinal);
                    CurrExchange.FindLast;
                    ImporteTotal := Round(PerfilSal.Importe) * CurrExchange."Relational Exch. Rate Amount";
                    ImporteBaseImp := ImporteTotal;
                end;


            if PerfilSal."Salario Base" then begin
                if PerfilSal."Currency Code" <> '' then begin
                    if ConfNominas."Tasa Cambio Calculo Divisa" <> 0 then begin
                        IngresoSalario := PerfilSal.Importe * ConfNominas."Tasa Cambio Calculo Divisa";
                        ImporteTotal := IngresoSalario;
                        ImporteBaseImp := ImporteTotal;
                    end
                    else begin
                        CurrExchange.SetRange("Currency Code", PerfilSal."Currency Code");
                        CurrExchange.SetRange("Starting Date", 0D, PerFinal);
                        CurrExchange.FindLast;
                        IngresoSalario := PerfilSal.Importe * CurrExchange."Relational Exch. Rate Amount";
                        ImporteTotal := IngresoSalario;
                        ImporteBaseImp := ImporteTotal;
                    end;

                    if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
                       (PerfilSal."1ra Quincena") and (PerfilSal."2da Quincena") then

                        //GRN            IF Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal THEN
                        ImporteTotal /= 2;
                end
                else begin
                    IngresoSalario := PerfilSal.Importe;

                    if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
                       (PerfilSal."1ra Quincena") and (PerfilSal."2da Quincena") then

                        //GRN           IF Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal THEN
                        if PerfilSal."1ra Quincena" and PerfilSal."2da Quincena" then
                            ImporteTotal /= 2;
                end;

                if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                    CantidadDiasEnt := 15;

                    //GRN            IF (Empleado."Employment Date" > DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3))) THEN
                    if (Empleado."Employment Date" > PerInici) then begin
                        CantidadDiasEnt := PerFinal - Empleado."Employment Date" + 1;

                        CantidadDiasEnt := CantidadDiasEnt - DiasAusencia;
                        if CantidadDiasEnt > 15 then
                            CantidadDiasEnt := 15
                        else
                            if CantidadDiasEnt <= 0 then
                                Error(Err001, CantidadDiasEnt, Empleado."No.");
                        /*
        //message('%1 %2 %3 %4',cantidaddiasent);
                        Fecha.RESET;
                        Fecha.SETRANGE("Period Type",0); //Dia
                        Fecha.SETRANGE("Period Start",Empleado."Employment Date",PerFinal);
        //                Fecha.setrange("Period End",closingdate(perfinal));
                        Fecha.SETRANGE("Period No.",6,7);//Sabado y Domingo
                        IF Fecha.FINDSET THEN
                           REPEAT
                            CASE Fecha."Period No." OF
                             6:
                              CantidadDiasEnt -= 0.5;
                             7:
                              CantidadDiasEnt -= 1;
                            END;
        //                    message('%1 %2 %3 %4',cantidaddiasent,Fecha."Period No.");
                         UNTIL Fecha.NEXT = 0;
                         */
                        DiasPago := CantidadDiasEnt;
                        ImporteBaseImp := ImporteTotal;
                    end;
                end
                else
                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then begin
                        CantidadDiasEnt := 30;
                        if Empleado."Employment Date" > PerInici then begin
                            CantidadDiasEnt := DMY2Date(CantidadDiasEnt, Date2DMY(PerFinal, 2), Date2DMY(PerFinal, 3)) -
                                                  Empleado."Employment Date";
                            if CantidadDiasEnt <= 0 then
                                Error(Err001, CantidadDiasEnt, Empleado."No.");
                            DiasPago := CantidadDiasEnt + 1;
                        end;
                    end;

                if (Contrato."Fecha finalización" <> 0D) and (Empleado."Fecha salida empresa" = 0D) then begin
                    Empleado."Fecha salida empresa" := Contrato."Fecha finalización";
                    Empleado.Modify;
                end;

                if MovNovAD2.FindLast then;

                //Para registrar las incidencias
                Clear(Incidencias);
                Incidencias.SetRange("Employee No.", Empleado."No.");
                Incidencias.SetFilter("From Date", '>=%1', DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)));
                Incidencias.SetFilter("To Date", '<=%1', PerFinal);
                Incidencias.SetRange(Closed, false);
                if Incidencias.FindSet() then begin
                    repeat
                        CauseAbs.Get(Incidencias."Cause of Absence Code");
                        case CauseAbs."Dias laborables" of
                        /*
                        2: //Vacaciones
                         BEGIN
                          Incidencias.TESTFIELD("From Date");
                          Incidencias.TESTFIELD("To Date");
                          HistVac.INIT;
                          HistVac."No. empleado" := Incidencias."Employee No.";
                          HistVac."Fecha Inicio" := Incidencias."From Date";
                          HistVac."Fecha Fin"    := Incidencias."To Date";
                          HistVac.Dias           := Incidencias.Quantity *-1;
                          IF NOT HistVac.INSERT THEN
                             HistVac.MODIFY;

                          MovNovAD.INIT;
                          MovNovAD.VALIDATE("Cod. Empleado",Incidencias."Employee No.");
                          MovNovAD."Tipo Novedad" := CauseAbs."Tipo de Accion de personal";
                          MovNovAD."Fecha Inicio" := Incidencias."From Date";
                          MovNovAD."Fecha Fin"    := Incidencias."To Date";
                          IF NOT MovNovAD.INSERT THEN
                             MovNovAD.MODIFY;
                         END;
                        */

                        /*//fes mig
                        3: //Licencia Voluntaria
                         BEGIN
                         END;
                        4: //Licencia Maternidad
                         BEGIN
                         END;
                        5: //Licencia x Discapacidad
                         BEGIN
                         END;
                         *///fes mig
                        end;


                        if Incidencias."% To deduct" <> 0 then
                            DiasIncid += (Incidencias."To Date" - Incidencias."From Date" + 1) *
                                                   Incidencias."% To deduct" / 100;
                        Incidencias2.Copy(Incidencias);
                        Incidencias2.Closed := true;
                        Incidencias2.Modify;
                    until Incidencias.Next = 0;

                    if DiasIncid < 0 then
                        DiasIncid := 1;
                    //             CalcDias.GET(ConfNominas."Método cálculo ausencias");
                    //             ImporteIncid       := IngresoSalario / CalcDias.Valor * DiasIncid;
                    ImporteIncid := IngresoSalario / 30 * DiasIncid;
                    ImporteTotal := ImporteTotal - ImporteIncid;
                end;

                if Empleado."Fecha salida empresa" <> 0D then
                    if (Empleado."Fecha salida empresa" >= PerInici) and (Empleado."Fecha salida empresa" < PerFinal) then begin
                        CantidadDiasSal := Date2DMY(Empleado."Fecha salida empresa", 1);
                        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                            if CantidadDiasSal > 15 then
                                CantidadDiasSal := 0;
                        DiasPago := CantidadDiasSal;
                    end;

                if DiasPago <> 0 then begin
                    Fecha.Reset;
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                    Fecha.SetRange("Period Start", PerInici);
                    Fecha.FindFirst;
                    FechaFinal := NormalDate(Fecha."Period End");
                    DiasMes := 30;

                    if Empleado."Employment Date" >= PerInici then begin
                        ImporteTotal := IngresoSalario / DiasMes * DiasPago;
                        ImporteBaseImp := ImporteTotal;
                    end;

                    if (Empleado."Fecha salida empresa" >= PerInici) and (Empleado."Fecha salida empresa" <= PerFinal) then begin
                        ImporteTotal := IngresoSalario / DiasMes * DiasPago;
                        ImporteBaseImp := ImporteTotal;
                    end;
                end;
            end;

            LinTabla += 10;
            InsertNomina(PerfilSal);
            if ImporteTotal <> 0 then
                TotalIngresos += ImporteTotal;
        end;

    end;


    procedure CalcularDescuentos()
    begin
        //CalcularDescuentos
        if (PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Deducciones) and (PerfilSal.Cantidad <> 0) and
           (PerfilSal.Importe <> 0) and (not PerfilSal."Sujeto Cotizacion") and (PerfilSal."Tipo Nomina" = GlobalRec."Tipo Nomina") then begin
            if not PerfilSal."Texto Informativo" then begin
                PerfilSal.Importe := PerfilSal.Cantidad * Round(PerfilSal.Importe);
                ImporteTotal := PerfilSal.Importe * -1;
            end
            else begin
                ImporteTotal := 0;
                ImpFactura := PerfilSal.Cantidad * PerfilSal.Importe;
                PerfilSal.Cantidad := 0;
            end;

            if PerfilSal."Currency Code" <> '' then begin
                if ConfNominas."Tasa Cambio Calculo Divisa" <> 0 then begin
                    PerfilSal.Importe := Round(PerfilSal.Importe) * ConfNominas."Tasa Cambio Calculo Divisa";
                    ImporteTotal := PerfilSal.Importe * -1;
                end
                else begin
                    CurrExchange.SetRange("Currency Code", PerfilSal."Currency Code");
                    CurrExchange.SetRange("Starting Date", 0D, PerFinal);
                    CurrExchange.FindLast;
                    PerfilSal.Importe := Round(PerfilSal.Importe) * CurrExchange."Relational Exch. Rate Amount";
                    ImporteTotal := PerfilSal.Importe * -1;
                end;
            end;

            if PerfilSal."% Retencion Ingreso Salario" <> 0 then begin
                Empleado.SetRange("Date Filter", DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                Empleado.CalcFields("Acumulado Salario");
                PerfilSal.Importe := Empleado."Acumulado Salario";
                ImporteTotal := (Empleado."Acumulado Salario") * PerfilSal."% Retencion Ingreso Salario" / 100;
                if PerfilSal."1ra Quincena" and PerfilSal."2da Quincena" then
                    ImporteTotal /= 2;
            end;
            LinTabla += 10;
            InsertNomina(PerfilSal)
        end;
    end;


    procedure CalcularDtosLegales()
    var
        LinNominasES: Record "Historico Lin. nomina";
        DeduccGob: Record "Tipos de Cotización";
        CabAportesEmpresa: Record "Cab. Aportes Empresas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        LinAportesEmpresa2: Record "Lin. Aportes Empresas";
        DistImpTSS: Record "Distribucion Importes TSS";
        PerfilSalTr: Record "Perfil Salarial";
        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
        ImporteCotizacion2: Decimal;
        ImporteImpuestos: Decimal;
        ImporteImpuestosemp: Decimal;
        ImporteCotizacionEmp: Decimal;
        ImporteEscalas: array[5] of Decimal;
        PorcientoEscalas: array[5] of Decimal;
        x: Integer;
        i: Integer;
    begin
        DeduccGob.Reset;
        DeduccGob.SetRange(Ano, Ano);
        if DeduccGob.FindSet() then
            repeat
                i := 0;
                DeduccGob.CalcFields("Control por escalas"); // Para los casos en que el descuento tiene escalas
                Clear(ImporteEscalas);
                Clear(PorcientoEscalas);
                if DeduccGob."Control por escalas" then begin
                    DistImpTSS.Reset;
                    DistImpTSS.SetRange(Ano, Ano);
                    DistImpTSS.SetRange("Concepto Salarial", DeduccGob.Código);
                    DistImpTSS.FindSet;
                    repeat
                        i += 1;
                        ImporteEscalas[i] := DistImpTSS."Importe Maximo";
                        PorcientoEscalas[i] := DistImpTSS."% Retencion";
                    until DistImpTSS.Next = 0;
                end;
                IndSkip := false;
                ImporteCotizacion := 0;
                ImporteCotizacionEmp := 0;
                PerfilSalTr.Reset;
                PerfilSalTr.SetRange("No. empleado", GlobalRec."No. empleado");
                PerfilSalTr.SetRange("Concepto salarial", DeduccGob.Código);
                PerfilSalTr.FindFirst;

                LinNominasES.Reset;
                LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                LinNominasES.SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");

                if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then begin
                    LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                    LinNominasES.SetRange("Sujeto Cotización", true);
                    if ConfNominas."Concepto AFP" = DeduccGob.Código then
                        LinNominasES.SetRange("Cotiza AFP", true)
                    else
                        if ConfNominas."Concepto INFOTEP" = DeduccGob.Código then begin
                            LinNominasES.SetRange("Cotiza Infotep", true);
                            if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::"Bonificación" then begin
                                DeduccGob."Porciento Empresa" /= 2;
                                DeduccGob."Porciento Empleado" := DeduccGob."Porciento Empresa";
                            end;
                        end
                        else
                            if ConfNominas."Concepto SRL" = DeduccGob.Código then
                                LinNominasES.SetRange("Cotiza SRL", true)
                            else
                                if ConfNominas."Concepto SFS" = DeduccGob.Código then
                                    LinNominasES.SetRange("Cotiza SFS", true);

                    if Empleado."Excluído Cotización TSS" then
                        IndSkip := true;

                    if LinNominasES.FindSet() then
                        repeat
                            ImporteCotizacion += LinNominasES.Total;
                            ImporteCotizacionEmp += LinNominasES.Total;
                        until LinNominasES.Next = 0;

                end
                else

                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                        if (PerfilSalTr."1ra Quincena") and (not PerfilSalTr."2da Quincena") and (PrimeraQ) then begin
                            LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                            LinNominasES.SetRange("Sujeto Cotización", true);
                            if ConfNominas."Concepto AFP" = DeduccGob.Código then
                                LinNominasES.SetRange("Cotiza AFP", true)
                            else
                                if ConfNominas."Concepto INFOTEP" = DeduccGob.Código then begin
                                    LinNominasES.SetRange("Cotiza Infotep", true);
                                    if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::"Bonificación" then begin
                                        DeduccGob."Porciento Empresa" /= 2;
                                        DeduccGob."Porciento Empleado" := DeduccGob."Porciento Empresa";
                                    end;
                                end
                                else
                                    if ConfNominas."Concepto SRL" = DeduccGob.Código then
                                        LinNominasES.SetRange("Cotiza SRL", true)
                                    else
                                        if ConfNominas."Concepto SFS" = DeduccGob.Código then
                                            LinNominasES.SetRange("Cotiza SFS", true);

                            if Empleado."Excluído Cotización TSS" then
                                IndSkip := true;

                            if LinNominasES.FindSet() then
                                repeat
                                    if Empleado."Employment Date" >= PerInici then begin
                                        ImporteCotizacion += LinNominasES.Total;
                                        ImporteCotizacionEmp += LinNominasES.Total;
                                    end
                                    else begin
                                        ImporteCotizacion += LinNominasES.Total;
                                        ImporteCotizacionEmp += LinNominasES.Total; //Ojo, importe base
                                    end;
                                until LinNominasES.Next = 0;
                        end
                        else
                            if (not PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena") and (SegundaQ) then begin
                                LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                                LinNominasES.SetRange("Sujeto Cotización", true);
                                if ConfNominas."Concepto AFP" = DeduccGob.Código then
                                    LinNominasES.SetRange("Cotiza AFP", true)
                                else
                                    if ConfNominas."Concepto INFOTEP" = DeduccGob.Código then begin
                                        LinNominasES.SetRange("Cotiza Infotep", true);
                                        if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::"Bonificación" then begin
                                            DeduccGob."Porciento Empresa" /= 2;
                                            DeduccGob."Porciento Empleado" := DeduccGob."Porciento Empresa";
                                        end;
                                    end
                                    else
                                        if ConfNominas."Concepto SRL" = DeduccGob.Código then
                                            LinNominasES.SetRange("Cotiza SRL", true)
                                        else
                                            if ConfNominas."Concepto SFS" = DeduccGob.Código then
                                                LinNominasES.SetRange("Cotiza SFS", true);

                                if Empleado."Excluído Cotización TSS" then
                                    IndSkip := true;

                                if LinNominasES.FindSet() then
                                    repeat
                                        ImporteCotizacion += LinNominasES.Total;
                                        ImporteCotizacionEmp += LinNominasES.Total;
                                    until LinNominasES.Next = 0;
                            end
                            else
                                if (PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena") then begin
                                    LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                                    if ConfNominas."Concepto AFP" = DeduccGob.Código then
                                        LinNominasES.SetRange("Cotiza AFP", true)
                                    else
                                        if ConfNominas."Concepto INFOTEP" = DeduccGob.Código then begin
                                            LinNominasES.SetRange("Cotiza Infotep", true);
                                            if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::"Bonificación" then begin
                                                DeduccGob."Porciento Empresa" /= 2;
                                                DeduccGob."Porciento Empleado" := DeduccGob."Porciento Empresa";
                                            end;
                                        end
                                        else
                                            if ConfNominas."Concepto SRL" = DeduccGob.Código then
                                                LinNominasES.SetRange("Cotiza SRL", true)
                                            else
                                                if ConfNominas."Concepto SFS" = DeduccGob.Código then
                                                    LinNominasES.SetRange("Cotiza SFS", true);

                                    if Empleado."Excluído Cotización TSS" then
                                        IndSkip := true;
                                    if LinNominasES.FindSet() then
                                        repeat
                                            ImporteCotizacion += LinNominasES.Total;
                                            ImporteCotizacionEmp += LinNominasES.Total;
                                        until LinNominasES.Next = 0;
                                    if SegundaQ then begin
                                        ImporteImpuestos := 0;

                                        //Busco el importe cobrado del impuesto
                                        LinNominasES.Reset;
                                        LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                                        LinNominasES.SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");
                                        LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)));
                                        LinNominasES.SetRange("Concepto salarial", DeduccGob.Código);
                                        if LinNominasES.FindSet then
                                            repeat
                                                ImporteImpuestos += LinNominasES.Total;
                                            until LinNominasES.Next = 0;
                                    end;
                                end
                    end;

                //GRN    IF (PerfilSalTr."1ra Quincena") AND (PerfilSalTr."2da Quincena") and (PerfilSalTr."salario base")THEN
                //GRN       ImporteCotizacion *= 2;

                if (ImporteCotizacion > DeduccGob."Tope Salarial/Acumulado Anual") and (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) and
                   (DeduccGob."Porciento Empleado" <> 0) then begin
                    ImporteCotizacion := DeduccGob."Tope Salarial/Acumulado Anual";
                    MontoAplicar := ImporteCotizacion * DeduccGob."Porciento Empleado" / 100;
                    if Abs(ImporteImpuestos) >= MontoAplicar then
                        IndSkip := true;
                end;

                if (ImporteCotizacion > DeduccGob."Tope Salarial/Acumulado Anual") and (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then
                    ImporteCotizacion := DeduccGob."Tope Salarial/Acumulado Anual";

                if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                    if ((PerfilSalTr."1ra Quincena" <> PrimeraQ) and (PrimeraQ) and
                       ((Empleado."Fecha salida empresa" = 0D) or (Empleado."Fecha salida empresa" >= PerFinal))) then
                        IndSkip := true;

                    if (not PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena") and (PrimeraQ) then
                        IndSkip := true;

                    if ((PerfilSalTr."2da Quincena" <> SegundaQ) and (SegundaQ) and
                       ((Empleado."Fecha salida empresa" = 0D) or (Empleado."Fecha salida empresa" >= PerFinal))) then
                        IndSkip := true;
                end;

                //Employee
                if DeduccGob."Porciento Empleado" <> 0 then begin
                    MontoAplicar := 0;
                    if not DeduccGob."Control por escalas" then
                        MontoAplicar := ImporteCotizacion * DeduccGob."Porciento Empleado" / 100
                    else begin
                        for x := 1 to i do begin
                            if ImporteCotizacion >= ImporteEscalas[x] then
                                MontoAplicar := MontoAplicar + ((ImporteCotizacion - ImporteEscalas[x]) * PorcientoEscalas[x] / 100);
                        end;
                    end;

                    if (ImporteCotizacion > DeduccGob."Tope Salarial/Acumulado Anual") and (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then begin
                        ImporteCotizacion := DeduccGob."Tope Salarial/Acumulado Anual";
                        ImporteCotizacionEmp := ImporteCotizacion;
                        MontoAplicar := ImporteCotizacion * DeduccGob."Porciento Empleado" / 100;
                        MontoAplicar += ImporteImpuestos;
                        if MontoAplicar < 0 then
                            MontoAplicar := 0;
                    end;

                    if not IndSkip then begin
                        PerfilSalTr.Importe := ImporteCotizacion;
                        PerfilSalTr.Cantidad := 1;
                        MontoAplicar += ImporteImpuestos;
                        ImporteTotal := MontoAplicar * -1;
                        "%Cot" := DeduccGob."Porciento Empleado";
                        LinTabla += 10;
                        if ImporteTotal <> 0 then
                            InsertNomina(PerfilSalTr);


                    end;
                end;

                //Employer
                NoLin += 10;
                LinAportesEmpresa."No. Documento" := CabNomina."No. Documento";
                LinAportesEmpresa."No. orden" := NoLin;
                LinAportesEmpresa."Empresa cotización" := CabNomina."Empresa cotización";
                LinAportesEmpresa.Período := CabNomina.Período;
                LinAportesEmpresa."No. Empleado" := CabNomina."No. empleado";
                LinAportesEmpresa.Validate("Concepto Salarial", DeduccGob.Código);
                LinAportesEmpresa."% Cotizable" := DeduccGob."Porciento Empresa";

                if (ImporteCotizacionEmp > DeduccGob."Tope Salarial/Acumulado Anual") and
                   (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then
                    ImporteCotizacionEmp := DeduccGob."Tope Salarial/Acumulado Anual";
                // MESSAGE('%1',ImporteCotizacionEmp);
                LinAportesEmpresa."Base Imponible" := ImporteCotizacionEmp;
                LinAportesEmpresa.Importe := ImporteCotizacionEmp * DeduccGob."Porciento Empresa" / 100;
                LinAportesEmpresa.Descripcion := PerfilSalTr.Descripcion;
                if ((Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
                   (PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena")) and
                   (SegundaQ) then begin
                    //Busco el importe cobrado del impuesto
                    ImporteImpuestosemp := 0;
                    LinAportesEmpresa2.Reset;
                    LinAportesEmpresa2.SetRange("No. Empleado", GlobalRec."No. empleado");
                    LinAportesEmpresa2.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)));
                    LinAportesEmpresa2.SetRange("Concepto Salarial", DeduccGob.Código);
                    if LinAportesEmpresa2.FindSet then
                        repeat
                            ImporteImpuestosemp += LinAportesEmpresa2.Importe;
                        until LinAportesEmpresa2.Next = 0;

                    LinAportesEmpresa.Importe -= ImporteImpuestosemp;
                end;

                if (LinAportesEmpresa.Importe <> 0) and (not IndSkip) then begin
                    recTmpDimEntry.DeleteAll;
                    InsertarDimTemp(ConfNominas."Dimension Conceptos Salariales", LinAportesEmpresa."Concepto Salarial");
                    InsertarDimTempDef(5200);
                    LinAportesEmpresa."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);

                    LinAportesEmpresa.Insert;

                end;
            until DeduccGob.Next = 0;
    end;


    procedure ReCalcularDtosLegales()
    var
        LinNominasES: Record "Historico Lin. nomina";
        DeduccGob: Record "Tipos de Cotización";
        CabAportesEmpresa: Record "Cab. Aportes Empresas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        PerfilSalTr: Record "Perfil Salarial";
        PerfilSalTr2: Record "Perfil Salarial";
        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
    begin
        ImporteCotizacionRec := 0;

        DeduccGob.Reset;
        DeduccGob.SetRange(Ano, Ano);
        //DeduccGob.SETFILTER("Porciento Empresa",'<>%1',0);
        if DeduccGob.FindSet() then
            repeat
                PerfilSalTr.Reset;
                PerfilSalTr.SetRange("No. empleado", GlobalRec."No. empleado");
                PerfilSalTr.SetRange("Concepto salarial", DeduccGob.Código);
                PerfilSalTr.SetRange("Cotiza ISR", true);
                if PerfilSalTr.FindFirst then
                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                        if (PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena") and (PrimeraQ) then begin
                            PerfilSalTr2.Reset;
                            PerfilSalTr2.SetRange("No. empleado", GlobalRec."No. empleado");
                            PerfilSalTr2.SetRange("Tipo concepto", PerfilSalTr2."Tipo concepto"::Deducciones);
                            PerfilSalTr2.SetRange("Cotiza ISR", true);
                            if PerfilSalTr2.FindSet() then
                                repeat
                                    IndSkip := false;
                                    //Verifico si el concepto ya llego al tope para el mes
                                    LinNominasES.Reset;
                                    LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                                    LinNominasES.SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");
                                    LinNominasES.SetRange(Período, PerInici, PerFinal);
                                    LinNominasES.SetRange("Concepto salarial", PerfilSalTr2."Concepto salarial");
                                    if LinNominasES.FindFirst then
                                        repeat
                                            if LinNominasES."Importe Base" >= DeduccGob."Tope Salarial/Acumulado Anual" then
                                                IndSkip := true;

                                            if not IndSkip then
                                                MontoAplicar := IngresoSalario * DeduccGob."Porciento Empleado" / 100;
                                        until LinNominasES.Next = 0;
                                until PerfilSalTr2.Next = 0;
                            ImporteCotizacionRec += MontoAplicar;
                        end;
                    end;
            until DeduccGob.Next = 0;
        ImporteCotizacionRec *= -1;
    end;


    procedure CalcularISR()
    var
        "RetenciónISR": Record "Tabla retencion ISR";
        SaldoFavor: Record "Saldos a favor ISR";
        HistLinNom: Record "Historico Lin. nomina";
        HistLinNomISR: Record "Historico Lin. nomina";
        BKSaldoFavor: Record "Prestaciones masivas";
        BKSFISR: Record "Prestaciones masivas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        LinEsqPercepISR: Record "Perfil Salarial";
        PFxE: Record "Distrib. Control de asis. Proy";
        RangoISR: array[10] of Decimal;
        "%Calcular": array[10] of Integer;
        Indice: Integer;
        Importe: Decimal;
        ImporteRetencion: array[10] of Decimal;
        t: Integer;
        Base: Decimal;
        TotalCompany: Decimal;
        Err002: Label 'Employee %1 doesn''t have posted payroll in company %2, please verify';
        ImporteISR: Decimal;
        CantParam: Integer;
        ImpSalMinimo: Decimal;
        ISRSalMinimo: Decimal;
        OtrosIngresosISR: Decimal;
        ColSubTotal: Decimal;
        TasaAnterior: Decimal;
        TasaActual: Decimal;
    begin
        //fes mig
        /*
        //CalculoISR (RC IVA)
        CLEAR(Importe);
        TotalCompany   := 0;
        CLEAR(TotalISR);
        LinTabla       += 10;
        LinNomina.INIT;
        "%Cot"         := 0;
        OtrosIngresosISR := 0;
        
        //Busco Tasa al cierre del mes anterior
        UFV.RESET;
        UFV.SETRANGE(Fecha,CALCDATE('-1D',PerInici));
        UFV.FINDFIRST;
        TasaAnterior := UFV."Tasa Actual";
        
        //Busco Tasa al cierre del mes actual
        UFV.RESET;
        UFV.SETRANGE(Fecha,PerFinal);
        UFV.FINDFIRST;
        TasaActual := UFV."Tasa Actual";
        
        //Busco el balance anterior
        BKSFISR.RESET;
        BKSFISR.SETRANGE("Cód. Empleado",GlobalRec."No. empleado");
        IF BKSFISR.FINDFIRST THEN
           ColSubTotal := BKSFISR."Saldo a favor";
        
        ColSubTotal := ColSubTotal / TasaAnterior * TasaActual;
        ColSubTotal := ROUND(ColSubTotal - BKSFISR."Saldo a favor",0.01);
        //Busqueda de todos los conceptos que cotizan para el calculo del ISR
        HistLinNom.RESET;
        HistLinNom.SETRANGE("No. empleado",GlobalRec."No. empleado");
        HistLinNom.SETRANGE("Tipo Nómina",Tipcalculo);
        HistLinNom.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)),PerFinal);
        HistLinNom.SETRANGE("Cotiza ISR",TRUE);
        HistLinNom.SETRANGE("Texto Informativo",FALSE);
        IF HistLinNom.FINDSET(FALSE,FALSE) THEN
           REPEAT
            IF HistLinNom.Total <> 0 THEN
               TotalISR[1][1] += ROUND(HistLinNom.Total,0.01);
           UNTIL HistLinNom.NEXT = 0;
        
        PFxE.RESET;
        PFxE.SETRANGE("Cod. Empleado",GlobalRec."No. empleado");
        IF PFxE.FINDSET THEN
           REPEAT
            OtrosIngresosISR += PFxE.Importe;
           UNTIL PFxE.NEXT = 0;
        
        Base := TotalISR[1][1] + OtrosIngresosISR;
        
        //Calculo el importe del Salario Minimo base para el RC IVA
        ConfNominas.TESTFIELD("Salario Minimo");
        ImpSalMinimo := ConfNominas."Salario Minimo" * 2;
        
        TotalISR[1][1] -= ImpSalMinimo;
        
        // Cálculo del ISR. Busqueda de Rangos ISR
        Indice := 0;
        RetenciónISR.SETRANGE(Ano,FORMAT(Ano,4,'<Standard Format,0>'));
        RetenciónISR.FINDSET(FALSE,FALSE);
        REPEAT
         Indice                   += 1;
         RangoISR[Indice]         := RetenciónISR."Importe Máximo";
         ImporteRetencion[Indice] := RetenciónISR."Importe retención";
         "%Calcular"[Indice]      := RetenciónISR."% Retención";
        UNTIL RetenciónISR.NEXT = 0;
        
        "%Cot"   := "%Calcular"[Indice];
        
        //Saco el calculo del % imponible
        TotalISR[1][1] := TotalISR[1][1] * "%Cot" /100;
        
        //Calculo el % de los 2 salarios minimos
        ISRSalMinimo := ImpSalMinimo * "%Cot" /100;
        
        
        TotalISR[1][1] := ISRSalMinimo - TotalISR[1][1];
        
        //Aqui se buscan los saldos a favor del empleado y si encuentra uno se pasa a una tabla
        //que sirve de BK al importe
        SaldoFavor.RESET;
        SaldoFavor.SETRANGE("Cód. Empleado",GlobalRec."No. empleado");
        SaldoFavor.SETFILTER("Importe Pendiente",'>0');
        IF SaldoFavor.FINDFIRST THEN
           BEGIN
            BKSaldoFavor.TRANSFERFIELDS(SaldoFavor);
            IF NOT BKSaldoFavor.INSERT THEN
               BKSaldoFavor.MODIFY;
           END;
        
        //message('%1 %2',totalisr[1][1],ColSubTotal);
        TotalISR[1][1] += SaldoFavor."Importe Pendiente" + ColSubTotal;
        
        //MESSAGE('%1 %2 %3',TotalISR[1][1],ImpFactura);
        //Resto el importe de factura
        TotalISR[1][1] := ImpFactura  + TotalISR[1][1];
        
        //Si importe es > 0 entonces es Saldo a Favor
        //De lo contrario, es un descuento
        IF TotalISR[1][1] > 0 THEN
           BEGIN
            SaldoFavor.INIT;
            SaldoFavor."Cód. Empleado"     := GlobalRec."No. empleado";
            SaldoFavor."Saldo a favor"     := ROUND(TotalISR[1][1],0.01);
            SaldoFavor."Importe Pendiente" := ROUND(TotalISR[1][1],0.01);
            IF NOT SaldoFavor.INSERT THEN
               SaldoFavor.MODIFY;
            EXIT;
           END;
        
        CLEAR(PerfilSalImp);
        PerfilSalImp.SETRANGE("No. empleado",GlobalRec."No. empleado");
        PerfilSalImp.SETRANGE("Concepto salarial",ConfNominas."Concepto ISR");
        PerfilSalImp.FINDFIRST;
        
        PerfilSalImp.Cantidad := 1;
        PerfilSalImp.Importe  := Base;
        ImporteTotal          := TotalISR[1][1];
        
        InsertNomina(PerfilSalImp);
        */
        //fes mig

    end;


    procedure CalcularPrestamos()
    var
        LinPerfilSal: Record "Perfil Salarial";
        rPrestamos: Record "CxC Empleados";
        rHistLinPrestamo: Record "Histórico Lín. Préstamo";
        rHistCabPrestamo: Record "Histórico Cab. Préstamo";
    begin
        //CalcularPrestamos

        rHistCabPrestamo.Reset;
        rHistCabPrestamo.SetRange("Employee No.", PerfilSal."No. empleado");
        rHistCabPrestamo.SetRange(Pendiente, true);
        if rHistCabPrestamo.FindSet then
            repeat
                //Busca la cuota del prestamo
                if rHistCabPrestamo."Concepto Salarial" <> PerfilSal."Concepto salarial" then
                    exit;

                LinPerfilSal.SetRange("No. empleado", PerfilSal."No. empleado");
                LinPerfilSal.SetRange("Concepto salarial", rHistCabPrestamo."Concepto Salarial");
                LinPerfilSal.FindFirst;

                rHistLinPrestamo.SetRange("Código Empleado", rHistCabPrestamo."Employee No.");
                rHistLinPrestamo.SetRange("No. Préstamo", rHistCabPrestamo."No. Préstamo");
                if (rHistLinPrestamo.FindLast) and (LinPerfilSal."Tipo concepto" <> 0) then begin
                    rHistLinPrestamo."No. Línea" += 100;
                    rHistLinPrestamo."Tipo CxC" := rHistCabPrestamo."Tipo CxC";
                    rHistLinPrestamo."No. Cuota" += 1;
                    rHistLinPrestamo."Fecha Transacción" := PerInici;
                    rHistLinPrestamo."Código Empleado" := LinPerfilSal."No. empleado";
                    rHistLinPrestamo.Importe := -LinPerfilSal.Importe;
                    rHistLinPrestamo.Validate(Importe);
                    rHistCabPrestamo.CalcFields("Importe Pendiente");
                    if rHistCabPrestamo."Importe Pendiente" + rHistLinPrestamo.Importe = 0 then begin
                        rHistCabPrestamo.Pendiente := false;
                        rHistCabPrestamo.Modify;
                    end;

                    rHistLinPrestamo.Insert;
                end;
            until rHistCabPrestamo.Next = 0;
    end;


    procedure CalculoBonificacion()
    var
        linperfilsal: Record "Perfil Salarial";
    begin
        // Bonificacion
        PerfilSal.Reset;
        PerfilSal.SetRange("Empresa cotizacion", GlobalRec."Empresa cotizacion");
        PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        PerfilSal.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        PerfilSal.SetFilter(Cantidad, '<>%1', 0);
        if PerfilSal.FindSet() then
            repeat
                if PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Deducciones then
                    ImporteTotal := (PerfilSal.Cantidad * Round(PerfilSal.Importe)) * -1
                else
                    ImporteTotal := PerfilSal.Cantidad * Round(PerfilSal.Importe);

                LinTabla += 10;
                InsertNomina(PerfilSal);
            until PerfilSal.Next = 0;
    end;


    procedure CalculoRegalia()
    begin
        /*1.-  Ingresos    */
        //  TipCalcNom := 1;
        PerfilSal.Reset;
        PerfilSal.SetRange("Empresa cotizacion", GlobalRec."Empresa cotizacion");
        PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        PerfilSal.SetRange("Tipo concepto", 0); /*Ingresos  */
        PerfilSal.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        if PerfilSal.FindSet() then
            repeat
                ImporteTotal := PerfilSal.Cantidad * Round(PerfilSal.Importe);
                InsertNomina(PerfilSal);
            until PerfilSal.Next = 0;

    end;


    procedure InsertNomina(perfSalario: Record "Perfil Salarial")
    begin
        //InsertNomina
        LinNomina."Empresa cotización" := perfSalario."Empresa cotizacion";
        LinNomina."No. empleado" := perfSalario."No. empleado";
        LinNomina."No. Documento" := CabNomina."No. Documento";
        LinNomina.Período := PerInici;
        LinNomina."No. Orden" := LinTabla;
        LinNomina.Ano := Ano;
        LinNomina."Concepto salarial" := perfSalario."Concepto salarial";
        LinNomina.Descripción := perfSalario.Descripcion;
        LinNomina.Cantidad := perfSalario.Cantidad;
        LinNomina."Importe Base" := perfSalario.Importe;
        LinNomina."Currency Code" := perfSalario."Currency Code";
        LinNomina.Total := ImporteTotal;
        LinNomina."Tipo concepto" := perfSalario."Tipo concepto";
        LinNomina."Texto Informativo" := perfSalario."Texto Informativo";
        LinNomina."Salario Base" := perfSalario."Salario Base";
        LinNomina."Cotiza ISR" := perfSalario."Cotiza ISR";
        LinNomina."Cotiza SFS" := perfSalario."Cotiza SFS";
        LinNomina."Cotiza AFP" := perfSalario."Cotiza AFP";
        LinNomina."Cotiza SRL" := perfSalario."Cotiza SRL";
        LinNomina."Cotiza Infotep" := perfSalario."Cotiza INFOTEP";
        LinNomina."Sujeto Cotización" := perfSalario."Sujeto Cotizacion";
        LinNomina."Aplica para Regalia" := perfSalario."Aplica para Regalia";
        LinNomina.Fórmula := perfSalario."Formula calculo";
        LinNomina.Imprimir := perfSalario.Imprimir;
        LinNomina."Inicio período" := PerInici;
        LinNomina."Fin período" := PerFinal;
        LinNomina."Tipo Nómina" := perfSalario."Tipo Nomina";
        LinNomina."% Cotizable" := "%Cot";
        LinNomina."% Pago Empleado" := perfSalario."% ISR Pago Empleado";
        LinNomina.Departamento := Empleado.Departamento;
        LinNomina."Sub-Departamento" := Empleado."Sub-Departamento";
        LinNomina."Excluir de listados" := perfSalario."Excluir de listados";


        ConceptosSal.SetRange(Codigo, perfSalario."Concepto salarial");
        ConceptosSal.FindFirst;

        recTmpDimEntry.DeleteAll;
        InsertarDimTemp(ConceptosSal."Dimension Nomina", perfSalario."Concepto salarial"); //Para el concepto salarial
        InsertarDimTempDef(5200);                                                           //Para las Dim del empleado
        InsertarDimTempDef(76061);                                                       //Para las Dim del perfil de salario (linea del concepto salarial)
        LinNomina."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);

        LinNomina.Insert;
    end;


    procedure CalculaBonoAntiguedad(FechaInicio: Date; FechaFin: Date)
    var
        PerSalEmp: Record "Perfil Salarial";

        AnoCalculado: Integer;
        MesCalculado: Integer;
        DiaCalculado: Integer;
    begin


        PerSalEmp.Reset;
        PerSalEmp.SetRange("No. empleado", GlobalRec."No. empleado");
        PerSalEmp.SetRange("Concepto salarial", ConfNominas."Concepto Bonificacion");
        PerSalEmp.FindFirst;
        //message('%1 %2 %3 %4 %5',fechainicio,fechafin,anocalculado);
        case AnoCalculado of
            2 .. 4:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 5 / 100, 0.01);
            5 .. 7:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 11 / 100, 0.01);
            8 .. 10:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 18 / 100, 0.01);
            11 .. 14:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 26 / 100, 0.01);
            15 .. 19:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 34 / 100, 0.01);
            20 .. 24:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 42 / 100, 0.01);
            25 .. 99:
                PerSalEmp.Importe := Round(ConfNominas."Salario Minimo" * 3 * 50 / 100, 0.01);
        end;

        if PerSalEmp.Importe <> 0 then begin
            PerSalEmp.Cantidad := 1;
            PerSalEmp.Modify;
        end;
    end;


    procedure CalculaDiasVacaciones()
    var
        HistVac: Record "Historico Vacaciones";

        AnoCalculado: Integer;
        MesCalculado: Integer;
        DiaCalculado: Integer;
        DiasVac: Integer;
    begin
        // 15 días de 1 a 5 años
        // 20 días de 5 años y un día a 10 años
        // 30 días de 10 años y un día en adelante


        // 15 días al primer año
        // 1 dia x cada año hasta llegar a 30

        DiasVac := 0;
        if (AnoCalculado >= 1) and (AnoCalculado < 5) then
            DiasVac := 15
        else
            if (AnoCalculado >= 5) and (AnoCalculado < 10) then
                DiasVac := 20
            else
                if AnoCalculado >= 10 then
                    DiasVac := 30;
        //message('%1',diasvac);
        if DiasVac <> 0 then begin
            HistVac.Reset;
            HistVac.SetRange("No. empleado", Empleado."No.");
            HistVac.SetRange("Fecha Inicio", DMY2Date(1, 1, Date2DMY(PerFinal, 3)));
            if HistVac.FindFirst then begin
                if HistVac.Dias <> DiasVac then begin
                    HistVac.Dias := DiasVac;
                    HistVac.Modify;
                end;
            end
            else
                if (Date2DMY(PerFinal, 2) >= Date2DMY(Empleado."Employment Date", 2)) then begin
                    HistVac.Init;
                    HistVac."No. empleado" := Empleado."No.";
                    HistVac."Fecha Inicio" := DMY2Date(Date2DMY(Empleado."Employment Date", 1),
                                              Date2DMY(Empleado."Employment Date", 2), Date2DMY(PerFinal, 3) - 1);
                    HistVac."Fecha Fin" := CalcDate('1A', HistVac."Fecha Inicio");
                    HistVac.Dias := DiasVac;
                    if HistVac.Insert then;
                end;
        end;
    end;


    procedure InsertarDimTemp(DimCode: Code[20]; DimValue: Code[20])
    var
        recDimVal: Record "Dimension Value";
    begin
        recDimVal.Get(DimCode, DimValue);
        recTmpDimEntry."Dimension Code" := DimCode;
        recTmpDimEntry."Dimension Value Code" := DimValue;
        recTmpDimEntry."Dimension Value ID" := recDimVal."Dimension Value ID";
        if recTmpDimEntry.Insert then;
    end;


    procedure InsertarDimTempDef(intPrmTabla: Integer)
    var
        recDfltDim: Record "Default Dimension";
    begin
        recDfltDim.Reset;
        recDfltDim.SetRange("Table ID", intPrmTabla);
        recDfltDim.SetRange("No.", GlobalRec."No. empleado");
        if recDfltDim.FindSet() then
            repeat
                InsertarDimTemp(recDfltDim."Dimension Code", recDfltDim."Dimension Value Code");
            until recDfltDim.Next = 0;
    end;
}

