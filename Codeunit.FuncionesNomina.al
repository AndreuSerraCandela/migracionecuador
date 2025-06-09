// codeunit 76031 "Funciones Nomina"
// {

//     trigger OnRun()
//     begin
//         ProcesaDatosPonchador;
//     end;

//     var
//         ConfNomina: Record "Configuracion nominas";
//         TiposCotiza: Record "Tipos de Cotización";
//         Fecha: Record Date;
//         Empl: Record Employee;
//         LinPerfSalarial: Record "Perfil Salarial";
//         Window: Dialog;
//         CounterTotal: Integer;
//         Counter: Integer;
//         FechaInicioMes: Date;
//         AnoInicio: Integer;
//         MesInicio: Integer;
//         "DíaInicio": Integer;
//         AnoFin: Integer;
//         MesFin: Integer;
//         "DíaFin": Integer;
//         Text001: Label 'Processing Wedge... \ #1########## \ #2##############################';
//         Text002: Label 'End of update';
//         Text003: Label 'The Customer %1 had been created, you must finish the setup of the Posting Groups fields and unblock it to be able to use it.';
//         Text004: Label 'The Resource %1 had been created, you must finish the setup of the Posting Groups fields and unblock it to be able to use it.';
//         Text005: Label 'The Salesperson %1 had been created.';
//         Err001: Label 'Starting date can''t be bigger than Ending date, %1 > %2';
//         AsciiStr: Text[250];
//         AnsiStr: Text[250];
//         CharVar: array[32] of Char;
//         OnesText: array[30] of Text[30];
//         TensText: array[10] of Text[30];
//         HundredsText: array[10] of Text[30];
//         ExponentText: array[5] of Text[30];
//         HundredText: Text[30];
//         AndText: Text[30];
//         ZeroText: Text[30];
//         CentsText: Text[30];
//         OneMillionText: Text[30];
//         ThousText: array[10] of Text[30];
//         Text010: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
//         Text011: Label 'All pending records have been processed, please check the data on employees';


//     procedure CalculoEntreFechas(var FechaInicio: Date; var FechaFin: Date; var AnoCalculado: Integer; var MesCalculado: Integer; var "DíaCalculado": Integer): Date
//     begin
//         if FechaInicio > FechaFin then
//             Error(Err001, FechaInicio, FechaFin);


//         AnoInicio := Date2DMY(FechaInicio, 3);
//         MesInicio := Date2DMY(FechaInicio, 2);
//         DíaInicio := Date2DMY(FechaInicio, 1);
//         AnoFin := Date2DMY(FechaFin, 3);
//         MesFin := Date2DMY(FechaFin, 2);
//         DíaFin := Date2DMY(FechaFin, 1);
//         FechaInicioMes := FechaInicio;

//         AnoCalculado := AnoFin - AnoInicio;
//         MesCalculado := MesFin - MesInicio;
//         DíaCalculado := DíaFin - DíaInicio + 1;


//         if AnoCalculado = 0 then begin
//             if DíaCalculado < 0 then begin
//                 DíaCalculado += 30;
//                 MesCalculado -= 1;
//                 if MesCalculado < 0 then begin
//                     MesCalculado += 12;
//                     AnoCalculado -= 1;
//                 end;
//             end
//             else begin
//                 Fecha.Reset;
//                 Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
//                 Fecha.SetRange(Fecha."Period Start", DMY2Date(1, 1, Date2DMY(FechaInicioMes, 3)));
//                 Fecha.FindFirst;
//                 if DíaCalculado = Date2DMY(Fecha."Period End", 1) then begin
//                     MesCalculado += 1;
//                     DíaCalculado := 0;
//                 end;
//             end;
//         end
//         else
//             if (AnoCalculado = 1) and (MesCalculado = 0) and ((DíaCalculado = 1) or (DíaCalculado = 0)) then
//                 AnoCalculado := 1
//             else begin
//                 if MesCalculado <= 0 then begin
//                     MesCalculado += 12;
//                     AnoCalculado -= 1;
//                     //DíaCalculado += 1;
//                 end;

//                 if MesCalculado = 12 then begin
//                     MesCalculado := 0;
//                     AnoCalculado += 1;
//                 end;

//                 if DíaCalculado < 0 then begin
//                     DíaCalculado += 30;
//                     MesCalculado -= 1;
//                     if MesCalculado < 0 then begin
//                         MesCalculado += 12;
//                         AnoCalculado -= 1;
//                     end
//                     else
//                         if MesCalculado = 0 then begin
//                             MesCalculado := 11;
//                             AnoCalculado -= 1;
//                             DíaCalculado += 1;
//                         end;
//                 end
//                 else begin
//                     Fecha.Reset;
//                     Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
//                     Fecha.SetRange(Fecha."Period Start", DMY2Date(1, 1, Date2DMY(FechaInicio, 3)));
//                     Fecha.FindFirst;
//                     if DíaCalculado = Date2DMY(Fecha."Period End", 1) then begin
//                         MesCalculado += 1;
//                         DíaCalculado := 0;
//                     end;
//                 end;
//             end;


//         //MESSAGE('Calculo entre fechas %1 %2 %3 %4', DíaCalculado, MesCalculado, AnoCalculado,FechaInicio);
//     end;


//     procedure CalculoDiaVacaciones(CodEmpl: Code[20]; MesTrabajo: Integer; AnoTrabajo: Integer; var MontoVacaciones: Decimal; FechaIngreso: Date; FechaFinal: Date) DiasVacaciones: Integer
//     var
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         FechaFin: Date;
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//         SueldoTotal: Decimal;
//     begin
//         // 6 días de salario ordinario, si tiene más de cinco meses de servicio
//         // 7 días de salario ordinario, si tiene más de seis meses de servicio
//         // 8 días de salario ordinario, si tiene más de siete meses de servicio
//         // 9 días de salario ordinario, si tiene más de ocho meses de servicio
//         //10 días de salario ordinario, si tiene más de nueve meses de servicio
//         //11 días de salario ordinario, si tiene más de diez meses de servicio
//         //12 días de salario ordinario, si tiene más de once meses de servicio (Arts.180 y 182)
//         ConfNomina.Get();
//         SueldoTotal := 0;
//         Empl.Get(CodEmpl);
//         if FechaIngreso = 0D then
//             Error(Err001, CodEmpl);

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
//         if Fecha.FindFirst then
//             FechaFin := NormalDate(Fecha."Period End");

//         CalculoEntreFechas(FechaIngreso, FechaFin, Anos, Meses, Dias);
//         //ERROR('%1 %2',FechaFin,Dias);
//         /*
//         IF DATE2DMY(FechaFin,1) = Dias THEN
//           BEGIN
//            Meses += 1;
//           Dias := 0;
//          END;
//         */

//         LinPerfSalarial.SetRange("No. empleado", CodEmpl);
//         LinPerfSalarial.SetRange("Salario Base", true);
//         LinPerfSalarial.SetFilter(Cantidad, '>%1', 0);
//         LinPerfSalarial.SetFilter(Importe, '<>%1', 0);
//         LinPerfSalarial.SetFilter("Concepto salarial", '<>%1', ConfNomina."Concepto Vacaciones");
//         LinPerfSalarial.FindSet;
//         repeat
//             if LinPerfSalarial."Currency Code" <> '' then begin
//                 SueldoTotal += LinPerfSalarial.Importe * ConfNomina."Tasa Cambio Calculo Divisa";
//             end
//             else
//                 SueldoTotal += LinPerfSalarial.Importe;
//         until LinPerfSalarial.Next = 0;

//         if (Anos >= 1) and (Anos < 5) then
//             DiasVacaciones := 14
//         else
//             if Anos >= 5 then
//                 DiasVacaciones := 18
//             else
//                 case Meses of
//                     5:
//                         DiasVacaciones := 6;
//                     6:
//                         DiasVacaciones := 7;
//                     7:
//                         DiasVacaciones := 8;
//                     8:
//                         DiasVacaciones := 9;
//                     9:
//                         DiasVacaciones := 10;
//                     10:
//                         DiasVacaciones := 11;
//                     11:
//                         DiasVacaciones := 12;
//                     else
//                         DiasVacaciones := 0;
//                 end;

//         MontoVacaciones := SueldoTotal / 23.83 * DiasVacaciones;

//         /*GRN 25/02/2020 Debo cambiar la programacion
//         IF Anos >= 1 THEN
//            DiasVacaciones := 14
//         ELSE
//            CASE Meses OF
//              0..4:
//               DiasVacaciones := 0;
//              5:
//               DiasVacaciones := 6;
//              6:
//               DiasVacaciones := 7;
//              7:
//               DiasVacaciones := 8;
//              8:
//               DiasVacaciones := 9;
//              9:
//               DiasVacaciones := 10;
//             10:
//               DiasVacaciones := 11;
//             11:
//               DiasVacaciones := 12;
//             ELSE
//               DiasVacaciones := 14;
//            END;
//         */
//         // ERROR('%1 %2',DiasVacaciones,MontoVacaciones);
//         exit(DiasVacaciones);

//     end;


//     procedure CalculoDiaVacacionesEC(CodEmpl: Code[20]; MesTrabajo: Integer; AnoTrabajo: Integer; MontoVacaciones: Decimal) DiasVacaciones: Integer
//     var
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         FechaFin: Date;
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//     begin
//         // 15 días al primer año
//         // 1 dia x cada año hasta llegar a 30

//         Empl.Get(CodEmpl);
//         if Empl."Employment Date" = 0D then
//             Error(Err001, CodEmpl);

//         Fecha.Reset;
//         Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange(Fecha."Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
//         if Fecha.FindFirst then
//             FechaFin := NormalDate(Fecha."Period End");

//         CalculoEntreFechas(Empl."Employment Date", FechaFin, Anos, Meses, Dias);

//         LinPerfSalarial.SetRange("No. empleado", CodEmpl);
//         LinPerfSalarial.SetRange("Salario Base", true);
//         LinPerfSalarial.FindFirst;

//         if Anos = 1 then
//             DiasVacaciones := 15
//         else
//             if Anos > 1 then
//                 DiasVacaciones += 1 * Anos - 1;

//         if DiasVacaciones > 30 then
//             DiasVacaciones := 30;

//         MontoVacaciones := LinPerfSalarial.Importe / 23.83 * DiasVacaciones;
//     end;


//     procedure CalculoDiaVacacionesCR(CodEmpl: Code[20]; MesTrabajo: Integer; AnoTrabajo: Integer; MontoVacaciones: Decimal) DiasVacaciones: Integer
//     var
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         Contrato: Record "Employment Contract";
//         FechaFin: Date;
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//     begin
//         // 1.83 días de vacaciones, si tiene 1 año o mas por cada mes para los empleados fijos
//         // 1    día de vacaciones, por cada mes para los empleados temporales

//         Empl.Get(CodEmpl);
//         if Empl."Employment Date" = 0D then
//             Error(Err001, CodEmpl);

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
//         if Fecha.FindFirst then
//             FechaFin := NormalDate(Fecha."Period End");

//         CalculoEntreFechas(Empl."Employment Date", FechaFin, Anos, Meses, Dias);

//         Meses := Meses + (Anos * 12);

//         LinPerfSalarial.SetRange("No. empleado", CodEmpl);
//         LinPerfSalarial.SetRange("Salario Base", true);
//         LinPerfSalarial.FindFirst;

