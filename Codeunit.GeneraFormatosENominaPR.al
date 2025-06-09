// codeunit 76038 "Genera Formatos  E. Nomina PR"
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
//         GHLN: Record "Historico Lin. nomina";
//         Fecha: Record Date;
//         BcoACH: Record "Bancos ACH Nomina";
//         VLE: Record "Vendor Ledger Entry";
//         BankAccount: Record "Bank Account";
//         Archivo: File;
//         FileVar: File;
//         IStream: InStream;
//         StreamOut: OutStream;
//         Lin_Body: Text[320];
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
//         TotalGeneral: Decimal;
//         ContLin: Integer;


//     procedure FormatoBanco()
//     var
//         Err001: Label 'Missing Bank''s information from Company Setup';
//         Empresa: Record "Empresas Cotizacion";
//         HCN: Record "Historico Cab. nomina";
//         HCN2: Record "Historico Cab. nomina";
//         HLN: Record "Historico Lin. nomina";
//         DIPG: Record "Distrib. Ingreso Pagos Elect.";
//         Banco: Record "Bank Account";
//         BcoNom: Record Bancos;
//         NetoBanco: Decimal;
//         RNC: Text;
//         FechaTrans: Date;
//         PathENV: Text[1024];
//         Mes: Integer;
//         Secuencia: Text[30];
//         SecuenciaHdr: Text;
//         SecuenciaTrans: Code[7];
//         Total: Decimal;
//         TotalDb: Decimal;
//         TotalCr: Decimal;
//         Concepto: Text[36];
//         Contador: Integer;
//         PrimeraVez: Boolean;
//         HASH: Decimal;
//         dHASH: Decimal;
//         Bloques: Integer;
//         GrupoReg: Integer;
//     begin
//         ConfNomina.Get();
//         ConfNomina.TestField("Path Archivos Electronicos");
//         ConfNomina.TestField("Secuencia de archivo Batch");
//         ConfNomina."Secuencia de archivo Batch" := IncStr(ConfNomina."Secuencia de archivo Batch");
//         ConfNomina.Modify;

//         ConfContab.Get();
//         Empresa.FindFirst;
//         //Empresa.TESTFIELD("Identificador Empresa");
//         Empresa.TestField("ID RNL");
//         /*
//         Empresa.TESTFIELD("RNC/CED");
//         RNC := DELCHR(Empresa."RNC/CED",'=','-');
//         */
//         if Empresa.Banco = '' then
//             Error(Err001);

//         BcoNom.Get(Empresa.Banco);
//         BcoNom.TestField(Formato);
//         Banco.Get(BcoNom.Codigo);
//         Blanco := ' ';
//         CERO := '0';
//         PrimeraVez := true;

//         EC.Get(GHCN."Empresa cotización");
//         //EC.TESTFIELD("Identificador Empresa");

//         ConfNomina.TestField("Path Archivos Electronicos");

//         if CopyStr(ConfNomina."Path Archivos Electronicos", StrLen(ConfNomina."Path Archivos Electronicos"), 1) <> '\' then
//             ConfNomina."Path Archivos Electronicos" += '\';

//         FechaTrans := GHCN."Fecha Pago";
//         PathENV := TemporaryPath;

//         NombreArchivo := 'PE' + '01' + Format(FechaTrans, 0, '<Year,4>') + Format(FechaTrans, 0, '<Month,2>') + Format(FechaTrans, 0, '<Day,2>');

//         Mes := Date2DMY(FechaTrans, 2);
//         Mes := Mes * 2;
//         Secuencia := '1';

//         NombreArchivo += Secuencia + 'E.txt';
//         NombreArchivo2 := NombreArchivo;
//         SecuenciaTrans := '0000000';

//         Archivo.TextMode(true);
//         Archivo.Create(PathENV + NombreArchivo);
//         Archivo.Trunc;


//         HCN.Reset;
//         //HCN.COPYFILTERS(GHCN);
//         HCN.SetFilter(Período, GHCN.GetFilter(Período));
//         HCN.SetFilter("Tipo Nomina", GHCN.GetFilter("Tipo Nomina"));
//         HCN.SetRange("Forma de Cobro", 3);// Transferencias de banco
//         CounterTotal := HCN.Count;
//         Window.Open(Text001);

