// codeunit 76036 "Genera Formatos  E. Nomina BO"
// {
//     Permissions = TableData Vendor = rimd,
//                   TableData "Gen. Journal Line" = rimd,
//                   TableData "General Ledger Setup" = rimd,
//                   TableData Employee = rimd;
//     TableNo = "Historico Cab. nomina";

//     trigger OnRun()
//     begin
//         GHCN.Copy(Rec);

//         case GHCN."Tipo Archivo" of
//             1:
//                 FormatoBanco;
//             2:
//                 NovedadesCambioSueldo;
//             3:
//                 NovedadesVarSueldo;
//             4:
//                 FondosReservaMensual;
//         end;
//     end;

//     var
//         ConfNomina: Record "Configuracion nominas";
//         ConfContab: Record "General Ledger Setup";
//         Empl: Record Employee;
//         EC: Record "Empresas Cotizacion";
//         GHCN: Record "Historico Cab. nomina";
//         Fecha: Record Date;
//         BcoACH: Record "Bancos ACH Nomina";
//         VLE: Record "Vendor Ledger Entry";
//         BankAccount: Record "Bank Account";
//         Archivo: File;
//         FileVar: File;
//         IStream: InStream;
//         StreamOut: OutStream;
//         Lin_Body: Text[252];
//         CERO: Text[100];
//         Blanco: Text[30];
//         Window: Dialog;
//         Text001: Label 'Generating file #1########## @2@@@@@@@@@@@@@';
//         CounterTotal: Integer;
//         Counter: Integer;
//         SettleDate: Date;
//         Err002: Label 'You must specify the Bank as balance account';
//         NombreArchivo: Text[1024];
//         NombreArchivo2: Text[1024];
//         MagicPath: Text[180];
//         FileToDownload: Text[180];
//         FileSystemObject: Automation;
//         DestinationFileName: Text[200];
//         recDimEntry: Record "Dimension Set Entry";


//     procedure FormatoBanco()
//     var
//         DIPG: Record "Distrib. Ingreso Pagos Elect.";
//         HCN: Record "Historico Cab. nomina";
//         HLN: Record "Historico Lin. nomina";
//         Banco: Record "Bank Account";
//         NetoBanco: Decimal;
//     begin
//         Blanco := ' ';
//         CERO := '0';
//         EC.Get(GHCN."Empresa cotización");
//         EC.TestField("Identificador Empresa");

//         ConfNomina.Get();
//         ConfContab.Get();
//         ConfNomina.TestField("Path Archivos Electronicos");

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         Archivo.TextMode(true);
//         NombreArchivo := 'c:\temp\TRANSFER.TXT';
//         NombreArchivo2 := (ConfNomina."Path Archivos Electronicos" + 'transfer.txt');

//         Archivo.Create(NombreArchivo);
//         Archivo.Trunc;

//         HCN.Reset;
//         HCN.SetFilter(Período, GHCN.GetFilter(Período));
//         HCN.SetFilter("Tipo Nomina", GHCN.GetFilter("Tipo Nomina"));
//         HCN.SetRange("Forma de Cobro", 3);// Transferencias de banco
//         CounterTotal := HCN.Count;
//         Window.Open(Text001);

//         if HCN.FindSet then
//             repeat
//                 Counter := Counter + 1;
//                 Window.Update(1, HCN."No. empleado");
//                 Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//                 Empl.Get(HCN."No. empleado");
//                 DIPG.Reset;
//                 DIPG.SetRange("No. empleado", HCN."No. empleado");
//                 DIPG.FindFirst;
//                 Clear(Lin_Body);
//                 Lin_Body := 'D01';
//                 Lin_Body += EC."Identificador Empresa";
//                 //      CERO     := PADSTR(CERO,10,'0');
//                 Clear(CERO);
//                 if StrLen(DIPG."Numero Cuenta") <= 10 then
//                     CERO := PadStr(CERO, 10 - StrLen(DIPG."Numero Cuenta"), '0')
//                 else
//                     CERO := CopyStr(DIPG."Numero Cuenta", 1, 10);
//                 Lin_Body += CERO + Format(DIPG."Numero Cuenta");
//                 Lin_Body += '017';
//                 Clear(CERO);
//                 CERO := PadStr(CERO, 10 - StrLen(EC.Cuenta), '0');
//                 Lin_Body += CERO + Format(EC.Cuenta);
//                 case DIPG."Tipo Cuenta" of
//                     0:
//                         Lin_Body += 'D';
//                     1:
//                         Lin_Body += 'C';
//                     else
//                         Lin_Body += 'H';
//                 end;
//                 Clear(CERO);
//                 CERO := PadStr(CERO, 50 - StrLen(Empl."Full Name"), ' ');
//                 Lin_Body += Empl."Full Name" + CERO;
//                 Lin_Body += '0';
//                 HCN.CalcFields("Total Ingresos", "Total deducciones");
//                 NetoBanco += HCN."Total Ingresos" - HCN."Total deducciones";
//                 Lin_Body += Format(Round((HCN."Total Ingresos" + HCN."Total deducciones"), ConfContab."Amount Rounding Precision") * 100,
//                                           15, '<integer,15><Filler Character,0>');
//                 Clear(CERO);
//                 CERO := PadStr(CERO, 15, '0');
//                 Lin_Body += CERO;
//                 Lin_Body += '            0                    000';
//                 if Date2DMY(HCN.Fin, 2) > 30 then
//                     HCN.Fin := DMY2Date(30, Date2DMY(HCN.Fin, 2), Date2DMY(HCN.Fin, 3));

//                 Lin_Body += Format(HCN.Fin, 0, '<Year4><Month,2><Day,2>');
//                 Clear(CERO);
//                 CERO := PadStr(CERO, 8, '0');
//                 Lin_Body += CERO;
//                 Clear(CERO);
//                 CERO := PadStr(CERO, 50 - 16, ' ');
//                 Lin_Body += 'PAGO DE SALARIOS' + CERO;
//                 Clear(CERO);
//                 CERO := PadStr(CERO, 14, ' ');
//                 Lin_Body += '1' + CERO;
//                 Lin_Body += Format(HCN.Fin, 0, '<Year4><Month,2><Day,2>');
//                 Lin_Body += Format(Time, 0, '<Hours24><Minutes,2><Seconds,2>');
//                 Clear(CERO);
//                 if StrLen(UserId) < 10 then
//                     CERO := PadStr(CERO, 10 - StrLen(UserId), ' ');

//                 Lin_Body += CopyStr(UserId, 1, 10) + CERO;
//                 Archivo.Write(Lin_Body);
//             until HCN.Next = 0;


//         Clear(Lin_Body);
//         Lin_Body := 'C01';
//         Lin_Body += EC."Identificador Empresa";
//         Clear(CERO);
//         if StrLen(DIPG."Numero Cuenta") <= 10 then
//             CERO := PadStr(CERO, 10 - StrLen(EC.Cuenta), '0')
//         else
//             CERO := CopyStr(EC.Cuenta, 1, 10);

