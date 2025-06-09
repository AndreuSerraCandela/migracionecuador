codeunit 53000 "Imp. Fisc. Panama"
{

    trigger OnRun()
    begin
    end;

    var
        Text014: Label '                                                                  ', Locked = true;
        ConfSant: Record "Config. Empresa";
        UserSetUp: Record "User Setup";
        ano: Text[30];
        mes: Text[30];
        dia: Text[30];
        hora: Text[30];
        "min": Text[30];
        segundo: Text[30];
        Comando: Text[1024];
        anoh: Text[30];
        mesh: Text[30];
        diah: Text[30];
        Tercera: Text[30];
        I: Integer;


    procedure AbrePuerto(): Decimal
    var
        Retorno: Integer;
    begin
        // Funcion Abre Puerto ------------------------------------------------------------------------------------------------------
        ConfSant.Get;
        UserSetUp.Get(UserId);
        UserSetUp.TestField("Puerto Imp. Fiscal");
        UserSetUp.TestField("Velocidad Imp. Fiscal");

        //fes mig Retorno := OCXImpFiscal.IF_OPEN(UserSetUp."Puerto Imp. Fiscal",UserSetUp."Velocidad Imp. Fiscal");

        //x:= '27-0163848-435';
        //fes mig OCXImpFiscal.SerialNumber('27-0163848-435');

        exit(Retorno);
    end;


    procedure ImpEncabezado(NoLinea: Integer; Texto: Text[1024])
    begin
        Comando := '@SetHeader|' + Format(NoLinea) + '|' + Texto;
        EscribeComando(Comando, 'ImpEncabezado');
    end;


    procedure AbreTicket(RazonSocial: Text[1024]; RUC: Text[30]; NoComprobante: Text[40]; NoImpresora: Text[40]; TipoDoc: Text[1]; Res1: Text[1]; Res2: Text[1]; Fecha: Date; Hora_Loc: Time): Decimal
    var
        Retorno: Decimal;
        FechaComprobante: Text[30];
        HoraComprobante: Text[30];
    begin
        // @OpenFiscalReceipt = Abrir comprobante fiscal.
        // Recibe : RazonSocial, RUC, NoComprobante, NoImpresora, FechaComprobante, HoraComprobante, Res1, Res2, TipoDoc.

        //Fecha
        ano := Format(Date2DMY(Fecha, 3));
        if StrLen(ano) = 4 then
            ano := CopyStr(ano, 3, 2);

        mes := Format(Date2DMY(Fecha, 2));
        dia := Format(Date2DMY(Fecha, 1));

        //Hora
        hora := CopyStr(Format(Hora_Loc), 1, 2);
        min := CopyStr(Format(Hora_Loc), 4, 2);
        segundo := CopyStr(Format(Hora_Loc), 7, 2);


        Comando := '@OpenFiscalReceipt|' + RazonSocial + '|' + RUC + '|' + NoComprobante + '|' + NoImpresora +
                   '|' + ano + mes + dia + '|' + hora + min + segundo + '|' + TipoDoc + '|' + Res1 + '|' + Res2;

        EscribeComando(Comando, 'AbrirTicket');
    end;


    procedure ExtraDataCliente(Linea: Integer; Texto: Text[200])
    begin
        Comando := '@SetCustExtraData|' + Format(Linea) + '|' + Texto;
        EscribeComando(Comando, 'ExtraDataCliente');
    end;


    procedure EscribeComando(Comando_Loc: Text[1024]; Funcion: Text[30]): Decimal
    var
        Retorno: Decimal;
        StatusPrinter: Text[10];
        StatusFiscal: Text[10];
        CantOpr: Text[10];
        Respuesta: Text[256];
    begin

        //fes mig Retorno := OCXImpFiscal.IF_WRITE(Comando_Loc);
        case Funcion of
            'AbrirTicket':
                begin

                end;

            'ImprimeLinea':
                begin
                    //fes mig
                    /*
                    OCXImpFiscal.IF_WRITE('@StatusExtra');
                    StatusPrinter := OCXImpFiscal.IF_READ(1);
                    StatusFiscal := OCXImpFiscal.IF_READ(2);
                   // CantOpr := OCXImpFiscal.IF_READ(3);
                   */
                    //fes mig
                    Respuesta := 'StatusPrinter:' + StatusPrinter + '|StatusFiscal : ' + StatusFiscal + '|CantOpr :' + CantOpr;
                end;

            'CerrarTicket':
                begin

                end;

            'ExtraDataCliente':
                begin
                end;

        end;
        exit(Retorno);

    end;


    procedure ImprimeLinea(Descripcion: Text[200]; Cantidad: Decimal; PrecioUni: Decimal; ITBMS: Decimal; TipoOpr: Text[1]; CodItem: Text[20]): Decimal
    var
        Retorno: Decimal;
    begin
        // @PrintLineItem = Imprimir ítem.
        // Recibe : .

        /*
        Comando := '@PrintLineItem|' + Descripcion + '|' +
                   FORMAT(Cantidad,10,'<Precision,2:2><Standard Format,3>') + '|' + FORMAT(PrecioUni,10,2) +
                   '|' + FORMAT(ITBMS,2,2) + '|' + TipoOpr + '|' + CodItem;
        
        */

        Comando := '@PrintLineItem|' + Descripcion + '|' +
                   Format(Cantidad, 10, 2) + '|' + Format(PrecioUni, 10, 2) +
                   '|' + Format(ITBMS, 2, 2) + '|' + TipoOpr + '|' + CodItem;


        EscribeComando(Comando, 'ImprimeLinea');

    end;


    procedure PrintFiscalText()
    begin
        Comando := ('@PrintFiscalText|' + 'DDDDDDDDDDDDDDD' + '|' + '');
        EscribeComando(Comando, 'PrintFiscalText');
    end;


    procedure ImpSubTot(): Decimal
    var
        Comando: Text[1024];
    begin
        // @PrintLineItem = SubTotal de la Factura.
        // Recibe : ().
        Comando := ('@Subtotal');
        EscribeComando(Comando, 'ImpSubTot');
    end;


    procedure CerrarTicket(TipoCierre: Text[1]): Decimal
    begin
        // @CloseFiscalReceipt = Cerrar comprobante fiscal.
        // Recibe : Tipo de cierre {A / E / N}.

        Comando := '@CloseFiscalReceipt|' + TipoCierre;

        EscribeComando(Comando, 'CerrarTicket');
    end;


    procedure ObtenerNCF(): Code[25]
    begin
        //EXIT(OCXImpFiscal.IF_READ(2));

        //fes mig EXIT(OCXImpFiscal.IF_READ(8));
    end;


    procedure CerrarPrinter(): Decimal
    var
        Retorno: Integer;
    begin

        //fes mig Retorno := OCXImpFiscal.IF_CLOSE();

        exit(Retorno);
    end;


    procedure CierreCajero(ImpInfCajero: Boolean; var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer)
    begin
    end;


    procedure CierreZ(Impresion: Code[1])
    begin
        Comando := '@DailyClose|Z|' + Impresion;
        EscribeComando(Comando, 'CierreZ');
    end;


    procedure CierreX(Impresion: Code[1])
    begin
        Comando := '@DailyClose|X|' + Impresion;
        EscribeComando(Comando, 'CierreX');
    end;


    procedure RepAuditPorFecha(FechaDesde: Date; FechaHasta: Date; GlobalDet: Code[1])
    begin
        ano := Format(Date2DMY(FechaDesde, 3));
        if StrLen(ano) = 4 then
            ano := CopyStr(ano, 3, 2);

        mes := Format(Date2DMY(FechaDesde, 2));
        dia := Format(Date2DMY(FechaDesde, 1));

        anoh := Format(Date2DMY(FechaHasta, 3));
        if StrLen(ano) = 4 then
            ano := CopyStr(ano, 3, 2);

        mesh := Format(Date2DMY(FechaHasta, 2));
        diah := Format(Date2DMY(FechaHasta, 1));

        Comando := '@DailyCloseByDate|120801|120802|G';
        //Comando := '@DailyCloseByDate|'+ano+mes+dia+'|'+anoh+mesh+diah+'|'+GlobalDet;
        EscribeComando(Comando, 'RepAuditPorFecha');
    end;


    procedure SetTrailer(NoLinea: Text[1]; Texto: Text[250])
    begin
        Comando := '@SetTrailer|' + NoLinea + '|' + Texto;
        EscribeComando(Comando, 'SetTrailer');
    end;


    procedure CortaPapel(var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer)
    begin
    end;


    procedure DatosFiscales(var NomEmpresa: Text[54]; var RNCEmpresa: Text[11]; var ResDGII: Text[40]; var LinDNFLibre: Text[3]; var LinDFlibre: Text[3]; var TasaITBIS: Text[5]; var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer)
    begin
    end;


    procedure DNVAbrir(TipoDoc: Text[1]): Decimal
    var
        Retorno: Decimal;
    begin
        // @OpenNonFiscalReceipt = Abrir comprobante no fiscal.
        // Recibe : Tipo de documento {C / D}

        Comando := '@OpenNonFiscalReceipt|' + TipoDoc;

        EscribeComando(Comando, 'DNVAbrir');
    end;


    procedure DNVCerrar(TipoCierre: Text[1]): Decimal
    var
        Retorno: Decimal;
    begin
        Comando := '@CloseNonFiscalReceipt|' + TipoCierre;

        EscribeComando(Comando, 'DNVCerrar');
    end;


    procedure DNVInfo(var NumDNVR: Integer; var CantLinDNVR: Integer; var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer)
    begin
    end;


    procedure DNVLinea(Linea: Text[120]): Decimal
    begin
        Comando := '@PrintNonFiscalText|' + Linea;

        EscribeComando(Comando, 'DNVLinea');
    end;


    procedure Encabezado(NumLinea: Integer; LinEncabezado: Text[56])
    var
        Estado: Integer;
        ReturnCode: Integer;
        EstadoPrinter: Integer;
        EstadoFiscal: Integer;
    begin
    end;


    procedure MedioPago(Descripcion: Text[50]; Monto: Decimal; TipoOpr: Text[1]; MedioPago: Integer): Decimal
    var
        Retorno: Decimal;
    begin
        // @TotalTender = Pago/Cancelación/Descuento en DF.
        // Recibe : TextoFiscal, Res1.


        Comando := '@TotalTender|' + Descripcion + '|' + Format(Monto, 9, 4) + '|' + TipoOpr + '|' + Format(MedioPago);

        EscribeComando(Comando, 'MedioPago');
    end;


    procedure ImprimeTextoFiscal(TextoFiscal: Text[42]; Res1: Text[1]): Decimal
    begin
        // @PrintFiscalText = Imprimir texto fiscal.
        // Recibe : TextoFiscal, Res1.

        Comando := '@PrintFiscalText|' + TextoFiscal + '|' + Res1;

        EscribeComando(Comando, 'ImprimeTextoFiscal');
    end;


    procedure FechaHora(var FechaTicket: Text[30]; var HoraTicket: Text[30])
    var
        Estado: Integer;
        ReturnCode: Integer;
        EstadoPrinter: Integer;
        EstadoFiscal: Integer;
    begin
    end;


    procedure GeneraLibroDia()
    begin
    end;


    procedure HistCierreXFecha(FechaIni: Text[8]; FechaFin: Text[8])
    var
        Estado: Integer;
        ReturnCode: Integer;
        EstadoPrinter: Integer;
        EstadoFiscal: Integer;
    begin
    end;


    procedure HistCierreXZ(var CierreIni: Text[16]; var CierreFin: Text[16])
    var
        Estado: Integer;
        ReturnCode: Integer;
        EstadoPrinter: Integer;
        EstadoFiscal: Integer;
    begin
    end;


    procedure IDImpresora(var NumSerie: Text[10]; var NumImpresora: Text[6]; var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer)
    begin
    end;


    procedure InformeX()
    var
        Estado: Integer;
        ReturnCode: Integer;
        EstadoPrinter: Integer;
        EstadoFiscal: Integer;
    begin
    end;


    procedure LineaComentarioTicket(TextoFiscal: Text[42]; Res1: Text[1]): Decimal
    var
        Comando: Text[1024];
        Retorno: Decimal;
    begin
    end;


    procedure TicketInfo(var NIF: Text[16]; var TipoNCF: Integer; var TotBruto: Text[12]; var TotNeto: Text[12]; var TotITBIS: Text[12]; var CantITEMS: Text[4]; var CantITEMExe: Text[4]; var MaxITEMs: Text[4]; var CantDesc: Text[2]; var DescPend: Text[2]; var CantImp: Text[2]; var ImpPend: Text[2]; var CantPagos: Text[2]; var PagosMax: Text[2]; var CantDonac: Text[2]; var DonacPend: Text[2]; var FaseTicket: Text[2])
    begin
    end;


    procedure TipoLetra(TipoLetra: Text[1]; var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer)
    begin
    end;


    procedure UltTicket()
    var
        Estado: Integer;
        ReturnCode: Integer;
        EstadoPrinter: Integer;
        EstadoFiscal: Integer;
        NIF: Text[30];
        MontoTicket: Text[30];
        VueltoTicket: Text[30];
    begin
    end;


    procedure VerificaEstado(var Estado: Integer; var ReturnCode: Integer; var EstadoPrinter: Integer; var EstadoFiscal: Integer; var UltimoError: Integer)
    begin
    end;


    procedure fnCentraTitulo(var TextoLin: Text[56]; AnchoReporte: Integer): Text[56]
    var
        LenTexto: Integer;
        Espacios: Integer;
        Texto: Text[60];
    begin

        LenTexto := StrLen(TextoLin);
        Espacios := (AnchoReporte - LenTexto) div 2;

        TextoLin := CopyStr(Text014, 1, Espacios) + TextoLin;
        exit(TextoLin);
    end;


    procedure fnCentraLinea(Columna1: Text[30]; Columna2: Text[15]; AnchoReporte: Integer): Text[56]
    var
        Linea1: Text[56];
        Linea2: Text[56];
        Texto1: Integer;
        Texto2: Integer;
    begin

        Texto1 := (AnchoReporte - (StrLen(Columna1) + StrLen(Columna2)));

        Linea1 := CopyStr(Text014, 1, Texto1);
        Linea2 := Columna1 + Linea1 + Columna2;
        exit(Linea2);
    end;


    procedure fnCentraTotales(Columna1: Text[30]; Columna2: Text[15]; AnchoReporte: Integer): Text[53]
    var
        Linea1: Text[53];
        Espacio: Text[53];
        Texto1: Integer;
    begin

        Texto1 := (53 - (StrLen(Columna1) + StrLen(Columna2)));

        Espacio := CopyStr(Text014, 1, Texto1);
        Linea1 := Columna1 + Espacio + Columna2;
        exit(Linea1);
    end;


    procedure fnCentraDetalle(Columna1: Text[22]; Columna2: Text[15]; Columna3: Text[16]; AnchoRep: Integer): Text[56]
    var
        Linea1: Text[56];
        Texto1: Integer;
        Texto2: Integer;
        Texto3: Integer;
        AnchoCol1: Integer;
        AnchoCol2: Integer;
        AnchoCol3: Integer;
        Espacio1: Text[22];
        Espacio2: Text[15];
        Espacio3: Text[16];
        Col1: Text[22];
        Col2: Text[15];
        Col3: Text[16];
    begin

        Texto1 := (22 - (StrLen(CopyStr(Columna1, 1, 22))));
        Texto2 := (15 - StrLen(Columna2));
        Texto3 := (16 - StrLen(Columna3));

        Espacio1 := CopyStr(Text014, 1, Texto1);
        Espacio2 := CopyStr(Text014, 1, Texto2);
        Espacio3 := CopyStr(Text014, 1, Texto3);

        Linea1 := Columna1 + Espacio1 + Espacio2 + Columna2 + Espacio3 + Columna3;

        exit(Linea1);
    end;


    procedure fnCentraDetalleNeg(Columna1: Text[22]; Columna2: Text[15]; Columna3: Text[16]; AnchoRep: Integer): Text[56]
    var
        Linea1: Text[56];
        Texto1: Integer;
        Texto2: Integer;
        Texto3: Integer;
        Espacio1: Text[22];
        Espacio2: Text[15];
        Espacio3: Text[16];
    begin

        // Lim. Columna 1 := 22; Lim. Columna 2 := 37; Lim. Columna 3 := 53
        // Ancho Columna 1 := 22; Ancho Columna 2 := 15; Ancho Columna 3 := 16

        Texto1 := (22 - (StrLen(CopyStr(Columna1, 1, 22))));
        Texto2 := (15 - StrLen(Columna2));
        Texto3 := (15 - StrLen(Columna3));

        Espacio1 := CopyStr(Text014, 1, Texto1);
        Espacio2 := CopyStr(Text014, 1, Texto2);
        Espacio3 := CopyStr(Text014, 1, Texto3);

        Linea1 := Columna1 + Espacio1 + Espacio2 + Columna2 + '-' + Espacio3 + Columna3 + '-';

        exit(Linea1);
    end;


    procedure UltimoError(var UltimoError: Integer)
    begin
    end;


    procedure OpenNonFiscalReceipt(Tipo: Code[3])
    begin
        Comando := '@OpenNonFiscalReceipt|' + Tipo;
        EscribeComando(Comando, 'OpenNonFiscalReceipt');
    end;


    procedure PrintNonFiscalText(Texto: Text[1024])
    begin

        Comando := '@PrintNonFiscalText' + '|' + Texto;
        EscribeComando(Comando, 'PrintNonFiscalText');
    end;


    procedure CloseNonFiscalReceipt()
    begin
        Comando := '@CloseNonFiscalReceipt|N';
        EscribeComando(Comando, 'CloseNonFiscalReceipt');
    end;


    procedure StatusExtra()
    begin
        Comando := '@StatusExtra';
        EscribeComando(Comando, 'ImprimeLinea');
    end;


    procedure IF_ERROR2()
    begin
    end;
}