//         //IF HCN.FINDSET THEN
//         HCN.FindSet;
//         repeat
//             Counter += 1;
//             Window.Update(1, HCN."No. empleado");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             Empl.Get(HCN."No. empleado");

//             DIPG.Reset;
//             DIPG.SetRange("No. empleado", HCN."No. empleado");
//             DIPG.FindFirst;
//             if (BcoNom.Formato = 'Santander') or (BcoNom.Formato = 'SANTANDER') then begin
//                 if PrimeraVez then begin
//                     PrimeraVez := false;
//                     //Creo la cabecera
//                     HCN2.Reset;
//                     HCN2.CopyFilters(HCN);
//                     CounterTotal := HCN.Count;
//                     HCN2.FindSet;
//                     repeat
//                         HCN2.CalcFields("Total Ingresos", "Total deducciones");
//                         //              TotalGeneral += ROUND(HCN2."Total Ingresos" + HCN2."Total deducciones",0.01);
//                         GHLN.Reset;
//                         GHLN.SetFilter(Período, HCN2.GetFilter(Período));
//                         GHLN.SetFilter("Tipo Nómina", HCN2.GetFilter("Tipo Nomina"));
//                         GHLN.SetRange("No. empleado", HCN2."No. empleado");
//                         if GHLN.FindSet then
//                             repeat
//                                 TotalGeneral += Round(GHLN.Total, 0.01);
//                             until GHLN.Next = 0;
//                     until HCN2.Next = 0;

//                     //ENCABEZADO DEL ARCHIVO;
//                     TotalCr := TotalGeneral;

//                     Lin_Body := '101'; //Tipo Record + Codigo Prioridad
//                     Lin_Body += Format(Blanco, 10 - StrLen(Banco."SWIFT Code"), '<Filler character, >') + Banco."SWIFT Code"; //Identificador del Destinatario
//                     Lin_Body += Format(Blanco, 10 - StrLen(Banco."SWIFT Code"), '<Filler character, >') + Banco."SWIFT Code"; //Identificador del Originador
//                     Lin_Body += Format(Today, 0, '<Year,2><Month,2><Day,2>'); //Fecha de creacion del archivo YYMMDD
//                     Lin_Body += Format(Time, 4, '<Hours24,2><Minutes,2>'); //HHMM
//                     Lin_Body += Secuencia + '094'; //Longitud del record
//                     Lin_Body += '10'; //Factor de bloque
//                     Lin_Body += '1'; //Código de formato

//                     if StrLen(Banco.Name) <= 23 then
//                         Lin_Body += Banco.Name + Format(Blanco, 23 - StrLen(Banco.Name), '<Filler character, >') //Nombre destinatario
//                     else
//                         Lin_Body += CopyStr(Banco.Name, 1, 23); //Nombre destinatario

//                     if StrLen(EC."Nombre Empresa cotizacinn") <= 23 then
//                         Lin_Body += EC."Nombre Empresa cotizacinn" + Format(Blanco, 23 - StrLen(EC."Nombre Empresa cotizacinn"), '<Filler character, >') //Nombre empresa
//                     else
//                         Lin_Body += CopyStr(EC."Nombre Empresa cotizacinn", 1, 23); //Nombre empresa


//                     CERO := PadStr(CERO, 8 - StrLen(ConfNomina."Secuencia de archivo Batch"), '0');
//                     Lin_Body += CERO + ConfNomina."Secuencia de archivo Batch";

//                     //Activar si lo piden, es opcional             Lin_Body += FORMAT(TODAY,0,'<Year,2><Month,2><Day,2>') + Secuencia; //Fecha + Secuencia

//                     Archivo.Write(Lin_Body);
//                     Bloques += 1;
//                     ContLin += 1;
//                     GrupoReg += 1;
//                     //ENCABEZADO DEL BATCH;
//                     Lin_Body := '5220'; //Tipo Record + Codigo clase de servicio
//                     if StrLen(EC."Nombre Empresa cotizacinn") < 16 then
//                         Lin_Body += UpperCase(EC."Nombre Empresa cotizacinn") + Format(Blanco, 16 - StrLen(EC."Nombre Empresa cotizacinn"), '<Filler character, >')  //Nombre empresa
//                     else
//                         Lin_Body += CopyStr(UpperCase(EC."Nombre Empresa cotizacinn"), 1, 16);  //Nombre empresa
//                     Lin_Body += Format(Blanco, 20); // 20 espacios en blanco