//         Lin_Body += CERO + Format(EC.Cuenta);
//         Lin_Body += '017';
//         Clear(CERO);
//         CERO := PadStr(CERO, 10, '0');
//         Lin_Body += CERO;
//         Lin_Body += 'D';
//         Clear(CERO);
//         CERO := PadStr(CERO, 50 - StrLen(EC."Nombre Empresa cotizacinn"), ' ');
//         Lin_Body += EC."Nombre Empresa cotizacinn" + CERO;
//         Lin_Body += '0';
//         HCN.CalcFields("Total Ingresos", "Total deducciones");
//         Lin_Body += Format(Round((NetoBanco), ConfContab."Amount Rounding Precision") * 100,
//                                   15, '<integer,15><Filler Character,0>');
//         Clear(CERO);
//         CERO := PadStr(CERO, 15, '0');
//         Lin_Body += CERO;
//         Lin_Body += '            0                    000';
//         if Date2DMY(HCN.Fin, 2) > 30 then
//             HCN.Fin := DMY2Date(30, Date2DMY(HCN.Fin, 2), Date2DMY(HCN.Fin, 3));

//         Lin_Body += Format(HCN.Fin, 0, '<Year4><Month,2><Day,2>');
//         Clear(CERO);
//         CERO := PadStr(CERO, 8, '0');
//         Lin_Body += CERO;
//         Clear(CERO);
//         CERO := PadStr(CERO, 50, ' ');
//         Lin_Body += CERO;
//         Clear(CERO);
//         CERO := PadStr(CERO, 15, ' ');
//         Lin_Body += CERO;
//         Lin_Body += Format(HCN.Fin, 0, '<Year4><Month,2><Day,2>');
//         Lin_Body += Format(Time, 0, '<Hours24><Minutes,2><Seconds,2>');
//         Clear(CERO);
//         if StrLen(UserId) < 10 then
//             CERO := PadStr(CERO, 10 - StrLen(UserId), ' ');

//         Lin_Body += CopyStr(UserId, 1, 10) + CERO;
//         Archivo.Write(Lin_Body);

//         Archivo.Close;

//         RenameFile;
//     end;


//     procedure NovedadesCambioSueldo()
//     var
//         HSalario: Record "Acumulado Salarios";
//         CT: Record "Centros de Trabajo";
//     begin
//         /*Archivo para novedades de modificación de sueldo (Aviso de nuevo sueldo)
//         o RUC de la empresa (13 dígitos)
//         o Código de la sucursal (4 dígitos)
//         o Año actual (4 dígitos formato YYYY)
//         o Mes actual (2 dígitos formato MM)
//         o Tipo de movimiento (prefijado como MSU)
//         o Cédula (Actualizada) de identidad del afiliado afectado (10 dígitos)
//         o Nuevo sueldo (14 dígitos)
//         */
//         Blanco := ';';
//         CERO := '0';
//         EC.Get(GHCN."Empresa cotización");
//         ConfNomina.Get();
//         ConfNomina.TestField("Path Archivos Electronicos");
//         ConfNomina.TestField("Secuencia de archivo Batch");
//         ConfNomina."Secuencia de archivo Batch" := IncStr(ConfNomina."Secuencia de archivo Batch");
//         ConfNomina.Modify;

//         Fecha.Reset;
//         Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange(Fecha."Period Start", DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3)));
//         Fecha.FindFirst;

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos") - 1, 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         NombreArchivo := ('c:\temp\' + 'CAMBIO-S-' +
//                           Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') +
//                           Format(WorkDate, 0, '<Day,2>') + EC."Identificador Empresa" + '_01.txt');
//         NombreArchivo2 := (ConfNomina."Path Archivos Electronicos" + 'CAMBIO-S-' +
//                           Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') +
//                           Format(WorkDate, 0, '<Day,2>') + EC."Identificador Empresa" + '_01.txt');

//         Archivo.TextMode(true);
//         /*
//         Archivo.CREATE(ConfNomina."Path Archivos Electronicos" + 'CAMBIO-S-' +
//                        FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                        FORMAT(WORKDATE,0,'<Day,2>') + '.txt');
//         */
//         Archivo.Create(NombreArchivo);
//         Archivo.Trunc;

//         HSalario.Reset;
//         HSalario.SetRange("Fecha Hasta", Fecha."Period Start", NormalDate(Fecha."Period End"));
//         CounterTotal := HSalario.Count;
//         Window.Open(Text001);

//         if HSalario.FindSet then
//             repeat
//                 Counter := Counter + 1;
//                 Window.Update(1, HSalario."No. empleado");
//                 Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//                 Empl.Get(HSalario."No. empleado");
//                 Empl.CalcFields(Salario);

//                 Clear(Lin_Body);
//                 Lin_Body := EC."RNC/CED" + Blanco + Empl."Working Center" + Blanco + Format(WorkDate, 0, '<Year4>') + Blanco +
//                             Format(WorkDate, 0, '<Month,2>') + Blanco + 'MSU' + Blanco + Lin_Body + Format(Empl."Document ID", 10) +
//                             Blanco + Format(Empl.Salario, 14, '<Integer><Decimals,3>') + Blanco + 'O';
//                 Archivo.Write(Lin_Body);
//             until HSalario.Next = 0;

//         Archivo.Close;
//         RenameFile;

//     end;


//     procedure NovedadesVarSueldo()
//     var
//         HCabNomina: Record "Historico Cab. nomina";
//         HLinNomina: Record "Historico Lin. nomina";
//         Acumulado: Decimal;
//     begin
//         /*Archivo para Novedades de Variación de Sueldo (Aviso de variación de sueldo por extras)
//         o RUC de la empresa (13 dígitos)
//         o Código de la sucursal (4 dígitos)
//         o Año actual (4 dígitos formato YYYY)
//         o Mes actual (2 dígitos formato MM)
//         o Tipo de movimiento (prefijado como INS)
//         o Cédula (Actualizada) de identidad del afiliado afectado (10 dígitos)
//         o Valores Extras (máximo 14 dígitos)
//         o Causa. (1 dígito (codificación ver Anexo) )
//         */

//         Blanco := ';';
//         CERO := '0';
//         EC.Get(GHCN."Empresa cotización");
//         ConfNomina.Get();
//         ConfNomina.TestField("Path Archivos Electronicos");
//         ConfNomina.TestField("Secuencia de archivo Batch");
//         ConfNomina."Secuencia de archivo Batch" := IncStr(ConfNomina."Secuencia de archivo Batch");
//         ConfNomina.Modify;

