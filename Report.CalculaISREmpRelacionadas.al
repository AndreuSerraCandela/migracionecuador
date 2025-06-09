report 76044 "Calcula ISR Emp. Relacionadas"
{
    Caption = 'Calculate TAX Related Companies';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Historico Cab. nomina"; "Historico Cab. nomina")
        {
            DataItemTableView = SORTING("No. empleado", Ano, "Período", "Tipo Nomina");
            RequestFilterFields = "Tipo Nomina", "Período", "No. empleado";

            trigger OnAfterGetRecord()
            begin
                PrimeraQ := Date2DMY(Período, 1) < 16;
                SegundaQ := Date2DMY(Período, 1) >= 16;
                PerInici := Inicio;
                PerFinal := Fin;
                iMes := Date2DMY(PerInici, 2);
                iAno := Date2DMY(PerInici, 3);

                Empleado.Get("No. empleado");
                Puestos.Get(Empleado."Job Type Code");

                if CodEmpl <> "No. empleado" then begin
                    TotalCompany := 0;
                    "%Cot" := 0;
                    Clear(TotalISR);
                    CodEmpl := "No. empleado";
                end;

                ConfNominas.Get();

                GlobalRec.Reset;
                GlobalRec.SetRange("No. empleado", "No. empleado");
                GlobalRec.FindFirst;

                Contrato.Reset;
                Contrato.SetRange("No. empleado", GlobalRec."No. empleado");
                Contrato.SetRange(Activo, true);
                Contrato.FindFirst;

                EmpresasRel.Reset;
                EmpresasRel.SetRange("Cod. Empleado", GlobalRec."No. empleado");
                if not EmpresasRel.FindFirst then
                    CurrReport.Skip
                else
                    if CompanyName <> EmpresasRel.Empresa then
                        CalcularISR;
            end;

            trigger OnPreDataItem()
            begin
                CodEmpl := '';
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
                group(Control1000000001)
                {
                    ShowCaption = false;
                    field(PerNomina; PerNomina)
                    {
                        ApplicationArea = All;
                        Caption = 'Daily,Weekly,Bi-Weekly,Half Month,Monthly,Yearly';

                    }
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

    trigger OnPostReport()
    begin
        Message(Text001);
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        Empleado: Record Employee;
        GlobalRec: Record "Perfil Salarial";
        Contrato: Record Contratos;
        ConceptosSal: Record "Conceptos salariales";
        PerfilSalImp: Record "Perfil Salarial";
        EmpresasRel: Record "Relacion Empresas Empleados";
        DfltDimension: Record "Default Dimension";
        HistLinNom: Record "Historico Lin. nomina";
        Puestos: Record "Puestos laborales";
        recTmpDimEntry: Record "Dimension Set Entry" temporary;
        cduDim: Codeunit DimensionManagement;
        TotalISR: array[3, 3] of Decimal;
        LinTabla: Decimal;
        "%Cot": Decimal;
        PerInici: Date;
        PerFinal: Date;
        IngresoSalario: Decimal;
        TotalCompany: Decimal;
        PrimeraQ: Boolean;
        SegundaQ: Boolean;
        iAno: Integer;
        iMes: Integer;
        ImporteTotal: Decimal;
        CodEmpl: Code[20];
        DimSetID: Integer;
        PerNomina: Option Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        Text001: Label 'Fin del proceso, favor de verificar los datos históricos';


    procedure CalcularISR()
    var
        "RetenciónISR": Record "Tabla retencion ISR";
        SaldoFavor: Record "Saldos a favor ISR";
        SaldoFavor2: Record "Saldos a favor ISR";
        HistLinNomISR: Record "Historico Lin. nomina";
        BKSaldoFavor: Record "Prestaciones masivas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        EmpresasRel2: Record "Relacion Empresas Empleados";
        LinEsqPercepISR: Record "Perfil Salarial";
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
        Err002: Label 'Employee %1 doesn''t have posted payroll in company %2, please verify';
    begin
        //CalculoISR
        Importe1 := 0;
        Importe2 := 0;
        Importe3 := 0;

        EmpresasRel.Reset;
        EmpresasRel.SetRange("Cod. Empleado", GlobalRec."No. empleado");
        if EmpresasRel.FindFirst then begin
            if CompanyName <> EmpresasRel.Empresa then begin
                EmpresasRel2.Reset;
                EmpresasRel2.SetRange("Cod. Empleado", GlobalRec."No. empleado");
                EmpresasRel2.FindSet;
                repeat
                    HistLinCompany.Reset;
                    HistLinCompany.ChangeCompany(EmpresasRel2.Empresa);
                    HistLinCompany.SetRange("No. empleado", EmpresasRel2."Cod. Empleado en empresa");
                    HistLinCompany.SetRange(Período, "Historico Cab. nomina".Inicio, "Historico Cab. nomina".Fin);
                    HistLinCompany.SetRange("Cotiza ISR", true);
                    HistLinCompany.SetRange("Salario Base", true);
                    if HistLinCompany.FindSet then
                        repeat
                            if Empleado."Employment Date" >= PerInici then
                                TotalCompany += HistLinCompany.Total
                            else
                                TotalCompany += HistLinCompany."Importe Base";
                        until HistLinCompany.Next = 0
                    else
                        Error(Err002, Empleado."Full Name", EmpresasRel2.Empresa);
                until EmpresasRel2.Next = 0;
            end
            else
                exit;
        end;

        //Busqueda de todos los conceptos que cotizan para el calculo del ISR
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", GlobalRec."No. empleado");
        HistLinNom.SetRange("Tipo Nómina", "Historico Cab. nomina"."Tipo Nomina");
        HistLinNom.SetRange(Período, "Historico Cab. nomina".Inicio, "Historico Cab. nomina".Fin);
        HistLinNom.SetRange("Cotiza ISR", true);
        if HistLinNom.Find('-') then
            repeat
                if HistLinNom.Total <> 0 then
                    TotalISR[1] [1] += HistLinNom.Total;
            until HistLinNom.Next = 0;

        ReCalcularTSSDistribuido;

        //TotalCompany += TotalISR[1][1];
        //TotalISR[1][1] := TotalCompany;
        Base := TotalISR[1] [1];

        // Cálculo del ISR. Busqueda de Rangos ISR
        Indice := 1;
        RetenciónISR.SetRange(Ano, Format(iAno, 4, '<Standard Format,0>'));
        RetenciónISR.Find('-');
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

        TotalISR[1] [1] := Importe1;


        ConceptosSal.SetRange(Codigo, ConfNominas."Concepto ISR");
        ConceptosSal.FindFirst;

        Clear(PerfilSalImp);

        PerfilSalImp.SetRange("No. empleado", GlobalRec."No. empleado");
        PerfilSalImp.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
        if not PerfilSalImp.FindFirst then
            exit;

        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
            if ((PerfilSalImp."1ra Quincena" <> PrimeraQ) and PrimeraQ) or ((PerfilSalImp."2da Quincena" <> SegundaQ) and SegundaQ) then
                exit;

        if (Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal) and
           (PerfilSalImp."1ra Quincena") and (PerfilSalImp."2da Quincena") and (PrimeraQ) and
           (Puestos."Metodo calculo Paga Salario" = 0) then
            TotalISR[1] [1] := Round(TotalISR[1] [1] / 2, 0.01)
        else begin
            HistLinNomISR.Reset;
            HistLinNomISR.SetRange("No. empleado", GlobalRec."No. empleado");
            HistLinNomISR.SetRange(Período, DMY2Date(1, Date2DMY(PerInici, 2), Date2DMY(PerInici, 3)), PerFinal);
            HistLinNomISR.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
            if HistLinNomISR.FindSet then
                repeat
                    if HistLinNomISR.Período <> PerInici then
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

        //MESSAGE('a %1 %2 %3 %4',TotalISR[1][1],base,"%Cot");

        //GRN Modifico los importes del Calculo del ISR
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", GlobalRec."No. empleado");
        HistLinNom.SetRange("Tipo Nómina", "Historico Cab. nomina"."Tipo Nomina");
        HistLinNom.SetRange(Período, PerInici, PerFinal);
        HistLinNom.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
        if HistLinNom.FindFirst then begin
            LinEsqPercepISR.Reset;
            LinEsqPercepISR.SetRange("No. empleado", GlobalRec."No. empleado");
            LinEsqPercepISR.SetRange("Concepto salarial", HistLinNom."Concepto salarial");
            LinEsqPercepISR.FindFirst;

            HistLinNom."Importe Base" := Base;
            HistLinNom.Total := TotalISR[1] [1] * -1;
            HistLinNom."% Cotizable" := "%Cot";
            HistLinNom.Modify;
        end;

        if PerfilSalImp."% ISR Pago Empleado" <> 0 then begin
            PerfilSalImp.Importe := Round(TotalISR[1] [1] * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
            ImporteTotal := PerfilSalImp.Importe * -1;

            //Employer
            LinAportesEmpresa.SetRange("No. Documento", "Historico Cab. nomina"."No. Documento");
            LinAportesEmpresa.SetRange("No. Empleado", "Historico Cab. nomina"."No. empleado");
            if LinAportesEmpresa.FindLast then
                NoLinImp := LinAportesEmpresa."No. orden";

            NoLinImp += 10;
            LinAportesEmpresa.Init;
            LinAportesEmpresa."No. Documento" := "Historico Cab. nomina"."No. Documento";
            LinAportesEmpresa."No. orden" := NoLinImp;
            LinAportesEmpresa."Empresa cotización" := "Historico Cab. nomina"."Empresa cotización";
            LinAportesEmpresa.Período := "Historico Cab. nomina".Período;
            LinAportesEmpresa."No. Empleado" := "Historico Cab. nomina"."No. empleado";
            LinAportesEmpresa.Validate("Concepto Salarial", PerfilSalImp."Concepto salarial");
            LinAportesEmpresa."% Cotizable" := Round("%Cot" * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
            LinAportesEmpresa."Base Imponible" := IngresoSalario;
            LinAportesEmpresa.Importe := Round(TotalISR[1] [1] * (100 - PerfilSalImp."% ISR Pago Empleado") / 100, 0.01);
            //    LinAportesEmpresa.INSERT;
            "%Cot" := Round("%Cot" * PerfilSalImp."% ISR Pago Empleado" / 100, 0.01);
        end;

        //Modifico el Saldo ISR a Favor
        SaldoFavor2.CopyFilters(SaldoFavor);
        if SaldoFavor2.Find('-') then begin
            SaldoFavor2.TransferFields(SaldoFavor);
            SaldoFavor2."Importe Pendiente" := SaldoFavor."Importe Pendiente";
            SaldoFavor2.Modify;
        end;
    end;


    procedure InsertaISR(perfSalario: Record "Perfil Salarial")
    var
        LinNomina: Record "Historico Lin. nomina";
    begin
        //GRN Busco Ult. No. de LInea
        HistLinNom.Reset;
        HistLinNom.SetRange("No. empleado", GlobalRec."No. empleado");
        HistLinNom.SetRange("Tipo Nómina", "Historico Cab. nomina"."Tipo Nomina");
        HistLinNom.SetRange(Período, "Historico Cab. nomina".Inicio, "Historico Cab. nomina".Fin);
        if HistLinNom.FindLast then
            LinTabla := HistLinNom."No. Orden" + 100;

        //GRN Modifico los importes del Calculo del ISR

        LinNomina."Empresa cotización" := perfSalario."Empresa cotizacion";
        LinNomina."No. empleado" := perfSalario."No. empleado";
        LinNomina."No. Documento" := "Historico Cab. nomina"."No. Documento";
        LinNomina.Período := PerInici;
        LinNomina."No. Orden" := LinTabla;
        LinNomina.Ano := "Historico Cab. nomina".Ano;
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
        LinNomina."Sujeto Cotización" := perfSalario."Sujeto Cotizacion";
        LinNomina.Fórmula := perfSalario."Formula calculo";
        LinNomina.Imprimir := perfSalario.Imprimir;
        LinNomina."Inicio período" := PerInici;
        LinNomina."Fin período" := PerFinal;
        LinNomina."Tipo Nómina" := perfSalario."Tipo Nomina";
        LinNomina."% Cotizable" := "%Cot";
        LinNomina."% Pago Empleado" := perfSalario."% ISR Pago Empleado";
        LinNomina.Insert;

        ConceptosSal.SetRange(Codigo, perfSalario."Concepto salarial");
        ConceptosSal.FindFirst;

        recTmpDimEntry.DeleteAll;
        InsertarDimTemp(ConceptosSal."Dimension Nomina", perfSalario."Concepto salarial"); //Para el concepto salarial
        InsertarDimTempDef(5200);                                                           //Para las Dim del empleado
        InsertarDimTempDefPS(76061, perfSalario."Concepto salarial");                     //Para las Dim del perfil de salario (linea del concepto salarial)
        LinNomina."Dimension Set ID" := cduDim.GetDimensionSetID(recTmpDimEntry);
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
            recTmpDimEntry.Insert(true);
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
        recDfltDim.SetRange("No.", GlobalRec."No. empleado" + ConceptoSal);
        if recDfltDim.FindSet() then
            repeat
                InsertarDimTemp(recDfltDim."Dimension Code", recDfltDim."Dimension Value Code");
            until recDfltDim.Next = 0;
    end;


    procedure ReCalcularTSSDistribuido()
    var
        LinNominasES: Record "Historico Lin. nomina";
        DeduccGob: Record "Tipos de Cotización";
        CabAportesEmpresa: Record "Cab. Aportes Empresas";
        LinAportesEmpresa: Record "Lin. Aportes Empresas";
        PerfilSalTr: Record "Perfil Salarial";
        PerfilSalTr2: Record "Perfil Salarial";
        LinEsqPercepISR2: Record "Perfil Salarial";
        NoLin: Integer;
        MontoAplicar: Decimal;
        IndSkip: Boolean;
        ImpuestoMes: Decimal;
        SFSMesSal: Decimal;
        AFPMesSal: Decimal;
        SFSMes: Decimal;
        AFPMes: Decimal;
        IngresoMes: Decimal;
        Ano: Integer;
        Importecotizacionmes: Decimal;
    begin
        //Funcion para recalcular la TSS para buscar la base de calculo del ISR  (IDC)
        SFSMes := 0;
        AFPMes := 0;
        SFSMesSal := 0;
        AFPMesSal := 0;

        Ano := Date2DMY("Historico Cab. nomina".Inicio, 3);

        LinEsqPercepISR2.Reset;
        LinEsqPercepISR2.SetRange("No. empleado", GlobalRec."No. empleado");
        LinEsqPercepISR2.SetRange("Concepto salarial", ConfNominas."Concepto ISR");
        if not LinEsqPercepISR2.FindFirst then
            LinEsqPercepISR2.Init;

        //IF (Contrato."Tipo Pago Nomina" = Contrato."Tipo Pago Nomina"::Quincenal) AND (Puestos."Método cálculo Paga Salario" = Puestos."Método cálculo Paga Salario"::Distribuido) AND
        //   (LinEsqPercepISR2."1ra Quincena" AND LinEsqPercepISR2."2da Quincena" AND PrimeraQ) THEN
        begin
            DeduccGob.Reset;
            DeduccGob.SetRange(Ano, Ano);
            DeduccGob.SetFilter("Porciento Empleado", '<>%1', 0);
            if DeduccGob.FindSet() then
                repeat
                    IndSkip := false;
                    Importecotizacionmes := 0;

                    LinNominasES.Reset;
                    LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
                    LinNominasES.SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");
                    LinNominasES.SetRange(Período, PerInici, PerFinal);
                    LinNominasES.SetRange("Sujeto Cotización", true);
                    if ConfNominas."Concepto AFP" = DeduccGob.Código then
                        LinNominasES.SetRange("Cotiza AFP", true)
                    else
                        if ConfNominas."Concepto SFS" = DeduccGob.Código then
                            LinNominasES.SetRange("Cotiza SFS", true);

                    if Empleado."Excluído Cotización TSS" then
                        IndSkip := true;

                    if LinNominasES.FindSet() then
                        repeat
                            if (LinNominasES."Salario Base") and (Empleado."Employment Date" < PerInici) then
                                Importecotizacionmes += LinNominasES."Importe Base"
                            else
                                Importecotizacionmes += LinNominasES.Total
                        until LinNominasES.Next = 0;


                    Importecotizacionmes += TotalCompany;

                    //Employee
                    if LinNominasES."Salario Base" then begin
                        //IDC
                        if ConfNominas."Concepto SFS" = DeduccGob.Código then
                            SFSMesSal := Importecotizacionmes * DeduccGob."Porciento Empleado" / 100
                        else
                            if ConfNominas."Concepto AFP" = DeduccGob.Código then
                                AFPMesSal := Importecotizacionmes * DeduccGob."Porciento Empleado" / 100;
                        //IDC Fin
                    end
                    else begin
                        //IDC
                        if ConfNominas."Concepto SFS" = DeduccGob.Código then
                            SFSMes := Importecotizacionmes * DeduccGob."Porciento Empleado" / 100
                        else
                            if ConfNominas."Concepto AFP" = DeduccGob.Código then
                                AFPMes := Importecotizacionmes * DeduccGob."Porciento Empleado" / 100;
                        //IDC Fin
                    end;
                until DeduccGob.Next = 0;

            //Busco todos los ingresos que
            LinNominasES.Reset;
            LinNominasES.SetRange("No. empleado", GlobalRec."No. empleado");
            LinNominasES.SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");
            LinNominasES.SetRange(Período, PerInici, PerFinal);
            LinNominasES.SetRange("Sujeto Cotización", true);
            LinNominasES.SetRange("Tipo concepto", LinNominasES."Tipo concepto"::Ingresos);
            if LinNominasES.FindSet then
                repeat
                    if LinNominasES."Salario Base" then begin
                        if Empleado."Employment Date" >= PerInici then
                            IngresoMes += LinNominasES.Total
                        else
                            IngresoMes += LinNominasES."Importe Base";
                    end
                    else
                        IngresoMes += LinNominasES.Total;
                until LinNominasES.Next = 0;

            TotalISR[1] [1] := ((AFPMes + SFSMes + AFPMesSal + SFSMesSal) * -1) + IngresoMes + TotalCompany;
        end;

        //MESSAGE('bb %1 %2 %3 %4 %5 %6',AFPMes,SFSMes,AFPMesSal,SFSMesSal,IngresoMes,totalcompany);
    end;
}

