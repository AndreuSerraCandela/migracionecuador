// codeunit 76040 "Genera Formatos  E. Nomina RD"
// {
//     Permissions = TableData Vendor = rimd,
//                   TableData "Gen. Journal Line" = rimd,
//                   TableData "General Ledger Setup" = rimd,
//                   TableData "Bank Account" = rm,
//                   TableData Employee = rimd;
//     TableNo = "Historico Cab. nomina";

//     trigger OnRun()
//     begin
//         GHCN.Copy(Rec);
//         case GHCN."Tipo Archivo" of
//             1:
//                 FormatoBanco(GHCN);
//             2:
//                 NovedadesCambioSueldo;
//             3:
//                 NovedadesVarSueldo;
//         end;
//     end;

//     var
//         ConfContab: Record "General Ledger Setup";
//         Empl: Record Employee;
//         EC: Record "Empresas Cotizacion";
//         GHCN: Record "Historico Cab. nomina";
//         GHLN: Record "Historico Lin. nomina";
//         Fecha: Record Date;
//         BcoACH: Record "Bancos ACH Nomina";
//         VLE: Record "Vendor Ledger Entry";
//         BankAccount: Record "Bank Account";
//         BankAccount2: Record "Bank Account";
//         GenJnlLine: Record "Gen. Journal Line";
//         CompanyInfo: Record "Company Information";
//         VendorBank: Record "Vendor Bank Account";
//         Vendor: Record Vendor;
//         FuncNom: Codeunit "Funciones Nomina";
//         Archivo: File;
//         FileVar: File;
//         IStream: InStream;
//         StreamOut: OutStream;
//         Lin_Body: Text[320];
//         Lin_Body2: Text[400];
//         CERO: Text[100];
//         Blanco: Text[30];
//         Window: Dialog;
//         Text001: Label 'Generating file #1########## @2@@@@@@@@@@@@@';
//         CounterTotal: Integer;
//         Counter: Integer;
//         SettleDate: Date;
//         Text002: Label 'PAYMENT PAYROLL FROM %1 TO %2';
//         Text003: Label 'PAYROLL FROM %1 TO %2';
//         MSG001: Label 'La generación del archivo del banco se ha realizado con éxito.';
//         Err002: Label 'You must specify the Bank as balance account';
//         NombreArchivo: Text[1024];
//         NombreArchivo2: Text[1024];
//         recDimEntry: Record "Dimension Set Entry";
//         TotalGeneral: Decimal;
//         Tracenumber: Text[30];
//         PathENV: Text[1024];
//         ExportAmount: Decimal;
//         Err003: Label 'The date in the journal should be the same or later than today, please check';
//         PrimeraVez: Boolean;
//         SecuenciaTrans: Code[10];


//     procedure FormatoBanco(var CN: Record "Historico Cab. nomina")
//     var
//         Empresa: Record "Empresas Cotizacion";
//         ConfNomina: Record "Configuracion nominas";
//         DIPG: Record "Distrib. Ingreso Pagos Elect.";
//         HCN: Record "Historico Cab. nomina";
//         HCN2: Record "Historico Cab. nomina";
//         HLN: Record "Historico Lin. nomina";
//         Banco: Record "Bank Account";
//         BcoNom: Record Bancos;
//         NetoBanco: Decimal;
//         Err001: Label 'Missing Bank''s information from Company Setup';
//         RNC: Text;
//         FechaTrans: Date;
//         PathENV: Text[1024];
//         Mes: Integer;
//         Secuencia: Text[30];
//         Total: Decimal;
//         Concepto: Text[40];
//         Contador: Integer;
//     begin
//         ConfNomina.Get();
//         ConfContab.Get();
//         Empresa.FindFirst;
//         Empresa.TestField("RNC/CED");
//         RNC := DelChr(Empresa."RNC/CED", '=', '-');

//         if Empresa.Banco = '' then
//             Error(Err001);

//         BcoNom.Get(Empresa.Banco);
//         BcoNom.TestField(Formato);

//         Blanco := ' ';
//         CERO := '0';
//         PrimeraVez := true;

//         EC.Get(GHCN."Empresa cotización");
//         EC.TestField("Identificador Empresa");

//         ConfNomina.TestField("Path Archivos Electronicos");

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         FechaTrans := GHCN."Fecha Pago";
//         PathENV := TemporaryPath;

//         NombreArchivo := 'PE' + Empresa."Identificador Empresa" + '01' + Format(FechaTrans, 0, '<Month,2>') + Format(FechaTrans, 0, '<Day,2>') + DelChr(Format(Time), '=', ' ampmAMPM:.');

//         Mes := Date2DMY(FechaTrans, 2);
//         Mes := Mes * 2;

//         BankAccount.Get(Empresa.Banco);

//         if ConfNomina."Secuencia de archivo Batch" = '' then begin
//             if Mes < 10 then
//                 Secuencia := '000000' + Format(Mes)
//             else
//                 Secuencia := '00000' + Format(Mes);

//             BankAccount.Secuencia := IncStr(Secuencia);
//             BankAccount.Modify;
//         end
//         else begin
//             ConfNomina."Secuencia de archivo Batch" := IncStr(ConfNomina."Secuencia de archivo Batch");
//             ConfNomina.Modify;
//             Secuencia := ConfNomina."Secuencia de archivo Batch";
//         end;

//         if (UpperCase(BcoNom.Formato) = 'BR') or (UpperCase(BcoNom.Formato) = 'RESERVAS') then begin
//             NombreArchivo := 'NOM-BR-' + Empresa."Empresa cotizacion" + '-' + FuncNom.FechaCorta(FechaTrans) + '.txt';
//             NombreArchivo2 := NombreArchivo;
//         end
//         else
//             if (UpperCase(BcoNom.Formato) = 'BLH') or (UpperCase(BcoNom.Formato) = 'LOPEZDEHARO') then begin
//                 NombreArchivo := '0' + BankAccount.Formato; //Identificador de empresa
//                 NombreArchivo += Format(GHCN.Período, 0, '<Year4><Month,2><Day,2>'); //Fecha creacion de archivo
//                 NombreArchivo += Format(Time, 0, '<Hours24,2><Minutes,2><Seconds,2>'); //Hora creacion de archivo
//                 NombreArchivo += 'S';//Tipo de archivo ==> Envio(S) Respuesta(R)
//                 NombreArchivo += '.txt';
//                 NombreArchivo2 := NombreArchivo;
//             end
//             else begin
//                 NombreArchivo += Secuencia + 'E.txt';
//                 NombreArchivo2 := NombreArchivo;
//                 SecuenciaTrans := '0000000';
//             end;

//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;


//         HCN.Reset;
//         //HCN.COPYFILTERS(CN);
//         HCN.SetFilter("No. empleado", CN.GetFilter("No. empleado"));
//         HCN.SetFilter(Período, CN.GetFilter(Período));
//         HCN.SetFilter("Tipo de nomina", CN.GetFilter("Tipo de nomina"));
//         HCN.SetFilter("Job No.", CN.GetFilter("Job No."));
//         HCN.SetRange("Forma de Cobro", 3);// Transferencias de banco
//         //HCN.SETRANGE(Banco,CN.Banco);
//         CounterTotal := HCN.Count;

//         Window.Open(Text001);
//         //ERROR('%1',HCN.GETFILTERS);
//         //IF HCN.FINDSET THEN
//         HCN.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, HCN."No. empleado");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             Empl.Get(HCN."No. empleado");

//             DIPG.Reset;
//             DIPG.SetRange("No. empleado", HCN."No. empleado");
//             DIPG.FindFirst;
//             if (BcoNom.Formato = 'Popular') or (BcoNom.Formato = 'BPD') then begin
//                 if PrimeraVez then begin
//                     PrimeraVez := false;
//                     //Creo la cabecera
//                     /*
//                     HCN2.RESET;
//                     HCN2.SETFILTER(Período,GHCN.GETFILTER(Período));
//                     HCN2.SETFILTER("Tipo Nomina",GHCN.GETFILTER("Tipo Nomina"));
//                     HCN2.SETRANGE("Forma de Cobro",3);// Transferencias de banco
//                     */
//                     HCN2.Reset;
//                     HCN2.CopyFilters(HCN);
//                     CounterTotal := HCN.Count;
//                     HCN2.FindSet;
//                     repeat
//                         HCN2.CalcFields("Total Ingresos", "Total deducciones");
//                         //              TotalGeneral += ROUND(HCN2."Total Ingresos" + HCN2."Total deducciones",0.01);
//                         GHLN.Reset;
//                         GHLN.SetFilter(Período, HCN2.GetFilter(Período));
//                         GHLN.SetFilter("Tipo de nomina", HCN2.GetFilter("Tipo de nomina"));
//                         GHLN.SetFilter("Job No.", HCN2.GetFilter("Job No."));
//                         GHLN.SetRange("No. empleado", HCN2."No. empleado");
//                         if GHLN.FindSet then
//                             repeat
//                                 TotalGeneral += Round(GHLN.Total, 0.01);
//                             until GHLN.Next = 0;
//                     until HCN2.Next = 0;