//         Fecha.Reset;
//         Fecha.SetRange(Fecha."Period Type", Fecha."Period Type"::Month);
//         Fecha.SetRange(Fecha."Period Start", DMY2Date(1, Date2DMY(WorkDate, 2), Date2DMY(WorkDate, 3)));
//         Fecha.FindFirst;

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos") - 1, 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         Archivo.TextMode(true);
//         NombreArchivo := 'c:\temp\' + 'VARIACION-S-' +
//                           Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') +
//                           Format(WorkDate, 0, '<Day,2>') + '.txt';

//         NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'VARIACION-S-' +
//                           Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') +
//                           Format(WorkDate, 0, '<Day,2>') + '.txt';

//         /*
//         Archivo.CREATE(ConfNomina."Path Archivos Electronicos" + 'VARIACION-S-' +
//                        FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                        FORMAT(WORKDATE,0,'<Day,2>') + '.txt');
//         */

//         Archivo.Trunc;

//         HCabNomina.Reset;
//         HCabNomina.SetRange("Tipo Nomina", GHCN."Tipo Nomina");
//         HCabNomina.SetRange(Período, GHCN.Período);

//         CounterTotal := HCabNomina.Count;
//         Window.Open(Text001);

//         HCabNomina.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, HCabNomina."No. empleado");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             Empl.Get(HCabNomina."No. empleado");
//             Acumulado := 0;

//             HLinNomina.Reset;
//             HLinNomina.SetRange("No. empleado", HCabNomina."No. empleado");
//             HLinNomina.SetRange("Tipo Nómina", HCabNomina."Tipo Nomina");
//             HLinNomina.SetRange(Período, HCabNomina.Período);
//             HLinNomina.SetRange("Salario Base", false);
//             HLinNomina.SetRange("Sujeto Cotización", true);
//             if HLinNomina.FindSet then
//                 repeat
//                     Acumulado += HLinNomina.Total;
//                 until HLinNomina.Next = 0;

//             if Acumulado <> 0 then begin
//                 Clear(Lin_Body);
//                 Lin_Body := EC."RNC/CED" + Blanco + Empl."Working Center" + Blanco + Format(WorkDate, 0, '<Year4>') + Blanco +
//                             Format(WorkDate, 0, '<Month,2>') + Blanco + 'INS' + Blanco + Lin_Body + Format(Empl."Document ID", 10) +
//                             Blanco + Format(Acumulado, 14, '<Integer><Decimals,3>') + Blanco + 'O';
//                 Archivo.Write(Lin_Body);
//             end;
//         until HCabNomina.Next = 0;
//         Window.Close;
//         Archivo.Close;

//         RenameFile;

//     end;


//     procedure FondosReservaMensual()
//     begin
//         /*Archivo para Fondos de Reserva Mensual (Planilla de Fondos de Reserva Mensual) Nuevo
//         o RUC de la empresa (13 dígitos)
//         o Código de la sucursal (4 dígitos)
//         o Año actual (4 dígitos formato YYYY) Año inicial del periodo de la planilla de fondos de reserva
//         o Mes actual (2 dígitos formato MM) Mes inicial del periodo de la planilla de fondos de reserva
//         o Tipo de movimiento (prefijadoco PFM)
//         o Cédula (Actualizada) de identidad del afiliado afectado (10 dígitos)
//         o Valores sueldo total (máximo 14 dígitos)
//         o Periodo del cual se cancela los fondos de reserva. (YYYY-MM A YYYY-MM) (total 17 lugares entre dígitos, líneas y espacio)
//         o Número de meses laborados (2 dígitos)
//         o Tipo de Periodo (1 dígito). G (Mensual Privado y Público)
//         */

//     end;


//     procedure FormatoBancoDiario(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         GenJnlLine: Record "Gen. Journal Line";
//         Banco: Record "Bank Account";
//         DIPG: Record "Distrib. Ingreso Pagos Elect.";
//         BcoACH: Record "Bancos ACH Nomina";
//         FirstTime: Boolean;
//         BancoAnt: Code[20];
//         Err001: Label 'The bank account must be the same in all the lines, please correct it';
//     begin
//         //Verifico que todas las lineas del diario tengan el mismo banco
//         FirstTime := true;
//         Blanco := ' ';
//         CERO := '0';

//         ConfNomina.Get();
//         ConfNomina.TestField("Path Archivos Electronicos");
//         ConfNomina.TestField("Secuencia de archivo Batch");
//         ConfNomina.TestField("Dimension Empleado");

//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::"Bank Account");
//         GenJnlLine.SetFilter("Account No.", '<>%1', '');
//         if not GenJnlLine.FindFirst then begin
//             GenJnlLine.Reset;
//             GenJnlLine.SetRange("Journal Template Name", CodDiario);
//             GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//             GenJnlLine.SetRange("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
//             GenJnlLine.SetFilter("Bal. Account No.", '<>%1', '');
//             if not GenJnlLine.FindFirst then
//                 Error(Err002);
//         end;

//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.FindSet;
//         repeat
//             if FirstTime then begin
//                 FirstTime := false;
//                 BancoAnt := GenJnlLine."Bal. Account No.";
//             end;
//             if BancoAnt <> GenJnlLine."Bal. Account No." then
//                 Error(Err001);
//         until GenJnlLine.Next = 0;


//         FirstTime := true;

//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::"G/L Account");
//         CounterTotal := GenJnlLine.Count;
//         Window.Open(Text001);
//         GenJnlLine.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, GenJnlLine."Line No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             if FirstTime then begin
//                 FirstTime := false;
//                 recDimEntry.Reset;
//                 recDimEntry.SetRange("Dimension Set ID", GenJnlLine."Dimension Set ID");
//                 recDimEntry.SetRange("Dimension Code", ConfNomina."Dimension Empleado");
//                 recDimEntry.FindFirst;


//                 Empl.Get(recDimEntry."Dimension Value Code"); //Busco el empleado
//                 Empl.TestField(Company);
//                 EC.Get(Empl.Company);

//                 ConfNomina."Secuencia de archivo Batch" := IncStr(ConfNomina."Secuencia de archivo Batch");
//                 ConfNomina.Modify;
//                 if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//                     ConfNomina."Path Archivos Electronicos" += '\';

//                 Archivo.TextMode(true);
//                 NombreArchivo := 'c:\temp\' + 'NCR' +
//                                   Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') +
//                                   Format(WorkDate, 0, '<Day,2>') + EC."Identificador Empresa" + '_01.txt';
//                 NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'NCR' +
//                                   Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') +
//                                   Format(WorkDate, 0, '<Day,2>') + EC."Identificador Empresa" + '_01.txt';
//                 /*
//                 Archivo.CREATE(ConfNomina."Path Archivos Electronicos" + 'NCR' +
//                                FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                                FORMAT(WORKDATE,0,'<Day,2>') + EC."Identificador Empresa" + '_01.txt');
//                 */
//                 Archivo.Create(NombreArchivo);
//                 Archivo.Trunc;
//             end;

