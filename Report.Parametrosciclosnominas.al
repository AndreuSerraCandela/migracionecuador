report 76053 "Parametros ciclos nominas"
{
    Caption = 'Payroll cicle parameters';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                ValidaFecha;
            end;

            trigger OnPreDataItem()
            begin
                ConfNomina.Get();

                Ventana.Open(
                  Text001 +
                  '   @1@@@@@@@@@@@@@    \');
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
                field("Tipo cálculo"; FrecuenciaPago)
                {
                    Caption = ' Payment frequency';
                    ApplicationArea = All;
                }
                field(Inicio; Inicio)
                {
                    Caption = 'Starting';
                    ApplicationArea = All;
                }
                field(Cantidad; Cantidad)
                {
                    Caption = 'Quantity';
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

    trigger OnPreReport()
    begin

        /*
        CASE FrecuenciaPago OF
          FrecuenciaPago::Diaria : BEGIN
            IF IntroLinPerfSal."Inicio Período" = 0D THEN
              ERROR(Err002);
          END;
          FrecuenciaPago::Semanal : BEGIN
            IF Semana = 0 THEN
              ERROR(Err003);
            Calendar.SETRANGE(Semana,Semana);
            Calendar.SETRANGE("ANo.",DATE2DMY(WORKDATE,3));
            Calendar.FIND('-');
            IntroLinPerfSal."Mes Inicio" := Calendar.Fecha;
            Calendar.FIND('+');
            IntroLinPerfSal."Mes Fin" := Calendar.Fecha;
          END;
          FrecuenciaPago::Mensual : BEGIN
            IF IntroLinPerfSal.Mes = 0 THEN
              ERROR(Err004);
            Calendar.SETRANGE(Período,IntroLinPerfSal.Mes);
            Calendar.SETRANGE("ANo.",DATE2DMY(WORKDATE,3));
            Calendar.FIND('-');
            IntroLinPerfSal."Mes Inicio" := Calendar.Fecha;
            Calendar.FIND('+');
            IntroLinPerfSal."Mes Fin" := Calendar.Fecha;
          END;
        END;
        */

    end;

    var
        ConfNomina: Record "Configuracion nominas";
        PCN: Record "Parametros ciclos nominas";
        Calendar: Record Calendario;
        Fecha: Record Date;
        Ventana: Dialog;
        FrecuenciaPago: Option Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        Inicio: Date;
        Text001: Label 'Creating';
        Err001: Label 'Starting date must be 1 or 16';
        Err002: Label 'Debe indicar fecha inicial';
        Cantidad: Integer;
        Incremento: Integer;

    local procedure ValidaFecha()
    var
        Fecha2: Record Date;
        PrimeraVez: Boolean;
        Cont: Integer;
        Seleccionar: Boolean;
    begin
        Fecha.Reset;

        case FrecuenciaPago of
            FrecuenciaPago::Anual:
                begin
                    Fecha.SetRange("Period Start", Inicio);
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
                end;
            FrecuenciaPago::"Bi-Semanal":
                begin
                    Fecha.SetRange("Period Start", Inicio, CalcDate('+' + Format(Cantidad * 2) + 'S', Inicio));
                    //Fecha.SETRANGE(Fecha."Period No.",cantidad);
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Week);
                end;
            FrecuenciaPago::Semanal:
                begin
                    Fecha.SetRange("Period Start", Inicio);
                    //Fecha.SETRANGE(Fecha."Period No.",Semana);
                    Fecha.SetRange("Period Type", Fecha."Period Type"::Week);
                end;
            FrecuenciaPago::Quincenal:
                begin
                    if (Date2DMY(Inicio, 1) <> 1) and (Date2DMY(Inicio, 1) <> 16) then
                        Error(Err001);
                end;
        end;

        PrimeraVez := true;
        Seleccionar := true;
        Cont := 0;
        Fecha.FindSet;
        //MESSAGE('%1',Fecha.GETFILTERS);
        repeat
            if PrimeraVez then begin
                PrimeraVez := false;
                PCN.Reset;
                PCN.SetRange("Frecuencia de pago", FrecuenciaPago);
                if PCN.FindSet then
                    PCN.DeleteAll;
            end;

            if Seleccionar then begin
                Seleccionar := false;
                Cont += 1;
                if Cont <= Cantidad then begin
                    PCN.Reset;
                    PCN."No. ciclo" := Cont;
                    PCN."Frecuencia de pago" := FrecuenciaPago;
                    PCN."Fecha de inicio" := Fecha."Period Start";
                    PCN."Fecha fin" := CalcDate('+1S', NormalDate(Fecha."Period End"));
                    PCN.Insert();
                end;
            end
            else
                Seleccionar := true;
        until Fecha.Next = 0;
    end;
}