//                     //TotalGeneral := ROUND(TotalGeneral,0.01);
//                     Lin_Body := 'H';
//                     Lin_Body += Format(RNC, 15);
//                     Lin_Body += Format(Empresa."Nombre Empresa cotizacinn", 35);
//                     Lin_Body += Secuencia + '01';
//                     Lin_Body += Format(FechaTrans, 0, '<Year4><Month,2><Day,2>');
//                     Lin_Body += '000000000000000000000000';
//                     Lin_Body += Format(CounterTotal, 11, '<Integer,11><Filler Character,0>');
//                     Lin_Body += Format(TotalGeneral * 100, 13, '<integer,13><Filler Character,0>');
//                     Lin_Body += '000000000000000';
//                     Lin_Body += Format(Today, 0, '<Year4><Month,2><Day,2>');
//                     Lin_Body += Format(Time, 4, '<hours24,2><Minutes,2>');
//                     Lin_Body += Format(Empresa."E-Mail", 40);
//                     Lin_Body += Format(Blanco, 136);
//                     Archivo.Write(Lin_Body);
//                 end;
//                 //Creo el detalle
//                 SecuenciaTrans := IncStr(SecuenciaTrans);
//                 Clear(Lin_Body);
//                 Lin_Body := 'N';
//                 Lin_Body += Format(RNC, 15);
//                 Lin_Body += Format(Secuencia, 7);
//                 Lin_Body += Format(SecuenciaTrans, 7);

//                 //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//                 if (DIPG."Numero Cuenta" <> '') and (DIPG."Tipo Cuenta" <> 2) then
//                     Lin_Body += Format(DIPG."Numero Cuenta") + Format(Blanco, 20 - StrLen(DIPG."Numero Cuenta"))
//                 else
//                     if DIPG."Tipo Cuenta" <> 2 then
//                         Error(Err002, Empl."No." + ', ' + Empl."Full Name")
//                     else
//                         if DIPG."Tipo Cuenta" = 2 then
//                             Lin_Body += Format(Blanco, 20);

//                 if DIPG."Tipo Cuenta" = 0 then
//                     Lin_Body += '2'
//                 else
//                     if DIPG."Tipo Cuenta" = 1 then
//                         Lin_Body += '1'
//                     else
//                         Lin_Body += '5';

//                 Lin_Body += '214'; //Moneda 214=RD$, 840=USD, 978=Euro
//                 BcoACH.Get(DIPG."Cod. Banco");
//                 Lin_Body += BcoACH."ACH Reservas";
//                 Lin_Body += Format(BcoACH."Digito Chequeo");

//                 if DIPG."Tipo Cuenta" = 0 then
//                     Lin_Body += '32'
//                 else
//                     if DIPG."Tipo Cuenta" = 1 then
//                         Lin_Body += '22'
//                     else
//                         Lin_Body += '12';

//                 //16/06/15          HCN.CALCFIELDS("Total Ingresos","Total deducciones");
//                 //16/06/15       Total    := ROUND(HCN."Total Ingresos" + HCN."Total deducciones",0.01);
//                 Clear(Total);
//                 GHLN.Reset;
//                 GHLN.SetFilter(Período, HCN2.GetFilter(Período));
//                 GHLN.SetFilter("Tipo de nomina", HCN.GetFilter("Tipo de nomina"));
//                 GHLN.SetRange("No. empleado", HCN."No. empleado");
//                 if GHLN.FindSet then
//                     repeat
//                         Total += Round(GHLN.Total, 0.01);
//                     until GHLN.Next = 0;

//                 Lin_Body += Format(Total * 100, 13, '<integer,13><Filler Character,0>');
//                 case Empl."Document Type" of
//                     0: //Cedula
//                         Lin_Body += 'CE';
//                     1: //Pasaporte
//                         Lin_Body += 'PS';
//                     else //Pasaporte
//                         Lin_Body += 'RN';
//                 end;
//                 Empl."Document ID" := DelChr(Empl."Document ID", '=', ' -');
//                 Lin_Body += Empl."Document ID" + Format(Blanco, 15 - StrLen(Empl."Document ID"), '<Text>');
//                 //Lin_Body += FORMAT(Blanco,17,'<Text,17>');
//                 Empl."Full Name" := FuncNom.Ascii2Ansi(Empl."Full Name");
//                 Lin_Body += Format(CopyStr(Empl."Full Name", 1, 35), 35);
//                 Lin_Body += Format(FechaTrans, 12, '<Year4><Month,2><Day,2><Filler Character,0>');
//                 Concepto := StrSubstNo(Text002, GHCN.Inicio, GHCN.Fin);
//                 Lin_Body += Format(CopyStr(Concepto, 1, 40), 40);
//                 Lin_Body += Format(Blanco, 4);

//                 if Empl."E-Mail" <> '' then
//                     Lin_Body += '1'
//                 else
//                     Lin_Body += ' ';

//                 if Empl."Company E-Mail" <> '' then
//                     Lin_Body += Format(Empl."Company E-Mail", 40)
//                 else
//                     Lin_Body += Format(Empl."E-Mail", 40);

//                 Lin_Body += Format(Blanco, 12);
//                 Lin_Body += '00';
//                 Lin_Body += Format(Blanco, 78);
//                 Archivo.Write(Lin_Body);

//                 Contador := Contador + 1;
//             end
//             else
//                 if (BcoNom.Formato = 'BHD') then begin
//                     //Creo el detalle
//                     //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//                     Clear(Lin_Body);
//                     DIPG.TestField("Numero Cuenta");
//                     BcoACH.Get(DIPG."Cod. Banco");
//                     Lin_Body += DIPG."Numero Cuenta";
//                     Lin_Body += ';' + BcoACH."Cod. Institucion Financiera";
//                     Lin_Body += ';' + CopyStr(Empl."Full Name", 1, 50);
//                     Lin_Body += ';' + Empl."No.";
//                     HCN.CalcFields("Total Ingresos", "Total deducciones");
//                     Total := Round(HCN."Total Ingresos" + HCN."Total deducciones", 0.01);

//                     Lin_Body += ';' + Format(Total, 0, '<Integer><Decimals,3>');
//                     Lin_Body += ';' + Format(Contador + 1);
//                     Lin_Body += ';' + StrSubstNo(Text002, GHCN.Inicio, GHCN.Fin);
//                     Archivo.Write(Lin_Body);
//                     Contador := Contador + 1;
//                 end
//                 else
//                     if (UpperCase(BcoNom.Formato) = 'BR') or (UpperCase(BcoNom.Formato) = 'RESERVAS') then begin
//                         //Creo el detalle
//                         //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//                         Clear(Lin_Body);
//                         if DIPG."Tipo Cuenta" = 0 then
//                             Lin_Body += 'CA'
//                         else
//                             Lin_Body += 'CC';
//                         Lin_Body += 'DOP'; //Moneda
//                         Lin_Body += DelChr(BankAccount."Bank Account No.", '=', '- ') + ',';
//                         DIPG.TestField("Numero Cuenta");
//                         Lin_Body += DIPG."Numero Cuenta";
//                         HCN.CalcFields("Total Ingresos", "Total deducciones");
//                         Total := Round(HCN."Total Ingresos" + HCN."Total deducciones", 0.01);
//                         Lin_Body += ',' + Format(Total * 100, 13, '<Integer>');
//                         Empl."Full Name" := FuncNom.Ascii2Ansi(Empl."Full Name");
//                         Lin_Body += ',' + CopyStr(DelChr(Empl."Full Name", '=', ','), 1, 39);
//                         case Empl."Document Type" of
//                             0:
//                                 Lin_Body += 'Cedula';
//                             1:
//                                 Lin_Body += 'Pasaporte';
//                             2:
//                                 Lin_Body += 'RNC';
//                         end;
//                         Empl."Document ID" := DelChr(Empl."Document ID", '=', ' -');
//                         Lin_Body += Empl."Document ID";
//                         Concepto := StrSubstNo(Text002, GHCN.Inicio, GHCN.Fin);
//                         Lin_Body += Format(CopyStr(Concepto, 1, 55), 55);

//                         Archivo.Write(Lin_Body);
//                         Contador := Contador + 1;
//                     end
//                     else
//                         if (UpperCase(BcoNom.Formato) = 'BDP') or (UpperCase(BcoNom.Formato) = 'PROGRESO') then begin
//                             //Creo el Cabecera
//                             if PrimeraVez then begin
//                                 PrimeraVez := false;
//                                 SecuenciaTrans := '000000';
//                                 BankAccount.Get(Empresa.Banco);
//                                 HCN2.Reset;
//                                 HCN2.CopyFilters(HCN);
//                                 CounterTotal := HCN.Count;
//                                 HCN2.FindSet;
//                                 repeat
//                                     HCN2.CalcFields("Total Ingresos", "Total deducciones");
//                                     //              TotalGeneral += ROUND(HCN2."Total Ingresos" + HCN2."Total deducciones",0.01);
//                                     GHLN.Reset;
//                                     GHLN.SetFilter(Período, HCN2.GetFilter(Período));
//                                     GHLN.SetFilter("Tipo de nomina", HCN2.GetFilter("Tipo de nomina"));
//                                     GHLN.SetRange("No. empleado", HCN2."No. empleado");
//                                     if GHLN.FindSet then
//                                         repeat
//                                             TotalGeneral += Round(GHLN.Total, 0.01);
//                                         until GHLN.Next = 0;
//                                 until HCN2.Next = 0;

//                                 //Creo la cabecera
//                                 RNC := DelChr(RNC, '=', '-. ,');
//                                 Lin_Body := PadStr(CERO, 11 - StrLen(RNC), '0') + RNC; //RNC
//                                 Lin_Body += 'H'; //Tipo de registro
//                                 BankAccount."Bank Account No." := DelChr(BankAccount."Bank Account No.", '=', '- ');
//                                 Lin_Body += PadStr(CERO, 10 - StrLen(BankAccount."Bank Account No."), '0') + BankAccount."Bank Account No.";
//                                 Lin_Body += Format(TotalGeneral * 100, 11, '<integer,11><Filler Character,0>');
//                                 Lin_Body += Format(FechaTrans, 0, '<Month,2><Day,2><Year4>'); //Fecha efectividad MMDDYYYY
//                                 Lin_Body += Format(CounterTotal, 6, '<Integer,6><Filler Character,0>');
//                                 Lin_Body += Format(CopyStr(Empresa."Nombre Empresa cotizacinn", 1, 30), 30, '<Filler Character, >');
//                                 Archivo.Write(Lin_Body);
//                             end;

