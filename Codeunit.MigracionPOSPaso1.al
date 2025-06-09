codeunit 80001 "Migracion POS Paso 1"
{

    trigger OnRun()
    begin
        TraspasarDatosATemp;
    end;

    var
        Text001: Label 'Copiando datos en tablas temporales migración';
        Text002: Label '########################################1\\';
        Text003: Label '########################################2\';
        Text004: Label '########################################3';


    procedure TraspasarDatosATemp()
    var
        recCustomer: Record Customer;
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesInvoiceLine: Record "Sales Invoice Line";
        recSalesMemoHeader: Record "Sales Cr.Memo Header";
        recSalesMemoLine: Record "Sales Cr.Memo Line";
        recConfiguracionTPV: Record "Configuracion General DsPOS";
        recGrupoCajeros: Record "Configuracion TPV";
        recUsuariosTPV: Record "Usuarios TPV";
        recTPV: Record Tiendas;
        recTiendas: Record "Bancos tienda";
        recDimAlmacen: Record Cajeros;
        recMenuVentasTPV: Record "Menu ventas TPV";
        recBotones: Record "Grupos Cajeros";
        recAcciones: Record "Log procesos TPV";
        recColores: Record "Menus TPV";
        recClientesTPV: Record "Clinetes TPV";
        recProductosTPV: Record Botones;
        recSalesHeaderPOS: Record Acciones;
        recSalesLinePOS: Record "Formas de Pago";
        recFormasPagoTPV: Record "Formas de Pago TPV";
        recPagosTPV: Record "Tipos de Tarjeta";
        recSolicitudEtiquetas: Record Vendedores;
        recConfRutas: Record "Conf. Rutas Imp/Exp. Ventas";
        recCedulasRUCs: Record "Cedulas/RUC";
        recTMPCustomer: Record "MIG Customer";
        recTMPSalesHeader: Record "MIG Sales Header";
        recTMPSalesLine: Record "MIG Sales Line";
        recTMPSalesInvoiceHeader: Record "MIG Sales Invoice Header";
        recTMPSalesInvoiceLine: Record "MIG Sales Invoice Line";
        recTMPSalesMemoHeader: Record "MIG Sales Cr.Memo Header";
        recTMPSalesMemolLine: Record "MIG Sales Cr.Memo Line";
        recTMPConfiguracionTPV: Record "MIG Configuracion TPV";
        recTMPGrupoCajeros: Record "MIG Grupo cajeros";
        recTMPUsuariosTPV: Record "MIG Usuarios TPV";
        recTMPTPV: Record "MIG TPV";
        recTMPTiendas: Record "MIG Tiendas";
        recTMPDimAlmacen: Record "MIG Dim. por Def. Almacen";
        recTMPMenuVentasTPV: Record "MIG Menu ventas TPV";
        recTMPBotones: Record "MIG Botones";
        recTMPAcciones: Record "MIG Acciones";
        recTMPColores: Record "MIG Colores";
        recTMPClientesTPV: Record "MIG Clientes TPV";
        recTMPProductosTPV: Record "MIG Productos TPV";
        recTMPSalesHeaderPOS: Record "MIG Sales Header POS";
        recTMPSalesLinePOS: Record "MIG Sales Line POS";
        recTMPFormasPagoTPV: Record "MIG Formas de Pago TPV";
        recTMPPagosTPV: Record "MIG Pagos TPV";
        recTMPDocumentDimensionPOS: Record "MIG Document Dimension POS";
        recTMPSolicitudEtiquetas: Record "MIG Solicitud de etiquetas";
        recTMPConfRutas: Record "MIG Conf. Rutas";
        recTMPCedulasRUCs: Record "MIG Cedulas/RUCs";
        dlgProgreso: Dialog;
        intProcesados: Integer;
        intTotal: Integer;
    begin
        /*//fes mig
        dlgProgreso.OPEN(Text002+Text003+Text004);
        dlgProgreso.UPDATE(1, Text001);
        
        
        WITH recCustomer DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
        
              recTMPCustomer.INIT;
              recTMPCustomer.TRANSFERFIELDS(recCustomer);
              recTMPCustomer.INSERT;
        
              CLEAR("Permite venta a credito");
              CLEAR("Colegio por defecto POS");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
        
          END;
        END;
        
        WITH recSalesHeader DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPSalesHeader.INIT;
              recTMPSalesHeader.TRANSFERFIELDS(recSalesHeader);
              recTMPSalesHeader.INSERT;
        
              CLEAR("ID Cajero");
              CLEAR("Hora creacion");
              CLEAR("Tipo pedido");
              CLEAR(TPV);
              CLEAR("Factura comprimida");
              CLEAR("Venta a credito");
              CLEAR("Importe a liquidar");
              CLEAR(Tienda);
              CLEAR("Forma de Pago TPV");
              CLEAR("Pedidos TPV sin lineas");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
        
          END;
        END;
        
        WITH recSalesLine DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPSalesLine.INIT;
              recTMPSalesLine.TRANSFERFIELDS(recSalesLine);
              recTMPSalesLine.INSERT;
        
              CLEAR("Anulada en TPV");
              CLEAR("Precio anulacion TPV");
              CLEAR("Cantidad anulacion TPV");
              CLEAR("Cantidad agregada");
              CLEAR("Cod. Vendedor");
              CLEAR("Tipo Documento Replicador");
              CLEAR("No. Pedido Replicador");
              CLEAR("Cantidad 1 Replicador");
              CLEAR("Cantidad 2 Replicador");
              CLEAR("Cantidad 3 Replicador");
              CLEAR("Cantidad 4 Replicador");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        
        WITH recSalesInvoiceHeader DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
        
              recTMPSalesInvoiceHeader.INIT;
              recTMPSalesInvoiceHeader.TRANSFERFIELDS(recSalesInvoiceHeader);
              recTMPSalesInvoiceHeader.INSERT;
        
        
              CLEAR(Tienda);
              CLEAR("Forma de Pago TPV");
              CLEAR("ID Cajero");
              CLEAR("Hora creacion");
              CLEAR("Tipo pedido");
              CLEAR(TPV);
              CLEAR("Factura comprimida");
              CLEAR("Importe ITBIS Incl.");
              CLEAR("Venta a credito");
              CLEAR("Importe a liquidar");
              CLEAR("Tipo Documento Replicador");
              CLEAR("No. Serie Envio Replicador");
              CLEAR("Anulada TPV");
              CLEAR("No. nota credito TPV");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
        
          END;
        END;
        
        WITH recSalesInvoiceLine DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
        
              recTMPSalesInvoiceLine.INIT;
              recTMPSalesInvoiceLine.TRANSFERFIELDS(recSalesInvoiceLine);
              recTMPSalesInvoiceLine.INSERT;
        
              CLEAR("Anulada en TPV");
              CLEAR("Precio anulacion TPV");
              CLEAR("Cantidad anulacion TPV");
              CLEAR("Cantidad agregada");
              CLEAR("Cod. Vendedor");
              CLEAR("Tipo Documento Replicador");
              CLEAR("No. Pedido Replicador");
              CLEAR("Cantidad 1 Replicador");
              CLEAR("Cantidad 2 Replicador");
              CLEAR("Cantidad 3 Replicador");
              CLEAR("Cantidad 4 Replicador");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
        
          END;
        END;
        
        WITH recSalesMemoHeader DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
        
              recTMPSalesMemoHeader.INIT;
              recTMPSalesMemoHeader.TRANSFERFIELDS(recSalesMemoHeader);
              recTMPSalesMemoHeader.INSERT;
        
              CLEAR(Tienda);
              CLEAR("ID Cajero");
              CLEAR("Hora creacion");
              CLEAR("Tipo pedido");
              CLEAR(TPV);
              CLEAR("Tipo Documento Replicador");
              CLEAR("No. Serie Envio Replicador");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
        
          END;
        END;
        
        
        WITH recSalesMemoLine DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
        
              recTMPSalesMemolLine.INIT;
              recTMPSalesMemolLine.TRANSFERFIELDS(recSalesMemoLine);
              recTMPSalesMemolLine.INSERT;
        
              CLEAR("Tipo Documento Replicador");
              CLEAR("No. Pedido Replicador");
              CLEAR("Cantidad 1 Replicador");
              CLEAR("Cantidad 2 Replicador");
              CLEAR("Cantidad 3 Replicador");
              CLEAR("Cantidad 4 Replicador");
              MODIFY;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
        
          END;
        END;
        
        WITH recConfiguracionTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPConfiguracionTPV.INIT;
              recTMPConfiguracionTPV.TRANSFERFIELDS(recConfiguracionTPV);
              recTMPConfiguracionTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recGrupoCajeros DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPGrupoCajeros.INIT;
              recTMPGrupoCajeros.TRANSFERFIELDS(recGrupoCajeros);
              recTMPGrupoCajeros.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recUsuariosTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPUsuariosTPV.INIT;
              recTMPUsuariosTPV.TRANSFERFIELDS(recUsuariosTPV);
              recTMPUsuariosTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPTPV.INIT;
              recTMPTPV.TRANSFERFIELDS(recTPV);
              recTMPTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
           END;
        END;
        
        WITH recTiendas DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPTiendas.INIT;
              recTMPTiendas.TRANSFERFIELDS(recTiendas);
              recTMPTiendas.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recDimAlmacen DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPDimAlmacen.INIT;
              recTMPDimAlmacen.TRANSFERFIELDS(recDimAlmacen);
              recTMPDimAlmacen.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recMenuVentasTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPMenuVentasTPV.INIT;
              recTMPMenuVentasTPV.TRANSFERFIELDS(recMenuVentasTPV);
              recTMPMenuVentasTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recBotones DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPBotones.INIT;
              recTMPBotones.TRANSFERFIELDS(recBotones);
              recTMPBotones.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recAcciones DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPAcciones.INIT;
              recTMPAcciones.TRANSFERFIELDS(recAcciones);
              recTMPAcciones.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recColores DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPColores.INIT;
              recTMPColores.TRANSFERFIELDS(recColores);
              recTMPColores.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recClientesTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPClientesTPV.INIT;
              recTMPClientesTPV.TRANSFERFIELDS(recClientesTPV);
              recTMPClientesTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recProductosTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPProductosTPV.INIT;
              recTMPProductosTPV.TRANSFERFIELDS(recProductosTPV);
              recTMPProductosTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recSalesHeaderPOS DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPSalesHeaderPOS.INIT;
              recTMPSalesHeaderPOS.TRANSFERFIELDS(recSalesHeaderPOS);
              recTMPSalesHeaderPOS.INSERT;
        
              DELETE;
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recSalesLinePOS DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPSalesLinePOS.INIT;
              recTMPSalesLinePOS.TRANSFERFIELDS(recSalesLinePOS);
              recTMPSalesLinePOS.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recFormasPagoTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPFormasPagoTPV.INIT;
              recTMPFormasPagoTPV.TRANSFERFIELDS(recFormasPagoTPV);
              recTMPFormasPagoTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recPagosTPV DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPPagosTPV.INIT;
              recTMPPagosTPV.TRANSFERFIELDS(recPagosTPV);
              recTMPPagosTPV.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recDocumentDimensionPOS DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPDocumentDimensionPOS.INIT;
              recTMPDocumentDimensionPOS.TRANSFERFIELDS(recDocumentDimensionPOS);
              recTMPDocumentDimensionPOS.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recSolicitudEtiquetas DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPSolicitudEtiquetas.INIT;
              recTMPSolicitudEtiquetas.TRANSFERFIELDS(recSolicitudEtiquetas);
              recTMPSolicitudEtiquetas.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recConfRutas DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPConfRutas.INIT;
              recTMPConfRutas.TRANSFERFIELDS(recConfRutas);
              recTMPConfRutas.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        
        WITH recCedulasRUCs DO BEGIN
          RESET;
          IF FINDSET THEN BEGIN
            dlgProgreso.UPDATE(2, TABLECAPTION);
            intTotal := COUNT;
            intProcesados := 0;
            REPEAT
              recTMPCedulasRUCs.INIT;
              recTMPCedulasRUCs.TRANSFERFIELDS(recCedulasRUCs);
              recTMPCedulasRUCs.INSERT;
        
              DELETE;
        
              intProcesados += 1;
              dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
            UNTIL NEXT = 0;
          END;
        END;
        */
        //fes mig

    end;


    procedure TraerLinProgreso(intPrmProcesados: Integer; intPrmTotal: Integer): Text
    var
        blnMostrar: Boolean;
    begin
        exit(Format(intPrmProcesados) + ' de ' + Format(intPrmTotal));
    end;
}

