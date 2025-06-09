report 76040 "Listado de vacaciones personal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Listadodevacacionespersonal.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            CalcFields = Salario, "Dias Vacaciones";
            DataItemTableView = WHERE("Fecha salida empresa" = FILTER(0D), "Calcular Nomina" = CONST(true));
            RequestFilterFields = "No.", "Calcular Nomina", "Global Dimension 1 Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(TIME; Time)
            {
            }
            column(GETFILTERS; GetFilters)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee__Full_Name_; "Full Name")
            {
            }
            column(Employee__Employment_Date_; "Employment Date")
            {
            }
            column(Employee_Departamento; Departamento)
            {
            }
            column(Dias_Vacaciones; DiasVacaciones)
            {
            }
            column(Monto_Vacaciones; MontoVacaciones)
            {
            }
            column(Saldo_Vac; "Dias Vacaciones")
            {
            }
            column(Employee_Salario; SalProm)
            {
            }
            column(Remanente_Vacaciones; Remanente)
            {
            }
            column(CantEmpl; CantEmpl)
            {
            }
            column(Employee_Vacaciones_ReportCaption; Employee_Vacaciones_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Employee__Full_Name_Caption; FieldCaption("Full Name"))
            {
            }
            column(Employee__Employment_Date_Caption; FieldCaption("Employment Date"))
            {
            }
            column(Employee_DepartamentoCaption; Employee_DepartamentoCaptionLbl)
            {
            }
            column(Dias_VacacionesCaption; Dias_VacacionesCaption)
            {
            }
            column(Monto_VacacionesCaption; MontoVacacionesCaptionLbl)
            {
            }
            column(Employee_SalarioCaption; FieldCaption(Salario))
            {
            }
            column(Remanente_Vacaciones_Caption; Remanente_Vacaciones_Caption)
            {
            }
            column(Total_de_empleadosCaption; Total_de_empleadosCaptionLbl)
            {
            }
            column(SaldoVac_Lbl; SaldoVac_Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Employment Date" = 0D then
                    CurrReport.Skip;

                if Mes <> Mes::"Año completo" then
                    MesTrabajo := Mes + 1
                else begin
                    MesTrabajo := 12;
                    Fecha.Reset;
                    Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
                    Fecha.SetRange(Fecha."Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
                    if Fecha.FindFirst then
                        FechaFin := NormalDate(Fecha."Period End");
                end;

                if Date2DMY("Employment Date", 3) > Date2DMY(FechaFin, 3) then
                    CurrReport.Skip;

                //Busco los datos del contrato
                Contrato.Reset;
                Contrato.SetRange("No. empleado", "No.");
                Contrato.SetRange("Cód. contrato", "Emplymt. Contract Code");
                Contrato.SetRange(Activo, true);
                if not Contrato.FindFirst then
                    CurrReport.Skip;

                if "Employment Date" = 0D then
                    Error(Err001, FieldCaption("Employment Date"), TableCaption, "No.");

                if Mes <> Mes::"Año completo" then begin
                    if Date2DMY("Employment Date", 2) <> MesTrabajo then
                        CurrReport.Skip;

                    Fecha.Reset;
                    Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
                    Fecha.SetRange(Fecha."Period Start", DMY2Date(1, 12, AnoTrabajo));
                    if Fecha.FindFirst then
                        FechaFin := NormalDate(Fecha."Period End");
                end;

                /*
                IF Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal THEN
                   BEGIN
                    IF Primera AND (NOT Segunda) AND (DATE2DMY("Employment Date",1) > 15) THEN
                       CurrReport.SKIP
                    ELSE
                    IF (NOT Primera) AND Segunda AND (DATE2DMY("Employment Date",1) < 16) THEN
                       CurrReport.SKIP;
                   END;
                */

                TestField("Employment Date");
                //Comentado CalculoFechas.CalculoEntreFechas("Employment Date", FechaFin, Anos, Meses, Dias);
                //Comentado DiasVacaciones := CalculoFechas.CalculoDiaVacaciones("No.", MesTrabajo, AnoTrabajo, MontoVacaciones, "Employment Date", FechaFin);

                if DiasVacaciones = 0 then
                    CurrReport.Skip;

                //Calculo en base a todos los conceptos de salario
                //CALCFIELDS(Salario);
                Salario := 0;
                LinPerfSalarial.Reset;
                LinPerfSalarial.SetRange("No. empleado", "No.");
                LinPerfSalarial.SetRange("Salario Base", true);
                LinPerfSalarial.SetFilter(Cantidad, '<>%1', 0);
                LinPerfSalarial.FindSet;
                repeat
                    Salario += LinPerfSalarial.Importe;
                until LinPerfSalarial.Next = 0;

                SalProm := Salario;
                //Busco el sueldo promedio del empleado si es por hora
                if "Tipo pago" = 1 then //Por hora
                   begin
                    SalProm := 0;

                    Fecha.Reset;
                    Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
                    Fecha.SetRange(Fecha."Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
                    Fecha.FindFirst;
                    FechaFin := CalcDate('-1A', DMY2Date(1, MesTrabajo, AnoTrabajo));
                    MesAnt := 0;
                    CantNom := 0;

                    HLN.Reset;
                    HLN.SetRange(Período, DMY2Date(1, Date2DMY(FechaFin, 2), Date2DMY(FechaFin, 3)), NormalDate(Fecha."Period End"));
                    HLN.SetRange("No. empleado", "No.");
                    HLN.SetRange("Salario Base", true);
                    if HLN.FindSet then
                        repeat
                            if MesAnt <> Date2DMY(HLN.Período, 2) then begin
                                MesAnt := Date2DMY(HLN.Período, 2);
                                CantNom += 1;
                            end;
                            SalProm += HLN.Total;
                        until HLN.Next = 0;

                    SalProm := SalProm / CantNom;
                end;
                //MESSAGE('%1 %2 %3 %4 %5',ConfNominas."Salario Minimo",salario,SalProm,HLN.GETFILTERS,CantNom);
                SalDiario := SalProm / 23.83;

                if (ConfNominas."Salario Minimo" <> 0) and (ConfNominas."Salario Minimo" > SalProm) then begin
                    SalDiario := ConfNominas."Salario Minimo" / 23.83;
                    SalProm := ConfNominas."Salario Minimo";
                end;

                if ConfNominas."Adelantar salario vacaciones" then begin
                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then
                        MontoVacaciones := SalDiario * DiasVacaciones //Employee.Salario + (SalDiario * DiasVacaciones)
                    else
                        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                            MontoVacaciones := Employee.Salario / 2 + (SalDiario * DiasVacaciones);

                    Remanente := MontoVacaciones;
                end
                else begin
                    MontoVacaciones := SalDiario * DiasVacaciones;

                    if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Mensual then
                        Remanente := Round(SalProm - MontoVacaciones, 0.01)
                    else
                        if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                            Remanente := Round(MontoVacaciones - (SalProm / 2), 0.01)
                        else
                            Remanente := Round(MontoVacaciones, 0.01);
                end;
                CantEmpl += 1;

                //Para actualizar el monto en el esq. percepcion
                if AplicaaNomina then begin
                    LinPerfSalarial2.SetRange("No. empleado", "No.");
                    LinPerfSalarial2.SetRange("Concepto salarial", ConfNominas."Concepto Vacaciones");
                    if LinPerfSalarial2.FindFirst then begin
                        LinPerfSalarial2.Cantidad := 1;
                        if "Tipo pago" = 1 then //Por hora
                            LinPerfSalarial2.Importe := Remanente
                        else
                            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then
                                LinPerfSalarial2.Importe := Remanente

                            else
                                LinPerfSalarial2.Importe := Remanente;
                        LinPerfSalarial2.Modify;
                    end;
                end;

            end;

            trigger OnPreDataItem()
            begin
                ConfNominas.Get();
                //ConfNominas.TESTFIELD("Salario Minimo");
                ConfNominas.TestField("Concepto Vacaciones");
                if Mes = Mes::"Año completo" then
                    MesTrabajo := 12
                else
                    MesTrabajo := Mes + 1;

                Fecha.Reset;
                Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
                Fecha.SetRange(Fecha."Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
                if Fecha.FindFirst then
                    FechaFin := NormalDate(Fecha."Period End");

                //CurrReport.CreateTotals(MontoVacaciones);
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
                field("Año a generar"; AnoTrabajo)
                {
                ApplicationArea = All;
                    Caption = 'Year to calculate';

                    trigger OnValidate()
                    begin
                        if (AnoTrabajo = 0) or (AnoTrabajo < 1900) then
                            Error('Introduzca un año válido por favor');
                    end;
                }
                field("Mes a generar"; Mes)
                {
                ApplicationArea = All;
                    Caption = 'Month to calculate';

                    trigger OnValidate()
                    begin
                        /*
                        IF Mes <> 12 THEN
                           BEGIN
                            Fecha.SETRANGE("Period Type",Fecha."Period Type"::Month);
                            Fecha.SETRANGE("Period Start",DMY2DATE(1,Mes+1,Anotrabajo));
                            Fecha.FINDFIRST;
                        
                            FechaIni := Fecha."Period Start";
                            FechaFin := NORMALDATE(Fecha."Period End");
                           END;
                        */

                    end;
                }
                field("Aplicar a nómina"; AplicaaNomina)
                {
                ApplicationArea = All;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if AnoTrabajo = 0 then
                AnoTrabajo := Date2DMY(Today, 3);
        end;
    }

    labels
    {
    }

    var
        ConfNominas: Record "Configuracion nominas";
        Contrato: Record Contratos;
        Fecha: Record Date;
        LinPerfSalarial: Record "Perfil Salarial";
        LinPerfSalarial2: Record "Perfil Salarial";
        HLN: Record "Historico Lin. nomina";
        //Comentado CalculoFechas: Codeunit "Funciones Nomina";
        Mes: Option Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre,"Año completo";
        ConceptoVac: Code[10];
        MesTrabajo: Integer;
        AnoTrabajo: Integer;
        FechaFin: Date;
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        CantEmpl: Integer;
        DiasVacaciones: Decimal;
        MontoVacaciones: Decimal;
        AplicaaNomina: Boolean;
        Err001: Label 'Configure %1 to %2 %3';
        SalDiario: Decimal;
        Employee_Vacaciones_ReportCaptionLbl: Label 'Employee Vacation''s Report';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Employee_DepartamentoCaptionLbl: Label 'Department';
        MontoVacacionesCaptionLbl: Label 'Vacation''s Amount';
        MontoVacaciones_Control1000000001CaptionLbl: Label 'Total Vacation';
        Total_de_empleadosCaptionLbl: Label 'Employee total';
        Primera: Boolean;
        Segunda: Boolean;
        Dias_VacacionesCaption: Label 'Vacation''s days';
        Remanente_Vacaciones_Caption: Label 'Remaining';
        SalProm: Decimal;
        MesAnt: Integer;
        CantNom: Integer;
        Remanente: Decimal;
        SaldoVac_Lbl: Label 'Remaining days';
}