//                             //Creo el detalle
//                             //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//                             Lin_Body := PadStr(CERO, 11 - StrLen(RNC), '0') + RNC; //RNC
//                             Lin_Body += 'N'; //Detalle
//                             DIPG.TestField("Numero Cuenta");
//                             Lin_Body += PadStr(CERO, 10 - StrLen(DIPG."Numero Cuenta"), '0') + DIPG."Numero Cuenta"; //No. cuenta beneficiario
//                             HCN.CalcFields("Total Ingresos", "Total deducciones");
//                             Total := Round(HCN."Total Ingresos" + HCN."Total deducciones", 0.01);
//                             Lin_Body += ConvertStr(Format(Total * 100, 11, '<Integer,11>'), ' ', '0'); //Importe a pagar
//                             Lin_Body += Format(FechaTrans, 0, '<Month,2><Day,2><Year4>'); //Fecha efectividad MMDDYYYY
//                             SecuenciaTrans := IncStr(SecuenciaTrans);
//                             Lin_Body += SecuenciaTrans;
//                             Empl."Full Name" := FuncNom.Ascii2Ansi(Empl."Full Name");
//                             Lin_Body += Format(CopyStr(Empl."Full Name", 1, 30), 30);
//                             Contador := Contador + 1;
//                             Archivo.Write(Lin_Body);
//                         end
//                         else
//                             if (UpperCase(BcoNom.Formato) = 'BLH') or (UpperCase(BcoNom.Formato) = 'LOPEZDEHARO') then begin
//                                 //Creo el Cabecera
//                                 DIPG.Reset;
//                                 DIPG.SetRange("No. empleado", HCN."No. empleado");
//                                 DIPG.FindFirst;
//                                 if PrimeraVez then begin
//                                     PrimeraVez := false;
//                                     //Creo la cabecera
//                                     Lin_Body2 := 'H'; //Header
//                                     Lin_Body2 += '0' + Format(Empresa."Identificador Empresa"); //Identificador de empresa
//                                     RNC := DelChr(RNC, '=', '-. ,');
//                                     Lin_Body2 += Format(Blanco, 11 - StrLen(RNC), '<Filler character, >') + RNC; //RNC
//                                     Lin_Body2 += Format(Today, 0, '<Year4><Month,2><Day,2>'); //Fecha creacion YYYYMMDD
//                                     Lin_Body2 += Format(Time, 0, '<Hours24,2><Minutes,2><Seconds,2>'); //Hora creacion HHMMSS
//                                     Lin_Body2 += Format(FechaTrans, 0, '<Year4><Month,2><Day,2>'); //Fecha efectividad YYYYMMDD
//                                                                                                    //Lin_Body2 += FORMAT(TIME,0,'<Hours24,2><Minutes,2><Seconds,2>');
//                                     Lin_Body2 += '000000'; //Hora efectividad HHMMSS
//                                     Lin_Body2 += '0000000000'; //No. referencia
//                                     Lin_Body2 += 'P'; //Post File
//                                     Lin_Body2 += '08'; //08=Payroll, 09=Pay bills
//                                     Concepto := StrSubstNo(Text002, GHCN.Inicio, GHCN.Fin);
//                                     Lin_Body2 += Format(Blanco, 80 - StrLen(Concepto), '<Filler character, >') + Concepto; //Concepto
//                                     Lin_Body2 += '0000'; //ID Cuenta
//                                     Lin_Body2 += '000000000000000'; //Para tarjetas de credito, No de comercio (Merchand ID)
//                                     Lin_Body2 += '1000'; //Version del archivo
//                                     Lin_Body2 += Format(Blanco, 238); //Espacios en blanco para llegar a 400
//                                     Archivo.Write(Lin_Body2);
//                                 end;

//                                 //Creo el detalle
//                                 //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//                                 Clear(Lin_Body2);
//                                 Lin_Body2 := 'D'; //Detalle
//                                 Contador := Contador + 1;
//                                 Clear(Blanco);
//                                 Lin_Body2 += Format(Contador, 6, '<Integer,6><Filler Character,0>'); //Secuencia
//                                 case Empl."Document Type" of //Tipo documento
//                                     0:
//                                         Lin_Body2 += 'CD';
//                                     1:
//                                         Lin_Body2 += 'PP';
//                                     else
//                                         Lin_Body2 += 'OT';
//                                 end;
//                                 Lin_Body2 += Format(DelChr(Empl."Document ID", '=', '-. '), 20); //ID Documento
//                                 Empl."Full Name" := FuncNom.Ascii2Ansi(Empl."Full Name");
//                                 Lin_Body2 += Format(CopyStr(Empl."Full Name", 1, 60), 60); //Nombre
//                                 Lin_Body2 += 'C'; //Tipo de operacion. D=Debito, C=Credito
//                                                   //Lin_Body2 += FORMAT(DIPG."Cod. Banco",4); //No. Banco destino
//                                 Lin_Body2 += 'BLDH'; //No. Banco destino
//                                 DIPG.TestField("Numero Cuenta");
//                                 Lin_Body2 += DIPG."Numero Cuenta" + Format(Blanco, 30 - StrLen(DIPG."Numero Cuenta"), '<Filler Character, >'); //No. cuenta beneficiario

//                                 if DIPG."Tipo Cuenta" = DIPG."Tipo Cuenta"::Credit then //Tipo de cuenta
//                                     Lin_Body2 += 'DDA'
//                                 else
//                                     Lin_Body2 += 'SAV';
//                                 Lin_Body2 += '214'; //Divisa, 214=RD$, 840=US$, 978=EUR
//                                 HCN.CalcFields("Total Ingresos", "Total deducciones");
//                                 Total := Round(HCN."Total Ingresos" + HCN."Total deducciones", 0.01);
//                                 TotalGeneral += Total;
//                                 //MESSAGE('%1',CONVERTSTR(FORMAT(Total,15,'<Integer,12><Decimals,3>'),' ','0'));
//                                 Lin_Body2 += ConvertStr(Format(Total * 100, 15, '<Integer>'), ' ', '0'); //Importe a pagar

//                                 Total := 0;
//                                 Lin_Body2 += Format(Total, 30, '<Integer,30><Filler character,0>');
//                                 if (Empl."E-Mail" <> '') or (Empl."Company E-Mail" <> '') then begin
//                                     Lin_Body2 += 'Y';
//                                     if Empl."Company E-Mail" <> '' then
//                                         Lin_Body2 += Format(Empl."Company E-Mail", 60)
//                                     else
//                                         Lin_Body2 += Format(Empl."E-Mail", 60);
//                                 end
//                                 else begin
//                                     Lin_Body2 += 'N';
//                                     Lin_Body2 += Format(Empl."Company E-Mail", 60);
//                                 end;
//                                 Concepto := StrSubstNo(Text003, GHCN.Inicio, GHCN.Fin);
//                                 Lin_Body2 += Format(CopyStr(Concepto, 1, 20), 20);
//                                 Lin_Body2 += Format(Blanco, 80, '<Filler Character, >');
//                                 Lin_Body2 += '0000';
//                                 Lin_Body2 += 'I';
//                                 Lin_Body2 += 'N';
//                                 Lin_Body2 += Format(Blanco, 58, '<Filler Character, >');

//                                 Archivo.Write(Lin_Body2);
//                             end;
//         until HCN.Next = 0;

//         if (UpperCase(BcoNom.Formato) = 'BLH') or (UpperCase(BcoNom.Formato) = 'LOPEZDEHARO') then begin
//             /*
//             TotalGeneral := 0;

//              GHLN.RESET;
//              GHLN.SETFILTER(Período,HCN.GETFILTER(Período));
//              GHLN.SETFILTER("Tipo de nomina",HCN.GETFILTER("Tipo de nomina"));

//              IF GHLN.FINDSET THEN
//                REPEAT
//                  GHCN.GET(GHLN.Ano,GHLN."No. empleado",GHLN.Período,GHLN."Job No.",GHLN."Tipo de nomina");
//                  IF GHCN."Forma de Cobro" = GHCN."Forma de Cobro"::"Transferencia Banc." THEN
//                     TotalGeneral += ROUND(GHLN.Total,0.01);
//                UNTIL GHLN.NEXT = 0;
//                */
//             // MESSAGE('%1 %2',GHLN.GETFILTERS,totalgeneral);
//             Lin_Body2 := 'S';
//             Lin_Body2 += Format(Contador, 6, '<Integer,6><Filler Character,0>');
//             Lin_Body2 += PadStr(CERO, 15 - StrLen(Format(TotalGeneral * 100, 0, '<Integer>')), '0') + Format(TotalGeneral * 100, 0, '<Integer>');
//             Lin_Body2 += Format(Blanco, 378, '<Filler character, >');
//             Archivo.Write(Lin_Body2);
//         end;
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + BcoNom.Formato + '\' + NombreArchivo2;
//         //MESSAGE('%1\ %2',NOMBREARCHIVO,NOMBREARCHIVO2);
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
//         /*
//         Blanco := ';';
//         CERO   := '0';
//         EC.GET(GHCN."Empresa cotización");
//         ConfNomina.GET();
//         ConfNomina.TESTFIELD("Path Archivos Electronicos");
//         ConfNomina.TESTFIELD("Secuencia de archivo Batch");
//         ConfNomina."Secuencia de archivo Batch" := INCSTR(ConfNomina."Secuencia de archivo Batch");
//         ConfNomina.MODIFY;

//         Fecha.RESET;
//         Fecha.SETRANGE(Fecha."Period Type",Fecha."Period Type"::Month);
//         Fecha.SETRANGE(Fecha."Period Start",DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3)));
//         Fecha.FINDFIRST;

