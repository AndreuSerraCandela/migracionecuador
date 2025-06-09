// codeunit 76035 "Genera formatos elect. legales"
// {

//     trigger OnRun()
//     begin
//         //RDAutodeterminacion(12,2018,'100');
//     end;

//     var
//         ConfContab: Record "General Ledger Setup";
//         ConfNomina: Record "Configuracion nominas";
//         Empl: Record Employee;
//         EC: Record "Empresas Cotizacion";
//         HCN: Record "Historico Cab. nomina";
//         Fecha: Record Date;
//         EmpRel: Record "Relacion Empresas Empleados";
//         TipoNom: Record "Tipos de nominas";
//         EmpresaCot: Record "Empresas Cotizacion";
//         FuncNom: Codeunit "Funciones Nomina";
//         ClientTypeManagement: Codeunit ClientTypeManagement;
//         Archivo: File;
//         PathENV: Text;
//         FileVar: File;
//         IStream: InStream;
//         StreamOut: OutStream;
//         Lin_Body: Text[366];
//         Lin_Body_DGT: Text[527];
//         CERO: Text[100];
//         Blanco: Text[30];
//         Window: Dialog;
//         CounterTotal: Integer;
//         Counter: Integer;
//         NombreArchivo: Text[1024];
//         NombreArchivo2: Text[1024];
//         FileSystemObject: Automation;
//         DestinationFileName: Text[200];
//         PrimeraVez: Boolean;
//         SecuenciaTrans: Code[10];
//         FechaTrans: Date;
//         Text001: Label 'Generating file #1########## @2@@@@@@@@@@@@@';
//         CantLineas: Integer;
//         Text002: Label 'File %1 has been generated';
//         RNC: Code[13];
//         Text003: Label ', please check';
//         Text004: Label 'File downloaded';
//         Err001: Label 'Payroll key must have a length of 3 positions';
//         CalcFecha: Label '+1Y';


//     procedure RDAutodeterminacion(var HCN: Record "Historico Cab. nomina"; TSSAno: Integer; ClaveNomina: Code[3])
//     var
//         CabNomina: Record "Historico Cab. nomina";
//         HLN: Record "Historico Lin. nomina";
//         SaldosFavor: Record "Saldos a favor ISR";
//         HistAccionesdepersonal: Record "Hist. Acciones de personal";
//         EmployeeAbsence: Record "Employee Absence";
//         CauseofAbsence: Record "Cause of Absence";
//         Conceptossalariales: Record "Conceptos salariales";
//         SalarioCotizable: Decimal;
//         SalarioISR: Decimal;
//         SalarioInfotep: Decimal;
//         OtrasRemuneraciones: Decimal;
//         RemOtrosAgentes: Decimal;
//         IngresosExentos: Decimal;
//         SaldoFavorISR: Decimal;
//         Preaviso_Cesantia: Decimal;
//         Regalia: Decimal;
//     begin
//         ConfNomina.Get();
//         ConfContab.Get();
//         TipoNom.Reset;
//         TipoNom.SetRange("Tipo de nomina", TipoNom."Tipo de nomina"::Regular);
//         TipoNom.FindFirst;
//         TipoNom.TestField("Dia inicio 1ra");

//         if StrLen(ClaveNomina) < 3 then
//             Error(Err001);
//         EC.FindFirst;
//         EC.TestField("RNC/CED");
//         RNC := DelChr(EC."RNC/CED", '=', '-');

//         Blanco := ' ';
//         CERO := '0';
//         PrimeraVez := true;
//         Empl.Init;
//         CantLineas := 1;
//         ConfNomina.TestField("Path Archivos Electronicos");

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         PathENV := TemporaryPath;
//         FechaTrans := HCN.GetRangeMax(Período);

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(FechaTrans, 2), Date2DMY(FechaTrans, 3)));
//         Fecha.FindFirst;

//         NombreArchivo := 'AM_' + RNC + '_' + Format(FechaTrans, 0, '<Month,2>') + Format(FechaTrans, 0, '<Year4>') + '.txt';
//         NombreArchivo2 := NombreArchivo;
//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Creo la cabecera
//         Lin_Body := 'E';
//         Lin_Body += 'AM';
//         Lin_Body += Format(Blanco, 11 - StrLen(RNC), '<Filler character, >') + RNC;
//         Lin_Body += Format(FechaTrans, 0, '<Month,2><Year4>');
//         Archivo.Write(Lin_Body);

