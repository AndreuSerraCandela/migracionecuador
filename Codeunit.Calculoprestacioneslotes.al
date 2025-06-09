codeunit 76002 "Calculo prestaciones lotes"
{

    trigger OnRun()
    begin
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        HLN: Record "Historico Lin. nomina";
        TN: Record "Tipos de nominas";
        Contrato: Record Contratos;
        PrestMasivas: Record "Prestaciones masivas";
        /*     FuncionesNom: Codeunit "Funciones Nomina"; */
        Perfinal: Date;
        Text001: Label 'Payment %1 days of retroactive salary';
        PromedioSalarioAnual: Decimal;
        PromedioSalarioMensual: Decimal;
        PromedioSalarioDiario: Decimal;
        "CDateSymbol-Y": Label 'Y';
        "CDateSymbol-W": Label 'W';


    procedure VerificaRetroactivo(Empl: Record Employee) Retroactivo: Decimal
    var
        PerfilSalario: Record "Perfil Salarial";
        Fecha: Record Date;
        DiasRetroactivo: Decimal;
        FechaInicial: Date;
    begin
        ConfNominas.Get();
        TN.Reset;
        TN.SetRange("Tipo de nomina", TN."Tipo de nomina"::Regular);
        TN.FindFirst;

        Retroactivo := 0;

        Contrato.Reset;
        Contrato.SetRange("No. empleado", Empl."No.");
        Contrato.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
        Contrato.FindLast;

        PrestMasivas.Reset;
        PrestMasivas.SetRange("Cod. Empleado", Empl."No.");
        if PrestMasivas.FindFirst then
            Perfinal := PrestMasivas."Termination Date"
        else
            Perfinal := Today;

        if Contrato."Fecha finalización" <> 0D then
            Perfinal := Contrato."Fecha finalización";

        // IF Empl."Employment Date" < CALCDATE('-1M',Perfinal) THEN
        //   EXIT;
        if Empl."Employment Date" > CalcDate('-' + Format(ConfNominas."Dias para corte nominas"), Perfinal) then
            exit;

        Empl.CalcFields(Salario);

        HLN.Reset;
        HLN.SetRange("No. empleado", Empl."No.");
        HLN.SetRange(Período, Empl."Employment Date");
        HLN.SetRange("Concepto salarial", ConfNominas."Concepto Retroactivo");
        if HLN.FindFirst then
            exit;

        HLN.Reset;
        HLN.SetRange("No. empleado", Empl."No.");
        HLN.SetFilter(Período, '<%1', Empl."Employment Date");
        if not HLN.FindFirst then begin
            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then begin
                FechaInicial := DMY2Date(TN."Dia inicio 1ra", Date2DMY(Perfinal, 2), Date2DMY(Perfinal, 3)); //OJO, REVISAR LA LOGICA
                DiasRetroactivo := Perfinal - FechaInicial;
            end
            else
                if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                    FechaInicial := DMY2Date(TN."Dia inicio 1ra", Date2DMY(Perfinal, 2), Date2DMY(Perfinal, 3)); //OJO, REVISAR LA LOGICA
                    DiasRetroactivo := Perfinal - FechaInicial;
                end;

            Fecha.Reset;
            Fecha.SetRange("Period Type", 0); //Dia
            Fecha.SetRange("Period Start", FechaInicial, Perfinal); //Verificar la fecha que debe tomar
            Fecha.SetRange("Period No.", 6, 7);//Sabado y Domingo
            if Fecha.FindSet then
                repeat
                    case Fecha."Period No." of
                        6:
                            DiasRetroactivo -= 0.5;
                        7:
                            DiasRetroactivo -= 1;
                    end;
                until Fecha.Next = 0;

            PerfilSalario.Reset;
            PerfilSalario.SetRange("No. empleado", Empl."No.");
            PerfilSalario.SetRange("Concepto salarial", ConfNominas."Concepto Retroactivo");
            PerfilSalario.FindFirst;
            if Empl."Tipo pago" = Empl."Tipo pago"::"Sueldo fijo" then
                PerfilSalario.Importe := Empl.Salario / 23.83;

            PerfilSalario.Validate(Cantidad, DiasRetroactivo);
            PerfilSalario.Comentario := StrSubstNo(Text001, Format(DiasRetroactivo));
            Retroactivo := PerfilSalario.Cantidad * PerfilSalario.Importe;
        end;
    end;


    procedure CalculoPreaviso(Empl: Record Employee; var DiasPreaviso: Integer; FechaFin: Date) MontoPreaviso: Decimal //Pendiente Nomina
    var
        FechaCalculo: Date;
        CantidadAnos: Integer;
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
    begin
        ConfNominas.Get();

        Contrato.Reset;
        Contrato.SetRange("No. empleado", Empl."No.");
        Contrato.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
        Contrato.FindLast;
        if FechaFin = 0D then
            Perfinal := Today
        else
            Perfinal := FechaFin;
        if Contrato."Fecha finalización" <> 0D then
            Perfinal := Contrato."Fecha finalización";

        DiasPreaviso := 0;
        /*  FuncionesNom.CalculoEntreFechas(Empl."Employment Date", Perfinal, Anos, Meses, Dias); */
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

        BuscaSalarioPromedio(Empl."No.");
        MontoPreaviso := PromedioSalarioDiario * DiasPreaviso;
    end;


    procedure CalculoCesantia(Empl: Record Employee; var DiasCesantia: Integer; FechaFin: Date) MontoCesantia: Decimal
    var
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        SalidaCesantia: Decimal;
    begin
        ConfNominas.Get();

        DiasCesantia := 0;

        Contrato.Reset;
        Contrato.SetRange("No. empleado", Empl."No.");
        Contrato.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
        Contrato.FindLast;

        if FechaFin = 0D then
            Perfinal := Today
        else
            Perfinal := FechaFin;
        if Contrato."Fecha finalización" <> 0D then
            Perfinal := Contrato."Fecha finalización";

        /* FuncionesNom.CalculoEntreFechas(Empl."Employment Date", Perfinal, Anos, Meses, Dias); */

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
                    if Empl."Employment Date" < DMY2Date(29, 5, 92) then
                        DiasCesantia := 15 * Anos
                    else
                        DiasCesantia := 23 * Anos;

                    if (Meses >= 3) and (Meses <= 6) then
                        DiasCesantia += 6
                    else
                        if Meses >= 7 then
                            DiasCesantia += 13;
                end;

        BuscaSalarioPromedio(Empl."No.");
        MontoCesantia := PromedioSalarioDiario * DiasCesantia;
    end;


    procedure CalculoVacaciones(Empl: Record Employee) MontoVacaciones: Decimal
    var
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        DiasVacaciones: Integer;
    begin
        //Vacaciones
        /*
        DiasVacaciones := 0;
        
        funcionesnom.CálculoEntreFechas(Empl."Employment Date", Empl."Termination Date",Anos, Meses, Dias);
        DiasVacaciones := funcionesnom.CalculoDiaVacaciones(Empl."No.",MesTrabajo,AnoTrabajo,MontoVacaciones,Empl."Employment Date",PerFinal);
        
        PromedioSalarioDiarioVac := "Perfil Salarial".Importe / 23.83;
        MontoVacaciones          := PromedioSalarioDiarioVac * DiasVacaciones;
        */

    end;


    procedure CalculoRegaliaPrest(Empl: Record Employee) MontoRegalia: Decimal
    var
        TipoNomina: Record "Tipos de nominas";
        LinNomina: Record "Historico Lin. nomina";
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        PerIni: Date;
        Perfinal: Date;
        AcumuladoRegalia: Decimal;
    begin
        //Regalia
        ConfNominas.Get();
        AcumuladoRegalia := 0;
        TipoNomina.Reset;
        TipoNomina.SetRange("Tipo de nomina", TipoNomina."Tipo de nomina"::Regular);
        TipoNomina.SetRange("Frecuencia de pago", Contrato."Frecuencia de pago");
        TipoNomina.FindFirst;

        Contrato.Reset;
        Contrato.SetRange("No. empleado", Empl."No.");
        Contrato.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
        Contrato.FindLast;
        PerIni := Today;
        Perfinal := Today;
        if Contrato."Fecha finalización" <> 0D then
            Perfinal := Contrato."Fecha finalización";

        LinNomina.Reset;
        LinNomina.SetRange("No. empleado", Empl."No.");
        /*
        IF (TipoNomina."Dia inicio 1ra" > TipoNomina."Dia inicio 2da") THEN
           LinNomina.SETRANGE(Período,DMY2DATE(TipoNomina."Dia inicio 1ra",12,DATE2DMY(CALCDATE('-12M',PerInici),3)),PerFinal)
        ELSE
        */
        LinNomina.SetRange(Período, DMY2Date(1, 1, Date2DMY(PerIni, 3)), Perfinal);
        LinNomina.SetRange("Aplica para Regalia", true);
        if LinNomina.FindSet then
            repeat
                AcumuladoRegalia += LinNomina.Total;
            until LinNomina.Next = 0;

        MontoRegalia := AcumuladoRegalia / 12;

    end;


    procedure CalcularDescuentosPrest(Empl: Record Employee) ImporteTotal: Decimal
    var
        PerfilSalRet: Record "Perfil Salarial";
    begin
        /*
        PerfilSalRet.RESET;
        PerfilSalRet.SETRANGE("No. empleado",Empl."No.");
        PerfilSalRet.SETRANGE("Tipo concepto",PerfilSalRet."Tipo concepto"::Deducciones);
        PerfilSalRet.SETFILTER(Cantidad,'<>%1',0);
        PerfilSalRet.SETFILTER(Importe,'<>%1',0);
        IF PerfilSalRet.FINDSET THEN
           REPEAT
            ImporteTotal := PerfilSalRet.Cantidad * PerfilSalRet.Importe *-1;
            Descuentos += PerfilSalRet.Importe;
           UNTIL PerfilSalRet.NEXT = 0;
        */

    end;


    procedure BuscaSalarioPromedio(CodEmpl: Code[20])
    var
        Empl: Record Employee;
        PerfilSal: Record "Perfil Salarial";
        LinNomina: Record "Historico Lin. nomina";
        Periodo: array[12] of Decimal;
        Salarios: array[12] of Decimal;
        TotalTiempoTrabajado: Decimal;
        TotalPeriodo: Decimal;
        M: Integer;
        N: Integer;
        UltimoSalario: Decimal;
        ImporteSueldoAcumulado: Decimal;
        FechaFinal: Date;
    begin
        //Salario Promedio
        Empl.Get(CodEmpl);

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", Empl."No.");
        PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Ingresos);
        PerfilSal.SetRange("Concepto salarial", ConfNominas."Concepto Sal. Base");
        if PerfilSal.FindFirst then
            UltimoSalario := PerfilSal.Importe;

        PerfilSal.Reset;
        PerfilSal.SetRange("No. empleado", Empl."No.");
        PerfilSal.SetRange("Tipo concepto", PerfilSal."Tipo concepto"::Ingresos);
        PerfilSal.SetFilter("Concepto salarial", '<>%1', ConfNominas."Concepto Sal. Base");
        PerfilSal.SetRange("Salario Base", true);
        if PerfilSal.FindSet then
            repeat
                UltimoSalario += PerfilSal.Importe;
            until PerfilSal.Next = 0;
        Clear(Periodo);
        Clear(Salarios);
        M := 0;
        N := 0;
        PromedioSalarioAnual := 0;
        PromedioSalarioMensual := UltimoSalario;
        PromedioSalarioDiario := 0;
        TotalPeriodo := 0;
        FechaFinal := Perfinal;
        if Perfinal > Today then begin
            PromedioSalarioDiario := UltimoSalario / 23.83;
            exit;
        end;

        LinNomina.Reset;
        LinNomina.SetRange("No. empleado", Empl."No.");
        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then
            LinNomina.SetRange(Período, CalcDate('-12M', DMY2Date(1, Date2DMY(FechaFinal, 2), Date2DMY(FechaFinal, 3))),
                                     Perfinal)
        else
            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                LinNomina.SetRange(Período, CalcDate('-51' + "CDateSymbol-W", DMY2Date(1, Date2DMY(FechaFinal, 2), Date2DMY(Perfinal, 3))),
                                         FechaFinal);

        LinNomina.SetRange("Salario Base", true);
        if LinNomina.FindSet then
            repeat
                PromedioSalarioAnual += LinNomina.Total;
                ImporteSueldoAcumulado += LinNomina.Total;
            until LinNomina.Next = 0;

        if ImporteSueldoAcumulado <> 0 then begin
            PromedioSalarioAnual := ImporteSueldoAcumulado;
            PromedioSalarioMensual := ImporteSueldoAcumulado / 12;
            //PromedioSalarioDRegalia  := ImporteSueldoAcumulado / 12;
            PromedioSalarioDiario := PromedioSalarioMensual / 23.83;
        end
        else begin
            PromedioSalarioAnual := UltimoSalario;
            PromedioSalarioMensual := UltimoSalario;
            //PromedioSalarioDRegalia  := UltimoSalario / 12;
            PromedioSalarioDiario := PromedioSalarioMensual / 23.83;
            PromedioSalarioAnual := ImporteSueldoAcumulado;
        end;
    end;
}