//         Contrato.Get(Empl."Emplymt. Contract Code");
//         if Contrato.Undefined then
//             DiasVacaciones := Meses * 1.83
//         else
//             DiasVacaciones := Meses * 1;

//         MontoVacaciones := LinPerfSalarial.Importe / 23.83 * DiasVacaciones;
//     end;


//     procedure CalculoDiaVacacionesPR(CodEmpl: Code[20]; MesTrabajo: Integer; AnoTrabajo: Integer; MontoVacaciones: Decimal) DiasVacaciones: Integer
//     var
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         HistLinNom: Record "Historico Lin. nomina";
//         FechaFin: Date;
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//         Horas: Decimal;
//     begin
//         // Regla de acumulativo por concepto de días de
//         // vacaciones y enfermedad a razón de que si labora
//         // 115 horas o más al mes, acumula 8 horas de enfermedad
//         // y 10 horas de vacaciones mensualmente.

//         Empl.Get(CodEmpl);
//         if Empl."Employment Date" = 0D then
//             Error(Err001, CodEmpl);

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
//         if Fecha.FindFirst then
//             FechaFin := NormalDate(Fecha."Period End");

//         HistLinNom.Reset;
//         HistLinNom.SetRange("No. empleado", CodEmpl);
//         HistLinNom.SetRange("Tipo Nómina", HistLinNom."Tipo Nómina"::Normal);
//         HistLinNom.SetRange(Período, Fecha."Period Start", FechaFin);
//         HistLinNom.SetRange("Salario Base", true);
//         if HistLinNom.FindSet then
//             repeat
//                 Horas += HistLinNom.Cantidad;
//             until HistLinNom.Next = 0;

//         Horas := Round(Horas / 115, 1);

//         DiasVacaciones := 10 * Horas;
//     end;


//     procedure CalculoDiaEnfermedadPR(CodEmpl: Code[20]; MesTrabajo: Integer; AnoTrabajo: Integer; MontoVacaciones: Decimal) DiasVacaciones: Integer
//     var
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         HistLinNom: Record "Historico Lin. nomina";
//         FechaFin: Date;
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//         Horas: Decimal;
//     begin
//         // Regla de acumulativo por concepto de días de
//         // vacaciones y enfermedad a razón de que si labora
//         // 115 horas o más al mes, acumula 8 horas de enfermedad
//         // y 10 horas de vacaciones mensualmente.

//         Empl.Get(CodEmpl);
//         if Empl."Employment Date" = 0D then
//             Error(Err001, CodEmpl);

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, MesTrabajo, AnoTrabajo));
//         if Fecha.FindFirst then
//             FechaFin := NormalDate(Fecha."Period End");

//         HistLinNom.Reset;
//         HistLinNom.SetRange("No. empleado", CodEmpl);
//         HistLinNom.SetRange("Tipo Nómina", HistLinNom."Tipo Nómina"::Normal);
//         HistLinNom.SetRange(Período, Fecha."Period Start", FechaFin);
//         HistLinNom.SetRange("Salario Base", true);
//         if HistLinNom.FindSet then
//             repeat
//                 Horas += HistLinNom.Cantidad;
//             until HistLinNom.Next = 0;

//         Horas := Round(Horas / 115, 1);

//         DiasVacaciones := 8 * Horas;
//     end;


//     procedure BuscaNovedades(Emp: Record Employee): Integer
//     var
//         MNA: Record "Tipos de acciones personal";
//         HistAccionesdepersonal: Record "Hist. Acciones de personal";
//     begin
//         /*
//         MNA.SETRANGE("Tipo de accion",Emp."No.");
//         MNA.SETFILTER("ID Documento",Emp.GETFILTER("Date Filter"));

//         EXIT(MNA.COUNT);
//         */

//         HistAccionesdepersonal.Reset;
//         HistAccionesdepersonal.SetRange("No. empleado", Emp."No.");
//         exit(HistAccionesdepersonal.Count);

//     end;


//     procedure MuestraNovedades(Emp: Record Employee)
//     var
//         HistAccionesdepersonal: Record "Hist. Acciones de personal";
//         frmMNA: Page "Hist. acciones de personal";
//     begin

//         HistAccionesdepersonal.Reset;
//         HistAccionesdepersonal.SetRange("No. empleado", Emp."No.");
//         frmMNA.SetTableView(HistAccionesdepersonal);
//         frmMNA.RunModal;
//         Clear(frmMNA);
//     end;


//     procedure BuscaAusencias(Emp: Record Employee): Integer
//     var
//         EmpAbs: Record "Employee Absence";
//     begin
//         EmpAbs.SetRange("Employee No.", Emp."No.");
//         if Emp.GetFilter("Date Filter") <> '' then begin
//             EmpAbs.SetFilter("From Date", '>=%1', Emp.GetRangeMin("Date Filter"));
//             EmpAbs.SetFilter("To Date", '<=%1', Emp.GetRangeMax("Date Filter"));
//         end;
//         EmpAbs.SetRange(Closed, true);
//         exit(EmpAbs.Count);
//     end;


//     procedure MuestraAusencias(Emp: Record Employee)
//     var
//         EmpAbs: Record "Employee Absence";
//         frmEmpAbs: Page "Employee Absences";
//     begin
//         EmpAbs.SetRange("Employee No.", Emp."No.");
//         if Emp.GetFilter("Date Filter") <> '' then begin
//             EmpAbs.SetFilter("From Date", '>=%1', Emp.GetRangeMin("Date Filter"));
//             EmpAbs.SetFilter("To Date", '<=%1', Emp.GetRangeMax("Date Filter"));
//         end;
//         frmEmpAbs.SetTableView(EmpAbs);
//         frmEmpAbs.RunModal;
//         Clear(frmEmpAbs);
//     end;


//     procedure BuscaDimensiones(NoEmp: Code[20]): Integer
//     var
//         DefDim: Record "Default Dimension";
//     begin
//         DefDim.SetRange("Table ID", 5200);
//         DefDim.SetRange("No.", NoEmp);
//         exit(DefDim.Count);
//     end;


//     procedure MuestraDimensiones(NoEmp: Code[20])
//     var
//         frmDefDim: Page "Default Dimensions";
//         DefDim: Record "Default Dimension";
//     begin
//         DefDim.SetRange("Table ID", 5200);
//         DefDim.SetRange("No.", NoEmp);
//         frmDefDim.SetTableView(DefDim);
//         frmDefDim.RunModal;
//         Clear(frmDefDim);
//     end;


//     procedure BuscaCualificaciones(NoEmp: Code[20]): Integer
//     var
//         Cualific: Record "Employee Qualification";
//     begin
//         Cualific.SetRange("Employee No.", NoEmp);
//         exit(Cualific.Count);
//     end;


//     procedure MuestraCualificaciones(NoEmp: Code[20])
//     var
//         frmCualific: Page "Employee Qualifications";
//         Cualific: Record "Employee Qualification";
//     begin
//         Cualific.SetRange("Employee No.", NoEmp);
//         frmCualific.SetTableView(Cualific);
//         frmCualific.RunModal;
//         Clear(frmCualific);
//     end;


//     procedure BuscaNominas(Emp: Record Employee): Integer
//     var
//         HCNom: Record "Historico Cab. nomina";
//     begin
//         HCNom.SetRange("No. empleado", Emp."No.");
//         if Emp.GetFilter("Date Filter") <> '' then
//             HCNom.SetRange(Período, Emp.GetRangeMin("Date Filter"), Emp.GetRangeMin("Date Filter"));
//         exit(HCNom.Count);
//     end;


//     procedure MuestraNominas(Emp: Record Employee)
//     var
//         HCNom: Record "Historico Cab. nomina";
//         pHCNom: Page "Lista historico nóminas";
//     begin
//         HCNom.SetRange("No. empleado", Emp."No.");
//         if Emp.GetFilter("Date Filter") <> '' then
//             HCNom.SetRange(Período, Emp.GetRangeMin("Date Filter"), Emp.GetRangeMin("Date Filter"));
//         pHCNom.SetTableView(HCNom);
//         pHCNom.RunModal;
//         Clear(pHCNom);
//     end;


//     procedure CalculoDiasBonificacion(CodEmpl: Code[20]; FechaFin: Date) DiasBonificacion: Integer
//     var
//         Empl: Record Employee;
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//     begin
//         Empl.Get(CodEmpl);
//         if Empl."Employment Date" = 0D then
//             Error(Err001, CodEmpl);

//         /*
//         Fecha.RESET;
//         Fecha.SETRANGE(Fecha."Period Type",Fecha."Period Type"::Month);
//         Fecha.SETRANGE(Fecha."Period Start",DMY2DATE(1,12,AnoTrabajo));
//         IF Fecha.FINDFIRST THEN
//            FechaFin:= NORMALDATE(Fecha."Period End");
//            */

//         CalculoEntreFechas(Empl."Employment Date", FechaFin, Anos, Meses, Dias);

//         LinPerfSalarial.SetRange("No. empleado", CodEmpl);
//         LinPerfSalarial.SetRange("Salario Base", true);
//         LinPerfSalarial.FindFirst;

//         if Anos < 3 then
//             DiasBonificacion := 45
//         else
//             DiasBonificacion := 60;

//     end;


//     procedure CalculoMontoBonificacion(CodEmpl: Code[20]; AnoTrabajo: Integer; MontoVacaciones: Decimal; FechaFinal: Date) MontoBonificac: Decimal
//     var
//         Empl: Record Employee;
//         Err001: Label 'Missing Starting Date for  Employee %1 ';
//         LinPerfSalarial: Record "Perfil Salarial";
//         FechaFin: Date;
//         Anos: Integer;
//         Meses: Integer;
//         Dias: Integer;
//         DiasBonificacion: Integer;
//     begin
//         Empl.Get(CodEmpl);
//         if Empl."Employment Date" = 0D then
//             Error(Err001, CodEmpl);


//         Fecha.Reset;
//         Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange(Fecha."Period Start", DMY2Date(1, 12, AnoTrabajo));
//         if Fecha.FindFirst then
//             FechaFin := NormalDate(Fecha."Period End");


//         CalculoEntreFechas(Empl."Employment Date", FechaFin, Anos, Meses, Dias);

//         LinPerfSalarial.SetRange("No. empleado", CodEmpl);
//         LinPerfSalarial.SetRange("Salario Base", true);
//         LinPerfSalarial.FindFirst;

//         if Anos < 3 then
//             DiasBonificacion := 45
//         else
//             DiasBonificacion := 60;
//         /*
//         IF Anos = 0 THEN
//            BEGIN
//             Empl.SETRANGE("Date Filter",DMY2DATE(1,1,AnoTrabajo),DMY2DATE(31,12,AnoTrabajo));
//             Empl.CALCFIELDS("Acumulado Salario");
//             MontoBonificac := ROUND(Empl."Acumulado Salario" / 12,0.01);
//             MontoBonificac := ROUND(MontoBonificac / 23.83 * DiasBonificacion,0.01);
//            END
//         ELSE
//         */
//         MontoBonificac := Round(LinPerfSalarial.Importe / 23.83 * DiasBonificacion, 0.01);

//     end;


