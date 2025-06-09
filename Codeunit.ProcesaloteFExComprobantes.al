codeunit 55012 "Procesa lote FE x Comprobantes"
{
    // #35029 RRT, 20.07.17: Mejoras y automatización FE Ecuador V2.
    // 
    // OBSERVACIONES:
    // 1) En la configuracion debe indicarse el AMBIENTE que toque. Si es de pruebas, hay que ir con mucho cuidado ya que podemos enviar informacion fiscal incorrecta.
    // 2) Para realizacion de pruebas se ha usado una tabla auxiliar y la funcion TestProcesarTipoDocumento()
    // 3) En la funcion AutorizarLote(), sólo se trataban facturas de venta. Lo he cambiado para tratar todos los "documentos FE" pendientes de autorizar.
    // 
    // ---------------------------------
    // LDP         : Luis Jose De La Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         LDP      03/09/2024      SANTINAV-6369: Autorizaciones automáticas - Separar

    Permissions = TableData "Parametros lote FE" = rimd;
    TableNo = "Parametros lote FE";

    trigger OnRun()
    var
        recFacVta: Record "Sales Invoice Header";
        recNCVta: Record "Sales Cr.Memo Header";
        recRemVta: Record "Sales Shipment Header";
        recRemTran: Record "Transfer Shipment Header";
        recFacCmp: Record "Purch. Inv. Header";
        recNCCmp: Record "Purch. Cr. Memo Hdr.";

        ParamentrosLote: Record "Parametros lote FE";
    begin
        /*         //001+ LDP
                if "Tipo comprobante" = "Tipo comprobante"::" " then begin
                    EnviarLotexComprobante;
                    AutorizarLote;
                end
                else
                    case Accion of
                        Accion::Enviar:
                            case "Tipo comprobante" of
                                "Tipo comprobante"::Factura:
                                    begin
                                        recFacVta.Get("No. comprobante");
                                        cduFE.EnviarFactura(recFacVta, false);
                                    end;
                                "Tipo comprobante"::NotaCredito:
                                    begin
                                        recNCVta.Get("No. comprobante");
                                        cduFE.EnviarNotaCredito(recNCVta, false);
                                    end;
                                "Tipo comprobante"::RemisionVta:
                                    begin
                                        recRemVta.Get("No. comprobante");
                                        cduFE.EnviarRemisionVenta(recRemVta, false)
                                    end;
                                "Tipo comprobante"::RemisionTrans:
                                    begin
                                        recRemTran.Get("No. comprobante");
                                        cduFE.EnviarRemisionTrans(recRemTran, false)
                                    end;
                                "Tipo comprobante"::RetencionFac:
                                    begin
                                        recFacCmp.Get("No. comprobante");
                                        cduFE.EnviarComprobanteRetencionFac(recFacCmp, false)
                                    end;
                                "Tipo comprobante"::RetencionNC:
                                    begin
                                        recNCCmp.Get("No. comprobante");
                                        cduFE.EnviarComprobanteRetencionNC(recNCCmp, false)
                                    end;
                            end;
                        Accion::Autorizar:
                            cduFE.ComprobarAutorizacion("No. comprobante", false, 0);
                    end;
                //001+ LDP */
    end;

    var
        Text001: Label 'Enviando comprobantes\\';
        Text002: Label 'Tipo de comprobante #########1\';
        Text003: Label 'Nº de comprobante #########2\\';
        Text004: Label '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@3\';
        Text005: Label '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4';
        dlgProgreso: Dialog;
        intProcesados: Integer;
        intTotal: Integer;
        Text006: Label 'Factura';
        Text007: Label 'Nota de crédito';
        Text008: Label 'Remisión de venta';
        Text009: Label 'Remisión tranfer.';
        Text010: Label 'Retención compra';
        Text011: Label 'Retención NC compra';
        Text012: Label '<<-3D>>';
        Text013: Label 'Autorizando comprobantes\\';
        "Procesar lote FE": Codeunit "Procesar lote FE";
        ProcLoteFE: Codeunit "Procesar lote FE";
        borrar: Record borrar;
        TipoComprobante: Option " ","Factura Venta","Nota Credito","Remision Venta","Remision Transferencia","Retencion Factura","Retencion Nota Credito";
        recParamE: Record "Parametros lote FE";
        rTipoComprobante: Option " ","Factura Venta","Nota Credito","Remision Venta","Remision Transferencia","Retencion Factura","Retencion Nota Credito";


    procedure AutorizarLote()
    var
        recCabFac: Record "Sales Invoice Header";
        /*    cduFE: Codeunit "Comprobantes electronicos"; */
        r114: Record "Sales Cr.Memo Header";
        r5744: Record "Transfer Shipment Header";
        r110: Record "Sales Shipment Header";
        r122: Record "Purch. Inv. Header";
        r124: Record "Purch. Cr. Memo Hdr.";
        lFechaInicio: Date;
        lFiltroNoDocumento: Text[100];
        lFiltrarPorFecha: Boolean;
        recParam: Record "Parametros lote FE";
    begin

        AutorizarDocumentos;
    end;


    procedure InsertarLOG(recPrmParam: Record "Parametros lote FE"; blnPrmError: Boolean)
    var
    /*      lcduFE: Codeunit "Comprobantes electronicos"; */
    begin
        //... Si hay un error, posiblemente no se haya grabado en el LOG. Lo hacemos ahora.
        if blnPrmError then begin
            //... El valor '6', es el error.
            /*    lcduFE.Parametros(recPrmParam);
               lcduFE.GuardarLOG(recPrmParam."No. comprobante", '', 6, CopyStr(GetLastErrorText, 1, 250), ''); */
            //lcduFE.GuardarLOG(recPrmParam."No. comprobante",'',6,COPYSTR(GETLASTERRORTEXT,250,250),'');
        end;
    end;


    procedure TestProcesarTipoDocumento(pTipoOperacion: Option Enviar,Autorizar; pIdTabla: Integer; var vFiltroDocumento: Text[100]; var vFiltrarPorFecha: Boolean): Boolean
    var
        lrAuxiliar: Record "Auxiliar proceso docum. SRI";
        lResult: Boolean;
        lTabla: Option " ","110","112","114","122","124","5744";
    begin
        //#35029

        lResult := true;
        vFiltroDocumento := '';
        vFiltrarPorFecha := true;

        lTabla := lTabla::" ";
        if pTipoOperacion = pTipoOperacion::Enviar then begin
            case pIdTabla of
                110:
                    lTabla := lTabla::"110";
                112:
                    lTabla := lTabla::"112";
                114:
                    lTabla := lTabla::"114";
                122:
                    lTabla := lTabla::"122";
                124:
                    lTabla := lTabla::"124";
                5744:
                    lTabla := lTabla::"5744";
            end;
        end;


        if lrAuxiliar.Get(pTipoOperacion, lTabla) then begin
            if not lrAuxiliar.Procesar then
                lResult := false
            else begin
                if lrAuxiliar.Filtro <> '' then
                    vFiltroDocumento := lrAuxiliar.Filtro;

                vFiltrarPorFecha := lrAuxiliar."Filtrar por fecha";
            end;
        end;

        exit(lResult);
    end;


    procedure AutorizarDocumentos()
    var
        rOrigen: Record "Documento FE";
        /*         cduFE: Codeunit "Comprobantes electronicos"; */
        lFechaInicio: Date;
        lFiltroNoDocumento: Text[100];
        lFiltrarPorFecha: Boolean;
        recParam: Record "Parametros lote FE";
        TextTipoComprobante: Text;
        OrTipoDoc: Option Factura,Retencion,Remision,NotaCredito,NotaDebito,Liquidacion;
    begin
        //+#35029
        if GuiAllowed then
            //dlgProgreso.OPEN(Text013+Text002+Text003+Text004+Text005);
            dlgProgreso.Open(Text013 + Text002 + Text003);

        //... Debemos restringir a los documentos con fecha no anterior a un periodo.
        lFechaInicio := CalcDate(Text012, WorkDate);
        lFiltrarPorFecha := true;
        //-#35029

        //11/09/2024+
        Clear(OrTipoDoc);
        case rTipoComprobante of
            rTipoComprobante::"Remision Venta":
                OrTipoDoc := rOrigen."Tipo documento"::Remision;
            rTipoComprobante::"Factura Venta":
                OrTipoDoc := rOrigen."Tipo documento"::Factura;
            rTipoComprobante::"Nota Credito":
                OrTipoDoc := rOrigen."Tipo documento"::NotaCredito;
            rTipoComprobante::"Retencion Factura":
                OrTipoDoc := rOrigen."Tipo documento"::Retencion;
            rTipoComprobante::"Retencion Nota Credito":
                OrTipoDoc := rOrigen."Tipo documento"::NotaDebito;
        end;
        //recParam."Tipo comprobante" := rTipoComprobante;
        //11/09/2024-

        rOrigen.Reset;
        rOrigen.SetCurrentKey("Fecha emision");
        rOrigen.SetFilter("Fecha emision", '>=%1', lFechaInicio);
        rOrigen.SetFilter("Estado envio", '=%1', rOrigen."Estado envio"::Enviado);
        rOrigen.SetFilter("Estado autorizacion", '<>%1', rOrigen."Estado autorizacion"::Autorizado);
        rOrigen.SetRange("Tipo documento", OrTipoDoc);//11/09/2024+-
        if rOrigen.FindSet then begin

            if GuiAllowed then
                //LDP+ //11/09/2024+
                Clear(TextTipoComprobante);
            TextTipoComprobante := Format(rOrigen."Tipo documento");
            dlgProgreso.Update(1, TextTipoComprobante);
            //dlgProgreso.UPDATE(1, Text006);
            //LDP- //11/09/2024+

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, rOrigen."No. documento");
                recParam.Init;
                //11/09/2024+
                /*
                CASE rOrigen."Tipo documento" OF
                  rOrigen."Tipo documento"::Remision: recParam."Tipo comprobante" := recParam."Tipo comprobante"::RemisionVta;
                  rOrigen."Tipo documento"::Factura: recParam."Tipo comprobante" := recParam."Tipo comprobante"::Factura;
                  rOrigen."Tipo documento"::NotaCredito: recParam."Tipo comprobante" := recParam."Tipo comprobante"::NotaCredito;
                  rOrigen."Tipo documento"::Retencion: recParam."Tipo comprobante" := recParam."Tipo comprobante"::RetencionFac;
                  rOrigen."Tipo documento"::NotaDebito: recParam."Tipo comprobante" := recParam."Tipo comprobante"::NotaCredito;
                END;
                */
                recParam."Tipo comprobante" := rTipoComprobante;
                //11/09/2024-

                recParam."No. comprobante" := rOrigen."No. documento";
                recParam.Accion := recParam.Accion::Autorizar;
                Commit;
                //InsertarLOG(recParam, NOT CODEUNIT.RUN(CODEUNIT::"Procesar lote FE",recParam));
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesa lote FE x Comprobantes", recParam));//001+-

            until rOrigen.Next = 0;
        end;
        if GuiAllowed then
            dlgProgreso.Close;

    end;


    procedure TestNoHayPresuntoError(pTipoDocumento: Option Factura,Retencion,Remision,NotaCredito,NotaDebito; pDocumento: Code[20]; pFecha: Date): Boolean
    var
        lResult: Boolean;
        lrLog: Record "Log comprobantes electronicos";
    begin
        //+35029
        //... Se intentará procesar un documento hasta un número determinado de veces.
        //... Para simplificar el método, si vemos que hay mas de N registros en el LOG para un mismo día, devolvemos el valor FALSE.
        lResult := true;

        lrLog.Reset;
        lrLog.SetCurrentKey("Tipo documento", "No. documento");//LDP-001+-
        //lrLog.SETCURRENTKEY("No. documento",Estado);//LDP-001+- SetCurrenKey para mejorar el rendimiento de las bases de datos
        lrLog.SetRange("Tipo documento", pTipoDocumento);
        lrLog.SetRange("No. documento", pDocumento);
        lrLog.SetRange("Fecha hora mov.", CreateDateTime(pFecha, 0T), CreateDateTime(pFecha, 235900T));
        if lrLog.Count > 15 then
            lResult := false;

        exit(lResult);
    end;


    procedure EnviarLotexComprobante(): Boolean
    var
        recParam: Record "Parametros lote FE";
        recRemVta: Record "Sales Shipment Header";
        recRemTran: Record "Transfer Shipment Header";
        recFacVta: Record "Sales Invoice Header";
        recNCVta: Record "Sales Cr.Memo Header";
        recFacCmp: Record "Purch. Inv. Header";
        recNCCmp: Record "Purch. Cr. Memo Hdr.";
        lFechaInicio: Date;
        lFiltroNoDocumento: Text[100];
        lFiltrarPorFecha: Boolean;
        recParamE: Record "Parametros lote FE";
    begin

        if GuiAllowed then
            dlgProgreso.Open(Text001 + Text002 + Text003);

        lFechaInicio := CalcDate(Text012, WorkDate);
        lFiltrarPorFecha := true;

        //LDP+ Borramos el registro que viene desde el reporte
        recParamE.Reset;
        recParamE.SetRange("Tipo comprobante", recParamE."Tipo comprobante"::" ");
        recParamE.SetRange("No. comprobante", '');
        recParamE.SetFilter("Tipo comprobante Manual", '<>%1', recParamE."Tipo comprobante Manual"::" ");
        if recParamE.FindSet then begin
            // 11/09/2024+
            Clear(rTipoComprobante);
            rTipoComprobante := recParamE."Tipo comprobante Manual";
            // 11/09/2024-
            recParamE.DeleteAll;
        end;
        //LDP- Borramos el registro que viene desde el reporte
        case rTipoComprobante of

            //Facturas venta++
            rTipoComprobante::"Factura Venta":
                begin
                    recFacVta.Reset;
                    recFacVta.SetCurrentKey("Posting Date");
                    recFacVta.SetFilter("Posting Date", '>=%1', lFechaInicio);
                    recFacVta.CalcFields("Facturacion electronica", "Estado envio FE");
                    recFacVta.SetRange("Facturacion electronica", true);
                    recFacVta.SetFilter("Estado envio FE", '<>%1', recFacVta."Estado envio FE"::Enviado);
                    if recFacVta.FindSet then begin
                        if GuiAllowed then
                            dlgProgreso.Update(1, Text006);

                        repeat
                            if GuiAllowed then
                                dlgProgreso.Update(2, recFacVta."No.");
                            recParam.Init;
                            recParam."Tipo comprobante" := recParam."Tipo comprobante"::Factura;
                            recParam."No. comprobante" := recFacVta."No.";
                            recParam.Accion := recParam.Accion::Enviar;
                            recParam."Tipo comprobante Manual" := recParam."Tipo comprobante Manual"::"Factura Venta";//LDP+-
                            Commit;
                            //InsertarLOG(recParam, NOT CODEUNIT.RUN(CODEUNIT::"Procesar lote FE",recParam));
                            InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesa lote FE x Comprobantes", recParam));//LDP+-
                        until recFacVta.Next = 0;
                    end;
                end;
            //Facturas venta--

            //Notas de crédito de venta ++
            rTipoComprobante::"Nota Credito":
                begin
                    recNCVta.Reset;
                    recNCVta.SetCurrentKey("Posting Date");
                    recNCVta.SetFilter("Posting Date", '>=%1', lFechaInicio);
                    recNCVta.CalcFields("Facturacion electronica", "Estado envio FE");
                    recNCVta.SetRange("Facturacion electronica", true);
                    recNCVta.SetFilter("Estado envio FE", '<>%1', recNCVta."Estado envio FE"::Enviado);
                    if recNCVta.FindSet then begin

                        if GuiAllowed then
                            dlgProgreso.Update(1, Text007);

                        repeat
                            if GuiAllowed then
                                dlgProgreso.Update(2, recNCVta."No.");

                            recParam.Init;
                            recParam."Tipo comprobante" := recParam."Tipo comprobante"::NotaCredito;
                            recParam."No. comprobante" := recNCVta."No.";
                            recParam.Accion := recParam.Accion::Enviar;
                            Commit;
                            InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesa lote FE x Comprobantes", recParam));//LDP+-
                        until recNCVta.Next = 0;
                    end;
                end;
            //Notas de crédito de venta--

            // Remision de venta ++
            rTipoComprobante::"Remision Venta":
                begin
                    recRemVta.Reset;
                    recRemVta.SetCurrentKey("Posting Date");
                    recRemVta.SetFilter("Posting Date", '>=%1', lFechaInicio);
                    recRemVta.CalcFields("Facturacion electronica", "Estado envio FE");
                    recRemVta.SetRange("Facturacion electronica", true);
                    recRemVta.SetFilter("Estado envio FE", '<>%1', recRemVta."Estado envio FE"::Enviado);
                    if recRemVta.FindSet then begin

                        if GuiAllowed then
                            dlgProgreso.Update(1, Text008);

                        repeat
                            if GuiAllowed then
                                dlgProgreso.Update(2, recRemVta."No.");

                            recParam.Init;
                            recParam."Tipo comprobante" := recParam."Tipo comprobante"::RemisionVta;
                            recParam."No. comprobante" := recRemVta."No.";
                            recParam.Accion := recParam.Accion::Enviar;
                            Commit;
                            InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesa lote FE x Comprobantes", recParam));//LDP+-
                        until recRemVta.Next = 0;
                    end;
                end;
            // Remision de venta --

            //Retenciones facturas compra++
            rTipoComprobante::"Retencion Factura":
                begin
                    recFacCmp.Reset;
                    recFacCmp.SetCurrentKey("Posting Date");
                    recFacCmp.SetFilter("Posting Date", '>=%1', lFechaInicio);
                    recFacCmp.CalcFields("Facturacion electronica Ret.", "Estado envio FE Ret.");
                    recFacCmp.SetRange("Facturacion electronica Ret.", true);
                    recFacCmp.SetFilter("Estado envio FE Ret.", '<>%1', recFacCmp."Estado envio FE Ret."::Enviado);

                    if recFacCmp.FindSet then begin
                        if GuiAllowed then
                            dlgProgreso.Update(1, Text010);
                        repeat
                            if GuiAllowed then
                                dlgProgreso.Update(2, recFacCmp."No.");

                            recParam.Init;
                            recParam."Tipo comprobante" := recParam."Tipo comprobante"::RetencionFac;
                            recParam."No. comprobante" := recFacCmp."No.";
                            recParam.Accion := recParam.Accion::Enviar;
                            Commit;
                            InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesa lote FE x Comprobantes", recParam));//LDP+-
                        until recFacCmp.Next = 0;
                    end;
                end;
            //Retenciones facturas compra--

            //Retenciones Nota Credito--
            rTipoComprobante::"Retencion Nota Credito":
                begin
                    recNCCmp.Reset;
                    recNCCmp.SetCurrentKey("Posting Date");
                    recNCCmp.SetFilter("Posting Date", '>=%1', lFechaInicio);
                    recNCCmp.CalcFields("Facturacion electronica Ret.", "Estado envio FE Ret.");
                    recNCCmp.SetRange("Facturacion electronica Ret.", true);
                    recNCCmp.SetFilter("Estado envio FE Ret.", '<>%1', recNCCmp."Estado envio FE Ret."::Enviado);
                    if recNCCmp.FindSet then begin
                        if GuiAllowed then
                            dlgProgreso.Update(1, Text011);

                        repeat
                            if GuiAllowed then
                                dlgProgreso.Update(2, recNCCmp."No.");

                            recParam.Init;
                            recParam."Tipo comprobante" := recParam."Tipo comprobante"::RetencionNC;
                            recParam."No. comprobante" := recNCCmp."No.";
                            recParam.Accion := recParam.Accion::Enviar;
                            Commit;
                            InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesa lote FE x Comprobantes", recParam));//LDP+-
                        until recNCCmp.Next = 0;
                    end;
                end;
        //Retenciones Nota Credito--
        end;

        if GuiAllowed then
            dlgProgreso.Close;
    end;
}