//         FechaTrans := HCN.GetRangeMin(Período);

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(FechaTrans, 2), Date2DMY(FechaTrans, 3)));
//         Fecha.FindFirst;

//         CabNomina.CopyFilters(HCN);

//         HCN.Reset;
//         HCN.SetRange(Período, FechaTrans, Fecha."Period End");
//         if CabNomina.GetFilter("No. empleado") <> '' then
//             HCN.SetFilter("No. empleado", CabNomina.GetFilter("No. empleado"));
//         CounterTotal := HCN.Count;
//         Window.Open(Text001);
//         HCN.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, HLN."No. empleado");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//             if HCN."No. empleado" <> Empl."No." then begin
//                 SalarioCotizable := 0;
//                 SalarioISR := 0;
//                 OtrasRemuneraciones := 0;
//                 SalarioInfotep := 0;
//                 Preaviso_Cesantia := 0;
//                 Regalia := 0;
//                 Empl.Get(HCN."No. empleado");
//                 Empl.TestField("Birth Date");
//                 Empl.TestField("Document ID");
//                 if not Empl."Excluído Cotización TSS" then begin
//                     //Creo el detalle
//                     Clear(Lin_Body);
//                     Lin_Body := 'D';
//                     Lin_Body += ClaveNomina;
//                     case Empl."Document Type" of
//                         0: //Cedula
//                             Lin_Body += 'C';
//                         1: //Pasaporte
//                             Lin_Body += 'P';
//                         else
//                             Lin_Body += 'N';
//                     end;

//                     Empl."Document ID" := DelChr(Empl."Document ID", '=', '-');
//                     Empl."First Name" := FuncNom.Ascii2Ansi(Empl."First Name");
//                     Empl."Middle Name" := FuncNom.Ascii2Ansi(Empl."Middle Name");
//                     Empl."Last Name" := FuncNom.Ascii2Ansi(Empl."Last Name");
//                     Empl."Second Last Name" := FuncNom.Ascii2Ansi(Empl."Second Last Name");

//                     if Empl."Document Type" <> Empl."Document Type"::"Cédula" then begin
//                         Empl.TestField("Social Security No.");
//                         Lin_Body += CopyStr(Empl."Social Security No." + PadStr(Blanco, 25 - StrLen(Empl."Social Security No.")), 1, 25);
//                     end
//                     else
//                         Lin_Body += CopyStr(Empl."Document ID" + PadStr(Blanco, 25 - StrLen(Empl."Document ID")), 1, 25);
//                     if StrLen(Empl."First Name" + ' ' + Empl."Middle Name") <= 50 then
//                         Lin_Body += Empl."First Name" + ' ' + Empl."Middle Name" + Format(Blanco, 50 - StrLen(Empl."First Name" + ' ' + Empl."Middle Name"), '<Filler character, >')
//                     else
//                         Lin_Body += CopyStr(Empl."First Name" + ' ' + Empl."Middle Name", 1, 50);
//                     Lin_Body += Empl."Last Name" + Format(Blanco, 40 - StrLen(Empl."Last Name"), '<Filler character, >');
//                     Lin_Body += Empl."Second Last Name" + Format(Blanco, 40 - StrLen(Empl."Second Last Name"), '<Filler character, >');
//                     case Empl.Gender of
//                         1: //Femenino
//                             Lin_Body += 'F'
//                         else
//                             Lin_Body += 'M';
//                     end;

//                     Lin_Body += Format(Empl."Birth Date", 0, '<Day,2><Month,2><Year4>');
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     // HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     if HLN.FindSet() then
//                         repeat
//                             Conceptossalariales.Get(HLN."Concepto salarial");
//                             if (not Empl."Excluído Cotización TSS") and (Conceptossalariales."Sujeto Cotizacion") then
//                                 SalarioCotizable += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;

//                     Lin_Body += PadStr('', 16 - StrLen(Format(SalarioCotizable, 0, '<Integer><Decimals,3>')), CERO) + Format(SalarioCotizable, 0, '<Integer><Decimals,3>');
//                     SalarioCotizable := 0; //Para el campo de aporte voluntario
//                     Lin_Body += PadStr('', 16 - StrLen(Format(SalarioCotizable, 0, '<Integer><Decimals,3>')), CERO) + Format(SalarioCotizable, 0, '<Integer><Decimals,3>');

