codeunit 76060 "Registrar nomina"
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
        recTmpDimEntry: Record "Dimension Set Entry" temporary;
        Puestos: Record "Puestos laborales";
        cduDim: Codeunit DimensionManagement;

        Generar: Boolean;
        "Período": Integer;
        PerInici: Date;
        PerFinal: Date;
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
        DimSetID: Integer;
        AFPMes: Decimal;
        SFSMes: Decimal;
        Importecotizacionmes: Decimal;
        Err003: Label 'Total revenue can not be less than total discounts. Please review employee %1';
        Err004: Label 'The difference between Income and Discount exceeds the %1 allowed. Please check employee %2';


    procedure CODIGO()
    var
        HayNominaObra: Boolean;
    begin
        ConfNominas.Get();
        ConfNominas.TestField("Concepto ISR");


        if GlobalRec."Tipo Nomina" <> 2 then //Bonificaciones
           begin
            Contrato.Reset;
            Contrato.SetRange("No. empleado", GlobalRec."No. empleado");
            Contrato.SetRange(Activo, true);
            Contrato.FindFirst;
        end
        else begin
            Contrato.Reset;
            Contrato.SetRange("No. empleado", GlobalRec."No. empleado");
            Contrato.FindLast;
        end;

        PrimeraQ := false;
        SegundaQ := false;
        ImporteCotizacion := 0;
        ImporteTotal := 0;
        "%Cot" := 0;
        ImporteBaseImp := 0;

        // with GlobalRec do begin
        //     Empleado.Get("No. empleado");
        //     if (Empleado."Mes Nacimiento" = 0) and
        //        (Empleado."Birth Date" <> 0D) then begin
        //         Empleado.Validate("Birth Date");
        //         Empleado.Modify;
        //     end;


        //     //  empleado.TESTFIELD("Global Dimension 1 Code");
        //     //  empleado.TESTFIELD("Global Dimension 2 Code");

        //     PerInici := GlobalRec."Inicio Periodo";
        //     PerFinal := GlobalRec."Fin Período";
        //     dia := Date2DMY(PerInici, 1);
        //     if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
        //         if (dia <> 1) and (dia <> 16) then
        //             Error(Err002);
        //     Mes := Date2DMY(PerInici, 2);
        //     Ano := Date2DMY(PerInici, 3);
        //     //ERROR('%1 %2',PerInici,PerFinal);



        //     //Para los empleados en proyectos
        //     if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") and
        //        ("Tipo Nomina" = "Tipo Nomina"::Normal) then begin
        //         HayNominaObra := CalculaNominaProy(GlobalRec."No. empleado", GlobalRec."Job No.", PerInici, PerFinal);
        //         if not HayNominaObra then
        //             exit;
        //     end;

        //     /*
        //       IF (Empleado."Fin contrato" <> 0D) AND (Empleado."Fin contrato" < Perfinal) AND
        //          (Empleado."Calcular Nomina") THEN
        //          BEGIN
        //           IF Contrato."Fecha finalización" <> 0D THEN
        //              BEGIN
        //               Empleado."Calcular Nomina"    := FALSE;
        //               Empleado."Fin contrato"       := Empleado."Fin contrato";
        //               Empleado.MODIFY;

        //               Contrato."Fecha finalización" := Empleado."Fin contrato";
        //               Contrato.Finalizado           := TRUE;
        //               Contrato.MODIFY;
        //               EXIT;
        //              END;
        //          END;
        //     */
        //     CalculaDiasVacaciones;
        //     CrearCabecera;
        //     // --------------------

        //     PerfilSal.Reset;
        //     PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        //     PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        //     PerfilSal.SetFilter(Cantidad, '<>0');
        //     PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Ingresos);

        //     if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
        //         if dia = 1 then begin
        //             if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal then
        //                 PerfilSal.SetRange("1ra Quincena", true);

        //             PrimeraQ := true;
        //         end
        //         else begin
        //             if GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal then
        //                 PerfilSal.SetRange("2da Quincena", true);

        //             SegundaQ := true;
        //         end;

        //     if PerfilSal.FindSet() then
        //         repeat
        //             //Para la bonificacion
        //             if GlobalRec."Tipo Nomina" = 2 then begin
        //                 CalculoBonificacion;
        //                 CalcularDtosLegales;
        //                 if not ConfNominas."Impuestos manuales" then
        //                     CalcularISR;
        //                 EliminaCabecera;
        //                 exit;
        //             end;

        //             //Para la Regalia
        //             if GlobalRec."Tipo Nomina" = 1 then begin
        //                 CalculoRegalia;
        //                 exit;
        //             end;

        //             //Para la Propina
        //             if GlobalRec."Tipo Nomina" = 3 then begin
        //                 CalculoPropina;
        //                 if not ConfNominas."Impuestos manuales" then begin
        //                     CalcularDtosLegales;
        //                     CalcularISR;
        //                 end;
        //                 EliminaCabecera;
        //                 exit;
        //             end;

        //             CalcularIngresos;
        //         until PerfilSal.Next = 0;

        //     PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Deducciones);
        //     if PerfilSal.FindSet() then
        //         repeat
        //             //Para la bonificacion
        //             if GlobalRec."Tipo Nomina" = 2 then begin
        //                 CalculoBonificacion;
        //                 exit;
        //             end;

        //             //Para la Regalia
        //             if GlobalRec."Tipo Nomina" = 1 then begin
        //                 CalculoRegalia;
        //                 exit;
        //             end;

        //             CalcularPrestamos;
        //             CalcularDescuentos;
        //         until PerfilSal.Next = 0;

        //     if Empleado."Calcular Nomina" then begin
        //         CalcularDtosLegales;
        //         //      IF NOT Empleado."Excluído Cotización SFS" THEN
        //         if not ConfNominas."Impuestos manuales" then
        //             CalcularISR;
        //     end;


        //     //Verifico que no se descuente mas de lo que se le paga.
        //     CabNomina.CalcFields("Total Ingresos", "Total deducciones");
        //     if (CabNomina."Total deducciones" <> 0) and (CabNomina."Total Ingresos" <> 0) then begin
        //         if Abs(CabNomina."Total deducciones") > CabNomina."Total Ingresos" then
        //             Error(StrSubstNo(Err003, CabNomina."Full name"));
        //     end;

        //     //Verifico que el descuento no sobrepase lo permitido en la configuracion.
        //     if ConfNominas."% dif. Ingresos y descuentos" <> 0 then begin
        //         if (CabNomina."Total deducciones" <> 0) and (CabNomina."Total Ingresos" <> 0) then begin
        //             if Abs(CabNomina."Total deducciones") / CabNomina."Total Ingresos" * 100 > ConfNominas."% dif. Ingresos y descuentos" then
        //                 Error(StrSubstNo(Err004, ConfNominas.FieldCaption("% dif. Ingresos y descuentos"), CabNomina."Full name"));
        //         end;
        //     end;

        //     if Empleado."Fin contrato" <> 0D then begin
        //         //   IF Contrato."Fecha finalización" = 0D THEN
        //         begin
        //             Empleado."Calcular Nomina" := false;
        //             Empleado."Fin contrato" := Empleado."Fin contrato";
        //             Empleado.Status := Empleado.Status::Terminated;
        //             Empleado.Modify;

        //             Contrato."Fecha finalización" := Empleado."Fin contrato";
        //             Contrato.Finalizado := true;
        //             Contrato.Modify;
        //         end;
        //     end;
        // end;

        // RegistraIncidencias;

        EliminaCabecera;

    end;


    procedure CrearCabecera()
    var
        CompanyTaxes: Record "Cab. Aportes Empresas";
        GestNoSer: Codeunit "No. Series";
        DPE: Record "Distrib. Ingreso Pagos Elect.";
        HCN: Record "Historico Cab. nomina";
    begin
        HCN.Reset;
        HCN.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        HCN.SetRange(Período, PerInici, PerFinal);
        HCN.SetRange("Frecuencia de pago", Contrato."Frecuencia de pago");
        if HCN.FindFirst then
            CabNomina."No. Documento" := HCN."No. Documento";

        if CabNomina."No. Documento" = '' then begin
            ConfNominas.TestField("No. serie nominas");
            GestNoSer.GetNextNo(ConfNominas."No. serie nominas");
        end;
        //Para buscar los datos del banco
        Clear(DPE);
        DPE.SetRange("No. empleado", GlobalRec."No. empleado");
        if DPE.FindFirst then;

        //Para buscar la semana cuando sea Bi-semanal o semanal
        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal) and
           (GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal) then begin
            Fecha.Reset;
            Fecha.SetRange("Period Start", PerInici);
            //Fecha.SETRANGE("Period End",PerFinal);
            Fecha.SetRange("Period Type", Fecha."Period Type"::Week);
            Fecha.FindFirst;
        end
        else
            if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") and
               (GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal) then begin
            end;

        //Create Payroll Header
        CabNomina."No. empleado" := GlobalRec."No. empleado";
        CabNomina.Ano := Ano;
        CabNomina.Período := GlobalRec."Inicio Periodo";
        CabNomina."Tipo Nomina" := GlobalRec."Tipo Nomina";
        CabNomina."Empresa cotización" := Empleado.Company;
        CabNomina."Centro trabajo" := Empleado."Working Center";
        CabNomina.Inicio := PerInici;
        CabNomina.Fin := PerFinal;
        CabNomina."Fecha Entrada" := Empleado."Employment Date";
        CabNomina."Fecha Salida" := Empleado."Fin contrato";
        CabNomina."Full name" := Empleado."Full Name";
        CabNomina.Cargo := Empleado."Job Type Code";
        CabNomina."Tipo Empleado" := Empleado."Tipo Empleado";
        CabNomina.Banco := DPE."Cod. Banco";
        CabNomina."Tipo Cuenta" := DPE."Tipo Cuenta";
        CabNomina."Frecuencia de pago" := Contrato."Frecuencia de pago";
        CabNomina.Cuenta := DPE."Numero Cuenta";
        //CabNomina.Semana                     := Fecha."Period No.";
        CabNomina."Forma de Cobro" := Empleado."Forma de Cobro";
        CabNomina.Validate("Shortcut Dimension 1 Code", Empleado."Global Dimension 1 Code");
        CabNomina.Validate("Shortcut Dimension 2 Code", Empleado."Global Dimension 2 Code");
        CabNomina.Departamento := Empleado.Departamento;
        CabNomina."Sub-Departamento" := Empleado."Sub-Departamento";
        CabNomina."Job No." := GlobalRec."Job No.";
        Clear(recTmpDimEntry);
        InsertarDimTempDef(5200);
        CabNomina."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);
        CabNomina.Insert;

        CabNomina.Get(Empleado."No.", Ano, GlobalRec."Inicio Periodo", GlobalRec."Job No.", GlobalRec."Tipo Nomina");

        /*//GRN 06/04/10
        IF Empleado."fin contrato" <> 0D THEN
           IF Contrato."Fecha finalización" = 0D THEN
              BEGIN
               Empleado."Calcular Nomina"    := FALSE;
               Empleado."Fin contrato"       := Empleado."fin contrato";
               Empleado.MODIFY;
        
               Contrato."Fecha finalización" := Empleado."fin contrato";
               Contrato.Finalizado           := TRUE;
               Contrato.MODIFY;
              END;
        */

        //Create Company's Taxes Header
        CompanyTaxes."No. Documento" := CabNomina."No. Documento";
        CompanyTaxes."Unidad cotización" := CabNomina."Empresa cotización";
        CompanyTaxes."Tipo Nomina" := CabNomina."Tipo Nomina";
        CompanyTaxes.Período := CabNomina.Período;
        CompanyTaxes."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);
        //CompanyTaxes."Tipo nomina"       := Contrato."Frecuencia de pago";
        CompanyTaxes."Job No." := GlobalRec."Job No.";
        DimSetID := CompanyTaxes."Dimension Set ID";
        if CompanyTaxes.Insert then;


        //Verifico los conceptos con cantidades y sin importes y limpio el valor de cantidad
        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        PerfilSal.SetFilter(Cantidad, '<>0');
        PerfilSal.SetRange(Importe, 0);
        if PerfilSal.FindSet() then
            repeat
                PerfilSal.Cantidad := 0;
                PerfilSal.Modify;
            until PerfilSal.Next = 0;

    end;


    procedure CalcularIngresos()
    var
        LinNominasES: Record "Historico Lin. nomina";
        Incidencias: Record "Employee Absence";
        Incidencias2: Record "Employee Absence";
        ParamCalcDias: Record "Parametros Calculo Dias";
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


        Empleado.TestField("Job Type Code");
        Puestos.Get(Empleado."Job Type Code");

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
                        //Esto NO VA  IF Puestos."Metodo calculo Paga Salario" = 0 THEN //Para Normal, se divide el salario
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

                        ConfNominas.TestField("Metodo calculo Ingresos");
                        ParamCalcDias.Get(ConfNominas."Metodo calculo Ingresos");
                        if ParamCalcDias.Valor <> 30 then begin
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
                        end;
                        DiasPago := CantidadDiasEnt;
                        ImporteBaseImp := ImporteTotal;
                    end;
                end
                else
                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then begin
                        CantidadDiasEnt := 30;
                        if Empleado."Employment Date" > PerInici then begin
                            CantidadDiasEnt := PerFinal - Empleado."Employment Date" + 1;

                            CantidadDiasEnt := CantidadDiasEnt - DiasAusencia;

                            if CantidadDiasEnt <= 0 then
                                Error(Err001, CantidadDiasEnt, Empleado."No.");

                            //message('%1 %2 %3 %4',cantidaddiasent);
                            if Puestos."Metodo cálculo Ingresos" = '' then
                                CalcDias.Get(ConfNominas."Metodo calculo Ingresos")
                            else
                                CalcDias.Get(Puestos."Metodo cálculo Ingresos");

                            if CalcDias.Valor <> 30 then begin
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
                            end;
                            DiasPago := CantidadDiasEnt;
                            ImporteBaseImp := ImporteTotal;

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
                        DiasIncid += Incidencias.Quantity * Incidencias."% To deduct" / 100;
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

                if Empleado."Fin contrato" <> 0D then
                    if (Empleado."Fin contrato" >= PerInici) and (Empleado."Fin contrato" <= PerFinal) then begin
                        CantidadDiasSal := Empleado."Fin contrato" - PerInici + 1;
                        CantidadDiasEnt := CantidadDiasEnt - CantidadDiasSal + 1;

                        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                            if CantidadDiasSal > 15 then
                                CantidadDiasSal := 0;

                        //Para no incluir en el calculo los dias con incidencias
                        ConfNominas.TestField("Metodo calculo Ingresos");
                        ParamCalcDias.Get(ConfNominas."Metodo calculo Ingresos");
                        if ParamCalcDias.Valor <> 30 then begin
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
                                    if Empleado."Fin contrato" <= PerFinal then
                                        Fecha.SetRange("Period Start", PerInici, Empleado."Fin contrato")
                                    else
                                        Fecha.SetRange("Period Start", PerInici, PerFinal);
                            Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
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
                        end;
                        //error('bb %1 %2 %3 %4',cantidaddiassal,diaspago,DiasIncid,calendar.COUNT,fecha.GETFILTERS);
                        if Puestos."Incluye Dias Feriados" then begin
                            Calendar.Reset;
                            if Incidencias."To Date" <> 0D then
                                Calendar.SetRange(Fecha, Incidencias."To Date", PerFinal)
                            else
                                Calendar.SetRange(Fecha, PerInici, PerFinal);
                            if Calendar.FindSet then
                                repeat
                                    if Calendar.Fecha > Incidencias."To Date" then
                                        if Empleado."Fin contrato" <> 0D then begin
                                            if (Empleado."Fin contrato" >= PerInici) and
                                               (Empleado."Fin contrato" >= Calendar.Fecha) then
                                                DiasCal += 1;
                                        end
                                        else
                                            DiasCal += 1;
                                until Calendar.Next = 0;
                        end;

                        DiasPago := CantidadDiasSal - DiasPago - DiasIncid - DiasCal;
                        //error('%1 %2 %3 %4',cantidaddiassal,diaspago,DiasIncid,diascal);
                    end;

                if (Empleado."Fin contrato" = PerFinal) and ((Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) or
                   (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal")) then
                    if not Incidencias.FindFirst then
                        DiasPago := 0;

                //MESSAGE('%1 %2 %3 %4',Empleado."Fin contrato", PerFinal,DiasCal);
                if DiasPago <> 0 then begin
                    if Empleado."Employment Date" >= PerInici then begin
                        if Puestos."Metodo cálculo Ingresos" = '' then
                            CalcDias.Get(ConfNominas."Metodo calculo Ingresos")
                        else
                            CalcDias.Get(Puestos."Metodo cálculo Ingresos");
                        //                message('%1 %2 %3 %4',ingresosalario, calcdias.valor, diaspago);
                        ImporteTotal := IngresoSalario / CalcDias.Valor * DiasPago;
                        ImporteBaseImp := ImporteTotal;
                    end;

                    if (Empleado."Fin contrato" >= PerInici) and (Empleado."Fin contrato" <= PerFinal) then begin
                        CalcDias.Get(ConfNominas."Metodo calculo Salidas");
                        //                error('%1 %2 %3',CalcDias.Valor, IngresoSalario, DiasPago);
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
        //MESSAGE('%1 %2',PerfilSal."Tipo Nomina" , GlobalRec."Tipo Nomina" );
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
        if ConfNominas."Impuestos manuales" then
            exit;
        DeduccGob.Reset;
        DeduccGob.SetRange(Ano, Ano);
        DeduccGob.FindSet();
        repeat
            IndSkip := false;
            if Empleado."Excluído Cotización TSS" then begin
                if (DeduccGob.Código = ConfNominas."Concepto AFP") or (DeduccGob.Código = ConfNominas."Concepto SFS") or
                   (DeduccGob.Código = ConfNominas."Concepto SRL") then
                    IndSkip := true;
            end;

            ImporteCotizacion := 0;
            ImporteCotizacionEmp := 0;
            Importecotizacionmes := 0;

            PerfilSalTr.Reset;
            PerfilSalTr.SetRange("No. empleado", GlobalRec."No. empleado");
            PerfilSalTr.SetRange("Concepto salarial", DeduccGob.Código);
            PerfilSalTr.FindFirst;

            LinNominasES.Reset;
            LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
            //    LinNominasES.SETRANGE("Tipo Nomina",GlobalRec."Tipo Nomina");
            LinNominasES.SetRange("Job No.", GlobalRec."Job No.");

            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then begin
                LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                //            LinNominasES.SETRANGE("Sujeto Cotización",TRUE);
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

                //       IF Empleado."Excluído Cotización TSS" THEN
                //          IndSkip := TRUE;

                if LinNominasES.FindSet() then
                    repeat
                        if (not Empleado."Excluído Cotización TSS") and ((LinNominasES."Cotiza SFS" or LinNominasES."Cotiza AFP")) then begin
                            ImporteCotizacion += LinNominasES.Total;
                            ImporteCotizacionEmp += LinNominasES.Total;
                        end
                        else
                            if (LinNominasES."Cotiza SRL" or (LinNominasES."Cotiza Infotep")) then begin
                                ImporteCotizacion += LinNominasES.Total;
                                ImporteCotizacionEmp += LinNominasES.Total;
                            end

                    until LinNominasES.Next = 0;
                // MESSAGE('pas a   %1 %2 %3 %4',ImporteCotizacion,PerfilSal."Concepto salarial");
            end
            else
                if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                    if (PerfilSalTr."1ra Quincena") and (not PerfilSalTr."2da Quincena") and (PrimeraQ) then begin
                        LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                        //LinNominasES.SETRANGE("Sujeto Cotización",TRUE);
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

                        //   IF Empleado."Excluído Cotización TSS" THEN
                        //      IndSkip := TRUE;

                        if LinNominasES.FindSet() then
                            repeat
                                if (not Empleado."Excluído Cotización TSS") and ((LinNominasES."Cotiza SFS" or LinNominasES."Cotiza AFP")) then begin
                                    if Empleado."Employment Date" >= PerInici then begin
                                        ImporteCotizacion += LinNominasES.Total;
                                        ImporteCotizacionEmp += LinNominasES.Total;
                                    end
                                    else begin
                                        ImporteCotizacion += LinNominasES."Importe Base";
                                        ImporteCotizacionEmp += LinNominasES."Importe Base"; //Ojo, importe base
                                                                                             //MESSAGE('%1 %2 %3',LinNominasES."Concepto salarial",LinNominasES."Importe Base",ImporteCotizacionEmp);
                                    end;
                                end
                                else
                                    if (LinNominasES."Cotiza SRL" or (LinNominasES."Cotiza Infotep")) then begin
                                        if Empleado."Employment Date" >= PerInici then begin
                                            ImporteCotizacion += LinNominasES.Total;
                                            ImporteCotizacionEmp += LinNominasES.Total;
                                        end
                                        else begin
                                            ImporteCotizacion += LinNominasES."Importe Base";
                                            ImporteCotizacionEmp += LinNominasES."Importe Base"; //Ojo, importe base
                                        end;
                                    end;
                            until LinNominasES.Next = 0;
                    end
                    else
                        if (not PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena") and (SegundaQ) then begin
                            LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerFinal, 3)), PerFinal);
                            //LinNominasES.SETRANGE("Sujeto Cotización",TRUE);
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

                            //  IF Empleado."Excluído Cotización TSS" THEN
                            //     IndSkip := TRUE;

                            if LinNominasES.FindSet() then
                                repeat
                                    if (not Empleado."Excluído Cotización TSS") and ((LinNominasES."Cotiza SFS" or LinNominasES."Cotiza AFP")) then begin
                                        ImporteCotizacion += LinNominasES.Total;
                                        ImporteCotizacionEmp += LinNominasES.Total;
                                    end
                                    else
                                        if (LinNominasES."Cotiza SRL" or (LinNominasES."Cotiza Infotep")) then begin
                                            ImporteCotizacion += LinNominasES.Total;
                                            ImporteCotizacionEmp += LinNominasES.Total;
                                        end;

                                until LinNominasES.Next = 0;
                        end
                        else
                            if PerfilSalTr."1ra Quincena" and PerfilSalTr."2da Quincena" then begin
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

                                //  IF Empleado."Excluído Cotización TSS" THEN
                                //     IndSkip := TRUE;

                                if LinNominasES.FindSet() then
                                    repeat
                                        //MESSAGE('%1 %2',Empleado."Termination Date",Empleado."No.");

                                        if (not Empleado."Excluído Cotización TSS") and ((LinNominasES."Cotiza SFS" or LinNominasES."Cotiza AFP")) then begin
                                            if (Puestos."Metodo calculo Paga Salario" = Puestos."Metodo calculo Paga Salario"::Distribuido) and
                                               (LinNominasES."Salario Base") and (PrimeraQ) then begin
                                                if (LinNominasES."Importe Base" > DeduccGob."Tope Salarial/Acumulado Anual") and
                                                   (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then
                                                    ImporteCotizacion += DeduccGob."Tope Salarial/Acumulado Anual" / 2
                                                else
                                                    if Empleado."Employment Date" >= PerInici then begin
                                                        ImporteCotizacion += LinNominasES.Total;
                                                        Importecotizacionmes += LinNominasES."Importe Base" / 2 + LinNominasES.Total; //IDC
                                                    end
                                                    else
                                                        if (Date2DMY(Empleado."Employment Date", 2) = Date2DMY(PerInici, 2)) and (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(PerInici, 3)) and
                                                           (SegundaQ) then begin
                                                            ImporteCotizacion += LinNominasES.Total;
                                                            Importecotizacionmes += LinNominasES.Total; //IDC
                                                        end
                                                        else
                                                            if (Empleado."Termination Date" <> 0D) then begin
                                                                if (Date2DMY(Empleado."Termination Date", 2) = Date2DMY(PerInici, 2)) and (Date2DMY(Empleado."Termination Date", 3) = Date2DMY(PerInici, 3)) then begin
                                                                    ImporteCotizacion += LinNominasES.Total;
                                                                    Importecotizacionmes += LinNominasES.Total; //IDC
                                                                end;
                                                            end
                                                            else
                                                                if SegundaQ then begin
                                                                    ImporteCotizacion += LinNominasES.Total;
                                                                    // MESSAGE('%1',LinNominasES."Importe Base");
                                                                end
                                                                else
                                                                    ImporteCotizacion += LinNominasES.Total;

                                                ImporteCotizacionEmp := ImporteCotizacion;
                                            end
                                            else begin
                                                ImporteCotizacion += LinNominasES.Total;
                                                ImporteCotizacionEmp += LinNominasES.Total;
                                            end;
                                        end
                                        else
                                            if (LinNominasES."Cotiza SRL" or (LinNominasES."Cotiza Infotep")) then begin
                                                if (Puestos."Metodo calculo Paga Salario" = Puestos."Metodo calculo Paga Salario"::Distribuido) and
                                                   (LinNominasES."Salario Base") then begin
                                                    if (LinNominasES."Importe Base" > DeduccGob."Tope Salarial/Acumulado Anual") and
                                                       (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then
                                                        ImporteCotizacion += DeduccGob."Tope Salarial/Acumulado Anual" / 2
                                                    else
                                                        if Empleado."Employment Date" >= PerInici then begin
                                                            ImporteCotizacion += LinNominasES.Total;
                                                            Importecotizacionmes += LinNominasES."Importe Base" / 2 + LinNominasES.Total; //IDC
                                                        end
                                                        else
                                                            if (Date2DMY(Empleado."Employment Date", 2) = Date2DMY(PerInici, 2)) and (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(PerInici, 3)) and
                                                               (SegundaQ) then begin
                                                                ImporteCotizacion += LinNominasES.Total;
                                                                Importecotizacionmes += LinNominasES.Total; //IDC
                                                            end
                                                            else
                                                                ImporteCotizacion += LinNominasES."Importe Base" / 2;

                                                    ImporteCotizacionEmp := ImporteCotizacion;
                                                end
                                                else begin
                                                    ImporteCotizacion += LinNominasES.Total;
                                                    ImporteCotizacionEmp += LinNominasES.Total;
                                                end;
                                            end;

                                    until LinNominasES.Next = 0;

                                //GRN Para verificar el acumulado del mes en la segunda Quinc. y no descontar mas del tope
                                if SegundaQ then begin
                                    ImporteImpuestos := 0;

                                    //Busco el importe cobrado del impuesto
                                    LinNominasES.Reset;
                                    LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                                    //LinNominasES.SETRANGE("Tipo Nomina",GlobalRec."Tipo Nomina");
                                    LinNominasES.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)));
                                    LinNominasES.SetRange("Concepto salarial", DeduccGob.Código);
                                    if LinNominasES.FindSet then
                                        repeat
                                            ImporteImpuestos += LinNominasES.Total;
                                        until LinNominasES.Next = 0;
                                end;
                            end;
                end
                else
                    if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Semanal) or
                       (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::"Bi-Semanal") then begin
                        LinNominasES.SetRange(Período, PerInici, PerFinal);
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

                        //  IF Empleado."Excluído Cotización TSS" THEN
                        //      IndSkip := TRUE;

                        if LinNominasES.FindSet() then
                            repeat
                                if (not Empleado."Excluído Cotización TSS") and ((LinNominasES."Cotiza SFS" or LinNominasES."Cotiza AFP")) then begin
                                    ImporteCotizacion += LinNominasES.Total;
                                    ImporteCotizacionEmp += LinNominasES.Total;
                                end
                                else
                                    if (LinNominasES."Cotiza SRL" or (LinNominasES."Cotiza Infotep")) then begin
                                        ImporteCotizacion += LinNominasES.Total;
                                        ImporteCotizacionEmp += LinNominasES.Total;
                                    end

                            until LinNominasES.Next = 0;
                        // MESSAGE('pas a   %1 %2 %3 %4',ImporteCotizacion,PerfilSal."Concepto salarial");
                    end;

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
                   ((Empleado."Fin contrato" = 0D) or (Empleado."Fin contrato" >= PerFinal))) then
                    IndSkip := true;

                if (not PerfilSalTr."1ra Quincena") and (PerfilSalTr."2da Quincena") and (PrimeraQ) then
                    IndSkip := true;

                if ((PerfilSalTr."2da Quincena" <> SegundaQ) and (SegundaQ) and
                   ((Empleado."Fin contrato" = 0D) or (Empleado."Fin contrato" >= PerFinal))) then
                    IndSkip := true;
            end;

            //Employee
            if DeduccGob."Porciento Empleado" <> 0 then begin
                MontoAplicar := (ImporteCotizacion * DeduccGob."Porciento Empleado" / 100) + ImporteImpuestos;
                //error('paso 1 %1 %2 %3',importecotizacionmes,montoaplicar,importeimpuestos);
                //IDC
                if ConfNominas."Concepto SFS" = DeduccGob.Código then
                    SFSMes := Importecotizacionmes * DeduccGob."Porciento Empleado" / 100
                else
                    if ConfNominas."Concepto AFP" = DeduccGob.Código then
                        AFPMes := Importecotizacionmes * DeduccGob."Porciento Empleado" / 100;
                //IDC Fin

                if (ImporteCotizacion >= DeduccGob."Tope Salarial/Acumulado Anual") and
                   (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then begin
                    ImporteCotizacion := DeduccGob."Tope Salarial/Acumulado Anual";
                    ImporteCotizacionEmp := ImporteCotizacion;
                    MontoAplicar := ImporteCotizacion * DeduccGob."Porciento Empleado" / 100;
                    MontoAplicar += ImporteImpuestos;
                    if MontoAplicar < 0 then
                        MontoAplicar := 0;
                end;

                if not IndSkip then begin
                    //                  message('paso2 %1 %2 %3',importeimpuestos,montoaplicar,importecotizacion);
                    PerfilSalTr.Importe := ImporteCotizacion;
                    PerfilSalTr.Cantidad := 1;
                    //            MontoAplicar         += ImporteImpuestos;
                    /*
                                IF ((Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal) AND
                                    (PerfilSalTr."1ra Quincena") AND (PerfilSalTr."2da Quincena") AND (PrimeraQ)) OR
                                    (Empleado."fin contrato" <> 0D) THEN
                                    IF Puestos."Metodo calculo Paga Salario" = Puestos."Metodo calculo Paga Salario"::Distribuido THEN
                                       MontoAplicar     /= 2;
                    */
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
            LinAportesEmpresa."Tipo Nomina" := CabNomina."Tipo Nomina";
            LinAportesEmpresa."No. Empleado" := CabNomina."No. empleado";
            LinAportesEmpresa.Validate("Concepto Salarial", DeduccGob.Código);
            LinAportesEmpresa."% Cotizable" := DeduccGob."Porciento Empresa";

            if (ImporteCotizacionEmp > DeduccGob."Tope Salarial/Acumulado Anual") and
               (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then
                ImporteCotizacionEmp := DeduccGob."Tope Salarial/Acumulado Anual";

            LinAportesEmpresa."Base Imponible" := ImporteCotizacionEmp;
            LinAportesEmpresa.Importe := ImporteCotizacionEmp * DeduccGob."Porciento Empresa" / 100 * -1;
            LinAportesEmpresa.Descripcion := PerfilSalTr.Descripcion;
            LinAportesEmpresa."Job No." := GlobalRec."Job No.";
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
                recTmpDimEntry.DeleteAll;
                InsertarDimTempDef(5200);                                                                      //Para las Dim del empleado
                InsertarDimTemp(ConfNominas."Dimension Conceptos Salariales", PerfilSalTr."Concepto salarial"); //Para el concepto salarial
                InsertarDimTempDefPS(76061, Empleado."No." + PerfilSalTr."Concepto salarial");                 //Para las Dim del perfil de salario (linea del concepto salarial)
                InsertarDimTempDefPS(76053, Empleado."Posting Group" + PerfilSalTr."Concepto salarial");    //Para las Dim del grupo contable (linea del concepto salarial)
                InsertarDimTempDefPS(76062, PerfilSalTr."Concepto salarial");    //Para las Dim de la config. concepto salarial
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
        ImpuestoMes: Decimal;
    begin
        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
            ImporteCotizacionRec := 0;
            MontoAplicar := 0;

            DeduccGob.Reset;
            DeduccGob.SetRange(Ano, Ano);
            DeduccGob.SetFilter("Porciento Empleado", '<>%1', 0);
            DeduccGob.FindSet;
            repeat
                PerfilSalTr.Reset;
                PerfilSalTr.SetRange("No. empleado", GlobalRec."No. empleado");
                PerfilSalTr.SetRange("Concepto salarial", DeduccGob.Código);
                PerfilSalTr.SetRange("Cotiza ISR", true);
                PerfilSalTr.FindFirst;
                if PerfilSalTr."1ra Quincena" and PerfilSalTr."2da Quincena" and PrimeraQ then begin
                    IndSkip := false;

                    LinNominasES.Reset;
                    LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                    //LinNominasES.SETRANGE("Tipo Nomina",GlobalRec."Tipo Nomina");
                    LinNominasES.SetRange(Período, PerInici, PerFinal);
                    LinNominasES.SetRange("Concepto salarial", PerfilSalTr."Concepto salarial");
                    LinNominasES.SetRange("Job No.", GlobalRec."Job No.");
                    if LinNominasES.FindFirst then begin
                        if (LinNominasES."Importe Base" >= DeduccGob."Tope Salarial/Acumulado Anual") and (DeduccGob."Tope Salarial/Acumulado Anual" <> 0) then
                            ImpuestoMes := DeduccGob."Tope Salarial/Acumulado Anual" * DeduccGob."Porciento Empleado" / 100;

                        if Abs(LinNominasES.Total * 2) >= ImpuestoMes then
                            MontoAplicar := ImpuestoMes / 2
                        else
                            MontoAplicar := LinNominasES.Total * -1;
                    end;

                    ImporteCotizacionRec += MontoAplicar;
                end;
            until DeduccGob.Next = 0;

            ImporteCotizacionRec *= -1;
        end;

        //MESSAGE('%1',ImporteCotizacionRec);
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
        //Poner que el acumulado base del ISR sea sobre lo devengado en el mes anterior.
        //Si se pasa del mes, solo calcular los dias trabajados en el mes. y revisar para el llenado de la plantilla de la tss

        //CalculoISR
        if Empleado."Excluído Cotización ISR" then
            exit;


        Importe1 := 0;
        //Importe2     := 0;
        //Importe3     := 0;
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
            //   IF Puestos."Metodo calculo Paga Salario" = 0 THEN //Para Normal, se divide el salario
            IngresoSalario := IngresoSalario / 2;

        //Busqueda de todos los conceptos que cotizan para el calculo del ISR
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", GlobalRec."No. empleado");
        //HistLinNom.SETRANGE("Tipo Nomina",CabNomina."Tipo Nomina");
        HistLinNom.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)), PerFinal);
        HistLinNom.SetRange("Cotiza ISR", true);
        if HistLinNom.FindSet() then
            repeat
                LinEsqPercepISR.Reset;
                LinEsqPercepISR.SetRange("No. empleado", GlobalRec."No. empleado");
                LinEsqPercepISR.SetRange("Concepto salarial", HistLinNom."Concepto salarial");
                LinEsqPercepISR.FindFirst;
                if LinEsqPercepISR."1ra Quincena" and LinEsqPercepISR."2da Quincena" then begin
                    if (Puestos."Metodo calculo Paga Salario" = 0) and (HistLinNom."Salario Base" and PrimeraQ) then
                        HistLinNom.Total += IngresoSalario;

                    //Solo si el ISR se deduce en ambas quincenas
                    if (HistLinNom.Total <> 0) and (LinEsqPercepISR2."1ra Quincena" and LinEsqPercepISR2."2da Quincena") then begin
                        if (HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Deducciones) and (PrimeraQ) then begin
                            if (Puestos."Metodo calculo Paga Salario" = Puestos."Metodo calculo Paga Salario"::Distribuido) then begin
                                if (Empleado."Employment Date" >= PerInici) and (PrimeraQ) then begin
                                    if HistLinNom."Concepto salarial" = ConfNominas."Concepto AFP" then
                                        TotalISR[1] [1] -= AFPMes
                                    else
                                        TotalISR[1] [1] -= SFSMes;
                                end
                                else
                                    //Aqui                    if
                                    TotalISR[1] [1] += Round(HistLinNom.Total * 2, 0.01)
                            end
                            else
                                TotalISR[1] [1] += Round(HistLinNom.Total, 0.01);
                        end
                        else
                            TotalISR[1] [1] += Round(HistLinNom.Total, 0.01);
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
                    end;
            //MESSAGE('%1 %2 %3 %4',TotalISR[1][1],HistLinNom."Concepto salarial");
            until HistLinNom.Next = 0;

        //modificar calculo descuentos cuando es caso vendedores

        //ReCalcularDtosLegales; //Para el caso de que el ISR solo se paga en 1ra, se calculan AFP y SFS para el mes.


        TotalISR[1] [1] += ImporteCotizacionRec;

        if (GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal) or
           (GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::"Bonificación") then
            TotalISR[1] [1] += TotalCompany + Empleado."Salario Empresas Externas"
        else
            TotalISR[1] [1] += TotalCompany;

        Base := TotalISR[1] [1];

        //message('%1 %2 %3 %4',BASE,TOTALISR[1][1],TOTALCOMPANY);
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


        if TotalISR[1] [1] < (RangoISR[1] / 12) then
            exit;

        if ((TotalISR[1] [1] * 12) >= RangoISR[1]) and
           ((TotalISR[1] [1] * 12) < (RangoISR[2])) then begin
            Importe1 := (TotalISR[1] [1] - (RangoISR[1] / 12)) * "%Calcular"[1] / 100;
            "%Cot" := "%Calcular"[1];
        end
        else
            if ((TotalISR[1] [1] * 12) >= RangoISR[2]) and
               ((TotalISR[1] [1] * 12) < RangoISR[3]) then begin
                Importe1 := ((TotalISR[1] [1] * 12) - RangoISR[2]) * "%Calcular"[2] / 100;
                Importe1 := Round((Importe1 + ImporteRetencion[2]) / 12, 0.01);
                "%Cot" := "%Calcular"[2];
            end
            else
                if (TotalISR[1] [1] * 12) >= (RangoISR[3]) then begin
                    Importe1 := ((TotalISR[1] [1] * 12) - RangoISR[3]) * "%Calcular"[3] / 100;
                    Importe1 := Round((Importe1 + ImporteRetencion[3]) / 12, 0.01);
                    "%Cot" := "%Calcular"[3];
                end;
        //message('%1 %2 %3 %4',BASE,TOTALISR[1][1],TOTALCOMPANY,importe1);
        //Aqui se buscan los saldos a favor del empleado y si encuentra uno se pasa a una tabla
        //que sirve de BK al importe

        SaldoFavor.Reset;
        SaldoFavor.SetRange("Cód. Empleado", GlobalRec."No. empleado");
        SaldoFavor.SetRange(Ano, Date2DMY(PerInici, 3));
        //SaldoFavor.SETFILTER("Importe Pendiente",'>0');
        if SaldoFavor.FindFirst then begin
            BKSaldoFavor.TransferFields(SaldoFavor);
            if not BKSaldoFavor.Insert then
                BKSaldoFavor.Modify;
        end;

        //message('a%1   b%2   c%3   d%4',Importe1, Importe2, Importe3);
        //TotalISR[1][1] := ROUND(Importe1 + Importe2 + Importe3,0.01);
        TotalISR[1] [1] := Importe1;

        if ((SaldoFavor."Importe Pendiente" <> 0) and (PerfilSal."1ra Quincena") and
            (not PerfilSal."2da Quincena") and (SegundaQ)) then
            exit;

        ConceptosSal.SetRange(Codigo, ConfNominas."Concepto ISR");
        ConceptosSal.FindFirst;

        Clear(PerfilSalImp);

        PerfilSalImp.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSalImp.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
        if not PerfilSalImp.FindFirst then
            exit;

        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
           (GlobalRec."Tipo Nomina" = GlobalRec."Tipo Nomina"::Normal) then
            if ((PerfilSalImp."1ra Quincena" <> PrimeraQ) and PrimeraQ) then
                exit;

        if ((Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
           (PerfilSalImp."1ra Quincena") and (PerfilSalImp."2da Quincena") and (PrimeraQ) and
           (Puestos."Metodo calculo Paga Salario" = 0)) then
            TotalISR[1] [1] := Round(TotalISR[1] [1] / 2, 0.01)
        else begin
            HistLinNomISR.Reset;
            HistLinNomISR.SetRange("No. empleado", GlobalRec."No. empleado");
            HistLinNomISR.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)), PerFinal);
            HistLinNomISR.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
            if HistLinNomISR.FindSet then
                repeat
                    TotalISR[1] [1] := TotalISR[1] [1] + HistLinNomISR.Total;
                until HistLinNomISR.Next = 0;
        end;

        if Abs(TotalISR[1] [1]) >= SaldoFavor."Importe Pendiente" then begin
            TotalISR[1] [1] -= SaldoFavor."Importe Pendiente";
            SaldoFavor."Importe Pendiente" := 0;
        end
        else begin
            SaldoFavor."Importe Pendiente" -= TotalISR[1] [1];
            TotalISR[1] [1] := 0;
        end;

        PerfilSalImp.Cantidad := 1;
        PerfilSalImp.Importe := Base;
        ImporteTotal := TotalISR[1] [1] * -1;

        if PerfilSalImp."% ISR Pago Empleado" <> 0 then begin
            PerfilSalImp.Importe := Round(TotalISR[1] [1] * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
            ImporteTotal := PerfilSalImp.Importe * -1;
            //MESSAGE('paso %1 %2 %3',CabNomina."No. empleado");
            //Employer
            ImporteTotal := 0;
            LinAportesEmpresa.Reset;
            //LinAportesEmpresa.SETRANGE("No. Documento", CabNomina."No. Documento");
            LinAportesEmpresa.SetRange("Tipo Nomina", CabNomina."Tipo Nomina");
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
            LinAportesEmpresa.Importe := Round(TotalISR[1] [1] * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
            LinAportesEmpresa.Descripcion := PerfilSalImp.Descripcion;
            LinAportesEmpresa."Job No." := GlobalRec."Job No.";
            if LinAportesEmpresa.Importe <> 0 then begin
                LinAportesEmpresa.Insert;
                "%Cot" := Round("%Cot" * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);

                Clear(recTmpDimEntry);

                InsertarDimTempDef(5200);                                                                       //Para las Dim del empleado
                InsertarDimTemp(ConfNominas."Dimension Conceptos Salariales", PerfilSalImp."Concepto salarial"); //Para el concepto salarial
                InsertarDimTempDefPS(76061, Empleado."No." + PerfilSalImp."Concepto salarial");                 //Para las Dim del perfil de salario (linea del concepto salarial)
                InsertarDimTempDefPS(76053, Empleado."Posting Group" + PerfilSalImp."Concepto salarial");    //Para las Dim del grupo contable (linea del concepto salarial)
                InsertarDimTempDefPS(76062, PerfilSalImp."Concepto salarial");    //Para las Dim de la config. concepto salarial

                LinAportesEmpresa."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);
            end;
        end;

        //Modifico el Saldo ISR a Favor
        SaldoFavor2.CopyFilters(SaldoFavor);
        if SaldoFavor2.FindSet() then begin
            SaldoFavor2.TransferFields(SaldoFavor);
            SaldoFavor2."Importe Pendiente" := SaldoFavor."Importe Pendiente";
            SaldoFavor2.Modify;
        end;

        PerfilSalImp."Tipo Nomina" := GlobalRec."Tipo Nomina";
        if ImporteTotal <> 0 then
            InsertNomina(PerfilSalImp);
    end;


    procedure CalcularPrestamos()
    var
        LinPerfilSal: Record "Perfil Salarial";
        Prestamos: Record "CxC Empleados";
        HistLinPrestamo: Record "Histórico Lín. Préstamo";
        HistCabPrestamo: Record "Histórico Cab. Préstamo";
        CheckHistLinPrestamo: Record "Histórico Lín. Préstamo";
    begin
        //CalcularPrestamos

        HistCabPrestamo.Reset;
        HistCabPrestamo.SetRange("Employee No.", PerfilSal."No. empleado");
        HistCabPrestamo.SetRange(Pendiente, true);
        if HistCabPrestamo.FindSet then
            repeat
                //Busca la cuota del prestamo

                LinPerfilSal.SetRange("No. empleado", PerfilSal."No. empleado");
                LinPerfilSal.SetRange("Concepto salarial", HistCabPrestamo."Concepto Salarial");
                LinPerfilSal.FindFirst;

                CheckHistLinPrestamo.Reset;
                CheckHistLinPrestamo.SetRange("Código Empleado", HistCabPrestamo."Employee No.");
                CheckHistLinPrestamo.SetRange("No. Préstamo", HistCabPrestamo."No. Préstamo");
                CheckHistLinPrestamo.SetRange("Fecha Transacción", PerInici);
                if not CheckHistLinPrestamo.FindFirst then begin
                    HistLinPrestamo.SetRange("Código Empleado", HistCabPrestamo."Employee No.");
                    HistLinPrestamo.SetRange("No. Préstamo", HistCabPrestamo."No. Préstamo");
                    if (HistLinPrestamo.FindLast) and (LinPerfilSal."Tipo concepto" <> 0) then begin
                        HistLinPrestamo."No. Línea" += 100;
                        HistLinPrestamo."Tipo CxC" := HistCabPrestamo."Tipo CxC";
                        HistLinPrestamo."No. Cuota" += 1;
                        HistLinPrestamo."Fecha Transacción" := PerInici;
                        HistLinPrestamo."Código Empleado" := LinPerfilSal."No. empleado";
                        HistLinPrestamo.Importe := -LinPerfilSal.Importe;
                        HistLinPrestamo.Validate(Importe);
                        HistCabPrestamo.CalcFields("Importe Pendiente");
                        if HistCabPrestamo."Importe Pendiente" + HistLinPrestamo.Importe = 0 then begin
                            HistCabPrestamo.Pendiente := false;
                            HistCabPrestamo.Modify;
                        end;

                        HistLinPrestamo.Insert;
                    end;
                end;
            until HistCabPrestamo.Next = 0;
    end;


    procedure CalculoBonificacion()
    var
        linperfilsal: Record "Perfil Salarial";
    begin
        // Bonificacion
        PerfilSal.Reset;
        //PerfilSal.SETRANGE("Empresa cotización",GlobalRec."Empresa cotización");
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
        //  PerfilSal.SETRANGE("Empresa cotización",GlobalRec."Empresa cotización");
        PerfilSal.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSal.SetRange("Perfil salarial", GlobalRec."Perfil salarial");
        //  PerfilSal.SETRANGE("Tipo concepto",0); {Ingresos  }
        PerfilSal.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        if PerfilSal.FindSet() then
            repeat
                if PerfilSal."Tipo concepto" = PerfilSal."Tipo concepto"::Deducciones then
                    ImporteTotal := (PerfilSal.Cantidad * Round(PerfilSal.Importe)) * -1
                else
                    ImporteTotal := PerfilSal.Cantidad * Round(PerfilSal.Importe);

                LinTabla += 10;

                //ImporteTotal := PerfilSal.Cantidad * ROUND(PerfilSal.Importe);
                InsertNomina(PerfilSal);
            until PerfilSal.Next = 0;

    end;


    procedure CalculoPropina()
    var
        PerfilSalProp: Record "Perfil Salarial";
    begin
        // Propina
        PerfilSalProp.Reset;
        PerfilSalProp.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSalProp.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        PerfilSalProp.SetFilter(Cantidad, '<>%1', 0);
        if PerfilSalProp.FindSet() then
            repeat
                if PerfilSalProp."Tipo concepto" = PerfilSalProp."Tipo concepto"::Deducciones then
                    ImporteTotal := (PerfilSalProp.Cantidad * PerfilSalProp.Importe) * -1
                else
                    ImporteTotal := PerfilSalProp.Cantidad * PerfilSalProp.Importe;
                LinTabla += 10;
                InsertNomina(PerfilSalProp);
            until PerfilSalProp.Next = 0;
    end;


    procedure CalculoRenta()
    var
        PerfilSalRent: Record "Perfil Salarial";
    begin
        // Renta  ==> Nomina que se paga
        PerfilSalRent.Reset;
        PerfilSalRent.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSalRent.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        PerfilSalRent.SetFilter(Cantidad, '<>%1', 0);
        if PerfilSalRent.FindSet() then
            repeat
                if PerfilSalRent."Tipo concepto" = PerfilSalRent."Tipo concepto"::Deducciones then
                    ImporteTotal := (PerfilSalRent.Cantidad * PerfilSalRent.Importe) * -1
                else
                    ImporteTotal := PerfilSalRent.Cantidad * PerfilSalRent.Importe;
                LinTabla += 10;
                InsertNomina(PerfilSalRent);
            until PerfilSalRent.Next = 0;
    end;


    procedure InsertNomina(perfSalario: Record "Perfil Salarial")
    begin
        //InsertNomina
        ConceptosSal.Get(perfSalario."Concepto salarial");

        if ImporteTotal = 0 then
            exit;

        LinNomina."Empresa cotización" := perfSalario."Empresa cotizacion";
        LinNomina."Tipo de nomina" := perfSalario."Tipo de nomina";
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
        LinNomina."Salario Base" := ConceptosSal."Salario Base";
        LinNomina."Cotiza ISR" := ConceptosSal."Cotiza ISR";
        LinNomina."Cotiza SFS" := ConceptosSal."Cotiza SFS";
        LinNomina."Cotiza AFP" := ConceptosSal."Cotiza AFP";
        LinNomina."Cotiza SRL" := ConceptosSal."Cotiza SRL";
        LinNomina."Cotiza Infotep" := ConceptosSal."Cotiza INFOTEP";
        LinNomina."Sujeto Cotización" := ConceptosSal."Sujeto Cotizacion";
        LinNomina."Aplica para Regalia" := ConceptosSal."Aplica para Regalia";
        LinNomina.Fórmula := perfSalario."Formula calculo";
        LinNomina.Imprimir := perfSalario.Imprimir;
        LinNomina."Inicio período" := PerInici;
        LinNomina."Fin período" := PerFinal;
        LinNomina."Tipo de nomina" := GlobalRec."Tipo de nomina";
        LinNomina."% Cotizable" := "%Cot";
        LinNomina."% Pago Empleado" := perfSalario."% ISR Pago Empleado";
        LinNomina.Departamento := Empleado.Departamento;
        LinNomina."Sub-Departamento" := Empleado."Sub-Departamento";
        LinNomina."Frecuencia de pago" := Contrato."Frecuencia de pago";
        LinNomina."Job No." := GlobalRec."Job No.";
        ConceptosSal.SetRange(Codigo, perfSalario."Concepto salarial");
        ConceptosSal.FindFirst;

        recTmpDimEntry.DeleteAll;
        InsertarDimTemp(ConceptosSal."Dimension Nomina", perfSalario."Concepto salarial");         //Para el concepto salarial
        InsertarDimTempDef(5200);                                                                   //Para las Dim del empleado
        InsertarDimTempDefPS(76061, Empleado."No." + perfSalario."Concepto salarial");             //Para las Dim del perfil de salario (linea del concepto salarial)
        InsertarDimTempDefPS(76053, Empleado."Posting Group" + perfSalario."Concepto salarial"); //Para las Dim del grupo contable (linea del concepto salarial)
        InsertarDimTempDefPS(76062, perfSalario."Concepto salarial");    //Para las Dim de la config. concepto salarial
        //MESSAGE('%1 %2',Empleado."Posting Group",Perfsalario."Concepto salarial");
        LinNomina."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);

        LinNomina.Insert;
    end;


    procedure InsertarDimTemp(DimCode: Code[20]; DimValue: Code[20])
    var
        recDimVal: Record "Dimension Value";
    begin
        recDimVal.Get(DimCode, DimValue);
        //message('%1 %2 %3 %4',recDimVal."Dimension Value ID",dimcode,dimsetid,dimvalue);
        if not recTmpDimEntry.Get(DimSetID, DimCode) then begin
            Clear(recTmpDimEntry);
            recTmpDimEntry.Validate("Dimension Code", DimCode);
            recTmpDimEntry.Validate("Dimension Value Code", DimValue);
            recTmpDimEntry.Validate("Dimension Value ID", recDimVal."Dimension Value ID");
            if recTmpDimEntry.Insert(true) then;
        end;
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


    procedure InsertarDimTempDefPS(intPrmTabla: Integer; ConceptoSal: Code[20])
    var
        recDfltDim: Record "Default Dimension";
    begin
        recDfltDim.Reset;
        recDfltDim.SetRange("Table ID", intPrmTabla);
        recDfltDim.SetRange("No.", ConceptoSal);
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

        //DiasVac := FuncNomina.CalculoDiaVacaciones(Empleado."No.",DATE2DMY(PerFinal,2),DATE2DMY(PerFinal,3),0.00,Empleado."Employment Date",PerFinal);

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
            else begin
                HistVac.Init;
                HistVac."No. empleado" := Empleado."No.";
                HistVac."Fecha Inicio" := DMY2Date(1, 1, Date2DMY(PerFinal, 3));
                HistVac."Fecha Fin" := DMY2Date(31, 12, Date2DMY(PerFinal, 3));
                HistVac.Dias := DiasVac;
                HistVac.Insert;
            end;
        end;
    end;


    procedure RegistraIncidencias()
    var
        Incidencias: Record "Employee Absence";
        MovNovedades: Record "Tipos de acciones personal";
        CA: Record "Cause of Absence";
    begin
        //Ingreso
        //Salida
        //Vacaciones
        //Licencia Voluntaria
        //Licencia Maternidad
        //Licencia x Discapacidad
        //Actualizacion de datos
        //Permiso de trabajo
        /*
        //Para registrar las incidencias
        Incidencias.RESET;
        Incidencias.SETRANGE("Employee No.",Empleado."No.");
        Incidencias.SETFILTER("From Date",'>=%1',DMY2DATE(1,DATE2DMY(PerInici,2),DATE2DMY(PerInici,3)));
        Incidencias.SETFILTER("To Date",'<=%1',PerFinal);
        //Incidencias.SETRANGE(Closed,TRUE);
        IF Incidencias.FINDSET(TRUE,FALSE) THEN
           REPEAT
            CLEAR(MovNovedades);
            MovNovedades.VALIDATE("Tipo de accion",Empleado."No.");
            MovNovedades.Codigo := Empleado.Company;
            MovNovedades."ID Documento" := FORMAT(CabNomina.Período,0,'<Month,2><Year4>');
            CA.GET(Incidencias."Cause of Absence Code");
            MovNovedades."Editar salario" := CA."Dias laborables";
            MovNovedades.VALIDATE("Editar cargo" ,Incidencias."From Date");
            MovNovedades.VALIDATE("Transferir entre empresas",Incidencias."To Date");
        //    MovNovedades."Salario SS"
        //    MovNovedades."Salario ISR"
        
            IF MovNovedades.INSERT THEN;
        
            IF NOT Incidencias.Closed THEN
               BEGIN
                Incidencias.Closed := TRUE;
                Incidencias.MODIFY;
               END;
           UNTIL Incidencias.NEXT = 0;
           */

    end;

    local procedure EliminaCabecera()
    begin
        //GRN Elimino Cabecera de los empleados que no tengan ingresos o deducciones
        CabNomina.Reset;
        CabNomina.SetRange("No. empleado", GlobalRec."No. empleado");
        CabNomina.SetRange("Tipo Nomina", GlobalRec."Tipo Nomina");
        CabNomina.SetRange("Frecuencia de pago", Contrato."Frecuencia de pago");
        CabNomina.SetRange(Inicio, PerInici);
        CabNomina.SetRange(Fin, PerFinal);
        //ERROR('%1 %2',CABNOMINA.GETFILTERS,cabnomina."total ingresos");
        if CabNomina.FindFirst then begin
            CabNomina.CalcFields("Total Ingresos");
            if CabNomina."Total Ingresos" = 0 then begin
                /*
                DfltDimension.RESET;
                DfltDimension.SETRANGE("Table ID",5200);
                DfltDimension.SETRANGE("No.",GlobalRec."No. empleado");
                IF DfltDimension.FINDSET(TRUE,FALSE) THEN
                   REPEAT
                    DfltDimension.DELETE;
                   UNTIL DfltDimension.NEXT = 0;
                */
                CabNomina.Delete();
            end;
        end;

    end;


    procedure CalculaNominaProy(CodEmpleado: Code[20]; CodProy: Code[20]; FechaDesde: Date; FechaHasta: Date) CalcularNom: Boolean
    var
        DCA: Record "Distrib. Control de asis. Proy";
        PerfSal: Record "Perfil Salarial";
        Text001: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Contrato: Record Contratos;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text002: Label 'All pending records have been processed, please check the data on employees';
        HorReg: Decimal;
        Hor35: Decimal;
        Hor100: Decimal;
        HorFer: Decimal;
        HorNoc: Decimal;
        PagarDieta: Boolean;
        PagarTransporte: Boolean;
        DiasTransporte: Decimal;
    begin
        //Buscamos la configuracion

        /*GRN Se va a realizar por el reporte, solo se procesa aqui la Dieta
        //Verificamos que los conceptos esten configurados
        ConfNominas.TESTFIELD("Concepto Horas Ext. 100%");
        ConfNominas.TESTFIELD("Concepto Horas Ext. 35%");
        ConfNominas.TESTFIELD("Concepto Horas nocturnas");
        ConfNominas.TESTFIELD("Concepto Dias feriados");
        ConfNominas.TESTFIELD("Concepto Sal. Base");
        
        //Leemos la tabla de Distribucion control de asistencia y la de distribucion para calcular el pago por concepto
        Hor100 := 0;
        Hor35  := 0;
        HorFer := 0;
        HorNoc := 0;
        HorReg := 0;
        */

        PagarTransporte := Empleado."Incluir pago transporte";
        DiasTransporte := 0;

        Contrato.Reset;
        Contrato.SetRange("No. empleado", CodEmpleado);
        Contrato.SetRange(Activo, true);
        Contrato.SetRange("Frecuencia de pago", Contrato."Frecuencia de pago"::"Bi-Semanal");
        if not Contrato.FindFirst then
            exit(false);

        ConfNominas.Get();
        ConfNominas.TestField("Concepto Dieta");

        PerfilSal.Reset;
        PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Dieta");
        PerfilSal.SetRange("No. empleado", CodEmpleado);
        if not PerfilSal.FindFirst then
            exit(false);

        PerfilSal.Cantidad := 0;
        PerfilSal.Modify;

        DCA.Reset;
        DCA.SetRange("Cod. Empleado", CodEmpleado);
        DCA.SetRange("Fecha registro", FechaDesde, FechaHasta);
        DCA.SetRange("Job No.", CodProy);
        if DCA.FindSet then
            repeat
                //Elimino los valores de la Dieta

                PagarDieta := false;

                //Para distribuir la Dieta. Se hace por día, si pasa de 4.5 horas regulares, o es sabado o es feriado, entonces
                if DCA."Horas feriadas" + DCA."Horas regulares" + DCA."Horas extras al 100" + DCA."Horas extras al 35" + DCA."Horas nocturnas" > 4.5 then
                    PagarDieta := true;

                //ERROR('a %1',PagarDieta);

                if (PagarDieta) and (not Empleado."Calcular dieta por dia") then begin
                    ConfNominas.TestField("Concepto Dieta");
                    PerfilSal.Reset;
                    PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Dieta");
                    PerfilSal.SetRange("No. empleado", DCA."Cod. Empleado");
                    PerfilSal.FindFirst;
                    PerfilSal.Cantidad += 1;
                    //El precio lo tiene el empleado PerfilSal.Importe := ;
                    PerfilSal.Modify;
                end
                else
                    if Empleado."Calcular dieta por dia" then begin
                        ConfNominas.TestField("Concepto Dieta");
                        PerfilSal.Reset;
                        PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Dieta");
                        PerfilSal.SetRange("No. empleado", DCA."Cod. Empleado");
                        PerfilSal.FindFirst;
                        PerfilSal.Cantidad += 1;
                        //El precio lo tiene el empleado PerfilSal.Importe := ;
                        PerfilSal.Modify;
                    end;
                if PagarTransporte then
                    DiasTransporte += 1;
            until DCA.Next = 0
        else
            exit(false);


        if PagarTransporte and (DiasTransporte <> 0) then begin
            ConfNominas.TestField("Concepto Transporte");
            PerfilSal.Reset;
            PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Transporte");
            PerfilSal.SetRange("No. empleado", DCA."Cod. Empleado");
            PerfilSal.FindFirst;
            PerfilSal.Cantidad := DiasTransporte;
            //El precio lo tiene el empleado  ;
            PerfilSal.Modify;

        end;

        exit(true);

    end;
}

