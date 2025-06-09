codeunit 76068 "Registrar nomina PA"

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
        recTmpDimEntry: Record "Dimension Set Entry" temporary;
        cduDim: Codeunit DimensionManagement;
        Generar: Boolean;
        "Período": Integer;
        PerInici: Date;
        PerFinal: Date;
        Tipcalculo: Integer;
        dia: Integer;
        mes1: Integer;
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
        //         //MESSAGE('%1',CabNomina."Total Ingresos");
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
    end;


    procedure CrearCabecera()
    var
        CompanyTaxes: Record "Cab. Aportes Empresas";
        GestNoSer: Codeunit "No. Series";
    begin
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
        //Revisar CabNomina."Grupo cotizac"      := empleado."Nivel Empleado";
        //CabNomina."Horas jornada"      :=
        //CabNomina."Base ISR"           :=
        CabNomina.Inicio := GlobalRec."Inicio Periodo";
        CabNomina.Fin := GlobalRec."Fin Período";
        CabNomina."Fecha Entrada" := Empleado."Employment Date";
        CabNomina."Fecha Salida" := Empleado."Fecha salida empresa";
        CabNomina."Full name" := Empleado."Full Name";
        CabNomina.Cargo := Empleado."Job Type Code";
        //CabNomina."Fecha antigüedad"   := empleado."Disponible 5";
        //CabNomina."No. Contabilización":=
        CabNomina."Tipo Empleado" := Empleado."Tipo Empleado";
        CabNomina.Banco := Empleado."Disponible 1";
        CabNomina."Tipo Cuenta" := Empleado."Disponible 2";
        CabNomina.Cuenta := Empleado.Cuenta;
        CabNomina."Forma de Cobro" := Empleado."Forma de Cobro";
        CabNomina.Validate("Shortcut Dimension 1 Code", Empleado."Global Dimension 1 Code");
        CabNomina.Validate("Shortcut Dimension 2 Code", Empleado."Global Dimension 2 Code");
        CabNomina.Departamento := Empleado.Departamento;
        CabNomina."Sub-Departamento" := Empleado."Sub-Departamento";

        Clear(recTmpDimEntry);
        InsertarDimTempDef(5200);
        CabNomina."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);

        CabNomina.Insert;

        Contrato.SetRange("No. empleado", Empleado."No.");
        //GRN Contrato.SETRANGE("Centro trabajo",Empleado."Working Center");
        Contrato.SetRange(Finalizado, false);
        Contrato.FindFirst;

        /*//GRN 06/04/10
        IF Empleado."Fecha salida empresa" <> 0D THEN
           IF Contrato."Fecha finalización" = 0D THEN
              BEGIN
               Empleado."Calcular Nomina"    := FALSE;
               Empleado."Fin contrato"       := Empleado."Fecha salida empresa";
               Empleado.MODIFY;
        
               Contrato."Fecha finalización" := Empleado."Fecha salida empresa";
               Contrato.Finalizado           := TRUE;
               Contrato.MODIFY;
              END;
        */

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
        ImporteIncid: Decimal;
        DiasIncid: Decimal;
        DiasPago: Decimal;
        CantidadDiasEnt: Decimal;
        CantidadDiasSal: Decimal;
        DiasAusencia: Decimal;
        DiasCal: Decimal;
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

                        //message('%1 %2 %3 %4',cantidaddiasent);
                        Fecha.Reset;
                        Fecha.SetRange("Period Type", 0); //Dia
                        Fecha.SetRange("Period Start", Empleado."Employment Date", PerFinal);
                        //                Fecha.setrange("Period End",closingdate(perfinal));
                        Fecha.SetRange("Period No.", 6, 7);//Sabado y Domingo
                        if Fecha.FindSet then
                            repeat
                                case Fecha."Period No." of
                                    6:
                                        CantidadDiasEnt -= 0.5;
                                    7:
                                        CantidadDiasEnt -= 1;
                                end;
                            //                    message('%1 %2 %3 %4',cantidaddiasent,Fecha."Period No.");
                            until Fecha.Next = 0;

                        DiasPago := CantidadDiasEnt;
                        ImporteBaseImp := ImporteTotal;
                    end;
                end
                else
                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then begin
                        CantidadDiasEnt := 30;
                        if Empleado."Employment Date" > PerInici then begin
                            CantidadDiasEnt := DMY2Date(CantidadDiasEnt, Date2DMY(PerFinal, 2), Date2DMY(PerFinal, 3)) -
                                                  Empleado."Employment Date" + 1;

                            if CantidadDiasEnt <= 0 then
                                Error(Err001, CantidadDiasEnt, Empleado."No.");
                        end;
                    end;

                //Para deducir las incidencias
                Clear(Incidencias);
                Incidencias.SetRange("Employee No.", Empleado."No.");
                Incidencias.SetFilter("From Date", '>=%1', DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)));
                Incidencias.SetFilter("To Date", '<=%1', PerFinal);
                Incidencias.SetRange(Closed, false);
                Incidencias.SetFilter("% To deduct", '<>%1', 0);
                if Incidencias.FindSet() then begin
                    repeat
                        DiasIncid += (Incidencias."To Date" - Incidencias."From Date" + 1) *
                                               Incidencias."% To deduct" / 100;
                        Incidencias2.Copy(Incidencias);
                        Incidencias2.Closed := true;
                        Incidencias2.Modify;
                    until Incidencias.Next = 0;

                    if DiasIncid <= 0 then
                        DiasIncid := 1;
                    CalcDias.Get(ConfNominas."Método cálculo ausencias");
                    ImporteIncid := IngresoSalario / CalcDias.Valor * DiasIncid;
                    ImporteTotal := ImporteTotal - ImporteIncid;
                end;

                if Empleado."Fecha salida empresa" <> 0D then
                    if (Empleado."Fecha salida empresa" >= PerInici) and (Empleado."Fecha salida empresa" < PerFinal) then begin
                        CantidadDiasSal := Empleado."Fecha salida empresa" - PerInici + 1;
                        CantidadDiasEnt := CantidadDiasEnt - CantidadDiasSal + 1;
                        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                            if CantidadDiasSal > 15 then
                                CantidadDiasSal := 0;

                        //Para no incluir en el calculo los dias con incidencias
                        Fecha.Reset;
                        Incidencias.Reset;
                        Incidencias.SetRange("Employee No.", Empleado."No.");
                        Incidencias.SetFilter("From Date", '>=%1', DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)));
                        Incidencias.SetFilter("To Date", '<=%1', PerFinal);
                        Incidencias.SetFilter("% To deduct", '<>%1', 0);
                        if Incidencias.FindSet then
                            Fecha.SetRange("Period Start", Incidencias."To Date", PerFinal)
                        else
                            if Empleado."Employment Date" >= PerInici then
                                Fecha.SetRange("Period Start", Empleado."Employment Date", PerFinal)
                            else
                                if Empleado."Fecha salida empresa" <= PerFinal then
                                    Fecha.SetRange("Period Start", PerInici, Empleado."Fecha salida empresa")
                                else
                                    Fecha.SetRange("Period Start", PerInici, PerFinal);

                        Fecha.SetRange("Period No.", 6, 7);
                        if Fecha.FindSet then
                            repeat
                                case Fecha."Period No." of
                                    6:
                                        CantidadDiasSal -= 0.5;
                                    7:
                                        CantidadDiasSal -= 1;
                                end;
                            until Fecha.Next = 0;
                        //GRN              MESSAGE('%1 %2 %3 %4',cantidaddiassal,diaspago,DiasIncid,calendar.COUNT);
                        Cargos.Get(Empleado."Job Type Code");
                        if Cargos."Incluye Dias Feriados" then begin
                            Calendar.Reset;
                            if Incidencias."To Date" <> 0D then
                                Calendar.SetRange(Fecha, Incidencias."To Date", PerFinal)
                            else
                                Calendar.SetRange(Fecha, PerInici, PerFinal);
                            if Calendar.FindSet then
                                repeat
                                    if Calendar.Fecha > Incidencias."To Date" then
                                        if Empleado."Fecha salida empresa" <> 0D then begin
                                            if (Empleado."Fecha salida empresa" >= PerInici) and
                                               (Empleado."Fecha salida empresa" >= Calendar.Fecha) then
                                                DiasCal += 1;
                                        end
                                        else
                                            DiasCal += 1;
                                until Calendar.Next = 0;
                        end;

                        DiasPago := CantidadDiasSal - DiasPago - DiasIncid - DiasCal;
                        //GRN              MESSAGE('%1 %2 %3 %4',cantidaddiassal,diaspago,DiasIncid,diascal);
                    end;

                if DiasPago <> 0 then begin
                    if Empleado."Employment Date" >= PerInici then begin
                        CalcDias.Get(ConfNominas."Metodo calculo Ingresos");
                        ImporteTotal := IngresoSalario / CalcDias.Valor * DiasPago;
                        ImporteBaseImp := ImporteTotal;
                    end;

                    if (Empleado."Fecha salida empresa" >= PerInici) and (Empleado."Fecha salida empresa" <= PerFinal) then begin
                        CalcDias.Get(ConfNominas."Metodo calculo Salidas");
                        //                MESSAGE('%1 %2 %3',CalcDias.Valor, IngresoSalario, DiasPago);
                        ImporteTotal := IngresoSalario / CalcDias.Valor * DiasPago;
                        ImporteBaseImp := ImporteTotal;
                    end;
                end;
            end;

            LinTabla += 10;
            InsertNomina(PerfilSal);
        end;
    end;


    procedure CalcularDescuentos()
    begin
        //MESSAGE('%1 %2',PerfilSal."Tipo Nómina" , GlobalRec."Tipo Nómina" );
        if (PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Deducciones) and (PerfilSal.Cantidad <> 0) and
           (PerfilSal.Importe <> 0) and (not PerfilSal."Sujeto Cotizacion") and (PerfilSal."Tipo Nomina" = GlobalRec."Tipo Nomina") then begin
            PerfilSal.Importe := PerfilSal.Cantidad * Round(PerfilSal.Importe);
            ImporteTotal := PerfilSal.Importe * -1;

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
            InsertNomina(PerfilSal);
        end;
    end;


    procedure CalcularDtosLegales()
    var
        LinNominasES: Record "Historico Lin. nomina";
        DeduccGob: Record "Tipos de Cotización";
        CabAportesEmpresa: Record "Cab. Aportes Empresas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        LinAportesEmpresa2: Record "Lin. Aportes Empresas";
        PerfilSalTr: Record "Perfil Salarial";
        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
        ImporteCotizacion2: Decimal;
        ImporteImpuestos: Decimal;
        ImporteImpuestosemp: Decimal;
        ImporteCotizacionEmp: Decimal;
    begin
        DeduccGob.Reset;
        DeduccGob.SetRange(Ano, Ano);
        //DeduccGob.SETFILTER("Porciento Empresa",'<>%1',0);
        if DeduccGob.FindSet() then
            repeat
                IndSkip := false;
                ImporteCotizacion := 0;
                ImporteCotizacionEmp := 0;
                PerfilSalTr.Reset;
                PerfilSalTr.SetRange("No. empleado", GlobalRec."No. empleado");
                PerfilSalTr.SetRange("Concepto salarial", DeduccGob.Código);
                PerfilSalTr.FindFirst;
                //    PerfilSalTr."Sujeto Cotización",Contrato."Tipo Pago Nomina",PerfilSalTr."1ra Quincena",PerfilSalTr."2da Quincena");
                //GRN    IF (PerfilSalTr."Sujeto Cotización") AND (Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal) THEN

                LinNominasES.Reset;
                LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                LinNominasES.SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");
                /*GRN 29/08/2011
                 IF Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Mensual THEN
                    BEGIN
                         LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerFinal,3)),PerFinal);
                         LinNominasES.SETRANGE("Sujeto Cotización",TRUE);
                         IF ConfNominas."Concepto AFP" = DeduccGob.Código THEN
                            LinNominasES.SETRANGE("Cotiza AFP",TRUE)
                         ELSE
                         IF ConfNominas."Concepto INFOTEP" = DeduccGob.Código THEN
                            BEGIN
                             LinNominasES.SETRANGE("Cotiza Infotep",TRUE);
                             IF GlobalRec."Tipo Nómina" = GlobalRec."Tipo Nómina"::Bonificación THEN
                                BEGIN
                                 DeduccGob."Porciento Empresa"   /= 2;
                                 DeduccGob."Porciento Empleado"  := DeduccGob."Porciento Empresa";
                                END;
                            END
                         ELSE
                         IF ConfNominas."Concepto SRL" = DeduccGob.Código THEN
                            LinNominasES.SETRANGE("Cotiza SRL",TRUE)
                         ELSE
                         IF ConfNominas."Concepto SFS" = DeduccGob.Código THEN
                           LinNominasES.SETRANGE("Cotiza SFS",TRUE);

                         IF Empleado."Excluído Cotización TSS" THEN
                            IndSkip := TRUE;

                         IF LinNominasES.FINDSET(FALSE,FALSE) THEN
                            REPEAT
                             ImporteCotizacion += LinNominasES.total;
                            UNTIL LinNominasES.NEXT = 0;
                     //    MESSAGE('pas a   %1 %2 %3 %4',ImporteCotizacion,PerfilSal."Concepto salarial");
                    END
                 ELSE
                 */
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
                        //    MESSAGE('pas a   %1 %2 %3 %4',ImporteCotizacion,PerfilSal."Concepto salarial");
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
                            //                 MESSAGE('pas 2   %1 %2 %3 %4',ImporteCotizacion,LinNominasES.Total,LinNominasES.Período);
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
                                //GRN Para verificar el acumulado del mes en la segunda Quinc. y no descontar mas del tope
                                if SegundaQ then begin
                                    /*GRN 29/08/2011
                                    ImporteCotizacion2 := ImporteCotizacion;
                                    //Busco el importe cotizable
                                    LinNominasES.RESET;
                                    LinNominasES.SETRANGE("No. empleado",GlobalRec."No. empleado");
                                    LinNominasES.SETRANGE("Tipo Nómina",GlobalRec."Tipo Nómina");
                                    LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)));
                                    IF ConfNominas."Concepto AFP" = DeduccGob.Código THEN
                                       LinNominasES.SETRANGE("Cotiza AFP",TRUE)
                                    ELSE
                                    IF ConfNominas."Concepto INFOTEP" = DeduccGob.Código THEN
                                       BEGIN
                                        LinNominasES.SETRANGE("Cotiza Infotep",TRUE);
                                        IF GlobalRec."Tipo Nómina" = GlobalRec."Tipo Nómina"::Bonificación THEN
                                           BEGIN
                                            DeduccGob."Porciento Empresa"   /= 2;
                                            DeduccGob."Porciento Empleado"  := DeduccGob."Porciento Empresa";
                                           END;
                                       END
                                    ELSE
                                    IF ConfNominas."Concepto SRL" = DeduccGob.Código THEN
                                       LinNominasES.SETRANGE("Cotiza SRL",TRUE)
                                    ELSE
                                    IF ConfNominas."Concepto SFS" = DeduccGob.Código THEN
                                      LinNominasES.SETRANGE("Cotiza SFS",TRUE);

                                    IF Empleado."Excluído Cotización TSS" THEN
                                       IndSkip := TRUE;
                    //                message('aqui %1 %2 %3 %4',importecotizacion,importecotizacion2,DeduccGob.Código);
                                    IF LinNominasES.FINDSET THEN
                                       REPEAT
                                        ImporteCotizacion2 += LinNominasES.Total;
                                       UNTIL LinNominasES.NEXT = 0;
                                    */
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
                    IndSkip := false;
                    MontoAplicar := ImporteCotizacion * DeduccGob."Porciento Empleado" / 100;
                    if (ImporteCotizacion > DeduccGob."Tope Salarial/Acumulado Anual") and
                       (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then begin
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

                LinAportesEmpresa."Base Imponible" := ImporteCotizacionEmp;
                LinAportesEmpresa.Importe := ImporteCotizacionEmp * DeduccGob."Porciento Empresa" / 100;
                LinAportesEmpresa.Descripcion := PerfilSalTr.Descripcion;
                /*
                       IF ((Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal) AND
                          (PerfilSalTr."1ra Quincena") AND (PerfilSalTr."2da Quincena") AND (PrimeraQ)) OR
                          (Empleado."Fecha salida empresa" <> 0D) THEN
                          LinAportesEmpresa.Importe           /= 2
                       ELSE
                */
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
                    Clear(recTmpDimEntry);
                    //         InsertarDimTemp(ConfNominas."Dimension Conceptos Salariales",PerfilSal."Concepto salarial");           JML : Esta dimensión no es necesaria
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
        SaldoFavor2: Record "Saldos a favor ISR";
        HistLinNom: Record "Historico Lin. nomina";
        HistLinNomISR: Record "Historico Lin. nomina";
        BKSaldoFavor: Record "Prestaciones masivas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        EmpresasRel: Record "Relacion Empresas Empleados";
        EmpresasRel2: Record "Relacion Empresas Empleados";
        LinEsqPercepISR: Record "Perfil Salarial";
        LinEsqPercepISR2: Record "Perfil Salarial";
        HistLinCompany: Record "Historico Lin. nomina";
        Indice: Integer;
        Importe1: Decimal;
        Importe2: Decimal;
        Importe3: Decimal;
        RangoISR: array[5] of Decimal;
        ImporteRetencion: array[5] of Decimal;
        "%Calcular": array[5] of Integer;
        t: Integer;
        NoLinImp: Integer;
        Base: Decimal;
        TotalCompany: Decimal;
        Err002: Label 'Employee %1 doesn''t have posted payroll in company %2, please verify';
        ImporteISR: Decimal;
    begin
        //CalculoISR
        Importe1 := 0;
        TotalCompany := 0;
        Clear(TotalISR);
        LinTabla += 10;
        Clear(TotalISR);
        LinNomina.Init;
        "%Cot" := 0;

        //Busco si es quincenal cuando se deduce el ISR
        LinEsqPercepISR2.Reset;
        LinEsqPercepISR2.SetRange("No. empleado", GlobalRec."No. empleado");
        LinEsqPercepISR2.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
        if not LinEsqPercepISR2.FindFirst then
            LinEsqPercepISR2.Init;

        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
            IngresoSalario := IngresoSalario / 2;

        //Busqueda de todos los conceptos que cotizan para el calculo del ISR
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", GlobalRec."No. empleado");
        HistLinNom.SetRange("Tipo Nómina", Tipcalculo);
        HistLinNom.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)), PerFinal);
        HistLinNom.SetRange("Cotiza ISR", true);
        if HistLinNom.FindSet() then
            repeat
                LinEsqPercepISR.Reset;
                LinEsqPercepISR.SetRange("No. empleado", GlobalRec."No. empleado");
                LinEsqPercepISR.SetRange("Concepto salarial", HistLinNom."Concepto salarial");
                LinEsqPercepISR.FindFirst;
                if LinEsqPercepISR."1ra Quincena" and LinEsqPercepISR."2da Quincena" then begin
                    // MESSAGE('%1 %2 %3 %4 %5',HistLinNom."Concepto salarial",HistLinNom.Total,TotalISR[1][1],LinEsqPercepISR."1ra Quincena"
                    //           ,LinEsqPercepISR."2da Quincena");

                    if HistLinNom."Salario Base" and PrimeraQ then
                        HistLinNom.Total += IngresoSalario;
                    //Solo si el ISR se deduce en ambas quincenas
                    if (HistLinNom.Total <> 0) and (LinEsqPercepISR2."1ra Quincena" and LinEsqPercepISR2."2da Quincena") then begin
                        if (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Deducciones) and (PrimeraQ) then
                            TotalISR[1] [1] += Round(HistLinNom.Total, 0.01)
                        else
                            TotalISR[1] [1] += Round(HistLinNom.Total, 0.01);
                        // MESSAGE('%1 %2 %3 %4 %5',HistLinNom."Concepto salarial",HistLinNom.Total,TotalISR[1][1],LinEsqPercepISR."1ra Quincena"
                        //           ,LinEsqPercepISR."2da Quincena");

                    end
                    else
                        if HistLinNom.Total <> 0 then begin
                            if (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Deducciones) and (PrimeraQ) then
                                TotalISR[1] [1] += Round(HistLinNom.Total, 0.01)
                            else
                                if (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Ingresos) and (PrimeraQ) and
                                   (not HistLinNom."Salario Base") then
                                    TotalISR[1] [1] += Round(HistLinNom.Total, 0.01)
                                else
                                    TotalISR[1] [1] += Round(HistLinNom.Total, 0.01)
                        end;
                end
                else
                    if HistLinNom.Total <> 0 then begin
                        TotalISR[1] [1] += Round(HistLinNom.Total, 0.01);
                        //         MESSAGE('%1 %2 %3 %4 %5',HistLinNom."Concepto salarial",HistLinNom.Total,TotalISR[1][1]);
                    end
            until HistLinNom.Next = 0;

        //modificar calculo descuentos cuando es caso vendedores
        //GRN message('%1 %2',importecotizacionrec,TotalISR[1][1]);

        //GRN 2012 ReCalcularDtosLegales; //Para el caso de que el ISR solo se paga en 1ra, se calculan AFP y SFS para el mes.

        //message('%1 %2',importecotizacionrec,TotalISR[1][1]);

        TotalISR[1] [1] += ImporteCotizacionRec;

        TotalISR[1] [1] += TotalCompany;
        Base := TotalISR[1] [1];
        //message('%1',base);

        // Cálculo del ISR. Busqueda de Rangos ISR
        Indice := 1;
        RetenciónISR.SetRange(Ano, Format(Ano, 4, '<Standard Format,0>'));
        RetenciónISR.FindSet();
        repeat
            RangoISR[Indice] := RetenciónISR."Importe Máximo";
            ImporteRetencion[Indice] := RetenciónISR."Importe retención";
            "%Calcular"[Indice] := RetenciónISR."% Retención";
            Indice += 1;
        until RetenciónISR.Next = 0;


        //message('xx %1 %2 %3 %4',totalisr[1][1]*13,RangoISR[1],RangoISR[2]);

        if TotalISR[1] [1] < (RangoISR[1] / 13) then
            exit;

        if ((TotalISR[1] [1] * 13) >= RangoISR[1]) and
           ((TotalISR[1] [1] * 13) < (RangoISR[2])) then begin
            Importe1 := (TotalISR[1] [1] - (RangoISR[1] / 13)) * "%Calcular"[1] / 100;
            "%Cot" := "%Calcular"[1];
        end
        else
            if ((TotalISR[1] [1] * 13) >= RangoISR[2]) and
               ((TotalISR[1] [1] * 13) < RangoISR[3]) then begin
                Importe1 := ((TotalISR[1] [1] * 13) - RangoISR[2]) * "%Calcular"[2] / 100;
                Importe1 := Round(Importe1 / 13 + ImporteRetencion[2], 0.01);
                "%Cot" := "%Calcular"[2];
            end
            else
                if (TotalISR[1] [1] * 13) >= (RangoISR[2]) then begin
                    Importe1 := ((TotalISR[1] [1] * 13) - RangoISR[2]) * "%Calcular"[2] / 100;
                    Importe1 := Round(Importe1 / 13 + ImporteRetencion[2], 0.01);
                    "%Cot" := "%Calcular"[2];
                end;

        //message('xx %1 %2 %3 %4',totalisr[1][1]*13,RangoISR[1],RangoISR[2],importe1);

        //Aqui se buscan los saldos a favor del empleado y si encuentra uno se pasa a una tabla
        //que sirve de BK al importe
        SaldoFavor.Reset;
        SaldoFavor.SetRange("Cód. Empleado", GlobalRec."No. empleado");
        SaldoFavor.SetRange(Ano, Date2DMY(PerInici, 3));
        SaldoFavor.SetFilter("Importe Pendiente", '>0');
        if SaldoFavor.FindFirst then begin
            BKSaldoFavor.TransferFields(SaldoFavor);
            if not BKSaldoFavor.Insert then
                BKSaldoFavor.Modify;
        end;

        //message('a%1   b%2   c%3   d%4',Importe1, Importe2, Importe3);
        //TotalISR[1][1] := ROUND(Importe1 + Importe2 + Importe3,0.01);
        TotalISR[1] [1] := Importe1;

        ConceptosSal.SetRange(Codigo, ConfNominas."Concepto ISR");
        ConceptosSal.FindFirst;

        PerfilSalImp.Reset;
        PerfilSalImp.Init;

        PerfilSalImp.SetRange("No. empleado", GlobalRec."No. empleado");
        //PerfilSalImp.SETRANGE("Perfil salarial",empleado."Perfil Salarios");
        PerfilSalImp.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
        if not PerfilSalImp.FindFirst then
            exit;

        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
            if ((PerfilSalImp."1ra Quincena" <> PrimeraQ) and PrimeraQ) or ((PerfilSalImp."2da Quincena" <> SegundaQ) and SegundaQ) then
                exit;

        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
           (PerfilSalImp."1ra Quincena") and (PerfilSalImp."2da Quincena") and (PrimeraQ) then
            TotalISR[1] [1] := Round(TotalISR[1] [1] / 2, 0.01)
        else begin
            HistLinNomISR.Reset;
            HistLinNomISR.SetRange("No. empleado", GlobalRec."No. empleado");
            HistLinNomISR.SetRange("Tipo Nómina", Tipcalculo);
            HistLinNomISR.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)), PerFinal);
            HistLinNomISR.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
            if HistLinNomISR.FindFirst then
                TotalISR[1] [1] := TotalISR[1] [1] + HistLinNomISR.Total;

            LinAportesEmpresa.Reset;
            LinAportesEmpresa.SetRange("No. Empleado", GlobalRec."No. empleado");
            LinAportesEmpresa.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)), PerFinal);
            LinAportesEmpresa.SetRange("Concepto Salarial", ConfNominas."Concepto ISR");
            if LinAportesEmpresa.FindFirst then
                TotalISR[1] [1] := TotalISR[1] [1] - LinAportesEmpresa.Importe;
        end;

        if Abs(TotalISR[1] [1]) >= SaldoFavor."Importe Pendiente" then begin
            TotalISR[1] [1] -= SaldoFavor."Importe Pendiente";
            SaldoFavor."Importe Pendiente" := 0;
        end
        else begin
            SaldoFavor."Importe Pendiente" -= TotalISR[1] [1];
            TotalISR[1] [1] := 0;
        end;

        if PerfilSalImp."% ISR Pago Empleado" < 100 then begin
            PerfilSalImp.Cantidad := 1;
            PerfilSalImp.Importe := Base;
            ImporteTotal := TotalISR[1] [1] * -1;
        end;


        if PerfilSalImp."% ISR Pago Empleado" <> 0 then begin
            PerfilSalImp.Importe := Round(TotalISR[1] [1] * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
            ImporteTotal := PerfilSalImp.Importe * -1;

            //Employer
            LinAportesEmpresa.Reset;
            LinAportesEmpresa.SetRange("No. Documento", CabNomina."No. Documento");
            LinAportesEmpresa.SetRange("No. Empleado", CabNomina."No. empleado");
            if LinAportesEmpresa.FindLast then
                NoLinImp := LinAportesEmpresa."No. orden";

            NoLinImp += 10;
            LinAportesEmpresa.Init;
            LinAportesEmpresa."No. Documento" := CabNomina."No. Documento";
            LinAportesEmpresa."No. orden" := NoLinImp;
            LinAportesEmpresa."Empresa cotización" := CabNomina."Empresa cotización";
            LinAportesEmpresa.Período := CabNomina.Período;
            LinAportesEmpresa."No. Empleado" := CabNomina."No. empleado";
            LinAportesEmpresa.Validate("Concepto Salarial", PerfilSalImp."Concepto salarial");
            if PerfilSalImp."% ISR Pago Empleado" < 100 then begin
                LinAportesEmpresa."% Cotizable" := Round("%Cot" * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
                LinAportesEmpresa.Importe := Round(TotalISR[1] [1] * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
            end
            else begin
                LinAportesEmpresa."% Cotizable" := "%Cot";
                LinAportesEmpresa.Importe := Round(TotalISR[1] [1], 0.01);
            end;
            LinAportesEmpresa."Base Imponible" := IngresoSalario;
            LinAportesEmpresa.Descripcion := PerfilSalImp.Descripcion;

            Clear(recTmpDimEntry);
            InsertarDimTemp(ConceptosSal."Dimension Nomina", PerfilSalImp."Concepto salarial");
            InsertarDimTempDef(5200);
            LinAportesEmpresa."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);

            LinAportesEmpresa.Insert;
            "%Cot" := Round("%Cot" * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
        end;

        //Modifico el Saldo ISR a Favor
        SaldoFavor2.CopyFilters(SaldoFavor);
        if SaldoFavor2.FindSet() then begin
            SaldoFavor2.TransferFields(SaldoFavor);
            SaldoFavor2."Importe Pendiente" := SaldoFavor."Importe Pendiente";
            SaldoFavor2.Modify;
        end;

        if (PerfilSalImp.Cantidad <> 0) and (PerfilSalImp.Importe <> 0) then
            InsertNomina(PerfilSalImp);
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


    procedure CalculaDiasVacaciones()
    var
        HistVac: Record "Historico Vacaciones";

        AnoCalculado: Integer;
        MesCalculado: Integer;
        DiaCalculado: Integer;
        DiasVac: Integer;
    begin
        // 30 días a partir de los 11 meses


        DiasVac := 0;
        if (AnoCalculado >= 1) and (MesCalculado = 0) then
            DiasVac := 30
        else
            if (AnoCalculado = 0) and (MesCalculado = 11) then
                DiasVac := 30;

        //message('%1 %2 %3 %4',diasvac,mescalculado,empleado."employment date",anocalculado);
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
}