//     procedure InicializaConceptosSalariales()
//     var
//         ParamInicConceptos: Record "Param. Inic. Conceptos Sal.";
//         LinEsqPercepcion: Record "Perfil Salarial";
//         Contrato: Record Contratos;
//         Ventana: Dialog;
//         Modifica: Boolean;
//     begin
//         Ventana.Open(Text001);
//         ConfNomina.Get();
//         ParamInicConceptos.FindFirst;
//         with ParamInicConceptos do
//             repeat
//                 LinEsqPercepcion.Reset;
//                 LinEsqPercepcion.SetRange("Concepto salarial", ParamInicConceptos.Codigo);
//                 Ventana.Update(1, ParamInicConceptos.Codigo);
//                 Ventana.Update(2, ParamInicConceptos.Descripcion);
//                 if LinEsqPercepcion.FindSet() then
//                     repeat
//                         Modifica := false;
//                         Empl.Get(LinEsqPercepcion."No. empleado");
//                         Contrato.Reset;
//                         Contrato.SetRange("No. empleado", LinEsqPercepcion."No. empleado");
//                         Contrato.SetRange("Cód. contrato", Empl."Emplymt. Contract Code");
//                         //Contrato.SETRANGE(Activo,TRUE);
//                         if not Contrato.FindFirst then
//                             Contrato.Init;

//                         if (Contrato."Frecuencia de pago" <> Contrato."Frecuencia de pago"::Mensual) and
//                            (Contrato."Frecuencia de pago" <> Contrato."Frecuencia de pago"::Quincenal) then begin
//                             if "Inicializa Cantidad" then begin
//                                 //                IF (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Sal. Base") AND
//                                 //                   (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Dieta") THEN
//                                 begin
//                                     LinEsqPercepcion.Cantidad := 0;
//                                     Modifica := true;
//                                 end;
//                             end;

//                             if ("Inicializa Importe") and (LinEsqPercepcion."Formula calculo" = '') then begin
//                                 if "Inicializa Cantidad" then begin
//                                     //                    IF (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Sal. Base") AND
//                                     //                       (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Dieta") THEN
//                                     begin
//                                         LinEsqPercepcion.Importe := 0;
//                                         Modifica := true;
//                                     end;
//                                 end;
//                             end;
//                         end
//                         else begin
//                             if "Inicializa Cantidad" then begin
//                                 if (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Sal. Base") and
//                                    (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Dieta") then begin
//                                     LinEsqPercepcion.Cantidad := 0;
//                                     Modifica := true;
//                                 end;
//                             end;

//                             if ("Inicializa Importe") and (LinEsqPercepcion."Formula calculo" = '') then begin
//                                 if "Inicializa Cantidad" then begin
//                                     if (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Sal. Base") and
//                                        (LinEsqPercepcion."Concepto salarial" <> ConfNomina."Concepto Dieta") then begin
//                                         LinEsqPercepcion.Importe := 0;
//                                         Modifica := true;
//                                     end;
//                                 end;
//                             end;
//                         end;

//                         if Modifica then
//                             LinEsqPercepcion.Modify;
//                     until LinEsqPercepcion.Next = 0;
//             until ParamInicConceptos.Next = 0;
//         Message(Text002);
//     end;


//     procedure BuscaBalCte(Emp: Record Employee): Decimal
//     var
//         Cte: Record Customer;
//     begin
//         if Cte.Get(Emp."Codigo Cliente") then begin
//             Cte.CalcFields("Balance (LCY)");
//             exit(Cte."Balance (LCY)");
//         end;
//     end;


//     procedure MuestraBalCte(Emp: Record Employee)
//     var
//         CLE: Record "Cust. Ledger Entry";
//         frmCLE: Page "Customer Ledger Entries";
//     begin
//         CLE.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
//         CLE.SetRange("Customer No.", Emp."Codigo Cliente");
//         CLE.SetRange(Open, true);
//         frmCLE.SetTableView(CLE);
//         frmCLE.RunModal;
//         Clear(frmCLE);
//     end;


//     procedure BuscaHistSalario(Emp: Record Employee): Integer
//     var
//         HSalario: Record "Acumulado Salarios";
//     begin
//         HSalario.SetRange("No. empleado", Emp."No.");
//         exit(HSalario.Count);
//     end;


//     procedure MuestraHistSalario(Emp: Record Employee)
//     var
//         HSalario: Record "Acumulado Salarios";
//         frmHSalario: Page "Histórico de Salarios";
//     begin
//         HSalario.SetRange("No. empleado", Emp."No.");
//         frmHSalario.SetTableView(HSalario);
//         frmHSalario.RunModal;
//         Clear(frmHSalario);
//     end;


//     procedure BuscaSaldoISRFavor(Emp: Record Employee): Decimal
//     var
//         SFISR: Record "Saldos a favor ISR";
//     begin
//         SFISR.Reset;
//         SFISR.SetRange("Cód. Empleado", Emp."No.");
//         SFISR.SetRange(Ano, Date2DMY(WorkDate, 3));
//         if SFISR.FindFirst then
//             exit(SFISR."Importe Pendiente");
//     end;


//     procedure MuestraSaldoISRFavor(Emp: Record Employee)
//     var
//         SFISR: Record "Saldos a favor ISR";
//         fSFISR: Page "Saldos a favor ISR";
//     begin
//         SFISR.Reset;
//         SFISR.SetRange("Cód. Empleado", Emp."No.");
//         SFISR.SetRange(Ano, Date2DMY(WorkDate, 3));
//         if SFISR.FindFirst then begin
//             fSFISR.SetRecord(SFISR);
//             fSFISR.RunModal;
//         end;

//         Clear(fSFISR);
//     end;


//     procedure AcumuladoFUTA(CodEmpleado: Code[20]; FechaIni: Date; FechaFin: Date): Decimal
//     var
//         HistLinNom: Record "Historico Lin. nomina";
//         HistLinEmp: Record "Lin. Aportes Empresas";
//         Acumulado: Decimal;
//     begin
//         ConfNomina.Get();
//         Acumulado := 0;
//         TiposCotiza.Get(Date2DMY(Today, 3), ConfNomina."Concepto AFP");
//         if (TiposCotiza."Acumula por" = 1) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinNom.SetCurrentKey("No. empleado", Período, "Concepto salarial");
//             HistLinNom.SetRange("No. empleado", CodEmpleado);
//             HistLinNom.SetRange(Período, FechaIni, FechaFin);
//             HistLinNom.SetRange("Concepto salarial", ConfNomina."Concepto AFP");
//             if HistLinNom.FindFirst then
//                 HistLinNom.CalcSums(Total);
//             Acumulado += HistLinNom.Total;
//         end;

//         if (TiposCotiza."Acumula por" = 2) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinEmp.SetCurrentKey("No. Empleado", Período, "Concepto Salarial");
//             HistLinEmp.SetRange("No. Empleado", CodEmpleado);
//             HistLinEmp.SetRange(Período, FechaIni, FechaFin);
//             HistLinEmp.SetRange("Concepto Salarial", ConfNomina."Concepto AFP");
//             if HistLinEmp.FindFirst then
//                 HistLinEmp.CalcSums(Importe);
//             Acumulado += HistLinEmp.Importe;
//         end;

//         exit(Abs(Round(Acumulado, 0.01)));
//     end;


//     procedure AcumuladoSUTA(CodEmpleado: Code[20]; FechaIni: Date; FechaFin: Date): Decimal
//     var
//         HistLinNom: Record "Historico Lin. nomina";
//         HistLinEmp: Record "Lin. Aportes Empresas";
//         Acumulado: Decimal;
//     begin
//         ConfNomina.Get();
//         Acumulado := 0;
//         TiposCotiza.Get(Date2DMY(Today, 3), ConfNomina."Concepto INFOTEP");
//         if (TiposCotiza."Acumula por" = 1) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
//             HistLinNom.SetRange("No. empleado", CodEmpleado);
//             HistLinNom.SetRange(Período, FechaIni, FechaFin);
//             HistLinNom.SetRange("Concepto salarial", ConfNomina."Concepto INFOTEP");
//             HistLinNom.CalcSums(Total);
//             Acumulado += HistLinNom.Total;
//         end;

//         if (TiposCotiza."Acumula por" = 2) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinEmp.SetCurrentKey("No. Empleado", Período, "Concepto Salarial");
//             HistLinEmp.SetRange("No. Empleado", CodEmpleado);
//             HistLinEmp.SetRange(Período, FechaIni, FechaFin);
//             HistLinEmp.SetRange("Concepto Salarial", ConfNomina."Concepto INFOTEP");
//             HistLinEmp.CalcSums(Importe);
//             Acumulado += HistLinEmp.Importe;
//         end;

//         exit(Abs(Round(Acumulado, 0.01)));
//     end;


//     procedure AcumuladoFICA(CodEmpleado: Code[20]; FechaIni: Date; FechaFin: Date): Decimal
//     var
//         HistLinNom: Record "Historico Lin. nomina";
//         HistLinEmp: Record "Lin. Aportes Empresas";
//         Acumulado: Decimal;
//     begin
//         ConfNomina.Get();
//         Acumulado := 0;
//         TiposCotiza.Get(Date2DMY(Today, 3), ConfNomina."Concepto Retroactivo");
//         if (TiposCotiza."Acumula por" = 1) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinNom.Reset;
//             HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
//             HistLinNom.SetRange("No. empleado", CodEmpleado);
//             HistLinNom.SetRange(Período, FechaIni, FechaFin);
//             HistLinNom.SetRange("Cotiza FICA", true);
//             HistLinNom.CalcSums(Total);
//             Acumulado += HistLinNom.Total;
//         end;

//         if (TiposCotiza."Acumula por" = 2) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinEmp.Reset;
//             HistLinEmp.SetCurrentKey("No. Empleado", Período, "Concepto Salarial");
//             HistLinEmp.SetRange("No. Empleado", CodEmpleado);
//             HistLinEmp.SetFilter(Período, '<%1', FechaIni);
//             //    histlinemp.setrange("Cotiza FICA",true);
//             HistLinEmp.CalcSums(Importe);
//             Acumulado += HistLinEmp.Importe;
//         end;

//         exit(Abs(Round(Acumulado, 0.01)));
//     end;


//     procedure AcumuladoSINOT(CodEmpleado: Code[20]; FechaIni: Date; FechaFin: Date): Decimal
//     var
//         HistLinNom: Record "Historico Lin. nomina";
//         HistLinEmp: Record "Lin. Aportes Empresas";
//         Acumulado: Decimal;
//     begin
//         ConfNomina.Get();
//         Acumulado := 0;
//         TiposCotiza.Get(Date2DMY(Today, 3), ConfNomina."Concepto SFS");
//         if (TiposCotiza."Acumula por" = 1) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinNom.Reset;
//             HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
//             HistLinNom.SetRange("No. empleado", CodEmpleado);
//             HistLinNom.SetFilter(Período, '<%1', FechaIni);
//             HistLinNom.SetRange("Cotiza SFS", true);
//             HistLinNom.SetFilter("Tipo Nómina", '<>%1', HistLinNom."Tipo Nómina"::Renta);
//             HistLinNom.CalcSums(Total);
//             Acumulado += HistLinNom.Total;
//             //    message('%1 %2 %3 %4 %5',acumulado,HistLinNom."Concepto salarial",HistLinNom.getfilters);
//         end;

//         if (TiposCotiza."Acumula por" = 2) or (TiposCotiza."Acumula por" = 3) then begin
//             HistLinEmp.Reset;
//             HistLinEmp.SetCurrentKey("No. Empleado", Período, "Concepto Salarial");
//             HistLinEmp.SetRange("No. Empleado", CodEmpleado);
//             HistLinEmp.SetFilter(Período, '<%1', FechaIni);
//             HistLinEmp.SetRange("Concepto Salarial", ConfNomina."Concepto SFS");
//             HistLinEmp.CalcSums(Importe);
//             Acumulado += HistLinEmp.Importe;
//         end;

