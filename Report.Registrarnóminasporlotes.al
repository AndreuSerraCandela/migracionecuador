report 76032 "Registrar nóminas por lotes"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Tipo Empleado";

            trigger OnAfterGetRecord()
            begin
                PerfilSalarios."Empresa cotizacion" := Company;
                PerfilSalarios."No. empleado" := "No.";
                PerfilSalarios."Mes Fin" := IntroLinPerfSal."Mes Fin";
                PerfilSalarios."Inicio Periodo" := IntroLinPerfSal."Inicio Periodo";
                PerfilSalarios."Fin Período" := IntroLinPerfSal."Fin Período";
                PerfilSalarios."Tipo de nomina" := TipoNom;
                //PerfilSalarios."Perfil salarial"    := "Perfil Salarios";
                if ("Employment Date" > IntroLinPerfSal."Fin Período") then
                    CurrReport.Skip;

                Contrato.SetRange("No. empleado", "No.");
                Contrato.SetRange("Cód. contrato", Employee."Emplymt. Contract Code");
                if TiposNom."Tipo de nomina" <> TiposNom."Tipo de nomina"::Prestaciones then
                    Contrato.SetRange(Activo, true)
                else
                    Contrato.SetRange(Activo, false);
                Contrato.FindFirst;
                if (Contrato."Frecuencia de pago" <> TipoCalculo) and
                   (TiposNom."Tipo de nomina" = TiposNom."Tipo de nomina"::Regular) then
                    CurrReport.Skip;

                ConfNomina.TestField("Codeunit calculo nomina");
                CODEUNIT.Run(ConfNomina."Codeunit calculo nomina", PerfilSalarios);


                Calculadas += 1;
                Ventana.Update(1, Round(Calculadas / ACalcular, 1));
            end;

            trigger OnPreDataItem()
            begin
                ConfNomina.Get();
                if not Confirm(Text002) then
                    CurrReport.Break;

                Ventana.Open(
                  Text001 +
                  '   @1@@@@@@@@@@@@@    \');

                TiposNom.Get(TipoNom);
                if TiposNom."Tipo de nomina" <> TiposNom."Tipo de nomina"::Prestaciones then
                    SetRange("Calcular Nomina", true)
                else
                    SetRange("Calcular Nomina", false);
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
                field(TipoNom; TipoNom)
                {
                ApplicationArea = All;
                    Caption = 'Payroll type';
                    TableRelation = "Tipos de nominas";

                    trigger OnValidate()
                    begin
                        if TiposNom.Get(TipoNom) then begin
                            TipoCalculo := TiposNom."Frecuencia de pago";
                            ActualizarControles;
                            if ((TipoCalculo = TipoCalculo::Semanal) or (TipoCalculo = TipoCalculo::"Bi-Semanal")) and (Semana <> 0) then
                                ValidaFecha;
                        end;
                    end;
                }
                field("Tipo cálculo"; TipoCalculo)
                {
                ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ActualizarControles;
                        if ((TipoCalculo = TipoCalculo::Semanal) or (TipoCalculo = TipoCalculo::"Bi-Semanal")) and (Semana <> 0) then
                            ValidaFecha;
                    end;
                }
                group(Semanal)
                {
                    Visible = blnSemanalVisible;
                    field(Semana; Semana)
                    {
                    ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            ValidaFecha;
                        end;
                    }
                    field(Inicio; IntroLinPerfSal."Inicio Periodo")
                    {
                    ApplicationArea = All;
                        Caption = 'Start:';
                        Editable = false;

                        trigger OnValidate()
                        begin
                            idia := Date2DMY(IntroLinPerfSal."Inicio Periodo", 1);
                            if TipoCalculo = TipoCalculo::Quincenal then begin
                                //    IF (dia <> 1) AND (dia <> 16) THEN
                                //       ERROR(Err001);
                                imes := Date2DMY(IntroLinPerfSal."Inicio Periodo", 2);
                                iaño := Date2DMY(IntroLinPerfSal."Inicio Periodo", 3);
                                if idia = 1 then
                                    IntroLinPerfSal."Fin Período" := DMY2Date(15, imes, iaño)
                                else begin
                                    Fecha.Reset;
                                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                                    Fecha.SetRange("Period Start", DMY2Date(1, imes, iaño));
                                    if Fecha.FindFirst then
                                        IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                                end;
                            end
                            else begin
                                Inicio := DMY2Date(1, imes, iaño);
                                Fecha.Reset;
                                Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                                Fecha.SetRange("Period Start", Inicio);
                                if Fecha.FindFirst then
                                    IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                            end;
                        end;
                    }
                    field(Fin; IntroLinPerfSal."Fin Período")
                    {
                    ApplicationArea = All;
                        Caption = 'End:';
                        Editable = false;
                    }
                }
                group(BiSemanal)
                {
                    Visible = blnbiSemanalVisible;
                    field(boInicio; IntroLinPerfSal."Inicio Periodo")
                    {
                    ApplicationArea = All;
                        Caption = 'Start:';
                        Editable = false;

                        trigger OnValidate()
                        begin
                            idia := Date2DMY(IntroLinPerfSal."Inicio Periodo", 1);
                            if TipoCalculo = TipoCalculo::Quincenal then begin
                                if (idia <> TiposNom."Dia inicio 1ra") and (idia <> TiposNom."Dia inicio 2da") then
                                    Error(StrSubstNo(Err001, TiposNom."Dia inicio 1ra", TiposNom."Dia inicio 2da"));

                                imes := Date2DMY(IntroLinPerfSal."Inicio Periodo", 2);
                                iaño := Date2DMY(IntroLinPerfSal."Inicio Periodo", 3);
                                if idia = 1 then
                                    IntroLinPerfSal."Fin Período" := DMY2Date(15, imes, iaño)
                                else begin
                                    Fecha.Reset;
                                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                                    Fecha.SetRange("Period Start", DMY2Date(1, imes, iaño));
                                    if Fecha.FindFirst then
                                        IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                                end;
                            end
                            else begin
                                Inicio := DMY2Date(1, imes, iaño);
                                Fecha.Reset;
                                Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                                Fecha.SetRange("Period Start", Inicio);
                                if Fecha.FindFirst then
                                    IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                            end;
                        end;
                    }
                    field(biFin; IntroLinPerfSal."Fin Período")
                    {
                    ApplicationArea = All;
                        Caption = 'End:';
                        Editable = false;
                    }
                }
                group(Mensual)
                {
                    Visible = blnMensualVisible;
                    field(Mes; IntroLinPerfSal.Mes)
                    {
                    ApplicationArea = All;
                        MaxValue = 12;
                        MinValue = 1;

                        trigger OnValidate()
                        begin
                            ValidaFecha;
                        end;
                    }
                    field("Año"; iaño)
                    {
                    ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if IntroLinPerfSal.Mes = 0 then
                                Error(Err004);

                            idia := 1;
                            Inicio := DMY2Date(1, IntroLinPerfSal.Mes, iaño);
                            IntroLinPerfSal."Inicio Periodo" := DMY2Date(1, IntroLinPerfSal.Mes, iaño);
                            Fecha.Reset;
                            Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                            Fecha.SetRange("Period Start", Inicio);
                            if Fecha.FindFirst then
                                IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                        end;
                    }
                    field(InicioMes; IntroLinPerfSal."Inicio Periodo")
                    {
                    ApplicationArea = All;
                        Caption = 'Start:';
                        Editable = false;

                        trigger OnValidate()
                        begin
                            idia := Date2DMY(IntroLinPerfSal."Inicio Periodo", TiposNom."Dia inicio 1ra");
                            if TipoCalculo = TipoCalculo::Quincenal then begin
                                if (idia <> TiposNom."Dia inicio 1ra") and (idia <> TiposNom."Dia inicio 2da") then
                                    Error(StrSubstNo(Err001, TiposNom."Dia inicio 1ra", TiposNom."Dia inicio 2da"));

                                imes := Date2DMY(IntroLinPerfSal."Inicio Periodo", 2);
                                iaño := Date2DMY(IntroLinPerfSal."Inicio Periodo", 3);
                                if idia = TiposNom."Dia inicio 1ra" then
                                    IntroLinPerfSal."Fin Período" := DMY2Date(15, imes, iaño)
                                else begin
                                    Fecha.Reset;
                                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                                    Fecha.SetRange("Period Start", DMY2Date(1, imes, iaño));
                                    if Fecha.FindFirst then
                                        IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                                end;
                            end
                            else begin
                                Inicio := DMY2Date(TiposNom."Dia inicio 1ra", imes, iaño);
                                /* Fecha.RESET;
                                 Fecha.SETRANGE("Period Type",Fecha."Period Type"::Month);
                                 Fecha.SETRANGE("Period Start",Inicio);
                                 IF Fecha.FINDFIRST THEN
                                    IntroLinPerfSal."Fin Período":= NORMALDATE(Fecha."Period End");
                                */
                                IntroLinPerfSal."Fin Período" := CalcDate('+1M', NormalDate(Fecha."Period End"));
                            end;

                        end;
                    }
                    field(FinMes; IntroLinPerfSal."Fin Período")
                    {
                    ApplicationArea = All;
                        Caption = 'End:';
                        Editable = false;
                    }
                }
                group(Quincenal)
                {
                    Visible = blnQuincenalVisible;
                    field(qInicio; IntroLinPerfSal."Inicio Periodo")
                    {
                    ApplicationArea = All;
                        Caption = 'Start:';

                        trigger OnValidate()
                        begin
                            ValidaFecha;
                        end;
                    }
                    field(qFin; IntroLinPerfSal."Fin Período")
                    {
                    ApplicationArea = All;
                        Caption = 'End:';
                        Editable = false;
                    }
                }
                group(Diaria)
                {
                    Visible = blnDiariolVisible;
                    field(dInicio; IntroLinPerfSal."Inicio Periodo")
                    {
                    ApplicationArea = All;
                        Caption = 'Start:';

                        trigger OnValidate()
                        begin
                            ValidaFecha;
                        end;
                    }
                }
                group(Anual)
                {
                    Visible = blnAnualVisible;
                    field("Año2"; iaño)
                    {
                    ApplicationArea = All;
                        Caption = 'Year';

                        trigger OnValidate()
                        begin
                            if IntroLinPerfSal.Mes = 0 then
                                Error(Err004);

                            Inicio := DMY2Date(1, Date2DMY(Today, 2), iaño);
                            Fecha.Reset;
                            Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                            Fecha.SetRange("Period Start", Inicio);
                            if Fecha.FindFirst then
                                IntroLinPerfSal."Inicio Periodo" := NormalDate(Fecha."Period Start");
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if iaño = 0 then
                iaño := Date2DMY(Today, 3);

            ActualizarControles;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ContarEmpleados.CopyFilters(Employee);
        ACalcular := ContarEmpleados.Count;
        ACalcular := ACalcular / 10000;
        Calculadas := 0;
    end;

    var
        ConfNomina: Record "Configuracion nominas";
        Calendar: Record Calendario;
        ContarEmpleados: Record Employee;
        IntroLinPerfSal: Record "Perfil Salarial";
        PerfilSalarios: Record "Perfil Salarial";
        Contrato: Record Contratos;
        TiposNom: Record "Tipos de nominas";
        CalculoNomina: Codeunit "Registrar nomina";
        Fecha: Record Date;
        Ventana: Dialog;
        ACalcular: Decimal;
        Calculadas: Decimal;
        TipoCalculo: Option Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        Semana: Integer;
        idia: Integer;
        imes: Integer;
        "iaño": Integer;
        Inicio: Date;
        "Tipo Nomina": Option Normal,"Regalía","Bonificación",Propina,Renta;
        Text001: Label 'Processing payroll ... \\';
        Text002: Label 'Do you confirm you want to post the payroll?';
        Text003: Label 'You must select %1 for employee %2';
        Err001: Label 'Starting date must be %1 or %2';
        Err002: Label 'Debe indicar fecha inicial';
        Err003: Label 'Debe indicar semana a calcular';
        Err004: Label 'Debe indicar mes a calcular';
        Err005: Label 'Debe indicar año a calcular';
        Err006: Label 'No puede indicar al mismo tiempo mes y semana';

        blnSemanalVisible: Boolean;

        blnBiSemanalVisible: Boolean;

        blnMensualVisible: Boolean;

        blnQuincenalVisible: Boolean;

        blnAnualVisible: Boolean;

        blnDiariolVisible: Boolean;
        TipoNom: Code[20];


    procedure ActualizarControles()
    begin
        blnSemanalVisible := false;
        blnMensualVisible := false;
        blnQuincenalVisible := false;
        blnDiariolVisible := false;
        blnAnualVisible := false;

        case TipoCalculo of
            TipoCalculo::Semanal:
                blnSemanalVisible := true;
            TipoCalculo::Mensual:
                blnMensualVisible := true;
            TipoCalculo::Quincenal:
                blnQuincenalVisible := true;
            TipoCalculo::Diaria:
                blnDiariolVisible := true;
            TipoCalculo::Anual:
                blnAnualVisible := true;
        end;
    end;

    local procedure ValidaFecha()
    var
        PCB: Record "Parametros ciclos nominas";
    begin
        TiposNom.Get(TipoNom);

        if TipoCalculo <> TipoCalculo::Mensual then
            idia := Date2DMY(IntroLinPerfSal."Inicio Periodo", 1)
        else
            idia := 1;

        Fecha.Reset;

        case TipoCalculo of
            TipoCalculo::Anual:
                begin
                    Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(WorkDate, 2), iaño));
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                end;
            /*
              TipoCalculo::"Bi-Semanal":
               BEGIN
                PCB.RESET;
                PCB.SETRANGE("Frecuencia de pago",TipoCalculo);
                PCB.SETRANGE("No. ciclo",BiSemana);
                PCB.FINDFIRST;

               END;
            */
            TipoCalculo::Diaria:
                begin
                    Fecha.SetRange("Period Start", IntroLinPerfSal."Inicio Periodo");
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
                end;
            TipoCalculo::Semanal:
                begin
                    Fecha.SetRange("Period Start", DMY2Date(1, 1, Date2DMY(WorkDate, 3)), DMY2Date(31, 12, Date2DMY(WorkDate, 3)));
                    Fecha.SetRange(Fecha."Period No.", Semana);
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Week);
                end;
            TipoCalculo::Quincenal:
                begin
                    imes := Date2DMY(IntroLinPerfSal."Inicio Periodo", 2);
                    iaño := Date2DMY(IntroLinPerfSal."Inicio Periodo", 3);
                    idia := Date2DMY(IntroLinPerfSal."Inicio Periodo", 1);
                    if TiposNom."Dia inicio 1ra" > TiposNom."Dia inicio 2da" then
                        IntroLinPerfSal."Fin Período" := CalcDate('-1D', DMY2Date(TiposNom."Dia inicio 2da", Date2DMY(CalcDate('+15D', IntroLinPerfSal."Inicio Periodo"), 2), Date2DMY(CalcDate('+15D', IntroLinPerfSal."Inicio Periodo"), 3)))
                    else begin
                        Fecha.Reset;
                        Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(IntroLinPerfSal."Inicio Periodo", 2), Date2DMY(IntroLinPerfSal."Inicio Periodo", 3)));
                        Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                        Fecha.FindFirst;
                        if idia = 1 then
                            IntroLinPerfSal."Fin Período" := DMY2Date(15, imes, iaño)
                        else begin
                            Fecha.Reset;
                            Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                            Fecha.SetRange("Period Start", DMY2Date(1, imes, iaño));
                            if Fecha.FindFirst then
                                IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                        end;
                    end;
                end;
            TipoCalculo::Mensual:
                begin
                    imes := IntroLinPerfSal.Mes;
                    Fecha.SetRange("Period Start", DMY2Date(1, imes, iaño));
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                    Fecha.FindFirst;
                    IntroLinPerfSal."Inicio Periodo" := Fecha."Period Start";
                    IntroLinPerfSal."Fin Período" := Fecha."Period End";
                end
            else begin
                imes := Date2DMY(Today, 2);

                Inicio := DMY2Date(1, imes, iaño);
                Fecha.Reset;
                Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                Fecha.SetRange("Period Start", Inicio);
            end;
        end;


        Fecha.FindFirst;

        if (TipoCalculo = TipoCalculo::Mensual) or (TipoCalculo = TipoCalculo::Anual) then begin
            IntroLinPerfSal."Inicio Periodo" := NormalDate(Fecha."Period Start");
            IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
        end
        else
            if TipoCalculo = TipoCalculo::Semanal then begin
                IntroLinPerfSal."Inicio Periodo" := NormalDate(Fecha."Period Start");
                Fecha.FindLast;
                IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
            end
            else
                if TipoCalculo = TipoCalculo::Diaria then begin
                    IntroLinPerfSal."Inicio Periodo" := NormalDate(Fecha."Period Start");
                    IntroLinPerfSal."Fin Período" := NormalDate(Fecha."Period End");
                end;

        /*
      ELSE
      IF TipoCalculo = TipoCalculo::"Bi-Semanal" THEN
         BEGIN
          IntroLinPerfSal."Inicio Período":= PCB."Fecha de inicio";
          IntroLinPerfSal."Fin Período" := PCB."Fecha fin";
        END;
        */

    end;
}