//             recDimEntry.Reset;
//             recDimEntry.SetRange("Dimension Set ID", GenJnlLine."Dimension Set ID");
//             recDimEntry.SetRange("Dimension Code", ConfNomina."Dimension Empleado");
//             recDimEntry.FindFirst;

//             Empl.Get(recDimEntry."Dimension Value Code"); //Busco el empleado


//             DIPG.Reset;
//             DIPG.SetRange("No. empleado", Empl."No.");
//             DIPG.FindFirst;
//             Clear(Lin_Body);
//             case DIPG."Tipo Cuenta" of
//                 0:
//                     Lin_Body := 'A'
//                 else
//                     Lin_Body := 'C';
//             end;

//             BcoACH.Get(DIPG."Cod. Banco");
//             if EC.Banco = DIPG."Cod. Banco" then begin
//                 CERO := PadStr(CERO, 10 - StrLen(DIPG."Numero Cuenta"), '0');
//                 Lin_Body += CERO + Format(DIPG."Numero Cuenta");
//                 Lin_Body += Format(Round((GenJnlLine.Amount), 0.01) * 100, 15, '<integer,15><Filler Character,0>');
//                 Lin_Body += 'XXY01';
//                 Lin_Body += Format(Blanco, 38);
//             end
//             else begin
//                 CERO := PadStr(CERO, 10, '0');
//                 Lin_Body += CERO;
//                 Lin_Body += Format(Round((GenJnlLine.Amount), 0.01) * 100, 15, '<integer,15><Filler Character,0>');
//                 Lin_Body += 'XXY01';

//                 Lin_Body += BcoACH."Cod. Institucion Financiera";
//                 CERO := PadStr(CERO, 18 - StrLen(DIPG."Numero Cuenta"), '0');
//                 Lin_Body += CERO + Format(DIPG."Numero Cuenta");
//                 Lin_Body += CopyStr(Empl."Full Name", 1, 18);
//             end;

//             Lin_Body += EC."Identificador Empresa";

//             Lin_Body += Format(Empl."E-Mail", 30);
//             CERO := PadStr(CERO, 10, '0');
//             Lin_Body += Format(CERO, 10); //Informacion del Celular

//             Lin_Body += Format(Blanco, 3);  //Banco Destino para el pago interbancario
//             case Empl."Document Type" of
//                 0: //Cedula
//                     begin
//                         Lin_Body += 'C';
//                         Lin_Body += Format(Empl."Document ID", 13);
//                     end;
//                 1: //Pasaporte
//                     begin
//                         Lin_Body += 'P';
//                         Lin_Body += Format(Empl."Document ID", 13);
//                     end;
//                 else begin
//                     Lin_Body += 'R';
//                     Lin_Body += Format(Empl."Document ID", 13);
//                 end;
//             end;
//             Archivo.Write(Lin_Body);
//         until GenJnlLine.Next = 0;
//         Window.Close;
//         Archivo.Close;

//         RenameFile;

//     end;


//     procedure FormatoPagoProveedores(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         Err001: Label 'The bank account must be the same in all the lines, please correct it';
//         GenJnlLine: Record "Gen. Journal Line";
//         VendorBank: Record "Vendor Bank Account";
//         BcoACH: Record "Bancos ACH Nomina";
//         Vendor: Record Vendor;
//         ExportPaymentsACH: Codeunit "Export Payments (ACH)";
//         ExportPaymentsRB: Codeunit "Export Payments (RB)";
//         FirstTime: Boolean;
//         FirstTime2: Boolean;
//         BancoAnt: Code[20];
//         TAB: Char;
//         TextMes: Code[3];
//         NoLin: Integer;
//         CodBco: Code[20];
//         ExportAmount: Decimal;
//         TraceNumber: Code[30];
//         SettleDate: Date;
//         Lin_Detail: Text[1024];
//         Seq: Integer;
//     begin
//         FirstTime := true;
//         Blanco := ' ';
//         CERO := '0';
//         TAB := 9;

//         EC.FindFirst;

//         //Verifico que todas las lineas del diario tengan el mismo banco
//         ConfNomina.Get();
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.FindSet;
//         repeat
//             if FirstTime then begin
//                 FirstTime := false;
//                 BancoAnt := GenJnlLine."Bal. Account No.";
//             end;
//             if BancoAnt <> GenJnlLine."Bal. Account No." then
//                 Error(Err001);
//         until GenJnlLine.Next = 0;

//         FirstTime := true;

//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         CounterTotal := GenJnlLine.Count;
//         Window.Open(Text001);
//         GenJnlLine.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, GenJnlLine."Line No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//             SettleDate := GenJnlLine."Posting Date";
//             if FirstTime then begin
//                 if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                     BankAccount.Get(GenJnlLine."Bal. Account No.");
//                 end
//                 else
//                     if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
//                         BankAccount.Get(GenJnlLine."Account No.");
//                     end;

//                 BankAccount.TestField("E-Pay Export File Path");
//                 BankAccount.TestField("Last Remittance Advice No.");
//                 BankAccount."Last Remittance Advice No." := IncStr(BankAccount."Last Remittance Advice No.");
//                 BankAccount.Modify;

//                 FirstTime := false;

//                 if CopyStr(BankAccount."E-Pay Export File Path", StrLen(BankAccount."E-Pay Export File Path"), 1) <> '\' then
//                     BankAccount."E-Pay Export File Path" += '\';

//                 case Date2DMY(WorkDate, 2) of
//                     1:
//                         TextMes := 'ENE';
//                     2:
//                         TextMes := 'FEB';
//                     3:
//                         TextMes := 'MAR';
//                     4:
//                         TextMes := 'ABR';
//                     5:
//                         TextMes := 'MAY';
//                     6:
//                         TextMes := 'JUN';
//                     7:
//                         TextMes := 'JUL';
//                     8:
//                         TextMes := 'AGO';
//                     9:
//                         TextMes := 'SEP';
//                     10:
//                         TextMes := 'OCT';
//                     11:
//                         TextMes := 'NOV';
//                     else
//                         TextMes := 'DIC';
//                 end;
//                 Archivo.TextMode(true);
//                 NombreArchivo := 'c:\temp\' + 'PAGOS_MULTICASH_' +
//                                Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') + Format(WorkDate, 0, '<Day,2>') + '_01.txt';

//                 NombreArchivo2 := BankAccount."E-Pay Export File Path" + 'PAGOS_MULTICASH_' +
//                                Format(WorkDate, 0, '<Year4>') + Format(WorkDate, 0, '<Month,2>') + Format(WorkDate, 0, '<Day,2>') + '_01.txt';
//                 Archivo.Create(NombreArchivo);
//                 Archivo.Trunc;
//                 //     Archivo.CREATEOUTSTREAM(StreamOut);
//             end;