//                     if StrLen(EC."ID RNL") < 10 then
//                         Lin_Body += Format(Blanco, 10 - StrLen(EC."ID RNL"), '<Filler character, >') + EC."ID RNL" //Identificador de empresa
//                     else
//                         Lin_Body += CopyStr(EC."ID RNL", 1, 10); //Identificador de empresa

//                     Lin_Body += 'PPD'; //Clase de transaccion
//                     Lin_Body += 'PAYROLL   '; //Descripcion de la transaccion
//                     Lin_Body += Format(Today, 0, '<Year,2><Month,2><Day,2>'); //Fecha de generacion del archivo
//                     Lin_Body += Format(GHCN."Fecha Pago", 0, '<Year,2><Month,2><Day,2>'); //Fecha de pago
//                     Lin_Body += Format(Blanco, 3); // Fecha de pago en dias (Ej: 31/12/xx ==> 365). Lo dejo en blanco
//                     Lin_Body += '1'; // Código de estatus de Originador
//                     Lin_Body += CopyStr(Banco."SWIFT Code", 1, 8);
//                     CERO := PadStr(CERO, 7 - StrLen(Secuencia), '0');
//                     Lin_Body += CERO + Secuencia;
//                     Archivo.Write(Lin_Body);
//                     Bloques += 1;
//                     ContLin += 1;
//                     GrupoReg += 1;
//                 end;
//                 //Creo el detalle
//                 SecuenciaTrans := IncStr(SecuenciaTrans);

//                 Clear(Lin_Body);
//                 Lin_Body := '6'; //Código de tipo de récord
//                 if DIPG."Tipo Cuenta" = 2 then //Check
//                     Lin_Body += '22'
//                 else
//                     Lin_Body += '32';

//                 BcoACH.Get(DIPG."Cod. Banco");
//                 BcoACH.TestField("ACH Reservas");
//                 //         Lin_Body += copystr(BcoACH."ACH Reservas",1,8) + FORMAT(BcoACH."Digito Chequeo"); //ID del banco + digito verificador
//                 Lin_Body += BcoACH."ACH Reservas"; //ID del banco + digito verificador

//                 Lin_Body += DIPG."Numero Cuenta" + Format(Blanco, 17 - StrLen(DIPG."Numero Cuenta"), '<Filler character, >'); //Cuenta
//                 BcoACH."ACH Reservas" := CopyStr(BcoACH."ACH Reservas", 1, 8);
//                 Evaluate(dHASH, BcoACH."ACH Reservas");
//                 HASH += dHASH;

//                 Total := 0;
//                 GHLN.Reset;
//                 GHLN.SetFilter(Período, HCN2.GetFilter(Período));
//                 GHLN.SetFilter("Tipo Nómina", HCN.GetFilter("Tipo Nomina"));
//                 GHLN.SetRange("No. empleado", HCN."No. empleado");
//                 if GHLN.FindSet then
//                     repeat
//                         Total += Round(GHLN.Total, 0.01);
//                     /*IF DIPG."Tipo Cuenta" = 0 THEN      //Debitos
//                        TotalDb += ROUND(GHLN.Total,0.01)
//                     ELSE
//                        TotalCr += ROUND(GHLN.Total,0.01);
//                     */
//                     until GHLN.Next = 0;

//                 Contador += 1;
//                 Lin_Body += Format(Total * 100, 10, '<integer,10><Filler Character,0>'); //Importe a pagar
//                 Lin_Body += Format(Blanco, 15, '<Text,15>'); //Número de identificación, se deja en blanco por seguridad
//                 Lin_Body += Format(CopyStr(Empl."Full Name", 1, 22), 22); //Nombre del empleado
//                 Lin_Body += Format(Blanco, 2, '<Text,2>'); //Campo opcional, se deja en blanco
//                 Lin_Body += '0'; //Indicador de récord de apéndice (Adenda)
//                 Lin_Body += '02150234'; //Número de rastreo + la secuencia que esta en la siguiente linea
//                 CERO := PadStr(CERO, 7 - StrLen(Format(Contador, 0, '<Integer>')), '0');
//                 Lin_Body += CERO + Secuencia; //Secuencia
//                 Archivo.Write(Lin_Body);
//                 Secuencia := IncStr(Secuencia);
//                 Bloques += 1;
//                 ContLin += 1;
//                 //         TotalDb += Total;
//             end
//         until HCN.Next = 0;

