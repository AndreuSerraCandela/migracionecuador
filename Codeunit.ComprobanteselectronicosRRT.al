/*codeunit 56017 "Comprobantes electronicos RRT"
{
    // #22493  08/06/2015 MOI : En el caso de que se inserte un nuevo porcentaje que no está configurado se muestra un error.
    //                          Se han añadido dos nuevos tipos de retenciones de los proveedores.
    // #25482  22/07/2015 JML : Contingencias.
    // #35982  20/11/2015 JML : Esquema off-line. Quito posibilidad de emisión en contingencia.
    //                          Se amplia el nº de autorización a 49
    // #37297  30/11/2015 JML : Corrigo error cuando se repite el % de IVA en un mismo documentos.
    // #53606  06/06/2016 JMB : Se añade un elemento al CASE de TipoComprobante que no contempla los IVA 14%
    // #53693  07/06/2016 JMB : Se indica que se realizo en el ISSUE anterior #53606
    // #54139  15/06/2016 JMB : Se crea funcion para eliminar caracteres raros (sobre todos "cr" y "lf")
    // #54139  15/06/2016 JMB : Se añade la funcion en todos los campos de texto tipo direccion.
    // #56177  26/08/2016 JMB : Se comenta ya que indican que tipo RUC siempre debe ser 4
    // #57011  13/09/2016 JMB : Se corrige un tema de redondeo del precio unitario enviado por XML
    // #35029  16.10.2017 RRT : Los mensajes se mostrarán si GUIALLOWED es TRUE. Adaptacion para DotNet. Este cambio es necesario si se ejecuta en NAS.
    //                          De hecho, en un futuro si funcionan bien las funciones con variables DotNet, se podrian eliminar las funciones con variables Automation.
    //                          Al ver que la versión en producción, ya no tiene la modificación #56177 en una de las dos modificaciones,
    //                          se ha vuelto atrás esta modificación.
    //         22.03.2018 RRT : No se permite autorizar un documento si no ha sido previamente enviado.
    //                          Hay un error notificado por SERES en el proceso de autorización. Se
    // 
    // RRT -> BUSCAR RRT PARA PROVOCAR GENERACION.

    Permissions = TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Transfer Shipment Header" = rimd;

    trigger OnRun()
    var
        texRespuesta: Text[1024];
        texInfo: Text[1024];
        lr112: Record "Sales Invoice Header";
        lr114: Record "Sales Cr.Memo Header";
        lr110: Record "Sales Shipment Header";
        lr122: Record "Purch. Inv. Header";
        lr5744: Record "Transfer Shipment Header";
        lrDocFE: Record "Documento FE";
        lrTMP: Record "Documento FE" temporary;
        lWindow: Dialog;
    begin
        //+RRT
        lrDocFE.Reset;
        lrDocFE.SetCurrentKey("Estado envio", "Estado autorizacion", "Fecha emision");
        lrDocFE.SetRange("Estado envio", lrDocFE."Estado envio"::Enviado);
        lrDocFE.SetRange("Estado autorizacion", lrDocFE."Estado autorizacion"::"No autorizado");
        lrDocFE.SetRange("Fecha emision", 20180901D, 20180912D);
        //lrDocFE.SETFILTER("No. documento",'%1|%2','CFR-042945','VFR-080720');

        lWindow.Open('Tratando ####################1');
        if lrDocFE.FindFirst then
            repeat
                lrTMP.Init;
                lrTMP.TransferFields(lrDocFE);
                lrTMP.Insert;
            until lrDocFE.Next = 0;

        //ERROR(FORMAT(lrTMP.COUNT));

        lrTMP.Reset;
        if lrTMP.FindFirst then
            repeat
                lWindow.Update(1, lrTMP."No. documento");

                case lrTMP."Tipo documento" of
                    lrTMP."Tipo documento"::Factura:
                        begin
                            lr112.Get(lrTMP."No. documento");
                            EnviarFactura(lr112, false);
                        end;

                    lrTMP."Tipo documento"::NotaCredito:
                        begin
                            lr114.Get(lrTMP."No. documento");
                            EnviarNotaCredito(lr114, false);
                        end;

                    lrTMP."Tipo documento"::Remision:
                        begin
                            if lrTMP."Subtipo documento" = lrTMP."Subtipo documento"::Transferencia then begin
                                lr5744.Get(lrTMP."No. documento");
                                EnviarRemisionTrans(lr5744, false)
                            end
                            else begin
                                lr110.Get(lrTMP."No. documento");
                                EnviarRemisionVenta(lr110, false)
                            end;
                        end;

                    lrTMP."Tipo documento"::Retencion:
                        begin
                            lr122.Get(lrTMP."No. documento");
                            EnviarComprobanteRetencionFac(lr122, false)
                        end;
                end;

                //... Finalmente autorizamos.
                ComprobarAutorizacion(lrTMP."No. documento", false);
                Commit;
            until lrTMP.Next = 0;

        lWindow.Close;


        /*
        lr110.GET('VFR-080721');
        EnviarFactura(lrSIH,TRUE);
        *//*

    end;

    var
        recCfgFE: Record "Config. Comprobantes elec.";
        optTipoDoc: Option Factura,Retencion,Remision,NotaCredito,NotaDebito;
        optEstado: Option Generado,Firmado,Enviado,Rechazado,Autorizado,"No autorizado",Error,Contingencia;
        blnManual: Boolean;
        Text001: Label 'Venta';
        Text002: Label 'Traslado de mercancía';
        Text003: Label 'El documento %1 %2 se ha enviado correctamente al SRI.';
        Text004: Label 'El documento %1 %2 se ha enviado, pero NO ha sido autorizado por el SRI. Error: %3 %4';
        Text005: Label 'Devolución';
        Text006: Label 'El documento %1 %2 ha sido autorizado por el SRI. Nº de autorización: %3';
        Text007: Label 'El documento %1 %2 NO ha sido autorizado por el SRI. Error: %3 %4';
        Text008: Label 'El documento %1 %2 todavía no ha sido procesado por el SRI. Por favor, intentelo de nuevo en unos minutos.';
        Text008b: Label 'El documento %1 %2 todavía no ha sido procesado por el SRI. El re-envio del comprobante ha sido rechazado.';
        Text009: Label '% Dto:';
        Error001: Label 'El comprobante no ha sido enviado. No se ha podido conectar con el WebService del SRI.';
        Error002: Label 'La facturación electrónica está desactivada.';
        Error003: Label 'El fichero %1 no se ha podido firmar.';
        Error004: Label 'No se ha podido encontrar fichero %1';
        Error005: Label 'El documento %1 %2 no se ha podido enviar al SRI. Error %3 %4';
        Error006: Label 'No se ha podido generar el fichero XML del documento %1 %2';
        Error007: Label 'Mo se encuentra el certificado de firma.';
        Error008: Label 'Error inesperado al concectar con WS';
        Error009: Label 'No se encuentra factura %1 relacionada con la nota de crédito %2';
        Error010: Label 'Debe enviar el comprobante antes de poder comprobar la autorización.';
        Error011: Label 'Debe enviar el comprobante antes de poder imprimirlo.';
        Error012: Label 'La factura de compra %1 no tiene retenciones.';
        Error013: Label 'La nota de crédito de compra %1 no tiene retenciones.';
        Error014: Label 'El documento %1 %2 ya ha sido enviado y autorizado por el SRI.';
        Error015: Label 'El documento %1 %2 fue autorizado por el SRI.\\ Fecha/Hora: %3\ Nº autorización: %4';
        Error016: Label 'El documento %1 %2 ya ha sido enviado al SRI. Debe comprobar la autorización.';
        Error017: Label 'El tipo de comprobante del documento %1 debe ser %2';
        Error018: Label '01 (Factura)';
        Error019: Label '06 (Remisión)';
        Error020: Label '04 (Nota de crédito)';
        Error021: Label '07 (Comprobante de retención)';
        Error022: Label 'La serie NCF %1 utilizada en el documento %2 no es de facturación electrónica.';
        Error023: Label 'El nº de comprobante fiscal del documento %1 es incorrecto.';
        Error024: Label 'La retención del documento %1 no tiene Nº de comprobante fiscal';
        Error025: Label 'El campo "%1" del transportista %2 no puede estar en blanco.';
        Error026: Label 'El usuario %1 no tiene permisos para acceder a la ruta %2';
        Error027: Label 'No hay claves de contingencia disponibles para ambiente %1';
        Error028: Label 'Debe informar la dirección del establecimiento %1 en tabla parametros SRI.';
        Error029: Label 'La emisión en contingencia no esta permitida en esquema off-line';
        ElementoEstado: Label 'estado';
        ElementoMensaje: Label 'mensaje';
        ElementoInfo: Label 'informacionAdicional';
        texValor: Text[1024];
        CurrentElementName: Text[1024];
        texURLRecepcion: Text[1024];
        texURLAutorizacion: Text[1024];
        iNodo: Integer;
        ElementoNoAuto: Label 'numeroAutorizacion';
        ElementoFechaAuto: Label 'fechaAutorizacion';
        _recFac: Record "Sales Invoice Header";
        _recAbono: Record "Sales Cr.Memo Header";
        _recEnvioTrans: Record "Transfer Shipment Header";
        _recFacCmp: Record "Purch. Inv. Header";
        wEliminado: Boolean;
        wNodoEliminado: Boolean;


    procedure EnviarFactura(recPrmDoc: Record "Sales Invoice Header"; blnPrmManual: Boolean): Boolean
    begin

        blnManual := blnPrmManual;
        optTipoDoc := optTipoDoc::Factura;

        ControlEstado(recPrmDoc."No.");
        ComprobarCfgFE(optTipoDoc);

        GenerarDatosTempFactura(recPrmDoc);
        Commit;

        if TESTConexionWS then
            ExportarDocumentoFE(recPrmDoc."No.")
        else begin
            GuardarLOG(recPrmDoc."No.", '', optEstado::Error, Error001, '');
            Error(Error001);
        end;
    end;


    procedure EnviarNotaCredito(recPrmDoc: Record "Sales Cr.Memo Header"; blnPrmManual: Boolean)
    var
        texFicheroXML: Text[255];
        texRespuesta: Text[1024];
        texInfo: Text[1024];
    begin

        blnManual := blnPrmManual;
        optTipoDoc := optTipoDoc::NotaCredito;

        ControlEstado(recPrmDoc."No.");
        ComprobarCfgFE(optTipoDoc);

        GenerarDatosTempNotaCredito(recPrmDoc);
        Commit;
        if TESTConexionWS then
            ExportarDocumentoFE(recPrmDoc."No.")
        else begin
            GuardarLOG(recPrmDoc."No.", '', optEstado::Error, Error001, '');
            Error(Error001)
        end;
    end;


    procedure EnviarRemisionVenta(recPrmDoc: Record "Sales Shipment Header"; blnPrmManual: Boolean)
    var
        texFicheroXML: Text[250];
        texRespuesta: Text[1024];
        texInfo: Text[1024];
    begin

        blnManual := blnPrmManual;
        optTipoDoc := optTipoDoc::Remision;

        ControlEstado(recPrmDoc."No.");
        ComprobarCfgFE(optTipoDoc);

        GenerarDatosTempRemisionVenta(recPrmDoc);
        if TESTConexionWS then
            ExportarDocumentoFE(recPrmDoc."No.")
        else begin
            GuardarLOG(recPrmDoc."No.", '', optEstado::Error, Error001, '');
            Error(Error001)
        end;
    end;


    procedure EnviarRemisionTrans(recPrmDoc: Record "Transfer Shipment Header"; blnPrmManual: Boolean)
    var
        texFicheroXML: Text[250];
        texRespuesta: Text[1024];
        texInfo: Text[1024];
    begin

        blnManual := blnPrmManual;
        optTipoDoc := optTipoDoc::Remision;

        ControlEstado(recPrmDoc."No.");
        ComprobarCfgFE(optTipoDoc);

        GenerarDatosTempRemisionTrans(recPrmDoc);
        Commit;
        if TESTConexionWS then
            ExportarDocumentoFE(recPrmDoc."No.")
        else begin
            GuardarLOG(recPrmDoc."No.", '', optEstado::Error, Error001, '');
            Error(Error001)
        end;
    end;


    procedure EnviarComprobanteRetencionFac(recPrmDoc: Record "Purch. Inv. Header"; blnPrmManual: Boolean)
    var
        texFicheroXML: Text[250];
        texRespuesta: Text[30];
        texInfo: Text[250];
    begin

        blnManual := blnPrmManual;
        optTipoDoc := optTipoDoc::Retencion;

        ControlEstado(recPrmDoc."No.");
        ComprobarCfgFE(optTipoDoc);

        GenerarDatosTempRetencionFac(recPrmDoc);
        Commit;
        if TESTConexionWS then
            ExportarDocumentoFE(recPrmDoc."No.")
        else begin
            GuardarLOG(recPrmDoc."No.", '', optEstado::Error, Error001, '');
            Error(Error001)
        end;
    end;


    procedure EnviarComprobanteRetencionNC(recPrmDoc: Record "Purch. Cr. Memo Hdr."; blnPrmManual: Boolean)
    var
        texFicheroXML: Text[250];
        texRespuesta: Text[30];
        texInfo: Text[250];
    begin

        blnManual := blnPrmManual;
        optTipoDoc := optTipoDoc::Retencion;

        ControlEstado(recPrmDoc."No.");
        ComprobarCfgFE(optTipoDoc);

        GenerarDatosTempRetencionNC(recPrmDoc);
        Commit;
        if TESTConexionWS then
            ExportarDocumentoFE(recPrmDoc."No.")
        else begin
            GuardarLOG(recPrmDoc."No.", '', optEstado::Error, Error001, '');
            Error(Error001)
        end;
    end;


    procedure ExportarDocumentoFE(codPrmDoc: Code[20])
    var
        texFicheroXML: Text[250];
        texRespuesta: Text[1024];
        texInfo: Text[1024];
    begin

        if GenerarXML(codPrmDoc, texFicheroXML) then begin
            if FirmarXML(codPrmDoc, texFicheroXML) then begin
                if EnviarXML(codPrmDoc, texFicheroXML, texRespuesta, texInfo) then
                    MostrarAviso(StrSubstNo(Text003, optTipoDoc, codPrmDoc))
                else
                    MostrarError(StrSubstNo(Error005, optTipoDoc, codPrmDoc, texRespuesta, texInfo));
            end else
                MostrarError(StrSubstNo(Error003, texFicheroXML));
        end else
            MostrarError(StrSubstNo(Error006, optTipoDoc, codPrmDoc));
    end;


    procedure GenerarDatosTempFactura(var recPrmFac: Record "Sales Invoice Header")
    var
        recCfgEmpresa: Record "Company Information";
        recAlmacen: Record Location;
        recLinFac: Record "Sales Invoice Line";
        recTmpDoc: Record "Documento FE";
        recTmpTotImp: Record "Total Impuestos FE";
        recTmpDet: Record "Detalle FE";
        recTmpImp: Record "Impuestos FE";
        recTmpRet: Record "Retenciones FE";
        recTempVATAmountLine: Record "VAT Amount Line" temporary;
        recProducto: Record Item;
        recCliente: Record Customer;
        recTipoComp: Record "SRI - Tabla Parametros";
        recSerie: Record "No. Series";
    begin

        recCfgEmpresa.Get;
        recCfgEmpresa.TestField("VAT Registration No.");

        with recPrmFac do begin

            if recTmpDoc.Get("No.") then
                recTmpDoc.Delete(true);

            recSerie.Get("No. Serie NCF Facturas");
            if not recSerie."Facturacion electronica" then
                Error(Error022, "No. Serie NCF Facturas", "No.");

            if "Tipo de Comprobante" <> '01' then
                Error(Error017, "No.", Error018);

            if StrLen("No. Comprobante Fiscal") > 9 then
                Error(Error023, "No.");

            recCliente.Get("Bill-to Customer No.");

            if "Location Code" <> '' then begin
                recAlmacen.Get("Location Code");
                recAlmacen.TestField(Address);
            end;

            CalcFields(Amount, "Amount Including VAT");
            recTmpDoc.Init;
            recTmpDoc."No. documento" := "No.";
            recTmpDoc."Tipo comprobante" := "Tipo de Comprobante";
            recTmpDoc."Fecha emision" := "Document Date";
            recTmpDoc."Contribuyente especial" := recCfgEmpresa."Cod. contribuyente especial";
            recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";
            recTmpDoc."Obligado contabilidad" := 'SI';

            recTmpDoc."Tipo id." := '04';
            if "VAT Registration No." = '9999999999999' then
                recTmpDoc."Tipo id." := '07'
            else
                recTmpDoc."Tipo id." := TraerTipoIdCliente("Bill-to Customer No.");

            recTmpDoc."Guia remision" := TraerGuiaRemision("Order No.");
            recTmpDoc."Razon social" := "Bill-to Name";
            recTmpDoc."Id. comprador" := "VAT Registration No.";
            recTmpDoc."Total sin impuestos" := Amount;
            recTmpDoc."Total descuento" := CalcularDescuentoFactura(recPrmFac);
            recTmpDoc.Propina := 0;
            recTmpDoc."Importe total" := "Amount Including VAT";
            recTmpDoc.Moneda := 'DOLAR';
            recTmpDoc.Establecimiento := PADSTR2("Establecimiento Factura", 3, '0');
            recTmpDoc."Dir. establecimiento" := TraerDireccionEstablecimiento(recTmpDoc.Establecimiento);
            recTmpDoc."Punto de emision" := PADSTR2("Punto de Emision Factura", 3, '0');
            recTmpDoc.Secuencial := PADSTR2("No. Comprobante Fiscal", 9, '0');
            recTmpDoc.Ambiente := recCfgFE.Ambiente;
            recTmpDoc.Clave := GenerarClave(recTmpDoc);
            recTmpDoc."No. autorizacion" := recTmpDoc.Clave;                            //#35982
            recTmpDoc."Tipo documento" := optTipoDoc;
            recTmpDoc."Adicional - Direccion" := EliminarCaracteresRaros("Bill-to Address");      //#54139
            recTmpDoc."Adicional - Telefono" := EliminarCaracteresRaros(recCliente."Phone No."); //#54139
            recTmpDoc."Adicional - Email" := EliminarCaracteresRaros(recCliente."E-Mail");    //#54139
            recTmpDoc."Adicional - Pedido" := "Order No.";
            recTmpDoc.Insert;

            recLinFac.CalcVATAmountLines(recPrmFac, recTempVATAmountLine);

            recTempVATAmountLine.Reset;
            if recTempVATAmountLine.FindSet then begin
                repeat

                    recTmpTotImp.Init;
                    recTmpTotImp."No. documento" := "No.";
                    recTmpTotImp.Codigo := '2'; //IVA
                    case recTempVATAmountLine."VAT %" of
                        0:
                            recTmpTotImp."Codigo Porcentaje" := '0';
                        12:
                            recTmpTotImp."Codigo Porcentaje" := '2';
                        14:
                            recTmpTotImp."Codigo Porcentaje" := '3'; // #53606
                    end;
                    recTmpTotImp."Base Imponible" := recTempVATAmountLine."VAT Base";
                    recTmpTotImp.Tarifa := recTempVATAmountLine."VAT %";
                    recTmpTotImp.Valor := recTempVATAmountLine."VAT Amount";

                    //#37297
                    if recTmpTotImp.Get(recTmpTotImp."No. documento", recTmpTotImp.Codigo, recTmpTotImp."Codigo Porcentaje") then begin
                        recTmpTotImp."Base Imponible" += recTempVATAmountLine."VAT Base";
                        recTmpTotImp.Valor += recTempVATAmountLine."VAT Amount";
                        recTmpTotImp.Modify;
                    end
                    else
                        //#37297
                        recTmpTotImp.Insert;


                until recTempVATAmountLine.Next = 0;
            end
            else begin
                recTmpTotImp.Init;
                recTmpTotImp."No. documento" := "No.";
                recTmpTotImp.Codigo := '2'; //IVA
                recTmpTotImp."Codigo Porcentaje" := '0';
                recTmpTotImp."Base Imponible" := 0;
                recTmpTotImp.Tarifa := 0;
                recTmpTotImp.Valor := 0;
                recTmpTotImp.Insert;
            end;

            recLinFac.Reset;
            recLinFac.SetRange("Document No.", "No.");
            recLinFac.SetFilter(Type, '<>%1', recLinFac.Type::" ");
            recLinFac.SetFilter(Quantity, '<>%1', 0);
            if recLinFac.FindSet then
                repeat

                    recTmpDet.Init;
                    recTmpDet."No. documento" := recLinFac."Document No.";
                    recTmpDet."No. linea" := recLinFac."Line No.";
                    recTmpDet."Codigo Principal" := recLinFac."No.";
                    if recLinFac.Type = recLinFac.Type::Item then
                        recTmpDet."Codigo Auxiliar" := TraerISBN(recLinFac."No.");
                    recTmpDet.Descripcion := recLinFac.Description;
                    recTmpDet.Cantidad := recLinFac.Quantity;
                    recTmpDet."Precio Unitario" := recLinFac."Unit Price"; // #57011
                    recTmpDet.Descuento := recLinFac."Line Discount Amount";
                    recTmpDet."Precio Total Sin Impuesto" := recLinFac.Amount;
                    recTmpDet."Detalle adicional 2" := Text009 + ' ' + Format(recLinFac."Line Discount %", 0, '<Standard Format,9>');
                    recTmpDet.Insert;

                    recTmpImp.Init;
                    recTmpImp."No. documento" := recLinFac."Document No.";
                    recTmpImp."No. linea" := recLinFac."Line No.";
                    recTmpImp.Codigo := '2'; //IVA
                    case recLinFac."VAT %" of
                        0:
                            recTmpImp."Codigo Porcentaje" := '0';
                        12:
                            recTmpImp."Codigo Porcentaje" := '2';
                        14:
                            recTmpImp."Codigo Porcentaje" := '3'; // #53606
                    end;
                    recTmpImp."Base Imponible" := recLinFac."VAT Base Amount";
                    recTmpImp.Tarifa := recLinFac."VAT %";
                    recTmpImp.Valor := recLinFac."Amount Including VAT" - recLinFac.Amount;
                    recTmpImp.Subtotal := recLinFac.Quantity * recLinFac."Unit Price";           //Informativo para la impresión    // #57011
                    recTmpImp.Insert;

                until recLinFac.Next = 0;

        end;
    end;


    procedure GenerarDatosTempNotaCredito(recPrmNC: Record "Sales Cr.Memo Header")
    var
        recCfgEmpresa: Record "Company Information";
        recAlmacen: Record Location;
        recLinNC: Record "Sales Cr.Memo Line";
        recTmpDoc: Record "Documento FE";
        recTmpTotImp: Record "Total Impuestos FE";
        recTmpDet: Record "Detalle FE";
        recTmpImp: Record "Impuestos FE";
        recTmpRet: Record "Retenciones FE";
        recTempVATAmountLine: Record "VAT Amount Line" temporary;
        recSerie: Record "No. Series";
        recCliente: Record Customer;
    begin

        recCfgEmpresa.Get;
        recCfgEmpresa.TestField("VAT Registration No.");


        with recPrmNC do begin

            if recTmpDoc.Get("No.") then
                recTmpDoc.Delete(true);

            recSerie.Get("No. Serie NCF Abonos");
            if not recSerie."Facturacion electronica" then
                Error(Error022, "No. Serie NCF Abonos", "No.");

            if "Tipo de Comprobante" <> '04' then
                Error(Error017, "No.", Error020);

            TestField("Establecimiento Factura");
            TestField("Punto de Emision Factura");
            TestField("No. Comprobante Fiscal Rel.");

            recCliente.Get("Bill-to Customer No.");

            if "Location Code" <> '' then begin
                recAlmacen.Get("Location Code");
                recAlmacen.TestField(Address);
            end;

            CalcFields(Amount, "Amount Including VAT");
            recTmpDoc.Init;

            recTmpDoc."No. documento" := "No.";
            recTmpDoc."Tipo comprobante" := "Tipo de Comprobante";
            recTmpDoc."Fecha emision" := "Document Date";
            recTmpDoc."Contribuyente especial" := recCfgEmpresa."Cod. contribuyente especial";
            recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";
            recTmpDoc."Obligado contabilidad" := 'SI';

            recTmpDoc."Tipo id." := '04';
            if "VAT Registration No." = '9999999999999' then
                recTmpDoc."Tipo id." := '07'
            else
                recTmpDoc."Tipo id." := TraerTipoIdCliente("Bill-to Customer No.");

            recTmpDoc."Razon social" := "Bill-to Name";
            recTmpDoc."Id. comprador" := "VAT Registration No.";
            recTmpDoc."Cod. doc. modificado" := '01'; //Factura
            recTmpDoc."Num. doc. modificado" := PADSTR2("Establecimiento Fact. Rel", 3, '0') + '-' +
                                                  PADSTR2("Punto de Emision Fact. Rel.", 3, '0') + '-' +
                                                  PADSTR2("No. Comprobante Fiscal Rel.", 9, '0');
            recTmpDoc."Valor modificacion" := "Amount Including VAT";
            recTmpDoc."Fecha emisión doc. sustento" := TraerFechaEmisionFactura("No.",
                                                                                "Establecimiento Fact. Rel",
                                                                                "Punto de Emision Fact. Rel.",
                                                                                "No. Comprobante Fiscal Rel.");

            recTmpDoc."Total sin impuestos" := Amount;
            recTmpDoc."Total descuento" := CalcularDescuentoNC(recPrmNC);
            recTmpDoc."Importe total" := "Amount Including VAT";
            recTmpDoc.Moneda := 'DOLAR';
            recTmpDoc.Establecimiento := PADSTR2("Establecimiento Factura", 3, '0');
            recTmpDoc."Dir. establecimiento" := TraerDireccionEstablecimiento(recTmpDoc.Establecimiento);
            recTmpDoc."Punto de emision" := PADSTR2("Punto de Emision Factura", 3, '0');
            recTmpDoc.Secuencial := PADSTR2("No. Comprobante Fiscal", 9, '0');
            recTmpDoc.Motivo := Text005;
            recTmpDoc.Ambiente := recCfgFE.Ambiente;
            recTmpDoc.Clave := GenerarClave(recTmpDoc);
            recTmpDoc."No. autorizacion" := recTmpDoc.Clave;                            //#35982
            recTmpDoc."Tipo documento" := optTipoDoc;
            recTmpDoc."Adicional - Direccion" := EliminarCaracteresRaros("Bill-to Address");       //#54139
            recTmpDoc."Adicional - Telefono" := EliminarCaracteresRaros(recCliente."Phone No.");  //#54139
            recTmpDoc."Adicional - Email" := EliminarCaracteresRaros(recCliente."E-Mail");     //#54139
            recTmpDoc.Insert;

            recLinNC.CalcVATAmountLines(recPrmNC, recTempVATAmountLine);

            recTempVATAmountLine.Reset;
            if recTempVATAmountLine.FindSet then begin
                repeat
                    recTmpTotImp.Init;
                    recTmpTotImp."No. documento" := "No.";
                    recTmpTotImp.Codigo := '2'; //IVA
                    case recTempVATAmountLine."VAT %" of
                        0:
                            recTmpTotImp."Codigo Porcentaje" := '0';
                        12:
                            recTmpTotImp."Codigo Porcentaje" := '2';
                        14:
                            recTmpTotImp."Codigo Porcentaje" := '3'; // #53606
                    end;
                    recTmpTotImp.Tarifa := recTempVATAmountLine."VAT %";
                    recTmpTotImp."Base Imponible" := recTempVATAmountLine."VAT Base";
                    recTmpTotImp.Valor := recTempVATAmountLine."VAT Amount";

                    //#37297
                    if recTmpTotImp.Get(recTmpTotImp."No. documento", recTmpTotImp.Codigo, recTmpTotImp."Codigo Porcentaje") then begin
                        recTmpTotImp."Base Imponible" += recTempVATAmountLine."VAT Base";
                        recTmpTotImp.Valor += recTempVATAmountLine."VAT Amount";
                        recTmpTotImp.Modify;
                    end
                    else
                        //#37297
                        recTmpTotImp.Insert;


                until recTempVATAmountLine.Next = 0;
            end
            else begin
                recTmpTotImp.Init;
                recTmpTotImp."No. documento" := "No.";
                recTmpTotImp.Codigo := '2'; //IVA
                recTmpTotImp."Codigo Porcentaje" := '0';
                recTmpTotImp."Base Imponible" := 0;
                recTmpTotImp.Tarifa := 0;
                recTmpTotImp.Valor := 0;
                recTmpTotImp.Insert;
            end;

            recLinNC.Reset;
            recLinNC.SetRange("Document No.", "No.");
            recLinNC.SetFilter(Type, '<>%1', recLinNC.Type::" ");
            recLinNC.SetFilter(Quantity, '<>%1', 0);
            if recLinNC.FindSet then
                repeat

                    recTmpDet.Init;
                    recTmpDet."No. documento" := recLinNC."Document No.";
                    recTmpDet."No. linea" := recLinNC."Line No.";
                    recTmpDet."Codigo Principal" := recLinNC."No.";
                    if recLinNC.Type = recLinNC.Type::Item then
                        recTmpDet."Codigo Auxiliar" := TraerISBN(recLinNC."No.");
                    recTmpDet.Descripcion := recLinNC.Description;
                    recTmpDet.Cantidad := recLinNC.Quantity;
                    recTmpDet."Precio Unitario" := recLinNC."Unit Price";   // #57011
                    recTmpDet.Descuento := recLinNC."Line Discount Amount";
                    recTmpDet."Precio Total Sin Impuesto" := recLinNC.Amount;
                    recTmpDet."Detalle adicional 2" := Text009 + ' ' + Format(recLinNC."Line Discount %", 0, '<Standard Format,9>');
                    recTmpDet.Insert;

                    recTmpImp.Init;
                    recTmpImp."No. documento" := recLinNC."Document No.";
                    recTmpImp."No. linea" := recLinNC."Line No.";
                    recTmpImp.Codigo := '2'; //IVA
                    case recLinNC."VAT %" of
                        0:
                            recTmpImp."Codigo Porcentaje" := '0';
                        12:
                            recTmpImp."Codigo Porcentaje" := '2';
                        14:
                            recTmpImp."Codigo Porcentaje" := '3'; // #53606
                    end;
                    recTmpImp."Base Imponible" := recLinNC."VAT Base Amount";
                    recTmpImp.Tarifa := recLinNC."VAT %";
                    recTmpImp.Valor := recLinNC."Amount Including VAT" - recLinNC.Amount;
                    recTmpImp.Subtotal := recLinNC.Quantity * recLinNC."Unit Price";           //Informativo para la impresión     // #57011
                    recTmpImp.Insert;

                until recLinNC.Next = 0;

        end;
    end;


    procedure GenerarDatosTempRemisionVenta(recPrmRem: Record "Sales Shipment Header")
    var
        recCfgEmpresa: Record "Company Information";
        recLinRem: Record "Sales Shipment Line";
        recTmpDoc: Record "Documento FE";
        recTmpDet: Record "Detalle FE";
        recAlmacen: Record Location;
        recTransportista: Record "Shipping Agent";
        recFac: Record "Sales Invoice Header";
        recSerie: Record "No. Series";
        recCliente: Record Customer;
    begin

        recCfgEmpresa.Get;
        recCfgEmpresa.TestField("VAT Registration No.");

        with recPrmRem do begin

            if recTmpDoc.Get("No.") then
                recTmpDoc.Delete(true);

            recSerie.Get("No. Serie NCF Remision");
            if not recSerie."Facturacion electronica" then
                Error(Error022, "No. Serie NCF Remision", "No.");

            if "Tipo Comprobante Remision" <> '06' then
                Error(Error017, "No.", Error019);

            TestField("Location Code");
            TestField("Shipping Agent Code");

            recCliente.Get("Bill-to Customer No.");

            if "Location Code" <> '' then begin
                recAlmacen.Get("Location Code");
                recAlmacen.TestField(Address);
            end;

            recTransportista.Get("Shipping Agent Code");
            if recTransportista.Name = '' then
                Error(Error025, recTransportista.FieldCaption(Name), recTransportista.Code);
            if recTransportista."Tipo id." = recTransportista."Tipo id."::" " then
                Error(Error025, recTransportista.FieldCaption("Tipo id."), recTransportista.Code);
            if recTransportista."VAT Registration No." = '' then
                Error(Error025, recTransportista.FieldCaption("VAT Registration No."), recTransportista.Code);
            if recTransportista.Placa = '' then
                Error(Error025, recTransportista.FieldCaption(Placa), recTransportista.Code);


            recTmpDoc.Init;
            recTmpDoc."No. documento" := "No.";
            recTmpDoc."Tipo comprobante" := "Tipo Comprobante Remision";
            recTmpDoc.Establecimiento := PADSTR2("Establecimiento Remision", 3, '0');
            recTmpDoc."Dir. establecimiento" := TraerDireccionEstablecimiento(recTmpDoc.Establecimiento);
            recTmpDoc."Punto de emision" := PADSTR2("Punto de Emision Remision", 3, '0');
            recTmpDoc.Secuencial := PADSTR2("No. Comprobante Fisc. Remision", 9, '0');
            recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";
            recTmpDoc."Fecha emision" := "Document Date";
            recTmpDoc."Dir. partida" := EliminarCaracteresRaros(recAlmacen.Address);      //#54139
            recTmpDoc."Nombre transportista" := recTransportista.Name;
            case recTransportista."Tipo id." of
                recTransportista."Tipo id."::RUC:
                    recTmpDoc."Tipo id. trans." := '04';
                recTransportista."Tipo id."::Cedula:
                    recTmpDoc."Tipo id. trans." := '05';
                recTransportista."Tipo id."::Pasaporte:
                    recTmpDoc."Tipo id. trans." := '06';
            end;
            recTmpDoc."RUC transportista" := recTransportista."VAT Registration No.";
            recTmpDoc.Rise := '';
            recTmpDoc."Obligado contabilidad" := '';
            recTmpDoc."Contribuyente especial" := recCfgEmpresa."Cod. contribuyente especial";
            recTmpDoc."Fecha ini. transporte" := "Fecha inicio trans.";
            recTmpDoc."Fecha fin transporte" := "Fecha fin trans.";
            recTmpDoc.Placa := recTransportista.Placa;

            //Datos del destinatario. En lugar de utilizar una tabla los he añadido a la tabla de documento FE
            //porque en Navision solo puede haber un destinatario por remisiÊn.

            recTmpDoc."Id. destinatario" := "VAT Registration No.";
            recTmpDoc."Razon social destinatario" := "Ship-to Name";
            recTmpDoc."Direccion destinatario" := EliminarCaracteresRaros("Ship-to Address");      //#54139

            recTmpDoc."Doc. aduanero unico" := '';
            recTmpDoc."Cod. etablecimiento destino" := '';
            recTmpDoc.Ruta := recAlmacen.City + ' - ' + "Ship-to City";

            //Si se encuentra la factura asociada se informan estos campos:

            recFac.Reset;
            recFac.SetCurrentKey("Order No.");
            recFac.SetRange("Order No.", recPrmRem."Order No.");
            if recFac.FindFirst then begin
                recTmpDoc."Cod. doc. sustento" := '01'; //Factura
                recTmpDoc."Num. doc. sustento" := PADSTR2(recFac."Establecimiento Factura", 3, '0') + '-' +
                                                  PADSTR2(recFac."Punto de Emision Factura", 3, '0') + '-' +
                                                  PADSTR2(recFac."No. Comprobante Fiscal", 9, '0');
                recTmpDoc."Num. aut. doc. sustento" := recFac."No. Autorizacion Comprobante";
                recTmpDoc."Fecha emisión doc. sustento" := recFac."Document Date";
            end;

            recTmpDoc.Motivo := Text001;
            recTmpDoc.Ambiente := recCfgFE.Ambiente;
            recTmpDoc.Clave := GenerarClave(recTmpDoc);
            recTmpDoc."No. autorizacion" := recTmpDoc.Clave;                                  //#35982
            recTmpDoc."Tipo documento" := optTipoDoc;
            recTmpDoc."Subtipo documento" := recTmpDoc."Subtipo documento"::Venta;
            recTmpDoc."Adicional - Direccion" := EliminarCaracteresRaros("Bill-to Address");       //#54139
            recTmpDoc."Adicional - Telefono" := EliminarCaracteresRaros(recCliente."Phone No.");  //#54139
            recTmpDoc."Adicional - Email" := EliminarCaracteresRaros(recCliente."E-Mail");     //#54139
            recTmpDoc."Adicional - Pedido" := "Order No.";
            recTmpDoc.Insert;

            recLinRem.Reset;
            recLinRem.SetRange("Document No.", recPrmRem."No.");
            recLinRem.SetFilter(Type, '<>%1', recLinRem.Type::" ");
            recLinRem.SetFilter(Quantity, '<>%1', 0);
            if recLinRem.FindSet then
                repeat

                    recTmpDet.Init;
                    recTmpDet."No. documento" := recLinRem."Document No.";
                    recTmpDet."No. linea" := recLinRem."Line No.";

                    recTmpDet."Codigo Principal" := recLinRem."No.";
                    if recLinRem.Type = recLinRem.Type::Item then
                        recTmpDet."Codigo Auxiliar" := TraerISBN(recLinRem."No.");
                    recTmpDet.Descripcion := recLinRem.Description;
                    recTmpDet.Cantidad := recLinRem.Quantity;
                    recTmpDet.Insert;

                until recLinRem.Next = 0;

        end;
    end;


    procedure GenerarDatosTempRemisionTrans(recPrmRem: Record "Transfer Shipment Header")
    var
        recCfgEmpresa: Record "Company Information";
        recLinRem: Record "Transfer Shipment Line";
        recTmpDoc: Record "Documento FE";
        recTmpDet: Record "Detalle FE";
        recTransportista: Record "Shipping Agent";
        recFac: Record "Sales Invoice Header";
        recSerie: Record "No. Series";
        recAlmacen: Record Location;
    begin

        recCfgEmpresa.Get;
        recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";


        with recPrmRem do begin

            if recTmpDoc.Get("No.") then
                recTmpDoc.Delete(true);

            TestField("Transfer-from Code");
            TestField("Shipping Agent Code");

            recAlmacen.Get("Transfer-to Code");

            recTransportista.Get("Shipping Agent Code");
            if recTransportista.Name = '' then
                Error(Error025, recTransportista.FieldCaption(Name), recTransportista.Code);
            if recTransportista."Tipo id." = recTransportista."Tipo id."::" " then
                Error(Error025, recTransportista.FieldCaption("Tipo id."), recTransportista.Code);
            if recTransportista."VAT Registration No." = '' then
                Error(Error025, recTransportista.FieldCaption("VAT Registration No."), recTransportista.Code);
            if recTransportista.Placa = '' then
                Error(Error025, recTransportista.FieldCaption(Placa), recTransportista.Code);

            recTmpDoc.Init;
            recTmpDoc."No. documento" := "No.";
            recTmpDoc."Tipo comprobante" := '06';
            recTmpDoc.Establecimiento := PADSTR2("Establecimiento Remision", 3, '0');
            recTmpDoc."Dir. establecimiento" := TraerDireccionEstablecimiento(recTmpDoc.Establecimiento);
            recTmpDoc."Punto de emision" := PADSTR2("Punto de Emision Remision", 3, '0');
            recTmpDoc.Secuencial := PADSTR2("No. Comprobante Fiscal", 9, '0');
            recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";
            recTmpDoc."Fecha emision" := "Transfer Order Date";

            recTmpDoc."Dir. partida" := EliminarCaracteresRaros(recPrmRem."Transfer-from Address");      //#54139

            recTmpDoc."Nombre transportista" := recTransportista.Name;
            case recTransportista."Tipo id." of
                recTransportista."Tipo id."::RUC:
                    recTmpDoc."Tipo id. trans." := '04';
                recTransportista."Tipo id."::Cedula:
                    recTmpDoc."Tipo id. trans." := '05';
                recTransportista."Tipo id."::Pasaporte:
                    recTmpDoc."Tipo id. trans." := '06';
            end;
            recTmpDoc."RUC transportista" := recTransportista."VAT Registration No.";
            recTmpDoc.Placa := recTransportista.Placa;

            recTmpDoc.Rise := '';
            recTmpDoc."Obligado contabilidad" := '';
            recTmpDoc."Contribuyente especial" := recCfgEmpresa."Cod. contribuyente especial";
            recTmpDoc."Fecha ini. transporte" := "Shipment Date";
            recTmpDoc."Fecha fin transporte" := "Receipt Date";


            //Datos del destinatario. En lugar de utilizar una tabla los he añadido a la tabla de documento FE
            //porque en Navision solo puede haber un destinatario por remisiÊn.

            recTmpDoc."Id. destinatario" := recCfgEmpresa."VAT Registration No.";
            //  recTmpDoc."Razon social destinatario"   := "Transfer-to Name";
            recTmpDoc."Razon social destinatario" := recCfgEmpresa.Name;
            recTmpDoc."Direccion destinatario" := EliminarCaracteresRaros("Transfer-to Address");      //#54139
            recTmpDoc."Doc. aduanero unico" := '';
            recTmpDoc."Cod. etablecimiento destino" := '';
            recTmpDoc.Ruta := recPrmRem."Transfer-from City" + ' - ' + recPrmRem."Transfer-to City";
            recTmpDoc.Motivo := Text002;
            recTmpDoc.Ambiente := recCfgFE.Ambiente;
            recTmpDoc.Clave := GenerarClave(recTmpDoc);
            recTmpDoc."No. autorizacion" := recTmpDoc.Clave;                                //#35982
            recTmpDoc."Subtipo documento" := recTmpDoc."Subtipo documento"::Transferencia;
            recTmpDoc."Tipo documento" := optTipoDoc;
            recTmpDoc."Adicional - Direccion" := EliminarCaracteresRaros(recAlmacen.Address);     //#54139
            recTmpDoc."Adicional - Telefono" := EliminarCaracteresRaros(recAlmacen."Phone No."); //#54139
            recTmpDoc."Adicional - Email" := EliminarCaracteresRaros(recAlmacen."E-Mail");    //#54139
            recTmpDoc."Adicional - Pedido" := "Transfer Order No.";
            recTmpDoc.Insert;

            recLinRem.Reset;
            recLinRem.SetRange("Document No.", recPrmRem."No.");
            recLinRem.SetFilter(Quantity, '<>%1', 0);
            if recLinRem.FindSet then
                repeat

                    recTmpDet.Init;
                    recTmpDet."No. documento" := recLinRem."Document No.";
                    recTmpDet."No. linea" := recLinRem."Line No.";
                    recTmpDet."Codigo Principal" := recLinRem."Item No.";
                    recTmpDet."Codigo Auxiliar" := TraerISBN(recLinRem."Item No.");
                    recTmpDet.Descripcion := recLinRem.Description;
                    recTmpDet.Cantidad := recLinRem.Quantity;
                    recTmpDet.Insert;

                until recLinRem.Next = 0;

        end;
    end;


    procedure GenerarDatosTempRetencionFac(recPrmFC: Record "Purch. Inv. Header")
    var
        recCfgEmpresa: Record "Company Information";
        recLinRet: Record "Historico Retencion Prov.";
        recTmpDoc: Record "Documento FE";
        recSerie: Record "No. Series";
        recProv: Record Vendor;
    begin

        recCfgEmpresa.Get;
        recCfgEmpresa.TestField("Cod. contribuyente especial");

        with recPrmFC do begin


            if recTmpDoc.Get("No.") then
                recTmpDoc.Delete(true);

            recProv.Get("Buy-from Vendor No.");

            recLinRet.Reset;
            recLinRet.SetFilter("Tipo documento", '%1|%2', recLinRet."Tipo documento"::Order, recLinRet."Tipo documento"::Invoice);
            recLinRet.SetRange("No. documento", "No.");
            if recLinRet.FindSet then begin

                recLinRet.TestField(Establecimiento);
                recLinRet.TestField("Punto Emision");
                recLinRet.TestField(NCF);

                recTmpDoc.Init;
                recTmpDoc."No. documento" := "No.";
                recTmpDoc."Tipo comprobante" := '07';   //Comprobante retención
                recTmpDoc."Fecha emision" := recLinRet."Fecha Registro";
                recTmpDoc."Contribuyente especial" := recCfgEmpresa."Cod. contribuyente especial";
                recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";
                recTmpDoc."Obligado contabilidad" := 'SI';
                recTmpDoc."Tipo documento" := optTipoDoc;

                case recProv."Tipo Documento" of
                    recProv."Tipo Documento"::RUC:
                        case recProv."Tipo Ruc/Cedula" of
                            recProv."Tipo Ruc/Cedula"::"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA":
                                recTmpDoc."Tipo id." := '08'; // #56177  - Modificado en #35029
                            recProv."Tipo Ruc/Cedula"::CEDULA:
                                recTmpDoc."Tipo id." := '05';
                            recProv."Tipo Ruc/Cedula"::PASAPORTE:
                                recTmpDoc."Tipo id." := '06';
                            else
                                recTmpDoc."Tipo id." := '04'; //RUC
                        end;
                    recProv."Tipo Documento"::Cedula:
                        recTmpDoc."Tipo id." := '05';
                    recProv."Tipo Documento"::Pasaporte:
                        recTmpDoc."Tipo id." := '06';
                end;

                recTmpDoc."id. sujeto retenido" := "VAT Registration No.";
                recTmpDoc."Razon social" := "Pay-to Name";
                recTmpDoc.Establecimiento := PADSTR2(recLinRet.Establecimiento, 3, '0');
                recTmpDoc."Dir. establecimiento" := TraerDireccionEstablecimiento(recTmpDoc.Establecimiento);
                recTmpDoc."Punto de emision" := PADSTR2(recLinRet."Punto Emision", 3, '0');
                recTmpDoc.Secuencial := PADSTR2(recLinRet.NCF, 9, '0');
                recTmpDoc."Periodo fiscal" := Format(recLinRet."Fecha Registro", 0, '<Month,2>/<Year4>');
                recTmpDoc."Adicional - Direccion" := EliminarCaracteresRaros("Buy-from Address");  //#54139
                recTmpDoc."Adicional - Telefono" := EliminarCaracteresRaros(recProv."Phone No."); //#54139
                recTmpDoc."Adicional - Email" := EliminarCaracteresRaros(recProv."E-Mail");    //#54139
                recTmpDoc.Ambiente := recCfgFE.Ambiente;
                recTmpDoc.Clave := GenerarClave(recTmpDoc);
                recTmpDoc."No. autorizacion" := recTmpDoc.Clave;                              //#35982
                recTmpDoc.Insert;

                repeat
                    InsertarRetencion(recTmpDoc, recLinRet, "Document Date", Establecimiento, "Punto de Emision", "No. Comprobante Fiscal");
                until recLinRet.Next = 0;
            end
            else
                Error(Error012, "No.");

        end;
    end;


    procedure GenerarDatosTempRetencionNC(recPrmNC: Record "Purch. Cr. Memo Hdr.")
    var
        recCfgEmpresa: Record "Company Information";
        recLinRet: Record "Historico Retencion Prov.";
        recTmpDoc: Record "Documento FE";
        recSerie: Record "No. Series";
        recProv: Record Vendor;
    begin


        recCfgEmpresa.Get;
        recCfgEmpresa.TestField("Cod. contribuyente especial");

        with recPrmNC do begin

            if recTmpDoc.Get("No.") then
                recTmpDoc.Delete(true);

            recProv.Get("Buy-from Vendor No.");

            recLinRet.Reset;
            recLinRet.SetRange("Tipo documento", recLinRet."Tipo documento"::"Credit Memo");
            recLinRet.SetRange("No. documento", "No.");
            if recLinRet.FindSet then begin

                recLinRet.TestField(Establecimiento);
                recLinRet.TestField("Punto Emision");
                recLinRet.TestField(NCF);

                recLinRet.TestField(Establecimiento);
                recLinRet.TestField("Punto Emision");
                recLinRet.TestField(NCF);

                recTmpDoc.Init;
                recTmpDoc."No. documento" := "No.";
                recTmpDoc."Tipo comprobante" := '07';   //Comprobante retención
                recTmpDoc."Fecha emision" := recLinRet."Fecha Registro";
                recTmpDoc."Contribuyente especial" := recCfgEmpresa."Cod. contribuyente especial";
                recTmpDoc.RUC := recCfgEmpresa."VAT Registration No.";
                recTmpDoc."Obligado contabilidad" := 'SI';
                recTmpDoc."Tipo documento" := optTipoDoc;

                case recProv."Tipo Documento" of
                    recProv."Tipo Documento"::RUC:
                        case recProv."Tipo Ruc/Cedula" of
                            //recProv."Tipo Ruc/Cedula"::"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA" : recTmpDoc."Tipo id." := '08'; // #56177
                            recProv."Tipo Ruc/Cedula"::CEDULA:
                                recTmpDoc."Tipo id." := '05';
                            recProv."Tipo Ruc/Cedula"::PASAPORTE:
                                recTmpDoc."Tipo id." := '06';
                            else
                                recTmpDoc."Tipo id." := '04'; //RUC
                        end;
                    recProv."Tipo Documento"::Cedula:
                        recTmpDoc."Tipo id." := '05';
                    recProv."Tipo Documento"::Pasaporte:
                        recTmpDoc."Tipo id." := '06';
                end;

                recTmpDoc."id. sujeto retenido" := "VAT Registration No.";
                recTmpDoc."Razon social" := "Pay-to Name";
                recTmpDoc.Establecimiento := PADSTR2(recLinRet.Establecimiento, 3, '0');
                recTmpDoc."Dir. establecimiento" := TraerDireccionEstablecimiento(recTmpDoc.Establecimiento);
                recTmpDoc."Punto de emision" := PADSTR2(recLinRet."Punto Emision", 3, '0');
                recTmpDoc.Secuencial := PADSTR2(recLinRet.NCF, 9, '0');
                recTmpDoc."Periodo fiscal" := Format(recLinRet."Fecha Registro", 0, '<Month,2>/<Year4>');
                recTmpDoc."Adicional - Direccion" := EliminarCaracteresRaros("Buy-from Address");  //#54139
                recTmpDoc."Adicional - Telefono" := EliminarCaracteresRaros(recProv."Phone No."); //#54139
                recTmpDoc."Adicional - Email" := EliminarCaracteresRaros(recProv."E-Mail");    //#54139
                recTmpDoc.Clave := GenerarClave(recTmpDoc);
                recTmpDoc."No. autorizacion" := recTmpDoc.Clave;                             //#35982
                recTmpDoc.Insert;

                repeat
                    InsertarRetencion(recTmpDoc, recLinRet, "Document Date", Establecimiento, "Punto de Emision", "No. Comprobante Fiscal");
                until recLinRet.Next = 0;
            end
            else
                Error(Error012, "No.");

        end;
    end;


    procedure TraerGuiaRemision(codPrmPedido: Code[20]): Code[20]
    var
        recGuia: Record "Sales Shipment Header";
    begin
        recGuia.Reset;
        recGuia.SetCurrentKey("Order No.");
        recGuia.SetRange("Order No.", codPrmPedido);
        if recGuia.FindFirst then
            if (recGuia."Establecimiento Remision" <> '') and
              (recGuia."Punto de Emision Remision" <> '') and
              (recGuia."No. Comprobante Fisc. Remision" <> '') then
                exit(PADSTR2(recGuia."Establecimiento Remision", 3, '0') + '-' +
                     PADSTR2(recGuia."Punto de Emision Remision", 3, '0') + '-' +
                     PADSTR2(recGuia."No. Comprobante Fisc. Remision", 9, '0'));
    end;


    procedure CalcularDescuentoFactura(recPrmFac: Record "Sales Invoice Header"): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
        InvDiscAmount: Decimal;
        currency: Record Currency;
        decTotalDto: Decimal;
    begin
        with recPrmFac do begin

            //  IF "Currency Code" = '' THEN
            //    currency.InitRoundingPrecision
            //  ELSE
            //    currency.GET("Currency Code");

            //  SalesInvLine.SETRANGE("Document No.","No.");
            //  IF SalesInvLine.FIND('-') THEN
            //    REPEAT
            //      IF "Prices Including VAT" THEN
            //        InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" / (1 + SalesInvLine."VAT %" / 100)
            //      ELSE
            //        InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
            //    UNTIL SalesInvLine.NEXT = 0;
            //  InvDiscAmount := ROUND(InvDiscAmount,currency."Amount Rounding Precision");
            //  EXIT(InvDiscAmount);

            SalesInvLine.Reset;
            SalesInvLine.SetRange("Document No.", "No.");
            if SalesInvLine.FindSet then
                repeat
                    decTotalDto += SalesInvLine."Line Discount Amount";
                until SalesInvLine.Next = 0;

        end;

        exit(decTotalDto);
    end;


    procedure CalcularDescuentoNC(recPrmNC: Record "Sales Cr.Memo Header"): Decimal
    var
        SalesNCLine: Record "Sales Cr.Memo Line";
        InvDiscAmount: Decimal;
        currency: Record Currency;
        decTotalDto: Decimal;
    begin
        with recPrmNC do begin

            SalesNCLine.Reset;
            SalesNCLine.SetRange("Document No.", "No.");
            if SalesNCLine.FindSet then
                repeat
                    decTotalDto += SalesNCLine."Line Discount Amount";
                until SalesNCLine.Next = 0;

        end;

        exit(decTotalDto);
    end;


    procedure PADSTR2(texPrmEntrada: Text[30]; intPrmLongitud: Integer; texPrmCaracter: Text[1]): Text[30]
    begin
        if StrLen(texPrmEntrada) < intPrmLongitud then
            texPrmEntrada := PadStr('', intPrmLongitud - StrLen(texPrmEntrada), texPrmCaracter) + texPrmEntrada;

        exit(texPrmEntrada);
    end;

    local procedure CreateElement(var XMLRequestDoc: XmlDocument; var InElement: XmlElement; InNodeName: Text[50]; InNodeValue: Text[250]; InAttributeName: Text[50]; InAttributeValue: Text[250])
    var
        TempElement: XmlElement;
    begin
        /*TempElement := XMLRequestDoc.createElement(InNodeName);
        TempElement.nodeTypedValue(InNodeValue);
        if InAttributeName <> '' then
            TempElement.setAttribute(InAttributeName, InAttributeValue);
        InElement.appendChild(TempElement);*//*
        TempElement := XmlElement.create(InNodeName);
        TempElement.Add(XmlText.Create(InNodeValue));
        if InAttributeName <> '' then
            TempElement.setAttribute(InAttributeName, InAttributeValue);
        InElement.Add(TempElement);
    end;

    procedure MoverFichero(texPrmOrigen: Text[255]; texPrmDestino: Text[255])
    begin
        if Copy(texPrmOrigen, texPrmDestino) then begin
            while Exists(texPrmOrigen) do begin
                Sleep(100);
                Erase(texPrmOrigen);
            end;
        end;
    end;


    procedure GenerarClave(recPrmDocFE: Record "Documento FE"): Code[49]
    var
        recClaveCon: Record "Claves contingencia";
        codFechaEmision: Code[8];
        codTipo: Code[2];
        codRUC: Code[13];
        codTipoAmbiente: Code[1];
        codSerie: Code[6];
        codSecuencial: Code[9];
        codNumerico: Code[8];
        codTipoEmision: Code[1];
        codDC: Code[1];
        codClave: Code[49];
    begin
        //La clave de acceso se compone de los siguientes campos:

        //  ----------------------------------------------------
        //  | No.  Descripción           Tipo  Long  Formato   |
        //  | ------------------------------------------------ |
        //  |  1  | Fecha de emision    | Num |  8 | ddmmaaaa  |
        //  |  2  | Tipo de comprobante | Num |  2 |           |
        //  |  3  | Nº de RUC           | Num | 13 |           |
        //  |  4  | Tipo de ambiente    | Num |  1 |           |
        //  |  5  | Serie               | Num |  6 |           |
        //  |  6  | Nº secuendial       | Num |  9 |           |
        //  |  7  | Codigo numerico     | Num |  8 |           |
        //  |  8  | Tipo de emision     | Num |  1 |           |
        //  |  9  | Digito de control   | Num |  1 |           |
        //  ----------------------------------------------------


        with recPrmDocFE do begin

            case "Tipo emision" of
                "Tipo emision"::Normal:
                    begin
                        if recPrmDocFE."Tipo comprobante" = '06' then
                            codFechaEmision := Format("Fecha ini. transporte", 0, '<Day,2><Month,2><Year4>')
                        else
                            codFechaEmision := Format("Fecha emision", 0, '<Day,2><Month,2><Year4>');
                        codTipo := "Tipo comprobante";
                        codRUC := RUC;
                        case Ambiente of
                            Ambiente::Pruebas:
                                codTipoAmbiente := '1';
                            Ambiente::Produccion:
                                codTipoAmbiente := '2';
                        end;
                        codSerie := Establecimiento + "Punto de emision";
                        codSecuencial := Secuencial;
                        codNumerico := '12345678';
                        codTipoEmision := '1';
                        codClave := codFechaEmision + codTipo + codRUC + codTipoAmbiente + codSerie + codSecuencial + codNumerico + codTipoEmision;
                    end;
                "Tipo emision"::Contingencia:
                    Error(Error029);
            end;

        end;


        codClave := codClave + Format(CalcularDC(codClave));

        exit(codClave);
    end;


    procedure CalcularDC(texPrmClave: Text[48]): Integer
    var
        intFactores: array[48] of Integer;
        intMultiplicador: Integer;
        intValorNum: Integer;
        intSuma: Integer;
        intModulo: Integer;
        intDC: Integer;
        i: Integer;
    begin
        //Calcula el digito de control en modulo 11

        intMultiplicador := 1;

        for i := StrLen(texPrmClave) downto 1 do begin

            Evaluate(intValorNum, Format(texPrmClave[i]));

            intMultiplicador += 1;

            if intMultiplicador > 7 then
                intMultiplicador := 2;

            intFactores[i] := intValorNum * intMultiplicador;

        end;

        for i := 1 to StrLen(texPrmClave) do
            intSuma += intFactores[i];

        intModulo := intSuma mod 11;

        intDC := 11 - intModulo;

        case intDC of
            10:
                intDC := 1;
            11:
                intDC := 0;
        end;

        exit(intDC);
    end;


    procedure GenerarXML(codPrmDoc: Code[20]; var texPrmFichero: Text[255]): Boolean
    var
        recTmpDoc: Record "Documento FE";
        XMLDOMDocument: XmlDocument;
        XMLNode: XmlNode;
        recTmpBlob: Codeunit "Temp Blob";
        OutStreamObj: OutStream;
        inStreamObj: InStream;
        filSalida: File;
        xmlFacturaFE: XMLport "Factura FE";
        texRutaDestino: Text[255];
        _XMLDOMDocument: XmlDocument;
        _XMLNode: XmlNode;
    begin
        if _GUIALLOWED then begin //+35029
            //if IsClear(XMLDOMDocument) then begin
            if XMLDOMDocument.inn then begin
                Create(XMLDOMDocument, true, true);
                XMLDOMDocument.async := false;
            end;
        end
        //+35029
        else begin
            _XMLDOMDocument := _XMLDOMDocument.XmlDocument;
        end;
        //-35029

        recTmpBlob.Blob.CreateOutStream(OutStreamObj);

        recTmpDoc.Reset;
        recTmpDoc.SetRange("No. documento", codPrmDoc);
        recTmpDoc.FindFirst;
        texPrmFichero := recTmpDoc.Clave + '.XML';
        texRutaDestino := TraerRutaGenerados + texPrmFichero;

        case optTipoDoc of
            optTipoDoc::Factura:
                XMLPORT.Export(XMLPORT::"Factura FE", OutStreamObj, recTmpDoc);
            optTipoDoc::Retencion:
                XMLPORT.Export(XMLPORT::"Comprobante Retencion FE", OutStreamObj, recTmpDoc);
            optTipoDoc::Remision:
                XMLPORT.Export(XMLPORT::"Remision FE", OutStreamObj, recTmpDoc);
            optTipoDoc::NotaCredito:
                XMLPORT.Export(XMLPORT::"Nota Credito FE", OutStreamObj, recTmpDoc);
            optTipoDoc::NotaDebito:
                XMLPORT.Export(XMLPORT::"Nota Debito FE", OutStreamObj, recTmpDoc);
        end;

        //JML No se pueden utilizar streams en Automations en NAV2013R2
        //recTmpBlob.Blob.CREATEINSTREAM(inStreamObj);
        //XMLDOMDocument.Load(inStreamObj);
        recTmpBlob.Blob.Export(texRutaDestino);

        if _GUIALLOWED then begin  //+35029
            if not XMLDOMDocument.load(texRutaDestino) then
                if not XMLDOMDocument.load(texRutaDestino) then
                    Error(Error026, UserId, texRutaDestino);
        end
        //+35029
        else begin
            _XMLDOMDocument.Load(texRutaDestino);
            //recTmpBlob.Blob.CREATEINSTREAM(inStreamObj);
            //_XMLDOMDocument.Load(inStreamObj);
        end;
        //-35029

        if _GUIALLOWED then //+35209
            XMLNode := XMLDOMDocument.documentElement
        //+035029
        else
            _XMLNode := _XMLDOMDocument.DocumentElement;
        //-35029


        if _GUIALLOWED then //+35029
            DeleteEmptyXMLNodes(XMLNode)

        //+35029
        //... Al no poder usa la funcion NextNode() como en Automation, y hacerlo a partir de un array, y como el nodo puede haberse eliminado, hay que hacer
        //... varias pasadas, hasta que no se elimine información.
        //... Existe alguna función para directamente seleccionar los nodos vacios, aunque lo he realizado así.
        else begin
            repeat
                wNodoEliminado := false;
                _DeleteEmptyXMLNodes(_XMLNode);
            until (not wNodoEliminado);
        end;
        //-35029

        if _GUIALLOWED then //+35029
            XMLDOMDocument.save(texRutaDestino)
        //+35029
        else begin
            _XMLDOMDocument.Save(texRutaDestino);
        end;
        //-35029

        //XMLDOMDocument.save('C:\TEMP\EmptyRequest.xml'); //JMB
        //ERROR('error'); //JMB

        GuardarLOG(codPrmDoc, texPrmFichero, optEstado::Generado, '', '');

        exit(true);
    end;


    procedure FirmarXML(codPrmDoc: Code[20]; texPrmFichero: Text[255]): Boolean
    var
        cDotNet: DotNet Process;
        texRutaDestino: Text[255];
        texRutaOrigen: Text[255];
        vRutaCert: Text[255];
        vClaveCert: Text[255];
        vArhivoFirmar: Text[255];
        vArchivoSalida: Text[255];
    begin

        texRutaOrigen := TraerRutaGenerados + texPrmFichero;
        texRutaDestino := TraerRutaFirmados + texPrmFichero;

        //IF EXISTS(texRutaDestino) THEN        //Habilitar para pruebas desde classic
        //  EXIT(TRUE);                         //

        vRutaCert := recCfgFE."Ruta certificado firma";
        vClaveCert := recCfgFE."Contraseña certificado firma";
        vArhivoFirmar := texRutaOrigen;
        vArchivoSalida := texRutaDestino;

        if IsNull(cDotNet) then
            cDotNet := cDotNet.Process;

        cDotNet.StartInfo.FileName := recCfgFE."Ruta Ejecutable Firma";
        cDotNet.StartInfo.Arguments := vRutaCert + ' ' + vClaveCert + ' ' + vArhivoFirmar + ' ' + vArchivoSalida;

        cDotNet.Start();
        cDotNet.WaitForExit();

        if cDotNet.HasExited() then
            if cDotNet.ExitCode <> 0 then
                exit(false);

        Clear(cDotNet);
        Erase(texRutaOrigen);

        Sleep(1000);  //Para evitar el error de la hora de la firma (fecha de firma posterior a la actual)
        GuardarLOG(codPrmDoc, texPrmFichero, optEstado::Firmado, '', '');

        exit(true);
    end;


    procedure EnviarXML(codPrmDoc: Code[20]; texPrmFichero: Text[255]; var texPrmRespuesta: Text[1024]; var texPrmInfo: Text[1024]): Boolean
    var
        texRutaDestino: Text[255];
        texRutaOrigen: Text[255];
        optEstado: Option Enviado,Rechazado,Error;
        optEstadoEnvio: Option Generado,Firmado,Enviado,Rechazado,Autorizado,"No autorizado",Error;
    begin

        texRutaOrigen := TraerRutaFirmados + texPrmFichero;
        texRutaDestino := TraerRutaEnviados + texPrmFichero;

        //+35029
        //RecepcionComprobanteWS(texRutaOrigen, texPrmRespuesta, texPrmInfo, optEstado);
        if _GUIALLOWED then
            RecepcionComprobanteWS(texRutaOrigen, texPrmRespuesta, texPrmInfo, optEstado)
        else
            _RecepcionComprobanteWS(texRutaOrigen, texPrmRespuesta, texPrmInfo, optEstado);
        //-35029

        case optEstado of
            optEstado::Enviado:
                begin
                    ActualizarEstadoDocFE(codPrmDoc, optEstadoEnvio::Enviado, '', '');
                    MoverFichero(texRutaOrigen, texRutaDestino);
                    GuardarLOG(codPrmDoc, texPrmFichero, optEstadoEnvio::Enviado, texPrmRespuesta, texPrmInfo);
                    exit(true);
                end;
            optEstado::Rechazado:
                begin
                    ActualizarEstadoDocFE(codPrmDoc, optEstadoEnvio::Rechazado, '', '');
                    GuardarLOG(codPrmDoc, texPrmFichero, optEstadoEnvio::Rechazado, texPrmRespuesta, texPrmInfo);
                    exit(false);
                end;
            optEstado::Error:
                begin
                    ActualizarEstadoDocFE(codPrmDoc, optEstadoEnvio::Error, '', '');
                    GuardarLOG(codPrmDoc, texPrmFichero, optEstadoEnvio::Error, texPrmRespuesta, texPrmInfo);
                    exit(false);
                end;
        end;
    end;

    local procedure RecepcionComprobanteWS(texPrmFileName: Text[255]; var texPrmRespuesta: Text[1024]; var texPrmInfo: Text[1024]; var optPrmEstado: Option Enviado,Rechazado,Error): Boolean
    var
        cduEnviar: Codeunit "Enviar comprobante electronico";
        [WithEvents]
        WinHTTP: Automation;
        XMLRequestDoc: Automation;
        XMLResponseDoc: Automation;
        XMLProsInstr: Automation;
        XMLElement1: Automation;
        XMLElement2: Automation;
        XMLElement3: Automation;
        XMLNode: Automation;
        ADOStream: Automation;
        XMLNodeList: Automation;
        i: Integer;
        texEstado: Text[1024];
    begin

        if not Exists(texPrmFileName) then
            Error(Error004, texPrmFileName);

        Create(XMLRequestDoc, true, true);

        XMLProsInstr := XMLRequestDoc.createProcessingInstruction('xml', 'version="1.0" encoding="utf-8"');
        XMLRequestDoc.appendChild(XMLProsInstr);
        XMLElement1 := XMLRequestDoc.createElement('soap:Envelope');
        XMLElement1.setAttribute('xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
        XMLElement2 := XMLRequestDoc.createElement('soap:Body');
        XMLElement3 := XMLRequestDoc.createElement('ns2:validarComprobante');
        XMLElement3.setAttribute('xmlns:ns2', 'http://ec.gob.sri.ws.recepcion');

        XMLNode := XMLRequestDoc.createElement('xml');

        XMLNode.dataType := 'bin.base64';
        Create(ADOStream, true, true);
        ADOStream.Type := 1;
        ADOStream.Open;
        ADOStream.LoadFromFile(texPrmFileName);
        XMLNode.nodeTypedValue := ADOStream.Read;
        ADOStream.Close;

        XMLElement3.appendChild(XMLNode);
        XMLElement2.appendChild(XMLElement3);
        XMLElement1.appendChild(XMLElement2);
        XMLRequestDoc.appendChild(XMLElement1);

        //IF UPPERCASE(USERID) = 'DYNASOFT\JESUS' THEN
        //  XMLRequestDoc.save('C:\TEMP\Request.xml');

        if IsClear(WinHTTP) then
            Create(WinHTTP, true, true);

        //fes mig cduEnviar.PasarParam(texURLRecepcion,XMLRequestDoc,WinHTTP);
        if cduEnviar.Run then begin

            if WinHTTP.status = 200 then begin

                Create(XMLResponseDoc, true, true);
                XMLResponseDoc.load(WinHTTP.responseXML);
                XMLResponseDoc.async(false);
                //XMLResponseDoc.save('C:\TEMP\ResponseSRI.xml');
                Clear(texValor);
                XMLNodeList := XMLResponseDoc.childNodes;
                for i := 0 to XMLNodeList.length - 1 do begin
                    XMLNode := XMLNodeList.item(i);
                    ReadChildNodes(XMLNode, ElementoEstado, '');
                end;
                texEstado := texValor;

                case texEstado of
                    'RECIBIDA':
                        begin
                            texPrmRespuesta := texEstado;
                            texPrmInfo := '';
                            optPrmEstado := optPrmEstado::Enviado;
                            exit(true);
                        end;
                    'DEVUELTA':
                        begin

                            Clear(texValor);
                            XMLNodeList := XMLResponseDoc.childNodes;
                            for i := 0 to XMLNodeList.length - 1 do begin
                                XMLNode := XMLNodeList.item(i);
                                ReadChildNodes(XMLNode, ElementoMensaje, '');
                            end;
                            texPrmRespuesta := texValor;

                            Clear(texValor);
                            XMLNodeList := XMLResponseDoc.childNodes;
                            for i := 0 to XMLNodeList.length - 1 do begin
                                XMLNode := XMLNodeList.item(i);
                                ReadChildNodes(XMLNode, ElementoInfo, '');
                            end;
                            texPrmInfo := texValor;
                            optPrmEstado := optPrmEstado::Rechazado;
                            exit(false);
                        end;
                end;

            end
            else begin
                texPrmRespuesta := Error001;
                texPrmInfo := '';
                optPrmEstado := optPrmEstado::Error;
                exit(false);
            end;
        end
        else begin
            texPrmRespuesta := Error001;
            texPrmInfo := '';
            optPrmEstado := optPrmEstado::Error;
            exit(false);
        end;
    end;

    local procedure AutorizacionComprobanteWS(texPrmClave: Text[250]; var texPrmRespuesta: Text[1024]; var texPrmInfo: Text[1024]; var texPrmNoAutorizacion: Text[250]; var texPrmFechaAuto: Text[250]): Boolean
    var
        [WithEvents]
        WinHTTP: Automation;
        XMLRequestDoc: Automation;
        XMLResponseDoc: Automation;
        XMLProsInstr: Automation;
        XMLElement1: Automation;
        XMLElement2: Automation;
        XMLElement3: Automation;
        XMLNode: Automation;
        XMLNodeList: Automation;
        texFileName: Text[255];
        texEstado: Text[30];
        texRutaRespuestaSOAP: Text[1024];
        i: Integer;
        lFile: File;
        lCarpetaLog: Text[250];
    begin

        Create(XMLRequestDoc, true, true);

        XMLProsInstr := XMLRequestDoc.createProcessingInstruction('xml', 'version="1.0" encoding="utf-8"');
        XMLRequestDoc.appendChild(XMLProsInstr);
        XMLElement1 := XMLRequestDoc.createElement('soap:Envelope');
        XMLElement1.setAttribute('xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
        XMLElement2 := XMLRequestDoc.createElement('soap:Body');
        XMLElement3 := XMLRequestDoc.createElement('ns2:autorizacionComprobante');
        XMLElement3.setAttribute('xmlns:ns2', 'http://ec.gob.sri.ws.autorizacion');

        XMLNode := XMLRequestDoc.createElement('claveAccesoComprobante');
        XMLNode.nodeTypedValue(texPrmClave);

        XMLElement3.appendChild(XMLNode);
        XMLElement2.appendChild(XMLElement3);
        XMLElement1.appendChild(XMLElement2);
        XMLRequestDoc.appendChild(XMLElement1);
        //XMLRequestDoc.save('C:\DYNASOFT\SolicitudAutorizacion.xml');

        //+#35029 22.03.18
        /*
        IF texPrmClave <> '' THEN BEGIN
          lCarpetaLog := '\\SECNAVSQL02\ProduccionFE\Dynasoft';
          IF lFile.OPEN(lCarpetaLog+'\log.txt') THEN BEGIN
            XMLRequestDoc.save(lCarpetaLog+'\'+'A'+texPrmClave+'.xml');
            lFile.CLOSE;
          END;
        END;
        *//*
        //-#35029 22.03.18

        Create(WinHTTP, true, true);
        //WinHTTP.open('POST','https://celcer.sri.gob.ec/comprobantes-electronicos-ws/AutorizacionComprobantes?wsdl',0);
        WinHTTP.open('POST', texURLAutorizacion, 0);
        WinHTTP.send(XMLRequestDoc);

        Create(XMLResponseDoc, true, true);
        XMLResponseDoc.load(WinHTTP.responseXML);
        //IF UPPERCASE(USERID) = 'DYNASOFT\JESUS' THEN
        //  XMLResponseDoc.save('C:\temp\RespuestaAutorizacionSRI.xml');
        //+#35029 22.03.18
        /*
        IF texPrmClave <> '' THEN BEGIN
          lCarpetaLog := '\\SECNAVSQL02\ProduccionFE\Dynasoft';
          IF lFile.OPEN(lCarpetaLog+'\log.txt') THEN BEGIN
            XMLResponseDoc.save(lCarpetaLog+'\'+'B'+texPrmClave+'.xml');
            lFile.CLOSE;
          END;
        END;
        *//*
        //-#35029 22.03.18



        if WinHTTP.status = 200 then begin

            //A veces los usuarios envian el comrpobante de nuevo autnque ya este autorizado, por eso
            //primero compruebo si se autorizó el comprobnate en alguno de los envios.

            Clear(texValor);
            XMLNodeList := XMLResponseDoc.childNodes;
            for i := 0 to XMLNodeList.length - 1 do begin
                XMLNode := XMLNodeList.item(i);
                ReadChildNodes(XMLNode, ElementoEstado, 'AUTORIZADO');
            end;
            texEstado := texValor;

            if texEstado <> 'AUTORIZADO' then begin
                Clear(texValor);
                XMLNodeList := XMLResponseDoc.childNodes;
                for i := 0 to XMLNodeList.length - 1 do begin
                    XMLNode := XMLNodeList.item(i);
                    ReadChildNodes(XMLNode, ElementoEstado, '');
                end;
                texEstado := texValor;
            end;

            case texEstado of
                'AUTORIZADO':
                    begin

                        texRutaRespuestaSOAP := TraerRutaEnviados + texPrmClave + '.SOAP.xml';
                        XMLResponseDoc.save(texRutaRespuestaSOAP);
                        DesEncapsular(texRutaRespuestaSOAP, TraerRutaAutorizados + texPrmClave + '.xml');

                        Clear(texValor);
                        XMLNodeList := XMLResponseDoc.childNodes;
                        for i := 0 to XMLNodeList.length - 1 do begin
                            XMLNode := XMLNodeList.item(i);
                            ReadChildNodes(XMLNode, ElementoNoAuto, '');
                        end;
                        texPrmNoAutorizacion := texValor;


                        Clear(texValor);
                        XMLNodeList := XMLResponseDoc.childNodes;
                        for i := 0 to XMLNodeList.length - 1 do begin
                            XMLNode := XMLNodeList.item(i);
                            ReadChildNodes(XMLNode, ElementoFechaAuto, '');
                        end;
                        texPrmFechaAuto := FormatFechaHoraXML(texValor);

                        texPrmRespuesta := texEstado;
                        texPrmInfo := '';

                        exit(true);
                    end;
                'NO AUTORIZADO':
                    begin

                        Clear(texValor);
                        XMLNodeList := XMLResponseDoc.childNodes;
                        for i := 0 to XMLNodeList.length - 1 do begin
                            XMLNode := XMLNodeList.item(i);
                            ReadChildNodes(XMLNode, ElementoMensaje, '');
                        end;
                        texPrmRespuesta := texValor;

                        Clear(texValor);
                        XMLNodeList := XMLResponseDoc.childNodes;
                        for i := 0 to XMLNodeList.length - 1 do begin
                            XMLNode := XMLNodeList.item(i);
                            ReadChildNodes(XMLNode, ElementoInfo, '');
                        end;
                        texPrmInfo := texValor;
                        exit(false);
                    end;
            //  ELSE
            //    ERROR(Error008);
            end;
        end
        else begin
            texPrmRespuesta := Error001;
            texPrmInfo := '';
            exit(false);
        end;

    end;


    procedure GuardarLOG(codPrmNoDoc: Code[20]; texPrmFichero: Text[250]; optPrmEstado: Option Generado,Firmado,Enviado,Rechazado,Autorizado,"No autorizado",Error,Contingencia; texPrmRespuestaWS: Text[1024]; texPrmInfoAdicional: Text[1024]): Integer
    var
        recLOG: Record "Log comprobantes electronicos";
    begin
        //+001
        //... El parametro optPrmEstado se ha ampliado de <Generado,Firmado,Enviado> a <Generado,Firmado,Enviado,Rechazado,Autorizado,No autorizado,Error,Contingencia>
        //-001

        recLOG.Init;
        recLOG."Fecha hora mov." := CurrentDateTime;
        recLOG.Usuario := UserId;
        recLOG.Ambiente := recCfgFE.Ambiente;
        recLOG."Fichero XML" := texPrmFichero;
        recLOG."Tipo documento" := optTipoDoc;
        recLOG."No. documento" := codPrmNoDoc;
        recLOG.Estado := optPrmEstado;
        recLOG."Respuesta SRI" := CopyStr(texPrmRespuestaWS, 1, 250);
        recLOG."Info adicional" := CopyStr(texPrmInfoAdicional, 1, 250);
        recLOG.Insert(true);
        Commit;

        exit(recLOG."No. mov.");
    end;


    procedure TraerRutaGenerados(): Text[255]
    begin

        case optTipoDoc of
            optTipoDoc::Factura:
                exit(recCfgFE."Ruta ficheros XML Facturas" + '\' + recCfgFE."Subcarpeta generados" + '\');
            optTipoDoc::Retencion:
                exit(recCfgFE."Ruta ficheros XML Retencion" + '\' + recCfgFE."Subcarpeta generados" + '\');
            optTipoDoc::Remision:
                exit(recCfgFE."Ruta ficheros XML Remisiones" + '\' + recCfgFE."Subcarpeta generados" + '\');
            optTipoDoc::NotaCredito:
                exit(recCfgFE."Ruta ficheros XML Nota Credito" + '\' + recCfgFE."Subcarpeta generados" + '\');
            optTipoDoc::NotaDebito:
                exit(recCfgFE."Ruta ficheros XML Nota Debito" + '\' + recCfgFE."Subcarpeta generados" + '\');
        end;
    end;


    procedure TraerRutaEnviados(): Text[255]
    begin

        case optTipoDoc of
            optTipoDoc::Factura:
                exit(recCfgFE."Ruta ficheros XML Facturas" + '\' + recCfgFE."Subcarpeta enviados" + '\');
            optTipoDoc::Retencion:
                exit(recCfgFE."Ruta ficheros XML Retencion" + '\' + recCfgFE."Subcarpeta enviados" + '\');
            optTipoDoc::Remision:
                exit(recCfgFE."Ruta ficheros XML Remisiones" + '\' + recCfgFE."Subcarpeta enviados" + '\');
            optTipoDoc::NotaCredito:
                exit(recCfgFE."Ruta ficheros XML Nota Credito" + '\' + recCfgFE."Subcarpeta enviados" + '\');
            optTipoDoc::NotaDebito:
                exit(recCfgFE."Ruta ficheros XML Nota Debito" + '\' + recCfgFE."Subcarpeta enviados" + '\');
        end;
    end;


    procedure TraerRutaFirmados(): Text[255]
    begin

        case optTipoDoc of
            optTipoDoc::Factura:
                exit(recCfgFE."Ruta ficheros XML Facturas" + '\' + recCfgFE."Subcarpeta firmados" + '\');
            optTipoDoc::Retencion:
                exit(recCfgFE."Ruta ficheros XML Retencion" + '\' + recCfgFE."Subcarpeta firmados" + '\');
            optTipoDoc::Remision:
                exit(recCfgFE."Ruta ficheros XML Remisiones" + '\' + recCfgFE."Subcarpeta firmados" + '\');
            optTipoDoc::NotaCredito:
                exit(recCfgFE."Ruta ficheros XML Nota Credito" + '\' + recCfgFE."Subcarpeta firmados" + '\');
            optTipoDoc::NotaDebito:
                exit(recCfgFE."Ruta ficheros XML Nota Debito" + '\' + recCfgFE."Subcarpeta firmados" + '\');
        end;
    end;


    procedure TraerRutaAutorizados(): Text[255]
    begin

        case optTipoDoc of
            optTipoDoc::Factura:
                exit(recCfgFE."Ruta ficheros XML Facturas" + '\' + recCfgFE."Subcarpeta autorizados" + '\');
            optTipoDoc::Retencion:
                exit(recCfgFE."Ruta ficheros XML Retencion" + '\' + recCfgFE."Subcarpeta autorizados" + '\');
            optTipoDoc::Remision:
                exit(recCfgFE."Ruta ficheros XML Remisiones" + '\' + recCfgFE."Subcarpeta autorizados" + '\');
            optTipoDoc::NotaCredito:
                exit(recCfgFE."Ruta ficheros XML Nota Credito" + '\' + recCfgFE."Subcarpeta autorizados" + '\');
            optTipoDoc::NotaDebito:
                exit(recCfgFE."Ruta ficheros XML Nota Debito" + '\' + recCfgFE."Subcarpeta autorizados" + '\');
        end;
    end;


    procedure ReadChildNodes(CurrentXMLNode: Automation; texPrmElemento: Text[30]; texPrmValor: Text[30]): Text[30]
    var
        TempXMLNodeList: Automation;
        TempXMLAttributeList: Automation;
        texValorAux: Text[1024];
        j: Integer;
        k: Integer;
    begin

        if texValor <> '' then
            exit;

        case Format(CurrentXMLNode.nodeType) of
            '1':
                begin // Elementos
                    CurrentElementName := CurrentXMLNode.nodeName;
                    TempXMLAttributeList := CurrentXMLNode.attributes;
                    for k := 0 to TempXMLAttributeList.length - 1 do
                        ReadChildNodes(TempXMLAttributeList.item(k), texPrmElemento, texPrmValor);

                    TempXMLNodeList := CurrentXMLNode.childNodes;
                    for j := 0 to TempXMLNodeList.length - 1 do
                        ReadChildNodes(TempXMLNodeList.item(j), texPrmElemento, texPrmValor);
                end;

            '2':
                begin // Atributos
                      //    MESSAGE(CurrentElementName + ' Attribute : ' +
                      //    FORMAT(CurrentXMLNode.nodeName) + ' = ' + FORMAT(CurrentXMLNode.nodeValue));
                end;

            '3':
                begin  // Valor
                    if texPrmValor <> '' then begin                        //El caso en que se busca si existe un valor concreto
                        if (CurrentElementName = texPrmElemento) then begin
                            texValorAux := Format(CurrentXMLNode.nodeValue);
                            if texValorAux <> '' then
                                if UpperCase(texPrmValor) = UpperCase(Format(CurrentXMLNode.nodeValue)) then begin
                                    texValor := texValorAux;
                                    exit;
                                end;
                        end;
                    end
                    else begin
                        if (CurrentElementName = texPrmElemento) then begin
                            texValor := Format(CurrentXMLNode.nodeValue);
                            if texValor <> '' then
                                exit;
                        end;
                    end;



                end;
        end;
    end;


    procedure MostrarError(texPrmTexto: Text[1024])
    begin
        if blnManual then
            Error(texPrmTexto);
    end;


    procedure MostrarAviso(texPrmTexto: Text[1024])
    begin
        if blnManual then
            Message(texPrmTexto);
    end;


    procedure TraerFechaEmisionFactura(codPrmNC: Code[20]; codPrmEstablecimiento: Code[10]; codPrmPunto: Code[10]; codPrmNoFiscal: Code[20]): Date
    var
        recCabFac: Record "Sales Invoice Header";
    begin
        recCabFac.Reset;
        recCabFac.SetCurrentKey("No. Comprobante Fiscal");
        recCabFac.SetRange("Establecimiento Factura", codPrmEstablecimiento);
        recCabFac.SetRange("Punto de Emision Factura", codPrmPunto);
        recCabFac.SetRange("No. Comprobante Fiscal", codPrmNoFiscal);
        if recCabFac.FindFirst then
            exit(recCabFac."Document Date")
        else
            Error(Error009, codPrmEstablecimiento + '-' + codPrmPunto + '-' + codPrmNoFiscal, codPrmNC);
    end;


    procedure ActualizarEstadoDocFE(codPrmDoc: Code[20]; optPrmEstado: Option Generado,Firmado,Enviado,Rechazado,Autorizado,"No autorizado",Error; texPrmNoAuto: Text[60]; texPrmFechaAuto: Text[30])
    var
        recDocFE: Record "Documento FE";
    begin

        recDocFE.Get(codPrmDoc);
        case optPrmEstado of
            optPrmEstado::Enviado:
                begin
                    recDocFE."Estado envio" := recDocFE."Estado envio"::Enviado;
                    recDocFE."Fecha hora ult. envio" := CurrentDateTime;
                end;
            optPrmEstado::Rechazado:
                recDocFE."Estado envio" := recDocFE."Estado envio"::Rechazado;
            optPrmEstado::"No autorizado":
                recDocFE."Estado autorizacion" := recDocFE."Estado autorizacion"::"No autorizado";
            optPrmEstado::Autorizado:
                begin
                    recDocFE."Estado autorizacion" := recDocFE."Estado autorizacion"::Autorizado;
                    recDocFE."No. autorizacion" := texPrmNoAuto;
                    recDocFE."Fecha hora autorizacion" := texPrmFechaAuto;
                end;
            optPrmEstado::Error:
                recDocFE."Estado envio" := recDocFE."Estado envio"::Pendiente;
        end;
        recDocFE.Ambiente := recCfgFE.Ambiente;
        recDocFE.Modify;
    end;


    procedure DeleteEmptyXMLNodes(XMLNode: Automation)
    var
        XMLDomNodeList: Automation;
        XMLChildNode: Automation;
        i: Integer;
    begin
        if XMLNode.nodeTypeString = 'element' then begin
            if (XMLNode.hasChildNodes = false) then begin
                if (XMLNode.xml = '<' + XMLNode.nodeName + '/>') then
                    XMLNode := XMLNode.parentNode.removeChild(XMLNode)
            end else begin
                XMLDomNodeList := XMLNode.childNodes;
                for i := 1 to XMLDomNodeList.length do begin
                    XMLChildNode := XMLDomNodeList.nextNode();
                    DeleteEmptyXMLNodes(XMLChildNode);
                end;
            end;
        end;
    end;


    procedure TraerTipoIdCliente(codPrmCliente: Code[20]): Code[2]
    var
        recCliente: Record Customer;
    begin
        recCliente.Get(codPrmCliente);
        case recCliente."Tipo Documento" of
            recCliente."Tipo Documento"::RUC:
                exit('04');
            recCliente."Tipo Documento"::Cedula:
                exit('05');
            recCliente."Tipo Documento"::Pasaporte:
                exit('06');
        end;
    end;


    procedure ImprimirDocumentoFE(codPrmDoc: Code[20])
    var
        recDocFE: Record "Documento FE";
    begin
        if not recDocFE.Get(codPrmDoc) then
            Error(Error011);

        recDocFE.Reset;
        recDocFE.SetRange("No. documento", recDocFE."No. documento");
        case recDocFE."Tipo documento" of
            recDocFE."Tipo documento"::Factura:
                REPORT.RunModal(REPORT::"Factura Santillana Ecuador FE", true, false, recDocFE);
            recDocFE."Tipo documento"::NotaCredito:
                REPORT.RunModal(REPORT::"NC Santillana Ecuador FE", true, false, recDocFE);
            recDocFE."Tipo documento"::Remision:
                REPORT.RunModal(REPORT::"Remision Santillana Ecuador FE", true, false, recDocFE);
            recDocFE."Tipo documento"::Retencion:
                REPORT.RunModal(REPORT::"Reten. Santillana Ecuador FE", true, false, recDocFE);
        end;
    end;


    procedure FormatFechaHoraXML(texFechaHoraXML: Text[60]): Text[60]
    var
        intDia: Integer;
        intMes: Integer;
        "intAño": Integer;
        codHoras: Code[10];
        codMinutos: Code[10];
        codSegundos: Code[10];
        timHora: Time;
        datFecha: Date;
    begin

        if texFechaHoraXML <> '' then begin
            Evaluate(intDia, CopyStr(texFechaHoraXML, 9, 2));
            Evaluate(intMes, CopyStr(texFechaHoraXML, 6, 2));
            Evaluate(intAño, CopyStr(texFechaHoraXML, 1, 4));

            codHoras := CopyStr(texFechaHoraXML, 12, 2);
            codMinutos := CopyStr(texFechaHoraXML, 15, 2);
            codSegundos := CopyStr(texFechaHoraXML, 18, 2);

            datFecha := DMY2Date(intDia, intMes, intAño);
            Evaluate(timHora, codHoras + codMinutos + codSegundos);
            exit(Format(CreateDateTime(datFecha, timHora), 0,
                        '<Month,2>/<Day,2>/<Year> <Hours24,2>:<Minutes,2>:<Seconds,2>'));
        end;
    end;


    procedure FormatRUC(codPrmRUC: Code[20]): Code[20]
    begin
        //IF STRLEN(codPrmRUC) = 10 THEN
        //  EXIT(codPrmRUC+'001');


        exit(codPrmRUC);
    end;


    procedure ControlEstado(codPrmDocFE: Code[20])
    var
        recDocFE: Record "Documento FE";
    begin
        //+35029 - 26.03.18
        //... Añadimos una sincronizacion para intentar evitar que el mismo proceso de envio y autorización se realice más de 1 vez al mismo tiempo.
        Sincronizacion(codPrmDocFE);
        //-35029 - 26.03.18

        if recDocFE.Get(codPrmDocFE) then begin
            if (recDocFE."Estado envio" = recDocFE."Estado envio"::Enviado) and (recDocFE."Estado autorizacion" = recDocFE."Estado autorizacion"::Autorizado) then
                Error(Error014, recDocFE."Tipo documento", recDocFE."No. documento");

            //+RRT
            //IF (recDocFE."Estado envio"=  recDocFE."Estado envio"::Enviado) THEN
            //  ERROR(Error016, recDocFE."Tipo documento", recDocFE."No. documento");
        end;
    end;


    procedure InsertarRetencion(recPrmDocFE: Record "Documento FE"; recPrmLinRet: Record "Historico Retencion Prov."; datPrmFechaEmisionDoc: Date; codPrmEstablecimiento: Code[3]; codPrmPuntoEmision: Code[3]; codPrmNCF: Code[9])
    var
        recTmpRet: Record "Retenciones FE";
        recFacCmp: Record "Purch. Inv. Header";
        recNCCmp: Record "Purch. Cr. Memo Hdr.";
        ErrorPorcentaje: Label 'El porcentaje %1 no está configurado, para los comprobantes electronicos.';
    begin

        with recPrmLinRet do begin
            recTmpRet.Init;
            recTmpRet."No. documento" := recPrmDocFE."No. documento";
            case "Base Cálculo" of
                "Base Cálculo"::"B. Imponible", "Base Cálculo"::Ninguno:
                    begin
                        recTmpRet.Codigo := 1;
                        recTmpRet.Impuesto := 'RENTA';
                        recTmpRet."Codigo retencion" := "Código Retención";
                    end;
                "Base Cálculo"::IVA:
                    begin
                        recTmpRet.Codigo := 2;
                        recTmpRet.Impuesto := 'IVA';
                        case "Importe Retención" of
                            //#22493:Inicio2
                            0:
                                recTmpRet."Codigo retencion" := '8';
                            10:
                                recTmpRet."Codigo retencion" := '9';
                            20:
                                recTmpRet."Codigo retencion" := '10';
                            //#22493:Fin2
                            30:
                                recTmpRet."Codigo retencion" := '1';
                            70:
                                recTmpRet."Codigo retencion" := '2';
                            100:
                                recTmpRet."Codigo retencion" := '3';
                            //#22493:Inicio
                            else
                                Error(ErrorPorcentaje, "Importe Retención");
                        //#22493:Fin
                        end;
                    end;
            end;

            recTmpRet."Base imponible" := "Importe Base Retencion";
            recTmpRet."Porcentaje retener" := "Importe Retención";
            recTmpRet."Valor retenido" := "Importe Retenido";

            case "Tipo documento" of
                "Tipo documento"::Order, "Tipo documento"::Invoice:
                    begin
                        recFacCmp.Get(recPrmLinRet."No. documento");
                        recTmpRet."Cod. doc. sustento" := recFacCmp."Tipo de Comprobante";
                        recTmpRet.Comprobante := recFacCmp."Desc. Tipo de Comprobante";
                    end;
                "Tipo documento"::"Credit Memo":
                    begin
                        recNCCmp.Get(recPrmLinRet."No. documento");
                        recTmpRet."Cod. doc. sustento" := recNCCmp."Tipo de Comprobante";
                        recTmpRet.Comprobante := recNCCmp."Desc. Tipo de Comprobante";
                    end;
            end;
            recTmpRet."Num. doc. sustento" := PADSTR2(codPrmEstablecimiento, 3, '0') +
                                              PADSTR2(codPrmPuntoEmision, 3, '0') +
                                              PADSTR2(codPrmNCF, 9, '0');
            recTmpRet."Fecha emision doc. sustento" := datPrmFechaEmisionDoc;
            recTmpRet."Ejercicio fiscal" := recPrmDocFE."Periodo fiscal";
            recTmpRet.Insert;
        end;
    end;


    procedure ComprobarCfgFE(optPrmTipoDoc: Option Factura,Retencion,Remision,NotaCredito,NotaDebito)
    begin
        recCfgFE.Get;
        if recCfgFE.Activado <> recCfgFE.Activado::Desactivado then begin

            case recCfgFE.Ambiente of
                recCfgFE.Ambiente::Pruebas:
                    begin
                        recCfgFE.TestField("Web Service Recepcion pruebas");
                        recCfgFE.TestField("Web Service Autoriza. pruebas");
                        texURLRecepcion := recCfgFE."Web Service Recepcion pruebas";
                        texURLAutorizacion := recCfgFE."Web Service Autoriza. pruebas";
                    end;
                recCfgFE.Ambiente::Produccion:
                    begin
                        recCfgFE.TestField("Web Service recep. produccion");
                        recCfgFE.TestField("Web Service Autori. produccion");
                        texURLRecepcion := recCfgFE."Web Service recep. produccion";
                        texURLAutorizacion := recCfgFE."Web Service Autori. produccion";
                    end;
            end;

            case optPrmTipoDoc of
                optPrmTipoDoc::Factura:
                    recCfgFE.TestField("Ruta ficheros XML Facturas");
                optPrmTipoDoc::Remision:
                    recCfgFE.TestField("Ruta ficheros XML Remisiones");
                optPrmTipoDoc::NotaCredito:
                    recCfgFE.TestField("Ruta ficheros XML Nota Credito");
                optPrmTipoDoc::NotaDebito:
                    recCfgFE.TestField("Ruta ficheros XML Nota Debito");
                optPrmTipoDoc::Retencion:
                    recCfgFE.TestField("Ruta ficheros XML Retencion");
            end;

            recCfgFE.TestField("Subcarpeta generados");
            recCfgFE.TestField("Subcarpeta firmados");
            recCfgFE.TestField("Subcarpeta enviados");
            recCfgFE.TestField("Subcarpeta autorizados");

            recCfgFE.TestField(recCfgFE."Ruta Ejecutable Firma");
            if not Exists(recCfgFE."Ruta certificado firma") then
                Error(Error007);

        end
        else
            Error(Error002);
    end;


    procedure ActualizarAutorizaHistoricos(recPrmDocFE: Record "Documento FE"; codPrmAutorizacion: Code[49])
    var
        recCabFac: Record "Sales Invoice Header";
        recCabRemVta: Record "Sales Shipment Header";
        recCabRemTrans: Record "Transfer Shipment Header";
        recCabNC: Record "Sales Cr.Memo Header";
        recHistRet: Record "Historico Retencion Prov.";
        recHistRetDoc: Record "Retencion Doc. Reg. Prov.";
        recLinRetFE: Record "Retenciones FE";
        recDocFE: Record "Documento FE";
        optTipo: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
    begin
        with recPrmDocFE do begin

            case "Tipo documento" of
                "Tipo documento"::Remision:
                    begin
                        if recCabRemVta.Get("No. documento") then begin
                            recCabRemVta."No. Autorizacion Remision" := codPrmAutorizacion;
                            recCabRemVta.Modify;

                            //Actualiza datos de remisión en factura
                            recCabFac.Reset;
                            recCabFac.SetCurrentKey("Order No.");
                            recCabFac.SetRange("Order No.", recCabRemVta."Order No.");
                            recCabFac.SetRange("Establecimiento Factura", recCabRemVta."Establecimiento Factura");
                            recCabFac.SetRange("Punto de Emision Factura", recCabRemVta."Punto de Emision Factura");
                            recCabFac.SetRange("No. Comprobante Fiscal", recCabRemVta."No. Comprobante Fiscal Factura");
                            recCabFac.ModifyAll("No. Autorizacion Remision", codPrmAutorizacion);

                        end;
                        if recCabRemTrans.Get("No. documento") then begin
                            recCabRemTrans."No. Autorizacion Comprobante" := codPrmAutorizacion;
                            recCabRemTrans.Modify;
                        end;

                    end;
                "Tipo documento"::Factura:
                    begin
                        if recCabFac.Get("No. documento") then begin
                            recCabFac."No. Autorizacion Comprobante" := codPrmAutorizacion;
                            recCabFac.Modify;

                            //Actualiza datos del documento de sustento en remisiones relacionadas.
                            recDocFE.Reset;
                            recDocFE.SetCurrentKey("Cod. doc. sustento", "Num. doc. sustento");
                            recDocFE.SetRange("Cod. doc. sustento", '01');
                            recDocFE.SetRange("Num. doc. sustento", PADSTR2(recCabFac."Establecimiento Factura", 3, '0') + '-' +
                                                                    PADSTR2(recCabFac."Punto de Emision Factura", 3, '0') + '-' +
                                                                    PADSTR2(recCabFac."No. Comprobante Fiscal", 9, '0'));
                            recDocFE.ModifyAll("Num. aut. doc. sustento", codPrmAutorizacion);


                            //Actualiza datos de la factura en remisiones
                            recCabRemVta.Reset;
                            recCabRemVta.SetCurrentKey("Order No.");
                            recCabRemVta.SetRange("Order No.", recCabFac."Order No.");
                            recCabRemVta.SetRange("Establecimiento Remision", recCabFac."Establecimiento Remision");
                            recCabRemVta.SetRange("Punto de Emision Remision", recCabFac."Punto de Emision Remision");
                            recCabRemVta.SetRange("No. Comprobante Fisc. Remision", recCabFac."No. Comprobante Fisc. Remision");
                            recCabRemVta.ModifyAll("No. Autorizacion Comprobante", codPrmAutorizacion);

                        end;

                    end;
                "Tipo documento"::NotaCredito:
                    begin
                        if recCabNC.Get("No. documento") then begin
                            recCabNC."No. Autorizacion Comprobante" := codPrmAutorizacion;
                            recCabNC.Modify;
                        end;
                    end;
                "Tipo documento"::Retencion:
                    begin


                        recLinRetFE.Reset;
                        recLinRetFE.SetRange("No. documento", "No. documento");
                        if recLinRetFE.FindSet then
                            case recLinRetFE."Cod. doc. sustento" of
                                '01':
                                    optTipo := optTipo::Invoice;
                                '04':
                                    optTipo := optTipo::"Credit Memo";
                            end;

                        recHistRet.Reset;
                        //      recHistRet.SETRANGE("Tipo documento", optTipo);
                        recHistRet.SetRange("No. documento", "No. documento");
                        if recHistRet.FindSet then
                            recHistRet.ModifyAll("No. autorizacion NCF", codPrmAutorizacion);

                        recHistRetDoc.Reset;
                        //      recHistRetDoc.SETRANGE("Tipo documento", optTipo);
                        recHistRetDoc.SetRange("No. documento", "No. documento");
                        if recHistRetDoc.FindSet then
                            recHistRetDoc.ModifyAll("No. autorizacion NCF", codPrmAutorizacion);

                    end;

            end;

        end;
    end;


    procedure ReenviarComprobante(recPrmEnvio: Record "Log comprobantes electronicos"; blnPrmManual: Boolean)
    var
        texRuta: Text[255];
        texRespuesta: Text[1024];
        texInfo: Text[1024];
        optDummy: Option;
        lOk: Boolean;
    begin

        with recPrmEnvio do begin
            texRuta := TraerRutaEnviados + "Fichero XML";

            //+35029
            //IF RecepcionComprobanteWS(texRuta, texRespuesta, texInfo, optDummy) THEN BEGIN
            lOk := false;
            if _GUIALLOWED then
                lOk := RecepcionComprobanteWS(texRuta, texRespuesta, texInfo, optDummy)
            else
                lOk := _RecepcionComprobanteWS(texRuta, texRespuesta, texInfo, optDummy);
            //-35029

            if lOk then begin
                ActualizarEstadoDocFE("No. documento", optEstado::Enviado, '', '');
                GuardarLOG("No. documento", "Fichero XML", optEstado::Enviado, texRespuesta, texInfo);
            end
            else
                MostrarAviso(StrSubstNo(Text008, optTipoDoc, "No. documento"))
        end;
    end;


    procedure TraerUltimoEnvio(recPrmFE: Record "Documento FE"; var recPrmEnvio: Record "Log comprobantes electronicos"): Boolean
    begin
        recPrmEnvio.Reset;
        recPrmEnvio.SetRange(Ambiente, recPrmFE.Ambiente);
        recPrmEnvio.SetRange("Tipo documento", recPrmFE."Tipo documento");
        recPrmEnvio.SetRange("No. documento", recPrmFE."No. documento");
        recPrmEnvio.SetRange(Estado, recPrmEnvio.Estado::Enviado);
        if recPrmEnvio.FindLast then
            exit(true);
    end;


    procedure ComprobarAutorizacion(codPrmDoc: Code[20]; blnPrmManual: Boolean)
    var
        recDocFE: Record "Documento FE";
        recEnvio: Record "Log comprobantes electronicos";
        texRespuestaWS: Text[1024];
        texInfoWS: Text[1024];
        texNoAutorizacion: Text[100];
        texFechaAutorizacion: Text[100];
        texRutaDestino: Text[255];
        texRutaOrigen: Text[255];
        lOk: Boolean;
        ErrorL001: Label 'El documento %1 no ha sido todavía enviado. No se puede autorizar';
    begin

        ComprobarCfgFE(optTipoDoc);

        if not recDocFE.Get(codPrmDoc) then
            Error(Error010);

        //+35029 - 26.03.18
        //... Añadimos una sincronizacion para intentar evitar que el mismo proceso de envio y autorización se realice más de 1 vez al mismo tiempo.
        Sincronizacion(codPrmDoc);
        //-35029 - 26.03.18

        //+#35029 - 22.03.18
        if recDocFE."Estado envio" <> recDocFE."Estado envio"::Enviado then
            Error(ErrorL001, codPrmDoc);
        //-#35029 - 22.03.18

        if recDocFE."Estado autorizacion" = recDocFE."Estado autorizacion"::Autorizado then begin
            //+#35029
            if blnPrmManual then
                //-#35029
                Message(Error015, recDocFE."Tipo documento", recDocFE."No. documento", recDocFE."Fecha hora autorizacion", recDocFE."No. autorizacion");
            exit;
        end;

        optTipoDoc := recDocFE."Tipo documento";
        blnManual := blnPrmManual;

        //+35029
        lOk := false;
        if _GUIALLOWED then begin
            if AutorizacionComprobanteWS(recDocFE.Clave, texRespuestaWS, texInfoWS, texNoAutorizacion, texFechaAutorizacion) then
                lOk := true;
        end
        else begin
            if _AutorizacionComprobanteWS(recDocFE.Clave, texRespuestaWS, texInfoWS, texNoAutorizacion, texFechaAutorizacion) then
                lOk := true;
        end;
        //-35029

        //+35029
        //IF AutorizacionComprobanteWS(recDocFE.Clave, texRespuestaWS, texInfoWS, texNoAutorizacion, texFechaAutorizacion) THEN BEGIN
        if lOk then begin
            //-35029
            ActualizarEstadoDocFE(codPrmDoc, optEstado::Autorizado, CopyStr(texNoAutorizacion, 1, 49), CopyStr(texFechaAutorizacion, 1, 30));
            ActualizarAutorizaHistoricos(recDocFE, CopyStr(texNoAutorizacion, 1, 49));
            GuardarLOG(codPrmDoc, recDocFE.Clave, optEstado::Autorizado, texRespuestaWS, texInfoWS);

            //  texRutaOrigen  := TraerRutaEnviados + recDocFE.Clave + '.xml';
            //  texRutaDestino := TraerRutaAutorizados + recDocFE.Clave + '.xml';
            //  MoverFichero(texRutaOrigen, texRutaDestino);

            blnManual := blnPrmManual;
            MostrarAviso(StrSubstNo(Text006, optTipoDoc, codPrmDoc, texNoAutorizacion))
        end
        else begin
            if texRespuestaWS <> '' then begin
                ActualizarEstadoDocFE(codPrmDoc, optEstado::"No autorizado", '', '');
                GuardarLOG(codPrmDoc, recDocFE.Clave, optEstado::"No autorizado", texRespuestaWS, texInfoWS);
                MostrarAviso(StrSubstNo(Text007, optTipoDoc, codPrmDoc, texRespuestaWS, texInfoWS))
            end
            else

                if TraerUltimoEnvio(recDocFE, recEnvio) then begin
                    if ((CurrentDateTime - recEnvio."Fecha hora mov.") < 300000) then  // 5 MINUTOS
                        MostrarAviso(StrSubstNo(Text008, optTipoDoc, codPrmDoc))
                    else
                        ReenviarComprobante(recEnvio, blnPrmManual);  //En lugar de mostrar un aviso, si ya ha pasado una hora lo volvemos a enviar y pedido autorización de nuevo
                end
                else
                    Error(Error010);
        end;
    end;


    procedure DesEncapsular(texPrmFicheroEntrada: Text[255]; texPrmFicheroSalida: Text[255])
    var
        filEntrada: File;
        filSalida: File;
        chrBuffer: Char;
    begin

        filEntrada.Open(texPrmFicheroEntrada);

        filSalida.WriteMode(true);
        filSalida.Create(texPrmFicheroSalida);

        filSalida.TextMode(true);
        filSalida.Write('<?xml version="1.0" encoding="utf-8"?>');
        filSalida.TextMode(false);

        filEntrada.Seek(164);
        while filEntrada.Pos < filEntrada.Len - 68 do begin
            filEntrada.Read(chrBuffer);
            filSalida.Write(chrBuffer);
        end;

        filEntrada.Close;
        filSalida.Close;

        Erase(texPrmFicheroEntrada);
    end;


    procedure TraerTodasAutorizaciones()
    var
        recDocFE: Record "Documento FE";
        dlgProgreso: Dialog;
        intProcesados: Integer;
    begin

        recDocFE.Reset;
        if recDocFE.FindSet then begin
            dlgProgreso.Open('Procesados #########1 de #########2');
            dlgProgreso.Update(2, recDocFE.Count);
            repeat
                ComprobarAutorizacionLote(recDocFE."No. documento");
                intProcesados += 1;
                dlgProgreso.Update(1, intProcesados);
            until recDocFE.Next = 0;
        end;
    end;


    procedure ComprobarAutorizacionLote(codPrmDoc: Code[20])
    var
        recDocFE: Record "Documento FE";
        recEnvio: Record "Log comprobantes electronicos";
        texRespuestaWS: Text[1024];
        texInfoWS: Text[1024];
        texNoAutorizacion: Text[100];
        texFechaAutorizacion: Text[100];
        texRutaDestino: Text[255];
        texRutaOrigen: Text[255];
    begin

        ComprobarCfgFE(optTipoDoc);

        if not recDocFE.Get(codPrmDoc) then
            Error(Error010);

        optTipoDoc := recDocFE."Tipo documento";
        blnManual := true;
        AutorizacionComprobanteWS(recDocFE.Clave, texRespuestaWS, texInfoWS, texNoAutorizacion, texFechaAutorizacion);
    end;


    procedure TraerISBN(codPrmProducto: Code[20]): Code[30]
    var
        recRef: Record "Item Cross Reference";
    begin
        recRef.Reset;
        recRef.SetRange("Item No.", codPrmProducto);
        recRef.SetRange("Cross-Reference Type", recRef."Cross-Reference Type"::"Bar Code");
        if recRef.FindFirst then
            exit(recRef."Cross-Reference No.");
    end;

    local procedure TESTConexionWS(): Boolean
    var
        cduEnviar: Codeunit "Enviar comprobante electronico";
        [WithEvents]
        WinHTTP: Automation;
        XMLRequestDoc: Automation;
        XMLResponseDoc: Automation;
        XMLProsInstr: Automation;
        XMLElement1: Automation;
        XMLElement2: Automation;
        XMLElement3: Automation;
        XMLNode: Automation;
        XMLNodeList: Automation;
        i: Integer;
        texEstado: Text[1024];
        _XMLRequestDoc: DotNet XmlDocument;
        _XMLProsInstr: DotNet XmlProcessingInstruction;
        _XMLElement1: DotNet XmlElement;
        _XMLElement2: DotNet XmlElement;
        _XMLElement3: DotNet XmlElement;
        _XMLNode: DotNet XmlNode;
        _XMLNodeList: DotNet XmlNodeList;
    begin
        //fes mig
        /*
        IF _GUIALLOWED THEN BEGIN  //+35029
          CREATE(XMLRequestDoc,TRUE,TRUE);
        
          XMLProsInstr := XMLRequestDoc.createProcessingInstruction('xml','version="1.0" encoding="utf-8"');
          XMLRequestDoc.appendChild(XMLProsInstr);
          XMLElement1 := XMLRequestDoc.createElement('soap:Envelope');
          XMLElement1.setAttribute('xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
          XMLElement2 := XMLRequestDoc.createElement('soap:Body');
          XMLElement3 := XMLRequestDoc.createElement('ns2:validarComprobante');
          XMLElement3.setAttribute('xmlns:ns2','http://ec.gob.sri.ws.recepcion');
        
          IF ISCLEAR(WinHTTP) THEN
            CREATE(WinHTTP,TRUE,TRUE);
        
          cduEnviar.PasarParam(texURLRecepcion,XMLRequestDoc,WinHTTP);
          COMMIT;
          IF cduEnviar.RUN THEN
            EXIT(WinHTTP.readyState <> 0);
          EXIT(FALSE);
        END
        //+35029
        ELSE BEGIN
        
          _XMLRequestDoc := _XMLRequestDoc.XmlDocument;
          _XMLProsInstr := _XMLRequestDoc.CreateProcessingInstruction('xml','version="1.0" encoding="utf-8"');
          _XMLRequestDoc.AppendChild(_XMLProsInstr);
        
          _XMLElement1 := _XMLRequestDoc.CreateElement('soap','Envelope');
          _XMLElement1.SetAttribute('xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
          _XMLElement2 := _XMLRequestDoc.CreateElement('soap:Body');
          _XMLElement3 := _XMLRequestDoc.CreateElement('ns2:validarComprobante');
          _XMLElement3.SetAttribute('xmlns:ns2','http://ec.gob.sri.ws.recepcion');
        
          IF ISNULL(_WinHTTP) THEN
            _WinHTTP := _WinHTTP.XMLHTTPRequestClass;
        
          cduEnviar._PasarParam(texURLRecepcion,_XMLRequestDoc,_WinHTTP);
          COMMIT;
          IF cduEnviar.RUN THEN BEGIN
            IF _WinHTTP.readyState <> 0 THEN
            EXIT(_WinHTTP.readyState <> 0);
          END;
          EXIT(FALSE);
        
        END;
        //-35029
        *//*
        //fes mig

    end;


    procedure TraerDireccionEstablecimiento(codPrmEstablecimiento: Code[3]): Text
    var
        recSRI: Record "SRI - Tabla Parametros";
    begin
        recSRI.Reset;
        recSRI.SetRange("Tipo Registro", recSRI."Tipo Registro"::"DIRECCION ESTABLECIMIENTO");
        recSRI.SetRange(Code, codPrmEstablecimiento);
        if recSRI.FindFirst then
            exit(recSRI.Description)
        else
            Error(Error028, codPrmEstablecimiento);
    end;


    procedure EliminarCaracteresRaros(InputText: Text) OutputText: Text
    var
        i: Integer;
        isNewLine: Boolean;
    begin

        for i := 1 to StrLen(InputText) do begin
            if InputText[i] >= 32 then
                OutputText := OutputText + Format(InputText[i])
            else begin
                if (InputText[i] in [10 .. 14]) and not isNewLine then
                    OutputText := OutputText + ' ';
                isNewLine := (InputText[i] in [10 .. 14]);
            end;
        end;

        exit(OutputText);
    end;


    procedure Parametros(recParam: Record "Parametros lote FE")
    begin
        //+35029
        //... Ajustamos el valor del tipo de documento en funcion del valor en recParam
        case recParam."Tipo comprobante" of
            recParam."Tipo comprobante"::RemisionVta:
                optTipoDoc := optTipoDoc::Remision;
            recParam."Tipo comprobante"::RemisionTrans:
                optTipoDoc := optTipoDoc::Remision;
            recParam."Tipo comprobante"::Factura:
                optTipoDoc := optTipoDoc::Factura;
            recParam."Tipo comprobante"::NotaCredito:
                optTipoDoc := optTipoDoc::NotaCredito;
            recParam."Tipo comprobante"::RetencionFac:
                optTipoDoc := optTipoDoc::Retencion;
            recParam."Tipo comprobante"::RetencionNC:
                optTipoDoc := optTipoDoc::Retencion;

        end;
    end;


    procedure _DeleteEmptyXMLNodes(_XMLNode: DotNet XmlNode)
    var
        _XMLNodeList: DotNet XmlNodeList;
        _XMLChildNode: DotNet XmlNode;
        i: Integer;
    begin
        //+35029
        if IsNull(_XMLNode) then exit;

        if _XMLNode.NodeType = 1 then begin // 1 = Element
            if _XMLNode.HasChildNodes = false then begin
                if (_XMLNode.OuterXml = ('<' + _XMLNode.Name + ' />')) or
                   (_XMLNode.OuterXml = ('<' + _XMLNode.Name + '/>')) then begin
                    _XMLNode := _XMLNode.ParentNode.RemoveChild(_XMLNode);
                    wNodoEliminado := true;
                end;
            end
            else begin
                _XMLNodeList := _XMLNode.ChildNodes;
                for i := 0 to _XMLNodeList.Count do begin
                    _XMLChildNode := _XMLNodeList.ItemOf(i);
                    _DeleteEmptyXMLNodes(_XMLChildNode);
                end;
            end;
        end;
    end;


    procedure _GUIALLOWED(): Boolean
    begin
        //#35029
        //... Esta función se puede usar también para poder debuggear tal y como lo haría NAS. (En NAS se usan variables DotNet)
        //EXIT(FALSE);
        //EXIT(TRUE);

        //... Lo ejecutamos tal y como lo haría la cola de proyectos.
        /*
        IF USERID = 'SECNAVSQL02\ADMINISTRATOR' THEN
          EXIT(FALSE)
        ELSE
          EXIT(GUIALLOWED);
        *//*

        exit(GuiAllowed);

    end;

    local procedure _RecepcionComprobanteWS(texPrmFileName: Text[255]; var texPrmRespuesta: Text[1024]; var texPrmInfo: Text[1024]; var optPrmEstado: Option Enviado,Rechazado,Error): Boolean
    var
        cduEnviar: Codeunit "Enviar comprobante electronico";
        i: Integer;
        texEstado: Text[1024];
        _XMLRequestDoc: DotNet XmlDocument;
        _XMLResponseDoc: DotNet XmlDocument;
        _XMLProsInstr: DotNet XmlProcessingInstruction;
        _XMLElement1: DotNet XmlElement;
        _XMLElement2: DotNet XmlElement;
        _XMLElement3: DotNet XmlElement;
        _XMLNode: DotNet XmlNode;
        _XMLNodeList: DotNet XmlNodeList;
        _XMLDOMDocument: DotNet XmlDocument;
        _XMLNodeAux: DotNet XmlNode;
        convert: DotNet Convert;
        ServerFile: DotNet File;
        lCarpetaLog: Text[250];
        lFile: File;
    begin
        //fes mig
        /*
        IF NOT EXISTS(texPrmFileName) THEN
          ERROR(Error004, texPrmFileName);
        
        _XMLRequestDoc := _XMLRequestDoc.XmlDocument;
        _XMLProsInstr := _XMLRequestDoc.CreateProcessingInstruction('xml','version="1.0" encoding="utf-8"');
        _XMLRequestDoc.AppendChild(_XMLProsInstr);
        _XMLElement1 := _XMLRequestDoc.CreateElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement1.SetAttribute('xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement2 := _XMLRequestDoc.CreateElement('soap','Body','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement3 := _XMLRequestDoc.CreateElement('ns2','validarComprobante','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement3.SetAttribute('xmlns:ns2','http://ec.gob.sri.ws.recepcion');
        
        _XMLNode := _XMLRequestDoc.CreateElement('xml');
        
        _XMLNode.InnerText := convert.ToBase64String(ServerFile.ReadAllBytes(texPrmFileName));
        
        _XMLElement3.AppendChild(_XMLNode);
        _XMLElement2.AppendChild(_XMLElement3);
        _XMLElement1.AppendChild(_XMLElement2);
        _XMLRequestDoc.AppendChild(_XMLElement1);
        
        
        //IF UPPERCASE(USERID) = 'DYNASOFT\JESUS' THEN
        //_XMLRequestDoc.Save('C:\TEMP\_Request.xml');
        
        IF ISNULL(_WinHTTP) THEN
          _WinHTTP := _WinHTTP.XMLHTTPRequestClass;
        
        cduEnviar._PasarParam(texURLRecepcion,_XMLRequestDoc,_WinHTTP);
        IF cduEnviar.RUN THEN BEGIN
        
          IF _WinHTTP.status = 200 THEN BEGIN
            _XMLResponseDoc := _XMLResponseDoc.XmlDocument;
        
            _XMLResponseDoc.LoadXml(_WinHTTP.responseText);
        
            //_XMLResponseDoc.async(FALSE);
            //_XMLResponseDoc.save('C:\TEMP\ResponseSRI.xml');
        
            CLEAR(texValor);
            _XMLNodeList := _XMLResponseDoc.ChildNodes;
            FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
              _XMLNode := _XMLNodeList.ItemOf(i);
              _ReadChildNodes(_XMLNode,ElementoEstado,'');
            END;
            texEstado := texValor;
        
            CASE texEstado OF
              'RECIBIDA' : BEGIN
                texPrmRespuesta := texEstado;
                texPrmInfo      := '';
                optPrmEstado := optPrmEstado::Enviado;
                EXIT(TRUE);
              END;
              'DEVUELTA' : BEGIN
        
                CLEAR(texValor);
                _XMLNodeList := _XMLResponseDoc.ChildNodes;
                FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
                  _XMLNode := _XMLNodeList.ItemOf(i);
                  _ReadChildNodes(_XMLNode,ElementoMensaje,'');
                END;
                texPrmRespuesta := texValor;
        
                CLEAR(texValor);
                _XMLNodeList := _XMLResponseDoc.ChildNodes;
                FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
                  _XMLNode := _XMLNodeList.ItemOf(i);
                  _ReadChildNodes(_XMLNode,ElementoInfo,'');
                END;
                texPrmInfo := texValor;
                optPrmEstado := optPrmEstado::Rechazado;
                EXIT(FALSE);
              END;
              ELSE BEGIN
                texPrmInfo := texValor;
                optPrmEstado := optPrmEstado::Rechazado;
                EXIT(FALSE);
              END;
        
            END;
        
          END
          ELSE BEGIN
            texPrmRespuesta := Error001;
            texPrmInfo := '';
            optPrmEstado := optPrmEstado::Error;
            EXIT(FALSE);
          END;
        END
        ELSE BEGIN
          texPrmRespuesta := Error001;
          texPrmInfo := '';
          optPrmEstado := optPrmEstado::Error;
          EXIT(FALSE);
        END;
        *//*
        //fes mig

    end;


    procedure _ReadChildNodes(CurrentXMLNode: DotNet XmlNode; texPrmElemento: Text[30]; texPrmValor: Text[30]): Text[30]
    var
        TempXMLNodeList: DotNet XmlNodeList;
        TempXMLAttributeList: DotNet XmlNamedNodeMap;
        texValorAux: Text[1024];
        j: Integer;
        k: Integer;
    begin

        if texValor <> '' then
            exit;

        case Format(CurrentXMLNode.NodeType) of
            'Element':
                begin // Elementos
                    CurrentElementName := CurrentXMLNode.Name;
                    TempXMLAttributeList := CurrentXMLNode.Attributes;
                    for k := 0 to TempXMLAttributeList.Count - 1 do
                        _ReadChildNodes(TempXMLAttributeList.Item(k), texPrmElemento, texPrmValor);

                    TempXMLNodeList := CurrentXMLNode.ChildNodes;
                    for j := 0 to TempXMLNodeList.Count - 1 do
                        _ReadChildNodes(TempXMLNodeList.ItemOf(j), texPrmElemento, texPrmValor);
                end;

            'Attribute':
                begin // Atributos
                      //    MESSAGE(CurrentElementName + ' Attribute : ' +
                      //    FORMAT(CurrentXMLNode.nodeName) + ' = ' + FORMAT(CurrentXMLNode.nodeValue));
                end;

            'Text':
                begin  // Valor
                    if texPrmValor <> '' then begin                        //El caso en que se busca si existe un valor concreto
                        if (CurrentElementName = texPrmElemento) then begin
                            texValorAux := Format(CurrentXMLNode.Value);
                            if texValorAux <> '' then
                                if UpperCase(texPrmValor) = UpperCase(Format(CurrentXMLNode.Value)) then begin
                                    texValor := texValorAux;
                                    exit;
                                end;
                        end;
                    end
                    else begin
                        if (CurrentElementName = texPrmElemento) then begin
                            texValor := Format(CurrentXMLNode.Value);
                            if texValor <> '' then
                                exit;
                        end;
                    end;

                end;
        end;
    end;

    local procedure _AutorizacionComprobanteWS(texPrmClave: Text[250]; var texPrmRespuesta: Text[1024]; var texPrmInfo: Text[1024]; var texPrmNoAutorizacion: Text[250]; var texPrmFechaAuto: Text[250]): Boolean
    var
        texFileName: Text[255];
        texEstado: Text[30];
        texRutaRespuestaSOAP: Text[1024];
        i: Integer;
        _XMLRequestDoc: DotNet XmlDocument;
        _XMLResponseDoc: DotNet XmlDocument;
        _XMLProsInstr: DotNet XmlProcessingInstruction;
        _XMLElement1: DotNet XmlElement;
        _XMLElement2: DotNet XmlElement;
        _XMLElement3: DotNet XmlElement;
        _XMLNode: DotNet XmlNode;
        _XMLNodeList: DotNet XmlNodeList;
        _XMLDOMDocument: DotNet XmlDocument;
        _XMLNodeAux: DotNet XmlNode;
        convert: DotNet Convert;
        ServerFile: DotNet File;
        lCarpetaLog: Text[250];
        lFile: File;
    begin
        //fes mig
        /*
        //+35029
        _XMLRequestDoc := _XMLRequestDoc.XmlDocument;
        _XMLProsInstr := _XMLRequestDoc.CreateProcessingInstruction('xml','version="1.0" encoding="utf-8"');
        _XMLRequestDoc.AppendChild(_XMLProsInstr);
        _XMLElement1 := _XMLRequestDoc.CreateElement('soap','Envelope','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement1.SetAttribute('xmlns:soap','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement2 := _XMLRequestDoc.CreateElement('soap','Body','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement3 := _XMLRequestDoc.CreateElement('ns2','autorizacionComprobante','http://schemas.xmlsoap.org/soap/envelope/');
        _XMLElement3.SetAttribute('xmlns:ns2','http://ec.gob.sri.ws.autorizacion');
        
        _XMLNode := _XMLRequestDoc.CreateElement('claveAccesoComprobante');
        
        //... No creo que sea el equivalente. Lo probamos......
        //_XMLNode.nodeTypedValue(texPrmClave);
        _XMLNode.InnerText := texPrmClave;
        
        _XMLElement3.AppendChild(_XMLNode);
        _XMLElement2.AppendChild(_XMLElement3);
        _XMLElement1.AppendChild(_XMLElement2);
        _XMLRequestDoc.AppendChild(_XMLElement1);
        
        IF ISNULL(_WinHTTP) THEN
          _WinHTTP := _WinHTTP.XMLHTTPRequestClass;
        
        _WinHTTP.open('POST',texURLAutorizacion,FALSE,'','');
        _WinHTTP.send(_XMLRequestDoc.OuterXml);
        
        SLEEP(500); //+#35029 22.03.2018
        
        //_XMLRequestDoc.save('C:\DYNASOFT\SolicitudAutorizacion.xml');
        ////+#35029 22.03.18
        {
        IF texPrmClave <> '' THEN BEGIN
          lCarpetaLog := '\\SECNAVSQL02\ProduccionFE\Dynasoft';
          IF lFile.OPEN(lCarpetaLog+'\log.txt') THEN BEGIN
            _XMLRequestDoc.Save(lCarpetaLog+'\'+'X'+texPrmClave+'.xml');
            lFile.CLOSE;
          END;
        END;
        }
        //-#35029 22.03.18
        
        
        _XMLResponseDoc := _XMLResponseDoc.XmlDocument;
        _XMLResponseDoc.LoadXml(_WinHTTP.responseText);
        //IF UPPERCASE(USERID) = 'DYNASOFT\JESUS' THEN
        //  XMLResponseDoc.save('C:\temp\RespuestaAutorizacionSRI.xml');
        
        //+#35029 22.03.18
        {
        IF texPrmClave <> '' THEN BEGIN
          lCarpetaLog := '\\SECNAVSQL02\ProduccionFE\Dynasoft';
          IF lFile.OPEN(lCarpetaLog+'\log.txt') THEN BEGIN
            _XMLResponseDoc.Save(lCarpetaLog+'\'+'R'+texPrmClave+'.xml');
            lFile.CLOSE;
          END;
        END;
        }
        //-#35029 22.03.18
        
        IF _WinHTTP.status = 200 THEN BEGIN
        
          //A veces los usuarios envian el comprobante de nuevo aunque ya este autorizado, por eso
          //primero compruebo si se autorizó el comprobnate en alguno de los envios.
        
          CLEAR(texValor);
          _XMLNodeList := _XMLResponseDoc.ChildNodes;
          FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
            _XMLNode := _XMLNodeList.ItemOf(i);
            _ReadChildNodes(_XMLNode,ElementoEstado,'AUTORIZADO');
          END;
          texEstado := texValor;
        
          IF texEstado <> 'AUTORIZADO' THEN BEGIN
            CLEAR(texValor);
            _XMLNodeList := _XMLResponseDoc.ChildNodes;
            FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
              _XMLNode := _XMLNodeList.ItemOf(i);
              _ReadChildNodes(_XMLNode,ElementoEstado,'');
            END;
            texEstado := texValor;
          END;
        
          CASE texEstado OF
            'AUTORIZADO' : BEGIN
        
              texRutaRespuestaSOAP := TraerRutaEnviados + texPrmClave + '.SOAP.xml';
              _XMLResponseDoc.Save(texRutaRespuestaSOAP);
              _DesEncapsular(texRutaRespuestaSOAP,TraerRutaAutorizados + texPrmClave + '.xml');
        
              CLEAR(texValor);
              _XMLNodeList := _XMLResponseDoc.ChildNodes;
              FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
                _XMLNode := _XMLNodeList.ItemOf(i);
                _ReadChildNodes(_XMLNode,ElementoNoAuto,'');
              END;
              texPrmNoAutorizacion := texValor;
        
        
              CLEAR(texValor);
              _XMLNodeList := _XMLResponseDoc.ChildNodes;
              FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
                _XMLNode := _XMLNodeList.ItemOf(i);
                _ReadChildNodes(_XMLNode,ElementoFechaAuto,'');
              END;
              texPrmFechaAuto := FormatFechaHoraXML(texValor);
        
              texPrmRespuesta      := texEstado;
              texPrmInfo           := '';
        
              EXIT(TRUE);
            END;
            'NO AUTORIZADO' : BEGIN
        
              CLEAR(texValor);
              _XMLNodeList := _XMLResponseDoc.ChildNodes;
              FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
                _XMLNode := _XMLNodeList.ItemOf(i);
                _ReadChildNodes(_XMLNode,ElementoMensaje,'');
              END;
              texPrmRespuesta := texValor;
        
              CLEAR(texValor);
              _XMLNodeList := _XMLResponseDoc.ChildNodes;
              FOR i := 0 TO _XMLNodeList.Count - 1 DO BEGIN
                _XMLNode := _XMLNodeList.ItemOf(i);
                _ReadChildNodes(_XMLNode,ElementoInfo,'');
              END;
              texPrmInfo := texValor;
              EXIT(FALSE);
            END;
        //  ELSE
        //    ERROR(Error008);
          END;
        END
        ELSE BEGIN
          texPrmRespuesta := Error001;
          texPrmInfo := '';
          EXIT(FALSE);
        END;
        //fes mig
        *//*

    end;


    procedure _DesEncapsular(texPrmFicheroEntrada: Text[255]; texPrmFicheroSalida: Text[255])
    var
        filEntrada: File;
        filSalida: File;
        chrBuffer: Char;
    begin
        //+#35029
        filEntrada.Open(texPrmFicheroEntrada);

        filSalida.WriteMode(true);
        filSalida.Create(texPrmFicheroSalida);

        filSalida.TextMode(true);
        filSalida.Write('<?xml version="1.0" encoding="utf-8"?>');
        filSalida.TextMode(false);

        filEntrada.Seek(164 + 18);
        while filEntrada.Pos < filEntrada.Len - (68 + 9) do begin
            filEntrada.Read(chrBuffer);
            filSalida.Write(chrBuffer);
        end;

        filEntrada.Close;
        filSalida.Close;

        Erase(texPrmFicheroEntrada);
    end;


    procedure Sincronizacion(pDocumento: Code[20])
    var
        lrLog: Record "Log comprobantes electronicos";
        lFin: Boolean;
        lTimeOut: Boolean;
        lMomentoInicial: DateTime;
        lTiempoTranscurrido: Integer;
        lSegundosEspera: Integer;
    begin
        //+#35029
        //... Se comprueba que el último registro en el LOG no sea Generacion o firmado. En ese caso, provocamos una espera con un TIMEOUT.
        //... Si el último registro del LOG  es Generacion o Firmado es porque otro proceso está tratando el mismo documento.
        //... Este método de sincronización puede ser insuficiente, ya se verá. De momento, como su implementación es sencilla, se prueba.
        //... El motivo de esta función es intentar evitar el error de ERROR CLAVE REGISTRADA.

        lTimeOut := false;
        lMomentoInicial := CurrentDateTime;
        lSegundosEspera := 10;

        repeat
            lFin := true;

            lrLog.Reset;
            lrLog.SetCurrentKey("Tipo documento", "No. documento", lrLog."No. mov.");
            lrLog.SetRange("No. documento", pDocumento);
            if lrLog.FindLast then
                if (lrLog.Estado = lrLog.Estado::Generado) or (lrLog.Estado = lrLog.Estado::Firmado) then begin
                    lFin := false;
                    Sleep(1000);
                end;

            lTiempoTranscurrido := CurrentDateTime - lMomentoInicial;
            if lTiempoTranscurrido > (lSegundosEspera * 1000) then
                lTimeOut := true;

        until lFin or lTimeOut;
    end;
}*/