//         IF COPYSTR(ConfNomina."Path Archivos Electronicos",STRLEN(ConfNomina."Path Archivos Electronicos")-1,1) <> '\' THEN
//            ConfNomina."Path Archivos Electronicos" += '\';

//         NombreArchivo  := ('c:\temp\' + 'CAMBIO-S-' +
//                           FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                           FORMAT(WORKDATE,0,'<Day,2>') + EC."Identificador Empresa" + '_01.txt');
//         NombreArchivo2 := (ConfNomina."Path Archivos Electronicos" + 'CAMBIO-S-' +
//                           FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                           FORMAT(WORKDATE,0,'<Day,2>') + EC."Identificador Empresa" + '_01.txt');

//         Archivo.TEXTMODE(TRUE);
//         {
//         Archivo.CREATE(ConfNomina."Path Archivos Electronicos" + 'CAMBIO-S-' +
//                        FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                        FORMAT(WORKDATE,0,'<Day,2>') + '.txt');
//         }
//         Archivo.CREATE(NombreArchivo);
//         Archivo.TRUNC;

//         HSalario.RESET;
//         HSalario.SETRANGE("Fecha Hasta",Fecha."Period Start",NORMALDATE(Fecha."Period End"));
//         CounterTotal := HSalario.COUNT;
//         Window.OPEN(Text001);

//         IF HSalario.FINDSET THEN
//            REPEAT
//               Counter := Counter + 1;
//               Window.UPDATE(1,HSalario."No. empleado");
//               Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));

//               Empl.GET(HSalario."No. empleado");
//               Empl.CALCFIELDS(Salario);

//               CLEAR(Lin_Body);
//               Lin_Body := EC."RNC/CED" + Blanco + Empl."Working Center" + Blanco + FORMAT(WORKDATE,0,'<Year4>') + Blanco +
//                           FORMAT(WORKDATE,0,'<Month,2>') + Blanco + 'MSU' + Blanco + Lin_Body + FORMAT(Empl."Document ID",10) +
//                           Blanco + FORMAT(Empl.Salario,14,'<Integer><Decimals,3>') + Blanco + 'O';
//               Archivo.WRITE(Lin_Body);
//            UNTIL HSalario.NEXT = 0;

//         Archivo.CLOSE;
//         RenameFile;
//         */

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
//         /*GRN
//         Blanco := ';';
//         CERO   := '0';
//         EC.GET(GHCN."Empresa cotización");
//         ConfNomina.GET();
//         ConfNomina.TESTFIELD("Path Archivos Electronicos");
//         ConfNomina.TESTFIELD("Secuencia de archivo Batch");
//         ConfNomina."Secuencia de archivo Batch" := INCSTR(ConfNomina."Secuencia de archivo Batch");
//         ConfNomina.MODIFY;

//         Fecha.RESET;
//         Fecha.SETRANGE(Fecha."Period Type",Fecha."Period Type"::Month);
//         Fecha.SETRANGE(Fecha."Period Start",DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3)));
//         Fecha.FINDFIRST;

//         IF COPYSTR(ConfNomina."Path Archivos Electronicos",STRLEN(ConfNomina."Path Archivos Electronicos")-1,1) <> '\' THEN
//            ConfNomina."Path Archivos Electronicos" += '\';

//         Archivo.TEXTMODE(TRUE);
//         NombreArchivo  := 'c:\temp\' + 'VARIACION-S-' +
//                           FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                           FORMAT(WORKDATE,0,'<Day,2>') + '.txt';

//         NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'VARIACION-S-' +
//                           FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                           FORMAT(WORKDATE,0,'<Day,2>') + '.txt';

//         {
//         Archivo.CREATE(ConfNomina."Path Archivos Electronicos" + 'VARIACION-S-' +
//                        FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                        FORMAT(WORKDATE,0,'<Day,2>') + '.txt');
//         }

//         Archivo.TRUNC;

//         HCabNomina.RESET;
//         HCabNomina.SETRANGE("Tipo Nomina",GHCN."Tipo Nomina");
//         HCabNomina.SETRANGE(Período,GHCN.Período);

//         CounterTotal := HCabNomina.COUNT;
//         Window.OPEN(Text001);

//         HCabNomina.FINDSET;
//         REPEAT
//           Counter := Counter + 1;
//           Window.UPDATE(1,HCabNomina."No. empleado");
//           Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));

//           Empl.GET(HCabNomina."No. empleado");
//           Acumulado := 0;

//           HLinNomina.RESET;
//           HLinNomina.SETRANGE("No. empleado",HCabNomina."No. empleado");
//           HLinNomina.SETRANGE("Tipo de Nomina",HCabNomina."Tipo de Nomina");
//           HLinNomina.SETRANGE(Período,HCabNomina.Período);
//           HLinNomina.SETRANGE("Salario Base",FALSE);
//           HLinNomina.SETRANGE("Sujeto Cotización",TRUE);
//           IF HLinNomina.FINDSET THEN
//              REPEAT
//               Acumulado += HLinNomina.Total;
//              UNTIL HLinNomina.NEXT = 0;

//           IF Acumulado <> 0 THEN
//              BEGIN
//                 CLEAR(Lin_Body);
//                 Lin_Body := EC."RNC/CED" + Blanco + Empl."Working Center" + Blanco + FORMAT(WORKDATE,0,'<Year4>') + Blanco +
//                             FORMAT(WORKDATE,0,'<Month,2>') + Blanco + 'INS' + Blanco + Lin_Body + FORMAT(Empl."Document ID",10) +
//                             Blanco + FORMAT(Acumulado,14,'<Integer><Decimals,3>') + Blanco + 'O';
//                 Archivo.WRITE(Lin_Body);
//              END;
//         UNTIL HCabNomina.NEXT =0;
//         Window.CLOSE;
//         Archivo.CLOSE;

//         RenameFile;
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
//         /*
//         FirstTime := TRUE;
//         Blanco := ' ';
//         CERO   := '0';

//         ConfNomina.GET();
//         ConfNomina.TESTFIELD("Path Archivos Electronicos");
//         ConfNomina.TESTFIELD("Secuencia de archivo Batch");
//         ConfNomina.TESTFIELD("Dimension Empleado");

//         GenJnlLine.RESET;
//         GenJnlLine.SETRANGE("Journal Template Name",CodDiario);
//         GenJnlLine.SETRANGE("Journal Batch Name",SeccDiario);
//         GenJnlLine.SETRANGE("Account Type",GenJnlLine."Account Type"::"Bank Account");
//         GenJnlLine.SETFILTER("Account No.",'<>%1','');
//         IF NOT GenJnlLine.FINDFIRST THEN
//            BEGIN
//             GenJnlLine.RESET;
//             GenJnlLine.SETRANGE("Journal Template Name",CodDiario);
//             GenJnlLine.SETRANGE("Journal Batch Name",SeccDiario);
//             GenJnlLine.SETRANGE("Bal. Account Type",GenJnlLine."Account Type"::"Bank Account");
//             GenJnlLine.SETFILTER("Bal. Account No.",'<>%1','');
//             IF NOT GenJnlLine.FINDFIRST THEN
//                ERROR(Err002);
//            END;

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
//         GenJnlLine.SETRANGE("Account Type",GenJnlLine."Account Type"::"G/L Account");
//         CounterTotal := GenJnlLine.COUNT;
//         Window.OPEN(Text001);
//         GenJnlLine.FINDSET;
//         REPEAT
//           Counter := Counter + 1;
//           Window.UPDATE(1,GenJnlLine."Line No.");
//           Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));

//           IF FirstTime THEN
//              BEGIN
//               FirstTime := FALSE;
//               recDimEntry.RESET;
//               recDimEntry.SETRANGE("Dimension Set ID", GenJnlLine."Dimension Set ID");
//               recDimEntry.SETRANGE("Dimension Code",ConfNomina."Dimension Empleado");
//               recDimEntry.FINDFIRST;


//               Empl.GET(recDimEntry."Dimension Value Code"); //Busco el empleado
//               Empl.TESTFIELD(Company);
//               EC.GET(Empl.Company);

//               ConfNomina."Secuencia de archivo Batch" := INCSTR(ConfNomina."Secuencia de archivo Batch");
//               ConfNomina.MODIFY;
//               IF COPYSTR(ConfNomina."Path Archivos Electronicos",STRLEN(ConfNomina."Path Archivos Electronicos"),1) <> '\' THEN
//                  ConfNomina."Path Archivos Electronicos" += '\';

//               Archivo.TEXTMODE(TRUE);
//               NombreArchivo  := 'c:\temp\' + 'NCR' +
//                                 FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                                 FORMAT(WORKDATE,0,'<Day,2>') + EC."Identificador Empresa" + '_01.txt';
//               NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + 'NCR' +
//                                 FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                                 FORMAT(WORKDATE,0,'<Day,2>') + EC."Identificador Empresa" + '_01.txt';
//               {
//               Archivo.CREATE(ConfNomina."Path Archivos Electronicos" + 'NCR' +
//                              FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') +
//                              FORMAT(WORKDATE,0,'<Day,2>') + EC."Identificador Empresa" + '_01.txt');
//               }
//               Archivo.CREATE(NombreArchivo);
//               Archivo.TRUNC;
//              END;

//           recDimEntry.RESET;
//           recDimEntry.SETRANGE("Dimension Set ID", GenJnlLine."Dimension Set ID");
//           recDimEntry.SETRANGE("Dimension Code",ConfNomina."Dimension Empleado");
//           recDimEntry.FINDFIRST;

//           Empl.GET(recDimEntry."Dimension Value Code"); //Busco el empleado


//           DIPG.RESET;
//           DIPG.SETRANGE("No. empleado",Empl."No.");
//           DIPG.FINDFIRST;
//           CLEAR(Lin_Body);
//           CASE DIPG."Tipo Cuenta" OF
//             0:
//              Lin_Body := 'A'
//           ELSE
//              Lin_Body := 'C';
//           END;