//         exit(Abs(Round(Acumulado, 0.01)));
//     end;


//     procedure VacacionesAcumuladas(CodEmpleado: Code[20]; FechaIni: Date; FechaFin: Date): Decimal
//     var
//         EmpAbs: Record "Employee Absence";
//         CA: Record "Cause of Absence";
//         Acumulado: Decimal;
//     begin
//         ConfNomina.Get();

//         CA.Reset;
//         CA.SetRange("Cod. concepto salarial", ConfNomina."Concepto Vacaciones");
//         CA.FindFirst;

//         Acumulado := 0;
//         EmpAbs.SetCurrentKey("Employee No.", "Cause of Absence Code");
//         EmpAbs.SetRange("Employee No.", CodEmpleado);
//         EmpAbs.SetRange("Cause of Absence Code", CA.Code);
//         EmpAbs.SetFilter("From Date", '%1..', FechaIni);
//         EmpAbs.CalcSums(Quantity);
//         Acumulado := EmpAbs.Quantity;
//         exit(Acumulado);
//     end;


//     procedure BuscaSaldoISRFavorBO(Emp: Record Employee): Decimal
//     var
//         SFISR: Record "Saldos a favor ISR";
//     begin
//         SFISR.SetRange("Cód. Empleado", Emp."No.");
//         if SFISR.FindLast then
//             exit(SFISR."Importe Pendiente");
//     end;


//     procedure MuestraSaldoISRFavorBO(Emp: Record Employee)
//     var
//         SFISR: Record "Saldos a favor ISR";
//         fSFISR: Page "Saldos a favor ISR";
//     begin
//         SFISR.Reset;
//         SFISR.SetRange("Cód. Empleado", Emp."No.");
//         if SFISR.FindFirst then begin
//             fSFISR.SetRecord(SFISR);
//             fSFISR.RunModal;
//         end;

//         Clear(fSFISR);
//     end;


//     procedure CreaRecurso(Employee: Record Employee)
//     var
//         Res: Record Resource;
//         ResSetup: Record "Resources Setup";
//         ResUOM: Record "Resource Unit of Measure";
//     begin
//         //Res.GET(Employee."Resource No.");
//         ResSetup.Get();
//         //ResSetup.TESTFIELD("Default Unit of Measure");

//         Res.Init;
//         Res."No." := Employee."No.";
//         Res."Job Title" := Employee."Job Title";
//         Res.Name := CopyStr(Employee.FullName, 1, 30);
//         Res.Address := Employee.Address;
//         Res."Address 2" := Employee."Address 2";
//         Res.Validate("Post Code", Employee."Post Code");
//         Res."Social Security No." := Employee."Social Security No.";
//         Res."Employment Date" := Employee."Employment Date";
//         Employee.CalcFields(Salario);
//         Employee.TestField(Salario);
//         Res."Direct Unit Cost" := Round(Employee.Salario / 23.83 / 8, 0.01);
//         Res."Unit Cost" := Res."Direct Unit Cost";
//         Res.Blocked := true;

//         Res.Insert(true);

//         ResUOM.Init;
//         ResUOM.Validate("Resource No.", Employee."No.");
//         //ResUOM.VALIDATE(Code,ResSetup."Default Unit of Measure");
//         ResUOM."Qty. per Unit of Measure" := 1;
//         if ResUOM.Insert(true) then;

//         //Res.VALIDATE("Base Unit of Measure",ResSetup."Default Unit of Measure");
//         Res.Modify;

//         Employee."Resource No." := Res."No.";
//         Employee.Modify(true);

//         Message(Text004, Res."No.");
//     end;


//     procedure CreaCliente(Employee: Record Employee)
//     var
//         Cte: Record Customer;
//     begin
//         Cte.Init;
//         Cte."No." := Employee."No.";
//         Cte.Validate(Name, Employee."Full Name");
//         Cte.Address := Employee.Address;
//         Cte."Address 2" := Employee."Address 2";
//         Cte.City := Employee.City;
//         Cte."Phone No." := Employee."Phone No.";
//         Cte."VAT Registration No." := Employee."Document ID";
//         Cte."Post Code" := Employee."Post Code";
//         Cte.County := Employee.County;
//         Cte."E-Mail" := Employee."E-Mail";
//         Cte."No. Series" := Employee."No. Series";
//         Cte.Blocked := Cte.Blocked::All;
//         Cte.Insert(true);
//         Cte.Validate("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
//         Cte.Validate("Global Dimension 2 Code", Employee."Global Dimension 2 Code");
//         Cte.Modify;

//         Employee."Codigo Cliente" := Cte."No.";
//         Employee.Modify(true);

//         Message(Text003, Cte."No.");
//     end;


//     procedure CreaVendedor(Employee: Record Employee)
//     var
//         SalesPerson: Record "Salesperson/Purchaser";
//     begin
//         SalesPerson.Code := Employee."No.";
//         SalesPerson.Name := Employee."Full Name";
//         SalesPerson."E-Mail" := Employee."E-Mail";
//         SalesPerson."Phone No." := Employee."Phone No.";
//         SalesPerson."Job Title" := Employee."Job Title";
//         SalesPerson.Insert(true);

//         SalesPerson.Validate("Global Dimension 1 Code", Employee."Global Dimension 1 Code");
//         SalesPerson.Validate("Global Dimension 2 Code", Employee."Global Dimension 2 Code");

//         SalesPerson.Modify;

//         Employee."Salespers./Purch. Code" := SalesPerson.Code;
//         Employee.Modify(true);

//         Message(Text005, SalesPerson.Code);
//     end;


//     procedure BuscaActividades(Emp: Record Employee; FechaIni: Date; FechaFin: Date): Integer
//     var
//         MovAct: Record "Mov. actividades OJO";
//     begin
//         MovAct.SetRange("No. empleado", Emp."No.");
//         MovAct.SetFilter("Inicio Período", '>=%1', FechaIni);
//         MovAct.SetFilter("Fin Período", '<=%1', FechaFin);
//         //MovAct.SETRANGE(Closed,TRUE);
//         exit(MovAct.Count);
//     end;


//     procedure MuestraActividades(Emp: Record Employee; FechaIni: Date; FechaFin: Date)
//     var
//         MovAct: Record "Mov. actividades OJO";
//         frmMovAct: Page "Mov. actividades";
//     begin
//         MovAct.SetRange("No. empleado", Emp."No.");
//         MovAct.SetFilter("Inicio Período", '>=%1', FechaIni);
//         MovAct.SetFilter("Fin Período", '<=%1', FechaFin);
//         frmMovAct.SetTableView(MovAct);
//         frmMovAct.RunModal;
//         Clear(frmMovAct);
//     end;


//     procedure Ansi2Ascii(_Text: Text[250]): Text[250]
//     begin
//         MakeVars;
//         exit(ConvertStr(_Text, AnsiStr, AsciiStr));
//     end;


//     procedure Ascii2Ansi(_Text: Text[250]): Text[250]
//     begin
//         MakeVars;
//         exit(ConvertStr(_Text, AsciiStr, AnsiStr));
//     end;

//     local procedure MakeVars()
//     begin
//         AsciiStr := 'áéíóúñÑAÉIOUü';
//         AnsiStr := 'aeiounNAEIOUU';
//         /*AsciiStr := 'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ¢£¥ƒáíóúñÑªº¿¬½¼¡«»¦¦¦¦¦…†‡ˆ¦¦++Ž++--+-+–—++--¦-+A';
//         AsciiStr := AsciiStr +'Ÿ¨©­®¯i´¸¹++¦_¦ÃØÊßËÌÍÎµÏÐÒÓÔÕ×ØÙÚ±=ÝÞã÷ð°õ·øý²¦ ';
//         CharVar[1] := 196;
//         CharVar[2] := 197;
//         CharVar[3] := 201;
//         CharVar[4] := 242;
//         CharVar[5] := 220;
//         CharVar[6] := 186;
//         CharVar[7] := 191;
//         CharVar[8] := 188;
//         CharVar[9] := 187;
//         CharVar[10] := 193;
//         CharVar[11] := 194;
//         CharVar[12] := 192;
//         CharVar[13] := 195;
//         CharVar[14] := 202;
//         CharVar[15] := 203;
//         CharVar[16] := 200;
//         CharVar[17] := 205;
//         CharVar[18] := 206;
//         CharVar[19] := 204;
//         CharVar[20] := 175;
//         CharVar[21] := 223;
//         CharVar[22] := 213;
//         CharVar[23] := 254;
//         CharVar[24] := 218;
//         CharVar[25] := 219;
//         CharVar[26] := 217;
//         CharVar[27] := 180;
//         CharVar[28] := 177;
//         CharVar[29] := 176;
//         CharVar[30] := 185;
//         CharVar[31] := 179;
//         CharVar[32] := 178;
//         AnsiStr  := '—ýÒËÍÊÎÏÓÔÐÙØÕ'+FORMAT(CharVar[1])+FORMAT(CharVar[2])+FORMAT(CharVar[3])+ 'µ–Þ÷'+FORMAT(CharVar[4]);
//         AnsiStr := AnsiStr + 'øõ ´'+FORMAT(CharVar[5])+'°ú¹¸âß×Ý·±©¬'+FORMAT(CharVar[6])+FORMAT(CharVar[7]);
//         AnsiStr := AnsiStr + '«¼'+FORMAT(CharVar[8])+'í½'+FORMAT(CharVar[9])+'___ªª' + FORMAT(CharVar[10])+FORMAT(CharVar[11]);
//         AnsiStr := AnsiStr + FORMAT(CharVar[12]) + 'ªª++óÑ++--+-+Ì' + FORMAT(CharVar[13]) + '++--ª-+ñÚ¨';
//         AnsiStr  :=  AnsiStr +FORMAT(CharVar[14])+FORMAT(CharVar[15])+FORMAT(CharVar[16])+'i'+FORMAT(CharVar[17])+FORMAT(CharVar[18]);
//         AnsiStr  :=  AnsiStr + 'Ÿ++__ª' + FORMAT(CharVar[19])+FORMAT(CharVar[20])+'®'+FORMAT(CharVar[21])+'¯­ã';
//         AnsiStr  :=  AnsiStr + FORMAT(CharVar[22]) + '…' + FORMAT(CharVar[23]) + 'Ã' + FORMAT(CharVar[24])+ FORMAT(CharVar[25]);
//         AnsiStr  :=  AnsiStr + FORMAT(CharVar[26]) + '²¦»' + FORMAT(CharVar[27]) + '¡' + FORMAT(CharVar[28]) +'=Ž†ºðˆ'+ FORMAT(CharVar[29]);
//         AnsiStr  :=  AnsiStr + '¿‡' + FORMAT(CharVar[30]) +FORMAT(CharVar[31]) +FORMAT(CharVar[32]) +'_ A';
//         */

//     end;


//     procedure FechaCorta(Fecha_Loc: Date): Text[250]
//     var
//         txtFecha: Text[250];
//         txtdia: Text[30];
//         txtmes: Text[30];
//         txtano: Text[30];
//         dia: Integer;
//         mes: Integer;
//         ano: Integer;
//         Esp: Text[1];
//     begin
//         Esp := ' ';
//         dia := Date2DMY(Fecha_Loc, 1);
//         mes := Date2DMY(Fecha_Loc, 2);
//         ano := Date2DMY(Fecha_Loc, 3);