//         //MESSAGE('%1 %2 ',TotalDb);
//         //Creamos el Batch de control
//         Clear(Lin_Body);
//         Lin_Body := '8220'; //8 = Codigo tipo de record + 220 = Codigo clase de servicio
//         CERO := PadStr(CERO, 6 - StrLen(Format(Contador, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(Contador, 0, '<Integer>'); //8 = Codigo tipo de record + 220 = Codigo clase de servicio
//         CERO := PadStr(CERO, 10 - StrLen(Format(HASH, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(HASH, 0, '<Integer>'); //Suma de los campos del 4 al 11 de todos los récords seis (6)
//         CERO := PadStr(CERO, 12 - StrLen(Format(TotalDb * 100, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(TotalDb * 100, 0, '<Integer>'); //Total de los débitos en dólares y centavos
//         CERO := PadStr(CERO, 12 - StrLen(Format(TotalCr * 100, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(TotalCr * 100, 0, '<Integer>'); //Total de los créditos en dólares y centavos
//         if StrLen(EC."ID RNL") < 10 then
//             Lin_Body += Format(Blanco, 10 - StrLen(EC."ID RNL"), '<Filler character, >') + EC."ID RNL" //Identificador de empresa
//         else
//             Lin_Body += CopyStr(EC."ID RNL", 1, 10); //Identificador de empresa
//         Lin_Body += Format(Blanco, 25, '<Filler Character, >'); //Reservados 19 + 6
//         Lin_Body += '02150234'; //Valor fijo, Igual que la posición 80 a la 87 en el Encabezado del  Batch.

//         CERO := PadStr(CERO, 7 - StrLen(ConfNomina."Secuencia de archivo Batch"), '0');
//         Lin_Body += CERO + ConfNomina."Secuencia de archivo Batch";

//         Archivo.Write(Lin_Body);
//         Bloques += 1;
//         ContLin += 1;

//         Bloques += 1; //Para la ultima que es 9
//         ContLin += 1; //Para la ultima que es 9

//         Contador := (Bloques div 10) + 1;
//         Bloques := 10 * Contador;

//         //Récord de Control de Archivo (File Control Record)
//         Clear(Lin_Body);
//         Lin_Body := '9'; //Código de tipo de récord
//         Lin_Body += '000001'; //Conteo de Batch. Igual al numero de Récords de Encabezados de Batch

//         CERO := PadStr(CERO, 6 - StrLen(Format(Bloques, 0, '<Integer>')), '0'); //Conteo de Bloques. Número de Bloques en el Archivo incluyendo los récords 1 y 5
//         Lin_Body += CERO + Format(Bloques, 0, '<Integer>'); //8 = Codigo tipo de record + 220 = Codigo clase de servicio

//         Lin_Body += '00000001'; //Conteo de Entradas y Apéndices. Conteo de los récords 6 y 7

//         CERO := PadStr(CERO, 10 - StrLen(Format(HASH, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(HASH, 0, '<Integer>'); //Entry Hash. Suma de los números de ruta y tránsito de los detalles de entrada Igual que los campos 11
//                                                          //al 20 del Récord de Control de Batch. Récord 8

//         CERO := PadStr(CERO, 12 - StrLen(Format(TotalDb * 100, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(TotalDb * 100, 0, '<Integer>'); //Total de los débitos en dólares y centavos

//         CERO := PadStr(CERO, 12 - StrLen(Format(TotalCr * 100, 0, '<Integer>')), '0');
//         Lin_Body += CERO + Format(TotalCr * 100, 0, '<Integer>'); //Total de los créditos en dólares y centavos

//         Lin_Body += Format(Blanco, 39);

//         Archivo.Write(Lin_Body);


//         if ContLin > 10 then begin
//             ContLin := Bloques - ContLin;
//             ContLin := 10 - ContLin;
//         end;

//         //Para rellenar con lineas 9999xxxx la cantidad de registros que faltan del ultimo bloque y multiplo de 10
//         while ContLin < 10 do begin
//             CERO := '9';
//             Lin_Body := PadStr(CERO, 94, '9');
//             Archivo.Write(Lin_Body);
//             ContLin += 1;
//         end;

//         Archivo.Close;