//           BcoACH.GET(DIPG."Cod. Banco");
//           IF EC.Banco = DIPG."Cod. Banco" THEN
//              BEGIN
//               CERO := PADSTR(CERO,10-STRLEN(DIPG."Numero Cuenta"),'0');
//               Lin_Body += CERO + FORMAT(DIPG."Numero Cuenta");
//               Lin_Body += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,15,'<integer,15><Filler Character,0>');
//               Lin_Body += 'XXY01';
//               Lin_Body += FORMAT(Blanco,38);
//              END
//           ELSE
//              BEGIN
//               CERO := PADSTR(CERO,10,'0');
//               Lin_Body += CERO;
//               Lin_Body += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,15,'<integer,15><Filler Character,0>');
//               Lin_Body += 'XXY01';

//               Lin_Body += BcoACH."Cod. Institucion Financiera";
//               CERO := PADSTR(CERO,18-STRLEN(DIPG."Numero Cuenta"),'0');
//               Lin_Body += CERO + FORMAT(DIPG."Numero Cuenta");
//               Lin_Body += COPYSTR(Empl."Full Name",1,18);
//              END;

//           Lin_Body += EC."Identificador Empresa";

//           Lin_Body += FORMAT(Empl."E-Mail",30);
//           CERO := PADSTR(CERO,10,'0');
//           Lin_Body += FORMAT(CERO,10); //Informacion del Celular

//           Lin_Body += FORMAT(Blanco,3);  //Banco Destino para el pago interbancario
//           CASE Empl."Document Type" OF
//            0: //Cedula
//             BEGIN
//              Lin_Body += 'C';
//              Lin_Body += FORMAT(Empl."Document ID",13);
//             END;
//            1: //Pasaporte
//             BEGIN
//              Lin_Body += 'P';
//              Lin_Body += FORMAT(Empl."Document ID",13);
//             END;
//            ELSE
//             BEGIN
//              Lin_Body += 'R';
//              Lin_Body += FORMAT(Empl."Document ID",13);
//             END;
//           END;
//           Archivo.WRITE(Lin_Body);
//         UNTIL GenJnlLine.NEXT = 0;
//         Window.CLOSE;
//         Archivo.CLOSE;

//         RenameFile;
//         */

//     end;


//     procedure FormatoPagoProveedores(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         Err001: Label 'The bank account must be the same in all the lines, please correct it';
//         GenJnlLine: Record "Gen. Journal Line";
//         VendorBank: Record "Vendor Bank Account";
//         BcoACH: Record "Bancos ACH Nomina";
//         Vendor: Record Vendor;
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
//         //Verifico que todas las lineas del diario tengan el mismo banco
//         FirstTime := true;
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.FindSet;
//         repeat
//             if FirstTime then begin
//                 FirstTime := false;
//                 BancoAnt := GenJnlLine."Bal. Account No.";
//                 BankAccount.Get(BancoAnt);
//             end;
//             if BancoAnt <> GenJnlLine."Bal. Account No." then
//                 Error(Err001);
//         until GenJnlLine.Next = 0;

//         BankAccount.TestField(Formato);
//         BankAccount.TestField("E-Pay Export File Path");
//         //MESSAGE('%1',BankAccount.Formato);

//         BankAccount.Formato := UpperCase(BankAccount.Formato);
//         case UpperCase(BankAccount.Formato) of
//             'BPD', 'POPULAR':
//                 FormatoBPD(CodDiario, SeccDiario);
//             'BHD':
//                 FormatoBHD(CodDiario, SeccDiario);
//             'SCA', 'SCOTIA', 'SCOTIABANK':
//                 FormatoSCA(CodDiario, SeccDiario);
//             'RES', 'RESERVA', 'RESERVAS':
//                 FormatoRES(CodDiario, SeccDiario);
//         end;
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
//         ConfEmpresa: Record "Empresas Cotizacion";
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

//     end;


//     procedure RenameFile()
//     var
//         FileManagement: Codeunit "File Management";
//     begin
//         FileManagement.DownloadToFile(NombreArchivo, NombreArchivo2);
//     end;

//     local procedure FormatoBPD(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         GenJnlLine2: Record "Gen. Journal Line";
//         RNC: Text[30];
//         Blanco: Text[60];
//         Cero: Text[1];
//         FechaTrans: Date;
//         Mes: Integer;
//         Secuencia: Code[10];
//         CodBco: Code[20];
//         Total: Decimal;
//         Contador: Integer;
//     begin
//         CompanyInfo.Get();
//         ConfContab.Get();
//         CompanyInfo.TestField("VAT Registration No.");
//         RNC := DelChr(CompanyInfo."VAT Registration No.", '=', '-');

//         Blanco := ' ';
//         Cero := '0';
//         PrimeraVez := true;
//         TotalGeneral := 0;
//         BankAccount.TestField("Identificador Empresa");

//         if CopyStr(BankAccount."E-Pay Export File Path", StrLen(BankAccount."E-Pay Export File Path"), 1) <> '\' then
//             BankAccount."E-Pay Export File Path" += '\';

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindFirst;

//         if GenJnlLine."Posting Date" < Today then
//             Error(Err003);
//         FechaTrans := GenJnlLine."Posting Date";
//         PathENV := TemporaryPath;

//         NombreArchivo := 'PE' + BankAccount."Identificador Empresa" + '01' + Format(FechaTrans, 0, '<Month,2>') + Format(FechaTrans, 0, '<Day,2>');

//         Mes := Date2DMY(FechaTrans, 2);
//         Mes := Mes * 2;

//         if BankAccount.Secuencia = '' then begin
//             if Mes < 10 then
//                 Secuencia := '000000' + Format(Mes)
//             else
//                 Secuencia := '00000' + Format(Mes);

//             BankAccount.Secuencia := IncStr(BankAccount.Secuencia);
//             BankAccount.Modify;
//         end
//         else begin
//             BankAccount.Secuencia := IncStr(BankAccount.Secuencia);
//             BankAccount.Modify;
//             Secuencia := BankAccount.Secuencia;
//         end;
//         NombreArchivo += Secuencia + 'E.txt';
//         NombreArchivo2 := NombreArchivo;
//         SecuenciaTrans := '0000000';

//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindSet;
//         CounterTotal := GenJnlLine.Count;
//         Window.Open(Text001);

//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, GenJnlLine."Account No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//             if PrimeraVez then begin
//                 PrimeraVez := false;
//                 //Creo la cabecera
//                 GenJnlLine2.Reset;
//                 GenJnlLine2.CopyFilters(GenJnlLine);
//                 GenJnlLine2.SetRange("Check Printed", false);
//                 GenJnlLine2.SetRange("Check Exported", false);
//                 GenJnlLine2.FindSet;
//                 repeat
//                     TotalGeneral += Round(GenJnlLine2.Amount, 0.01);
//                 until GenJnlLine2.Next = 0;

//                 Lin_Body := 'H';
//                 Lin_Body += Format(RNC, 15);
//                 Lin_Body += Format(CompanyInfo.Name, 35);
//                 Lin_Body += Secuencia + '02';
//                 Lin_Body += Format(FechaTrans, 0, '<Year4><Month,2><Day,2>');
//                 Lin_Body += '000000000000000000000000';
//                 Lin_Body += Format(CounterTotal, 11, '<Integer,11><Filler Character,0>');
//                 Lin_Body += Format(TotalGeneral * 100, 13, '<integer,13><Filler Character,0>');
//                 Lin_Body += '000000000000000';
//                 Lin_Body += Format(Today, 0, '<Year4><Month,2><Day,2>');
//                 Lin_Body += Format(Time, 4, '<hours24,2><Minutes,2>');
//                 Lin_Body += Format(CompanyInfo."E-Mail", 40);
//                 Lin_Body += Format(Blanco, 136);
//                 Archivo.Write(Lin_Body);
//             end;

//             //Creo el detalle
//             Clear(Vendor);
//             SecuenciaTrans := IncStr(SecuenciaTrans);
//             Clear(Lin_Body);
//             Lin_Body := 'N';
//             Lin_Body += Format(RNC, 15);
//             Lin_Body += Format(Secuencia, 7);
//             Lin_Body += Format(SecuenciaTrans, 7);


//             if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                 Vendor.Get(GenJnlLine."Account No.");
//                 BankAccount.Get(GenJnlLine."Bal. Account No.");
//                 VendorBank.Reset;
//                 VendorBank.SetRange("Vendor No.", GenJnlLine."Account No.");
//                 VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                 CodBco := GenJnlLine."Bal. Account No.";
//                 VendorBank.FindFirst;
//                 VendorBank.TestField("Bank Account No.");
//                 //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                 //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                 //BcoACH.TESTFIELD("Ruta y Transito");
//             end
//             else
//                 if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
//                     Vendor.Get(GenJnlLine."Bal. Account No.");
//                     BankAccount.Get(GenJnlLine."Account No.");
//                     VendorBank.Reset;
//                     VendorBank.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
//                     VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                     CodBco := GenJnlLine."Account No.";
//                     VendorBank.FindFirst;
//                     VendorBank.TestField("Bank Account No.");
//                     //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                     //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                     //BcoACH.TESTFIELD("Ruta y Transito");
//                 end;

//             BankAccount."Bank Account No." := DelChr(BankAccount."Bank Account No.", '=', '-/., ');

//             //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//             if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") and  // Para cuando es transferencias entre bancos
//                (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") then begin
//                 BankAccount2.Get(GenJnlLine."Account No.");
//                 BankAccount2.TestField("Bank Account No.");
//                 //BankAccount2.TESTFIELD("Bank Code");
//                 BankAccount2."Bank Account No." := DelChr(BankAccount2."Bank Account No.", '=', '-/., ');