//             if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                 Vendor.Get(GenJnlLine."Account No.");
//                 BankAccount.Get(GenJnlLine."Bal. Account No.");
//                 VendorBank.Reset;
//                 VendorBank.SetRange("Vendor No.", GenJnlLine."Account No.");
//                 CodBco := GenJnlLine."Bal. Account No.";
//             end
//             else
//                 if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
//                     Vendor.Get(GenJnlLine."Bal. Account No.");
//                     BankAccount.Get(GenJnlLine."Account No.");
//                     VendorBank.Reset;
//                     VendorBank.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
//                     CodBco := GenJnlLine."Account No.";
//                 end;

//             VendorBank.FindFirst;
//             VendorBank.TestField("Bank Account No.");
//             //  VendorBank.TESTFIELD("Banco Receptor");

//             //  BcoACH.GET(VendorBank."Banco Receptor");
//             BcoACH.TestField("Cod. Institucion Financiera");
//             Lin_Detail := 'PA' + Format(TAB);
//             BankAccount."Bank Account No." := DelChr(BankAccount."Bank Account No.", '=', '-/., ');
//             CERO := PadStr(CERO, 10 - StrLen(BankAccount."Bank Account No."), '0');
//             Lin_Detail += CERO + Format(BankAccount."Bank Account No.") + Format(TAB);
//             Lin_Detail += Format(Counter) + Format(TAB);
//             Lin_Detail += GenJnlLine."External Document No." + Format(TAB);
//             Lin_Detail += VendorBank."Bank Account No." + Format(TAB);
//             Lin_Detail += 'USD' + Format(TAB);
//             Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>') + Format(TAB);
//             Lin_Detail += 'CTA' + Format(TAB);
//             CERO := PadStr(CERO, 4 - StrLen(BcoACH."Cod. Institucion Financiera"), '0');
//             Lin_Detail += CERO + BcoACH."Cod. Institucion Financiera" + Format(TAB);

//             case VendorBank."Tipo Cuenta" of
//                 0:
//                     Lin_Detail += 'CTE' + Format(TAB);
//                 1:
//                     Lin_Detail += 'AHO' + Format(TAB);
//             end;

//             if VendorBank.Code = CodBco then begin
//                 VendorBank."Bank Account No." := DelChr(VendorBank."Bank Account No.", '=', '-/., ');
//                 CERO := PadStr(CERO, 10 - StrLen(VendorBank."Bank Account No."), '0');
//                 VendorBank."Bank Account No." := CERO;
//             end
//             else begin
//                 VendorBank."Bank Account No." := DelChr(VendorBank."Bank Account No.", '=', '-/., ');
//             end;

//             Clear(CERO);
//             if StrLen(VendorBank."Bank Account No.") < 10 then
//                 CERO := PadStr(CERO, 10 - StrLen(VendorBank."Bank Account No."), '0');

//             Lin_Detail += CERO + VendorBank."Bank Account No." + Format(TAB);

//             Vendor."VAT Registration No." := DelChr(Vendor."VAT Registration No.", '=', '-/., ');
//             if StrLen(Vendor."VAT Registration No.") = 10 then
//                 Lin_Detail += 'C' + Format(TAB)
//             else
//                 Lin_Detail += 'R' + Format(TAB);


//             Lin_Detail += Vendor."VAT Registration No." + Format(TAB);
//             Lin_Detail += CopyStr(GenJnlLine.Beneficiario, 1, 40) + Format(TAB);
//             Lin_Detail += CopyStr(Vendor.Address, 1, 50) + Format(TAB);
//             Lin_Detail += Vendor.City + Format(TAB); //Ciudad Beneficiario
//             Lin_Detail += Vendor."Phone No." + Format(TAB);
//             Lin_Detail += Format(TAB); //Localidad Beneficiario
//             Lin_Detail += GenJnlLine.Description + Format(TAB);
//             Lin_Detail += 'Pagos|';

//             Lin_Detail += Format(Empl."E-Mail");
//             Archivo.Write(Lin_Detail);

//             case BankAccount."Export Format" of
//                 BankAccount."Export Format"::US:
//                     begin
//                         TraceNumber := ExportPaymentsACH.ExportElectronicPayment(GenJnlLine, ExportAmount);
//                     end;
//                 BankAccount."Export Format"::CA:
//                     begin
//                         TraceNumber := ExportPaymentsRB.ExportElectronicPayment(GenJnlLine, ExportAmount, SettleDate);
//                     end;
//                 BankAccount."Export Format"::MX:
//                     begin
//                         //      TraceNumber := ExportPaymentsCecoban.ExportElectronicPayment(GenJnlLine,ExportAmount,SettleDate);
//                     end;
//             end;

//             //aqui vle
//             if GenJnlLine."Applies-to Doc. No." <> '' then begin
//             end
//             else begin
//                 //Detalle de las facturas que se pagan
//                 VLE.Reset;
//                 VLE.SetCurrentKey("Vendor No.", Open, Positive, "Due Date", "Currency Code");
//                 if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                     VLE.SetRange("Vendor No.", GenJnlLine."Account No.");
//                     Vendor.Get(GenJnlLine."Account No.");
//                 end
//                 else begin
//                     VLE.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
//                     Vendor.Get(GenJnlLine."Bal. Account No.");
//                 end;

//                 FirstTime2 := true;
//                 VLE.SetRange(Open, true);
//                 VLE.SetRange(Positive, false);
//                 VLE.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
//                 if VLE.FindSet then
//                     repeat
//                         if FirstTime2 then begin
//                             FirstTime2 := false;
//                             // Linea del pago
//                             Clear(Lin_Detail);
//                             Lin_Detail := 'DE' + Format(TAB);
//                             Seq += 1;
//                             Lin_Detail += Format(Counter) + Format(TAB);
//                             Lin_Detail += 'EGRESO' + Format(TAB);
//                             Lin_Detail += GenJnlLine."Document No." + ' TRANSFERENCIA BANCARIA' + Format(TAB);
//                             Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>') + Format(TAB);
//                             Lin_Detail += '00000' + Format(TAB);
//                             Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>');
//                             Archivo.Write(Lin_Detail);
//                             //Fin
//                         end;

//                         Clear(Lin_Detail);
//                         Lin_Detail := 'DE' + Format(TAB);
//                         Seq += 1;
//                         Lin_Detail += Format(Counter) + Format(TAB);
//                         Lin_Detail += 'INGRESO' + Format(TAB);
//                         Lin_Detail += CopyStr('Factura No. ' + VLE."External Document No." + ' ' + Vendor.Name, 1, 50) + Format(TAB);
//                         VLE.CalcFields("Remaining Amount");
//                         Lin_Detail += Format(Round((VLE."Remaining Amount"), 0.01) * 100, 13, '<integer,13><Filler Character,0>') + Format(TAB);
//                         Lin_Detail += '00000' + Format(TAB);
//                         Lin_Detail += Format(Round((VLE."Remaining Amount"), 0.01) * 100, 13, '<integer,13><Filler Character,0>');
//                         Archivo.Write(Lin_Detail);
//                     until VLE.Next = 0
//                 else begin
//                     if FirstTime2 then begin
//                         FirstTime2 := false;
//                         // Linea del pago
//                         Clear(Lin_Detail);
//                         Lin_Detail := 'DE' + Format(TAB);
//                         Seq += 1;
//                         Lin_Detail += Format(Counter) + Format(TAB);
//                         Lin_Detail += 'EGRESO' + Format(TAB);
//                         Lin_Detail += GenJnlLine."Document No." + ' TRANSFERENCIA BANCARIA' + Format(TAB);
//                         Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>') + Format(TAB);
//                         Lin_Detail += '00000' + Format(TAB);
//                         Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>');
//                         Archivo.Write(Lin_Detail);