//         NombreArchivo := TemporaryPath + NombreArchivo;
//         NombreArchivo2 := ConfNomina."Path Archivos Electronicos" + NombreArchivo2;
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
//         /*
//         FirstTime := TRUE;
//         Blanco := ' ';
//         CERO   := '0';
//         TAB    := 9;

//         EC.FINDFIRST;

//         //Verifico que todas las lineas del diario tengan el mismo banco
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
//           SettleDate := GenJnlLine."Posting Date";
//           IF FirstTime THEN
//              BEGIN
//               IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                  BEGIN
//                   BankAccount.GET(GenJnlLine."Bal. Account No.");
//                  END
//               ELSE
//               IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
//                  BEGIN
//                   BankAccount.GET(GenJnlLine."Account No.");
//                  END;

//               BankAccount.TESTFIELD("E-Pay Export File Path");
//               BankAccount.TESTFIELD("Last Remittance Advice No.");
//               BankAccount."Last Remittance Advice No." := INCSTR(BankAccount."Last Remittance Advice No.");
//               BankAccount.MODIFY;

//               FirstTime := FALSE;

//               IF COPYSTR(BankAccount."E-Pay Export File Path",STRLEN(BankAccount."E-Pay Export File Path"),1) <> '\' THEN
//                  BankAccount."E-Pay Export File Path" += '\';

//               CASE DATE2DMY(WORKDATE,2) OF
//                  1 :
//                   TextMes := 'ENE';
//                  2 :
//                   TextMes := 'FEB';
//                  3 :
//                   TextMes := 'MAR';
//                  4 :
//                   TextMes := 'ABR';
//                  5 :
//                   TextMes := 'MAY';
//                  6 :
//                   TextMes := 'JUN';
//                  7 :
//                   TextMes := 'JUL';
//                  8 :
//                   TextMes := 'AGO';
//                  9 :
//                   TextMes := 'SEP';
//                 10 :
//                   TextMes := 'OCT';
//                 11 :
//                   TextMes := 'NOV';
//               ELSE
//                   TextMes := 'DIC';
//               END;
//               Archivo.TEXTMODE(TRUE);
//               NombreArchivo := 'c:\temp\' + 'PAGOS_MULTICASH_' +
//                              FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') + FORMAT(WORKDATE,0,'<Day,2>') + '_01.txt';

//               NombreArchivo2 := BankAccount."E-Pay Export File Path" + 'PAGOS_MULTICASH_' +
//                              FORMAT(WORKDATE,0,'<Year4>') + FORMAT(WORKDATE,0,'<Month,2>') + FORMAT(WORKDATE,0,'<Day,2>') + '_01.txt';
//               Archivo.CREATE(NombreArchivo);
//               Archivo.TRUNC;
//          //     Archivo.CREATEOUTSTREAM(StreamOut);
//              END;

//             IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
//                BEGIN
//                 Vendor.GET(GenJnlLine."Account No.");
//                 BankAccount.GET(GenJnlLine."Bal. Account No.");
//                 VendorBank.RESET;
//                 VendorBank.SETRANGE("Vendor No.",GenJnlLine."Account No.");
//                 CodBco := GenJnlLine."Bal. Account No.";
//                END
//             ELSE
//             IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
//                BEGIN
//                 Vendor.GET(GenJnlLine."Bal. Account No.");
//                 BankAccount.GET(GenJnlLine."Account No.");
//                 VendorBank.RESET;
//                 VendorBank.SETRANGE("Vendor No.",GenJnlLine."Bal. Account No.");
//                 CodBco := GenJnlLine."Account No.";
//                END;

//           VendorBank.FINDFIRST;
//           VendorBank.TESTFIELD("Bank Account No.");
//           VendorBank.TESTFIELD("Banco Receptor");

//           BcoACH.GET(VendorBank."Banco Receptor");
//           BcoACH.TESTFIELD("Cod. Institucion Financiera");
//           Lin_Detail := 'PA' + FORMAT(TAB);
//           BankAccount."Bank Account No." := DELCHR(BankAccount."Bank Account No.",'=','-/., ');
//           CERO     := PADSTR(CERO,10-STRLEN(BankAccount."Bank Account No."),'0');
//           Lin_Detail += CERO + FORMAT(BankAccount."Bank Account No.") + FORMAT(TAB);
//           Lin_Detail += FORMAT(Counter) + FORMAT(TAB);
//           Lin_Detail += GenJnlLine."External Document No." + FORMAT(TAB);
//           Lin_Detail += VendorBank."Bank Account No." + FORMAT(TAB);
//           Lin_Detail += 'USD' + FORMAT(TAB);
//           Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>') + FORMAT(TAB);
//           Lin_Detail += 'CTA' + FORMAT(TAB);
//           CERO     := PADSTR(CERO,4-STRLEN(BcoACH."Cod. Institucion Financiera"),'0');
//           Lin_Detail += CERO+BcoACH."Cod. Institucion Financiera" + FORMAT(TAB);