//                 Lin_Body += Format(BankAccount2."Bank Account No.") + Format(Blanco, 20 - StrLen(BankAccount2."Bank Account No."));
//                 Lin_Body += '1';
//                 if StrPos(ConfContab."LCY Code", 'US') <> 0 then begin
//                     if StrPos(GenJnlLine."Currency Code", 'DO') <> 0 then
//                         Lin_Body += '214'
//                     else
//                         if StrPos(GenJnlLine."Currency Code", 'EU') <> 0 then
//                             Lin_Body += '978'
//                         else
//                             Lin_Body += '840'; //Moneda 214=RD$, 840=USD, 978=Euro
//                 end
//                 else
//                     if StrPos(ConfContab."LCY Code", 'DO') <> 0 then begin
//                         if StrPos(GenJnlLine."Currency Code", 'US') <> 0 then
//                             Lin_Body += '840'
//                         else
//                             if StrPos(GenJnlLine."Currency Code", 'EU') <> 0 then
//                                 Lin_Body += '978'
//                             else
//                                 Lin_Body += '214'; //Moneda 214=RD$, 840=USD, 978=Euro
//                     end;

//                 Lin_Body += BankAccount2."SWIFT Code";//Aqui debe tener el Identificador del banco + codigo ACH + Digito de chequeo
//                 Vendor."E-Mail" := BankAccount2."E-Mail";

//                 if BankAccount2."Tipo Cuenta" = 0 then //Corriente
//                     Lin_Body += '22'
//                 else
//                     if BankAccount2."Tipo Cuenta" = 1 then //Ahorro
//                         Lin_Body += '32'
//                     else
//                         Lin_Body += '52'; //Tarjeta o Prestamo
//             end
//             else begin
//                 if (VendorBank."Bank Account No." <> '') and (VendorBank."Tipo Cuenta" <> 2) then
//                     Lin_Body += Format(VendorBank."Bank Account No.") + Format(Blanco, 20 - StrLen(VendorBank."Bank Account No."))
//                 else
//                     if VendorBank."Tipo Cuenta" <> 2 then
//                         Error(Err002, GenJnlLine."Account No." + ', ' + GenJnlLine.Beneficiario)
//                     else
//                         if VendorBank."Tipo Cuenta" = 2 then
//                             Lin_Body += Format(Blanco, 20);

//                 if VendorBank."Tipo Cuenta" = 0 then //Corriente
//                     Lin_Body += '1'
//                 else
//                     if VendorBank."Tipo Cuenta" = 1 then //Ahorro
//                         Lin_Body += '2'
//                     else
//                         Lin_Body += '5';

//                 if StrPos(ConfContab."LCY Code", 'US') <> 0 then begin
//                     if StrPos(GenJnlLine."Currency Code", 'DO') <> 0 then
//                         Lin_Body += '214'
//                     else
//                         if StrPos(GenJnlLine."Currency Code", 'EU') <> 0 then
//                             Lin_Body += '978'
//                         else
//                             Lin_Body += '840'; //Moneda 214=RD$, 840=USD, 978=Euro

//                     //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                     if (StrPos(GenJnlLine."Currency Code", 'DO') = 0) and (BcoACH."Cod. Institucion Financiera" <> 'BPD') then begin
//                         Lin_Body += '8' + CopyStr(BcoACH."ACH Reservas", 2, 10);
//                         Lin_Body += 'L';
//                     end
//                     else begin
//                         Lin_Body += BcoACH."ACH Reservas";
//                         Lin_Body += Format(BcoACH."Digito Chequeo");
//                     end;
//                 end
//                 else
//                     if StrPos(ConfContab."LCY Code", 'DO') <> 0 then begin
//                         if StrPos(GenJnlLine."Currency Code", 'US') <> 0 then
//                             Lin_Body += '840'
//                         else
//                             if StrPos(GenJnlLine."Currency Code", 'EU') <> 0 then
//                                 Lin_Body += '978'
//                             else
//                                 Lin_Body += '214'; //Moneda 214=RD$, 840=USD, 978=Euro

//                         //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                         if (GenJnlLine."Currency Code" = '') or (BcoACH."Cod. Institucion Financiera" = 'BPD') then begin
//                             Lin_Body += BcoACH."ACH Reservas";
//                             Lin_Body += Format(BcoACH."Digito Chequeo");
//                         end
//                         else begin
//                             Lin_Body += '8' + CopyStr(BcoACH."ACH Reservas", 2, 10);
//                             Lin_Body += 'L';
//                         end;
//                     end;

//                 if VendorBank."Tipo Cuenta" = 0 then //Corriente
//                     Lin_Body += '22'
//                 else
//                     if VendorBank."Tipo Cuenta" = 1 then //Ahorro
//                         Lin_Body += '32'
//                     else
//                         Lin_Body += '12';
//             end;

//             Lin_Body += Format(GenJnlLine.Amount * 100, 13, '<integer,13><Filler Character,0>');

//             //GRN Se cambia por tipo doc y numero Lin_Body += FORMAT(Blanco,17,'<Text,17>');
//             Vendor."VAT Registration No." := DelChr(Vendor."VAT Registration No.", '=', '-');
//             if StrLen(Vendor."VAT Registration No.") > 9 then
//                 Lin_Body += 'CE'
//             else
//                 Lin_Body += 'RN';

//             Lin_Body += PadStr(Blanco, 15 - StrLen(Vendor."VAT Registration No.")) + Vendor."VAT Registration No.";
//             Lin_Body += Format(CopyStr(GenJnlLine.Beneficiario, 1, 35), 35);
//             Lin_Body += Format(FechaTrans, 12, '<Year4><Month,2><Day,2><Filler Character,0>');
//             if StrPos(CompanyInfo.Name, ',') <> 0 then
//                 Lin_Body += Format(CopyStr(CopyStr(CompanyInfo.Name, 1, StrPos(CompanyInfo.Name, ',') - 1) + '-' + GenJnlLine.Description, 1, 40), 40)
//             else
//                 Lin_Body += Format(CopyStr(CompanyInfo.Name, 1, 40), 40);
//             Lin_Body += Format(Blanco, 4);
//             if Vendor."E-Mail" <> '' then
//                 Lin_Body += '1'
//             else
//                 Lin_Body += ' ';

//             if StrLen(Vendor."E-Mail") <= 40 then
//                 Lin_Body += Format(Vendor."E-Mail", 40);

//             Lin_Body += Format(Blanco, 12);
//             Lin_Body += '00';

//             Lin_Body += Format(Blanco, 78);
//             Archivo.Write(Lin_Body);

//             Contador := Contador + 1;
//             /*GRN

//                 CASE BankAccount."Export Format" OF
//                   BankAccount."Export Format"::US:
//                     TraceNumber := ExportPaymentsACH.ExportElectronicPayment(GenJnlLine,ExportAmount);
//                   BankAccount."Export Format"::CA:
//                     TraceNumber := ExportPaymentsRB.ExportElectronicPayment(GenJnlLine,ExportAmount,SettleDate);
//                   BankAccount."Export Format"::MX:
//                     TraceNumber := ExportPaymentsCecoban.ExportElectronicPayment(GenJnlLine,ExportAmount,SettleDate);
//                 END;
//             */
//             Tracenumber := Format(CurrentDateTime);
//             Tracenumber := DelChr(Tracenumber, '=', '._-:');
//             ExportAmount := GenJnlLine.Amount;
//             GenJnlLine."Check Printed" := true;
//             GenJnlLine."Check Exported" := true;
//             GenJnlLine."Check Transmitted" := true;

//             GenJnlLine."Export File Name" := NombreArchivo2;
//             BankAccount.TestField("Last Remittance Advice No.");
//             GenJnlLine."Document No." := IncStr(BankAccount."Last Remittance Advice No.");

//             BankAccount."Last Remittance Advice No." := IncStr(BankAccount."Last Remittance Advice No.");
//             BankAccount."Last E-Pay Export File Name" := NombreArchivo;
//             BankAccount.Modify;


//             GenJnlLine."Exported to Payment File" := true;
//             InsertIntoCheckLedger(Tracenumber, -ExportAmount, GenJnlLine);
//             GenJnlLine.Modify;

//         until GenJnlLine.Next = 0;
//         Window.Close;
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := BankAccount."E-Pay Export File Path" + NombreArchivo2;
//         //MESSAGE('%1\ %2',NOMBREARCHIVO,NOMBREARCHIVO2);
//         RenameFile;

//     end;

//     local procedure FormatoBHD(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         Empresa: Record "Company Information";
//         GenJnlLine2: Record "Gen. Journal Line";
//         Secuencia: Text;
//         CodBco: Code[20];
//         RNC: Code[20];
//     begin
//         //BHD
//         CompanyInfo.Get();
//         CompanyInfo.TestField("VAT Registration No.");
//         RNC := DelChr(CompanyInfo."VAT Registration No.", '=', '-');

//         Blanco := ' ';
//         CERO := '0';
//         TotalGeneral := 0;
//         PrimeraVez := true;
//         BankAccount.TestField("Identificador Empresa");

//         if CopyStr(BankAccount."E-Pay Export File Path", StrLen(BankAccount."E-Pay Export File Path"), 1) <> '\' then
//             BankAccount."E-Pay Export File Path" += '\';

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindFirst;

//         PathENV := TemporaryPath;

//         NombreArchivo := 'PE-BHD-' + BankAccount."Identificador Empresa" + '-' + Format(WorkDate, 0, '<Month,2>') + Format(WorkDate, 0, '<Day,2>');

//         if BankAccount.Secuencia = '' then begin
//             Secuencia := 'HHH0000000';

//             BankAccount.Secuencia := IncStr(BankAccount.Secuencia);
//             BankAccount.Modify;
//         end;