//                         Clear(Lin_Detail);
//                         Lin_Detail := 'DE' + Format(TAB);
//                         Seq += 1;
//                         Lin_Detail += Format(Counter) + Format(TAB);
//                         Lin_Detail += 'INGRESO' + Format(TAB);
//                         Lin_Detail += GenJnlLine.Beneficiario + Format(TAB);
//                         Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>') + Format(TAB);
//                         Lin_Detail += '00000' + Format(TAB);
//                         Lin_Detail += Format(Round((GenJnlLine.Amount), 0.01) * 100, 13, '<integer,13><Filler Character,0>');
//                         Archivo.Write(Lin_Detail);
//                         //Fin
//                     end;
//                 end;
//             end;

//             if TraceNumber <> '' then begin
//                 //      GenJnlLine."Posting Date" := SettleDate;
//                 GenJnlLine."Check Printed" := true;
//                 GenJnlLine."Check Exported" := true;
//                 GenJnlLine."Check Transmitted" := true;

//                 GenJnlLine."Export File Name" := BankAccount."Last E-Pay Export File Name";
//                 BankAccount."Last Remittance Advice No." := IncStr(BankAccount."Last Remittance Advice No.");
//                 GenJnlLine."Document No." := IncStr(BankAccount."Last Remittance Advice No.");

//                 GenJnlLine.Modify;
//                 InsertIntoCheckLedger(TraceNumber, -ExportAmount, GenJnlLine);
//             end;

//         until GenJnlLine.Next = 0;

//         Window.Close;
//         Archivo.Close;

//         RenameFile;
//     end;


//     procedure InsertIntoCheckLedger(Trace: Code[30]; Amt: Decimal; GenJnlLine: Record "Gen. Journal Line")
//     var
//         CheckLedgerEntry: Record "Check Ledger Entry";
//         CheckManagement: Codeunit CheckManagement;
//     begin
//         with CheckLedgerEntry do begin
//             Init;
//             "Bank Account No." := BankAccount."No.";
//             "Posting Date" := GenJnlLine."Posting Date";
//             "Document Type" := GenJnlLine."Document Type";
//             "Document No." := GenJnlLine."Document No.";
//             Description := GenJnlLine.Description;
//             Beneficiario := GenJnlLine.Beneficiario; //GRN Para guardar info beneficiario
//             "Bank Payment Type" := "Bank Payment Type"::"Electronic Payment";
//             "Entry Status" := "Entry Status"::Exported;
//             "Check Date" := GenJnlLine."Posting Date";
//             "Check No." := GenJnlLine."Document No.";
//             /*
//             IF BankAccountIs = BankAccountIs::Acnt THEN BEGIN
//               "Bal. Account Type" := genjnlline."Bal. Account Type";
//               "Bal. Account No." := genjnlline."Bal. Account No.";
//             END ELSE
//             */
//             begin
//                 "Bal. Account Type" := GenJnlLine."Account Type";
//                 "Bal. Account No." := GenJnlLine."Account No.";
//             end;
//             "Trace No." := Trace;
//             "Transmission File Name" := GenJnlLine."Export File Name";
//             Amount := Amt;
//             CheckManagement.InsertCheck(CheckLedgerEntry, RecordId);
//         end;

//     end;


//     procedure EnviaMailPagos(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         Mail: Codeunit "SMTP Mail";
//         GenJnlLine: Record "Gen. Journal Line";
//         VendorBank: Record "Vendor Bank Account";
//         Vendor: Record Vendor;
//         UserSetup: Record "User Setup";
//         FirstTime: Boolean;
//         BancoAnt: Code[20];
//         CuerpoMail: Text[1024];
//         CodBco: Code[20];
//         Subject: Text[150];
//         Err001: Label 'The bank account must be the same in all the lines, please correct it';
//         Err002: Label 'User %1 is not defined in the Database';
//         Filtro: Text[30];
//         User: Record User;
//     begin
//         /*GRN 22/04/2013 lo voy a sustituir por un sistema de correo abierto
//          No el de NAVISION porque da error en algunos servidores

//         //Verifico que todas las lineas del diario tengan el mismo banco
//         FirstTime := TRUE;
//         Subject := 'CONFIRMACION DE PAGO';

//         Filtro := '*' + USERID + '*';
//         UserSetupW.RESET;
//         UserSetupW.SETFILTER(ID,Filtro);
//         //MESSAGE('%1',UserSetupW.GETFILTERS);
//         IF NOT UserSetupW.FINDFIRST THEN
//            IF NOT UserSetupD.GET(USERID) THEN
//               ERROR(Err002,USERID);

//         IF NOT UserSetup.GET(USERID) THEN
//            ERROR(Err002,USERID);

//         UserSetup.TESTFIELD("E-Mail");

//         EC.FINDFIRST;
//         ConfNomina.GET();
//         GenJnlLine.RESET;
//         GenJnlLine.SETRANGE("Journal Template Name",CodDiario);
//         GenJnlLine.SETRANGE("Journal Batch Name",SeccDiario);
//         GenJnlLine.FINDSET;
//         REPEAT
//           IF FirstTime THEN
//              BEGIN
//               FirstTime := FALSE;
//               BancoAnt := GenJnlLine."Bal. Account No.";
//              END;
//              IF BancoAnt <> GenJnlLine."Bal. Account No." THEN
//                 ERROR(Err001);
//         UNTIL GenJnlLine.NEXT = 0;

//         FirstTime := TRUE;

//         GenJnlLine.RESET;
//         GenJnlLine.SETRANGE("Journal Template Name",CodDiario);
//         GenJnlLine.SETRANGE("Journal Batch Name",SeccDiario);
//         CounterTotal := GenJnlLine.COUNT;
//         Window.OPEN(Text001);
//         GenJnlLine.FINDSET;
//         REPEAT
//           Counter := Counter + 1;
//           Window.UPDATE(1,GenJnlLine."Line No.");
//           Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));