//                     //ISR
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     //HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Cotiza ISR", true);
//                     HLN.SetRange("Salario Base", true);
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     if HLN.FindSet() then
//                         repeat
//                             if not Empl."Excluído Cotización ISR" then
//                                 SalarioISR += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;
//                     Lin_Body += PadStr('', 16 - StrLen(Format(SalarioISR, 0, '<Integer><Decimals,3>')), CERO) + Format(SalarioISR, 0, '<Integer><Decimals,3>');

//                     //Otras remuneraciones
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     // HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Cotiza ISR", true);
//                     HLN.SetRange("Salario Base", false);
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     if HLN.FindSet() then
//                         repeat
//                             OtrasRemuneraciones += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;
//                     Lin_Body += PadStr('', 16 - StrLen(Format(OtrasRemuneraciones, 0, '<Integer><Decimals,3>')), CERO) + Format(OtrasRemuneraciones, 0, '<Integer><Decimals,3>');

//                     RemOtrosAgentes := 0;
//                     EmpRel.SetRange("Cod. Empleado", HCN."No. empleado");
//                     if EmpRel.FindSet() then
//                         repeat
//                             Clear(HLN);
//                             HLN.ChangeCompany(EmpRel.Empresa);
//                             HLN.SetRange("No. empleado", EmpRel."Cod. Empleado");
//                             //HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                             HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                             HLN.SetRange("Cotiza ISR", true);
//                             //HLN.SETRANGE("Tipo concepto",HLN."Tipo concepto"::Ingresos);
//                             if HLN.FindSet() then
//                                 repeat
//                                     RemOtrosAgentes += Round(HLN.Total, 0.01);
//                                 until HLN.Next = 0;
//                         until EmpRel.Next = 0;
//                     RemOtrosAgentes += Empl."Salario Empresas Externas";

//                     //Agente de retencion
//                     EmpresaCot.Get(Empl.Company);
//                     if RemOtrosAgentes <> 0 then begin
//                         Empl."RNC Agente de Retencion ISR" := DelChr(Empl."RNC Agente de Retencion ISR", '=', '-');
//                         if Empl."RNC Agente de Retencion ISR" = '' then
//                             Empl."RNC Agente de Retencion ISR" := DelChr(EmpresaCot."RNC/CED", '=', '-');
//                     end;


//                     Lin_Body += CopyStr(Empl."RNC Agente de Retencion ISR" + PadStr(Blanco, 11 - StrLen(Empl."RNC Agente de Retencion ISR")), 1, 11);
//                     Lin_Body += PadStr('', 16 - StrLen(Format(RemOtrosAgentes, 0, '<Integer><Decimals,3>')), CERO) + Format(RemOtrosAgentes, 0, '<Integer><Decimals,3>');

//                     //Ingresos exentos
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     //HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Cotiza ISR", false);
//                     HLN.SetRange("Sujeto Cotización", false);
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     HLN.SetFilter("Concepto salarial", '<>%1&<>%2&<>%3&<>%4', ConfNomina."Concepto Regalia", ConfNomina."Concepto Cesantia", ConfNomina."Concepto Preaviso", ConfNomina."Concepto Dieta");
//                     if HLN.FindSet() then
//                         repeat
//                             IngresosExentos += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;
//                     Lin_Body += PadStr('', 16 - StrLen(Format(IngresosExentos, 0, '<Integer><Decimals,3>')), CERO) + Format(IngresosExentos, 0, '<Integer><Decimals,3>');
//                     //      IF IngresosExentos <> 0 THEN
//                     //         ERROR('aqui');
//                     //GRN Busco el saldo a favor
//                     SaldosFavor.Reset;
//                     SaldosFavor.SetRange(Ano, HCN.Ano);
//                     SaldosFavor.SetRange("Cód. Empleado", HCN."No. empleado");
//                     if SaldosFavor.FindFirst then
//                         SaldoFavorISR := Round(SaldosFavor."Importe Pendiente", 0.01);
//                     Lin_Body += PadStr('', 16 - StrLen(Format(SaldoFavorISR, 0, '<Integer><Decimals,3>')), CERO) + Format(SaldoFavorISR, 0, '<Integer><Decimals,3>');