//         SecuenciaTrans := BankAccount.Secuencia;
//         NombreArchivo += Secuencia + '.txt';
//         NombreArchivo2 := NombreArchivo;

//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindSet;
//         CounterTotal := GenJnlLine.Count;
//         Window.Open(Text001);
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, GenJnlLine."Account No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             if GenJnlLine."Posting Date" < WorkDate then
//                 Error(Err003);

//             //Creo el detalle
//             Clear(Vendor);
//             Clear(Lin_Body);
//             if PrimeraVez then begin
//                 PrimeraVez := false;
//                 SecuenciaTrans := 'HHH0000000';
//                 //Creo la cabecera
//                 BankAccount."Bank Account No." := DelChr(BankAccount."Bank Account No.", '=', '-/., ');
//                 Lin_Body := BankAccount."Bank Account No." + ';'; //Cuenta de la empresa

//                 GenJnlLine2.Reset;
//                 GenJnlLine2.CopyFilters(GenJnlLine);
//                 GenJnlLine2.SetRange("Check Printed", false);
//                 GenJnlLine2.SetRange("Check Exported", false);
//                 GenJnlLine2.FindSet;
//                 repeat
//                     TotalGeneral += Round(GenJnlLine2.Amount, 0.01);
//                 until GenJnlLine2.Next = 0;

//                 Lin_Body := BankAccount."Bank Account No." + ';';
//                 Lin_Body += 'BHD;';
//                 Lin_Body += 'CC;';
//                 Lin_Body += DelChr(CompanyInfo.Name, '=', ';') + ';';
//                 Lin_Body += 'D;';
//                 Lin_Body += Format(TotalGeneral, 0, '<Integer><Decimals,3>') + ';';
//                 Lin_Body += SecuenciaTrans + ';';
//                 Lin_Body += 'TRANSFERENCIA ELECTRONICA;';
//                 Archivo.Write(Lin_Body);
//             end;

//             if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                 Vendor.Get(GenJnlLine."Account No.");
//                 BankAccount.Get(GenJnlLine."Bal. Account No.");
//                 VendorBank.Reset;
//                 VendorBank.SetRange("Vendor No.", GenJnlLine."Account No.");
//                 VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                 CodBco := GenJnlLine."Bal. Account No.";
//                 VendorBank.FindFirst;
//                 VendorBank.TestField("Bank Account No.");
//                 //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                 //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                 //      BcoACH.TESTFIELD("Ruta y Transito");
//             end
//             else
//                 if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
//                     Vendor.Get(GenJnlLine."Bal. Account No.");
//                     BankAccount.Get(GenJnlLine."Account No.");
//                     VendorBank.Reset;
//                     VendorBank.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
//                     VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                     CodBco := GenJnlLine."Account No.";
//                     VendorBank.FindFirst;
//                     VendorBank.TestField("Bank Account No.");
//                     //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                     //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                     //BcoACH.TESTFIELD("Ruta y Transito");
//                 end;
//             //fes mig BcoACH.GET(VendorBank."Banco RED ACH");

//             Clear(Lin_Body);
//             VendorBank."Bank Account No." := DelChr(VendorBank."Bank Account No.", '=', '-/., ');
//             Lin_Body := VendorBank."Bank Account No." + ';'; //Cuenta del proveedor

//             Lin_Body += BcoACH."Cod. Institucion Financiera" + ';'; //Banco y ruta destino
//             if VendorBank."Tipo Cuenta" = 0 then //Corriente
//                 Lin_Body += 'CC'
//             else
//                 if VendorBank."Tipo Cuenta" = 1 then //Ahorro
//                     Lin_Body += 'CA'
//                 else
//                     Lin_Body += 'PR';

//             GenJnlLine.Beneficiario := DelChr(GenJnlLine.Beneficiario, '=', ';');
//             Lin_Body += ';' + CopyStr(GenJnlLine.Beneficiario, 1, 22) + ';';
//             Lin_Body += 'C;';
//             Lin_Body += Format(GenJnlLine.Amount, 0, '<Integer><Decimals,3>') + ';';
//             SecuenciaTrans := IncStr(SecuenciaTrans);
//             Lin_Body += SecuenciaTrans + ';';
//             GenJnlLine.Description := DelChr(GenJnlLine.Description, '=', ';');
//             Lin_Body += CopyStr(GenJnlLine.Description, 1, 80) + ';';
//             Lin_Body += Vendor."E-Mail";


//             Archivo.Write(Lin_Body);

//             Tracenumber := Format(CurrentDateTime);
//             Tracenumber := DelChr(Tracenumber, '=', '._-:');
//             ExportAmount := GenJnlLine.Amount;
//             GenJnlLine."Check Printed" := true;
//             GenJnlLine."Check Exported" := true;
//             GenJnlLine."Check Transmitted" := true;
//             //jpg eliminar hhh a la secuencia para campo "EP Bulk No. Line"

//             GenJnlLine."Export File Name" := NombreArchivo2;
//             BankAccount.TestField("Last Remittance Advice No.");
//             GenJnlLine."Document No." := IncStr(BankAccount."Last Remittance Advice No.");

//             BankAccount."Last Remittance Advice No." := IncStr(BankAccount."Last Remittance Advice No.");
//             BankAccount."Last E-Pay Export File Name" := NombreArchivo;
//             BankAccount.Modify;


//             GenJnlLine."Exported to Payment File" := true;
//             InsertIntoCheckLedger(Tracenumber, -ExportAmount, GenJnlLine);
//             GenJnlLine.Modify;
//         until GenJnlLine.Next = 0;

//         BankAccount.Secuencia := SecuenciaTrans;
//         BankAccount.Modify;

//         Window.Close;
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := BankAccount."E-Pay Export File Path" + NombreArchivo2;
//         RenameFile;
//         Message(MSG001);
//     end;

//     local procedure FormatoRES(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         Empresa: Record "Company Information";
//         Secuencia: Text;
//         CodBco: Code[20];
//         RNC: Code[20];
//     begin
//         //Reservas

//         CompanyInfo.Get();
//         CompanyInfo.TestField("VAT Registration No.");
//         RNC := DelChr(CompanyInfo."VAT Registration No.", '=', '-');

//         Blanco := ' ';
//         CERO := '0';
//         TotalGeneral := 0;
//         BankAccount.TestField("Identificador Empresa");

//         if CopyStr(BankAccount."E-Pay Export File Path", StrLen(BankAccount."E-Pay Export File Path"), 1) <> '\' then
//             BankAccount."E-Pay Export File Path" += '\';

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindFirst;

//         PathENV := TemporaryPath;

//         NombreArchivo := 'PE-BR-' + BankAccount."Identificador Empresa" + '-' + Format(WorkDate, 0, '<Month,2>') + Format(WorkDate, 0, '<Day,2>');

//         if BankAccount.Secuencia = '' then begin
//             Secuencia := '000000';

//             BankAccount.Secuencia := IncStr(BankAccount.Secuencia);
//             BankAccount.Modify;
//         end
//         else begin
//             BankAccount.Secuencia := IncStr(BankAccount.Secuencia);
//             BankAccount.Modify;
//             Secuencia := BankAccount.Secuencia;
//         end;
//         NombreArchivo += Secuencia + '.txt';
//         NombreArchivo2 := NombreArchivo;

//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindSet;
//         CounterTotal := GenJnlLine.Count;
//         Window.Open(Text001);
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, GenJnlLine."Account No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             if GenJnlLine."Posting Date" < Today then
//                 Error(Err003);

//             //Creo el detalle
//             Clear(Vendor);
//             Clear(Lin_Body);
//             if BankAccount."Tipo Cuenta" = BankAccount."Tipo Cuenta"::"CA=Cuenta de Ahorro" then
//                 Lin_Body := 'ÇA'
//             else
//                 Lin_Body := 'ÇC';

//             if BankAccount."Currency Code" = '' then
//                 Lin_Body += 'DOP'
//             else
//                 Lin_Body += BankAccount."Currency Code";
//             BankAccount."Bank Account No." := DelChr(BankAccount."Bank Account No.", '=', '-/., ');
//             Lin_Body += BankAccount."Bank Account No." + ','; //Cuenta de origen

//             if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                 Vendor.Get(GenJnlLine."Account No.");
//                 BankAccount.Get(GenJnlLine."Bal. Account No.");
//                 VendorBank.Reset;
//                 VendorBank.SetRange("Vendor No.", GenJnlLine."Account No.");
//                 VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                 CodBco := GenJnlLine."Bal. Account No.";
//                 VendorBank.FindFirst;
//                 VendorBank.TestField("Bank Account No.");
//                 //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                 //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                 //BcoACH.TESTFIELD("Ruta y Transito");
//             end
//             else
//                 if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
//                     Vendor.Get(GenJnlLine."Bal. Account No.");
//                     BankAccount.Get(GenJnlLine."Account No.");
//                     VendorBank.Reset;
//                     VendorBank.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
//                     VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                     CodBco := GenJnlLine."Account No.";
//                     VendorBank.FindFirst;
//                     VendorBank.TestField("Bank Account No.");
//                     //fes mig  VendorBank.TESTFIELD("Banco RED ACH");
//                     //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                     //BcoACH.TESTFIELD("Ruta y Transito");
//                 end;
//             //fes mig BcoACH.GET(VendorBank."Banco RED ACH");


//             Lin_Body += BcoACH."ACH Reservas" + ','; //Banco y ruta destino

//             //Tipo cuenta ==> AH= ahorro, CC= Corriente, TC = Tarjeta de crédito, PR = Préstamos
//             if (VendorBank."Bank Account No." <> '') and (VendorBank."Tipo Cuenta" <> 2) then
//                 Lin_Body += VendorBank."Bank Account No."
//             else
//                 if VendorBank."Tipo Cuenta" <> 2 then
//                     Error(Err002, GenJnlLine."Account No." + ', ' + GenJnlLine.Beneficiario)
//                 else
//                     if VendorBank."Tipo Cuenta" = 2 then
//                         Lin_Body += Format(Blanco, 20);
//             Lin_Body += ',';
//             if VendorBank."Tipo Cuenta" = 0 then //Corriente
//                 Lin_Body += 'CC'
//             else
//                 Lin_Body += 'CA';