//         txtdia := Format(dia);
//         txtano := Format(ano);

//         case mes of
//             1:
//                 txtmes := 'enero';
//             2:
//                 txtmes := 'febrero';
//             3:
//                 txtmes := 'marzo';
//             4:
//                 txtmes := 'abril';
//             5:
//                 txtmes := 'mayo';
//             6:
//                 txtmes := 'junio';
//             7:
//                 txtmes := 'julio';
//             8:
//                 txtmes := 'agosto';
//             9:
//                 txtmes := 'septiembre';
//             10:
//                 txtmes := 'octubre';
//             11:
//                 txtmes := 'noviembre';
//             12:
//                 txtmes := 'diciembre';
//         end;

//         txtFecha := txtdia + Esp + 'de' + Esp + txtmes + Esp + 'del' + Esp + txtano;

//         exit(txtFecha);
//     end;


//     procedure FechaLarga(Fecha_Loc: Date): Text[250]
//     var
//         txtFecha: Text[250];
//         txtdia: Text[30];
//         txtmes: Text[30];
//         txtano: Text[30];
//         Esp: Text[1];
//         dia: Integer;
//         mes: Integer;
//         ano: Integer;
//     begin
//         Esp := ' ';

//         dia := Date2DMY(Fecha_Loc, 1);
//         mes := Date2DMY(Fecha_Loc, 2);
//         ano := Date2DMY(Fecha_Loc, 3);

//         txtdia := (LowerCase(txtdia));
//         dia := Date2DMY(Fecha_Loc, 1);

//         dia := Date2DMY(Fecha_Loc, 1);
//         mes := Date2DMY(Fecha_Loc, 2);
//         ano := Date2DMY(Fecha_Loc, 3);

//         txtdia := Format(dia);
//         txtano := Format(ano);

//         case dia of
//             1:
//                 txtdia := 'primero (01)';
//             2:
//                 txtdia := 'dos (02)';
//             3:
//                 txtdia := 'tres (30)';
//             4:
//                 txtdia := 'cuatro (04)';
//             5:
//                 txtdia := 'cinco (05)';
//             6:
//                 txtdia := 'seis (06)';
//             7:
//                 txtdia := 'siete (07)';
//             8:
//                 txtdia := 'ocho (08)';
//             9:
//                 txtdia := 'nueve (09)';
//             10:
//                 txtdia := 'diez (10)';
//             11:
//                 txtdia := 'once (11)';
//             12:
//                 txtdia := 'doce (12)';
//             13:
//                 txtdia := 'trece (13)';
//             14:
//                 txtdia := 'catorce (14)';
//             15:
//                 txtdia := 'quince (15)';
//             16:
//                 txtdia := 'dieciséis (16)';
//             17:
//                 txtdia := 'diecisiete (17)';
//             18:
//                 txtdia := 'dieciocho (18)';
//             19:
//                 txtdia := 'diecinueve (19)';
//             20:
//                 txtdia := 'veinte (20)';
//             21:
//                 txtdia := 'veintiuno (21)';
//             22:
//                 txtdia := 'veintidós (22)';
//             23:
//                 txtdia := 'veintitrés (23)';
//             24:
//                 txtdia := 'veinticuatro (24)';
//             25:
//                 txtdia := 'veinticinco (25)';
//             26:
//                 txtdia := 'veintiséis (26)';
//             27:
//                 txtdia := 'veintisiete (27)';
//             28:
//                 txtdia := 'veintiocho (28)';
//             29:
//                 txtdia := 'veintinueve (29)';
//             30:
//                 txtdia := 'treinta (30)';
//             31:
//                 txtdia := 'Treinta y uno (31)';
//         end;


//         case mes of
//             1:
//                 txtmes := 'enero';
//             2:
//                 txtmes := 'febrero';
//             3:
//                 txtmes := 'marzo';
//             4:
//                 txtmes := 'abril';
//             5:
//                 txtmes := 'mayo';
//             6:
//                 txtmes := 'junio';
//             7:
//                 txtmes := 'julio';
//             8:
//                 txtmes := 'agosto';
//             9:
//                 txtmes := 'septiembre';
//             10:
//                 txtmes := 'octubre';
//             11:
//                 txtmes := 'noviembre';
//             12:
//                 txtmes := 'diciembre';
//         end;

//         //txtano := LOWERCASE(cuDocWord.FechaALetras(ano,''));

//         txtFecha := txtdia + Esp + 'días' + Esp + 'del mes de' + Esp + txtmes + Esp + 'del' + Esp + 'año' + Esp;

//         exit(txtFecha);
//     end;


//     procedure NombreDia(Fecha_Loc: Date): Text[250]
//     var
//         txtFecha: Text[250];
//         txtdia: Text[30];
//         txtmes: Text[30];
//         txtano: Text[30];
//         Esp: Text[1];
//         dia: Integer;
//         mes: Integer;
//         ano: Integer;
//     begin
//         Esp := ' ';

//         dia := Date2DMY(Fecha_Loc, 1);
//         mes := Date2DMY(Fecha_Loc, 2);
//         ano := Date2DMY(Fecha_Loc, 3);

//         txtdia := (LowerCase(txtdia));
//         dia := Date2DMY(Fecha_Loc, 1);

//         dia := Date2DMY(Fecha_Loc, 1);
//         mes := Date2DMY(Fecha_Loc, 2);
//         ano := Date2DMY(Fecha_Loc, 3);

//         txtdia := Format(dia);
//         txtano := Format(ano);

//         case dia of
//             1:
//                 txtdia := 'primero (01)';
//             2:
//                 txtdia := 'dos (02)';
//             3:
//                 txtdia := 'tres (03)';
//             4:
//                 txtdia := 'cuatro (04)';
//             5:
//                 txtdia := 'cinco (05)';
//             6:
//                 txtdia := 'seis (06)';
//             7:
//                 txtdia := 'siete (07)';
//             8:
//                 txtdia := 'ocho (08)';
//             9:
//                 txtdia := 'nueve (09)';
//             10:
//                 txtdia := 'diez (10)';
//             11:
//                 txtdia := 'once (11)';
//             12:
//                 txtdia := 'doce (12)';
//             13:
//                 txtdia := 'trece (13)';
//             14:
//                 txtdia := 'catorce (14)';
//             15:
//                 txtdia := 'quince (15)';
//             16:
//                 txtdia := 'dieciséis (16)';
//             17:
//                 txtdia := 'diecisiete (17)';
//             18:
//                 txtdia := 'dieciocho (18)';
//             19:
//                 txtdia := 'diecinueve (19)';
//             20:
//                 txtdia := 'veinte (20)';
//             21:
//                 txtdia := 'veintiuno (21)';
//             22:
//                 txtdia := 'veintidós (22)';
//             23:
//                 txtdia := 'veintitrés (23)';
//             24:
//                 txtdia := 'veinticuatro (24)';
//             25:
//                 txtdia := 'veinticinco (25)';
//             26:
//                 txtdia := 'veintiséis (26)';
//             27:
//                 txtdia := 'veintisiete (27)';
//             28:
//                 txtdia := 'veintiocho (28)';
//             29:
//                 txtdia := 'veintinueve (29)';
//             30:
//                 txtdia := 'treinta (30)';
//             31:
//                 txtdia := 'Treinta y uno (31)';
//         end;


//         txtFecha := txtdia;

//         exit(txtFecha);
//     end;


//     procedure ProcesaControlAsistencia(FechaIni: Date; FechaFin: Date)
//     var
//         CA: Record "Control de asistencia";
//         DCA: Record "Control de asistencia";
//         PerfSal: Record "Perfil Salarial";
//         HorReg: Decimal;
//         Hor35: Decimal;
//         Hor100: Decimal;
//         HorFer: Decimal;
//         HorNoc: Decimal;
//         HorENoc: Decimal;
//     begin
//         //Buscamos la configuracion
//         ConfNomina.Get();

//         //Verificamos que los conceptos esten configurados
//         //ConfNomina.TESTFIELD("Concepto Horas Ext. 100%");
//         ConfNomina.TestField("Concepto Horas Ext. 35%");
//         ConfNomina.TestField("Concepto Horas nocturnas");
//         ConfNomina.TestField("Concepto Dias feriados");
//         ConfNomina.TestField("Concepto Sal. Base");

//         //Leemos la tabla de control de asistencia y la de distribucion para calcular el pago por concepto
//         CA.Reset;
//         if (FechaIni <> 0D) and (FechaFin <> 0D) then
//             CA.SetRange("Fecha registro", FechaIni, FechaFin);
//         CA.SetRange(Status, CA.Status::Pendiente);
//         CA.FindSet;
//         CounterTotal := CA.Count;
//         Window.Open(Text010);
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, CA."Cod. Empleado");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             Hor100 := 0;
//             Hor35 := 0;
//             HorFer := 0;
//             HorNoc := 0;
//             HorReg := 0;
//             HorENoc := 0;

//             DCA.Reset;
//             DCA.SetRange("Cod. Empleado", CA."Cod. Empleado");
//             DCA.SetFilter("Fecha registro", CA.GetFilter("Fecha registro"));
//             //DCA.SETRANGE("Hora registro",CA."Hora registro");

//             if DCA.FindSet then
//                 repeat
//                     if DCA."Horas extras 100" <> 0 then
//                         HorENoc += DCA."Horas extras 100";

//                     if DCA."Horas feriadas" <> 0 then
//                         Hor100 += DCA."Horas feriadas";

//                     if DCA."Horas extras al 35" <> 0 then
//                         Hor35 += DCA."Horas extras al 35";

//                     if DCA."Horas feriadas" <> 0 then
//                         HorFer += DCA."Horas feriadas";

//                     if DCA."Horas nocturnas" <> 0 then
//                         HorNoc += DCA."Horas nocturnas";

//                     if DCA."Horas regulares" <> 0 then
//                         HorReg += DCA."Horas regulares";

//                 until DCA.Next = 0;

//             if HorENoc <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Sal. hora");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorENoc;
//                 PerfSal.Modify;
//             end
//             else
//                 if Hor100 <> 0 then begin
//                     PerfSal.Reset;
//                     PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Horas Ext. 100%");
//                     PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                     PerfSal.FindFirst;
//                     PerfSal.Cantidad := Hor100;
//                     PerfSal.Modify;
//                 end;
//             if Hor35 <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Horas Ext. 35%");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := Hor35;
//                 PerfSal.Modify;
//             end;
//             if HorFer <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Dias feriados");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorFer;
//                 PerfSal.Modify;
//             end;
//             if HorNoc <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Horas nocturnas");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorNoc;
//                 PerfSal.Modify;
//             end;
//             if HorReg <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Sal. Base");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorReg;
//                 PerfSal.Modify;
//             end;
//         until CA.Next = 0;
//         Window.Close;
//         Message(Text011);
//     end;


//     procedure ProcesaControlAsistenciaJob(FechaIni: Date; FechaFin: Date; CodProyecto: Code[20])
//     var
//         CA: Record "Control de asistencia";
//         DCA: Record "Distrib. Control de asis. Proy";
//         PerfSal: Record "Perfil Salarial";
//         HorReg: Decimal;
//         Hor35: Decimal;
//         Hor100: Decimal;
//         HorFer: Decimal;
//         HorNoc: Decimal;
//         HorENoc: Decimal;
//     begin
//         //Buscamos la configuracion
//         ConfNomina.Get();