//                     //Salario cotizable Infotep
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     //HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Cotiza Infotep", true);
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     if HLN.FindSet() then
//                         repeat
//                             SalarioInfotep += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;
//                     Lin_Body += PadStr('', 16 - StrLen(Format(SalarioInfotep, 0, '<Integer><Decimals,3>')), CERO) + Format(SalarioInfotep, 0, '<Integer><Decimals,3>');

//                     //Para los tipos de ingresos
//                     if (Empl."Employment Date" > Fecha."Period Start") or
//                        (Empl."Termination Date" <> 0D) or (Empl."Fin contrato" <> 0D) then
//                         Lin_Body += '0004'
//                     else
//                         if Empl."Tipo pago" = Empl."Tipo pago"::"Por hora" then
//                             Lin_Body += '0003'
//                         else
//                             if Empl."Tipo Empleado" = Empl."Tipo Empleado"::Temporal then
//                                 Lin_Body += '0002'
//                             else
//                                 Lin_Body += '0001';

//                     //Regalia
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     //HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Concepto salarial", ConfNomina."Concepto Regalia");
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     if HLN.FindSet() then
//                         repeat
//                             Regalia += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;
//                     Lin_Body += '01' + PadStr('', 16 - StrLen(Format(Regalia, 0, '<Integer><Decimals,3>')), CERO) + Format(Regalia, 0, '<Integer><Decimals,3>');

//                     //Preaviso, cesantia,viaticos, indemnizaciones
//                     Clear(HLN);
//                     HLN.SetRange("No. empleado", HCN."No. empleado");
//                     //HLN.SETRANGE("Tipo de nomina",HCN."Tipo de nomina");
//                     HLN.SetRange(Período, Fecha."Period Start", Fecha."Period End");
//                     HLN.SetRange("Cotiza ISR", false);
//                     HLN.SetRange("Sujeto Cotización", false);
//                     HLN.SetRange("Tipo concepto", HLN."Tipo concepto"::Ingresos);
//                     HLN.SetFilter("Concepto salarial", '%1|%2|%3', ConfNomina."Concepto Cesantia", ConfNomina."Concepto Preaviso", ConfNomina."Concepto Dieta");
//                     if HLN.FindSet() then
//                         repeat
//                             Preaviso_Cesantia += Round(HLN.Total, 0.01);
//                         until HLN.Next = 0;
//                     Lin_Body += '02' + PadStr('', 16 - StrLen(Format(Preaviso_Cesantia, 0, '<Integer><Decimals,3>')), CERO) + Format(Preaviso_Cesantia, 0, '<Integer><Decimals,3>');

//                     //Pension alimenticia
//                     //Lin_Body += PADSTR('',16 - STRLEN(FORMAT(Preaviso_Cesantia,0,'<Integer><Decimals,3>')),CERO) + FORMAT(IngresosExentos,0,'<Integer><Decimals,3>');
//                     Lin_Body += '030000000000000.00';

//                     Archivo.Write(Lin_Body);

//                     CantLineas += 1;
//                 end;
//             end;
//         until HCN.Next = 0;


//         //Pie de archivo
//         Clear(Lin_Body);
//         Lin_Body += 'S';
//         CantLineas += 1;
//         Lin_Body += PadStr('', 6 - StrLen(Format(CantLineas, 0, '<Integer>')), CERO) + Format(CantLineas, 0, '<Integer>');
//         Archivo.Write(Lin_Body);
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'TSS\' + NombreArchivo2;
//         RenameFile;

//         Message('%1 %2 %3', Text002, NombreArchivo2, Text003);
//     end;


//     procedure RDDGT3(var DGTMes: Integer; var DGTAno: Integer)
//     var
//         SalarioCotizable: Decimal;
//     begin
//         ConfNomina.Get();
//         ConfContab.Get();
//         EC.FindFirst;
//         EC.TestField("RNC/CED");
//         EC.TestField("ID RNL");
//         RNC := DelChr(EC."RNC/CED", '=', '-');

//         Blanco := ' ';
//         CERO := '0';
//         PrimeraVez := true;
//         Empl.Init;
//         CantLineas := 1;
//         ConfNomina.TestField("Path Archivos Electronicos");

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         FechaTrans := DMY2Date(1, DGTMes, DGTAno);
//         PathENV := TemporaryPath;

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(FechaTrans, 2), Date2DMY(FechaTrans, 3)));
//         Fecha.FindFirst;