//         //  IF FirstTime THEN
//         //     BEGIN
//         //      FirstTime := FALSE;
//               IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                  BEGIN
//                   BankAccount.GET(GenJnlLine."Bal. Account No.");
//                   BankAccount.TESTFIELD("E-Pay Export File Path");
//                  END
//               ELSE
//               IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
//                  BEGIN
//                   BankAccount.GET(GenJnlLine."Account No.");
//                   BankAccount.TESTFIELD("E-Pay Export File Path");
//                  END;

//               IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                  BEGIN
//                   Vendor.GET(GenJnlLine."Account No.");
//                   BankAccount.GET(GenJnlLine."Bal. Account No.");
//                   VendorBank.RESET;
//                   VendorBank.SETRANGE("Vendor No.",GenJnlLine."Account No.");
//                   CodBco := GenJnlLine."Bal. Account No.";
//                  END
//               ELSE
//               IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
//                  BEGIN
//                   Vendor.GET(GenJnlLine."Bal. Account No.");
//                   BankAccount.GET(GenJnlLine."Account No.");
//                   VendorBank.RESET;
//                   VendorBank.SETRANGE("Vendor No.",GenJnlLine."Bal. Account No.");
//                   CodBco := GenJnlLine."Account No.";
//                  END;
//         //     END;
//               VendorBank.FINDFIRST;
//               VendorBank.TESTFIELD("Bank Account No.");
//               VendorBank.TESTFIELD("Banco Receptor");

//               CuerpoMail := 'Estimado Colaborador:';
//               Mail.CreateMessage(UserSetupW.Name,UserSetup."E-Mail",Vendor."E-Mail",Subject,'',TRUE);
//               Mail.AppendBody(CuerpoMail + '<br>');
//               CLEAR(CuerpoMail);
//               Mail.AppendBody(CuerpoMail + '<br>');
//               Mail.AppendBody(CuerpoMail + '<br>');
//               CuerpoMail := 'El Grupo Editorial Santillana, tiene el agrado de informarle que ha sido generada una Orden de ';
//               CuerpoMail += 'Pago a su favor en su Cuenta ';
//               CASE VendorBank."Tipo Cuenta" OF
//                  0:
//                   CuerpoMail += 'CTE No. ';
//                  1:
//                   CuerpoMail += 'AHO No. ';
//               END;

//               CuerpoMail += VendorBank."Bank Account No.";
//               CuerpoMail += ' constando como Beneficiario: ';
//               CuerpoMail += GenJnlLine.Beneficiario + '.';
//               Mail.AppendBody(CuerpoMail + '<br>');
//               CLEAR(CuerpoMail);
//               Mail.AppendBody(CuerpoMail + '<br>');

//               CuerpoMail := 'Por un valor de $' + FORMAT(ABS(GenJnlLine.Amount)) + '.';
//               Mail.AppendBody(CuerpoMail + '<br>');

//               CuerpoMail := 'Facturas canceladas:';
//               Mail.AppendBody(CuerpoMail + '<br>');

//               //Detalle de las facturas que se pagan
//               VLE.RESET;
//               VLE.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date","Currency Code");
//               IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                  BEGIN
//                   VLE.SETRANGE("Vendor No.",GenJnlLine."Account No.");
//                   Vendor.GET(GenJnlLine."Account No.");
//                  END
//               ELSE
//                  BEGIN
//                   VLE.SETRANGE("Vendor No.",GenJnlLine."Bal. Account No.");
//                   Vendor.GET(GenJnlLine."Bal. Account No.");
//                  END;

//               VLE.SETRANGE(Open,TRUE);
//               VLE.SETRANGE(Positive,FALSE);
//               VLE.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
//               IF VLE.FINDSET THEN
//                  REPEAT
//                   CuerpoMail := VLE."Document No." + ', ';
//                   Mail.AppendBody(CuerpoMail);
//                  UNTIL VLE.NEXT =0;
//               CLEAR(CuerpoMail);
//               Mail.AppendBody(CuerpoMail + '<br>' + '<br>');


//               CuerpoMail += 'También le recordamos que sus comprobantes de Retención pueden ser retirados en nuestras ';
//               CuerpoMail += 'oficinas de lunes a viernes de 9:00 a 18:00, solo con presentar la copia del RUC para empresas y  ';
//               CuerpoMail += 'la Cédula de Ciudadanía para personas naturales.';
//               Mail.AppendBody(CuerpoMail);
//               CLEAR(CuerpoMail);
//               Mail.AppendBody(CuerpoMail + '<br>' + '<br>');


//               CuerpoMail += 'Agradecemos de antemano por su atención y colaboración. ';
//               Mail.AppendBody(CuerpoMail + '<br>');
//               CLEAR(CuerpoMail);
//               Mail.AppendBody(CuerpoMail + '<br>' + '<br>');

//               CuerpoMail := 'Atentamente';
//               Mail.AppendBody(CuerpoMail + '<br>');


//               CuerpoMail := 'Grupo Santillana ';
//               Mail.AppendBody(CuerpoMail + '<br>');

//               CuerpoMail := 'TESORERIA ';
//               Mail.AppendBody(CuerpoMail + '<br>');

//               Mail.Send();
//               CLEAR(Mail);
//         UNTIL GenJnlLine.NEXT = 0;
//         Window.CLOSE;
//         */

//         //Verifico que todas las lineas del diario tengan el mismo banco
//         /*ConfEmpresa.GET();
//         ConfEmpresa.TESTFIELD("E-Mail copia pagos a Proveedor");

//         FirstTime := TRUE;
//         Subject := 'CONFIRMACION DE PAGO';

//         //Filtro := '*' + USERID + '*';

//         IF NOT User.GET(USERID) THEN
//           ERROR(Err002,USERID);


//         IF NOT UserSetup.GET(USERID) THEN
//            ERROR(Err002,USERID);

//         UserSetup.TESTFIELD("E-Mail");

//         EC.FINDFIRST;
//         ConfNomina.GET();
//         GenJnlLine.RESET;
//         GenJnlLine.SETRANGE("Journal Template Name",CodDiario);
//         GenJnlLine.SETRANGE("Journal Batch Name",SeccDiario);
//         GenJnlLine.FINDSET;
//         REPEAT
//           IF FirstTime THEN
//              BEGIN
//               FirstTime := FALSE;
//               BancoAnt := GenJnlLine."Bal. Account No.";
//              END;
//              IF BancoAnt <> GenJnlLine."Bal. Account No." THEN
//                 ERROR(Err001);
//         UNTIL GenJnlLine.NEXT = 0;

//         FirstTime := TRUE;

//         GenJnlLine.RESET;
//         GenJnlLine.SETRANGE("Journal Template Name",CodDiario);
//         GenJnlLine.SETRANGE("Journal Batch Name",SeccDiario);
//         CounterTotal := GenJnlLine.COUNT;
//         Window.OPEN(Text001);
//         GenJnlLine.FINDSET;
//         REPEAT
//           Counter := Counter + 1;
//           Window.UPDATE(1,GenJnlLine."Line No.");
//           Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));