//         //Verificamos que los conceptos esten configurados
//         ConfNomina.TestField("Concepto Horas Ext. 100%");
//         ConfNomina.TestField("Concepto Horas Ext. 35%");
//         ConfNomina.TestField("Concepto Horas nocturnas");
//         ConfNomina.TestField("Concepto Dias feriados");
//         ConfNomina.TestField("Concepto Sal. Base");

//         //Leemos la tabla de control de asistencia y la de distribucion para calcular el pago por concepto
//         CA.Reset;
//         if (FechaIni <> 0D) and (FechaFin <> 0D) then
//             CA.SetRange("Fecha registro", FechaIni, FechaFin);
//         CA.SetRange(Status, CA.Status::Pendiente);
//         CA.FindSet;
//         CounterTotal := CA.Count;
//         Window.Open(Text010);
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, CA."Cod. Empleado");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             Hor100 := 0;
//             Hor35 := 0;
//             HorFer := 0;
//             HorNoc := 0;
//             HorReg := 0;
//             HorENoc := 0;

//             DCA.Reset;
//             DCA.SetRange("Cod. Empleado", CA."Cod. Empleado");
//             DCA.SetRange("Job No.", CodProyecto);
//             DCA.SetFilter("Fecha registro", CA.GetFilter("Fecha registro"));
//             //DCA.SETRANGE("Hora registro",CA."Hora registro");

//             if DCA.FindSet then
//                 repeat
//                     if DCA."Horas Extras Nocturnas" <> 0 then
//                         HorENoc += DCA."Horas Extras Nocturnas";

//                     if DCA."Horas extras al 100" <> 0 then
//                         Hor100 += DCA."Horas extras al 100";

//                     if DCA."Horas extras al 35" <> 0 then
//                         Hor35 += DCA."Horas extras al 35";

//                     if DCA."Horas feriadas" <> 0 then
//                         HorFer += DCA."Horas feriadas";

//                     if DCA."Horas nocturnas" <> 0 then
//                         HorNoc += DCA."Horas nocturnas";

//                     if DCA."Horas regulares" <> 0 then
//                         HorReg += DCA."Horas regulares";

//                 until DCA.Next = 0;

//             if HorENoc <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Sal. hora");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorENoc;
//                 PerfSal.Modify;
//             end
//             else
//                 if Hor100 <> 0 then begin
//                     PerfSal.Reset;
//                     PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Horas Ext. 100%");
//                     PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                     PerfSal.FindFirst;
//                     PerfSal.Cantidad := Hor100;
//                     PerfSal.Modify;
//                 end;
//             if Hor35 <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Horas Ext. 35%");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := Hor35;
//                 PerfSal.Modify;
//             end;
//             if HorFer <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Dias feriados");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorFer;
//                 PerfSal.Modify;
//             end;
//             if HorNoc <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Horas nocturnas");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorNoc;
//                 PerfSal.Modify;
//             end;
//             if HorReg <> 0 then begin
//                 PerfSal.Reset;
//                 PerfSal.SetRange("Concepto salarial", ConfNomina."Concepto Sal. Base");
//                 PerfSal.SetRange("No. empleado", CA."Cod. Empleado");
//                 PerfSal.FindFirst;
//                 PerfSal.Cantidad := HorReg;
//                 PerfSal.Modify;
//             end;
//         until CA.Next = 0;
//         Window.Close;
//         Message(Text011);
//     end;


//     procedure ProcesaDatosPonchador()
//     var
//         LogPonchador: Record "Punch log";
//         LogPonchador2: Record "Punch log";
//         ControlAsist: Record "Control de asistencia";
//         ShiftSch: Record "Shift schedule";
//         ContadorReg: Integer;
//         Contador: Integer;
//         EmpAnt: Code[20];
//         FechaAnt: Date;
//         HoraReg: Time;
//     begin
//         ConfNomina.Get();
//         if ConfNomina."Integracion ponche activa" then begin
//             ConfNomina.TestField("CU Procesa datos ponchador");
//             CODEUNIT.Run(ConfNomina."CU Procesa datos ponchador");
//             Commit;
//         end;

//         LogPonchador.Reset;
//         //LogPonchador.SETRANGE("Cod. Empleado",'1007');
//         LogPonchador.SetRange("Fecha registro", CalcDate('-7D', Today), Today);
//         //LogPonchador.SETRANGE(Procesado,FALSE);
//         CounterTotal := LogPonchador.Count;
//         Window.Open(Text010);
//         if LogPonchador.FindSet() then
//             repeat
//                 Counter := Counter + 1;
//                 Window.Update(1, LogPonchador."Cod. Empleado");
//                 Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//                 Empl.Get(LogPonchador."Cod. Empleado");
//                 if (Empl.Status = Empl.Status::Active) and (LogPonchador."Fecha registro" <> 0D) then begin
//                     //Busco los registros de ese dia para ese empleado
//                     if (EmpAnt <> LogPonchador."Cod. Empleado") or (FechaAnt <> LogPonchador."Fecha registro") then begin
//                         EmpAnt := LogPonchador."Cod. Empleado";
//                         FechaAnt := LogPonchador."Fecha registro";
//                         LogPonchador2.Reset;
//                         LogPonchador2.SetRange("Cod. Empleado", LogPonchador."Cod. Empleado");
//                         LogPonchador2.SetRange("Fecha registro", LogPonchador."Fecha registro");
//                         //habilitar LogPonchador2.SETRANGE(Procesado,FALSE);

//                         if Empl.Shift <> '' then begin
//                             ShiftSch.Reset;
//                             ShiftSch.SetRange("Codigo turno", Empl.Shift);
//                             ShiftSch.FindFirst;
//                             ConfNomina.TestField("Horas de almuerzo");
//                             if ShiftSch."Hora Inicio" > 120000T then
//                                 LogPonchador2.SetRange("Fecha registro", LogPonchador."Fecha registro", CalcDate('+1D', LogPonchador."Fecha registro"));
//                         end;

//                         //            LogPonchador2.FINDSET;
//                         ContadorReg := LogPonchador2.Count;
//                         Contador := 0;
//                     end;

//                     Clear(HoraReg);
//                     HoraReg := LogPonchador."Hora registro";// + 14400000; //4 horas

//                     ControlAsist.Reset;
//                     ControlAsist.SetRange("Cod. Empleado", LogPonchador."Cod. Empleado");
//                     ControlAsist.SetRange("Fecha registro", LogPonchador."Fecha registro");
//                     if not ControlAsist.FindFirst then begin
//                         Contador += 1;
//                         ControlAsist.Init;
//                         ControlAsist.Validate("Cod. Empleado", LogPonchador."Cod. Empleado");
//                         ControlAsist.Validate("Fecha registro", LogPonchador."Fecha registro");
//                         ControlAsist."Hora registro" := Time;
//                         ControlAsist."ID Equipo" := LogPonchador."ID Equipo";

//                         if Contador <= ContadorReg then
//                             case Contador of
//                                 1:
//                                     begin
//                                         ControlAsist.Validate("1ra entrada", HoraReg);
//                                         ControlAsist."Fecha Entrada" := LogPonchador."Fecha registro";
//                                     end;
//                                 2:
//                                     begin
//                                         ControlAsist."1ra salida" := HoraReg;
//                                         ControlAsist."Fecha Salida" := LogPonchador."Fecha registro";
//                                         /*
//                                         IF Empl.Shift <> '' THEN
//                                            BEGIN
//                                              ControlAsist."1ra salida"  := ShiftSch."Hora almuerzo";
//                                            END;
//                                            */
//                                     end;
//                                 3:
//                                     begin
//                                         ControlAsist."2da entrada" := HoraReg;
//                                         ControlAsist."Fecha Entrada" := LogPonchador."Fecha registro";
//                                     end
//                                 else begin
//                                     ControlAsist."2da salida" := HoraReg;
//                                     ControlAsist."Fecha Salida" := LogPonchador."Fecha registro";
//                                 end;
//                             end;

//                         ControlAsist.Validate("1ra entrada");
//                         ControlAsist.Insert;
//                     end
//                     else begin
//                         Contador += 1;
//                         ControlAsist."2da entrada" := 0T;
//                         ControlAsist."2da salida" := 0T;
//                         if Contador <= ContadorReg then
//                             case Contador of
//                                 1:
//                                     begin
//                                         ControlAsist."1ra entrada" := HoraReg;
//                                         ControlAsist."Fecha Entrada" := LogPonchador."Fecha registro";
//                                     end;
//                                 2:
//                                     begin
//                                         ControlAsist."1ra salida" := HoraReg;
//                                         ControlAsist."Fecha Salida" := LogPonchador."Fecha registro";
//                                         /*
//                                         IF Empl.Shift <> '' THEN
//                                            BEGIN
//                                              ControlAsist."1ra salida"  := ShiftSch."Hora almuerzo";
//                                              ControlAsist."2da entrada" := ShiftSch."Hora almuerzo" + 1 * 60 * 60 * 1000;
//                                              ControlAsist.VALIDATE("2da salida",HoraReg);
//                                            END;
//                                            */
//                                     end;

//                                 3:
//                                     begin
//                                         ControlAsist."2da entrada" := HoraReg;
//                                         ControlAsist."Fecha Entrada" := LogPonchador."Fecha registro";
//                                     end;
//                                 else begin
//                                     ControlAsist."2da salida" := HoraReg;
//                                     ControlAsist."Fecha Salida" := LogPonchador."Fecha registro";
//                                 end;
//                             end;
//                         ControlAsist.Validate("Fecha registro", LogPonchador."Fecha registro");
//                         ControlAsist.Validate("1ra entrada");
//                         ControlAsist.Modify;
//                     end;
//                 end;

//                 LogPonchador.Procesado := true;
//                 LogPonchador.Modify;

//             until LogPonchador.Next = 0;
//         Window.Close;
//         Message(Text011);

//     end;


//     procedure ProcesaDatosPonchadorManual()
//     var
//         LogPonchador: Record "Punch log";
//         LogPonchador2: Record "Punch log";
//         ControlAsist: Record "Control de asistencia";
//         ShiftSch: Record "Shift schedule";
//         ContadorReg: Integer;
//         Contador: Integer;
//         EmpAnt: Code[20];
//         FechaAnt: Date;
//     begin
//         ConfNomina.Get();
//         ConfNomina.TestField("XML importa datos ponchador");
//         XMLPORT.Run(ConfNomina."XML importa datos ponchador");


//         LogPonchador.Reset;
//         LogPonchador.SetRange(Procesado, false);
//         CounterTotal := LogPonchador.Count;
//         Window.Open(Text010);
//         if LogPonchador.FindSet() then
//             repeat
//                 Counter := Counter + 1;
//                 Window.Update(1, LogPonchador."Cod. Empleado");
//                 Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//                 Empl.Get(LogPonchador."Cod. Empleado");
//                 if Empl.Status = Empl.Status::Active then begin
//                     //Busco los registros de ese dia para ese empleado
//                     if (EmpAnt <> LogPonchador."Cod. Empleado") or (FechaAnt <> LogPonchador."Fecha registro") then begin
//                         EmpAnt := LogPonchador."Cod. Empleado";
//                         FechaAnt := LogPonchador."Fecha registro";
//                         LogPonchador2.Reset;
//                         LogPonchador2.SetRange("Cod. Empleado", LogPonchador."Cod. Empleado");
//                         LogPonchador2.SetRange("Fecha registro", LogPonchador."Fecha registro");
//                         LogPonchador2.SetRange(Procesado, false);
//                         //            LogPonchador2.FINDSET;
//                         ContadorReg := LogPonchador2.Count;
//                         Contador := 0;
//                     end;