//           CASE VendorBank."Tipo Cuenta" OF
//             0:
//              Lin_Detail += 'CTE' + FORMAT(TAB);
//             1:
//              Lin_Detail += 'AHO' + FORMAT(TAB);
//           END;

//           IF VendorBank.Code = CodBco THEN
//              BEGIN
//               VendorBank."Bank Account No." := DELCHR(VendorBank."Bank Account No.",'=','-/., ');
//               CERO     := PADSTR(CERO,10-STRLEN(VendorBank."Bank Account No."),'0');
//               VendorBank."Bank Account No." := CERO;
//              END
//           ELSE
//              BEGIN
//               VendorBank."Bank Account No." := DELCHR(VendorBank."Bank Account No.",'=','-/., ');
//              END;

//           CLEAR(CERO);
//           IF STRLEN(VendorBank."Bank Account No.") < 10 THEN
//              CERO     := PADSTR(CERO,10-STRLEN(VendorBank."Bank Account No."),'0');

//           Lin_Detail += CERO + VendorBank."Bank Account No." + FORMAT(TAB);

//           Vendor."VAT Registration No."  := DELCHR(Vendor."VAT Registration No.",'=','-/., ');
//           IF STRLEN(Vendor."VAT Registration No.") = 10 THEN
//              Lin_Detail += 'C' + FORMAT(TAB)
//           ELSE
//              Lin_Detail += 'R' + FORMAT(TAB);


//           Lin_Detail += Vendor."VAT Registration No." + FORMAT(TAB);
//           Lin_Detail += COPYSTR(GenJnlLine.Beneficiario,1,40) + FORMAT(TAB);
//           Lin_Detail += COPYSTR(Vendor.Address,1,50) + FORMAT(TAB);
//           Lin_Detail += Vendor.City + FORMAT(TAB); //Ciudad Beneficiario
//           Lin_Detail += Vendor."Phone No." + FORMAT(TAB);
//           Lin_Detail += FORMAT(TAB); //Localidad Beneficiario
//           Lin_Detail += GenJnlLine.Description + FORMAT(TAB);
//           Lin_Detail += 'Pagos|';

//           Lin_Detail += FORMAT(Vendor."E-Mail");
//           Archivo.WRITE(Lin_Detail);

//           CASE BankAccount."Export Format" OF
//             BankAccount."Export Format"::US:
//              BEGIN
//               TraceNumber := ExportPaymentsACH.ExportElectronicPayment(GenJnlLine,ExportAmount);
//              END;
//             BankAccount."Export Format"::CA:
//              BEGIN
//               TraceNumber := ExportPaymentsRB.ExportElectronicPayment(GenJnlLine,ExportAmount,SettleDate);
//              END;
//             BankAccount."Export Format"::MX:
//              BEGIN
//               TraceNumber := ExportPaymentsCecoban.ExportElectronicPayment(GenJnlLine,ExportAmount,SettleDate);
//              END;
//           END;

//         //aqui vle
//           IF GenJnlLine."Applies-to Doc. No." <> '' THEN
//              BEGIN
//              END
//           ELSE
//              BEGIN
//              //Detalle de las facturas que se pagan
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

//               FirstTime2 := TRUE;
//               VLE.SETRANGE(Open,TRUE);
//               VLE.SETRANGE(Positive,FALSE);
//               VLE.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
//               IF VLE.FINDSET THEN
//                  REPEAT
//                   IF FirstTime2 THEN
//                      BEGIN
//                       FirstTime2 := FALSE;
//                       // Linea del pago
//                        CLEAR(Lin_Detail);
//                        Lin_Detail := 'DE' + FORMAT(TAB);
//                        Seq += 1;
//                        Lin_Detail += FORMAT(Counter) + FORMAT(TAB);
//                        Lin_Detail += 'EGRESO' + FORMAT(TAB);
//                        Lin_Detail += GenJnlLine."Document No." + ' TRANSFERENCIA BANCARIA' + FORMAT(TAB);
//                        Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>') + FORMAT(TAB);
//                        Lin_Detail += '00000' + FORMAT(TAB);
//                        Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>');
//                        Archivo.WRITE(Lin_Detail);
//                       //Fin
//                      END;