//         NombreArchivo := 'DGT3-' + RNC + '-' + Format(FechaTrans, 0, '<Month,2>') + Format(FechaTrans, 0, '<Year4>') + '.txt';
//         NombreArchivo2 := NombreArchivo;
//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Creo la cabecera
//         Lin_Body_DGT := 'E';
//         Lin_Body_DGT += 'T3';
//         Lin_Body_DGT += Format(Blanco, 11 - StrLen(RNC), '<Filler character, >') + RNC;
//         Lin_Body_DGT += Format(FechaTrans, 0, '<Month,2><Year4>');
//         Archivo.Write(Lin_Body_DGT);

//         Empl.Reset;
//         Empl.SetRange("Employment Date", Fecha."Period Start", Fecha."Period End");
//         CounterTotal := Empl.Count;
//         Window.Open(Text001);

//         Empl.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, Empl."No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             //Creo el detalle
//             Clear(Lin_Body_DGT);
//             Lin_Body_DGT := 'D';
//             Lin_Body_DGT += 'NI';
//             case Empl."Document Type" of
//                 0: //Cedula
//                     Lin_Body_DGT += 'C';
//                 1: //Pasaporte
//                     Lin_Body_DGT += 'P';
//                 else
//                     Lin_Body_DGT += 'N';
//             end;
//             Empl."Document ID" := DelChr(Empl."Document ID", '=', '-');
//             Empl."First Name" := FuncNom.Ascii2Ansi(Empl."First Name");
//             Empl."Middle Name" := FuncNom.Ascii2Ansi(Empl."Middle Name");
//             Empl."Last Name" := FuncNom.Ascii2Ansi(Empl."Last Name");
//             Empl."Second Last Name" := FuncNom.Ascii2Ansi(Empl."Second Last Name");

//             Lin_Body_DGT += CopyStr(Empl."Document ID" + PadStr(Blanco, 25 - StrLen(Empl."Document ID")), 1, 25);
//             Lin_Body_DGT += CopyStr(Empl."First Name" + ' ' + Empl."Middle Name" + PadStr(Blanco, 50 - StrLen(Empl."First Name" + ' ' + Empl."Middle Name")), 1, 50);
//             Lin_Body_DGT += CopyStr(Empl."Last Name" + PadStr(Blanco, 40 - StrLen(Empl."Last Name")), 1, 40);
//             Lin_Body_DGT += CopyStr(Empl."Second Last Name" + PadStr(Blanco, 40 - StrLen(Empl."Second Last Name")), 1, 40);
//             Lin_Body_DGT += Format(Empl."Birth Date", 0, '<Day,2><Month,2><Year4>');
//             case Empl.Gender of
//                 1: //Femenino
//                     Lin_Body_DGT += 'F'
//                 else
//                     Lin_Body_DGT += 'M';
//             end;

//             Lin_Body_DGT += Format(Empl."Birth Date", 0, '<Day,2><Month,2><Year4>');
//             Lin_Body_DGT += PadStr('', 16 - StrLen(Format(SalarioCotizable, 0, '<Integer><Decimals,3>')), CERO) + Format(SalarioCotizable, 0, '<Integer><Decimals,3>');
//             Lin_Body_DGT += Format(Empl."Employment Date", 0, '<Day,2><Month,2><Year4>');
//             Lin_Body_DGT += CopyStr(PadStr(Blanco, 6 - StrLen(Empl."Puesto Segun MT")) + Empl."Cod. Puesto MT", 1, 6);
//             Lin_Body_DGT += CopyStr(PadStr(Blanco, 150 - StrLen(Empl."Puesto Segun MT")) + Empl."Puesto Segun MT", 1, 150);
//             //Para calcular las vacaciones
//             if Date2DMY(Empl."Employment Date", 3) = Date2DMY(Today, 3) then begin
//                 Empl."Employment Date" := CalcDate(CalcFecha, Empl."Employment Date");
//                 Lin_Body_DGT += Format(Empl."Employment Date", 0, '<Day,2><Month,2><Year4>');
//             end
//             else begin
//                 Empl."Employment Date" := DMY2Date(Date2DMY(Empl."Employment Date", 1), Date2DMY(Empl."Employment Date", 2), Date2DMY(Today, 3));
//                 Lin_Body_DGT += Format(Empl."Employment Date", 0, '<Day,2><Month,2><Year4>');
//             end;

