codeunit 76072 "Registrar nomina RD -2"

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
        TotalISR: Decimal;
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
        ConfNominas.TestField("Job Journal Template Name");

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
        //         //  empleado.TESTFIELD("Global Dimension 1 Code");
        //         //  empleado.TESTFIELD("Global Dimension 2 Code");

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

        //         CrearCabecera;
        //         // --------------------

        //         PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        //         PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        //         PerfilSal.SetFilter(Cantidad, '<>0');
        //         PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Ingresos);

        //         if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
        //             if dia = 1 then begin
        //                 PerfilSal.SetRange("1ra Quincena", true);
        //                 PrimeraQ := true;
        //             end
        //             else begin
        //                 PerfilSal.SetRange("2da Quincena", true);
        //                 SegundaQ := true;
        //             end;

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
        //             if not Empleado."Excluído Cotización ISR" then
        //                 CalcularIncomeTax;
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
        CabNomina.SetCurrentKey(Ano, Período, "No. empleado");
        CabNomina.SetRange(Ano, Ano);
        CabNomina.SetRange(Período, GlobalRec."Inicio Periodo");
        if not CabNomina.FindFirst then begin
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
        CabNomina.Inicio := GlobalRec."Inicio Periodo";
        CabNomina.Fin := GlobalRec."Fin Período";
        CabNomina."Fecha Entrada" := Empleado."Employment Date";
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

        CabNomina.Insert;

        Contrato.SetRange("No. empleado", Empleado."No.");
        //GRN 12/01/2011 Contrato.SETRANGE("Centro trabajo",Empleado."Working Center");
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

        DfltDimension.SetRange("Table ID", 5200);
        DfltDimension.SetRange("No.", GlobalRec."No. empleado");
        if DfltDimension.FindSet() then
            repeat
                LlenaDimCab(76070, GlobalRec."No. empleado", CabNomina."No. Documento", DfltDimension."Dimension Code",
                            DfltDimension."Dimension Value Code", 0);
            until DfltDimension.Next = 0;

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

        if PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Ingresos then begin
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
                //GRN 20/01/2011        Incidencias.SETFILTER("% To deduct",'<>%1',0);
                if Incidencias.FindSet() then begin
                    repeat
                        //GRN             DiasIncid          += (Incidencias."To Date" - Incidencias."From Date" + 1) *
                        //GRN                                    Incidencias."% To deduct" / 100;
                        if Incidencias."% To deduct" <> 0 then
                            DiasIncid += Incidencias.Quantity * Incidencias."% To deduct" / 100;
                        Incidencias2.Copy(Incidencias);
                        Incidencias2.Closed := true;
                        Incidencias2.Modify;
                    until Incidencias.Next = 0;

                    if DiasIncid < 0 then
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
        if (PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Deducciones) and (PerfilSal.Cantidad <> 0) and
           (PerfilSal.Importe <> 0) and (not PerfilSal."Sujeto Cotizacion") then begin
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
        PerfilSalTr: Record "Perfil Salarial";

        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
        ImporteCotizacion2: Decimal;
        ImporteImpuestos: Decimal;
        Acumulado: Decimal;
    begin
        //fes mig
        /*
        Acumulado := 0;
        DeduccGob.RESET;
        DeduccGob.SETRANGE(Ano,Ano);
        //DeduccGob.SETFILTER("Porciento Empresa",'<>%1',0);
        IF DeduccGob.FINDSET(FALSE,FALSE) THEN
           REPEAT
            IndSkip := FALSE;
            ImporteCotizacion := 0;
            PerfilSalTr.RESET;
            PerfilSalTr.SETRANGE("No. empleado",GlobalRec."No. empleado");
            PerfilSalTr.SETRANGE("Concepto salarial",DeduccGob.Código);
            PerfilSalTr.FINDFIRST;
        
            LinNominasES.RESET;
            LinNominasES.SETRANGE("No. empleado",GlobalRec."No. empleado");
            LinNominasES.SETRANGE("Tipo Nómina",GlobalRec."Tipo Nómina");
            IF ConfNominas."Concepto Otros Ingresos 4" = DeduccGob.Código THEN
               BEGIN
                LinNominasES.SETRANGE("Cotiza SUTA",TRUE);
                Acumulado := FuncNomina.AcumuladoSUTA(GlobalRec."No. empleado",DMY2DATE(1,1,DATE2DMY(PerFinal,3)),
                                                                               DMY2DATE(31,12,DATE2DMY(PerFinal,3)));
        
               END
            ELSE
            IF ConfNominas."Concepto Otros Ingresos 3" = DeduccGob.Código THEN
               BEGIN
                LinNominasES.SETRANGE("Cotiza FUTA",TRUE);
                Acumulado := FuncNomina.AcumuladoFUTA(GlobalRec."No. empleado",DMY2DATE(1,1,DATE2DMY(PerFinal,3)),
                                                                               DMY2DATE(31,12,DATE2DMY(PerFinal,3)));
               END
            ELSE
            IF ConfNominas."Concepto Otras Deducciones 1" = DeduccGob.Código THEN
               BEGIN
                LinNominasES.SETRANGE("Cotiza FICA",TRUE);
                Acumulado := FuncNomina.AcumuladoFICA(GlobalRec."No. empleado",DMY2DATE(1,1,DATE2DMY(PerFinal,3)),
                                                                               DMY2DATE(31,12,DATE2DMY(PerFinal,3)));
               END
            ELSE
            IF ConfNominas."Concepto Otras Deducciones 3" = DeduccGob.Código THEN
               BEGIN
                LinNominasES.SETRANGE("Cotiza SINOT",TRUE);
                Acumulado := FuncNomina.AcumuladoSINOT(GlobalRec."No. empleado",DMY2DATE(1,1,DATE2DMY(PerFinal,3)),
                                                                                DMY2DATE(31,12,DATE2DMY(PerFinal,3)));
               END
            ELSE
            IF ConfNominas."Concepto Otras Deducciones 2" = DeduccGob.Código THEN
               LinNominasES.SETRANGE("Cotiza MEDICARE",TRUE)
            ELSE
            IF ConfNominas."Salario Minimo" = DeduccGob.Código THEN
               LinNominasES.SETRANGE("Cotiza CHOFERIL",TRUE);
        
            IF Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Mensual THEN
               BEGIN
                LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerFinal,3)),PerFinal);
        
                IF LinNominasES.FINDSET(FALSE,FALSE) THEN
                   REPEAT
                    ImporteCotizacion += LinNominasES."Importe Base";
                   UNTIL LinNominasES.NEXT = 0;
                //    MESSAGE('pas a   %1 %2 %3 %4',ImporteCotizacion,PerfilSal."Concepto salarial");
               END
            ELSE
            IF Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal THEN
               BEGIN
                IF (PerfilSalTr."1ra Quincena") AND (NOT PerfilSalTr."2da Quincena") AND (PrimeraQ)THEN
                   BEGIN
                    LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerFinal,3)),PerFinal);
        
                    IF LinNominasES.FINDSET(FALSE,FALSE) THEN
                       REPEAT
                        IF Empleado."Employment Date" >= PerInici THEN
                           ImporteCotizacion += LinNominasES.Total + LinNominasES."Importe Base"/2
                        ELSE
                          ImporteCotizacion += LinNominasES."Importe Base";
                       UNTIL LinNominasES.NEXT = 0;
                //    MESSAGE('pas a   %1 %2 %3 %4',ImporteCotizacion,PerfilSal."Concepto salarial");
                   END
                ELSE
                IF (NOT PerfilSalTr."1ra Quincena") AND (PerfilSalTr."2da Quincena") AND (SegundaQ)THEN
                   BEGIN
                    LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerFinal,3)),PerFinal);
        
                    IF LinNominasES.FINDSET(FALSE,FALSE) THEN
                       REPEAT
                        ImporteCotizacion += LinNominasES.Total;
                       UNTIL LinNominasES.NEXT = 0;
        //                 MESSAGE('pas 2   %1 %2 %3 %4',ImporteCotizacion,LinNominasES.Total,LinNominasES.Período);
                   END
                ELSE
                IF (PerfilSalTr."1ra Quincena") AND (PerfilSalTr."2da Quincena") THEN
                   BEGIN
                    LinNominasES.SETRANGE(Período,PerInici,PerFinal);
        
                    IF LinNominasES.FINDSET(FALSE,FALSE) THEN
                       REPEAT
                        ImporteCotizacion += LinNominasES.Total;
                       UNTIL LinNominasES.NEXT = 0;
        
                    //GRN Para verificar el acumulado del mes en la segunda Quinc. y no descontar mas del tope
                    IF SegundaQ THEN
                       BEGIN
                        ImporteCotizacion2 := ImporteCotizacion;
                        //Busco el importe cotizable
                        LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)));
        
                        IF LinNominasES.FINDSET THEN
                           REPEAT
                            ImporteCotizacion2 += LinNominasES.Total;
                           UNTIL LinNominasES.NEXT = 0;
        
                        ImporteImpuestos := 0;
        
                        //Busco el importe cobrado del impuesto
                        LinNominasES.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)));
        
                        IF LinNominasES.FINDSET THEN
                           REPEAT
                            ImporteImpuestos += LinNominasES.Total;
                           UNTIL LinNominasES.NEXT = 0;
                       END;
                   END
               END;
        
            IF (Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal) AND (IndSkip = FALSE) THEN
               BEGIN
                IF ((PerfilSalTr."1ra Quincena" <> PrimeraQ) AND (PrimeraQ) AND
                   ((Empleado."Fecha salida empresa" = 0D) OR (Empleado."Fecha salida empresa" >= PerFinal))) THEN
                   IndSkip := TRUE;
        
                IF (NOT PerfilSalTr."1ra Quincena") AND (PerfilSalTr."2da Quincena") AND (PrimeraQ) THEN
                   IndSkip := TRUE;
        
                IF ((PerfilSalTr."2da Quincena" <> SegundaQ) AND (SegundaQ) AND
                   ((Empleado."Fecha salida empresa" = 0D) OR (Empleado."Fecha salida empresa" >= PerFinal))) THEN
                   IndSkip := TRUE;
               END;
        
        
            //Employee
            IF DeduccGob."Porciento Empleado" <> 0 THEN
               BEGIN
                MontoAplicar                           := ImporteCotizacion * DeduccGob."Porciento Empleado" / 100;
        
                IF ((MontoAplicar + Acumulado) > DeduccGob."Tope Salarial/Acumulado Anual") AND
                    (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) AND
                    (DeduccGob."Acumula por" = 1) OR (DeduccGob."Acumula por" = 3) THEN
                    MontoAplicar     := DeduccGob."Tope Salarial/Acumulado Anual" - Acumulado;
        
        //MESSAGE('a%1 b%2 %3 %4 %5 %6 %7',DeduccGob."Porciento Empleado",DeduccGob."Tope Salarial/acumulado anual",DeduccGob.Código,
        //                                  IndSkip,MontoAplicar,ImporteImpuestos,ImporteCotizacion);
             {
                IF NOT IndSkip THEN
                   BEGIN
                    PerfilSalTr.Importe                   := ImporteCotizacion;
                    PerfilSalTr.Cantidad                  := 1;
                    ImporteTotal                           := MontoAplicar *-1;
                    "%Cot"                                 := DeduccGob."Porciento Empleado";
                    LinTabla                               += 10;
                    IF ImporteTotal <> 0 THEN
                       InsertNomina(PerfilSalTr);
        
                    LlenaDimCab(76059,GlobalRec."No. empleado",CabNomina."No. Documento",ConfNominas."Dimension Conceptos Salariales",
                                PerfilSal."Concepto salarial",NoLin);
        
                    DfltDimension.SETRANGE("Table ID",5200);
                    DfltDimension.SETRANGE("No.",GlobalRec."No. empleado");
                    IF DfltDimension.FINDSET(FALSE,FALSE) THEN
                       REPEAT
                        LlenaDimCab(76059,GlobalRec."No. empleado",CabNomina."No. Documento",DfltDimension."Dimension Code",
                                    DfltDimension."Dimension Value Code",NoLin);
                       UNTIL DfltDimension.NEXT = 0;
                   END;
            }
               END
            ELSE
            IF DeduccGob."Cuota Empleado" <> 0 THEN
               BEGIN
                ImporteCotizacion := 0;
                MontoAplicar      := DeduccGob."Cuota Empleado";
               END;
        
            IF NOT IndSkip THEN
               BEGIN
                PerfilSalTr.Importe                   := ImporteCotizacion;
                PerfilSalTr.Cantidad                  := 1;
                ImporteTotal                           := MontoAplicar *-1;
                "%Cot"                                 := DeduccGob."Porciento Empleado";
                LinTabla                               += 10;
                IF ImporteTotal <> 0 THEN
                   InsertNomina(PerfilSalTr);
        
                LlenaDimCab(76059,GlobalRec."No. empleado",CabNomina."No. Documento",ConfNominas."Dimension Conceptos Salariales",
                            PerfilSal."Concepto salarial",NoLin);
        
                DfltDimension.SETRANGE("Table ID",5200);
                DfltDimension.SETRANGE("No.",GlobalRec."No. empleado");
                IF DfltDimension.FINDSET(FALSE,FALSE) THEN
                   REPEAT
                    LlenaDimCab(76059,GlobalRec."No. empleado",CabNomina."No. Documento",DfltDimension."Dimension Code",
                                DfltDimension."Dimension Value Code",NoLin);
                   UNTIL DfltDimension.NEXT = 0;
               END;
        
        //---------------- **** Employer **** ----------------
               NoLin                                  += 10;
               LinAportesEmpresa."No. Documento"      := CabNomina."No. Documento";
               LinAportesEmpresa."No. orden"          := NoLin;
               LinAportesEmpresa."Empresa cotización" := CabNomina."Empresa cotización";
               LinAportesEmpresa.Período              := CabNomina.Período;
               LinAportesEmpresa."No. Empleado"       := CabNomina."No. empleado";
               LinAportesEmpresa.VALIDATE("Concepto Salarial", DeduccGob.Código);
               LinAportesEmpresa.Descripcion          := PerfilSalTr.Descripción;
               IF DeduccGob."Porciento Empresa" <> 0 THEN
                  BEGIN
                   MontoAplicar                        := ImporteCotizacion * DeduccGob."Porciento Empresa" / 100;
                   LinAportesEmpresa."% Cotizable"     := DeduccGob."Porciento Empresa";
                   LinAportesEmpresa."Base Imponible"  := ImporteCotizacion;
                  END
               ELSE
                  BEGIN
                   MontoAplicar                        := DeduccGob."Cuota Empresa";
                   LinAportesEmpresa."% Cotizable"     := 0;
                   LinAportesEmpresa."Base Imponible"  := 0;
                  END;
        
               LinAportesEmpresa.Importe              := MontoAplicar*-1;
        
               IF ((MontoAplicar + Acumulado) > DeduccGob."Tope Salarial/Acumulado Anual") AND
                   (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) THEN
                   BEGIN
                    IF ((DeduccGob."Acumula por" = 2) OR  (DeduccGob."Acumula por" = 3)) OR
                       ((DeduccGob."Porciento Empresa" <> 0) AND (DeduccGob."Acumula por" = 1)) THEN
                       LinAportesEmpresa.Importe           := (DeduccGob."Tope Salarial/Acumulado Anual" - Acumulado) *-1;
        
        //            message('%1 %2 %3 %4',DeduccGob.Código,LinAportesEmpresa.Importe);
                    IF LinAportesEmpresa.Importe *-1 > DeduccGob."Tope Salarial/Acumulado Anual" THEN
                       LinAportesEmpresa.Importe := 0;
                   END;
        
               IF (LinAportesEmpresa.Importe <> 0) AND (NOT IndSkip) THEN
                  LinAportesEmpresa.INSERT;
        
               LlenaDimCab(76059,GlobalRec."No. empleado",CabNomina."No. Documento",ConfNominas."Dimension Conceptos Salariales",
                           LinAportesEmpresa."Concepto Salarial",NoLin);
        
               DfltDimension.SETRANGE("Table ID",5200);
               DfltDimension.SETRANGE("No.",GlobalRec."No. empleado");
               IF DfltDimension.FINDSET(FALSE,FALSE) THEN
                  REPEAT
                    LlenaDimCab(76059,GlobalRec."No. empleado",CabNomina."No. Documento",DfltDimension."Dimension Code",
                                DfltDimension."Dimension Value Code",NoLin);
                  UNTIL DfltDimension.NEXT = 0;
           UNTIL DeduccGob.NEXT = 0;
        */
        //fes mig

    end;


    procedure CalcularIncomeTax()
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
        ITEP: Record "Income tax Employee parameters";
        ER: Record "Employee Relative";
        Indice: Integer;
        Importe1: Decimal;
        Importe2: Decimal;
        Importe3: Decimal;
        Importe4: Decimal;
        Importe5: Decimal;
        RangoISR: array[5] of Decimal;
        ImporteRetencion: array[5] of Decimal;
        "%Calcular": array[5] of Integer;
        t: Integer;
        NoLinImp: Integer;
        Base: Decimal;
        TotalCompany: Decimal;
        Err002: Label 'Employee %1 doesn''t have posted payroll in company %2, please verify';
        NumDep: Integer;
        ImporteIRS: Decimal;
    begin
        //CalculoISR
        Importe1 := 0;
        Importe2 := 0;
        Importe3 := 0;
        Importe4 := 0;
        Importe5 := 0;
        TotalCompany := 0;
        Clear(TotalISR);
        LinTabla += 10;
        Clear(TotalISR);
        LinNomina.Init;
        "%Cot" := 0;

        //Primero se calcula el importe base

        //Busco si es quincenal cuando se deduce el ISR
        LinEsqPercepISR2.Reset;
        LinEsqPercepISR2.SetRange("No. empleado", GlobalRec."No. empleado");
        LinEsqPercepISR2.SetRange("Concepto salarial", ConfNominas."Job Journal Template Name");
        if not LinEsqPercepISR2.FindFirst then
            LinEsqPercepISR2.Init;

        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
            //  if (LinEsqPercepISR."1ra Quincena") and (LinEsqPercepISR."2da Quincena") then
            IngresoSalario := IngresoSalario * 12; //Lo llevo a salario anual
            IngresoSalario := IngresoSalario / 2080; //La cantidad de horas laborables al año. Esto da un salario x hora
            IngresoSalario := IngresoSalario * 86.67; //La cantidad de horas en una quincena, saco salario quincenal
        end;

        /*
        //Busqueda de todos los conceptos que cotizan para el calculo del INCOMETAX
        HistLinNom.RESET;
        HistLinNom.SETRANGE("No. empleado",GlobalRec."No. empleado");
        HistLinNom.SETRANGE("Tipo Nómina",Tipcalculo);
        HistLinNom.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)),PerFinal);
        HistLinNom.SETRANGE("Cotiza INCOMETAX",TRUE);
        IF HistLinNom.FINDSET(FALSE,FALSE) THEN
           REPEAT
            LinEsqPercepISR.RESET;
            LinEsqPercepISR.SETRANGE("No. empleado",GlobalRec."No. empleado");
            LinEsqPercepISR.SETRANGE("Concepto salarial",HistLinNom."Concepto salarial");
            LinEsqPercepISR.FINDFIRST;
            IF LinEsqPercepISR."1ra Quincena" AND LinEsqPercepISR."2da Quincena" THEN
               BEGIN
        //        IF HistLinNom."Salario Base" AND PrimeraQ THEN
        //           HistLinNom.Total += IngresoSalario;
        
                //Solo si el Incometax se deduce en ambas quincenas
                IF (HistLinNom.Total <> 0) AND (LinEsqPercepISR2."1ra Quincena" AND LinEsqPercepISR2."2da Quincena") THEN
                   BEGIN
                    IF (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Deducciones) AND (PrimeraQ) THEN
                       TotalISR += ROUND(HistLinNom.Total,0.01)
                    ELSE
                       TotalISR += ROUND(HistLinNom.Total,0.01);
        // MESSAGE('%1 %2 %3 %4 %5',HistLinNom."Concepto salarial",HistLinNom.Total,TotalISR,LinEsqPercepISR."1ra Quincena"
        //           ,LinEsqPercepISR."2da Quincena");
                   END
                ELSE
                IF HistLinNom.Total <> 0 THEN
                   BEGIN
                    IF (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Deducciones) AND (PrimeraQ) THEN
                       TotalISR += ROUND(HistLinNom.Total,0.01)
                    ELSE
                    IF (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Ingresos) AND (PrimeraQ) AND
                       (NOT HistLinNom."Salario Base") THEN
                       TotalISR += ROUND(HistLinNom.Total,0.01)
                    ELSE
                       TotalISR += ROUND(HistLinNom.Total,0.01)
                   END;
               END
            ELSE
            IF HistLinNom.Total <> 0 THEN
              BEGIN
                 TotalISR += ROUND(HistLinNom.Total,0.01);
        //         MESSAGE('%1 %2 %3 %4 %5',HistLinNom."Concepto salarial",HistLinNom.Total,TotalISR);
              END
           UNTIL HistLinNom.NEXT = 0;
        */
        //TotalISR += ImporteCotizacionRec;
        TotalISR := IngresoSalario;

        TotalISR += TotalCompany;
        Base := TotalISR;

        ER.SetRange("Employee No.", GlobalRec."No. empleado");
        if ER.FindSet then
            NumDep := ER.Count;

        ITEP.SetRange("Employee No.", GlobalRec."No. empleado");
        ITEP.SetRange("Wedge Code", ConfNominas."Job Journal Template Name");
        if ITEP.FindFirst then;

        //MESSAGE('xx%1 %2 %3 %4',base,ingresosalario);

        Base := Base - (NumDep * ITEP."Exeption for Dependents") - ITEP."Personal Exemption";
        TotalISR := Base;
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

        //MESSAGE('xx%1 %2 %3 %4',TotalISR,(RangoISR[1]/12),RangoISR[1]);

        if TotalISR < (RangoISR[1]) then
            exit;

        if (TotalISR >= RangoISR[1]) and
           (TotalISR < (RangoISR[2])) then begin
            ImporteIRS := TotalISR * "%Calcular"[1] / 100 - ImporteRetencion[1];
            "%Cot" := "%Calcular"[1];
        end
        else
            if (TotalISR >= RangoISR[2]) and
               (TotalISR < RangoISR[3]) then begin
                ImporteIRS := TotalISR * "%Calcular"[2] / 100 - ImporteRetencion[2];
                "%Cot" := "%Calcular"[2];
            end
            else
                if (TotalISR >= RangoISR[3]) and
                   (TotalISR < RangoISR[4]) then begin
                    ImporteIRS := TotalISR * "%Calcular"[3] / 100 - ImporteRetencion[3];
                    "%Cot" := "%Calcular"[3];
                end
                else
                    if TotalISR >= (RangoISR[4]) then begin
                        "%Cot" := "%Calcular"[4];
                        ImporteIRS := TotalISR * "%Calcular"[4] / 100 - ImporteRetencion[4];
                    end;

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

        //MESSAGE('a%1   b%2   c%3   d%4',ImporteIRS,Empleado."Aporte Voluntario Income Tax");
        TotalISR := Round(ImporteIRS + Empleado."Aporte Voluntario Income Tax", 0.01);

        ConceptosSal.SetRange(Codigo, ConfNominas."Job Journal Template Name");
        ConceptosSal.FindFirst;

        PerfilSalImp.Reset;
        PerfilSalImp.Init;

        PerfilSalImp.SetRange("No. empleado", GlobalRec."No. empleado");
        //PerfilSalImp.SETRANGE("Perfil salarial",empleado."Perfil Salarios");
        PerfilSalImp.SetRange("Concepto salarial", ConfNominas."Job Journal Template Name");
        if not PerfilSalImp.FindFirst then
            exit;

        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
            if ((PerfilSalImp."1ra Quincena" <> PrimeraQ) and PrimeraQ) or ((PerfilSalImp."2da Quincena" <> SegundaQ) and SegundaQ) then
                exit;
        /*
        IF (Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal) AND
           (PerfilSalImp."1ra Quincena") AND (PerfilSalImp."2da Quincena") AND (PrimeraQ) THEN
           TotalISR := ROUND(TotalISR / 2, 0.01)
        ELSE
           BEGIN
            HistLinNomISR.RESET;
            HistLinNomISR.SETRANGE("No. empleado",GlobalRec."No. empleado");
            HistLinNomISR.SETRANGE("Tipo Nómina",Tipcalculo);
            HistLinNomISR.SETRANGE(Período,DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)),PerFinal);
            HistLinNomISR.SETRANGE("Concepto salarial",ConfNominas."Concepto INCOMETAX");
            IF HistLinNomISR.FINDFIRST THEN
               TotalISR := TotalISR + HistLinNomISR.Total;
           END;
        */
        if Abs(TotalISR) >= SaldoFavor."Importe Pendiente" then begin
            TotalISR -= SaldoFavor."Importe Pendiente";
            SaldoFavor."Importe Pendiente" := 0;
        end
        else begin
            SaldoFavor."Importe Pendiente" -= TotalISR;
            TotalISR := 0;
        end;

        PerfilSalImp.Cantidad := 1;
        PerfilSalImp.Importe := Base;
        ImporteTotal := TotalISR * -1;

        if PerfilSalImp."% ISR Pago Empleado" <> 0 then begin
            PerfilSalImp.Importe := Round(TotalISR * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
            ImporteTotal := Round(PerfilSalImp.Importe) * -1;

            //Employer
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
            LinAportesEmpresa."% Cotizable" := Round("%Cot" * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
            LinAportesEmpresa."Base Imponible" := IngresoSalario;
            LinAportesEmpresa.Importe := Round(TotalISR * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
            LinAportesEmpresa.Insert;
            "%Cot" := Round("%Cot" * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
            LlenaDimCab(76059, CabNomina."No. empleado", CabNomina."No. Documento", ConceptosSal."Dimension Nomina",
                        PerfilSalImp."Concepto salarial", NoLinImp);

            DfltDimension.SetRange("Table ID", 5200);
            DfltDimension.SetRange("No.", CabNomina."No. empleado");
            if DfltDimension.FindSet() then
                repeat
                    LlenaDimCab(76059, CabNomina."No. empleado", CabNomina."No. Documento", DfltDimension."Dimension Code",
                                DfltDimension."Dimension Value Code", NoLinImp);
                until DfltDimension.Next = 0;
        end;

        //Modifico el Saldo ISR a Favor
        SaldoFavor2.CopyFilters(SaldoFavor);
        if SaldoFavor2.FindSet() then begin
            SaldoFavor2.TransferFields(SaldoFavor);
            SaldoFavor2."Importe Pendiente" := SaldoFavor."Importe Pendiente";
            SaldoFavor2.Modify;
        end;
        LinNomina."Aporte Voluntario" := Empleado."Aporte Voluntario Income Tax";
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
        //Busca la cuota del prestamo
        PerfilSal.SetRange("No. empleado", PerfilSal."No. empleado");
        PerfilSal.SetRange(Descripcion, ConfNominas."Concepto CxC Empl.");
        PerfilSal.SetRange("Cotiza SFS", GlobalRec."Cotiza SFS");
        if PerfilSal.FindFirst then;

        rHistCabPrestamo.SetRange("Employee No.", PerfilSal."No. empleado");
        rHistCabPrestamo.SetRange(Pendiente, true);
        if rHistCabPrestamo.FindFirst then begin
            rHistLinPrestamo.SetRange("Código Empleado", rHistCabPrestamo."Employee No.");
            rHistLinPrestamo.SetRange("No. Préstamo", rHistCabPrestamo."No. Préstamo");
            if (rHistLinPrestamo.Find('+')) and (PerfilSal."Tipo concepto" <> 0) then begin
                rHistLinPrestamo."No. Línea" += 100;
                rHistLinPrestamo."Tipo CxC" := rHistCabPrestamo."Tipo CxC";
                rHistLinPrestamo."No. Cuota" += 1;
                rHistLinPrestamo."Fecha Transacción" := PerInici;
                rHistLinPrestamo."Código Empleado" := PerfilSal."No. empleado";
                rHistLinPrestamo.Importe := -1 * PerfilSal."Tipo concepto";
                rHistLinPrestamo.Validate(Importe);
                rHistCabPrestamo.CalcFields("% Cuota");
                if rHistCabPrestamo."% Cuota" + rHistLinPrestamo.Importe = 0 then begin
                    rHistCabPrestamo.Pendiente := false;
                    rHistCabPrestamo.Modify;
                end;

                rHistLinPrestamo.Insert;
            end;
        end;
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
        if PerfilSal.FindSet() then
            repeat
                ImporteTotal := PerfilSal.Cantidad * Round(PerfilSal.Importe);
                InsertNomina(PerfilSal);
            until PerfilSal.Next = 0;

        CalcularIncomeTax;
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
        LinNomina."Salario Base" := perfSalario."Salario Base";
        LinNomina."Cotiza ISR" := perfSalario."Cotiza ISR";
        LinNomina."Cotiza SFS" := perfSalario."Cotiza SFS";
        LinNomina."Cotiza AFP" := perfSalario."Cotiza AFP";
        LinNomina."Cotiza SRL" := perfSalario."Cotiza SRL";
        LinNomina."Cotiza Infotep" := perfSalario."Cotiza INFOTEP";
        //fes mig LinNomina."Cotiza SUTA"         := perfSalario."Cotiza SUTA";
        //fes mig LinNomina."Cotiza FUTA"         := perfSalario."Job No.";
        //fes mig LinNomina."Cotiza MEDICARE"     := perfSalario."Cotiza MEDICARE";
        LinNomina."Cotiza FICA" := perfSalario."Cotiza FICA";
        //fes mig LinNomina."ISR compensado"        := perfSalario."Cotiza SINOT";
        //fes mig LinNomina."Cotiza CHOFERIL"     := perfSalario."Cotiza CHOFERIL";
        //fes mig LinNomina."Cotiza INCOMETAX"    := perfSalario."Cotiza INCOMETAX";
        LinNomina."Sujeto Cotización" := perfSalario."Sujeto Cotizacion";
        LinNomina.Fórmula := perfSalario."Formula calculo";
        LinNomina.Imprimir := perfSalario.Imprimir;
        LinNomina."Inicio período" := PerInici;
        LinNomina."Fin período" := PerFinal;
        LinNomina."Tipo Nómina" := perfSalario."Tipo Nomina";
        LinNomina."% Cotizable" := "%Cot";
        LinNomina."% Pago Empleado" := perfSalario."% ISR Pago Empleado";
        LinNomina.Departamento := Empleado.Departamento;
        LinNomina."Sub-Departamento" := Empleado."Sub-Departamento";
        LinNomina.Insert;

        ConceptosSal.SetRange(Codigo, perfSalario."Concepto salarial");
        ConceptosSal.FindFirst;

        LlenaDimCab(76071, GlobalRec."No. empleado", CabNomina."No. Documento", ConceptosSal."Dimension Nomina",
                    perfSalario."Concepto salarial", LinTabla);

        DfltDimension.SetRange("Table ID", 5200);
        DfltDimension.SetRange("No.", GlobalRec."No. empleado");
        if DfltDimension.FindSet() then
            repeat
                LlenaDimCab(76071, GlobalRec."No. empleado", CabNomina."No. Documento", DfltDimension."Dimension Code",
                            DfltDimension."Dimension Value Code", LinTabla);
            until DfltDimension.Next = 0;
    end;


    procedure LlenaDimCab(IDObjeto: Integer; NoEmpleado: Code[20]; NoDoc: Code[20]; DimCode: Code[20]; DimValue: Code[20]; LineNo: Integer)
    begin
        //fes mig
        /*
        ToPostedDocDim."Table ID"             := IDObjeto;
        ToPostedDocDim."Document No."         := NoDoc+NoEmpleado;
        ToPostedDocDim."Line No."             := LineNo;
        ToPostedDocDim."Dimension Code"       := DimCode;
        ToPostedDocDim."Dimension Value Code" := DimValue;
        IF ToPostedDocDim.INSERT THEN;
        */
        //fes mig

    end;
}