//                   CLEAR(Lin_Detail);
//                   Lin_Detail := 'DE' + FORMAT(TAB);
//                   Seq += 1;
//                   Lin_Detail += FORMAT(Counter) + FORMAT(TAB);
//                   Lin_Detail += 'INGRESO' + FORMAT(TAB);
//                   Lin_Detail += COPYSTR('Factura No. ' + VLE."External Document No." + ' ' + Vendor.Name,1,50) + FORMAT(TAB);
//                   VLE.CALCFIELDS("Remaining Amount");
//                   Lin_Detail += FORMAT(ROUND((VLE."Remaining Amount"),0.01)*100,13,'<integer,13><Filler Character,0>') + FORMAT(TAB);
//                   Lin_Detail += '00000' + FORMAT(TAB);
//                   Lin_Detail += FORMAT(ROUND((VLE."Remaining Amount"),0.01)*100,13,'<integer,13><Filler Character,0>');
//                   Archivo.WRITE(Lin_Detail);
//                  UNTIL VLE.NEXT =0
//               ELSE
//                 BEGIN
//                   IF FirstTime2 THEN
//                      BEGIN
//                       FirstTime2 := FALSE;
//                       // Linea del pago
//                        CLEAR(Lin_Detail);
//                        Lin_Detail := 'DE' + FORMAT(TAB);
//                        Seq += 1;
//                        Lin_Detail += FORMAT(Counter) + FORMAT(TAB);
//                        Lin_Detail += 'EGRESO' + FORMAT(TAB);
//                        Lin_Detail += GenJnlLine."Document No." + ' TRANSFERENCIA BANCARIA' + FORMAT(TAB);
//                        Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>') + FORMAT(TAB);
//                        Lin_Detail += '00000' + FORMAT(TAB);
//                        Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>');
//                        Archivo.WRITE(Lin_Detail);

//                        CLEAR(Lin_Detail);
//                        Lin_Detail := 'DE' + FORMAT(TAB);
//                        Seq += 1;
//                        Lin_Detail += FORMAT(Counter) + FORMAT(TAB);
//                        Lin_Detail += 'INGRESO' + FORMAT(TAB);
//                        Lin_Detail += GenJnlLine.Beneficiario + FORMAT(TAB);
//                        Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>') + FORMAT(TAB);
//                        Lin_Detail += '00000' + FORMAT(TAB);
//                        Lin_Detail += FORMAT(ROUND((GenJnlLine.Amount),0.01)*100,13,'<integer,13><Filler Character,0>');
//                        Archivo.WRITE(Lin_Detail);
//                       //Fin
//                      END;
//                 END;
//              END;

//           IF TraceNumber <> '' THEN
//              BEGIN
//         //      GenJnlLine."Posting Date" := SettleDate;
//               GenJnlLine."Check Printed" := TRUE;
//               GenJnlLine."Check Exported" := TRUE;
//               GenJnlLine."Check Transmitted" := TRUE;

//               GenJnlLine."Export File Name" := BankAccount."Last E-Pay Export File Name";
//               BankAccount."Last Remittance Advice No." := INCSTR(BankAccount."Last Remittance Advice No.");
//               GenJnlLine."Document No." := INCSTR(BankAccount."Last Remittance Advice No.");

//               GenJnlLine.MODIFY;
//               InsertIntoCheckLedger(TraceNumber,-ExportAmount,GenJnlLine);
//              END;

//         UNTIL GenJnlLine.NEXT = 0;

//         Window.CLOSE;
//         Archivo.CLOSE;

//         RenameFile;
//         */

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


//         /*Habilitar esto mas luego
//         //Verifico que todas las lineas del diario tengan el mismo banco
//         ConfEmpresa.GET();
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
//     var
//         FileManagement: Codeunit "File Management";
//     begin
//         FileManagement.DownloadToFile(NombreArchivo, NombreArchivo2);
//     end;
// }