//             VendorBank."Bank Account No." := DelChr(VendorBank."Bank Account No.", '=', '-/., ');

//             Lin_Body += ',';
//             Lin_Body += Format(GenJnlLine.Amount * 100, 13, '<integer,13><Filler Character,0>') + ',';
//             GenJnlLine.Beneficiario := DelChr(GenJnlLine.Beneficiario, '=', ',');
//             Lin_Body += CopyStr(GenJnlLine.Beneficiario, 1, 22) + ',';
//             Vendor.TestField("VAT Registration No.");
//             if StrLen(DelChr(Vendor."VAT Registration No.", '=', ' -')) = 9 then
//                 Lin_Body += 'RNC'
//             else
//                 if StrLen(DelChr(Vendor."VAT Registration No.", '=', ' -')) = 11 then
//                     Lin_Body += 'Cedula'
//                 else
//                     Lin_Body += 'Pasaporte';
//             Lin_Body += RNC + ',';
//             GenJnlLine.Description := DelChr(GenJnlLine.Description, '=', ',');
//             Lin_Body += Format(CopyStr(GenJnlLine.Description, 1, 55), 55);
//             Archivo.Write(Lin_Body);
//         until GenJnlLine.Next = 0;

//         Window.Close;
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := BankAccount."E-Pay Export File Path" + NombreArchivo2;
//         //MESSAGE('%1\ %2',NOMBREARCHIVO,NOMBREARCHIVO2);
//         RenameFile;
//         Message(MSG001);
//     end;

//     local procedure FormatoSCA(CodDiario: Code[20]; SeccDiario: Code[20])
//     var
//         Secuencia: Text[10];
//         CodBco: Code[20];
//         Contador: Integer;
//     begin
//         CompanyInfo.Get();

//         Blanco := ' ';
//         CERO := '0';
//         TotalGeneral := 0;

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindFirst;

//         if CopyStr(BankAccount."E-Pay Export File Path", StrLen(BankAccount."E-Pay Export File Path"), 1) <> '\' then
//             BankAccount."E-Pay Export File Path" += '\';

//         PathENV := TemporaryPath;

//         BankAccount."Last E-Pay Export File Name" := IncStr(BankAccount."Last E-Pay Export File Name");
//         BankAccount.Modify;

//         NombreArchivo := BankAccount."Last E-Pay Export File Name";

//         NombreArchivo2 := NombreArchivo;

//         PathENV := TemporaryPath;

//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;

//         //Leemos el Diario
//         GenJnlLine.Reset;
//         GenJnlLine.SetRange("Journal Template Name", CodDiario);
//         GenJnlLine.SetRange("Journal Batch Name", SeccDiario);
//         GenJnlLine.SetRange("Check Printed", false);
//         GenJnlLine.SetRange("Check Exported", false);
//         GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Payment);
//         GenJnlLine.SetRange("Bank Payment Type", GenJnlLine."Bank Payment Type"::"Electronic Payment");
//         GenJnlLine.SetFilter(Amount, '<>%1', 0);
//         GenJnlLine.FindSet;
//         CounterTotal := GenJnlLine.Count;
//         Window.Open(Text001);

//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, GenJnlLine."Account No.");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             if GenJnlLine."Posting Date" < Today then
//                 Error(Err003);

//             //Creo el detalle
//             Clear(Vendor);
//             Clear(Lin_Body);
//             Contador := Contador + 1;

//             if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
//                 Vendor.Get(GenJnlLine."Account No.");
//                 BankAccount.Get(GenJnlLine."Bal. Account No.");
//                 VendorBank.Reset;
//                 VendorBank.SetRange("Vendor No.", GenJnlLine."Account No.");
//                 VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                 CodBco := GenJnlLine."Bal. Account No.";
//                 VendorBank.FindFirst;
//                 VendorBank.TestField("Bank Account No.");
//                 //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                 //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                 //      BcoACH.TESTFIELD("Ruta y Transito");
//             end
//             else
//                 if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then begin
//                     Vendor.Get(GenJnlLine."Bal. Account No.");
//                     BankAccount.Get(GenJnlLine."Account No.");
//                     VendorBank.Reset;
//                     VendorBank.SetRange("Vendor No.", GenJnlLine."Bal. Account No.");
//                     VendorBank.SetRange(Code, GenJnlLine."Recipient Bank Account");
//                     CodBco := GenJnlLine."Account No.";
//                     VendorBank.FindFirst;
//                     VendorBank.TestField("Bank Account No.");
//                     //fes mig VendorBank.TESTFIELD("Banco RED ACH");
//                     //fes mig BcoACH.GET(VendorBank."Banco RED ACH");
//                     //      BcoACH.TESTFIELD("Ruta y Transito");
//                 end;

//             BankAccount."Bank Account No." := DelChr(BankAccount."Bank Account No.", '=', '-/., ');
//             GenJnlLine.Description := DelChr(GenJnlLine.Description, '=', ',');
//             GenJnlLine.Beneficiario := DelChr(GenJnlLine.Beneficiario, '=', ',');

//             //tipo cuenta ==> 0= ahorro, 1= Corriente, 2 = cheque
//             if (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account") and  // Para cuando es transferencias entre bancos
//                (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") then begin
//                 BankAccount2.Get(GenJnlLine."Account No.");
//                 BankAccount2.TestField("Bank Account No.");
//                 //BankAccount2.TESTFIELD("Bank Code");
//                 BankAccount2."Bank Account No." := DelChr(BankAccount2."Bank Account No.", '=', '-/., ');
//                 Clear(Lin_Body);
//                 Lin_Body := Format(CopyStr(GenJnlLine.Beneficiario, 1, 32), 32);
//                 Lin_Body += ',';
//                 if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then
//                     Lin_Body += Format(DelChr(Vendor."VAT Registration No.", '=', ' .-'))
//                 else
//                     if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor then
//                         Lin_Body += Format(DelChr(Vendor."VAT Registration No.", '=', ' .-'))
//                     else
//                         Lin_Body += Format(Counter, 0, '<Integer>');
//                 Lin_Body += ',';
//                 Lin_Body += VendorBank."SWIFT Code";
//                 Lin_Body += ',';
//                 Lin_Body += BankAccount."Bank Account No.";
//                 Lin_Body += ',';
//                 if GenJnlLine."Currency Code" = '' then
//                     Lin_Body += 'DOP'
//                 else
//                     Lin_Body += GenJnlLine."Currency Code";

//                 Lin_Body += ',';
//                 if BankAccount."Tipo Cuenta" = BankAccount."Tipo Cuenta"::"CC= Cuenta Corriente" then
//                     Lin_Body += 'Chequing'
//                 else
//                     Lin_Body += 'Saving';
//                 Lin_Body += ',';
//                 Lin_Body += Format(GenJnlLine.Amount * 100, 10, '<Integer,10><Filler Character,0>');
//                 Lin_Body += ',';
//                 Lin_Body += CopyStr(GenJnlLine.Description, 1, 80);
//                 Archivo.Write(Lin_Body);
//             end
//             else begin
//                 Clear(Lin_Body);
//                 Lin_Body := Format(CopyStr(GenJnlLine.Beneficiario, 1, 32), 32);
//                 Lin_Body += ',';
//                 Counter += 1;
//                 Lin_Body += Format(Contador, 0, '<Integer>');
//                 Lin_Body += ',';
//                 Lin_Body += VendorBank."SWIFT Code";
//                 Lin_Body += ',';
//                 Lin_Body += BankAccount."Bank Account No.";
//                 Lin_Body += ',';
//                 if GenJnlLine."Currency Code" = '' then
//                     Lin_Body += 'DOP'
//                 else
//                     Lin_Body += GenJnlLine."Currency Code";

//                 Lin_Body += ',';
//                 if BankAccount."Tipo Cuenta" = BankAccount."Tipo Cuenta"::"CC= Cuenta Corriente" then
//                     Lin_Body += 'Chequing'
//                 else
//                     Lin_Body += 'Saving';
//                 Lin_Body += ',';
//                 Lin_Body += Format(GenJnlLine.Amount * 100, 10, '<Integer,10><Filler Character,0>');
//                 Lin_Body += ',';
//                 Lin_Body += CopyStr(GenJnlLine.Description, 1, 80);
//                 Archivo.Write(Lin_Body);
//             end;

//             ExportAmount := GenJnlLine.Amount;

//             GenJnlLine."Check Printed" := true;
//             GenJnlLine."Check Exported" := true;
//             GenJnlLine."Check Transmitted" := true;
//             GenJnlLine."Exported to Payment File" := true;

//             GenJnlLine."Export File Name" := NombreArchivo2;
//             BankAccount.TestField("Last Remittance Advice No.");
//             GenJnlLine."Document No." := IncStr(BankAccount."Last Remittance Advice No.");

//             BankAccount."Last Remittance Advice No." := IncStr(BankAccount."Last Remittance Advice No.");
//             BankAccount."Last E-Pay Export File Name" := NombreArchivo;
//             BankAccount.Modify;

//             InsertIntoCheckLedger(Tracenumber, -ExportAmount, GenJnlLine);
//             GenJnlLine.Modify;

//         until GenJnlLine.Next = 0;
//         Window.Close;
//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := BankAccount."E-Pay Export File Path" + NombreArchivo2;
//         //MESSAGE('%1\ %2',NOMBREARCHIVO,NOMBREARCHIVO2);
//         RenameFile;
//         Message(MSG001);
//     end;
// }