//                     if Empl.Shift <> '' then begin
//                         ShiftSch.Reset;
//                         ShiftSch.SetRange("Codigo turno", Empl.Shift);
//                         ShiftSch.FindFirst;
//                         ConfNomina.TestField("Horas de almuerzo");
//                     end;

//                     ControlAsist.Reset;
//                     ControlAsist.SetRange("Cod. Empleado", LogPonchador."Cod. Empleado");
//                     ControlAsist.SetRange("Fecha registro", LogPonchador."Fecha registro");
//                     if not ControlAsist.FindFirst then begin
//                         Contador += 1;
//                         ControlAsist.Init;
//                         ControlAsist.Validate("Cod. Empleado", LogPonchador."Cod. Empleado");
//                         ControlAsist.Validate("Fecha registro", LogPonchador."Fecha registro");
//                         ControlAsist."Hora registro" := Time;
//                         ControlAsist."ID Equipo" := LogPonchador."ID Equipo";
//                         /*
//                         IF LogPonchador."Hora registro" < 120000T THEN
//                            BEGIN
//                             ControlAsist.VALIDATE("1ra entrada",LogPonchador."Hora registro");
//             //                ControlAsist.VALIDATE("1ra salida",120000T);
//             //                ControlAsist.VALIDATE("2da entrada",130000T);
//                            END
//                         ELSE
//                         IF ContadorReg > 3 THEN
//                            BEGIN
//                              ControlAsist.VALIDATE("1ra salida",LogPonchador."Hora registro");
//                              ControlAsist.VALIDATE("2da salida",130000T);
//                            END
//                         ELSE
//                           ControlAsist.VALIDATE("1ra salida",LogPonchador."Hora registro");
//                         */

//                         if Contador <= ContadorReg then
//                             case Contador of
//                                 1:
//                                     ControlAsist.Validate("1ra entrada", LogPonchador."Hora registro");
//                                 2:
//                                     begin
//                                         ControlAsist."1ra salida" := LogPonchador."Hora registro";
//                                         if Empl.Shift <> '' then begin
//                                             //   ControlAsist."1ra salida"  := ConfNomina."Horas de almuerzo";
//                                             //ControlAsist."2da entrada" := ConfNomina."Horas de almuerzo" + 010000t;
//                                             ControlAsist.Validate("2da salida", LogPonchador."Hora registro");
//                                         end;
//                                     end;
//                                 3:
//                                     ControlAsist."2da entrada" := LogPonchador."Hora registro";
//                                 else
//                                     ControlAsist."2da salida" := LogPonchador."Hora registro";
//                             end;
//                         ControlAsist.Insert;
//                     end
//                     else begin
//                         Contador += 1;
//                         if Contador <= ContadorReg then
//                             case Contador of
//                                 1:
//                                     ControlAsist."1ra entrada" := LogPonchador."Hora registro";
//                                 2:
//                                     begin
//                                         ControlAsist."1ra salida" := LogPonchador."Hora registro";
//                                         if Empl.Shift <> '' then begin
//                                             //                        ControlAsist."1ra salida"  := ShiftSch."Hora almuerzo";
//                                             //                        ControlAsist."2da entrada" := ShiftSch."Hora almuerzo" + 1 * 60 * 60 * 1000;
//                                             //                        ControlAsist.VALIDATE("2da salida",LogPonchador."Hora registro");
//                                         end;
//                                     end;

//                                 3:
//                                     ControlAsist."2da entrada" := LogPonchador."Hora registro";
//                                 else
//                                     ControlAsist."2da salida" := LogPonchador."Hora registro";
//                             end;

//                         /*
//                         IF LogPonchador."Hora registro" < 120000T THEN
//                            BEGIN
//                             ControlAsist.VALIDATE("1ra entrada",LogPonchador."Hora registro");
//             //                ControlAsist.VALIDATE("1ra salida",120000T);
//             //                ControlAsist.VALIDATE("2da entrada",130000T);
//                            END
//                         ELSE
//                         IF ContadorReg >= 3 THEN
//                            BEGIN
//                              ControlAsist.VALIDATE("1ra salida",LogPonchador."Hora registro");
//                              ControlAsist.VALIDATE("2da entrada",130000T);
//                            END
//                         ELSE
//                         IF ContadorReg > 2 THEN
//                            ControlAsist.VALIDATE("1ra salida",LogPonchador."Hora registro");
//                         ELSE
//                             ControlAsist.VALIDATE("1ra salida",LogPonchador."Hora registro");
//                         */
//                         ControlAsist.Validate("Fecha registro", LogPonchador."Fecha registro");
//                         ControlAsist.Validate("1ra entrada");
//                         ControlAsist.Modify;
//                     end;
//                 end;

//                 LogPonchador.Procesado := true;
//                 LogPonchador.Modify;

//             until LogPonchador.Next = 0;
//         Window.Close;
//         Message(Text011);

//     end;


//     procedure ValidarCedula(NoCed: Text[11]): Boolean
//     var
//         Digito: Integer;
//         Digito2: Integer;
//         i: Integer;
//         Resta: Integer;
//         Numero_Base: Text;
//         Suma: Integer;
//         Division: Integer;
//     begin
//         //Verificamos que la longitud del parametro sea igual a 11, de lo contrario, no es valida
//         if StrLen(NoCed) < 11 then
//             exit(false);

//         Numero_Base := '1212121212';
//         for i := 10 downto 1 do begin
//             Evaluate(Digito, CopyStr(NoCed, i, 1)); //1 digito del string de la cedula
//             Evaluate(Digito2, CopyStr(Numero_Base, i, 1)); //1 digito del string numero base
//             Resta := Digito * Digito2;
//             if Resta > 10 then //Si se pasa de 10 le resto 9
//                 Resta := Resta - 9
//             else
//                 if Resta = 10 then
//                     Resta := 1;
//             Suma += Resta;
//         end;

//         Division := Suma div 10 * 10;
//         if Division <> Suma then begin
//             Division := Division + 10;
//             Division -= Suma;
//         end
//         else
//             Division -= Suma;

//         if Format(Division) = CopyStr(NoCed, 11, 1) then
//             exit(true);
//     end;


//     procedure TraspasaEmpleados(Empresa: Text[60]; Accionesdepersonal: Record "Acciones de personal")
//     var
//         Empl: Record Employee;
//         Empto: Record Employee;
//         PerfilSal: Record "Perfil Salarial";
//         PerfilSalTo: Record "Perfil Salarial";
//         Contrato: Record Contratos;
//         ContratoTo: Record Contratos;
//         Banco: Record "Distrib. Ingreso Pagos Elect.";
//         BancoTo: Record "Distrib. Ingreso Pagos Elect.";
//         HistCabNom: Record "Historico Cab. nomina";
//         HistCabNomTo: Record "Historico Cab. nomina";
//         HistLinNom: Record "Historico Lin. nomina";
//         HistLinNomTo: Record "Historico Lin. nomina";
//         Vacac: Record "Historico Vacaciones";
//         VacacTo: Record "Historico Vacaciones";
//         SaldoISR: Record "Saldos a favor ISR";
//         SaldoISRTo: Record "Saldos a favor ISR";
//         MovAct: Record "Mov. actividades OJO";
//         MovActTo: Record "Mov. actividades OJO";
//         HistSal: Record "Acumulado Salarios";
//         HistSalTo: Record "Acumulado Salarios";
//         AltAddr: Record "Alternative Address";
//         AltAddrTo: Record "Alternative Address";
//         Qualif: Record "Employee Qualification";
//         QualifTo: Record "Employee Qualification";
//         Ausencia: Record "Employee Relative";
//         AusenciaTo: Record "Employee Relative";
//         RecDiv: Record "Misc. Article Information";
//         RecDivTo: Record "Misc. Article Information";
//         InfConf: Record "Confidential Information";
//         InfConfTo: Record "Confidential Information";
//         HistCabCxC: Record "Histórico Cab. Préstamo";
//         HistCabCxCTo: Record "Histórico Cab. Préstamo";
//         HistLinCxC: Record "Histórico Lín. Préstamo";
//         HistLinCxCTo: Record "Histórico Lín. Préstamo";
//         HistAccepersonal: Record "Hist. Acciones de personal";
//         HistAccepersonalTo: Record "Hist. Acciones de personal";
//     begin
//         if Empresa = CompanyName then
//             exit;

//         //Empleados.SETFILTER("Codigo Empleado",'%1','4230');
//         Empl.Get(Accionesdepersonal."No. empleado");
//         Clear(Empto);

//         Empto.ChangeCompany(Empresa);
//         if Empto.Get(Empl."No.") then;

//         Empto.TransferFields(Empl, false);
//         Empto."No." := Accionesdepersonal."No. empleado";
//         if not Empto.Insert then
//             Empto.Modify;

//         PerfilSal.Reset;
//         PerfilSal.SetRange("No. empleado", Empl."No.");
//         if PerfilSal.FindSet then
//             repeat
//                 Clear(PerfilSalTo);
//                 PerfilSalTo.TransferFields(PerfilSal, false);
//                 PerfilSalTo."No. empleado" := Empto."No.";
//                 PerfilSalTo."Perfil salarial" := PerfilSal."Perfil salarial";
//                 PerfilSalTo."Concepto salarial" := PerfilSal."Concepto salarial";
//                 PerfilSalTo.ChangeCompany(Empresa);
//                 if not PerfilSalTo.Insert then
//                     PerfilSalTo.Modify;
//             until PerfilSal.Next = 0;

//         Contrato.Reset;
//         Contrato.SetRange("No. empleado", Empl."No.");
//         if Contrato.FindSet then
//             repeat
//                 Clear(ContratoTo);
//                 ContratoTo.TransferFields(Contrato, false);
//                 ContratoTo."No. empleado" := Empto."No.";
//                 ContratoTo."No. Orden" := Contrato."No. Orden";
//                 ContratoTo.ChangeCompany(Empresa);
//                 if not ContratoTo.Insert then begin
//                     ContratoTo."Fecha finalización" := 0D;
//                     ContratoTo.Modify;
//                 end;
//             until Contrato.Next = 0;

//         Banco.Reset;
//         Banco.SetRange("No. empleado", Empl."No.");
//         if Banco.FindSet then
//             repeat
//                 Clear(BancoTo);
//                 BancoTo.TransferFields(Banco, false);
//                 BancoTo."No. empleado" := Empto."No.";
//                 BancoTo."Cod. Banco" := Banco."Cod. Banco";
//                 BancoTo.ChangeCompany(Empresa);
//                 if not BancoTo.Insert then
//                     BancoTo.Modify;
//             until Banco.Next = 0;

//         HistCabNom.Reset;
//         HistCabNom.SetRange("No. empleado", Empl."No.");
//         if HistCabNom.FindSet then
//             repeat
//                 Clear(HistCabNomTo);
//                 HistCabNomTo.TransferFields(HistCabNom);
//                 HistCabNomTo."No. empleado" := Empto."No.";
//                 HistCabNomTo.ChangeCompany(Empresa);
//                 if HistCabNomTo.Insert then;
//             until HistCabNom.Next = 0;