//             Lin_Body_DGT += PadStr(Blanco, 6); //Turno
//             Lin_Body_DGT += PadStr(Blanco, 2) + CopyStr(EC."ID RNL", MaxStrLen(EC."ID RNL") - 4, 5); // RNL
//             Lin_Body_DGT += PadStr(Blanco, 150); //Observacion
//             Archivo.Write(Lin_Body_DGT);
//             CantLineas += 1;

//         until Empl.Next = 0;


//         //Pie de archivo
//         Clear(Lin_Body_DGT);
//         Lin_Body_DGT += 'S';

//         Lin_Body_DGT += PadStr('', 6 - StrLen(Format(CantLineas, 0, '<Integer>')), CERO) + Format(CantLineas, 0, '<Integer>');
//         Archivo.Write(Lin_Body_DGT);
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'DGT\' + NombreArchivo2;
//         RenameFile;
//         Message('%1 %2 %3', Text002, NombreArchivo2, Text003);
//     end;


//     procedure RDDGT4(var DGTMes: Integer; var DGTAno: Integer)
//     var
//         SalarioCotizable: Decimal;
//         HAP: Record "Hist. Acciones de personal";
//         HayDatos: Boolean;
//     begin
//         ConfNomina.Get();
//         ConfContab.Get();
//         EC.FindFirst;
//         EC.TestField("RNC/CED");
//         EC.TestField("ID RNL");
//         RNC := DelChr(EC."RNC/CED", '=', '-');

//         Blanco := ' ';
//         CERO := '0';
//         PrimeraVez := true;
//         Empl.Init;
//         CantLineas := 1;
//         ConfNomina.TestField("Path Archivos Electronicos");

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         FechaTrans := DMY2Date(1, DGTMes, DGTAno);
//         PathENV := TemporaryPath;

//         Fecha.Reset;
//         Fecha.SetRange("Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange("Period Start", DMY2Date(1, Date2DMY(FechaTrans, 2), Date2DMY(FechaTrans, 3)));
//         Fecha.FindFirst;

//         NombreArchivo := 'DGT4-' + RNC + '-' + Format(FechaTrans, 0, '<Month,2>') + Format(FechaTrans, 0, '<Year4>') + '.txt';
//         NombreArchivo2 := NombreArchivo;
//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Creo la cabecera
//         Lin_Body_DGT := 'E';
//         Lin_Body_DGT += 'T4';
//         Lin_Body_DGT += Format(Blanco, 11 - StrLen(RNC), '<Filler character, >') + RNC;
//         Lin_Body_DGT += Format(FechaTrans, 0, '<Month,2><Year4>');
//         Archivo.Write(Lin_Body_DGT);

//         Empl.Reset;
//         Empl.SetRange("Employment Date", Fecha."Period Start", Fecha."Period End");
//         CounterTotal := Empl.Count;
//         Window.Open(Text001);

//         Empl.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, Empl."No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//             HayDatos := false;

//             //Creo el detalle
//             Clear(Lin_Body_DGT);
//             Lin_Body_DGT := 'D';

//             if Empl."Employment Date" >= Fecha."Period Start" then begin
//                 HayDatos := true;
//                 Lin_Body_DGT += 'NI';
//             end
//             else
//                 if Empl."Termination Date" >= Fecha."Period Start" then begin
//                     HayDatos := true;
//                     Lin_Body_DGT += 'NS';
//                 end
//                 else begin
//                     HAP.Reset;
//                     HAP.SetRange("No. empleado", Empl."No.");
//                     HAP.SetRange("Fecha efectividad", Fecha."Period Start", Fecha."Period End");
//                     if HAP.FindFirst then begin
//                         Lin_Body_DGT += 'NC';
//                         HayDatos := true;
//                     end
//                     else
//                         HAP.Init;
//                 end;

//             if HayDatos then begin
//                 case Empl."Document Type" of
//                     0: //Cedula
//                         Lin_Body_DGT += 'C';
//                     1: //Pasaporte
//                         Lin_Body_DGT += 'P';
//                     else
//                         Lin_Body_DGT += 'N';
//                 end;
//                 Empl."Document ID" := DelChr(Empl."Document ID", '=', '-');
//                 Empl."First Name" := FuncNom.Ascii2Ansi(Empl."First Name");
//                 Empl."Middle Name" := FuncNom.Ascii2Ansi(Empl."Middle Name");
//                 Empl."Last Name" := FuncNom.Ascii2Ansi(Empl."Last Name");
//                 Empl."Second Last Name" := FuncNom.Ascii2Ansi(Empl."Second Last Name");

