codeunit 55005 "Procesar lote FE"
{
    // #35029 RRT, 20.07.17: Mejoras y automatización FE Ecuador V2.
    // 
    // OBSERVACIONES:
    // 1) En la configuracion debe indicarse el AMBIENTE que toque. Si es de pruebas, hay que ir con mucho cuidado ya que podemos enviar informacion fiscal incorrecta.
    // 2) Para realizacion de pruebas se ha usado una tabla auxiliar y la funcion TestProcesarTipoDocumento()
    // 3) En la funcion AutorizarLote(), sólo se trataban facturas de venta. Lo he cambiado para tratar todos los "documentos FE" pendientes de autorizar.
    // 
    // ---------------------------------
    // YFC     : Yefrecis Francisco Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC      27/8/2020       SANTINAV-1619 Mejoras
    // 002         LDP      09/05/2023      Revisión Rendimiento BC PRIVADO Santillana

    TableNo = "Parametros lote FE";

    trigger OnRun()
    var
        recFacVta: Record "Sales Invoice Header";
        recNCVta: Record "Sales Cr.Memo Header";
        recRemVta: Record "Sales Shipment Header";
        recRemTran: Record "Transfer Shipment Header";
        recFacCmp: Record "Purch. Inv. Header";
        recNCCmp: Record "Purch. Cr. Memo Hdr.";
        /*         cduFE: Codeunit "Comprobantes electronicos"; */
        ParamentrosLote: Record "Parametros lote FE";
    begin
        /*   // ++ 001-YFC
          // Home(ParamentrosLote);

          if "Tipo comprobante" = "Tipo comprobante"::" " then begin
              EnviarLote;
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

          // -- 001-YFC */
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
        Text012: Label '<-29D>';
        Text013: Label 'Autorizando comprobantes\\';
        "Procesar lote FE": Codeunit "Procesar lote FE";
        ProcLoteFE: Codeunit "Procesar lote FE";
        borrar: Record borrar;


    procedure Home(var _ParametrosLote: Record "Parametros lote FE")
    var
        recFacVta: Record "Sales Invoice Header";
        recNCVta: Record "Sales Cr.Memo Header";
        recRemVta: Record "Sales Shipment Header";
        recRemTran: Record "Transfer Shipment Header";
        recFacCmp: Record "Purch. Inv. Header";
        recNCCmp: Record "Purch. Cr. Memo Hdr.";
    /*         cduFE: Codeunit "Comprobantes electronicos"; */
    begin
        // Cree esta funcion para manejar lo que se hacía en el ONRUN de esta CU 001-YFC
        /*
        WITH _ParametrosLote DO BEGIN // 001-YFC
        
          IF "Tipo comprobante" = "Tipo comprobante"::" " THEN BEGIN
            EnviarLote;
            AutorizarLote;
          END
          ELSE
            CASE Accion OF
              Accion::Enviar :
                CASE "Tipo comprobante" OF
                  "Tipo comprobante"::Factura : BEGIN
                    recFacVta.GET("No. comprobante");
                    cduFE.EnviarFactura(recFacVta,FALSE);
                  END;
                  "Tipo comprobante"::NotaCredito : BEGIN
                    recNCVta.GET("No. comprobante");
                    cduFE.EnviarNotaCredito(recNCVta,FALSE);
                  END;
                  "Tipo comprobante"::RemisionVta : BEGIN
                    recRemVta.GET("No. comprobante");
                    cduFE.EnviarRemisionVenta(recRemVta,FALSE)
                  END;
                  "Tipo comprobante"::RemisionTrans :  BEGIN
                    recRemTran.GET("No. comprobante");
                    cduFE.EnviarRemisionTrans(recRemTran,FALSE)
                  END;
                  "Tipo comprobante"::RetencionFac :  BEGIN
                    recFacCmp.GET("No. comprobante");
                    cduFE.EnviarComprobanteRetencionFac(recFacCmp,FALSE)
                  END;
                  "Tipo comprobante"::RetencionNC : BEGIN
                    recNCCmp.GET("No. comprobante");
                    cduFE.EnviarComprobanteRetencionNC(recNCCmp,FALSE)
                  END;
                END;
              Accion::Autorizar : cduFE.ComprobarAutorizacion("No. comprobante",FALSE,0);
            END;
        END; //001-YFC
        */

    end;


    procedure EnviarLote(): Boolean
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
    begin

        if GuiAllowed then
            //dlgProgreso.OPEN(Text001+Text002+Text003+Text004+Text005);
            dlgProgreso.Open(Text001 + Text002 + Text003);

        //+#35029
        //... Debemos restringir a los documentos con fecha no anterior a un periodo.
        lFechaInicio := CalcDate(Text012, WorkDate);
        lFiltrarPorFecha := true;
        //-#35029

        //Remisiones venta
        recRemVta.Reset;
        recRemVta.SetCurrentKey("Posting Date"); // 001-YFC
        recRemVta.SetFilter("Posting Date", '>=%1', lFechaInicio); // 001-YFC
        recRemVta.CalcFields("Facturacion electronica", "Estado envio FE");  // 001-YFC
        recRemVta.SetRange("Facturacion electronica", true);
        recRemVta.SetFilter("Estado envio FE", '<>%1', recRemVta."Estado envio FE"::Enviado);

        // ++ 001-YFC
        /*
        //+#35029. Temporal.
        //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
        IF TestProcesarTipoDocumento(0,110,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
        IF lFiltroNoDocumento <> '' THEN
          SETFILTER("No.",lFiltroNoDocumento);
        //-#35029. Temporal.

        //+#35029
        IF lFiltrarPorFecha THEN
          SETFILTER("Posting Date",'>=%1',lFechaInicio);
        //-035029
        */
        // -- 001-YFC

        if recRemVta.FindSet then begin

            if GuiAllowed then
                dlgProgreso.Update(1, Text008);

            repeat

                if GuiAllowed then
                    dlgProgreso.Update(2, recRemVta."No.");

                //+35029 - 26.03.18
                //... Revisamos que no haya indicios de error y ya hayamos procesar el documento "demasiadas" veces.
                //IF TestNoHayPresuntoError(2,"No.",TODAY) THEN BEGIN  // 001-YFC
                recParam.Init;
                recParam."Tipo comprobante" := recParam."Tipo comprobante"::RemisionVta;
                recParam."No. comprobante" := recRemVta."No.";
                recParam.Accion := recParam.Accion::Enviar;
                Commit;
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            // InsertarLOG(recParam, NOT ProcLoteFE.Home(recParam));
            //END;  //+35029 // 001-YFC

            until recRemVta.Next = 0;
        end;
        // END; //#35029. Temporal.  // 001-YFC

        //Remisiones transferencia
        recRemTran.Reset;
        recRemTran.SetCurrentKey("Posting Date"); // 001-YFC
        recRemTran.SetFilter("Posting Date", '>=%1', lFechaInicio); // 001-YFC
        recRemTran.CalcFields("Facturacion electronica", "Estado envio FE");  // 001-YFC

        recRemTran.SetRange("Facturacion electronica", true);
        recRemTran.SetFilter("Estado envio FE", '<>%1', recRemTran."Estado envio FE"::Enviado);

        // ++ 001-YFC
        /*
       //+#35029. Temporal.
       //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
       IF TestProcesarTipoDocumento(0,5744,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
       IF lFiltroNoDocumento <> '' THEN
         SETFILTER("No.",lFiltroNoDocumento);
       //-#35029. Temporal.

       //+#35029
       IF lFiltrarPorFecha THEN
         SETFILTER("Posting Date",'>=%1',lFechaInicio);
       //-035029
        */
        // -- 001-YFC

        if recRemTran.FindSet then begin

            if GuiAllowed then
                dlgProgreso.Update(1, Text009);

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, recRemTran."No.");

                //+35029 - 26.03.18
                //... Revisamos que no haya indicios de error y ya hayamos procesar el documento "demasiadas" veces.
                //IF TestNoHayPresuntoError(2,"No.",TODAY) THEN BEGIN // 001-YFC
                recParam.Init;
                recParam."Tipo comprobante" := recParam."Tipo comprobante"::RemisionTrans;
                recParam."No. comprobante" := recRemTran."No.";
                recParam.Accion := recParam.Accion::Enviar;
                Commit;
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            // END; //+35029 // 001-YFC

            until recRemTran.Next = 0;
        end;
        // END; //#35029. Temporal // 001-YFC

        //Facturas venta
        recFacVta.Reset;
        recFacVta.SetCurrentKey("Posting Date"); // 001-YFC
        recFacVta.SetFilter("Posting Date", '>=%1', lFechaInicio); // 001-YFC

        recFacVta.CalcFields("Facturacion electronica", "Estado envio FE");  // 001-YFC
        recFacVta.SetRange("Facturacion electronica", true);
        recFacVta.SetFilter("Estado envio FE", '<>%1', recFacVta."Estado envio FE"::Enviado);

        // ++ 001-YFC
        /*
        //+#35029. Temporal.
        //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
        IF TestProcesarTipoDocumento(0,112,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
        IF lFiltroNoDocumento <> '' THEN
          SETFILTER("No.",lFiltroNoDocumento);
        //-#35029. Temporal.

        //+#35029
        IF lFiltrarPorFecha THEN
          SETFILTER("Posting Date",'>=%1',lFechaInicio);
        //-035029
        */
        // -- 001-YFC

        if recFacVta.FindSet then begin
            if GuiAllowed then
                dlgProgreso.Update(1, Text006);

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, recFacVta."No.");

                //+35029 - 26.03.18
                //... Revisamos que no haya indicios de error y ya hayamos procesar el documento "demasiadas" veces.
                //IF TestNoHayPresuntoError(0,"No.",TODAY) THEN BEGIN   // YFC
                recParam.Init;
                recParam."Tipo comprobante" := recParam."Tipo comprobante"::Factura;
                recParam."No. comprobante" := recFacVta."No.";
                recParam.Accion := recParam.Accion::Enviar;
                Commit;
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            // END; //+35029   // YFC
            until recFacVta.Next = 0;
        end;
        // END; //#35029. Temporal. // 001-YFC

        //Notas de crédito de venta
        recNCVta.Reset;
        recNCVta.SetCurrentKey("Posting Date"); // 001-YFC
        recNCVta.SetFilter("Posting Date", '>=%1', lFechaInicio); // 001-YFC
        recNCVta.CalcFields("Facturacion electronica", "Estado envio FE");  // 001-YFC
        recNCVta.SetRange("Facturacion electronica", true);
        recNCVta.SetFilter("Estado envio FE", '<>%1', recNCVta."Estado envio FE"::Enviado);

        // ++ 001-YFC
        /*
         //+#35029. Temporal.
         //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
         IF TestProcesarTipoDocumento(0,114,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
         IF lFiltroNoDocumento <> '' THEN
           SETFILTER("No.",lFiltroNoDocumento);
         //-#35029. Temporal.

         //+#35029
         IF lFiltrarPorFecha THEN
           SETFILTER("Posting Date",'>=%1',lFechaInicio);
         //-035029
         */
        // -- 001-YFC

        if recNCVta.FindSet then begin

            if GuiAllowed then
                dlgProgreso.Update(1, Text007);

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, recNCVta."No.");

                //+35029 - 26.03.18
                //... Revisamos que no haya indicios de error y ya hayamos procesar el documento "demasiadas" veces.
                // IF TestNoHayPresuntoError(3,"No.",TODAY) THEN BEGIN
                recParam.Init;
                recParam."Tipo comprobante" := recParam."Tipo comprobante"::NotaCredito;
                recParam."No. comprobante" := recNCVta."No.";
                recParam.Accion := recParam.Accion::Enviar;
                Commit;
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            //END;  //+35029    // 001-YFC

            until recNCVta.Next = 0;
        end;
        // END; //#35029. Temporal.   // 001-YFC

        //Retenciones facturas compra
        recFacCmp.Reset;
        recFacCmp.SetCurrentKey("Posting Date"); // 001-YFC
        recFacCmp.SetFilter("Posting Date", '>=%1', lFechaInicio); // 001-YFC
        recFacCmp.CalcFields("Facturacion electronica Ret.", "Estado envio FE Ret.");  // 001-YFC
        recFacCmp.SetRange("Facturacion electronica Ret.", true);
        recFacCmp.SetFilter("Estado envio FE Ret.", '<>%1', recFacCmp."Estado envio FE Ret."::Enviado);

        // ++ 001-YFC
        /*
       //+#35029. Temporal.
       //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
       IF TestProcesarTipoDocumento(0,122,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
       IF lFiltroNoDocumento <> '' THEN
         SETFILTER("No.",lFiltroNoDocumento);
       //-#35029. Temporal.

       //+#35029
       IF lFiltrarPorFecha THEN
         SETFILTER("Posting Date",'>=%1',lFechaInicio);
       //-035029
       */
        // -- 001-YFC

        if recFacCmp.FindSet then begin
            if GuiAllowed then
                dlgProgreso.Update(1, Text010);

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, recFacCmp."No.");

                //+35029 - 26.03.18
                //... Revisamos que no haya indicios de error y ya hayamos procesar el documento "demasiadas" veces.
                // IF TestNoHayPresuntoError(1,"No.",TODAY) THEN BEGIN // 001-YFC
                recParam.Init;
                recParam."Tipo comprobante" := recParam."Tipo comprobante"::RetencionFac;
                recParam."No. comprobante" := recFacCmp."No.";
                recParam.Accion := recParam.Accion::Enviar;
                Commit;
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            //END; //+35029  // 001-YFC

            until recFacCmp.Next = 0;
        end;
        // END; //#35029. Temporal. // 001-YFC

        //Retenciones notas crédito compra
        recNCCmp.Reset;
        recNCCmp.SetCurrentKey("Posting Date"); // 001-YFC
        recNCCmp.SetFilter("Posting Date", '>=%1', lFechaInicio); // 001-YFC
        recNCCmp.CalcFields("Facturacion electronica Ret.", "Estado envio FE Ret.");  // 001-YFC

        recNCCmp.SetRange("Facturacion electronica Ret.", true);
        recNCCmp.SetFilter("Estado envio FE Ret.", '<>%1', recNCCmp."Estado envio FE Ret."::Enviado);

        // ++ 001-YFC
        /*
        //+#35029. Temporal.
        //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
        IF TestProcesarTipoDocumento(0,124,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
        IF lFiltroNoDocumento <> '' THEN
          SETFILTER("No.",lFiltroNoDocumento);
        //-#35029. Temporal.

        //+#35029
        IF lFiltrarPorFecha THEN
          SETFILTER("Posting Date",'>=%1',lFechaInicio);
        //-035029
       */
        // -- 001-YFC

        if recNCCmp.FindSet then begin
            if GuiAllowed then
                dlgProgreso.Update(1, Text011);

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, recNCCmp."No.");

                //+35029 - 26.03.18
                //... Revisamos que no haya indicios de error y ya hayamos procesar el documento "demasiadas" veces.
                //IF TestNoHayPresuntoError(1,"No.",TODAY) THEN BEGIN   // 001-YFC
                recParam.Init;
                recParam."Tipo comprobante" := recParam."Tipo comprobante"::RetencionNC;
                recParam."No. comprobante" := recNCCmp."No.";
                recParam.Accion := recParam.Accion::Enviar;
                Commit;
                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            //  END;   //+35029 // 001-YFC

            until recNCCmp.Next = 0;
        end;
        // END; //+35029. Temporal.   // 001-YFC


        //+35029
        if GuiAllowed then
            dlgProgreso.Close;
        //-35029

    end;


    procedure AutorizarLote()
    var
        recCabFac: Record "Sales Invoice Header";
        /*         cduFE: Codeunit "Comprobantes electronicos"; */
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
        //+#35029
        //... Se asterisca el codigo antiguo.
        /*
        recCabFac.RESET;
        recCabFac.SETRANGE("Facturacion electronica", TRUE);
        recCabFac.SETRANGE("Estado envio FE", recCabFac."Estado envio FE"::Enviado);
        recCabFac.SETFILTER("Estado autorizacion FE", '<>%1', recCabFac."Estado autorizacion FE"::Autorizado);
        IF recCabFac.FINDSET THEN
          REPEAT
            cduFE.ComprobarAutorizacion(recCabFac."No.",FALSE);
          UNTIL recCabFac.NEXT = 0;
        */

        //... Entiendo que la autorizacion debe realizarse para todos los tipos de documento.
        AutorizarDocumentos;

    end;


    procedure InsertarLOG(recPrmParam: Record "Parametros lote FE"; blnPrmError: Boolean)
    var
    /*         lcduFE: Codeunit "Comprobantes electronicos"; */
    begin
        //+35029
        //... Este es el codigo que había anteriormente. El log apuntaba a 55015 en lugar de 55013. Lo cambiamos.
        /*
        recLOG.INIT;
        recLOG."Fecha hora mov."  := CURRENTDATETIME;
        recLOG.Usuario            := USERID;
        recLOG."Tipo documento"   := recPrmParam."Tipo comprobante";
        recLOG."No. documento"    := recPrmParam."No. comprobante";
        recLOG.Error              := blnPrmError;
        IF blnPrmError THEN BEGIN
          recLOG.Descripcion := COPYSTR(GETLASTERRORTEXT,1,250);
          CLEARLASTERROR;
        END
        ELSE
          recLOG.Descripcion := FORMAT(recPrmParam.Accion);
        recLOG.INSERT(TRUE);
        */

        //... Si hay un error, posiblemente no se haya grabado en el LOG. Lo hacemos ahora.
        if blnPrmError then begin
            //... El valor '6', es el error.
            /*         lcduFE.Parametros(recPrmParam);
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
    begin
        //+#35029
        if GuiAllowed then
            //dlgProgreso.OPEN(Text013+Text002+Text003+Text004+Text005);
            dlgProgreso.Open(Text013 + Text002 + Text003);

        //... Debemos restringir a los documentos con fecha no anterior a un periodo.
        lFechaInicio := CalcDate(Text012, WorkDate);
        lFiltrarPorFecha := true;
        //-#35029

        rOrigen.Reset;
        rOrigen.SetCurrentKey("Fecha emision"); // 001-YFC
        rOrigen.SetFilter("Fecha emision", '>=%1', lFechaInicio);    // 001-YFC
        rOrigen.SetFilter("Estado envio", '=%1', rOrigen."Estado envio"::Enviado);
        rOrigen.SetFilter("Estado autorizacion", '<>%1', rOrigen."Estado autorizacion"::Autorizado); // 001-YFC
                                                                                                     //rOrigen.SETFILTER(rOrigen."Tipo documento", '=%1', rOrigen."Tipo documento"::Factura); // 001-YFC

        //... Asteriscamos temporalmente hasta que se hayan hecho las pruebas.
        //rOrigen.SETFILTER("Fecha emision",'>=%1',lFechaInicio);
        //Factura,Retencion,Remision,NotaCredito,NotaDebito

        // ++ 001-YFC
        /*
        //+#35029. Temporal.
        //... Posibilidad de ejecutar, restrigiendo sólo para unos documentos. El uso debe ser temporal.
        IF TestProcesarTipoDocumento(1,0,lFiltroNoDocumento,lFiltrarPorFecha) THEN BEGIN
        
          IF lFiltroNoDocumento <> '' THEN
            rOrigen.SETFILTER("No. documento",lFiltroNoDocumento);
          //-#35029. Temporal.
        
         // +#35029
          IF lFiltrarPorFecha THEN
            rOrigen.SETFILTER("Fecha emision",'>=%1',lFechaInicio);
          //-035029
          */
        // -- 001-YFC

        if rOrigen.FindSet then begin

            if GuiAllowed then
                dlgProgreso.Update(1, Text006);

            repeat
                if GuiAllowed then
                    dlgProgreso.Update(2, rOrigen."No. documento");
                recParam.Init;
                case rOrigen."Tipo documento" of
                    rOrigen."Tipo documento"::Remision:
                        recParam."Tipo comprobante" := recParam."Tipo comprobante"::RemisionVta;
                    rOrigen."Tipo documento"::Factura:
                        recParam."Tipo comprobante" := recParam."Tipo comprobante"::Factura;
                    rOrigen."Tipo documento"::NotaCredito:
                        recParam."Tipo comprobante" := recParam."Tipo comprobante"::NotaCredito;
                    rOrigen."Tipo documento"::Retencion:
                        recParam."Tipo comprobante" := recParam."Tipo comprobante"::RetencionFac;
                    rOrigen."Tipo documento"::NotaDebito:
                        recParam."Tipo comprobante" := recParam."Tipo comprobante"::NotaCredito;
                end;

                recParam."No. comprobante" := rOrigen."No. documento";
                recParam.Accion := recParam.Accion::Autorizar;
                Commit;

                InsertarLOG(recParam, not CODEUNIT.Run(CODEUNIT::"Procesar lote FE", recParam));
            //END; // 001-YFC
            until rOrigen.Next = 0;
        end;
        //END; // 001-YFC

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
}