//         HistLinNom.Reset;
//         HistLinNom.SetRange("No. empleado", Empl."No.");
//         if HistLinNom.FindSet then
//             repeat
//                 Clear(HistLinNomTo);
//                 HistLinNomTo.TransferFields(HistLinNom);
//                 HistLinNomTo."No. empleado" := Empto."No.";
//                 HistLinNomTo.ChangeCompany(Empresa);
//                 if HistLinNomTo.Insert then;
//             until HistLinNom.Next = 0;

//         Vacac.Reset;
//         Vacac.SetRange("No. empleado", Empl."No.");
//         if Vacac.FindSet then
//             repeat
//                 Clear(VacacTo);
//                 VacacTo.TransferFields(Vacac);
//                 VacacTo."No. empleado" := Empto."No.";
//                 VacacTo.ChangeCompany(Empresa);
//                 if VacacTo.Insert then;
//             until Vacac.Next = 0;

//         SaldoISR.Reset;
//         SaldoISR.SetRange("Cód. Empleado", Empl."No.");
//         if SaldoISR.FindSet then
//             repeat
//                 Clear(SaldoISRTo);
//                 SaldoISRTo.TransferFields(SaldoISR);
//                 SaldoISRTo."Cód. Empleado" := Empto."No.";
//                 SaldoISRTo.ChangeCompany(Empresa);
//                 if not SaldoISRTo.Insert then
//                     SaldoISRTo.Modify;
//             until SaldoISR.Next = 0;

//         MovAct.Reset;
//         MovAct.SetRange("No. empleado", Empl."No.");
//         if MovAct.FindSet then
//             repeat
//                 Clear(MovActTo);
//                 MovActTo.TransferFields(MovAct);
//                 MovActTo."No. empleado" := Empto."No.";
//                 MovActTo.ChangeCompany(Empresa);
//                 if not MovActTo.Insert then
//                     MovActTo.Modify;
//             until MovAct.Next = 0;

//         HistSal.Reset;
//         HistSal.SetRange("No. empleado", Empl."No.");
//         if HistSal.FindSet then
//             repeat
//                 Clear(HistSalTo);
//                 HistSalTo.TransferFields(HistSal);
//                 HistSalTo."No. empleado" := Empto."No.";
//                 HistSalTo.ChangeCompany(Empresa);
//                 if HistSalTo.Insert then;
//             until HistSal.Next = 0;

//         AltAddr.Reset;
//         AltAddr.SetRange("Employee No.", Empl."No.");
//         if AltAddr.FindSet then
//             repeat
//                 Clear(AltAddrTo);
//                 AltAddrTo.TransferFields(AltAddr);
//                 AltAddrTo."Employee No." := Empto."No.";
//                 AltAddrTo.ChangeCompany(Empresa);
//                 if not AltAddrTo.Insert then
//                     AltAddrTo.Modify;
//             until AltAddr.Next = 0;

//         Qualif.Reset;
//         Qualif.SetRange("Employee No.", Empl."No.");
//         if Qualif.FindSet then
//             repeat
//                 Clear(QualifTo);
//                 QualifTo.TransferFields(Qualif);
//                 QualifTo."Employee No." := Empto."No.";
//                 QualifTo.ChangeCompany(Empresa);
//                 if not QualifTo.Insert then
//                     QualifTo.Modify;
//             until Qualif.Next = 0;

//         Ausencia.Reset;
//         Ausencia.SetRange("Employee No.", Empl."No.");
//         if Ausencia.FindSet then
//             repeat
//                 Clear(AusenciaTo);
//                 AusenciaTo.TransferFields(Ausencia);
//                 AusenciaTo."Employee No." := Empto."No.";
//                 AusenciaTo.ChangeCompany(Empresa);
//                 if AusenciaTo.Insert then;
//             until Ausencia.Next = 0;

//         RecDiv.Reset;
//         RecDiv.SetRange("Employee No.", Empl."No.");
//         if RecDiv.FindSet then
//             repeat
//                 Clear(RecDivTo);
//                 RecDivTo.TransferFields(RecDiv);
//                 RecDivTo."Employee No." := Empto."No.";
//                 RecDivTo.ChangeCompany(Empresa);
//                 if not RecDivTo.Insert then
//                     RecDivTo.Modify;
//             until RecDiv.Next = 0;

//         InfConf.Reset;
//         InfConf.SetRange("Employee No.", Empl."No.");
//         if InfConf.FindSet then
//             repeat
//                 Clear(InfConfTo);
//                 InfConfTo.TransferFields(InfConf);
//                 InfConfTo."Employee No." := Empto."No.";
//                 InfConfTo.ChangeCompany(Empresa);
//                 if not InfConfTo.Insert then
//                     InfConfTo.Modify;
//             until InfConf.Next = 0;

//         HistCabCxC.Reset;
//         HistCabCxC.SetRange("Employee No.", Empl."No.");
//         if HistCabCxC.FindSet then
//             repeat
//                 HistCabCxCTo.TransferFields(HistCabCxC);
//                 HistCabCxCTo."Employee No." := Empto."No.";
//                 HistCabCxCTo.ChangeCompany(Empresa);
//                 if not HistCabCxCTo.Insert then;
//             until HistCabCxC.Next = 0;
//         HistLinCxC.Reset;
//         HistLinCxC.SetRange("Código Empleado", Empl."No.");
//         if HistLinCxC.FindSet then
//             repeat
//                 HistLinCxCTo.TransferFields(HistLinCxC);
//                 HistLinCxCTo."Código Empleado" := Empto."No.";
//                 HistLinCxCTo.ChangeCompany(Empresa);
//                 if not HistLinCxCTo.Insert then;
//             until HistLinCxC.Next = 0;

//         HistAccepersonal.Reset;
//         HistAccepersonal.SetRange("No. empleado", Empto."No.");
//         if HistAccepersonal.FindSet then
//             repeat
//                 HistAccepersonalTo.TransferFields(HistAccepersonal);
//                 HistAccepersonalTo.ChangeCompany(Empresa);
//                 if HistAccepersonalTo.Insert then;
//             until HistAccepersonal.Next = 0;

//         HistAccepersonal.Init;
//         HistAccepersonal.TransferFields(Accionesdepersonal);
//         HistAccepersonal.ChangeCompany(Empresa);
//         if HistAccepersonal.Insert then;
//     end;


//     procedure CalculoEntreFechaDotNet(TipoFecha: Code[6]; FechaIni: DateTime; FechaFin: DateTime): Integer
//     var
//         DateandTime: DotNet DateAndTime;
//         DayOfWeekInput: DotNet FirstDayOfWeek;
//         WeekOfYearInput: DotNet FirstWeekOfYear;
//     begin
//         if TipoFecha = '' then
//             TipoFecha := 'YYYY';

//         exit(DateandTime.DateDiff(TipoFecha, FechaIni, FechaFin, DayOfWeekInput, WeekOfYearInput));
//     end;


//     procedure VacacionesporVencer() Vacaciones: Decimal
//     var
//         HistoricoVacaciones: Record "Historico Vacaciones";
//         Contar: Boolean;
//     begin
//         Vacaciones := 0;
//         Empl.Reset;
//         Empl.SetRange(Status, Empl.Status::Active);
//         if Empl.FindSet then
//             repeat
//                 Contar := false;
//                 HistoricoVacaciones.Reset;
//                 HistoricoVacaciones.SetRange("No. empleado", Empl."No.");
//                 HistoricoVacaciones.SetFilter("Fecha Fin", '<%1', CalcDate('+60D', Today));
//                 if HistoricoVacaciones.FindSet then begin
//                     HistoricoVacaciones.CalcSums(Dias);
//                     if HistoricoVacaciones.Dias > 0 then
//                         Contar := true;
//                 end;
//                 if Contar then
//                     Vacaciones += 1
//             until Empl.Next = 0;
//         ;
//     end;


//     procedure MuestraVacporVencer()
//     var
//         HistoricoVacaciones: Record "Historico Vacaciones";
//         pEmployeeList: Page "Employee List";
//     begin
//         Empl.Reset;
//         Empl.SetRange(Status, Empl.Status::Active);
//         if Empl.FindSet then
//             repeat
//                 HistoricoVacaciones.Reset;
//                 HistoricoVacaciones.SetRange("No. empleado", Empl."No.");
//                 HistoricoVacaciones.SetFilter("Fecha Fin", '<%1', CalcDate('+60D', Today));
//                 if HistoricoVacaciones.FindSet then begin
//                     HistoricoVacaciones.CalcSums(Dias);
//                     if HistoricoVacaciones.Dias > 0 then
//                         Empl.Mark(true);
//                 end;
//             until Empl.Next = 0;

//         Empl.MarkedOnly(true);
//         pEmployeeList.SetTableView(Empl);
//         pEmployeeList.RunModal;
//         Clear(pEmployeeList);
//     end;


//     procedure AniversarioEmpleados() TotalEmp: Decimal
//     var
//         Contar: Boolean;
//     begin
//         AnoInicio := Date2DMY(Today, 3);
//         MesInicio := Date2DMY(Today, 2);
//         Empl.Reset;
//         Empl.SetRange(Status, Empl.Status::Active);
//         Empl.SetFilter("Employment Date", '<>%1', 0D);
//         if Empl.FindSet then
//             repeat
//                 AnoFin := Date2DMY(Empl."Employment Date", 3);
//                 MesFin := Date2DMY(Empl."Employment Date", 2);
//                 if (AnoFin <> AnoInicio) and (MesFin = MesInicio) then
//                     TotalEmp += 1;
//             until Empl.Next = 0;
//     end;


//     procedure MuestraAniversarioEmpl()
//     var
//         pEmployeeList: Page "Employee List";
//     begin
//         AnoInicio := Date2DMY(Today, 3);
//         MesInicio := Date2DMY(Today, 2);
//         Empl.Reset;
//         Empl.SetRange(Status, Empl.Status::Active);
//         Empl.SetFilter("Employment Date", '<>%1', 0D);
//         if Empl.FindSet then
//             repeat
//                 AnoFin := Date2DMY(Empl."Employment Date", 3);
//                 MesFin := Date2DMY(Empl."Employment Date", 2);
//                 if (AnoFin <> AnoInicio) and (MesFin = MesInicio) then
//                     Empl.Mark(true);
//             until Empl.Next = 0;

//         Empl.MarkedOnly(true);
//         pEmployeeList.SetTableView(Empl);
//         pEmployeeList.RunModal;
//         Clear(pEmployeeList);
//     end;


//     procedure GetBirthdays(var Noticias: Text[250])
//     var
//         Emp: Record Employee;
//         PrimeraVez: Boolean;
//         Contador: Integer;
//         Contador2: Integer;
//     begin
//         PrimeraVez := true;
//         Contador := 0;
//         Contador2 := 0;

//         Emp.Reset;
//         Emp.SetCurrentKey("Mes Nacimiento", "Dia nacimiento");
//         Emp.SetRange("Mes Nacimiento", Date2DMY(Today, 2));
//         Emp.SetRange("Dia nacimiento", Date2DMY(Today, 1));
//         Contador := Emp.Count;
//         if Emp.FindSet then
//             repeat
//                 Contador2 += 1;
//                 if Contador2 = 1 then
//                     Noticias := Emp."Full Name"
//                 else
//                     if Contador = Contador2 then
//                         Noticias += ' y ' + Emp."Full Name"
//                     else
//                         Noticias += ', ' + Emp."Full Name";
//             until Emp.Next = 0;
//     end;
// }