//                 Lin_Body_DGT += CopyStr(Empl."Document ID" + PadStr(Blanco, 25 - StrLen(Empl."Document ID")), 1, 25);
//                 Lin_Body_DGT += CopyStr(Empl."First Name" + ' ' + Empl."Middle Name" + PadStr(Blanco, 50 - StrLen(Empl."First Name" + ' ' + Empl."Middle Name")), 1, 50);
//                 Lin_Body_DGT += CopyStr(Empl."Last Name" + PadStr(Blanco, 40 - StrLen(Empl."Last Name")), 1, 40);
//                 Lin_Body_DGT += CopyStr(Empl."Second Last Name" + PadStr(Blanco, 40 - StrLen(Empl."Second Last Name")), 1, 40);
//                 Lin_Body_DGT += Format(Empl."Birth Date", 0, '<Day,2><Month,2><Year4>');
//                 case Empl.Gender of
//                     1: //Femenino
//                         Lin_Body_DGT += 'F'
//                     else
//                         Lin_Body_DGT += 'M';
//                 end;

//                 Lin_Body_DGT += Format(Empl."Birth Date", 0, '<Day,2><Month,2><Year4>');
//                 Lin_Body_DGT += PadStr('', 16 - StrLen(Format(SalarioCotizable, 0, '<Integer><Decimals,3>')), CERO) + Format(SalarioCotizable, 0, '<Integer><Decimals,3>');
//                 Lin_Body_DGT += Format(Empl."Employment Date", 0, '<Day,2><Month,2><Year4>');
//                 if Empl."Termination Date" <> 0D then
//                     Lin_Body_DGT += Format(Empl."Termination Date", 0, '<Day,2><Month,2><Year4>')
//                 else
//                     Lin_Body_DGT += '00000000';
//                 Lin_Body_DGT += CopyStr(PadStr(Blanco, 6 - StrLen(Empl."Cod. Puesto MT")) + Empl."Cod. Puesto MT", 1, 6);
//                 Lin_Body_DGT += CopyStr(PadStr(Blanco, 150 - StrLen(Empl."Puesto Segun MT")) + Empl."Puesto Segun MT", 1, 150);
//                 //Para calcular las vacaciones
//                 if Date2DMY(Empl."Employment Date", 3) = Date2DMY(Today, 3) then begin
//                     Empl."Employment Date" := CalcDate(CalcFecha, Empl."Employment Date");
//                     Lin_Body_DGT += Format(Empl."Employment Date", 0, '<Day,2><Month,2><Year4>');
//                 end;

//                 Lin_Body_DGT += PadStr(Blanco, 6); //Turno
//                 Lin_Body_DGT += PadStr(Blanco, 2) + CopyStr(EC."ID RNL", MaxStrLen(EC."ID RNL") - 4, 5); // RNL
//                 Lin_Body_DGT += CopyStr(PadStr(Blanco, 3 - StrLen(Empl."Cod. Nacionalidad MT")) + Empl."Cod. Nacionalidad MT", 1, 3);
//                 if HAP."Fecha accion" <> 0D then
//                     Lin_Body_DGT += Format(HAP."Fecha accion", 0, '<Day,2><Month,2><Year4>')
//                 else
//                     Lin_Body_DGT += '00000000';
//                 Archivo.Write(Lin_Body_DGT);
//                 CantLineas += 1;
//             end;
//         until Empl.Next = 0;


//         //Pie de archivo
//         Clear(Lin_Body_DGT);
//         Lin_Body_DGT += 'S';

//         Lin_Body_DGT += PadStr('', 6 - StrLen(Format(CantLineas, 0, '<Integer>')), CERO) + Format(CantLineas, 0, '<Integer>');
//         Archivo.Write(Lin_Body_DGT);
//         Archivo.Close;

//         if ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Windows then begin
//             NombreArchivo := TemporaryPath + NombreArchivo;
//             NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'DGT\' + NombreArchivo2;
//             RenameFile;
//             Message('%1 %2 %3', Text002, NombreArchivo2, Text003);
//         end
//         else
//             Message(Text004);
//     end;


//     procedure RenameFile()
//     var
//         FileManagement: Codeunit "File Management";
//     begin
//         FileManagement.DownloadToFile(NombreArchivo, NombreArchivo2);
//     end;
// }