//         //  IF FirstTime THEN
//         //     BEGIN
//         //      FirstTime := FALSE;
//               IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                  BEGIN
//                   BankAccount.GET(GenJnlLine."Bal. Account No.");
//                   BankAccount.TESTFIELD("E-Pay Export File Path");
//                  END
//               ELSE
//               IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
//                  BEGIN
//                   BankAccount.GET(GenJnlLine."Account No.");
//                   BankAccount.TESTFIELD("E-Pay Export File Path");
//                  END;

//               IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                  BEGIN
//                   Vendor.GET(GenJnlLine."Account No.");
//                   BankAccount.GET(GenJnlLine."Bal. Account No.");
//                   VendorBank.RESET;
//                   VendorBank.SETRANGE("Vendor No.",GenJnlLine."Account No.");
//                   CodBco := GenJnlLine."Bal. Account No.";
//                  END
//               ELSE
//               IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
//                  BEGIN
//                   Vendor.GET(GenJnlLine."Bal. Account No.");
//                   BankAccount.GET(GenJnlLine."Account No.");
//                   VendorBank.RESET;
//                   VendorBank.SETRANGE("Vendor No.",GenJnlLine."Bal. Account No.");
//                   CodBco := GenJnlLine."Account No.";
//                  END;
//         //     END;
//               VendorBank.FINDFIRST;
//               VendorBank.TESTFIELD("Bank Account No.");
//               VendorBank.TESTFIELD("Banco Receptor");
//               IF Vendor."E-Mail" <> '' THEN
//                  BEGIN
//                   CuerpoMail := 'Estimado Colaborador:';
//                   Mail2.CreateMessage(User."Full Name",UserSetup."E-Mail",Vendor."E-Mail",Subject,'',TRUE);
//                   Mail2.AddCC(ConfEmpresa."E-Mail copia pagos a Proveedor");
//                   Mail2.AppendBody(CuerpoMail + '<br>');
//                   CLEAR(CuerpoMail);
//                   Mail2.AppendBody(CuerpoMail + '<br>');
//                   Mail2.AppendBody(CuerpoMail + '<br>');
//                   CuerpoMail := 'El Grupo Editorial Santillana, tiene el agrado de informarle que ha sido generada una Orden de ';
//                   CuerpoMail += 'Pago a su favor en su Cuenta ';
//                   CASE VendorBank."Tipo Cuenta" OF
//                      0:
//                       CuerpoMail += 'CTE No. ';
//                      1:
//                       CuerpoMail += 'AHO No. ';
//                   END;

//                   CuerpoMail += VendorBank."Bank Account No.";
//                   CuerpoMail += ' constando como Beneficiario: ';
//                   CuerpoMail += GenJnlLine.Beneficiario + '.';
//                   Mail2.AppendBody(CuerpoMail + '<br>');
//                   CLEAR(CuerpoMail);
//                   Mail2.AppendBody(CuerpoMail + '<br>');

//                   CuerpoMail := 'Por un valor de $' + FORMAT(ABS(GenJnlLine.Amount)) + '.';
//                   Mail2.AppendBody(CuerpoMail + '<br>');

//                   CuerpoMail := 'Facturas canceladas:';
//                   Mail2.AppendBody(CuerpoMail + '<br>');

//                   //Detalle de las facturas que se pagan
//                   VLE.RESET;
//                   VLE.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date","Currency Code");
//                   IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                      BEGIN
//                       VLE.SETRANGE("Vendor No.",GenJnlLine."Account No.");
//                       Vendor.GET(GenJnlLine."Account No.");
//                      END
//                   ELSE
//                      BEGIN
//                       VLE.SETRANGE("Vendor No.",GenJnlLine."Bal. Account No.");
//                       Vendor.GET(GenJnlLine."Bal. Account No.");
//                      END;

//                   VLE.SETRANGE(Open,TRUE);
//                   VLE.SETRANGE(Positive,FALSE);
//                   VLE.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
//                   IF VLE.FINDSET THEN
//                      REPEAT
//                       CuerpoMail := VLE."External Document No." + ', ';
//                       Mail2.AppendBody(CuerpoMail);
//                      UNTIL VLE.NEXT =0;
//                   CLEAR(CuerpoMail);
//                   Mail2.AppendBody(CuerpoMail + '<br>' + '<br>');


//                   CuerpoMail += 'También le recordamos que sus comprobantes de Retención pueden ser retirados en nuestras ';
//                   CuerpoMail += 'oficinas de lunes a viernes de 9:00 a 18:00, solo con presentar la copia del RUC para empresas y  ';
//                   CuerpoMail += 'la Cédula de Ciudadanía para personas naturales.';
//                   Mail2.AppendBody(CuerpoMail);
//                   CLEAR(CuerpoMail);
//                   Mail2.AppendBody(CuerpoMail + '<br>' + '<br>');


//                   CuerpoMail += 'Agradecemos de antemano por su atención y colaboración. ';
//                   Mail2.AppendBody(CuerpoMail + '<br>');
//                   CLEAR(CuerpoMail);
//                   Mail2.AppendBody(CuerpoMail + '<br>' + '<br>');

//                   CuerpoMail := 'Atentamente';
//                   Mail2.AppendBody(CuerpoMail + '<br>');


//                   CuerpoMail := 'Grupo Santillana ';
//                   Mail2.AppendBody(CuerpoMail + '<br>');

//                   CuerpoMail := 'TESORERIA ';
//                   Mail2.AppendBody(CuerpoMail + '<br>');

//                   Mail2.Send();
//                   CLEAR(Mail2);
//                 END;
//         UNTIL GenJnlLine.NEXT = 0;

//         Window.CLOSE;
//         */

//     end;


//     procedure RenameFile()
//     begin
//         if IsServiceTier then begin
//             //El archivo fue creado en la carpeta C: del ServiceTier
//             //Por lo cual hay que pasarlo a la maquina local. Debe ser pasado a la carpeta temporal
//             //para evitar que al copiarse despliegue un cuadro de dialogo
//             MagicPath := NombreArchivo;
//             FileToDownload := NombreArchivo;
//             FileVar.Open(FileToDownload);
//             FileVar.CreateInStream(IStream);
//             DownloadFromStream(IStream, '', '<TEMP>', 'Text file(*.txt)|*.txt', MagicPath);
//             FileVar.Close;


//             //Luego de copiado al temporal, lo llevamos a una carpeta con un Path entendible
//             //por el automation wSHShell
//             Create(FileSystemObject, true, true);
//             DestinationFileName := NombreArchivo2;
//             if FileSystemObject.FileExists(DestinationFileName) then
//                 FileSystemObject.DeleteFile(DestinationFileName, true);
//             FileSystemObject.CopyFile(MagicPath, DestinationFileName);
//             FileSystemObject.DeleteFile(MagicPath, true);
//             Clear(FileSystemObject);
//         end;
//     end;
// }

