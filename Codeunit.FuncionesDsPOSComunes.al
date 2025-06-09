// codeunit 76016 "Funciones DsPOS - Comunes"
// {
//     // #65225  PLB 10/05/2017: Numeradores en DSPOS
//     // #65232  PLB 10/05/2017: Temas Varios DSPOS - Mejoras
//     //         PLB 14/06/2017: Resolver error en el pago de una devolución
//     // 
//     // #90735  RRT 13.09.2017: En vista de varias incidencias ocurridas presuntamente relacionadas con bloqueos de tablas, antes de ejecutar las funciones
//     //         Nueva_venta() y Registro(), se bloqueara una primera tabla, para asegurar que estas operaciones se realizan consecutivamente y no simultaneamente.
//     // 
//     // #88460  RRT 04.10.2017: También se sincronizará la anulación de facturas. Para poder depurar el error, se registrarán los procesos que se vayan realizando.
//     // 
//     // #76946  RRT 26.09.2017: Invocar rutinas para FE, tras registrar una factura o NCR. (GT)
//     // #116527 RRT 25.01.2018: Incluir opcion para seleccionar facturas resguardo en TPV. (GT)          t
//     // 
//     // #120811  RRT  16.02.2018    Intentar evitar saltos de NCF (PY)
//     // 
//     // #121213 RRT 08.03.2018: Modificaciones para intentar prevenir y/o auditar los errores de facturas sin linea.
//     //         Por ello, al igual que en la función de AnularFactura(), se controla mejor el proceso de registro para asegurar que se pueda realizar un Rollback en caso
//     //         de error. También se insertarán puntos de notificación en el Log, para ampliar la información de la actividad de borrado de líneas de factura.
//     // 
//     // #124085 RRT 10.04.2018: Incorporación de los siguientes desarrollos de El Salvador.
//     //         #78451 PLB 12/07/2017: Al contabilizar cobros, pasar la forma de pago y el NIT (VAT No.)
//     //         #82483 PLB 16/08/2017: No. comprobante fiscal en el diario al registrar pago
//     // 
//     // #70132  RRT 03.07.2018: Permitir una NC como medio de pago.
//     // #148711 RRT 10.06.2018: No se permitirán eliminar una línea de venta, si el pedido ya está registrado.
//     // #144756 RRT, 31.0.2018: DSPOS no asigna Cod. Almacen colegio. Se crea un log para saber si se llega a ejecutar la función Actualiza_Venta_Contacto()
//     // #116527 RRT,  07/11/2018: Adaptaciones para unificación de los objetos en todos los paises
//     // #175576 RRT, 25.11.2018: Nueva parametrización para obtener la venta por contacto.
//     // #184407 RRT,04.12.18: Actualización DS-POS. Se han renumerado varios campos que estaban en el rango de objetos comunes DS-POS
//     //         RRT,10.04.2018: Se normaliza el código para llamar al envio electronico, depues de registrar y antes de imprimir el documento.
//     // 
//     // #211509 RRT,08.05.2019: Para facilitar la replicación, se ha creado el campo "Registrado TPV" en las tablas "Lin. Venta" y "Pagos TPV".
//     // #187632 RRT 18.12.2018: Si un documento no ha enviado electronicamente, no puede imprimirse tampoco según el formato electrónico.
//     // #232158 RRT 06.11.2019: Adaptación de los últimos cambios en Guatemala. Se deja #70132 desactivado al ser un desarrollo sólo de Dominicana. Se puede activar fácil.
//     //         RRT 06.11.2019: Modificaciones para nueva versión FE.
//     // #273889 RRT 15.10.2019: La funcion CambiarEstadoRegistro(), se ejecutara despues de la funcion de GuardarVentaTPV(). Nuevos puntos de LOG
//     // #232158 RRT 17.10.2019: En la función AnularFactura(), el valor de "Prices Including VAT" se asignará según el valor del documento anulado.
//     // #308268 RRT 19.03.2020: Costa Rica. Modificacion para que si una factura ya ha sido liquidada, se modifique también el valor del campo "Liquidado TPV".
//     // #328529 RRT 05.08.2020: Información de auditoria para la aplicación de cupones.
//     // #336189 RRT 02.10.2020: Correccion en la firma electronica de un documento DS-POS cuando la tienda es en linea.
//     // #348662 RRT 26.11.2020: Adaptaciones para unificación.
//     // #355717 RRT 31.03.2021: Devoluciones parciales.
//     // #374964 RRT 24.04.2021: Que las NCR se puedan vincular siempre a una forma de pago.
//     // #378479 RRT 06.05.2021: Error en el calculo del importe a cobrar.
//     // #381937 RRT 18.05.2021: Corrección de potenciales errores. Eliminar la sincronización de procesos.
//     // #383107 RRT 24.05.2021: Corrección en el orden de asignación del valor de varios campos al registrar.
//     // #373762 RRT 09.04.2021: Aplicación de descuentos de línea automáticos por forma de pago.
//     // #381937  RRT 31.05.2021: Que la creacion de devolución se vea en el log.

//     Permissions = TableData "Sales Invoice Header" = rimd,
//                   TableData "Sales Cr.Memo Header" = rimd,
//                   TableData "Log procesos TPV" = rimd;
//     TableNo = "Param. CDU DsPOS";

//     trigger OnRun()
//     var
//         optTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
//     begin
//         case Accion of
//             //+#65232
//             //Accion::LiquidarFactura     : LiquidaFacturaTPV(Documento);
//             //Accion::LiquidarNotaCredito : LiquidaNotaCreditoTPV(Documento);
//             Accion::LiquidarFactura:
//                 LiquidaDocumentoTPV(Documento, optTipoDoc::Invoice);
//             Accion::LiquidarNotaCredito:
//                 LiquidaDocumentoTPV(Documento, optTipoDoc::"Credit Memo");
//         //-#65232
//         end;
//     end;

//     var
//         cDominicana: Codeunit "Funciones DsPOS - Dominicana";
//         cBolivia: Codeunit "Funciones DsPOS - Bolivia";
//         cParaguay: Codeunit "Funciones DsPOS - Paraguay";
//         cEcuador: Codeunit "Funciones DsPOS - Ecuador";
//         cGuatemala: Codeunit "Funciones DsPOS - Guatemala";
//         cSalvador: Codeunit "Funciones DsPOS - Salvador";
//         cHonduras: Codeunit "Funciones DsPOS - Honduras";
//         cCostaRica: Codeunit "Funciones DsPOS - Costa Rica";
//         Text010: Label 'No se pudo realizar el envio electrónico del documento %1';
//         wCupon4Log: Code[20];


//     procedure InsertarDimTemp(DimCode: Code[20]; DimValue: Code[20]; var P_recTmpDimEntry: Record "Dimension Set Entry" temporary)
//     var
//         recDimVal: Record "Dimension Value";
//         cDimManag: Codeunit DimensionManagement;
//     begin

//         recDimVal.Get(DimCode, DimValue);
//         P_recTmpDimEntry."Dimension Code" := DimCode;
//         P_recTmpDimEntry."Dimension Value Code" := DimValue;
//         P_recTmpDimEntry."Dimension Value ID" := recDimVal."Dimension Value ID";
//         if P_recTmpDimEntry.Insert then;
//     end;


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; p_Devolucion: Boolean): Text
//     var
//         rSalesHeader: Record "Sales Header";
//         rCajeros: Record Cajeros;
//         rGrupoCajeros: Record "Grupos Cajeros";
//         rDimDefAlmacen: Record "Dimension Defecto Almacen";
//         rAlmacen: Record Location;
//         rTienda: Record Tiendas;
//         rTPV: Record "Configuracion TPV";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         recTmpDimEntry: Record "Dimension Set Entry" temporary;
//         cDimManag: Codeunit DimensionManagement;
//         Error001: Label 'No se ha podido crear el pedido de venta';
//         Text001: Label ' Nº Venta %1';
//         cControl: Codeunit "Control TPV";
//         recControlTPV: Record "Control de TPV";
//         rDimEntry: Record "Dimension Set Entry";
//         Evento: DotNet ;
//         lNumLog: Integer;
//         TextL002: Label 'Esta clave ya ha sido utilizada anteriormente. Hay que revisar la configuración de las series';
//         lTextoError: Text[150];
//         lNotificacion: Text[160];
//     begin
//         //+#90735
//         ControlDeAcceso(p_Tienda, true);
//         //rSalesHeader.LOCKTABLE;
//         //-#90735

//         //+88460
//         lNumLog := IniciarLog(1, p_Tienda, p_IdTPV);
//         //-88460

//         rTienda.Get(p_Tienda);
//         rTPV.Get(p_Tienda, p_IdTPV);
//         rCajeros.Get(p_Tienda, p_Cajero);
//         rGrupoCajeros.Get(p_Tienda, rCajeros."Grupo Cajero");

//         rSalesHeader.Init;
//         if p_Devolucion then begin
//             rSalesHeader.Validate("Document Type", rSalesHeader."Document Type"::"Credit Memo");
//             rSalesHeader."No." := NoSeriesMgt.GetNextNo(rTPV."No. serie notas credito", WorkDate, true);
//             rSalesHeader.Devolucion := true;
//         end
//         else begin
//             rSalesHeader.Validate("Document Type", rSalesHeader."Document Type"::Invoice);
//             rSalesHeader."No." := NoSeriesMgt.GetNextNo(rTPV."No. serie Facturas", WorkDate, true);
//         end;

//         rSalesHeader.Validate("Sell-to Customer No.", rGrupoCajeros."Cliente al contado");

//         rSalesHeader.Validate("Order Date", cControl.DiaAbierto(p_Tienda, p_IdTPV));
//         rSalesHeader.Validate("Posting Date", rSalesHeader."Order Date");
//         rSalesHeader.Validate("Document Date", rSalesHeader."Order Date");
//         rSalesHeader.Validate("Hora creacion", FormatTime(Time));

//         // Si es registro en linea añadimos las dimensiones del alamcen
//         // en caso de ser negativo se recrearan en central en el proceso de registro nocturno
//         if rTienda.Get(rCajeros.Tienda) then
//             if rTienda."Registro En Linea" then begin
//                 if rAlmacen.Get(rTienda."Cod. Almacen") then begin
//                     Clear(recTmpDimEntry);
//                     rDimDefAlmacen.Reset;
//                     rDimDefAlmacen.SetRange("Cod. Almacen", rAlmacen.Code);
//                     if rDimDefAlmacen.FindSet then begin
//                         repeat
//                             InsertarDimTemp(rDimDefAlmacen."Codigo Dimension", rDimDefAlmacen."Valor Dimension", recTmpDimEntry);
//                         until rDimDefAlmacen.Next = 0;

//                         // En caso de que la cabecera ya tuviera dimensiones se las añadimos
//                         if rSalesHeader."Dimension Set ID" <> 0 then begin
//                             rDimEntry.Reset;
//                             rDimEntry.SetRange("Dimension Set ID", rSalesHeader."Dimension Set ID");
//                             if rDimEntry.FindSet then
//                                 repeat
//                                     InsertarDimTemp(rDimEntry."Dimension Code", rDimEntry."Dimension Value Code", recTmpDimEntry);
//                                 until rDimEntry.Next = 0;
//                         end;
//                         rSalesHeader."Dimension Set ID" := cDimManag.GetDimensionSetID(recTmpDimEntry);
//                     end;
//                 end;
//             end;

//         rSalesHeader."Venta TPV" := true;
//         rSalesHeader."ID Cajero" := p_Cajero;
//         rSalesHeader.TPV := p_IdTPV;
//         rSalesHeader."External Document No." := rSalesHeader."No.";
//         rSalesHeader.Tienda := p_Tienda;
//         rSalesHeader.Turno := cControl.TraerTurnoActual(p_Tienda, p_IdTPV, WorkDate);
//         rSalesHeader.Validate("Location Code", rTienda."Cod. Almacen");
//         rSalesHeader.Validate("Currency Code", '');

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := 6;

//         case Pais of
//             1:
//                 Evento.TextoDato7 := cDominicana.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader); // Dominicana
//             2:
//                 cBolivia.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);                         // Bolivia
//             3:
//                 Evento.TextoDato7 := cParaguay.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);   // Paraguay
//             4:
//                 Evento.TextoDato7 := cEcuador.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);     // Ecuador
//             5:
//                 Evento.TextoDato7 := cGuatemala.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);   // Guatemala
//             6:
//                 Evento.TextoDato7 := cSalvador.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);    // Salvador
//             7:
//                 Evento.TextoDato7 := cHonduras.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);    // Honduras
//             9:
//                 Evento.TextoDato7 := cCostaRica.Nueva_Venta(p_Tienda, p_IdTPV, p_Cajero, rSalesHeader);   // Costa Rica
//         end;

//         if rSalesHeader.Insert(false) then begin
//             Evento.TextoDato := rSalesHeader."No.";
//             Evento.TextoDato2 := StrSubstNo('%1', rSalesHeader."Posting Date");
//             Evento.TextoDato3 := rSalesHeader."Sell-to Customer Name";
//             Evento.TextoDato4 := rSalesHeader."VAT Registration No.";
//             Evento.TextoDato5 := rSalesHeader."Sell-to Customer No.";
//             Evento.TextoDato8 := rSalesHeader."Cod. Colegio";
//             Evento.TextoDato9 := rSalesHeader."Nombre Colegio";
//             Evento.TextoRespuesta := StrSubstNo(Text001, rSalesHeader."No.");

//             //+#76946
//             //... Este mensaje se dará en el caso que en el registro del documento anterior, haya habido error en el envío electrónico.
//             rTPV.Get(p_Tienda, p_IdTPV);
//             if rTPV."Texto aviso FE" <> '' then begin
//                 Evento.TextoRespuesta := Evento.TextoRespuesta + '. ' + rTPV."Texto aviso FE";
//                 GrabarTextoAvisoFE(p_Tienda, p_IdTPV, '');
//             end;
//             //-#76946

//             Evento.AccionRespuesta := 'Actualizar_Todo';
//             if not p_Devolucion then
//                 Actualizar_Totales(Evento.TextoDato, Evento, true, p_Devolucion);
//         end
//         else begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := Error001;
//         end;

//         //+#12123
//         lTextoError := CopyStr(Evento.TextoRespuesta, 1, 150);  //+#232158
//         if TestIDYaUtilizado(rSalesHeader, true, lNotificacion) then begin
//             if lTextoError <> '' then
//                 lTextoError := lTextoError + '. ';

//             lTextoError := CopyStr(lTextoError + lNotificacion, 1, 150);
//         end;
//         //-#12123


//         //+88460
//         ModificarDatosLog(lNumLog, 2, rSalesHeader."Document Type", rSalesHeader."No.", rSalesHeader."Posting No.", rSalesHeader."No. Fiscal TPV", rSalesHeader."No. Comprobante Fiscal",
//         //+#12123
//         //                Evento.TextoRespuesta);
//                           lTextoError);
//         //-#12123
//         //-88460



//         //+90735
//         ControlDeAcceso(p_Tienda, false);
//         //-90735

//         if not p_Devolucion then
//             exit(Evento.aXml())
//         else
//             exit(rSalesHeader."No.");
//     end;


//     procedure Buscar_Producto(var p_Producto: Code[20]; var p_Medida: Code[10])
//     var
//         rItemCrossRef: Record "Item Cross Reference";
//         rItem: Record Item;
//         rItemIdentifier: Record "Item Identifier";
//     begin

//         // 1 - Cod. Barras (ref Cruzadas)
//         // 2 - Identificadores
//         // 3 - Codigo producto

//         rItemCrossRef.Reset;
//         rItemCrossRef.SetCurrentKey("Cross-Reference No.");
//         rItemCrossRef.SetRange("Cross-Reference No.", p_Producto);
//         rItemCrossRef.SetRange("Cross-Reference Type", rItemCrossRef."Cross-Reference Type"::"Bar Code");

//         if rItemCrossRef.FindFirst then begin
//             p_Producto := rItemCrossRef."Item No.";
//             p_Medida := rItemCrossRef."Unit of Measure";
//         end
//         else
//             if rItemIdentifier.Get(p_Producto) then begin
//                 p_Producto := rItemIdentifier."Item No.";
//                 if (rItemIdentifier."Unit of Measure Code" = '') then begin
//                     if rItem.Get(p_Producto) then
//                         p_Medida := rItem."Base Unit of Measure"
//                     else
//                         p_Medida := rItemIdentifier."Unit of Measure Code"
//                 end
//                 else
//                     p_Medida := rItemIdentifier."Unit of Measure Code";
//             end
//             else
//                 if rItem.Get(p_Producto) then
//                     p_Medida := rItem."Base Unit of Measure"
//                 else begin
//                     rItem.SetCurrentKey(ISBN);
//                     rItem.SetRange(ISBN, p_Producto);
//                     if rItem.FindFirst then
//                         p_Producto := rItem."No."
//                     else
//                         p_Producto := '';
//                 end;
//     end;


//     procedure Insertar_Producto(p_Producto: Code[20]; p_Tienda: Code[20]; p_IdTPV: Code[20]; p_NumVenta: Code[20]; p_Cantidad: Decimal): Text
//     var
//         rSalesLine: Record "Sales Line";
//         rSalesHeader: Record "Sales Header";
//         rConfTPV: Record "Configuracion TPV";
//         CodProd: Code[20];
//         uMedida: Code[10];
//         NuevaLinea: Boolean;
//         Evento: DotNet ;
//         Error001: Label 'Imposible Modificar Línea de Pedido';
//         Error002: Label 'El Producto %1 No Tiene Precio Configurado';
//         Error003: Label 'Imposible Insertar Línea de Pedido';
//         Error004: Label 'El Producto %1 no existe';
//         rTienda: Record Tiendas;
//         Error005: Label 'El n·mero máximo de líneas (%1) para este pedido se ha superado';
//         Error006: Label 'Se ha producido un error inesperado. Se está intentando modificar una factura ya emitida por el TPV (%1). Por favor, pulse el botón de "Nueva venta".';
//         Text001: Label 'Añadido/s %1 unidad/es del producto %2';
//         dto: Decimal;
//         rSalesH: Record "Sales Header";
//     begin
//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         //+#65232
//         // No podemos permitir que se están creando/modificando líneas de una factura ya registrada en TPV
//         rSalesHeader.Get(rSalesHeader."Document Type"::Invoice, p_NumVenta);
//         if rSalesHeader."Posting No." <> '' then begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(Error006, p_NumVenta);
//             exit(Evento.aXml());
//         end;
//         //-#65232

//         rConfTPV.Get(p_Tienda, p_IdTPV);
//         rTienda.Get(p_Tienda);
//         CodProd := p_Producto;

//         Buscar_Producto(CodProd, uMedida);

//         Evento.TipoEvento := 7;
//         if (CodProd = '') then begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(Error004, p_Producto);
//             exit(Evento.aXml());
//         end;

//         if (rTienda."Agrupar Lineas") then begin
//             rSalesLine.Reset;
//             rSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
//             rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::Invoice);
//             rSalesLine.SetRange("Document No.", p_NumVenta);
//             rSalesLine.SetRange("No.", CodProd);
//             rSalesLine.SetRange("Unit of Measure Code", uMedida);
//             rSalesLine.SetRange("Anulada en TPV", false);
//             if rSalesLine.FindFirst then begin
//                 rSalesLine.Validate(Quantity, rSalesLine.Quantity + p_Cantidad);
//                 if not (rSalesLine.Modify(false)) then begin
//                     Evento.AccionRespuesta := 'ERROR';
//                     Evento.TextoRespuesta := Error001;
//                 end;
//             end
//             else
//                 NuevaLinea := true;
//         end;

//         if ((not rTienda."Agrupar Lineas") or NuevaLinea) then begin

//             if rTienda."No. Maximo de Lineas" > 0 then begin
//                 rSalesLine.Reset;
//                 rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::Invoice);
//                 rSalesLine.SetRange("Document No.", p_NumVenta);

//                 if rSalesLine.Count >= rTienda."No. Maximo de Lineas" then begin
//                     Evento.AccionRespuesta := 'ERROR';
//                     Evento.TextoRespuesta := StrSubstNo(Error005, rTienda."No. Maximo de Lineas");
//                     exit(Evento.aXml());
//                 end;
//             end;

//             rSalesLine.Init;
//             rSalesLine.Validate("Document Type", rSalesLine."Document Type"::Invoice);
//             rSalesLine.Validate("Document No.", p_NumVenta);
//             rSalesLine.Validate("Line No.", SigNoLinea(p_NumVenta));
//             rSalesLine.Validate(Type, rSalesLine.Type::Item);
//             rSalesLine.Validate("No.", CodProd);
//             rSalesLine.Validate("Unit of Measure Code", uMedida);
//             rSalesLine.Validate(Quantity, p_Cantidad);

//             rSalesH.Get(rSalesLine."Document Type", rSalesLine."Document No.");
//             rSalesLine.Validate("Location Code", rSalesH."Location Code");

//             if not rSalesLine.Insert(false) then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 Evento.TextoRespuesta := Error003;
//             end;

//         end;

//         if Evento.AccionRespuesta <> 'ERROR' then begin
//             Evento.TextoDato2 := CodProd;
//             Evento.TextoRespuesta := StrSubstNo(Text001, p_Cantidad, p_Producto);
//             Evento.AccionRespuesta := 'Actualizar_Lineas';
//             Actualizar_Totales(p_NumVenta, Evento, false, false);
//         end;

//         exit(Evento.aXml());
//     end;


//     procedure Ejecutar_Accion(p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         rAccion: Record Acciones;
//         rLinPed: Record "Sales Line";
//         Error: Boolean;
//         Mensaje: array[2] of Text;
//         Text001: Label 'Linea eliminada Correctamente';
//         Text002: Label 'Cantidad modificada Correctamente';
//         Text003: Label 'Descuento en Linea Aplicado Correctamente';
//         Text004: Label 'Precio Modificado Correctamente';
//         Text005: Label 'Descuento General Aplicado Correctamente';
//         Text006: Label 'Venta Correctamente Archivada';
//         Text007: Label 'Exención de IVA añadido correctamente';
//         Error001: Label 'No ha sido posible borrar la linea Seleccionada';
//         Error002: Label 'Imposible Modificar Línea de Pedido';
//         Error003: Label 'No se encuentra la línea de Pedido';
//         Error004: Label 'No se encuentra el pedido';
//         rCabFac: Record "Sales Header";
//         Error005: Label 'No se encuentra la venta a archivar';
//         i: Integer;
//         Text008: Label 'Especifique cuenta de Exención de IVA para la Tienda %1';
//         rTienda: Record Tiendas;
//         lcFunciones: Codeunit "Funciones Addin DSPos";
//         lNotificar: Boolean;
//         TextL001: Label 'Intentelo en unos segundos';
//         lSeguir: Boolean;
//         lrCV: Record "Sales Header";
//         Error006: Label 'Esta línea de pedido corresponde a un pedido registrado y no deberá visualizarse. Por favor, salga de la pantalla de ventas y vuelva a entrar.';
//         Error007: Label 'La cantidad máxima que puede devolver es %1';
//         lOk: Boolean;
//         lEsDevolucion: Boolean;
//         lPrecioAnterior: Decimal;
//         lCantidadOriginal: Decimal;
//         lCantidadYaDevuelta: Decimal;
//         Error008: Label 'No se ha podido determinar la cantidad ya devuelta. Avise al departamento de sistemas';
//         lDtoAnterior: Decimal;
//         lDtoAutoAnterior: Decimal;
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := p_Evento.TipoEvento;

//         //+#355717
//         lEsDevolucion := false;
//         //-#355717

//         if rAccion.Get(p_Evento.TextoDato4) then begin
//             case p_Evento.TextoDato4 of

//                 'EXIVA':
//                     begin

//                         rTienda.Get(p_Evento.TextoDato);

//                         if rTienda."Cuenta Excencion IVA" = '' then begin
//                             Error := true;
//                             Evento.AccionRespuesta := 'ERROR';
//                             Mensaje[1] := StrSubstNo(Text008, p_Evento.TextoDato);
//                         end
//                         else begin
//                             Insertar_Pago(p_Evento);
//                             Mensaje[1] := Text007;
//                             Mensaje[2] := 'Actualizar_Pagos';
//                         end;

//                     end;

//                 'ANULARLINEA':
//                     begin
//                         for i := 1 to p_Evento.IntDato1 do begin
//                             rLinPed.Reset;
//                             if not (rLinPed.Get(rLinPed."Document Type"::Invoice, p_Evento.TextoDato3, SelectStr(i, p_Evento.TextoDato6))) then begin
//                                 Error := true;
//                                 Mensaje[1] := Error003;
//                             end
//                             else begin

//                                 //+#148711
//                                 //... Si el pedido ya esta registrado, se está visualizando por error.
//                                 //... Por ello, se indicará que la linea no se puede eliminar, y que hay que salir de la pantalla.
//                                 lSeguir := true;
//                                 if lrCV.Get(rLinPed."Document Type", rLinPed."Document No.") then begin
//                                     if lrCV."Registrado TPV" then begin
//                                         Error := true;
//                                         Mensaje[1] := Error006;
//                                         lSeguir := false;
//                                     end;
//                                 end;

//                                 //-#148711
//                                 if lSeguir then begin //#+148711

//                                     if not rLinPed.Delete(true) then begin
//                                         Error := true;
//                                         Mensaje[1] := Error001;
//                                     end
//                                     else begin
//                                         Mensaje[1] := Text001;
//                                         Mensaje[2] := 'Actualizar_Lineas';
//                                     end;
//                                 end; //-#148711
//                             end;
//                         end;
//                     end;


//                 'CAMBCANT':
//                     begin
//                         for i := 1 to p_Evento.IntDato1 do begin
//                             lOk := false;
//                             if not (rLinPed.Get(rLinPed."Document Type"::Invoice, p_Evento.TextoDato3, SelectStr(i, p_Evento.TextoDato6))) then begin
//                                 //+#355717
//                                 if not (rLinPed.Get(rLinPed."Document Type"::"Credit Memo", p_Evento.TextoDato3, SelectStr(i, p_Evento.TextoDato6))) then begin
//                                     Error := true;
//                                     Mensaje[1] := Error003;
//                                 end
//                                 else begin
//                                     lEsDevolucion := true;
//                                     lCantidadOriginal := -1;
//                                     lCantidadYaDevuelta := -1;
//                                     if not ObtenerCantidadYaDevuelta(rLinPed, lCantidadOriginal, lCantidadYaDevuelta) then begin
//                                         Error := true;
//                                         Mensaje[1] := StrSubstNo(Error008);
//                                     end
//                                     else begin
//                                         if lCantidadOriginal < (lCantidadYaDevuelta + p_Evento.DatoDecimal) then begin
//                                             Error := true;
//                                             Mensaje[1] := StrSubstNo(Error007, lCantidadOriginal - lCantidadYaDevuelta);
//                                         end
//                                         else
//                                             lOk := true;
//                                     end;
//                                 end;
//                                 //-#355717
//                             end
//                             else
//                                 lOk := true;

//                             //+#355717 -> Se han hecho modificaciones en el siguiente bloque por las devoluciones parciales.
//                             if lOk then begin
//                                 lPrecioAnterior := rLinPed."Unit Price";

//                                 //+#373762
//                                 lDtoAnterior := rLinPed."Line Discount %";
//                                 lDtoAutoAnterior := rLinPed."% Dto por forma de pago";
//                                 //-#373762

//                                 rLinPed.Validate(Quantity, p_Evento.DatoDecimal);

//                                 //... De momento sólo para la devolución.
//                                 if lEsDevolucion then begin
//                                     rLinPed.Validate("Unit Price", lPrecioAnterior);

//                                     //+#373762
//                                     rLinPed.Validate("Line Discount %", lDtoAnterior);
//                                     rLinPed.Validate("% Dto por forma de pago", lDtoAutoAnterior);
//                                     //-#373762

//                                 end;

//                                 if not rLinPed.Modify(false) then begin
//                                     Error := true;
//                                     Mensaje[1] := Error002;
//                                 end
//                                 else begin
//                                     Mensaje[1] := Text002;
//                                     Mensaje[2] := 'Actualizar_Lineas';
//                                 end;
//                             end;
//                         end;
//                     end;

//                 'DTOLINEA':
//                     begin
//                         for i := 1 to p_Evento.IntDato1 do begin
//                             rLinPed.Reset;
//                             if not (rLinPed.Get(rLinPed."Document Type"::Invoice, p_Evento.TextoDato3, SelectStr(i, p_Evento.TextoDato6))) then begin
//                                 Error := true;
//                                 Mensaje[1] := Error003;
//                             end
//                             else begin
//                                 rLinPed.Validate("Line Discount %", p_Evento.DatoDecimal);
//                                 if not rLinPed.Modify(false) then begin
//                                     Error := true;
//                                     Mensaje[1] := Error002;
//                                 end
//                                 else begin
//                                     Mensaje[1] := Text003;
//                                     Mensaje[2] := 'Actualizar_Lineas';
//                                 end;
//                             end;
//                         end;
//                     end;

//                 'CAMBPREC':
//                     begin
//                         for i := 1 to p_Evento.IntDato1 do begin
//                             rLinPed.Reset;
//                             if not (rLinPed.Get(rLinPed."Document Type"::Invoice, p_Evento.TextoDato3, SelectStr(i, p_Evento.TextoDato6))) then begin
//                                 Error := true;
//                                 Mensaje[1] := Error003;
//                             end
//                             else begin
//                                 rLinPed.Validate("Unit Price", p_Evento.DatoDecimal);
//                                 if not rLinPed.Modify(false) then begin
//                                     Error := true;
//                                     Mensaje[1] := Error002;
//                                 end
//                                 else begin
//                                     Mensaje[1] := Text004;
//                                     Mensaje[2] := 'Actualizar_Lineas';
//                                 end;
//                             end;
//                         end;
//                     end;

//                 'REGISTRAR':
//                     begin
//                         //+#121213
//                         //... De momento el seguimiento se realiza sólo en el caso en que el registro se realice en una BD que no sea Central.
//                         //... Cuando el registro es en linea se realizan COMMITs que quita el sentido a esta prevención.
//                         //  Error := NOT((Registrar(p_Evento,Evento)));

//                         lNotificar := true;
//                         if RegistroEnLinea(p_Evento.TextoDato) then begin
//                             Error := not ((Registrar(p_Evento, Evento)));

//                             //+#355717
//                             if not Error then
//                                 Commit;
//                             //-#355717

//                         end
//                         else begin
//                             Commit; //+#232158

//                             ClearLastError;
//                             lcFunciones.SetParameters(p_Evento, Evento);
//                             if not lcFunciones.Run then begin
//                                 //... Debemos llegar aquí en caso de error.
//                                 lNotificar := false;
//                                 if GetLastErrorText <> '' then begin
//                                     RegistrarError(0, p_Evento.TextoDato, p_Evento.TextoDato2, p_Evento.TextoDato3, GetLastErrorText);
//                                     //+#232158
//                                     Message(GetLastErrorText);
//                                     //MESSAGE(GETLASTERRORTEXT+'. '+TextL001);
//                                     //-#232158

//                                 end;
//                             end
//                             else begin
//                                 lcFunciones.GetParameters(p_Evento, Evento, Error);
//                                 Error := not Error;
//                             end;

//                         end;
//                         //-#121213

//                         if lNotificar then begin //+#121213
//                             Mensaje[1] := Evento.TextoRespuesta;
//                             Mensaje[2] := Evento.AccionRespuesta;

//                             if not Error then begin
//                                 AntesDeImprimir(Evento.TextoDato4);  //+#184407
//                                 Imprimir(p_Evento.TextoDato, Evento.TextoDato4);
//                             end;
//                         end;  //+#121213

//                     end;

//                 'CUPON':
//                     begin

//                         case Pais of
//                             1:
//                                 cDominicana.Ejecutar_Accion(p_Evento, Evento);
//                             2:
//                                 cBolivia.Ejecutar_Accion(p_Evento, Evento);
//                             3:
//                                 cParaguay.Ejecutar_Accion(p_Evento, Evento);
//                             4:
//                                 cEcuador.Ejecutar_Accion(p_Evento, Evento);
//                             5:
//                                 cGuatemala.Ejecutar_Accion(p_Evento, Evento);
//                             6:
//                                 cSalvador.Ejecutar_Accion(p_Evento, Evento);
//                             7:
//                                 cHonduras.Ejecutar_Accion(p_Evento, Evento);
//                             9:
//                                 cCostaRica.Ejecutar_Accion(p_Evento, Evento);  //+#148807
//                         end;

//                         Error := (Evento.TextoRespuesta = 'ERROR');
//                         Mensaje[1] := Evento.TextoRespuesta;
//                         Mensaje[2] := Evento.AccionRespuesta;

//                     end;


//                 'ELIMINARCUPON':
//                     begin

//                         case Pais of
//                             1:
//                                 cDominicana.Ejecutar_Accion(p_Evento, Evento);
//                             2:
//                                 cBolivia.Ejecutar_Accion(p_Evento, Evento);
//                             3:
//                                 cParaguay.Ejecutar_Accion(p_Evento, Evento);
//                             4:
//                                 cEcuador.Ejecutar_Accion(p_Evento, Evento);
//                             5:
//                                 cGuatemala.Ejecutar_Accion(p_Evento, Evento);
//                             6:
//                                 cSalvador.Ejecutar_Accion(p_Evento, Evento);
//                             7:
//                                 cHonduras.Ejecutar_Accion(p_Evento, Evento);
//                             9:
//                                 cCostaRica.Ejecutar_Accion(p_Evento, Evento);  //+#148807
//                         end;

//                         Error := (Evento.TextoRespuesta = 'ERROR');
//                         Mensaje[1] := Evento.TextoRespuesta;
//                         Mensaje[2] := Evento.AccionRespuesta;

//                     end;


//                 'DTOGENERAL':
//                     begin
//                         rLinPed.Reset;
//                         rLinPed.SetRange("Document Type", rLinPed."Document Type"::Invoice);
//                         rLinPed.SetRange("Document No.", p_Evento.TextoDato3);
//                         if not (rLinPed.FindFirst) then begin
//                             Error := true;
//                             Mensaje[1] := Error003;
//                         end
//                         else begin
//                             repeat
//                                 rLinPed.Validate("Line Discount %", p_Evento.DatoDecimal);
//                                 if not rLinPed.Modify(false) then begin
//                                     Error := true;
//                                     Mensaje[1] := Error002;
//                                 end
//                             until rLinPed.Next = 0;
//                             Mensaje[1] := Text005;
//                             Mensaje[2] := 'Actualizar_Todo';
//                         end;
//                     end;

//                 'APARCARPEDIDO':
//                     begin

//                         rCabFac.Reset;

//                         if rCabFac.Get(rCabFac."Document Type"::Invoice, p_Evento.TextoDato3) then begin

//                             rCabFac.Aparcado := true;
//                             rCabFac.Modify(false);

//                             case Pais of
//                                 1:
//                                     cDominicana.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 2:
//                                     cBolivia.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 3:
//                                     cParaguay.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 4:
//                                     cEcuador.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 5:
//                                     cGuatemala.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 6:
//                                     cSalvador.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 7:
//                                     cHonduras.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);
//                                 9:
//                                     cCostaRica.Guardar_Datos_Aparcados(p_Evento.TextoDato3, p_Evento);  //+#148807
//                             end;

//                             Mensaje[1] := Text006;
//                             Mensaje[2] := 'Nueva_Venta';

//                         end
//                         else begin

//                             Error := true;
//                             Mensaje[1] := Error005;

//                         end;
//                     end;

//             end;

//             Evento.TextoRespuesta := Mensaje[1];
//             if Error then
//                 Evento.AccionRespuesta := 'ERROR'
//             else begin
//                 Evento.AccionRespuesta := Mensaje[2];
//                 Actualizar_Totales(p_Evento.TextoDato3, Evento, false, lEsDevolucion);
//             end;
//         end;

//         exit(Evento.aXml());
//     end;


//     procedure Insertar_Pago(var p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         rPagos: Record "Pagos TPV";
//         rfPago: Record "Formas de Pago";
//         Text001: Label 'Linea de Pago insertada Correctamente';
//         rTarj: Record "Tipos de Tarjeta";
//         Text002: Label 'No existe %1 ni como forma de pago ni como tipo de tarjeta';
//         EsDevolucion: Boolean;
//         rCab: Record "Sales Header";
//         decImportes: array[10] of Decimal;
//         exacto: Boolean;
//         Documento: Code[20];
//         lPais: Integer;
//         lcDominicana: Codeunit "Funciones DsPOS - Dominicana";
//         lDocNCRPago: Code[20];
//         lrFP: Record "Formas de Pago";
//         lcEcuador: Codeunit "Funciones DsPOS - Ecuador";
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := p_Evento.TipoEvento;
//         Documento := p_Evento.TextoDato3;

//         //+#70132
//         //... En los parametros debemos poder obtener el NCR de pago. He visto que TextoData7 estaba libre.
//         lDocNCRPago := '';
//         if lrFP.Get(p_Evento.TextoDato4) then
//             if lrFP."Tipo Compensacion NC" = lrFP."Tipo Compensacion NC"::"Sí" then
//                 if p_Evento.TextoDato8 <> '' then
//                     lDocNCRPago := p_Evento.TextoDato7;
//         lPais := Pais;
//         //-#70132

//         EsDevolucion := rCab.Get(rCab."Document Type"::"Credit Memo", Documento);
//         //+#65232
//         if not EsDevolucion then
//             rCab.Get(rCab."Document Type"::Invoice, Documento);
//         //-#65232


//         case p_Evento.TextoDato6 of
//             'DSPOS_EXACTO':
//                 begin
//                     exacto := true;
//                     rPagos.Reset;
//                     rPagos.SetRange("No. Borrador", p_Evento.TextoDato3);
//                     rPagos.SetFilter(rPagos."Forma pago TPV", '<>EXIVA');
//                     if rPagos.FindSet then
//                         rPagos.DeleteAll;
//                     //+#65232
//                     //IF NOT(EsDevolucion) THEN
//                     //  rCab.GET(rCab."Document Type"::Invoice, p_Evento.TextoDato3);
//                     //-#65232
//                     ActValoresTPV(rCab, decImportes[1], decImportes[2], decImportes[3], decImportes[4], decImportes[5], decImportes[6], decImportes[7]);
//                     p_Evento.TextoDato4 := Efectivo_Local;
//                 end;
//             'DSPOS_EFECTIVO':
//                 p_Evento.TextoDato4 := Efectivo_Local;
//         end;

//         rTarj.Init;
//         if not rfPago.Get(p_Evento.TextoDato4) then
//             if not rTarj.Get(p_Evento.TextoDato4) then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 Evento.TextoRespuesta := StrSubstNo(Text002, p_Evento.TextoDato4);
//             end;

//         with rPagos do begin

//             // Obtener datos de Sales Header
//             //rCab.GET(rCab."Document Type"::Invoice, p_Evento.TextoDato3); //-#65232
//             rCab.CalcFields(Amount);
//             rCab.CalcFields("Amount Including VAT");

//             Reset;
//             if not Get(p_Evento.TextoDato3, p_Evento.TextoDato4, false) then begin

//                 // Modificar registro
//                 "Tipo Tarjeta" := rTarj.Codigo;
//                 Validate("Forma pago TPV", p_Evento.TextoDato4);
//                 Fecha := WorkDate;
//                 "No. Borrador" := p_Evento.TextoDato3;
//                 Tienda := p_Evento.TextoDato;
//                 TPV := p_Evento.TextoDato2;

//                 if p_Evento.TextoDato4 = 'EXIVA' then begin
//                     Validate(Importe, (rCab."Amount Including VAT" - rCab.Amount));
//                     "No. Documento Exencion" := p_Evento.TextoDato6;
//                 end
//                 else
//                     if exacto then
//                         Validate(Importe, decImportes[5])
//                     else
//                         Validate(Importe, p_Evento.DatoDecimal);

//                 if Evento.AccionRespuesta <> 'ERROR' then begin
//                     Cajero := p_Evento.TextoDato5;
//                     Hora := FormatTime(Time);
//                     Cambio := false;

//                     //+#70132
//                     case lPais of
//                         //Dominicana
//                         1:
//                             lcDominicana.ActDatosPagoPorCompensacion(lDocNCRPago, rPagos);
//                     end;
//                     //-#70132

//                     Insert;
//                 end;

//             end
//             else begin

//                 if p_Evento.TextoDato4 = 'EXIVA' then begin
//                     Validate(Importe, (rCab."Amount Including VAT" - rCab.Amount));
//                     "No. Documento Exencion" := p_Evento.TextoDato6;
//                 end
//                 else
//                     Validate(Importe, p_Evento.DatoDecimal);

//                 Hora := FormatTime(Time);

//                 //+#70132
//                 case lPais of
//                     //Dominicana
//                     1:
//                         lcDominicana.ActDatosPagoPorCompensacion(lDocNCRPago, rPagos);
//                 end;
//                 //-#70132

//                 Modify;

//             end;
//         end;


//         if Evento.AccionRespuesta <> 'ERROR' then begin
//             Evento.AccionRespuesta := 'Actualizar_Pagos';

//             Evento.TextoRespuesta := Text001;
//             Actualizar_Totales(p_Evento.TextoDato3, Evento, false, EsDevolucion);
//         end;

//         exit(Evento.aXml());
//     end;


//     procedure Eliminar_Pago(var p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         rPagosTPV: Record "Pagos TPV";
//         Text001: Label 'Pago %1 Eliminado Correctamente';
//         Text002: Label 'Pago %1 NO Encontrado';
//         EsDevolucion: Boolean;
//         rCab: Record "Sales Header";
//         lActualizarTodo: Boolean;
//         lcEcuador: Codeunit "Funciones DsPOS - Ecuador";
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := p_Evento.TipoEvento;

//         EsDevolucion := rCab.Get(rCab."Document Type"::"Credit Memo", p_Evento.TextoDato3);

//         rPagosTPV.Reset;
//         if rPagosTPV.Get(p_Evento.TextoDato3, p_Evento.TextoDato4, false) then begin
//             rPagosTPV.Delete(false);

//             //+#373762
//             //... Tras eliminar un pago, si este pago va ligado a un descuento por pago, quizás haya que actualizar toda la pantalla.
//             lActualizarTodo := false;
//             case Pais of
//                 4:
//                     lActualizarTodo := lcEcuador.ExistenDescuentosPorFormaPago(EsDevolucion, p_Evento.TextoDato3, p_Evento.TextoDato4);
//             end;
//             //-#373762

//             Evento.AccionRespuesta := 'Actualizar_Pagos';

//             //+#373762
//             if lActualizarTodo then
//                 Evento.AccionRespuesta := 'Actualizar_Todo';
//             //-#373762

//             Evento.TextoRespuesta := StrSubstNo(Text001, p_Evento.TextoDato4);
//             Actualizar_Totales(p_Evento.TextoDato3, Evento, false, EsDevolucion);
//         end
//         else begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(Text002, p_Evento.TextoDato4);
//         end;

//         exit(Evento.aXml());
//     end;


//     procedure Registrar(var p_Evento: DotNet ; var p_Resultado: DotNet ): Boolean
//     var
//         recTienda: Record Tiendas;
//         rCab: Record "Configuracion General DsPOS";
//         rSalesH: Record "Sales Header";
//         rCust: Record Customer;
//         recLinVta: Record "Sales Line";
//         wApagar: Decimal;
//         Error001: Label 'Fecha de registro debe ser igual a la fecha del día';
//         Error002: Label 'Debe Especificar Nº de Identificación Fiscal';
//         Error003: Label 'ORDER WITH REMAINING AMOUNT';
//         Error004: Label 'ORDER WITH REMAINING AMOUNT';
//         Error005: Label 'ORDER WITH REMAINING AMOUNT';
//         Error006: Label 'Imposible Modificar Registro';
//         Error007: Label 'La línea de Venta %1 no tiene asignado precio.';
//         Text001: Label 'Factura %1 Registrada Correctamente';
//         cComunes: Codeunit "Funciones DsPOS - Comunes";
//         recParam: Record "Param. CDU DsPOS";
//         texto: Text;
//         recTPV: Record "Configuracion TPV";
//         rHistFact: Record "Sales Invoice Header";
//         Text005: Label 'Devolucion %1 Registrada Correctamente';
//         cRegistro: Codeunit "Registrar Ventas en Lote DsPOS";
//         cControl: Codeunit "Control TPV";
//         Es_NotaCr: Boolean;
//         lNumLog: Integer;
//         lTextoAviso: Text[1024];
//         lMensajeError: Text[1024];
//         lcGuatemala: Codeunit "Funciones DsPOS - Guatemala";
//     begin
//         //+#90735
//         ControlDeAcceso(p_Evento.TextoDato, true);
//         //-#90735

//         rSalesH.Reset;

//         //+#65232
//         //IF NOT rSalesH.GET(rSalesH."Document Type"::Invoice, p_Evento.TextoDato3) THEN
//         //Es_Devolucion := rSalesH.GET(rSalesH."Document Type"::"Credit Memo", p_Evento.TextoDato3);
//         if not rSalesH.Get(rSalesH."Document Type"::Invoice, p_Evento.TextoDato3) then begin
//             Es_NotaCr := rSalesH.Get(rSalesH."Document Type"::"Credit Memo", p_Evento.TextoDato3);
//             if not Es_NotaCr then begin
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                 p_Resultado.TextoRespuesta := Error004;
//                 exit(false);
//             end;
//         end;
//         //-#65232

//         recTPV.Get(p_Evento.TextoDato, p_Evento.TextoDato2);

//         with rSalesH do begin
//             //+#65232
//             //SalesLine.RESET;
//             //SalesLine.SETRANGE("Document Type" , rSalesH."Document Type");
//             //SalesLine.SETRANGE("Document No."  , rSalesH."No.");
//             //IF SalesLine.FINDSET THEN
//             //  REPEAT
//             //    IF SalesLine."Unit Price" = 0 THEN BEGIN
//             //      p_Resultado.TextoRespuesta := STRSUBSTNO(Error007,SalesLine."Line No.");
//             //      EXIT(FALSE);
//             //    END;
//             //  UNTIL SalesLine.NEXT = 0;
//             recLinVta.Reset;
//             recLinVta.SetRange("Document Type", "Document Type");
//             recLinVta.SetRange("Document No.", "No.");
//             recLinVta.SetFilter(Quantity, '<>0');
//             if recLinVta.IsEmpty then begin
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                 p_Resultado.TextoRespuesta := Error004 + ' 1!!';
//                 exit(false);
//             end;

//             recLinVta.SetRange(Quantity);
//             recLinVta.SetRange("Unit Price", 0);
//             if recLinVta.FindFirst then begin
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                 p_Resultado.TextoRespuesta := StrSubstNo(Error007, recLinVta."Line No.");
//                 exit(false);
//             end;
//             recLinVta.SetRange("Unit Price");
//             //-#65232

//             if "VAT Registration No." = '' then begin
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                 p_Resultado.TextoRespuesta := Error002;
//                 exit(false);
//             end;

//             ComprobarCambioCliente(rSalesH, p_Evento.TextoPais.GetValue(7));
//             "Venta a credito" := Es_Vta_Credito(rSalesH);

//             rCust.Get("Sell-to Customer No.");
//             if "Venta a credito" then
//                 if not rCust."Permite venta a credito" then begin
//                     ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                     p_Resultado.TextoRespuesta := Error003;
//                     exit(false);
//                 end;

//             //+#70132
//             if not TestFormaPago(rSalesH, lMensajeError) then begin
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                 p_Resultado.TextoRespuesta := lMensajeError;
//                 exit(false);
//             end;
//             //-#70132

//             "Hora creacion" := FormatTime(Time);
//             "ID Cajero" := p_Evento.TextoDato5;
//             TPV := p_Evento.TextoDato2;
//             Ship := false;
//             Invoice := true;

//             //+#355717
//             //... Se valida el colegio.
//             //"Cod. Colegio"   := p_Evento.TextoPais.GetValue(8);
//             Validate("Cod. Colegio", p_Evento.TextoPais.GetValue(8));
//             //-#355717

//             "Nombre Colegio" := CopyStr(p_Evento.TextoPais.GetValue(9), 1, MaxStrLen("Nombre Colegio"));

//             //+#65225
//             //*************************************************
//             /*
//             IF "Posting No." = '' THEN
//               IF NOT Es_Devolucion THEN BEGIN
//                 "No. Series"           := recTPV."No. serie Facturas";
//                 "Posting No. Series"   := recTPV."No. serie facturas Reg.";
//                 "Posting No."          := cduNoSeries.GetNextNo(recTPV."No. serie facturas Reg.","Posting Date",TRUE);
//                 "Posting Description"  := STRSUBSTNO(Text003,rSalesH."Posting No.");
//               END
//               ELSE BEGIN
//                 "No. Series"           := recTPV."No. serie notas credito";
//                 "Posting No. Series"   := recTPV."No. serie notas credito reg.";
//                 "Posting No."          := cduNoSeries.GetNextNo(recTPV."No. serie notas credito reg.","Posting Date",TRUE);
//                 "Posting Description"  := STRSUBSTNO(Text004,rSalesH."Posting No.");
//               END;

//             IF rSalesH.Devolucion THEN
//               RelacionaDevolucion(rSalesH);

//             p_Resultado.TextoRespuesta := '';
//             CASE Pais OF
//               1: p_Resultado.TextoRespuesta := cDominicana.Registrar(rSalesH,p_Evento); // Dominicana
//               2: p_Resultado.TextoRespuesta := cBolivia.Registrar(rSalesH,p_Evento);    // Bolivia
//               3: p_Resultado.TextoRespuesta := cParaguay.Registrar(rSalesH,p_Evento);   // Paraguay
//               4: p_Resultado.TextoRespuesta := cEcuador.Registrar(rSalesH,p_Evento);    // Ecuador
//               5: p_Resultado.TextoRespuesta := cGuatemala.Registrar(rSalesH,p_Evento);    // Guatemala
//               6: p_Resultado.TextoRespuesta := cSalvador.Registrar(rSalesH,p_Evento);   // Salvador
//               7: p_Resultado.TextoRespuesta := cHonduras.Registrar(rSalesH,p_Evento);   // Honduras
//               9: p_Resultado.TextoRespuesta := cCostaRica.Registrar(rSalesH,p_Evento);   // Costa Rica / #148807
//             END;

//             IF p_Resultado.TextoRespuesta <> '' THEN BEGIN
//               ControlDeAcceso(p_Evento.TextoDato,FALSE); //+90735
//               EXIT(FALSE);
//             END;

//             IF "Nº Fiscal TPV" = '' THEN
//               "Nº Fiscal TPV" := "Posting No.";
//             */
//             //*************************************************
//             //-#65225

//             if not Modify(false) then begin
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                 p_Resultado.TextoRespuesta := Error006;
//                 p_Resultado.AccionRespuesta := 'ERROR';
//                 exit(false);
//             end;

//             //+#65225
//             //*************************************************
//             /*
//             recPagosTPV.RESET;
//             recPagosTPV.SETRANGE("No. Borrador" , rSalesH."No.");
//             IF recPagosTPV.FINDSET THEN BEGIN
//               REPEAT
//                 IF NOT Es_Devolucion THEN
//                   recPagosTPV."No. Factura" := "Posting No."
//                 ELSE
//                   recPagosTPV."No. Nota Credito" := "Posting No.";
//                 recPagosTPV.Fecha := "Posting Date";
//                 recPagosTPV.MODIFY;
//               UNTIL recPagosTPV.NEXT = 0;
//             END;
//             */
//             //*************************************************

//             //+#144756
//             //... Actualizaciones El Salvador.
//             Actualiza_Venta_Contacto_2(rSalesH);
//             //-#144756

//             //+88460
//             lNumLog := IniciarLog(0, p_Evento.TextoDato, p_Evento.TextoDato2);
//             //-88460

//             //+#381937
//             //... En la función RegistrarPorPais() se pueden producir mensajes de error controlados. Estas dos funciones deberían ir despues.
//             /*
//             RegistrarAsignaPostingNo(rSalesH,recTPV);
//             IF Devolucion THEN
//               RelacionaDevolucion(rSalesH);
//             */
//             //-#381937

//             //+#383107
//             if Devolucion then
//                 RelacionaDevolucion_0(rSalesH);
//             //-#383107


//             p_Resultado.TextoRespuesta := RegistrarPorPais(rSalesH, p_Evento);
//             if p_Resultado.TextoRespuesta <> '' then begin
//                 if not Modify then;
//                 p_Resultado.AccionRespuesta := 'ERROR';
//                 ControlDeAcceso(p_Evento.TextoDato, false); //+90735

//                 //+88460
//                 ModificarDatosLog(lNumLog, 2, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal",
//                                   p_Resultado.TextoRespuesta);
//                 //-88460
//                 exit(false);
//             end;

//             //+#381937
//             RegistrarAsignaPostingNo(rSalesH, recTPV);
//             if Devolucion then
//                 RelacionaDevolucion(rSalesH);
//             //-#381937

//             // IMPORTANTE: Si a partir de aquí el registro no finaliza correctamente, se puede perde la serie de registro y el nº fiscal

//             RegistrarActualizaPagos(rSalesH);
//             //-#65225

//             //+88460
//             ModificarDatosLog(lNumLog, 3, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//             //-88460

//             if RegistroEnLinea(p_Evento.TextoDato) then begin
//                 //+#65232
//                 if not Modify(false) then begin
//                     ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                     p_Resultado.TextoRespuesta := Error006;
//                     p_Resultado.AccionRespuesta := 'ERROR';

//                     //+88460
//                     ModificarDatosLog(lNumLog, 4, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal",
//                                     p_Resultado.TextoRespuesta);
//                     //-88460

//                     exit(false);
//                 end;
//                 //-#65232

//                 if not "Venta a credito" then //+#65232
//                     ActualizarDatoPago(rSalesH);

//                 //+88460
//                 ModificarDatosLog(lNumLog, 5, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//                 //-88460

//                 Commit;

//                 if (CODEUNIT.Run(CODEUNIT::"Ventas-Registrar DsPOS", rSalesH)) then begin

//                     //+88460
//                     ModificarDatosLog(lNumLog, 6, rSalesH."Document Type", rSalesH."No.", rSalesH."Last Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//                     //-88460

//                     GuardarVentaTPV(rSalesH, true);

//                     recParam.Init;
//                     //IF NOT Es_Devolucion THEN //-#65232
//                     if not Es_NotaCr then //+#65232
//                         recParam.Accion := recParam.Accion::LiquidarFactura
//                     else
//                         recParam.Accion := recParam.Accion::LiquidarNotaCredito;

//                     recParam.Documento := rSalesH."Last Posting No.";

//                     //+#120811
//                     //... Actualizamos los datos fiscales.
//                     Post_Registrar(rSalesH, true, recTPV);
//                     //-#120811


//                     //+88460
//                     ModificarDatosLog(lNumLog, 7, rSalesH."Document Type", rSalesH."No.", rSalesH."Last Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//                     //-88460

//                     Commit;

//                     if (CODEUNIT.Run(CODEUNIT::"Funciones DsPOS - Comunes", recParam)) then begin

//                         p_Resultado.AccionRespuesta := 'Nueva_Venta';
//                         //IF NOT Es_Devolucion THEN //-#65232
//                         if not Es_NotaCr then //+#65232
//                             p_Resultado.TextoRespuesta := StrSubstNo(Text001, rSalesH."Last Posting No.")
//                         else
//                             p_Resultado.TextoRespuesta := StrSubstNo(Text005, rSalesH."Last Posting No.");

//                         p_Resultado.TextoDato4 := rSalesH."Last Posting No.";

//                         //+88460
//                         ModificarDatosLog(lNumLog, 8, rSalesH."Document Type", rSalesH."No.", rSalesH."Last Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//                         //-88460

//                         //+76946
//                         ClearLastError;
//                         if not FE_Por_Pais(rSalesH, true) then begin
//                             lTextoAviso := CopyStr(StrSubstNo(Text010, rSalesH."Last Posting No.") + '. ' + GetLastErrorText, 1, 1024);
//                             //... Según como se puede activar el siguiente mensaje, en lugar de grabar en la tabla de TPVs.
//                             //MESSAGE(lTextoAviso);
//                             GrabarTextoAvisoFE(p_Evento.TextoDato, p_Evento.TextoDato2, lTextoAviso);
//                             ClearLastError;
//                         end;
//                         //-76946


//                         cControl.EliminarBorradores(p_Evento.TextoDato, p_Evento.TextoDato2, false);
//                         ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                         exit(true);
//                     end;

//                 end
//                 else begin
//                     p_Resultado.AccionRespuesta := 'ERROR';
//                     p_Resultado.TextoRespuesta := GetLastErrorText;

//                     //+88460
//                     ModificarDatosLog(lNumLog, 9, rSalesH."Document Type", rSalesH."No.", rSalesH."Last Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal",
//                                       p_Resultado.TextoRespuesta);
//                     //-88460

//                     ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                     ClearLastError;
//                     exit(false);
//                 end;

//             end
//             else begin

//                 //+#65232
//                 //recLinVta.RESET;
//                 //recLinVta.SETRANGE("Document Type" , "Document Type");
//                 //recLinVta.SETRANGE("Document No."  , "No.");
//                 //recLinVta.SETFILTER(Quantity,'<>0');
//                 //IF NOT recLinVta.FINDFIRST THEN BEGIN
//                 //  p_Resultado.TextoRespuesta := Error004;
//                 //  EXIT(FALSE);
//                 //END;
//                 //-#65232

//                 "Registrado TPV" := true;

//                 //+#211509
//                 //+#273889
//                 //... Esta funcion se ejecutara despues de GuardarVentaTPV(). En la funcion ActualizarDatoPago() se crean registros de pago por el cambio
//                 //... y no se replican debido a que no estan marcados como Registrado.
//                 //ActualizarEstadoRegistro(rSalesH);
//                 //-#211509

//                 if not "Venta a credito" then //+#65232
//                     ActualizarDatoPago(rSalesH);
//                 GuardarVentaTPV(rSalesH, false);

//                 //+#211509
//                 ActualizarEstadoRegistro(rSalesH);
//                 //-#211509

//                 //+88460
//                 ModificarDatosLog(lNumLog, 10, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//                 //-88460

//                 if Modify(false) then begin

//                     //+#121213
//                     //... El proceso de registro con esta modificación queda más controlado. Elimino el COMMIT.
//                     //COMMIT; //+#65232
//                     //-#121213

//                     p_Resultado.AccionRespuesta := 'Nueva_Venta';

//                     //IF NOT Es_Devolucion THEN //-#65232
//                     if not Es_NotaCr then //+#65232
//                         p_Resultado.TextoRespuesta := StrSubstNo(Text001, rSalesH."Posting No.")
//                     else
//                         p_Resultado.TextoRespuesta := StrSubstNo(Text005, rSalesH."Posting No.");

//                     p_Resultado.TextoDato4 := rSalesH."No.";

//                     //+88460
//                     ModificarDatosLog(lNumLog, 11, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", '');
//                     //-88460

//                     //+#232158
//                     //... Evitamos el COMMIT. Si en Guatemala no se ha podido realizar la firma electronica devolvemos error.
//                     /*
//                     //+76946
//                     CLEARLASTERROR;
//                     IF NOT FE_Por_Pais(rSalesH,FALSE) THEN BEGIN
//                       lTextoAviso := COPYSTR(STRSUBSTNO(Text010,rSalesH."No.")+'. '+GETLASTERRORTEXT,1,1024);
//                       //... Según como se puede activar el siguiente mensaje en lugar de grabar el mensaje en la tabla.
//                       //MESSAGE(lTextoAviso);
//                       GrabarTextoAvisoFE(p_Evento.TextoDato,p_Evento.TextoDato2,lTextoAviso);
//                       CLEARLASTERROR;
//                     END;
//                     //-76946
//                     */

//                     //... Guatemala. Llamada a la funcion para FE 2.0. Como novedad, si hay algun error no puede concluir la venta.
//                     lTextoAviso := '';
//                     case Pais of
//                         5:
//                             lTextoAviso := lcGuatemala.FacturacionElectronica(rSalesH, false, true);
//                     end;

//                     if lTextoAviso <> '' then begin
//                         //... Si no devolvemos un ERROR, el campo Registrado TPV y otros valores indican que la venta ha ido OK. Por ello, hay que hacer ROLLBACK
//                         Error(lTextoAviso);

//                         lTextoAviso := CopyStr(lTextoAviso, 1, 150);

//                         p_Resultado.TextoRespuesta := lTextoAviso;
//                         p_Resultado.AccionRespuesta := 'ERROR';
//                         ModificarDatosLog(lNumLog, 13, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal",
//                                           p_Resultado.TextoRespuesta);

//                         ControlDeAcceso(p_Evento.TextoDato, false);

//                         exit(false);


//                     end
//                     else begin
//                         cControl.EliminarBorradores(p_Evento.TextoDato, p_Evento.TextoDato2, false);
//                         ModificarDatosLog(lNumLog, 14, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal",
//                                           '');
//                         ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                         exit(true);
//                     end;

//                 end
//                 else begin
//                     p_Resultado.TextoRespuesta := Error006;
//                     p_Resultado.AccionRespuesta := 'ERROR';
//                     //+88460
//                     ModificarDatosLog(lNumLog, 12, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal",
//                                       p_Resultado.TextoRespuesta);
//                     //-88460
//                     ControlDeAcceso(p_Evento.TextoDato, false); //+90735
//                     exit(false);
//                 end;

//             end;

//         end;

//     end;


//     procedure RegistrarPorPais(var p_SalesH: Record "Sales Header"; var p_Evento: DotNet ) Respuesta: Text
//     begin
//         //+#65232
//         case Pais of
//             1:
//                 Respuesta := cDominicana.Registrar(p_SalesH, p_Evento); // Dominicana
//             2:
//                 Respuesta := cBolivia.Registrar(p_SalesH, p_Evento);    // Bolivia
//             3:
//                 Respuesta := cParaguay.Registrar(p_SalesH, p_Evento);   // Paraguay
//             4:
//                 Respuesta := cEcuador.Registrar(p_SalesH, p_Evento);    // Ecuador
//             5:
//                 Respuesta := cGuatemala.Registrar(p_SalesH, p_Evento);  // Guatemala
//             6:
//                 Respuesta := cSalvador.Registrar(p_SalesH, p_Evento);   // Salvador
//             7:
//                 Respuesta := cHonduras.Registrar(p_SalesH, p_Evento);   // Honduras
//             9:
//                 Respuesta := cCostaRica.Registrar(p_SalesH, p_Evento);   // Costa Rica /#148807
//         end;

//         if (Respuesta = '') and (p_SalesH."No. Fiscal TPV" = '') then
//             p_SalesH."No. Fiscal TPV" := p_SalesH."Posting No.";
//     end;


//     procedure RegistrarActualizaPagos(var p_SalesH: Record "Sales Header")
//     var
//         recPagosTPV: Record "Pagos TPV";
//     begin
//         //+#65225
//         with p_SalesH do begin
//             recPagosTPV.Reset;
//             recPagosTPV.SetRange("No. Borrador", "No.");
//             if "Document Type" = "Document Type"::"Credit Memo" then
//                 recPagosTPV.ModifyAll("No. Nota Credito", "Posting No.")
//             else
//                 recPagosTPV.ModifyAll("No. Factura", "Posting No.");
//             recPagosTPV.ModifyAll(Fecha, "Posting Date");
//         end;
//     end;


//     procedure RegistrarAsignaPostingNo(var p_SalesH: Record "Sales Header"; p_recTPV: Record "Configuracion TPV")
//     var
//         cduNoSeries: Codeunit NoSeriesManagement;
//         Text003: Label 'Factura TPV %1';
//         Text004: Label 'Devolución TPV %1';
//     begin
//         //+#65225
//         with p_SalesH do begin
//             if "Posting No." = '' then
//                 if "Document Type" = "Document Type"::"Credit Memo" then begin
//                     "No. Series" := p_recTPV."No. serie notas credito";
//                     "Posting No. Series" := p_recTPV."No. serie notas credito reg.";
//                     "Posting No." := cduNoSeries.GetNextNo(p_recTPV."No. serie notas credito reg.", "Posting Date", true);
//                     "Posting Description" := StrSubstNo(Text004, "Posting No.");
//                 end
//                 else begin
//                     "No. Series" := p_recTPV."No. serie Facturas";
//                     "Posting No. Series" := p_recTPV."No. serie facturas Reg.";
//                     "Posting No." := cduNoSeries.GetNextNo(p_recTPV."No. serie facturas Reg.", "Posting Date", true);
//                     "Posting Description" := StrSubstNo(Text003, "Posting No.");
//                 end;
//         end;
//     end;


//     procedure Crear_Devolucion(p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         rSalesH: Record "Sales Header";
//         rSalesInvH: Record "Sales Invoice Header";
//         rSalesLin: Record "Sales Line";
//         rSalesInvLin: Record "Sales Invoice Line";
//         NotaCredito: Code[20];
//         rCabDevol: Record "Sales Header";
//         rLinDevol: Record "Sales Line";
//         Text001: Label 'Se ha creado la devoluciÙn %1';
//         NoLin: Integer;
//         i: Integer;
//         ArrayNav: array[60] of Integer;
//         varArray: DotNet Array;
//         wDateTime: DateTime;
//         lNumLog: Integer;
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Evento.TipoEvento := 16;
//         i := 1;
//         while i < (p_Evento.ArrayEnteros.Length + 1) do begin
//             ArrayNav[i] := p_Evento.ArrayEnteros.GetValue(i - 1);
//             i += 1;
//         end;

//         with rCabDevol do begin
//             Get("Document Type"::"Credit Memo", Nueva_Venta(p_Evento.TextoDato, p_Evento.TextoDato2, p_Evento.TextoDato4, true));

//             //+#381937
//             //... Registramos en el LOG.
//             lNumLog := IniciarLog(8, p_Evento.TextoDato, p_Evento.TextoDato2);
//             //-#381937

//             if RegistroEnLinea(p_Evento.TextoDato) then begin
//                 rSalesInvH.Get(p_Evento.TextoDato5);
//                 Validate("Sell-to Customer No.", rSalesInvH."Sell-to Customer No.");
//                 Validate("Cod. Colegio", rSalesInvH."Cod. Colegio");
//                 Validate("Salesperson Code", rSalesInvH."Salesperson Code");
//                 Validate("Location Code", rSalesInvH."Location Code");
//                 "Bill-to Name" := rSalesInvH."Bill-to Name";
//                 "Bill-to Address" := rSalesInvH."Bill-to Address";
//                 "VAT Registration No." := rSalesInvH."VAT Registration No.";
//                 "Sell-to Customer Name" := rSalesInvH."Sell-to Customer Name";
//                 "Sell-to Address" := rSalesInvH."Sell-to Address";
//                 "Sell-to Contact No." := rSalesInvH."Sell-to Contact No.";
//                 "Bill-to Contact No." := rSalesInvH."Bill-to Contact No.";

//                 //+#355717
//                 "Ship-to Name" := rSalesInvH."Ship-to Name";
//                 "Ship-to Name 2" := rSalesInvH."Ship-to Name 2";
//                 "E-Mail" := rSalesInvH."E-Mail";
//                 "No. Telefono" := rSalesInvH."No. Telefono";

//                 "Ship-to Code" := rSalesInvH."Ship-to Code";
//                 "Ship-to Address" := rSalesInvH."Ship-to Address";
//                 "Ship-to Address 2" := rSalesInvH."Ship-to Address 2";
//                 "Ship-to City" := rSalesInvH."Ship-to City";
//                 "Ship-to Contact" := rSalesInvH."Ship-to Contact";
//                 //-#355717

//             end
//             else begin
//                 rSalesH.Get(rSalesH."Document Type"::Invoice, p_Evento.TextoDato5);
//                 Validate("Sell-to Customer No.", rSalesH."Sell-to Customer No.");
//                 Validate("Cod. Colegio", rSalesH."Cod. Colegio");
//                 Validate("Salesperson Code", rSalesH."Salesperson Code");
//                 Validate("Location Code", rSalesH."Location Code");
//                 "Bill-to Name" := rSalesH."Bill-to Name";
//                 "Bill-to Address" := rSalesH."Bill-to Address";
//                 "VAT Registration No." := rSalesH."VAT Registration No.";
//                 "Sell-to Customer Name" := rSalesH."Sell-to Customer Name";
//                 "Sell-to Address" := rSalesH."Sell-to Address";
//                 "Sell-to Contact No." := rSalesH."Sell-to Contact No.";
//                 "Bill-to Contact No." := rSalesH."Bill-to Contact No.";

//                 //+#355717
//                 "Ship-to Name" := rSalesH."Ship-to Name";
//                 "Ship-to Name 2" := rSalesH."Ship-to Name 2";
//                 "E-Mail" := rSalesH."E-Mail";
//                 "No. Telefono" := rSalesH."No. Telefono";

//                 "Ship-to Code" := rSalesH."Ship-to Code";
//                 "Ship-to Address" := rSalesH."Ship-to Address";
//                 "Ship-to Address 2" := rSalesH."Ship-to Address 2";
//                 "Ship-to City" := rSalesH."Ship-to City";
//                 "Ship-to Contact" := rSalesH."Ship-to Contact";
//                 //-#355717

//             end;
//             Devolucion := true;
//             Validate("Currency Code", '');
//             Modify(false);
//         end;

//         i := 1;
//         NoLin := 10000;
//         while ArrayNav[i] <> 0 do begin
//             if RegistroEnLinea(p_Evento.TextoDato) then begin
//                 rSalesInvLin.SetRange("Document No.", rSalesInvH."No.");
//                 rSalesInvLin.SetRange("Line No.", ArrayNav[i]);
//                 if rSalesInvLin.FindSet then
//                     repeat
//                         with rLinDevol do begin
//                             Init;
//                             "Document Type" := rCabDevol."Document Type";
//                             "Document No." := rCabDevol."No.";
//                             "Line No." := NoLin;
//                             Validate(Type, rSalesInvLin.Type);
//                             Validate("No.", rSalesInvLin."No.");
//                             Validate("Unit of Measure", rSalesInvLin."Unit of Measure");
//                             //+#355717
//                             //... Se pueden realizar devoluciones parciales.
//                             //VALIDATE(Quantity               ,  rSalesInvLin.Quantity);
//                             if (rSalesInvLin."Cantidad devuelta TPV" > 0) and (rSalesInvLin."Cantidad devuelta TPV" < rSalesInvLin.Quantity) then
//                                 Validate(Quantity, rSalesInvLin.Quantity - rSalesInvLin."Cantidad devuelta TPV")
//                             else
//                                 Validate(Quantity, rSalesInvLin.Quantity);
//                             //-#355717

//                             Validate("Unit Price", rSalesInvLin."Unit Price");
//                             Validate("Line Discount %", rSalesInvLin."Line Discount %");
//                             Validate("Line Discount Amount", rSalesInvLin."Line Discount Amount");
//                             "Devuelve a Documento" := rSalesInvH."No.";
//                             "Devuelve a Linea Documento" := rSalesInvLin."Line No.";
//                             Insert(false);
//                         end;
//                         NoLin += 10000;
//                     until rSalesInvLin.Next = 0;


//             end
//             else begin
//                 rSalesLin.SetRange("Document Type", rSalesLin."Document Type"::Invoice);
//                 rSalesLin.SetRange("Document No.", rSalesH."No.");
//                 rSalesLin.SetRange("Line No.", ArrayNav[i]);
//                 if rSalesLin.FindSet then
//                     repeat
//                         with rLinDevol do begin
//                             Init;
//                             "Document Type" := rCabDevol."Document Type";
//                             "Document No." := rCabDevol."No.";
//                             "Line No." := NoLin;
//                             Validate(Type, rSalesLin.Type);
//                             Validate("No.", rSalesLin."No.");
//                             Validate("Unit of Measure", rSalesLin."Unit of Measure");

//                             //+#355717
//                             //... Se pueden realizar devoluciones parcialtes.
//                             //VALIDATE(Quantity               ,  rSalesLin.Quantity);
//                             if (rSalesLin."Cantidad devuelta TPV" > 0) and (rSalesLin."Cantidad devuelta TPV" < rSalesLin.Quantity) then
//                                 Validate(Quantity, rSalesLin.Quantity - rSalesLin."Cantidad devuelta TPV")
//                             else
//                                 Validate(Quantity, rSalesLin.Quantity);
//                             //-#355717

//                             Validate("Unit Price", rSalesLin."Unit Price");
//                             Validate("Line Discount %", rSalesLin."Line Discount %");
//                             Validate("Line Discount Amount", rSalesLin."Line Discount Amount");
//                             "Devuelve a Documento" := rSalesH."Posting No.";
//                             "Devuelve a Linea Documento" := rSalesLin."Line No.";

//                             Linea_LocalizadaOFF(rSalesLin, rLinDevol);

//                             Insert(false);
//                         end;
//                         NoLin += 10000;
//                     until rSalesLin.Next = 0;
//             end;
//             i += 1;

//             //+#381937
//             ModificarDatosLog(lNumLog, 2, rCabDevol."Document Type", rCabDevol."No.", rCabDevol."Posting No.", rCabDevol."No. Fiscal TPV", rCabDevol."No. Comprobante Fiscal", '');
//             //-#381937

//         end;

//         // Para obtener el siguiente nº de notas de credito
//         case Pais of
//             3:
//                 Evento.TextoDato7 := cParaguay.Nueva_Venta(rCabDevol.Tienda, rCabDevol.TPV, rCabDevol."ID Cajero", rCabDevol);   // Paraguay
//             4:
//                 Evento.TextoDato7 := cEcuador.Nueva_Venta(rCabDevol.Tienda, rCabDevol.TPV, rCabDevol."ID Cajero", rCabDevol);     // Ecuador
//             5:
//                 Evento.TextoDato7 := cGuatemala.Nueva_Venta(rCabDevol.Tienda, rCabDevol.TPV, rCabDevol."ID Cajero", rCabDevol);     // Guatemala
//             6:
//                 Evento.TextoDato7 := cSalvador.Nueva_Venta(rCabDevol.Tienda, rCabDevol.TPV, rCabDevol."ID Cajero", rCabDevol);     // Salvador
//             7:
//                 Evento.TextoDato7 := cHonduras.Nueva_Venta(rCabDevol.Tienda, rCabDevol.TPV, rCabDevol."ID Cajero", rCabDevol);     // Honduras
//             9:
//                 Evento.TextoDato7 := cCostaRica.Nueva_Venta(rCabDevol.Tienda, rCabDevol.TPV, rCabDevol."ID Cajero", rCabDevol);     // Costa Rica  /#148807
//         end;

//         Evento.TextoDato := rCabDevol."No.";
//         Evento.TextoDato2 := StrSubstNo('%1', rCabDevol."Posting Date");
//         Evento.TextoDato3 := rCabDevol."Sell-to Customer Name";
//         Evento.TextoDato4 := rCabDevol."VAT Registration No.";
//         Evento.TextoRespuesta := StrSubstNo(Text001, rCabDevol."No.");
//         Evento.TextoDato5 := rCabDevol."Sell-to Customer No.";
//         Evento.TextoDato8 := rCabDevol."Cod. Colegio";
//         Evento.TextoDato9 := rCabDevol."Nombre Colegio";

//         Evento.AccionRespuesta := 'Actualizar_Todo';
//         Actualizar_Totales(Evento.TextoDato, Evento, false, true);

//         exit(Evento.aXml());
//     end;


//     procedure Actualizar_Totales(p_Venta: Code[20]; var p_Evento: DotNet ; EsNueva: Boolean; Devolucion: Boolean)
//     var
//         varArray: DotNet Array;
//         [RunOnClient]
//         Evento: DotNet ;
//         rSalesH: Record "Sales Header";
//         decDummy: Decimal;
//         i: Integer;
//         decImportes: array[10] of Decimal;
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         i := 1;
//         varArray := varArray.CreateInstance(Evento.GetTypeOfDecimal(), 10);

//         if not (EsNueva) then begin
//             case Devolucion of
//                 false:
//                     begin
//                         if not rSalesH.Get(rSalesH."Document Type"::Invoice, p_Venta) then
//                             exit;
//                     end;
//                 true:
//                     begin
//                         if not rSalesH.Get(rSalesH."Document Type"::"Credit Memo", p_Venta) then
//                             exit;
//                     end;
//             end;

//             ActValoresTPV(rSalesH, decImportes[1], decImportes[2], decImportes[3], decImportes[4], decImportes[5], decImportes[6], decImportes[7]);
//             while i <= 7 do begin
//                 varArray.SetValue(decImportes[i], i);
//                 i += 1;
//             end;
//         end;

//         p_Evento.ArrayTotales := varArray;
//     end;


//     procedure ActValoresTPV(recPrmCabVta: Record "Sales Header"; var decPrmTotal: Decimal; var decPrmPago: Decimal; var decPrmDescuentos: Decimal; var decPrmCambio: Decimal; var decPrmBalance: Decimal; var decPrmTotalProds: Decimal; var decPrImpuestos: Decimal)
//     var
//         recLinVta: Record "Sales Line";
//         recPagosTPV: Record "Pagos TPV";
//     begin
//         Clear(decPrmTotal);
//         Clear(decPrmDescuentos);
//         Clear(decPrmPago);

//         recPrmCabVta.CalcFields(Amount);
//         recPrmCabVta.CalcFields("Amount Including VAT");
//         decPrImpuestos := recPrmCabVta."Amount Including VAT" - recPrmCabVta.Amount;

//         if recPagosTPV.Get(recPrmCabVta."No.", 'EXIVA', false) then begin
//             recPagosTPV.Importe := decPrImpuestos;
//             recPagosTPV."Importe (DL)" := decPrImpuestos;
//             recPagosTPV.Modify;
//         end;

//         //+#65232
//         //*************************************************
//         /*
//         recLinVta.RESET;
//         recLinVta.SETRANGE("Document Type" , recPrmCabVta."Document Type");
//         recLinVta.SETRANGE("Document No."  , recPrmCabVta."No.");
//         IF recLinVta.FINDSET THEN
//           REPEAT
//             decPrmTotal      += recLinVta."Outstanding Amount" + recLinVta."Line Discount Amount";
//             decPrmDescuentos += recLinVta."Line Discount Amount";
//             decPrmTotalProds += recLinVta.Quantity;
//           UNTIL recLinVta.NEXT = 0;
        
//         recPagosTPV.RESET;
//         recPagosTPV.SETRANGE("No. Borrador", recPrmCabVta."No.");
//         IF recPagosTPV.FINDSET THEN
//           REPEAT
//             decPrmPago += recPagosTPV."Importe (DL)";
//           UNTIL recPagosTPV.NEXT = 0;
//         */
//         //*************************************************
//         ObtValoresFac(recPrmCabVta, decPrmTotal, decPrmDescuentos, decPrmTotalProds);
//         decPrmPago := ObtImportePago(recPrmCabVta);
//         //-#65232

//         decPrmBalance := decPrmTotal - decPrmDescuentos - decPrmPago;
//         if decPrmBalance < 0 then
//             decPrmBalance := 0;

//         decPrmCambio := decPrmTotal - decPrmDescuentos - decPrmPago;
//         if decPrmCambio > 0 then
//             decPrmCambio := 0;

//         if decPrmPago = 0 then
//             decPrmCambio := 0;

//     end;


//     procedure ObtValoresFac(recPrmCabVta: Record "Sales Header"; var decPrmTotal: Decimal; var decPrmDescuentos: Decimal; var decPrmTotalProds: Decimal)
//     var
//         recLinVta: Record "Sales Line";
//     begin
//         //+#65232
//         recLinVta.Reset;
//         recLinVta.SetRange("Document Type", recPrmCabVta."Document Type");
//         recLinVta.SetRange("Document No.", recPrmCabVta."No.");
//         recLinVta.CalcSums("Outstanding Amount", "Line Discount Amount", Quantity);

//         //+#378479
//         recLinVta.CalcSums("Amount Including VAT");
//         //-#378479

//         //+#378479
//         //decPrmTotal := recLinVta."Outstanding Amount" + recLinVta."Line Discount Amount";
//         decPrmTotal := recLinVta."Amount Including VAT" + recLinVta."Line Discount Amount";
//         //-#378479

//         decPrmDescuentos := recLinVta."Line Discount Amount";
//         decPrmTotalProds := recLinVta.Quantity;
//     end;


//     procedure ObtImportePago(recPrmCabVta: Record "Sales Header"): Decimal
//     var
//         recPagosTPV: Record "Pagos TPV";
//     begin
//         //+#65232
//         recPagosTPV.Reset;
//         recPagosTPV.SetRange("No. Borrador", recPrmCabVta."No.");
//         recPagosTPV.CalcSums("Importe (DL)");

//         exit(recPagosTPV."Importe (DL)");
//     end;


//     procedure ActualizarDatoPago(recPrmCabVta: Record "Sales Header")
//     var
//         decDummy: array[10] of Decimal;
//         decCambio: Decimal;
//     begin
//         ActValoresTPV(recPrmCabVta, decDummy[1], decDummy[2], decDummy[3], decCambio, decDummy[4], decDummy[5], decDummy[6]);

//         if decCambio <> 0 then
//             InsertaCambio(recPrmCabVta, decCambio);
//     end;


//     procedure Valida_Venta(rSalesHeader: Record "Sales Header"): Boolean
//     var
//         rSalesLine: Record "Sales Line";
//     begin

//         rSalesLine.Reset;
//         rSalesLine.SetRange("Document Type", rSalesHeader."Document Type");
//         rSalesLine.SetRange("Document No.", rSalesHeader."No.");
//         if rSalesLine.FindSet then
//             repeat
//                 if rSalesLine."Outstanding Amount" <> 0 then
//                     exit(true);
//             until rSalesLine.Next = 0;

//         exit(false);
//     end;


//     procedure Es_Vta_Credito(var pSalesHeader: Record "Sales Header"): Boolean
//     var
//         rSalesline: Record "Sales Line";
//         rPagosTPV: Record "Pagos TPV";
//         wTotal: Decimal;
//         wDescuentos: Decimal;
//         wPago: Decimal;
//     begin

//         rSalesline.Reset;
//         rSalesline.SetRange("Document Type", pSalesHeader."Document Type");
//         rSalesline.SetRange("Document No.", pSalesHeader."No.");
//         if rSalesline.FindSet then
//             repeat

//                 //+#378479
//                 //wTotal    += rSalesline."Outstanding Amount" + rSalesline."Line Discount Amount";
//                 wTotal += rSalesline."Amount Including VAT" + rSalesline."Line Discount Amount";
//                 //-#378479

//                 wDescuentos += rSalesline."Line Discount Amount";
//             until rSalesline.Next = 0;

//         rPagosTPV.Reset;
//         rPagosTPV.SetRange("No. Borrador", pSalesHeader."No.");
//         if rPagosTPV.FindSet then
//             repeat
//                 wPago += rPagosTPV."Importe (DL)";
//             until rPagosTPV.Next = 0;

//         exit((wTotal - wDescuentos - wPago) > 0)
//     end;


//     procedure SigNoLinea(p_Pedido: Code[20]): Integer
//     var
//         rSalesLine: Record "Sales Line";
//     begin

//         rSalesLine.Reset;
//         rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::Invoice);
//         rSalesLine.SetRange("Document No.", p_Pedido);
//         if rSalesLine.FindLast then
//             exit(rSalesLine."Line No." + 10000)
//         else
//             exit(10000);
//     end;


//     procedure Pais(): Integer
//     var
//         rConfGeneral: Record "Configuracion General DsPOS";
//     begin

//         rConfGeneral.Get();
//         rConfGeneral.TestField(Pais);
//         exit(rConfGeneral.Pais);
//     end;


//     procedure GetDimensionSetIDMovCliente(codPrmDocNo: Code[20]): Integer
//     var
//         recMovCli: Record "Cust. Ledger Entry";
//     begin

//         //Se igualan las dimensiones del pago a las de la factura
//         recMovCli.Reset;
//         recMovCli.SetCurrentKey("Document No.", "Document Type", "Customer No.");
//         recMovCli.SetRange("Document Type", recMovCli."Document Type"::Invoice);
//         recMovCli.SetRange("Document No.", codPrmDocNo);
//         if recMovCli.FindFirst then
//             exit(recMovCli."Dimension Set ID")
//         else begin
//             recMovCli.Reset;
//             recMovCli.SetCurrentKey("Document No.", "Document Type", "Customer No.");
//             recMovCli.SetRange("Document Type", recMovCli."Document Type"::"Credit Memo");
//             recMovCli.SetRange("Document No.", codPrmDocNo);
//             if recMovCli.FindFirst then
//                 exit(recMovCli."Dimension Set ID")
//         end;
//     end;


//     procedure InsertaCambio(recPrmCabVta: Record "Sales Header"; decPrmImporteCambio: Decimal)
//     var
//         recPagosTPV: Record "Pagos TPV";
//         recFormPagosTPV: Record "Formas de Pago";
//         TextL001: Label 'REG_CAMBIO';
//         lcDominicana: Codeunit "Funciones DsPOS - Dominicana";
//     begin

//         recPagosTPV.Reset;
//         recPagosTPV.SetRange("No. Borrador", recPrmCabVta."No.");
//         recPagosTPV.SetRange(Cambio, true);
//         if recPagosTPV.FindFirst then
//             exit;

//         //Inserta La forma de pago Cambio
//         with recPrmCabVta do begin
//             if decPrmImporteCambio <> 0 then begin
//                 recFormPagosTPV.Reset;
//                 recFormPagosTPV.SetRange("Efectivo Local", true);
//                 recFormPagosTPV.FindFirst;

//                 recPagosTPV.Init;
//                 recPagosTPV."Forma pago TPV" := recFormPagosTPV."ID Pago";
//                 recPagosTPV."No. Borrador" := "No.";
//                 recPagosTPV.Tienda := Tienda;
//                 recPagosTPV.TPV := TPV;
//                 recPagosTPV."Cod. divisa" := '';
//                 recPagosTPV."Importe (DL)" := decPrmImporteCambio;
//                 recPagosTPV.Importe := decPrmImporteCambio;
//                 recPagosTPV.Fecha := WorkDate;
//                 recPagosTPV.Hora := FormatTime(Time);
//                 recPagosTPV.Cajero := "ID Cajero";
//                 recPagosTPV."No. Factura" := "Posting No.";
//                 recPagosTPV.Cambio := true;

//                 //+#70132
//                 case Pais of
//                     1:
//                         lcDominicana.ActDatosPagoPorCompensacion(TextL001, recPagosTPV);
//                 end;
//                 //-#70132

//                 recPagosTPV.Insert;
//             end;
//         end;
//     end;


//     procedure Imprimir(codPrmTienda: Code[20]; codPrmDoc: Code[20]): Text
//     var
//         recCabFac: Record "Sales Invoice Header";
//         recCabNC: Record "Sales Cr.Memo Header";
//         recCabVta: Record "Sales Header";
//         recTienda: Record Tiendas;
//         i: Integer;
//         Evento: DotNet ;
//         Text001: Label 'Las facturas Manuales no se pueden imprimir';
//         lResult: Integer;
//         lTextoError: Text[1024];
//         lPais: Integer;
//     begin
//         lResult := 1; //+#232158
//         lPais := Pais; //+232158

//         case lPais of
//             2:
//                 begin
//                     if not cBolivia.Imprimir(codPrmTienda, codPrmDoc) then begin
//                         if IsNull(Evento) then
//                             Evento := Evento.Evento();
//                         Evento.TipoEvento := 17;
//                         Evento.TextoRespuesta := Text001;
//                         Evento.AccionRespuesta := 'ERROR';
//                         exit(Evento.aXml());
//                     end;
//                 end;

//             //+#232158
//             5:
//                 begin
//                     lResult := cGuatemala.Imprimir(codPrmTienda, codPrmDoc, lTextoError);
//                     Commit;
//                     if lResult < 0 then begin
//                         if IsNull(Evento) then
//                             Evento := Evento.Evento();
//                         Evento.TipoEvento := 17;
//                         Evento.TextoRespuesta := lTextoError;
//                         Evento.AccionRespuesta := 'ERROR';
//                         exit(Evento.aXml());
//                     end;
//                 end;
//         //-#232158
//         end;

//         if lResult = 1 then begin
//             if recTienda.Get(codPrmTienda) then
//                 if recTienda."Registro En Linea" then begin
//                     recCabFac.Reset;
//                     recCabFac.SetRange("No.", codPrmDoc);
//                     if recCabFac.FindFirst then begin
//                         recTienda.TestField("ID Reporte contado");
//                         while i < recTienda."Cantidad de Copias Contado" do begin
//                             i += 1;
//                             //+#76946
//                             if TestFE_Factura(recCabFac) and (recTienda."ID Reporte contado FE" > 0) then begin
//                                 //+#232158
//                                 //REPORT.RUN(recTienda."ID Reporte contado FE",FALSE,FALSE,recCabFac);
//                                 if lPais = 5 then
//                                     cGuatemala.ImprimirPDF(codPrmDoc)
//                                 else
//                                     REPORT.Run(recTienda."ID Reporte contado FE", false, false, recCabFac);
//                                 //-#232158
//                             end
//                             else
//                                 //-#76946
//                                 REPORT.Run(recTienda."ID Reporte contado", false, false, recCabFac);
//                         end;
//                     end
//                     else begin
//                         recCabNC.Reset;
//                         recCabNC.SetRange("No.", codPrmDoc);
//                         if recCabNC.FindFirst then begin
//                             recTienda.TestField("ID Reporte nota credito");
//                             while i < recTienda."Cantidad copias nota credito" do begin
//                                 i += 1;
//                                 //+#76946
//                                 if TestFE_NCR(recCabNC) and (recTienda."ID Reporte nota credito FE" > 0) then begin
//                                     //+#232158
//                                     //REPORT.RUN(recTienda."ID Reporte nota credito FE",FALSE,FALSE,recCabNC)
//                                     if lPais = 5 then
//                                         cGuatemala.ImprimirPDF(codPrmDoc)
//                                     else
//                                         REPORT.Run(recTienda."ID Reporte nota credito FE", false, false, recCabNC)
//                                     //-#232158
//                                 end
//                                 else
//                                     //-#76946
//                                     REPORT.Run(recTienda."ID Reporte nota credito", false, false, recCabNC);
//                             end;
//                         end;
//                     end;

//                 end
//                 else begin
//                     recCabVta.Reset;
//                     recCabVta.SetRange("Document Type", recCabVta."Document Type"::Invoice);
//                     recCabVta.SetRange("No.", codPrmDoc);
//                     if recCabVta.FindFirst then begin
//                         recTienda.TestField("ID Reporte contado");
//                         while i < recTienda."Cantidad de Copias Contado" do begin
//                             i += 1;
//                             //+#76946
//                             if TestFE(recCabVta) and (recTienda."ID Reporte contado FE" > 0) then
//                                 //MDM    REPORT.RUN(recTienda."ID Reporte contado FE",FALSE,FALSE,recCabVta)
//                                 cGuatemala.ImprimirPDF(codPrmDoc)
//                             else
//                                 //-#76946
//                                 REPORT.Run(recTienda."ID Reporte contado", false, false, recCabVta);
//                         end;
//                     end
//                     else begin
//                         recCabVta.Reset;
//                         recCabVta.SetRange("Document Type", recCabVta."Document Type"::"Credit Memo");
//                         recCabVta.SetRange("No.", codPrmDoc);
//                         if recCabVta.FindFirst then begin
//                             recTienda.TestField("ID Reporte nota credito");
//                             while i < recTienda."Cantidad copias nota credito" do begin
//                                 i += 1;
//                                 //+#76946
//                                 if TestFE(recCabVta) and (recTienda."ID Reporte nota credito FE" > 0) then
//                                     //MDM    REPORT.RUN(recTienda."ID Reporte nota credito FE",FALSE,FALSE,recCabVta)
//                                     cGuatemala.ImprimirPDF(codPrmDoc)
//                                 else
//                                     //-#76946
//                                     REPORT.Run(recTienda."ID Reporte nota credito", false, false, recCabVta);
//                             end;
//                         end;
//                     end;
//                 end;
//         end;
//     end;


//     procedure AnularFactura(codPrmTienda: Code[20]; codPrmTPV: Code[20]; codPrmCajero: Code[20]; codPrmDoc: Code[20]): Text
//     var
//         recCabVta: Record "Sales Header";
//         recLinVta: Record "Sales Line";
//         recCab: Record "Sales Header";
//         recLin: Record "Sales Line";
//         recCabFac: Record "Sales Invoice Header";
//         recLinFac: Record "Sales Invoice Line";
//         recTPV: Record "Configuracion TPV";
//         Evento: DotNet ;
//         Error001: Label 'La factura %1 ya está anulada.';
//         Error002: Label 'No se ha podido insertar la nota de crédito.';
//         Text002: Label 'Factura anulada correctamente.';
//         recCabNC: Record "Sales Cr.Memo Header";
//         rPagos: Record "Pagos TPV";
//         rPagosNC: Record "Pagos TPV";
//         cduNoSeries: Codeunit NoSeriesManagement;
//         Text003: Label 'Anula a Fact. TPV %1';
//         cRegistro: Codeunit "Registrar Ventas en Lote DsPOS";
//         lNumLog: Integer;
//         lOk: Boolean;
//         lTextoAviso: Text[1024];
//         lcGuatemala: Codeunit "Funciones DsPOS - Guatemala";
//         lImporte: Decimal;
//         lImporteDL: Decimal;
//         lMensaje: Text;
//         lValidar: Boolean;
//         lrTienda: Record Tiendas;
//         lTotal: Decimal;
//         lIdFormaPagoNcr: Code[20];
//     begin
//         //#88460
//         ControlDeAcceso(codPrmTienda, true);
//         //-88460

//         //+88460
//         lNumLog := IniciarLog(2, codPrmTienda, codPrmTPV);
//         //-88460

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Evento.TipoEvento := 10;
//         recTPV.Get(codPrmTienda, codPrmTPV);

//         if RegistroEnLinea(codPrmTienda) then begin

//             recCabFac.Get(codPrmDoc);
//             if recCabFac."Anulado TPV" then begin
//                 Evento.TextoRespuesta := 'ERROR';
//                 Evento.AccionRespuesta := StrSubstNo(Error001, recCabFac."No.");

//                 //+88460
//                 ModificarDatosLog(lNumLog, 2, 0, recCabFac."No.", recCabFac."No.", recCabFac."No. Fiscal TPV", recCabFac."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 //-88460

//                 exit(Evento.aXml());
//             end;

//             //+#355717B
//             if not TestViabilidadNCR_2(recCabFac, lMensaje) then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 Evento.TextoRespuesta := lMensaje;

//                 ModificarDatosLog(lNumLog, 113, 0, recCabFac."No.", recCabFac."No.", recCabFac."No. Fiscal TPV", recCabFac."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 exit(Evento.aXml());
//             end;

//             //+#373762
//             //...
//             /*
//             //+#374964
//             lValidar := TRUE;
//             IF lrTienda.GET(codPrmTienda) THEN
//               IF lrTienda."Forma pago para NCR" <> '' THEN
//                 lValidar := FALSE;

//             IF lValidar THEN BEGIN
//             //-#374964
//               rPagos.RESET;
//               rPagos.SETRANGE("No. Factura" , recCabFac."No.");
//               IF rPagos.FINDFIRST THEN
//                 REPEAT

//                   IF NOT CalcularImporteAsignacionNCR_2(rPagos,0,lMensaje,lImporte,lImporteDL) THEN BEGIN
//                     Evento.AccionRespuesta  := 'ERROR';
//                     Evento.TextoRespuesta   := lMensaje;

//                     ModificarDatosLog(lNumLog,114,0,recCabFac."No.",recCabFac."No.",recCabFac."No. Fiscal TPV",recCabFac."No. Comprobante Fiscal",
//                                       Evento.TextoRespuesta);

//                     EXIT(Evento.aXml());

//                   END;

//               UNTIL rPagos.NEXT=0;
//             //-#355717
//             END;
//             */
//             //-#373762

//             recCabVta.Init;
//             recCabVta."Document Type" := recCabVta."Document Type"::"Credit Memo";
//             recCabVta."No." := cduNoSeries.GetNextNo(recTPV."No. serie notas credito", WorkDate, true);
//             recCabVta."No. Series" := recTPV."No. serie notas credito";
//             recCabVta."Posting No. Series" := recTPV."No. serie notas credito reg.";

//             recCabVta.Validate("Sell-to Customer No.", recCabFac."Sell-to Customer No.");
//             recCabVta.Validate("Order Date", WorkDate);
//             recCabVta.Validate("Posting Date", WorkDate);
//             recCabVta.Validate("Document Date", WorkDate);
//             recCabVta.Validate("Hora creacion", FormatTime(Time));

//             recCabVta."Venta TPV" := true;
//             recCabVta.Tienda := recTPV.Tienda;
//             recCabVta.TPV := recTPV."Id TPV";
//             recCabVta."ID Cajero" := codPrmCajero;

//             recCabVta.Validate("Location Code", recCabFac."Location Code");
//             recCabVta.Validate("Currency Code", recCabFac."Currency Code");

//             recCabVta.Correction := true;
//             recCabVta.Turno := recCabFac.Turno;
//             recCabVta."Anula a Documento" := codPrmDoc;
//             recCabVta."Posting No." := cduNoSeries.GetNextNo(recCabVta."Posting No. Series", WorkDate, true);

//             recCabVta."Sell-to Contact No." := recCabFac."Sell-to Contact No.";
//             recCabVta."Bill-to Contact No." := recCabFac."Bill-to Contact No.";
//             recCabVta."Location Code" := recCabFac."Location Code";

//             recCabVta.Insert(true);

//             recCabVta."Posting Description" := StrSubstNo(Text003, recCabFac."No.");
//             recCabVta.Validate("Dimension Set ID", recCabFac."Dimension Set ID");
//             recCabVta.Validate("Cod. Colegio", recCabFac."Cod. Colegio");
//             recCabVta.Validate("Salesperson Code", recCabFac."Salesperson Code");

//             recCabVta."Bill-to Name" := recCabFac."Bill-to Name";
//             recCabVta."Bill-to Address" := recCabFac."Bill-to Address";
//             recCabVta."VAT Registration No." := recCabFac."VAT Registration No.";
//             recCabVta."Sell-to Customer Name" := recCabFac."Sell-to Customer Name";
//             recCabVta."Sell-to Address" := recCabFac."Sell-to Address";

//             //+#232158 (RRT / MDM)
//             recCabVta."Prices Including VAT" := recCabFac."Prices Including VAT";
//             //-#232158 (RRT / MDM)

//             //+#355717
//             recCabVta."No. Telefono" := recCabFac."No. Telefono";

//             recCabVta."E-Mail" := recCabFac."E-Mail";
//             recCabVta."Ship-to Code" := recCabFac."Ship-to Code";
//             recCabVta."Ship-to Name" := recCabFac."Ship-to Name";
//             recCabVta."Ship-to Name 2" := recCabFac."Ship-to Name 2";
//             recCabVta."Ship-to Address" := recCabFac."Ship-to Address";
//             recCabVta."Ship-to Address 2" := recCabFac."Ship-to Address 2";
//             recCabVta."Ship-to City" := recCabFac."Ship-to City";
//             recCabVta."Ship-to Contact" := recCabFac."Ship-to Contact";
//             //-#355717

//             recCabVta.Modify(false);

//             recLinFac.Reset;
//             recLinFac.SetCurrentKey(Devuelto);
//             recLinFac.SetRange("Document No.", recCabFac."No.");
//             recLinFac.SetRange(Devuelto, false);
//             if recLinFac.FindSet then
//                 repeat
//                     recLinVta.Init;
//                     recLinVta.Validate("Document Type", recCabVta."Document Type");
//                     recLinVta.Validate("Document No.", recCabVta."No.");
//                     recLinVta."Line No." := recLinFac."Line No.";
//                     recLinVta.Validate(Type, recLinFac.Type);
//                     recLinVta.Validate("No.", recLinFac."No.");
//                     recLinVta.Validate("Location Code", recLinFac."Location Code");
//                     recLinVta.Validate(Quantity, recLinFac.Quantity);

//                     //+#355717
//                     if (recLinFac."Cantidad devuelta TPV" >= 0) and (recLinFac."Cantidad devuelta TPV" < recLinFac.Quantity) then
//                         recLinVta.Validate(Quantity, recLinFac.Quantity - recLinFac."Cantidad devuelta TPV");
//                     //-#355717

//                     recLinVta.Validate("Unit Price", recLinFac."Unit Price");
//                     recLinVta.Validate("Line Discount %", recLinFac."Line Discount %");
//                     recLinVta.Validate("Line Discount Amount", recLinFac."Line Discount Amount");
//                     recLinVta."Devuelve a Documento" := recCabFac."No.";
//                     recLinVta."Devuelve a Linea Documento" := recLinFac."Line No.";
//                     recLinVta.Validate("Dimension Set ID", recLinFac."Dimension Set ID");
//                     recLinVta.Insert(false);
//                 until recLinFac.Next = 0;

//             Evento.TextoRespuesta := '';

//             //+88460
//             ModificarDatosLog(lNumLog, 3, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                                 Evento.TextoRespuesta);
//             //-88460

//             case Pais of
//                 1:
//                     Evento.TextoRespuesta := cDominicana.AnularFactura(recCabVta);
//                 3:
//                     Evento.TextoRespuesta := cParaguay.AnularFactura(recCabVta); // Paraguay
//                 4:
//                     Evento.TextoRespuesta := cEcuador.AnularFactura(recCabVta); // Ecuador
//                 5:
//                     Evento.TextoRespuesta := cGuatemala.AnularFactura(recCabVta); // Guatemala
//                 6:
//                     Evento.TextoRespuesta := cSalvador.AnularFactura(recCabVta); // Salvador
//                 7:
//                     Evento.TextoRespuesta := cHonduras.AnularFactura(recCabVta); // Honduras
//                 9:
//                     Evento.TextoRespuesta := cCostaRica.AnularFactura(recCabVta); // Costa Rica  / #148807
//             end;

//             if Evento.TextoRespuesta <> '' then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 //+88460
//                 ModificarDatosLog(lNumLog, 4, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 //-88460
//                 exit(Evento.aXml());
//             end;

//             recCabVta.Modify;


//             //+#374964
//             //... Este valor hay que calcularlo antes de registrar.
//             recCabVta.CalcFields("Amount Including VAT");
//             lTotal := recCabVta."Amount Including VAT";
//             //-#374964

//             Commit;

//             if not (CODEUNIT.Run(CODEUNIT::"Ventas-Registrar DsPOS", recCabVta)) then begin
//                 Evento.TextoRespuesta := GetLastErrorText;
//                 Evento.AccionRespuesta := 'ERROR';
//                 //+88460
//                 ModificarDatosLog(lNumLog, 5, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 //-88460
//                 ClearLastError;
//             end
//             else begin

//                 recCabFac."Anulado por Documento" := recCabVta."Last Posting No.";
//                 recCabFac."Anulado TPV" := true;
//                 recCabFac.Modify(false);

//                 //+#374964
//                 //... Revisamos si hay una forma de pago asignada.
//                 lIdFormaPagoNcr := '';
//                 if lrTienda.Get(recCabFac.Tienda) then
//                     if lrTienda."Forma pago para NCR" <> '' then
//                         lIdFormaPagoNcr := lrTienda."Forma pago para NCR";
//                 //-#374964

//                 // Hacemos los pagos a la inversa para que se liquiden en central con la NC
//                 rPagos.Reset;
//                 rPagos.SetCurrentKey("No. Factura", "Cod. divisa");
//                 rPagos.SetRange("No. Factura", codPrmDoc);
//                 if rPagos.FindSet then
//                     repeat

//                         //+#374964
//                         if lIdFormaPagoNcr = '' then begin
//                             //-#374964
//                             //+#355717B - Corrección de error.
//                             //... Se ha detectado que si previamente se ha realizado una devolución, la nota de crédito se liquidaba por un importe incorrecto.

//                             //+#373762
//                             //CalcularImporteAsignacionNCR_2(rPagos,1,lMensaje,lImporte,lImporteDL);
//                             lImporte := rPagos.Importe;
//                             lImporteDL := rPagos."Importe (DL)";
//                             //-#373762

//                             //-#355717B - END.
//                             //+#374964
//                         end
//                         else begin
//                             //... No aplicamos el MODIFY!!
//                             rPagos.Validate(Importe, lTotal);
//                             lImporte := rPagos.Importe;
//                             lImporteDL := rPagos."Importe (DL)";
//                         end;
//                         //-#374964

//                         rPagosNC.Init;
//                         rPagosNC.TransferFields(rPagos);

//                         //+#355717B
//                         //rPagosNC."Importe (DL)"   := -rPagosNC."Importe (DL)";
//                         //rPagosNC.Importe          := -rPagosNC.Importe;
//                         rPagosNC."Importe (DL)" := -lImporteDL;
//                         rPagosNC.Importe := -lImporte;
//                         //-#355717

//                         rPagosNC."No. Borrador" := recCabVta."No.";
//                         rPagosNC."No. Factura" := '';
//                         rPagosNC."No. Nota Credito" := recCabVta."Last Posting No.";
//                         rPagosNC.Fecha := WorkDate;
//                         rPagosNC.Hora := FormatTime(Time);

//                         //+#374964
//                         if lIdFormaPagoNcr <> '' then
//                             rPagosNC."Forma pago TPV" := lIdFormaPagoNcr;
//                         //-#374964

//                         rPagosNC.Insert(false);
//                     //+#374964
//                     //UNTIL rPagos.NEXT = 0;
//                     until (rPagos.Next = 0) or (lIdFormaPagoNcr <> '');
//                 //-#374964

//                 GuardarAnulacionTPV(recCabVta, true);

//                 //+#374964
//                 //... He visto un caso en que falla la liquidaci?n por un error en la configuraci?n de dimensiones.
//                 //... Es necesario poner un COMMIT, ya que en este punto el documento est? registrado.
//                 Commit;
//                 //-#374964


//                 AnulaPagoFacturaTPV(codPrmDoc, recCabVta."Last Posting No.");

//                 Evento.AccionRespuesta := 'OK';
//                 Evento.TextoRespuesta := Text002;

//                 //+88460
//                 ModificarDatosLog(lNumLog, 6, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 //-88460

//                 //+76946
//                 lOk := true;
//                 ClearLastError;
//                 if not FE_Por_Pais(recCabVta, true) then begin
//                     Evento.TextoRespuesta := Text002 + ' ' + StrSubstNo(Text010, recCabVta."Last Posting No.") + '. ' + GetLastErrorText;
//                     lOk := false;
//                     ClearLastError;
//                 end;
//                 //-76946

//                 // Imprimir Nota de Credito ON
//                 //+76946
//                 //Imprimir(codPrmTienda, recCabVta."Last Posting No.");
//                 if lOk then  //+76946
//                     Imprimir(codPrmTienda, recCabVta."Last Posting No.");
//                 //-76946


//                 //+88460
//                 ModificarDatosLog(lNumLog, 7, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 //-88460

//             end;

//         end
//         else begin

//             recCab.Get(recCab."Document Type"::Invoice, codPrmDoc);
//             if recCab."Anulado TPV" then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 Evento.TextoRespuesta := StrSubstNo(Error001, recCab."No.");

//                 //+88460
//                 ModificarDatosLog(lNumLog, 8, recCab."Document Type", recCab."No.", recCab."Posting No.", recCab."No. Fiscal TPV", recCab."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 //-88460

//                 exit(Evento.aXml());
//             end;

//             //+#355717B
//             if not TestViabilidadNCR(recCab, lMensaje) then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 Evento.TextoRespuesta := lMensaje;

//                 ModificarDatosLog(lNumLog, 111, recCab."Document Type", recCab."No.", recCab."Posting No.", recCab."No. Fiscal TPV", recCab."No. Comprobante Fiscal",
//                                   Evento.TextoRespuesta);
//                 exit(Evento.aXml());
//             end;

//             //+#373762
//             /*
//             //+#374964
//             lValidar := TRUE;
//             IF lrTienda.GET(codPrmTienda) THEN
//               IF lrTienda."Forma pago para NCR" <> '' THEN
//                 lValidar := FALSE;

//             IF lValidar THEN BEGIN
//             //-#374964

//               rPagos.RESET;
//               rPagos.SETRANGE("No. Borrador" , recCab."No.");
//               IF rPagos.FINDFIRST THEN
//                 REPEAT

//                   IF NOT CalcularImporteAsignacionNCR(rPagos,0,lMensaje,lImporte,lImporteDL) THEN BEGIN
//                     Evento.AccionRespuesta  := 'ERROR';
//                     Evento.TextoRespuesta   := lMensaje;

//                     ModificarDatosLog(lNumLog,112,recCab."Document Type",recCab."No.",recCab."Posting No.",recCab."No. Fiscal TPV",recCab."No. Comprobante Fiscal",
//                                       Evento.TextoRespuesta);

//                     EXIT(Evento.aXml());

//                   END;

//               UNTIL rPagos.NEXT=0;
//               //-#355717
//             END;
//             */
//             //-#373762

//             recCabVta.Init;
//             recCabVta."Document Type" := recCabVta."Document Type"::"Credit Memo";
//             recCabVta."No." := cduNoSeries.GetNextNo(recTPV."No. serie notas credito", WorkDate, true);
//             recCabVta."No. Series" := recTPV."No. serie notas credito";
//             recCabVta."Posting No. Series" := recTPV."No. serie notas credito reg.";
//             recCabVta.Validate("Sell-to Customer No.", recCab."Sell-to Customer No.");
//             recCabVta.Validate("Order Date", WorkDate);
//             recCabVta.Validate("Posting Date", WorkDate);
//             recCabVta.Validate("Document Date", WorkDate);
//             recCabVta.Validate("Hora creacion", FormatTime(Time));

//             recCabVta."Venta TPV" := true;
//             recCabVta.Tienda := codPrmTienda;
//             recCabVta.TPV := codPrmTPV;
//             recCabVta."ID Cajero" := codPrmCajero;

//             recCabVta.Validate("Location Code", recCab."Location Code");
//             recCabVta.Validate("Currency Code", recCab."Currency Code");

//             recCabVta."Dimension Set ID" := recCab."Dimension Set ID";
//             recCabVta.Correction := true;
//             recCabVta.Turno := recCab.Turno;
//             recCabVta."Anula a Documento" := recCab."Posting No.";
//             recCabVta."Registrado TPV" := true;
//             recCabVta."Posting No." := cduNoSeries.GetNextNo(recTPV."No. serie notas credito reg.", WorkDate, true);

//             recCabVta."Sell-to Contact No." := recCab."Sell-to Contact No.";
//             recCabVta."Bill-to Contact No." := recCab."Bill-to Contact No.";
//             recCabVta."Location Code" := recCab."Location Code";

//             recCabVta.Insert(false);
//             recCabVta."Posting Description" := StrSubstNo(Text003, recCab."Posting No.");
//             recCabVta.Validate("Cod. Colegio", recCab."Cod. Colegio");
//             recCabVta.Validate("Salesperson Code", recCab."Salesperson Code");

//             recCabVta."Bill-to Name" := recCab."Bill-to Name";
//             recCabVta."Bill-to Address" := recCab."Bill-to Address";
//             recCabVta."VAT Registration No." := recCab."VAT Registration No.";

//             recCabVta."Sell-to Customer Name" := recCab."Sell-to Customer Name";
//             recCabVta."Sell-to Address" := recCab."Sell-to Address";

//             //+#232158
//             //... Al incluir el e-mail, me he fijado que los campos de envio, no salían igual...
//             recCabVta."E-Mail" := recCab."E-Mail";
//             recCabVta."Ship-to Code" := recCab."Ship-to Code";
//             recCabVta."Ship-to Name" := recCab."Ship-to Name";
//             recCabVta."Ship-to Name 2" := recCab."Ship-to Name 2";
//             recCabVta."Ship-to Address" := recCab."Ship-to Address";
//             recCabVta."Ship-to Address 2" := recCab."Ship-to Address 2";
//             recCabVta."Ship-to City" := recCab."Ship-to City";
//             recCabVta."Ship-to Contact" := recCab."Ship-to Contact";
//             //-#232158

//             //+#232158 (RRT / MDM)
//             recCabVta."Prices Including VAT" := recCab."Prices Including VAT";
//             //-#232158 (RRT / MDM)


//             //+#355717
//             recCabVta."No. Telefono" := recCab."No. Telefono";
//             //-#355717

//             recCabVta.Modify(false);

//             recLin.Reset;
//             recLin.SetCurrentKey(Devuelto, "Devuelve a Documento");
//             recLin.SetRange("Document No.", recCab."No.");
//             recLin.SetRange(Devuelto, false);
//             if recLin.FindSet then
//                 repeat
//                     recLinVta.Init;
//                     recLinVta.Validate("Document Type", recCabVta."Document Type");
//                     recLinVta.Validate("Document No.", recCabVta."No.");
//                     recLinVta."Line No." := recLin."Line No.";
//                     recLinVta.Validate(Type, recLin.Type);
//                     recLinVta.Validate("No.", recLin."No.");
//                     recLinVta.Validate("Location Code", recLin."Location Code");
//                     recLinVta.Validate(Quantity, recLin.Quantity);

//                     //+#355717
//                     if (recLin."Cantidad devuelta TPV" >= 0) and (recLin."Cantidad devuelta TPV" < recLin.Quantity) then
//                         recLinVta.Validate(Quantity, recLin.Quantity - recLin."Cantidad devuelta TPV");
//                     //-#355717

//                     recLinVta.Validate("Unit Price", recLin."Unit Price");
//                     recLinVta.Validate("Line Discount %", recLin."Line Discount %");
//                     recLinVta.Validate("Line Discount Amount", recLin."Line Discount Amount");
//                     recLinVta."Devuelve a Documento" := recCab."Posting No.";
//                     recLinVta."Devuelve a Linea Documento" := recLin."Line No.";

//                     //+#211509
//                     recLinVta."Registrado TPV" := true;
//                     //-#211509

//                     Linea_LocalizadaOFF(recLin, recLinVta);

//                     recLinVta.Insert(false);
//                 until recLin.Next = 0;

//             //+88460
//             ModificarDatosLog(lNumLog, 9, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                               '');
//             //-88460

//             Evento.TextoRespuesta := '';
//             case Pais of
//                 3:
//                     Evento.TextoRespuesta := cParaguay.AnularFactura(recCabVta); // Paraguay
//                 4:
//                     Evento.TextoRespuesta := cEcuador.AnularFactura(recCabVta); // Ecuador
//                 5:
//                     Evento.TextoRespuesta := cGuatemala.AnularFactura(recCabVta); // Guatemala
//                 6:
//                     Evento.TextoRespuesta := cSalvador.AnularFactura(recCabVta); // Salvador
//                 7:
//                     Evento.TextoRespuesta := cHonduras.AnularFactura(recCabVta); // Honduras
//                 9:
//                     Evento.TextoRespuesta := cCostaRica.AnularFactura(recCabVta); // Costa Rica / #148807
//             end;

//             if Evento.TextoRespuesta <> '' then begin
//                 Evento.AccionRespuesta := 'ERROR';
//                 //+88460
//                 ModificarDatosLog(lNumLog, 10, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                                 Evento.TextoRespuesta);
//                 //-88460
//                 exit(Evento.aXml());
//             end;

//             // Marcamos la cabecera como anualada
//             recCab."Anulado TPV" := true;
//             recCab."Anulado por Documento" := recCabVta."Posting No.";
//             recCab.Modify(false);

//             //+#374964
//             //... Revisamos si hay una forma de pago asignada.
//             lIdFormaPagoNcr := '';
//             if lrTienda.Get(recCabVta.Tienda) then
//                 if lrTienda."Forma pago para NCR" <> '' then
//                     lIdFormaPagoNcr := lrTienda."Forma pago para NCR";
//             //-#374964


//             // Hacemos los pagos a la inversa para que se liquiden en central con la NC
//             rPagos.Reset;
//             rPagos.SetRange("No. Borrador", codPrmDoc);

//             if rPagos.FindSet then
//                 repeat

//                     //+#374964
//                     if lIdFormaPagoNcr = '' then begin
//                         //-#374964

//                         //+#355717B - Corrección de error.
//                         //... Se ha detectado que si previamente se ha realizado una devolución, la nota de crédito se liquidaba por un importe incorrecto.

//                         //+#373762
//                         //CalcularImporteAsignacionNCR(rPagos,1,lMensaje,lImporte,lImporteDL);
//                         lImporte := rPagos.Importe;
//                         lImporteDL := rPagos."Importe (DL)";
//                         //-#373762

//                         //-#355717B - END.

//                         //+#374964
//                     end
//                     else begin
//                         recCabVta.CalcFields("Amount Including VAT");
//                         //... No usamos el MODIFY para rPagos.
//                         rPagos.Validate(Importe, recCabVta."Amount Including VAT");
//                         lImporte := rPagos.Importe;
//                         lImporteDL := rPagos."Importe (DL)";
//                     end;
//                     //-#374964

//                     rPagosNC.Init;
//                     rPagosNC.TransferFields(rPagos);

//                     //+#355717
//                     //rPagosNC."Importe (DL)"       := -rPagos."Importe (DL)";
//                     //rPagosNC.Importe              := -rPagos.Importe;
//                     rPagosNC."Importe (DL)" := -lImporteDL;
//                     rPagosNC.Importe := -lImporte;
//                     //-#355717

//                     rPagosNC.Fecha := WorkDate;
//                     rPagosNC.Hora := FormatTime(Time);
//                     rPagosNC."No. Borrador" := recCabVta."No.";
//                     rPagosNC."No. Factura" := '';
//                     rPagosNC."No. Nota Credito" := recCabVta."Posting No.";

//                     //+#211509
//                     rPagosNC."Registrado TPV" := true;
//                     //-#211509

//                     //+#374964
//                     if lIdFormaPagoNcr <> '' then
//                         rPagosNC."Forma pago TPV" := lIdFormaPagoNcr;
//                     //-#374964

//                     rPagosNC.Insert(false);

//                 //+#374964
//                 //UNTIL (rPagos.NEXT = 0);
//                 until (rPagos.Next = 0) or (lIdFormaPagoNcr <> '');
//             //-#374964

//             // Anulamos las transacciones de caja
//             GuardarAnulacionTPV(recCabVta, false);
//             Evento.AccionRespuesta := 'OK';
//             Evento.TextoRespuesta := Text002;

//             RelacionaAnulacion(recCabVta, codPrmTienda);

//             //+88460
//             ModificarDatosLog(lNumLog, 11, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal",
//                               Evento.TextoRespuesta);
//             //-88460

//             //+#232158
//             lOk := true;
//             //... Adaptacion a FE 2.0
//             /*
//             //+76946
//             lOk := TRUE;
//             CLEARLASTERROR;
//             IF NOT FE_Por_Pais(recCabVta,FALSE) THEN BEGIN
//               Evento.TextoRespuesta := Text002+' '+STRSUBSTNO(Text010,recCabVta."No.")+'. '+GETLASTERRORTEXT;
//               lOk := FALSE;
//               CLEARLASTERROR;
//             END;
//             //-76946
//             */

//             //... Guatemala. Llamada a la funcion para FE 2.0. Como novedad, si hay algun error no puede concluir la venta.
//             lTextoAviso := '';
//             case Pais of
//                 5:
//                     lTextoAviso := lcGuatemala.FacturacionElectronica(recCabVta, false, true);
//             end;

//             if lTextoAviso <> '' then begin
//                 //... Si no devolvemos un ERROR, el campo Registrado TPV y otros valores indican que la venta ha ido OK. Por ello, hay que hacer ROLLBACK
//                 Error(lTextoAviso);
//             end;
//             //-#232158


//             // Imprimir Nota de Credito OFF
//             //+#76046
//             //Imprimir(codPrmTienda, recCabVta."No.");
//             if lOk then  //+76946
//                          // Imprimir Nota de Credito OFF
//                 Imprimir(codPrmTienda, recCabVta."No.");
//             //-#76946

//         end;

//         //+88460
//         ModificarDatosLog(lNumLog, 12, recCabVta."Document Type", recCabVta."No.", recCabVta."Posting No.", recCabVta."No. Fiscal TPV", recCabVta."No. Comprobante Fiscal", '');
//         //-88460

//         //#88460
//         ControlDeAcceso(codPrmTienda, false);
//         //-88460

//         exit(Evento.aXml());

//     end;


//     procedure PrecioDisponibilidad(p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         rCabVta: Record "Sales Header";
//         rLinVtaTMP: Record "Sales Line" temporary;
//         Umed: Code[10];
//         CodProd: Code[20];
//         rTiendas: Record Tiendas;
//         rItem: Record Item;
//         varArray: DotNet Array;
//         rSalesH: Record "Sales Header";
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Evento.TipoEvento := 15;

//         rTiendas.Get(p_Evento.TextoDato);
//         CodProd := p_Evento.TextoDato4;
//         Buscar_Producto(CodProd, Umed);

//         with rLinVtaTMP do begin
//             Init;
//             Validate("Document Type", "Document Type"::Invoice);
//             Validate("Document No.", p_Evento.TextoDato3);
//             Validate("Line No.", 10000);
//             Validate(Type, Type::Item);
//             Temporal := true; //+#65232 para que no de error si el producto ya está en la factura
//             Validate("No.", CodProd);
//             Validate("Unit of Measure Code", Umed);
//             Validate(Quantity, 1);

//             rSalesH.Get("Document Type", "Document No.");

//             Validate("Location Code", rSalesH."Location Code");
//         end;

//         rItem.Reset;
//         rItem.Get(CodProd);
//         rItem.SetFilter("Location Filter", rTiendas."Cod. Almacen");
//         rItem.CalcFields(Inventory);

//         varArray := varArray.CreateInstance(Evento.GetTypeOfDecimal(), 10);
//         varArray.SetValue(rLinVtaTMP."Unit Price", 1);
//         varArray.SetValue(rItem.Inventory, 2);

//         Evento.AccionRespuesta := 'OK';
//         Evento.ArrayTotales := varArray;

//         exit(Evento.aXml());
//     end;


//     procedure LiquidaDocumentoTPV(codPrmDoc: Code[20]; optTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund)
//     var
//         recCabFac: Record "Sales Invoice Header";
//         recCabNC: Record "Sales Cr.Memo Header";
//         recPagosTPV: Record "Pagos TPV";
//         recTransCaja: Record "Transacciones Caja TPV";
//         CodTienda: Code[20];
//         CodCliente: Code[20];
//         Factor: Decimal;
//     begin
//         //+#65232
//         // Sustituye a las funciones LiquidaFacturaTPV y LiquidaNotaCreditoTPV

//         //Esta función genera los pagos según divisa y liquida la factura o nota de crédito TPV

//         if optTipoDoc = optTipoDoc::Invoice then begin
//             recCabFac.Get(codPrmDoc);
//             CodTienda := recCabFac.Tienda;
//             CodCliente := recCabFac."Bill-to Customer No.";
//             Factor := 1;
//         end
//         else begin
//             recCabNC.Get(codPrmDoc);
//             CodTienda := recCabNC.Tienda;
//             CodCliente := recCabNC."Bill-to Customer No.";
//             Factor := -1
//         end;

//         //Primero se comprueba que no se haya liquidado el mov. cliente
//         if MovClientePendiente(CodCliente, optTipoDoc, codPrmDoc) then begin
//             // damos prioridad a la transacción de caja, es más fiable que pagos TPV
//             if TieneTransaccionCaja(recTransCaja, CodTienda, codPrmDoc) then begin
//                 with recTransCaja do begin

//                     if FindSet then
//                         repeat
//                             SetRange("Cod. divisa", "Cod. divisa");
//                             SetRange("NCR regis. de compensacion", "NCR regis. de compensacion");  //+#70132
//                             CalcSums(Importe);
//                             // Primero registramos los pagos
//                             if (Importe * Factor) > 0 then;
//                             RegistrarPagoDocumento(codPrmDoc, optTipoDoc, "Cod. tienda", "Cod. divisa", Importe, "Forma de pago", "NCR regis. de compensacion");  //+#70132

//                             FindLast;
//                             SetRange("Cod. divisa");
//                             SetRange("NCR regis. de compensacion");  //+#70132
//                         until Next = 0;

//                     if FindSet then
//                         repeat
//                             SetRange("Cod. divisa", "Cod. divisa");
//                             SetRange("NCR regis. de compensacion", "NCR regis. de compensacion");  //+#70132
//                             CalcSums(Importe);
//                             // Si quedan reembolsos, se liquidan contra pagos pendientes.
//                             if (Importe * Factor) < 0 then
//                                 RegistrarPagoDocumento(codPrmDoc, optTipoDoc, "Cod. tienda", "Cod. divisa", Importe, "Forma de pago", "NCR regis. de compensacion");  //+#70132

//                             FindLast;
//                             SetRange("Cod. divisa");
//                             SetRange("NCR regis. de compensacion");  //+#70132
//                         until Next = 0;

//                     if optTipoDoc = optTipoDoc::Invoice then begin
//                         recCabFac."Liquidado TPV" := true;
//                         recCabFac.Modify(false);
//                     end
//                     else begin
//                         recCabNC."Liquidado TPV" := true;
//                         recCabNC.Modify(false);
//                     end;

//                 end;
//             end
//             else begin
//                 with recPagosTPV do begin
//                     Reset;
//                     if optTipoDoc = optTipoDoc::Invoice then begin
//                         SetCurrentKey("No. Factura", "Cod. divisa");
//                         SetRange("No. Factura", recCabFac."No.");
//                     end
//                     else begin
//                         SetCurrentKey("No. Nota Credito", "Cod. divisa");
//                         SetRange("No. Nota Credito", recCabNC."No.");
//                     end;
//                     SetRange(Tienda, CodTienda);
//                     if FindSet then
//                         repeat
//                             if "Cod. divisa" = '' then
//                                 SetFilter("Forma pago TPV", '<>EXIVA');
//                             SetRange("Cod. divisa", "Cod. divisa");
//                             SetRange("NCR regis. de compensacion", "NCR regis. de compensacion");  //+#70132
//                             CalcFields("Importe Total divisa");
//                             // Primero registramos los pagos
//                             if ("Importe Total divisa" * Factor) > 0 then
//                                 RegistrarPagoDocumento(codPrmDoc, optTipoDoc, Tienda, "Cod. divisa", "Importe Total divisa", "Forma pago TPV", "NCR regis. de compensacion");  //+#70132

//                             FindLast;
//                             SetRange("Cod. divisa");
//                             SetRange("Forma pago TPV");
//                             SetRange("NCR regis. de compensacion");  //+#70132

//                         until Next = 0;

//                     if FindSet then
//                         repeat
//                             if "Cod. divisa" = '' then
//                                 SetFilter("Forma pago TPV", '<>EXIVA');
//                             SetRange("Cod. divisa", "Cod. divisa");
//                             SetRange("NCR regis. de compensacion", "NCR regis. de compensacion");  //+#70132
//                             CalcFields("Importe Total divisa");
//                             // Si quedan reembolsos, se liquidan contra pagos pendientes.
//                             if ("Importe Total divisa" * Factor) < 0 then
//                                 RegistrarPagoDocumento(codPrmDoc, optTipoDoc, Tienda, "Cod. divisa", "Importe Total divisa", "Forma pago TPV", "NCR regis. de compensacion");  //+#70132

//                             FindLast;
//                             SetRange("Cod. divisa");
//                             SetRange("Forma pago TPV");
//                             SetRange("NCR regis. de compensacion");  //+#70132
//                         until Next = 0;

//                     if optTipoDoc = optTipoDoc::Invoice then begin
//                         recCabFac."Liquidado TPV" := true;
//                         recCabFac.Modify(false);
//                     end
//                     else begin
//                         recCabNC."Liquidado TPV" := true;
//                         recCabNC.Modify(false);
//                     end;

//                 end;
//             end;
//         end
//         else begin
//             //+#308268
//             //... De momento solo lo aplicamos a las facturas.....
//             //...
//             if optTipoDoc = optTipoDoc::Invoice then begin
//                 if not recCabFac."Liquidado TPV" then begin
//                     recCabFac."Liquidado TPV" := true;
//                     recCabFac.Modify;
//                 end;
//             end;
//             //-#308268

//         end;
//     end;


//     procedure RegistrarPagoDocumento(codPrmDoc: Code[20]; optTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; codTienda: Code[20]; codDivisa: Code[10]; decImporte: Decimal; CodFormaPago: Code[20]; pNCR: Code[20])
//     var
//         recCfgPOS: Record "Configuracion General DsPOS";
//         recBancosTienda: Record "Bancos tienda";
//         recLinDiaGen: Record "Gen. Journal Line";
//         recLinDiaGen2: Record "Gen. Journal Line";
//         recLinDiaGen3: Record "Gen. Journal Line";
//         recCabFac: Record "Sales Invoice Header";
//         recCabNC: Record "Sales Cr.Memo Header";
//         rTiendas: Record Tiendas;
//         cduRegDia: Codeunit "Gen. Jnl.-Post Line";
//         intLinea: Integer;
//         Text001: Label 'Liq. Factura TPV Doc. %1';
//         Text002: Label 'Liq. Devolucion TPV Doc. %1';
//         Text003: Label 'EXIVA Doc. %1 Exen: %2';
//         SalesPersonCode: Code[10];
//         CodCliente: Code[20];
//         PostingDate: Date;
//         NoFiscal: Code[40];
//         ExtDocumentNo: Code[35];
//         NoBorrador: Code[20];
//         rPagosTPV: Record "Pagos TPV";
//         lwImporteEX: Decimal;
//         recFormaPago: Record "Formas de Pago";
//         VatNo: Text[35];
//         CustName: Text[80];
//         lFormaPagoCompensacionNC: Boolean;
//         lrFP: Record "Formas de Pago";
//         lrNCR: Record "Sales Cr.Memo Header";
//         TextL004: Label 'Liq. NCR %1';
//     begin
//         //+#65232
//         // Sustituye a las funciones RegistrarPagoFactura y RegistrarPagoNotaCredito

//         recCfgPOS.Get;
//         recCfgPOS.TestField("Nombre libro diario");
//         recCfgPOS.TestField("Nombre seccion diario");

//         recBancosTienda.Get(codTienda, codDivisa);
//         recBancosTienda.TestField("Cod. Banco");

//         if optTipoDoc = optTipoDoc::Invoice then begin
//             recCabFac.Get(codPrmDoc);
//             CodCliente := recCabFac."Bill-to Customer No.";
//             SalesPersonCode := recCabFac."Salesperson Code";
//             PostingDate := recCabFac."Posting Date";
//             NoFiscal := recCabFac."No. Fiscal TPV";
//             ExtDocumentNo := recCabFac."External Document No.";
//             NoBorrador := recCabFac."Pre-Assigned No.";
//             VatNo := recCabFac."VAT Registration No."; //+#78451
//             CustName := CopyStr(recCabFac."Bill-to Name", 1, MaxStrLen(CustName)); //+#78451

//         end
//         else begin
//             recCabNC.Get(codPrmDoc);
//             CodCliente := recCabNC."Bill-to Customer No.";
//             SalesPersonCode := recCabNC."Salesperson Code";
//             PostingDate := recCabNC."Posting Date";
//             NoFiscal := recCabNC."No. Fiscal TPV";
//             ExtDocumentNo := recCabNC."External Document No.";
//             NoBorrador := recCabNC."Pre-Assigned No.";
//             VatNo := recCabNC."VAT Registration No."; //+#78451
//             CustName := CopyStr(recCabNC."Bill-to Name", 1, MaxStrLen(CustName)); //+#78451
//         end;

//         with recLinDiaGen do begin
//             Init;
//             Validate("Journal Template Name", recCfgPOS."Nombre libro diario");
//             Validate("Journal Batch Name", recCfgPOS."Nombre seccion diario");
//             Validate("Salespers./Purch. Code", SalesPersonCode);
//             Validate("Account Type", "Account Type"::Customer);
//             Validate("Account No.", CodCliente);
//             Validate("Posting Date", PostingDate);

//             //+999 PLB
//             //IF USERID = 'SANTILLANA-NAV\DYNASOFT' THEN
//             //  VALIDATE("Posting Date",           WORKDATE);
//             //-999 PLB

//             if decImporte > 0 then begin
//                 if optTipoDoc = optTipoDoc::Invoice then
//                     Validate("Applies-to Doc. Type", "Applies-to Doc. Type"::Invoice)
//                 else
//                     Validate("Applies-to Doc. Type", "Applies-to Doc. Type"::Refund);
//                 Validate("Applies-to Doc. No.", codPrmDoc);
//                 Validate("Document Type", "Document Type"::Payment);
//             end
//             else begin
//                 if optTipoDoc = optTipoDoc::Invoice then
//                     Validate("Applies-to Doc. Type", "Applies-to Doc. Type"::Payment)
//                 else
//                     Validate("Applies-to Doc. Type", "Applies-to Doc. Type"::"Credit Memo");
//                 Validate("Applies-to Doc. No.", codPrmDoc);
//                 Validate("Document Type", "Document Type"::Refund);
//             end;

//             "Document No." := codPrmDoc;
//             if optTipoDoc = optTipoDoc::Invoice then
//                 Description := StrSubstNo(Text001, NoFiscal)
//             else
//                 Description := StrSubstNo(Text002, NoFiscal);

//             //+#70132
//             lFormaPagoCompensacionNC := false;
//             if pNCR <> '' then
//                 if lrNCR.Get(pNCR) then
//                     if lrFP.Get(CodFormaPago) then
//                         if lrFP."Tipo Compensacion NC" = lrFP."Tipo Compensacion NC"::"Sí" then
//                             lFormaPagoCompensacionNC := true;
//             //-#70132

//             "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
//             Validate("Bal. Account No.", recBancosTienda."Cod. Banco");
//             "External Document No." := ExtDocumentNo;
//             Validate("Currency Code", codDivisa);

//             //+#124085
//             //... Por si acaso......, la siguiente acción sòlo se realizará (al menos de momento) para El Salvador.
//             if Pais = 6 then begin
//                 //+#78451
//                 recFormaPago.Get(CodFormaPago);
//                 if recFormaPago."Forma pago" <> '' then
//                     recLinDiaGen."Payment Method Code" := recFormaPago."Forma pago";
//                 recLinDiaGen."VAT Registration No." := VatNo;

//                 case Pais of
//                     6:
//                         cSalvador.DiarioGeneralPago(recLinDiaGen, CodFormaPago, CustName, NoFiscal); //+#82483
//                 end;
//                 //-#78451
//             end;
//             //-#124085

//             //Comprobamos si tiene exención de IVA
//             if codDivisa = '' then begin
//                 rPagosTPV.Reset;
//                 rPagosTPV.SetRange("No. Borrador", NoBorrador);
//                 rPagosTPV.SetRange("Forma pago TPV", 'EXIVA');
//                 if rPagosTPV.FindFirst then begin
//                     lwImporteEX := rPagosTPV."Importe (DL)";
//                     recLinDiaGen2.TransferFields(recLinDiaGen);
//                 end;
//             end;

//             Validate(Amount, -decImporte + lwImporteEX);
//             cduRegDia.RunWithCheck(recLinDiaGen);

//             //+#70132
//             if lFormaPagoCompensacionNC then begin
//                 recLinDiaGen3.TransferFields(recLinDiaGen);
//                 recLinDiaGen3."Applies-to Doc. Type" := recLinDiaGen3."Applies-to Doc. Type"::"Credit Memo";
//                 recLinDiaGen3."Applies-to Doc. No." := lrNCR."No.";
//                 recLinDiaGen3.Description := StrSubstNo(TextL004, lrNCR."No.");
//                 recLinDiaGen3.Validate(Amount, -recLinDiaGen.Amount);
//                 cduRegDia.RunWithCheck(recLinDiaGen3);
//             end;
//             //-#70132

//             if lwImporteEX <> 0 then begin
//                 rTiendas.Get(codTienda);
//                 recLinDiaGen2.Description := StrSubstNo(Text003, NoFiscal, rPagosTPV."No. Documento Exencion");
//                 recLinDiaGen2."Bal. Account Type" := recLinDiaGen."Bal. Account Type"::"G/L Account";
//                 recLinDiaGen2.Validate("Bal. Account No.", rTiendas."Cuenta Excencion IVA");
//                 recLinDiaGen2.Validate(Amount, -lwImporteEX);
//                 cduRegDia.RunWithCheck(recLinDiaGen2);
//             end;
//         end;
//     end;


//     procedure TieneTransaccionCaja(var recTransCaja: Record "Transacciones Caja TPV"; CodTienda: Code[20]; NoRegistrado: Code[20]): Boolean
//     begin
//         with recTransCaja do begin
//             Reset;
//             SetCurrentKey("No. Registrado", "Cod. divisa");
//             SetRange("No. Registrado", NoRegistrado);
//             SetRange("Cod. tienda", CodTienda);
//             //SETRANGE(TPV                , recCabFac.TPV);  // Comentar para posibles ventas en diferentes TPV's
//             exit(not IsEmpty);
//         end;
//     end;


//     procedure LiquidaFacturaTPV_Obsoleto(codPrmDoc: Code[20])
//     var
//         recCabFac: Record "Sales Invoice Header";
//         recPagosTPV: Record "Pagos TPV";
//         recTienda: Record Tiendas;
//     begin
//         //+#65232: Función obsoleta
//         /*
//         //Esta función genera los pagos según divisa y liquida la factura TPV
        
//         recCabFac.GET(codPrmDoc);
        
//         //Primero se comprueba que no se haya liquidado el mov. cliente
//         IF MovClientePendiente(recCabFac."Bill-to Customer No.",optTipoDoc::Invoice,recCabFac."No.") THEN BEGIN
//           //Primero registramos los pagos
//           recPagosTPV.RESET;
//           recPagosTPV.SETCURRENTKEY("No. Factura" , "Cod. divisa");
//           recPagosTPV.SETRANGE("No. Factura"      , recCabFac."No.");
//           recPagosTPV.SETRANGE(Tienda             , recCabFac.Tienda);
//           //recPagosTPV.SETRANGE(TPV                , recCabFac.TPV);  // Comentar para posibles ventas en diferentes TPV's
//           IF recPagosTPV.FINDSET THEN
//             REPEAT
//               recPagosTPV.SETRANGE("Cod. divisa", recPagosTPV."Cod. divisa");
//               recPagosTPV.FINDLAST;
        
//               IF recPagosTPV."Cod. divisa" = '' THEN
//                 recPagosTPV.SETFILTER("Forma pago TPV",'<>EXIVA');
        
//               recPagosTPV.SETRANGE("Cod. divisa");
//               recPagosTPV.CALCFIELDS("Importe Total divisa");
//               IF recPagosTPV."Importe Total divisa" > 0 THEN
//                 RegistrarPagoFactura(recCabFac,recPagosTPV);
        
//            UNTIL recPagosTPV.NEXT = 0;
        
//            recCabFac."Liquidado TPV" := TRUE;
//            recCabFac.MODIFY(FALSE);
        
//           //si quedan reembolsos, se liquidan contra pagos pendientes.
//           recPagosTPV.RESET;
//           recPagosTPV.SETCURRENTKEY("No. Factura" , "Cod. divisa");
//           recPagosTPV.SETRANGE("No. Factura"      , recCabFac."No.");
//           recPagosTPV.SETRANGE(Tienda             , recCabFac.Tienda);
//           //recPagosTPV.SETRANGE(TPV                , recCabFac.TPV);
//           IF recPagosTPV.FINDSET THEN
//             REPEAT
//               recPagosTPV.SETRANGE("Cod. divisa", recPagosTPV."Cod. divisa");
//               recPagosTPV.FINDLAST;
//               recPagosTPV.SETRANGE("Cod. divisa");
//               recPagosTPV.CALCFIELDS("Importe Total divisa");
//               IF recPagosTPV."Importe Total divisa" < 0 THEN
//                 RegistrarPagoFactura(recCabFac,recPagosTPV);
        
//            UNTIL recPagosTPV.NEXT = 0;
//         END;
//         */

//     end;


//     procedure RegistrarPagoFactura_Obsoleto(recPrmCabFac: Record "Sales Invoice Header"; codTienda: Code[20]; codDivisa: Code[10]; decImporte: Decimal)
//     var
//         recCfgPOS: Record "Configuracion General DsPOS";
//         recBancosTienda: Record "Bancos tienda";
//         recLinDiaGen: Record "Gen. Journal Line";
//         cduRegDia: Codeunit "Gen. Jnl.-Post Line";
//         intLinea: Integer;
//         Text001: Label 'Liq. Factura TPV Doc. %1';
//         Text002: Label 'EXIVA Doc. %1 Exen: %2';
//         rPagosTPV: Record "Pagos TPV";
//         lwImporteEX: Decimal;
//     begin
//         //+#65232: Función obsoleta
//         /*
//         recCfgPOS.GET;
//         recCfgPOS.TESTFIELD("Nombre libro diario");
//         recCfgPOS.TESTFIELD("Nombre sección diario");
        
//         //recBancosTienda.GET(recPrmPagoTPV.Tienda,recPrmPagoTPV."Cod. divisa"); //-#65232
//         recBancosTienda.GET(codTienda,codDivisa); //+#65232
//         recBancosTienda.TESTFIELD("Cod. Banco");
        
//         WITH recPrmCabFac DO BEGIN
//           recLinDiaGen.INIT;
//           recLinDiaGen.VALIDATE("Journal Template Name",  recCfgPOS."Nombre libro diario");
//           recLinDiaGen.VALIDATE("Journal Batch Name",     recCfgPOS."Nombre sección diario");
//           recLinDiaGen.VALIDATE("Salespers./Purch. Code", "Salesperson Code");
//           recLinDiaGen.VALIDATE("Account Type",           recLinDiaGen."Account Type"::Customer);
//           recLinDiaGen.VALIDATE("Account No.",            "Bill-to Customer No.");
//           recLinDiaGen.VALIDATE("Posting Date",           "Posting Date");
//           //+#65232 PLB
//           //IF USERID = 'SANTILLANA-NAV\DYNASOFT' THEN
//           //  recLinDiaGen.VALIDATE("Posting Date",           WORKDATE);
//           //-#65232 PLB
        
//           //IF recPrmPagoTPV."Importe Total divisa" > 0 THEN BEGIN //-#65232
//           IF decImporte > 0 THEN BEGIN //+#65232
//             recLinDiaGen.VALIDATE("Applies-to Doc. Type", recLinDiaGen."Applies-to Doc. Type"::Invoice);
//             recLinDiaGen.VALIDATE("Applies-to Doc. No.",  "No.");
//             recLinDiaGen.VALIDATE("Document Type",        recLinDiaGen."Document Type"::Payment);
//           END
//           ELSE BEGIN
//             recLinDiaGen.VALIDATE("Applies-to Doc. Type", recLinDiaGen."Applies-to Doc. Type"::Payment);
//             recLinDiaGen.VALIDATE("Applies-to Doc. No.",  "No.");
//             recLinDiaGen.VALIDATE("Document Type",        recLinDiaGen."Document Type"::Refund);
//           END;
        
//           recLinDiaGen."Document No."                     := "No.";
//           recLinDiaGen.Description                        := STRSUBSTNO(Text001, "Nº Fiscal TPV");
//           recLinDiaGen."Bal. Account Type"                := recLinDiaGen."Bal. Account Type"::"Bank Account";
//           recLinDiaGen.VALIDATE("Bal. Account No.",       recBancosTienda."Cod. Banco");
//           recLinDiaGen."External Document No."            := "External Document No.";
//           //+#65232
//           //recLinDiaGen.VALIDATE("Currency Code",          recPrmPagoTPV."Cod. divisa");
//           //recLinDiaGen.VALIDATE(Amount,                   -recPrmPagoTPV."Importe Total divisa");
//           recLinDiaGen.VALIDATE("Currency Code",          codDivisa);
        
//           //Comprobamos si tiene exención de IVA
//           IF recPrmPagoTPV."Cod. divisa" = '' THEN BEGIN
//             rPagosTPV.RESET;
//             rPagosTPV.SETRANGE("No. Borrador"   , recPrmPagoTPV."No. Borrador");
//             rPagosTPV.SETRANGE("Forma pago TPV" ,'EXIVA');
//             IF rPagosTPV.FINDFIRST THEN BEGIN
//               lwImporteEX := rPagosTPV."Importe (DL)";
//               recLinDiaGen2.TRANSFERFIELDS(recLinDiaGen);
//             END;
//           END;
        
//           recLinDiaGen.VALIDATE(Amount,                   -decImporte+lwImporteEX);
//           //-#65232
//           cduRegDia.RunWithCheck(recLinDiaGen);
        
//           IF lwImporteEX <> 0 THEN BEGIN
//             rTiendas.GET(recPrmCabFac.Tienda);
//             recLinDiaGen2.Description                        := STRSUBSTNO(Text002, "Nº Fiscal TPV",rPagosTPV."No. Documento Exencion");
//             recLinDiaGen2."Bal. Account Type"                := recLinDiaGen."Bal. Account Type"::"G/L Account";
//             recLinDiaGen2.VALIDATE("Bal. Account No.",       rTiendas."Cuenta Excencion IVA");
//             recLinDiaGen2.VALIDATE(Amount,                   -lwImporteEX);
//             cduRegDia.RunWithCheck(recLinDiaGen2);
//           END;
        
//         END;
//         */

//     end;


//     procedure LiquidaNotaCreditoTPV_Obsoleto(codPrmDoc: Code[20])
//     var
//         recCabNC: Record "Sales Cr.Memo Header";
//         recPagosTPV: Record "Pagos TPV";
//     begin
//         //+#65232: Función obsoleta
//         /*
//         //Esta función genera los pagos según divisa y liquida la nota de crédito TPV
        
//         recCabNC.GET(codPrmDoc);
        
//         //Primero se comprueba que no se haya liquidado el mov. cliente
//         IF MovClientePendiente(recCabNC."Bill-to Customer No.",optTipoDoc::"Credit Memo",recCabNC."No.") THEN BEGIN
        
//           recPagosTPV.RESET;
//           recPagosTPV.SETCURRENTKEY("No. Nota Credito" , "Cod. divisa");
//           recPagosTPV.SETRANGE("No. Nota Credito"      , recCabNC."No.");
//           recPagosTPV.SETRANGE(Tienda                  , recCabNC.Tienda);
//         //  recPagosTPV.SETRANGE(TPV                     , recCabNC.TPV); //-#65232
//           IF recPagosTPV.FINDSET THEN
//             REPEAT
//               recPagosTPV.SETRANGE("Cod. divisa", recPagosTPV."Cod. divisa");
//               recPagosTPV.FINDLAST;
//               recPagosTPV.SETRANGE("Cod. divisa");
//               recPagosTPV.CALCFIELDS("Importe Total divisa");
//               IF recPagosTPV."Importe Total divisa" < 0 THEN BEGIN
//                 RegistrarPagoNotaCredito(recCabNC,recPagosTPV)
//               END;
//            UNTIL recPagosTPV.NEXT = 0;
        
//            recCabNC."Liquidado TPV" := TRUE;
//            recCabNC.MODIFY(FALSE);
        
//           recPagosTPV.RESET;
//           recPagosTPV.SETCURRENTKEY("No. Nota Credito" , "Cod. divisa");
//           recPagosTPV.SETRANGE("No. Nota Credito"      , recCabNC."No.");
//           recPagosTPV.SETRANGE(Tienda                  , recCabNC.Tienda);
//           //recPagosTPV.SETRANGE(TPV                     , recCabNC.TPV); //-#65232
//           IF recPagosTPV.FINDSET THEN
//             REPEAT
//               recPagosTPV.SETRANGE("Cod. divisa", recPagosTPV."Cod. divisa");
//               recPagosTPV.FINDLAST;
//               recPagosTPV.SETRANGE("Cod. divisa");
//               recPagosTPV.CALCFIELDS("Importe Total divisa");
//               IF recPagosTPV."Importe Total divisa" > 0 THEN
//                 RegistrarPagoNotaCredito(recCabNC,recPagosTPV);
        
//            UNTIL recPagosTPV.NEXT = 0;
        
        
//         END;
//         */

//     end;


//     procedure RegistrarPagoNotaCredito_Obsoleto(recPrmCabNC: Record "Sales Cr.Memo Header"; recPrmPagoTPV: Record "Pagos TPV")
//     var
//         recCfgPOS: Record "Configuracion General DsPOS";
//         recBancosTienda: Record "Bancos tienda";
//         recLinDiaGen: Record "Gen. Journal Line";
//         cduRegDia: Codeunit "Gen. Jnl.-Post Line";
//         intLinea: Integer;
//         Text001: Label 'Liq. Devolucion TPV Doc. %1';
//         Text002: Label 'EXIVA Doc. %1 Exen: %2';
//         rPagosTPV: Record "Pagos TPV";
//         lwImporteEX: Decimal;
//     begin
//         //+#65232: Función obsoleta
//         /*
//         recCfgPOS.GET;
//         recCfgPOS.TESTFIELD("Nombre libro diario");
//         recCfgPOS.TESTFIELD("Nombre sección diario");
        
//         recBancosTienda.GET(recPrmPagoTPV.Tienda,recPrmPagoTPV."Cod. divisa");
//         recBancosTienda.TESTFIELD("Cod. Banco");
        
//         WITH recPrmCabNC DO BEGIN
//           recLinDiaGen.INIT;
//           recLinDiaGen.VALIDATE("Journal Template Name",  recCfgPOS."Nombre libro diario");
//           recLinDiaGen.VALIDATE("Journal Batch Name",     recCfgPOS."Nombre sección diario");
//           recLinDiaGen.VALIDATE("Salespers./Purch. Code", "Salesperson Code");
//           recLinDiaGen.VALIDATE("Account Type",           recLinDiaGen."Account Type"::Customer);
//           recLinDiaGen.VALIDATE("Account No.",            "Bill-to Customer No.");
//           recLinDiaGen.VALIDATE("Posting Date",           "Posting Date");
        
//           IF recPrmPagoTPV."Importe Total divisa" < 0 THEN BEGIN
//             recLinDiaGen.VALIDATE("Applies-to Doc. Type", recLinDiaGen."Applies-to Doc. Type"::"Credit Memo");
//             recLinDiaGen.VALIDATE("Applies-to Doc. No.",  "No.");
//             recLinDiaGen.VALIDATE("Document Type",        recLinDiaGen."Document Type"::Refund);
//           END
//           ELSE BEGIN
//             recLinDiaGen.VALIDATE("Applies-to Doc. Type", recLinDiaGen."Applies-to Doc. Type"::Refund);
//             recLinDiaGen.VALIDATE("Applies-to Doc. No.",  "No.");
//             recLinDiaGen.VALIDATE("Document Type",        recLinDiaGen."Document Type"::Payment);
//           END;
        
//           recLinDiaGen."Document No."                     := "No.";
//           recLinDiaGen.Description                        := STRSUBSTNO(Text001, "Nº Fiscal TPV");
//           recLinDiaGen."Bal. Account Type"                := recLinDiaGen."Bal. Account Type"::"Bank Account";
//           recLinDiaGen.VALIDATE("Bal. Account No.",       recBancosTienda."Cod. Banco");
//           recLinDiaGen."External Document No."            := "External Document No.";
//           recLinDiaGen.VALIDATE("Currency Code",          recPrmPagoTPV."Cod. divisa");
        
//           //Comprobamos si tiene exención de IVA
//           IF recPrmPagoTPV."Cod. divisa" = '' THEN BEGIN
//             rPagosTPV.RESET;
//             rPagosTPV.SETRANGE("No. Borrador"   , recPrmPagoTPV."No. Borrador");
//             rPagosTPV.SETRANGE("Forma pago TPV" ,'EXIVA');
//             IF rPagosTPV.FINDFIRST THEN BEGIN
//               lwImporteEX := rPagosTPV."Importe (DL)";
//               recLinDiaGen2.TRANSFERFIELDS(recLinDiaGen);
//             END;
//           END;
        
//           recLinDiaGen.VALIDATE(Amount,                   -recPrmPagoTPV."Importe Total divisa"+lwImporteEX);
//           cduRegDia.RunWithCheck(recLinDiaGen);
        
//           IF lwImporteEX <> 0 THEN BEGIN
//             rTiendas.GET(recPrmCabNC.Tienda);
//             recLinDiaGen2.Description                        := STRSUBSTNO(Text002, "Nº Fiscal TPV",rPagosTPV."No. Documento Exencion");
//             recLinDiaGen2."Bal. Account Type"                := recLinDiaGen."Bal. Account Type"::"G/L Account";
//             recLinDiaGen2.VALIDATE("Bal. Account No.",       rTiendas."Cuenta Excencion IVA");
//             recLinDiaGen2.VALIDATE(Amount,                   -lwImporteEX);
//             cduRegDia.RunWithCheck(recLinDiaGen2);
//           END;
        
        
//         END;
//         */

//     end;


//     procedure AnulaPagoFacturaTPV(codPrmFac: Code[20]; codPrmHNC: Code[20])
//     var
//         recCfgPOS: Record "Configuracion General DsPOS";
//         recCabNC: Record "Sales Cr.Memo Header";
//         recCabFac: Record "Sales Invoice Header";
//         recPagosTPV: Record "Pagos TPV";
//         recBancosTienda: Record "Bancos tienda";
//         recLinDiaGen: Record "Gen. Journal Line";
//         cduRegDia: Codeunit "Gen. Jnl.-Post Line";
//         Text001: Label 'Liq. Nota Crédito TPV Doc. %1';
//     begin
//         //Esta funció busca los pagos introducidos en la factura y liquida la nota de credito contra las mismas cuenta de banco.

//         recCfgPOS.Get;
//         recCabFac.Get(codPrmFac);
//         recCabNC.Get(codPrmHNC);

//         recPagosTPV.Reset;
//         recPagosTPV.SetCurrentKey("No. Factura", "Cod. divisa");
//         recPagosTPV.SetRange("No. Factura", recCabFac."No.");
//         recPagosTPV.SetRange(Tienda, recCabFac.Tienda);
//         recPagosTPV.SetRange(TPV, recCabFac.TPV);
//         if recPagosTPV.FindSet then
//             repeat
//                 recPagosTPV.SetRange("Cod. divisa", recPagosTPV."Cod. divisa");
//                 recPagosTPV.FindLast;
//                 recPagosTPV.CalcFields("Importe Total divisa");
//                 if recPagosTPV."Importe Total divisa" <> 0 then begin
//                     recBancosTienda.Get(recPagosTPV.Tienda, recPagosTPV."Cod. divisa");
//                     recBancosTienda.TestField("Cod. Banco");
//                     recLinDiaGen.Init;
//                     recLinDiaGen.Validate("Journal Template Name", recCfgPOS."Nombre libro diario");
//                     recLinDiaGen.Validate("Journal Batch Name", recCfgPOS."Nombre seccion diario");
//                     recLinDiaGen.Validate("Account Type", recLinDiaGen."Account Type"::Customer);
//                     recLinDiaGen.Validate("Account No.", recCabFac."Sell-to Customer No.");
//                     recLinDiaGen.Validate("Posting Date", recCabFac."Posting Date");
//                     recLinDiaGen.Validate("Applies-to Doc. Type", recLinDiaGen."Applies-to Doc. Type"::"Credit Memo");
//                     recLinDiaGen.Validate("Applies-to Doc. No.", recCabNC."No.");
//                     recLinDiaGen.Validate("Document Type", recLinDiaGen."Document Type"::Payment);
//                     recLinDiaGen."Document No." := recCabNC."No.";
//                     recLinDiaGen.Description := StrSubstNo(Text001, recCabNC."No.");
//                     recLinDiaGen."Bal. Account Type" := recLinDiaGen."Bal. Account Type"::"Bank Account";
//                     recLinDiaGen.Validate("Bal. Account No.", recBancosTienda."Cod. Banco");
//                     recLinDiaGen."External Document No." := recCabFac."No.";
//                     recLinDiaGen.Validate("Salespers./Purch. Code", recCabFac."Salesperson Code");
//                     recLinDiaGen.Validate("Currency Code", recPagosTPV."Cod. divisa");
//                     recLinDiaGen.Validate(Amount, recPagosTPV."Importe Total divisa");
//                     recLinDiaGen.Validate("Dimension Set ID", GetDimensionSetIDMovCliente(codPrmHNC));
//                     cduRegDia.RunWithCheck(recLinDiaGen);
//                 end;
//             until recPagosTPV.Next = 0;
//     end;


//     procedure MovClientePendiente(codPrmCliente: Code[20]; optPrmTipoDoc: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; codPrmDoc: Code[20]): Boolean
//     var
//         recMovCliente: Record "Cust. Ledger Entry";
//     begin

//         recMovCliente.Reset;
//         recMovCliente.SetCurrentKey("Document No.", "Document Type", "Customer No.");
//         recMovCliente.SetRange("Document Type", optPrmTipoDoc);
//         recMovCliente.SetRange("Document No.", codPrmDoc);
//         recMovCliente.SetRange("Customer No.", codPrmCliente);
//         recMovCliente.SetRange(Open, true);
//         //EXIT(recMovCliente.FINDFIRST); //-65232
//         exit(not recMovCliente.IsEmpty); //+65232
//     end;


//     procedure Efectivo_Local(): Code[20]
//     var
//         rFpago: Record "Formas de Pago";
//     begin

//         rFpago.Reset;
//         rFpago.SetCurrentKey("Efectivo Local", "Cod. divisa");
//         rFpago.SetRange("Efectivo Local", true);
//         rFpago.FindFirst;
//         exit(rFpago."ID Pago");
//     end;


//     procedure GuardarVentaTPV(recPrmCabVta: Record "Sales Header"; blnRegistroEnLinea: Boolean)
//     var
//         recPagosTPV: Record "Pagos TPV";
//         Text001: Label 'Liq. factura TPV Doc. %1';
//         recVentaTPV: Record "Transacciones TPV";
//         recCabFac: Record "Sales Invoice Header";
//         decImporte: Decimal;
//         decImporteIVA: Decimal;
//         Devolucion: Boolean;
//         recCabNC: Record "Sales Cr.Memo Header";
//     begin

//         with recPrmCabVta do begin

//             if blnRegistroEnLinea then begin

//                 case "Document Type" of

//                     "Document Type"::Invoice:
//                         begin

//                             recCabFac.Get("Last Posting No.");
//                             recCabFac.CalcFields(Amount);
//                             recCabFac.CalcFields("Amount Including VAT");

//                             decImporte := recCabFac.Amount;
//                             decImporteIVA := recCabFac."Amount Including VAT";

//                             recCabFac."Cod. Colegio" := recPrmCabVta."Cod. Colegio";
//                             recCabFac."Nombre Colegio" := recPrmCabVta."Nombre Colegio";
//                             recCabFac.Modify(false);

//                         end;

//                     "Document Type"::"Credit Memo":
//                         begin

//                             Devolucion := true;
//                             recCabNC.Get("Last Posting No.");
//                             recCabNC.CalcFields(Amount);
//                             recCabNC.CalcFields("Amount Including VAT");

//                             decImporte := -recCabNC.Amount;
//                             decImporteIVA := -recCabNC."Amount Including VAT";

//                             recCabNC."Cod. Colegio" := recPrmCabVta."Cod. Colegio";
//                             recCabNC."Nombre Colegio" := recPrmCabVta."Nombre Colegio";
//                             recCabNC.Modify(false);

//                         end;
//                 end;

//             end
//             else begin

//                 CalcFields(Amount);
//                 CalcFields("Amount Including VAT");
//                 case "Document Type" of
//                     "Document Type"::Invoice:
//                         begin
//                             decImporte := Amount;
//                             decImporteIVA := "Amount Including VAT";
//                         end;
//                     "Document Type"::"Credit Memo":
//                         begin
//                             Devolucion := true;
//                             decImporte := -Amount;
//                             decImporteIVA := -"Amount Including VAT";
//                         end;
//                 end;

//             end;

//             recVentaTPV.Init;
//             recVentaTPV."Cod. tienda" := Tienda;
//             recVentaTPV."Cod. TPV" := TPV;
//             recVentaTPV.Fecha := "Posting Date";
//             recVentaTPV."Id. cajero" := "ID Cajero";
//             recVentaTPV.Hora := FormatTime("Hora creacion");
//             recVentaTPV."No. Borrador" := "No.";
//             recVentaTPV.Importe := decImporte;
//             recVentaTPV."Importe IVA inc." := decImporteIVA;

//             if not blnRegistroEnLinea then
//                 recVentaTPV."No. Registrado" := "Posting No."
//             else
//                 recVentaTPV."No. Registrado" := "Last Posting No.";

//             recVentaTPV."Cod. cliente" := "Sell-to Customer No.";
//             recVentaTPV."Nombre cliente" := "Sell-to Customer Name";

//             if not Devolucion then
//                 recVentaTPV."Tipo Transaccion" := recVentaTPV."Tipo Transaccion"::Venta
//             else
//                 recVentaTPV."Tipo Transaccion" := recVentaTPV."Tipo Transaccion"::Anulacion;

//             recVentaTPV.Insert(true);

//             recPagosTPV.Reset;
//             recPagosTPV.SetRange("No. Borrador", "No.");
//             if recPagosTPV.FindSet then
//                 repeat
//                     if not Devolucion then
//                         InsertarTransaccionCaja(recVentaTPV, recPagosTPV, '')
//                     else begin
//                         recPagosTPV."Importe (DL)" := -recPagosTPV."Importe (DL)";
//                         recPagosTPV.Importe := -recPagosTPV.Importe;
//                         recPagosTPV.Modify(false);
//                         InsertarTransaccionCaja(recVentaTPV, recPagosTPV, recPrmCabVta."Posting No.");
//                     end;
//                 until recPagosTPV.Next = 0;

//         end;
//     end;


//     procedure GuardarAnulacionTPV(recPrmCabVta: Record "Sales Header"; blnRegistroEnLinea: Boolean)
//     var
//         recCabAbo: Record "Sales Cr.Memo Header";
//         recPagosTPV: Record "Pagos TPV";
//         Text001: Label 'Liq. factura TPV Doc. %1';
//         recVentaTPV: Record "Transacciones TPV";
//         decImporte: Decimal;
//         decImporteIVA: Decimal;
//     begin

//         with recPrmCabVta do begin

//             if blnRegistroEnLinea then begin
//                 recCabAbo.Get("Last Posting No.");
//                 recCabAbo.CalcFields(Amount);
//                 recCabAbo.CalcFields("Amount Including VAT");
//                 decImporte := recCabAbo.Amount;
//                 decImporteIVA := recCabAbo."Amount Including VAT";
//             end
//             else begin
//                 CalcFields(Amount);
//                 CalcFields("Amount Including VAT");
//                 decImporte := Amount;
//                 decImporteIVA := "Amount Including VAT";
//             end;

//             recVentaTPV.Init;
//             recVentaTPV."Cod. tienda" := Tienda;
//             recVentaTPV."Cod. TPV" := TPV;
//             recVentaTPV.Fecha := WorkDate;
//             recVentaTPV."Id. cajero" := "ID Cajero";
//             recVentaTPV.Hora := FormatTime(Time);
//             recVentaTPV."Tipo Transaccion" := recVentaTPV."Tipo Transaccion"::Anulacion;
//             recVentaTPV."No. Borrador" := "No.";

//             if not blnRegistroEnLinea then
//                 recVentaTPV."No. Registrado" := "Posting No."
//             else
//                 recVentaTPV."No. Registrado" := "Last Posting No.";

//             recVentaTPV."Cod. cliente" := "Sell-to Customer No.";
//             recVentaTPV."Nombre cliente" := "Sell-to Customer Name";

//             recVentaTPV.Importe := -decImporte;
//             recVentaTPV."Importe IVA inc." := -decImporteIVA;
//             recVentaTPV.Insert(true);

//             recPagosTPV.Reset;
//             recPagosTPV.SetRange("No. Borrador", "No.");
//             if recPagosTPV.FindSet then
//                 repeat
//                     if not blnRegistroEnLinea then
//                         InsertarTransaccionCaja(recVentaTPV, recPagosTPV, recPrmCabVta."Posting No.")
//                     else
//                         InsertarTransaccionCaja(recVentaTPV, recPagosTPV, recPrmCabVta."Last Posting No.");
//                 until recPagosTPV.Next = 0;

//         end;
//     end;


//     procedure InsertarTransaccionCaja(recPrmVentaTPV: Record "Transacciones TPV"; recPrmPago: Record "Pagos TPV"; PrmNumReg: Code[20])
//     var
//         recTrans: Record "Transacciones Caja TPV";
//         cduControlTPV: Codeunit "Funciones DsPOS - Bolivia";
//     begin

//         with recPrmVentaTPV do begin

//             recTrans.Reset;
//             recTrans."Cod. tienda" := "Cod. tienda";
//             recTrans."Cod. TPV" := "Cod. TPV";
//             recTrans.Fecha := Fecha;

//             case "Tipo Transaccion" of
//                 "Tipo Transaccion"::Venta:
//                     begin
//                         recTrans."Tipo transaccion" := recTrans."Tipo transaccion"::"Cobro TPV";
//                         recTrans.Importe := recPrmPago.Importe;
//                         recTrans."Importe (DL)" := recPrmPago."Importe (DL)";
//                         recTrans."No. Registrado" := recPrmPago."No. Factura";
//                     end;

//                 "Tipo Transaccion"::Anulacion:
//                     begin
//                         recTrans."Tipo transaccion" := recTrans."Tipo transaccion"::Anulacion;
//                         recTrans.Importe := recPrmPago.Importe;
//                         recTrans."Importe (DL)" := recPrmPago."Importe (DL)";
//                         if PrmNumReg <> '' then
//                             recTrans."No. Registrado" := PrmNumReg
//                         else
//                             recTrans."No. Registrado" := recPrmPago."No. Nota Credito";
//                     end;
//             end;

//             recTrans."Id. cajero" := "Id. cajero";
//             recTrans.Hora := Hora;
//             recTrans."Forma de pago" := recPrmPago."Forma pago TPV";
//             recTrans."Cod. divisa" := recPrmPago."Cod. divisa";
//             recTrans."Factor divisa" := recPrmPago."Factor divisa";
//             recTrans.Cambio := recPrmPago.Cambio;
//             recTrans."NCR regis. de compensacion" := recPrmPago."NCR regis. de compensacion"; //+#70132

//             recTrans.Insert(true);

//         end;
//     end;


//     procedure FormatTime(timEntrada: Time): Time
//     var
//         texHora: Text;
//         timSalida: Time;
//     begin

//         texHora := Format(timEntrada);
//         Evaluate(timSalida, texHora);
//         exit(timSalida);
//     end;


//     procedure RegistroEnLinea(codPrmTienda: Code[20]): Boolean
//     var
//         recTienda: Record Tiendas;
//     begin
//         recTienda.Get(codPrmTienda);
//         exit(recTienda."Registro En Linea");
//     end;


//     procedure TraspasarVtaADevolucion(codPrmTienda: Code[20]; codPrmDoc: Code[20]; codPrmDev: Code[20])
//     var
//         recLinFac: Record "Sales Invoice Line";
//         recLinPed: Record "Sales Line";
//         recLinDev: Record "Sales Line";
//     begin

//         if RegistroEnLinea(codPrmTienda) then begin
//             recLinFac.Reset;
//             recLinFac.SetRange("Document No.", codPrmDoc);
//             if recLinFac.FindSet then
//                 repeat
//                     recLinDev.Init;
//                     recLinDev."Document Type" := recLinDev."Document Type"::"Credit Memo";
//                     recLinDev."Document No." := codPrmDev;
//                     recLinDev."Line No." := recLinFac."Line No.";
//                     recLinDev.Validate(Type, recLinFac.Type);
//                     recLinDev.Validate("No.", recLinFac."No.");
//                     recLinDev.Validate("Unit of Measure Code", recLinFac."Unit of Measure Code");
//                     recLinDev.Validate(Quantity, recLinFac.Quantity);
//                     recLinDev.Validate("Location Code", recLinFac."Location Code");
//                     recLinDev.Insert(true);
//                 until recLinFac.Next = 0;
//         end
//         else begin
//             recLinPed.Reset;
//             recLinPed.SetRange("Document Type", recLinPed."Document Type"::Invoice);
//             recLinPed.SetRange("Document No.", codPrmDoc);
//             if recLinPed.FindSet then
//                 repeat
//                     recLinDev.Init;
//                     recLinDev."Document Type" := recLinDev."Document Type"::"Credit Memo";
//                     recLinDev."Document No." := codPrmDev;
//                     recLinDev."Line No." := recLinPed."Line No.";
//                     recLinDev.Validate(Type, recLinPed.Type);
//                     recLinDev.Validate("No.", recLinPed."No.");
//                     recLinDev.Validate("Unit of Measure Code", recLinPed."Unit of Measure Code");
//                     recLinDev.Validate(Quantity, recLinPed.Quantity);
//                     recLinDev.Validate("Location Code", recLinPed."Location Code");
//                     recLinDev.Insert(true);
//                 until recLinFac.Next = 0;
//         end;
//     end;


//     procedure ActualizarDivisas(pTienda: Code[20]; pTPV: Code[20]): Text
//     var
//         Evento: DotNet ;
//         rConf: Record "Configuracion TPV";
//         rBotones: Record Botones;
//         rFPago: Record "Formas de Pago";
//         rDivPos: Record "Divisas DsPOS";
//         rTC: Record "Currency Exchange Rate";
//         rDiv: Record Currency;
//         text001: Label 'TIPO CAMBIO NO DEFINIDO';
//         Error001: Label 'No se han definido formas de pago para el menú %1';
//     begin

//         rConf.Reset;
//         rConf.Get(pTienda, pTPV);

//         rDivPos.Reset;
//         rDivPos.SetRange(Tienda, pTienda);
//         rDivPos.SetRange(TPV, pTPV);
//         if rDivPos.FindSet then
//             rDivPos.DeleteAll(false);

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := 14;

//         rBotones.Reset;
//         rBotones.SetRange("ID Menu", rConf."Menu de Formas de Pago");
//         rBotones.SetFilter(Pago, '<>%1', '');
//         if rBotones.FindSet then begin
//             repeat
//                 rFPago.Reset;
//                 rFPago.Get(rBotones.Pago);
//                 if rFPago."Cod. divisa" <> '' then begin
//                     rTC.Reset;
//                     rTC.SetRange("Currency Code", rFPago."Cod. divisa");
//                     rTC.SetRange("Starting Date", 0D, WorkDate);
//                     if rTC.FindLast then begin
//                         with rDivPos do begin
//                             Tienda := pTienda;
//                             TPV := pTPV;
//                             Divisa := rFPago."Cod. divisa";
//                             rDiv.Get(rFPago."Cod. divisa");
//                             Descripcion := rDiv.Description;
//                             "Tipo Cambio" := rTC."Relational Exch. Rate Amount";
//                             "Fecha Valor" := rTC."Starting Date";
//                             Insert(false);
//                         end;
//                     end
//                     else begin
//                         with rDivPos do begin
//                             Tienda := pTienda;
//                             TPV := pTPV;
//                             Divisa := rFPago."Cod. divisa";
//                             Descripcion := text001;
//                             Insert(false);
//                         end;
//                     end;
//                 end;
//             until rBotones.Next = 0;
//             Evento.AccionRespuesta := 'OK';
//         end
//         else begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(Error001, rConf."Menu de Formas de Pago");
//         end;

//         exit(Evento.aXml());
//     end;


//     procedure RelacionaDevolucion(var pSalesHeader: Record "Sales Header")
//     var
//         rCabHistFac: Record "Sales Invoice Header";
//         rLinHistFac: Record "Sales Invoice Line";
//         rLinFac: Record "Sales Line";
//         rLin: Record "Sales Line";
//         OnLine: Boolean;
//         rCab: Record "Sales Header";
//         wDoc: Code[20];
//         TodoDevuelto: Boolean;
//         TextL001: Label 'Se está intentando devolver una cantidad %1, superior al valor inicial %2';
//     begin

//         OnLine := RegistroEnLinea(pSalesHeader.Tienda);

//         with rLin do begin
//             SetCurrentKey(Devuelto, "Devuelve a Documento");
//             SetRange("Document No.", pSalesHeader."No.");
//             SetRange("Document Type", pSalesHeader."Document Type");
//             SetFilter("Devuelve a Documento", '<>%1', '');
//             if FindSet then begin
//                 wDoc := rLin."Devuelve a Documento";
//                 pSalesHeader."Anula a Documento" := wDoc;
//                 repeat
//                     if OnLine then begin
//                         rLinHistFac.Reset;
//                         rLinHistFac.Get("Devuelve a Documento", "Devuelve a Linea Documento");
//                         rLinHistFac."Devuelto en Documento" := "Devuelve a Documento";
//                         rLinHistFac."Devuelto en Linea Documento" := "Devuelve a Linea Documento";

//                         //+#355717
//                         //rLinHistFac.Devuelto := TRUE;

//                         //+#381937
//                         //... Corrección. El valor correcto debe estar en el campo calculado.
//                         rLinHistFac.CalcFields("Cantidad dev. TPV (calc)");
//                         if rLinHistFac."Cantidad devuelta TPV" <> rLinHistFac."Cantidad dev. TPV (calc)" then
//                             rLinHistFac."Cantidad devuelta TPV" := rLinHistFac."Cantidad dev. TPV (calc)";
//                         //-#381937

//                         rLinHistFac."Cantidad devuelta TPV" := rLinHistFac."Cantidad devuelta TPV" + rLin.Quantity;
//                         if rLinHistFac."Cantidad devuelta TPV" > rLinHistFac.Quantity then
//                             Error(TextL001, rLinHistFac."Cantidad devuelta TPV", rLinHistFac.Quantity);
//                         if rLinHistFac."Cantidad devuelta TPV" >= rLinHistFac.Quantity then
//                             rLinHistFac.Devuelto := true;
//                         //-#355717

//                         rLinHistFac.Modify(false);
//                     end
//                     else begin
//                         rCab.Reset;
//                         rCab.SetCurrentKey("Posting No.");
//                         rCab.SetRange("Posting No.", rLin."Devuelve a Documento");
//                         rCab.FindSet;
//                         rLinFac.Reset;
//                         rLinFac.Get(rLinFac."Document Type"::Invoice, rCab."No.", "Devuelve a Linea Documento");
//                         rLinFac."Devuelto en Documento" := pSalesHeader."Posting No.";
//                         rLinFac."Devuelto en Linea Documento" := "Devuelve a Linea Documento";

//                         //+#355717
//                         //rLinFac.Devuelto := TRUE;

//                         //+#381937
//                         //... Corrección. El valor correcto debe estar en el campo calculado.
//                         rLinFac.CalcFields("Cantidad dev. TPV (calc)");
//                         if rLinFac."Cantidad devuelta TPV" <> rLinFac."Cantidad dev. TPV (calc)" then
//                             rLinFac."Cantidad devuelta TPV" := rLinFac."Cantidad dev. TPV (calc)";
//                         //-#381937

//                         rLinFac."Cantidad devuelta TPV" := rLinFac."Cantidad devuelta TPV" + rLin.Quantity;
//                         if rLinFac."Cantidad devuelta TPV" > rLinFac.Quantity then
//                             Error(TextL001, rLinFac."Cantidad devuelta TPV", rLinFac.Quantity);

//                         if rLinFac."Cantidad devuelta TPV" >= rLinFac.Quantity then
//                             rLinFac.Devuelto := true;
//                         //-#355717

//                         rLinFac.Modify(false);
//                     end;
//                 until rLin.Next = 0;

//                 TodoDevuelto := true;
//                 if OnLine then begin
//                     rLinHistFac.Reset;
//                     rLinHistFac.SetRange("Document No.", wDoc);
//                     if rLinHistFac.FindSet then
//                         repeat
//                             TodoDevuelto := rLinHistFac.Devuelto
//                         until (rLinHistFac.Next = 0) or not (TodoDevuelto);
//                     if TodoDevuelto then begin
//                         rCabHistFac.Get(wDoc);
//                         rCabHistFac."Anulado TPV" := true;
//                         //      rCabHistFac."Anulado por Documento" := pSalesHeader."Posting No.";
//                         rCabHistFac.Modify(false);
//                     end;
//                 end
//                 else begin
//                     rLinFac.Reset;
//                     rLinFac.SetRange("Document Type", rLinFac."Document Type"::Invoice);
//                     rLinFac.SetRange("Document No.", rCab."No.");
//                     if rLinFac.FindSet then
//                         repeat
//                             TodoDevuelto := rLinFac.Devuelto
//                         until (rLinFac.Next = 0) or not (TodoDevuelto);
//                     if TodoDevuelto then begin
//                         rCab."Anulado TPV" := true;
//                         //      rCab."Anulado por Documento" := pSalesHeader."Posting No.";
//                         rCab.Modify(false);
//                     end;
//                 end;
//             end;
//         end;
//     end;


//     procedure ComprobarCambioCliente(var pSalesH: Record "Sales Header"; NuevoClie: Code[20])
//     var
//         Cust: Record Customer;
//         UserSetupMngt: Codeunit "User Management";
//         GLSetup: Record "General Ledger Setup";
//         SalesLine: Record "Sales Line";
//     begin

//         if ((NuevoClie <> pSalesH."Sell-to Customer No.") and
//           (NuevoClie <> '')) then
//             if Cust.Get(NuevoClie) then
//                 with pSalesH do begin
//                     pSalesH."Sell-to Customer No." := NuevoClie;
//                     "Sell-to Customer Template Code" := '';
//                     "Sell-to Customer Name" := CopyStr(Cust.Name, 1, MaxStrLen("Sell-to Customer Name"));
//                     "Sell-to Customer Name 2" := CopyStr(Cust."Name 2", 1, MaxStrLen("Sell-to Customer Name 2"));
//                     "Sell-to Address" := CopyStr(Cust.Address, 1, MaxStrLen("Sell-to Address"));
//                     "Sell-to Address 2" := CopyStr(Cust."Address 2", 1, MaxStrLen("Sell-to Address 2"));
//                     "Sell-to City" := Cust.City;
//                     "Sell-to Post Code" := Cust."Post Code";
//                     "Sell-to County" := Cust.County;
//                     "Sell-to Country/Region Code" := Cust."Country/Region Code";
//                     "Sell-to Contact" := Cust.Contact;
//                     "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
//                     "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
//                     "Tax Area Code" := Cust."Tax Area Code";
//                     "Tax Liable" := Cust."Tax Liable";
//                     "Tax Exemption No." := Cust."Tax Exemption No.";
//                     "VAT Registration No." := Cust."VAT Registration No.";
//                     "VAT Country/Region Code" := Cust."Country/Region Code";
//                     "Shipping Advice" := Cust."Shipping Advice";
//                     "Salesperson Code" := Cust."Salesperson Code";
//                     "Responsibility Center" := '';
//                     "Ship-to Code" := '';

//                     VentaaCliente(pSalesH, Cust."No.");

//                     Cust.Get("Bill-to Customer No.");
//                     if (Cust."Bill-to Customer No." <> '') and
//                        (Cust."Bill-to Customer No." <> Cust."No.") then
//                         VentaaCliente(pSalesH, Cust."No.");

//                     SalesLine.SetRange("Document Type", "Document Type"::Invoice);
//                     SalesLine.SetRange("Document No.", "No.");
//                     if SalesLine.FindSet then begin
//                         SalesLine.ModifyAll("Sell-to Customer No.", "Sell-to Customer No.", false);
//                         SalesLine.ModifyAll("Bill-to Customer No.", "Bill-to Customer No.", false);
//                     end;
//                 end;


//         // Colegio
//     end;


//     procedure VentaaCliente(var pSalesH: Record "Sales Header"; Cliente: Code[20])
//     var
//         GLsetup: Record "General Ledger Setup";
//         Cust: Record Customer;
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//     begin

//         Cust.Get(pSalesH."Sell-to Customer No.");
//         with pSalesH do begin
//             "Bill-to Customer No." := Cust."Bill-to Customer No.";
//             "Bill-to Customer Template Code" := '';
//             "Bill-to Name" := CopyStr(Cust.Name, 1, MaxStrLen("Bill-to Name"));
//             "Bill-to Name 2" := CopyStr(Cust."Name 2", 1, MaxStrLen("Bill-to Name 2"));
//             "Bill-to Address" := CopyStr(Cust.Address, 1, MaxStrLen("Bill-to Address"));
//             "Bill-to Address 2" := CopyStr(Cust."Address 2", 1, MaxStrLen("Bill-to Address 2"));
//             "Bill-to City" := Cust.City;
//             "Bill-to Post Code" := Cust."Post Code";
//             "Bill-to County" := Cust.County;
//             "Bill-to Country/Region Code" := Cust."Country/Region Code";
//             "Payment Method Code" := Cust."Payment Method Code";

//             GLsetup.Get;
//             if GLsetup."Bill-to/Sell-to VAT Calc." = GLsetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." then begin
//                 "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
//                 "VAT Country/Region Code" := Cust."Country/Region Code";
//                 "VAT Registration No." := Cust."VAT Registration No.";
//                 "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
//             end;

//             "Customer Posting Group" := Cust."Customer Posting Group";
//             "Currency Code" := Cust."Currency Code";
//             "Customer Price Group" := Cust."Customer Price Group";
//             "Prices Including VAT" := Cust."Prices Including VAT";
//             "Allow Line Disc." := Cust."Allow Line Disc.";
//             "Invoice Disc. Code" := Cust."Invoice Disc. Code";
//             "Customer Disc. Group" := Cust."Customer Disc. Group";
//             "Language Code" := Cust."Language Code";
//             "Salesperson Code" := Cust."Salesperson Code";
//             "Combine Shipments" := Cust."Combine Shipments";
//             Reserve := Cust.Reserve;


//             if cfComunes.RegistroEnLinea(pSalesH.Tienda) then begin

//                 pSalesH.SetHideValidationDialog(true);

//                 Validate("Payment Terms Code");
//                 Validate("Prepmt. Payment Terms Code");
//                 Validate("Payment Method Code");
//                 Validate("Currency Code");
//                 Validate("Prepayment %");

//                 CreateDim(
//                   DATABASE::Customer, "Bill-to Customer No.",
//                   DATABASE::"Salesperson/Purchaser", "Salesperson Code",
//                   DATABASE::Campaign, "Campaign No.",
//                   DATABASE::"Responsibility Center", "Responsibility Center",
//                   DATABASE::"Customer Template", "Bill-to Customer Template Code");

//             end;

//         end;
//     end;


//     procedure RelacionaAnulacion(var pSalesH: Record "Sales Header"; CodTienda: Code[20])
//     begin

//         case Pais of
//             1:
//                 cDominicana.RelacionaAnulacion(pSalesH, CodTienda);
//             2:
//                 cBolivia.RelacionaAnulacion(pSalesH, CodTienda); // Bolivia;
//             3:
//                 cParaguay.RelacionaAnulacion(pSalesH, CodTienda); // Paraguay;
//             4:
//                 cEcuador.RelacionaAnulacion(pSalesH, CodTienda);  // Ecuador;
//             5:
//                 cGuatemala.RelacionaAnulacion(pSalesH, CodTienda);  // Guatemala;
//             6:
//                 cSalvador.RelacionaAnulacion(pSalesH, CodTienda);  // Salvador;
//             7:
//                 cHonduras.RelacionaAnulacion(pSalesH, CodTienda);  // Honduras;
//             9:
//                 cCostaRica.RelacionaAnulacion(pSalesH, CodTienda);  // Costa Rica /#148807
//         end;

//         if pSalesH.Modify then;
//     end;


//     procedure DeconfiguraAnulaciones(var rec: Record Tiendas)
//     var
//         rTPV: Record "Configuracion TPV";
//         Text001: Label 'Se va a proceder a desconfigurar de la tienda y todas sus POS asignadas la configuración de notas de crédito.\ Continuar?';
//         rTienda: Record Tiendas;
//     begin

//         if not Confirm(Text001, false) then
//             exit;

//         with rTPV do begin
//             Reset;
//             SetRange(Tienda, rec."Cod. Tienda");
//             if FindFirst then
//                 repeat
//                     Clear("NCF Credito fiscal NCR");

//                     Clear("NCF Credito fiscal NCR 2"); //+325138

//                     //+#116527
//                     Clear("NCF Credito fiscal NCR resg.");
//                     //-#116527

//                     Clear("No. serie notas credito");
//                     Clear("No. serie notas credito reg.");
//                     Modify(false);
//                 until rTPV.Next = 0;
//         end;

//         with rec do begin
//             "ID Reporte nota credito" := 0;
//             "Cantidad copias nota credito" := 0;
//             Modify(false);
//         end;
//     end;


//     procedure PermiteAnulaciones(pTienda: Code[20]): Boolean
//     var
//         rTienda: Record Tiendas;
//     begin

//         rTienda.Get(pTienda);
//         exit(rTienda."Permite Anulaciones en POS");
//     end;


//     procedure EsCentral(): Boolean
//     var
//         recTPV: Record "Configuracion TPV";
//         cduPOS: Codeunit "Funciones Addin DSPos";
//     begin

//         recTPV.Reset;
//         recTPV.SetCurrentKey("Usuario windows");
//         recTPV.SetRange("Usuario windows", cduPOS.TraerUsuarioWindows);
//         exit(not (recTPV.FindFirst));
//     end;


//     procedure ValidaIDCliente(ID: Code[20]; TipoID: Integer): Text
//     var
//         Mensaje: Text;
//         Evento: DotNet ;
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := 18;

//         case Pais of
//             4:
//                 Mensaje := cEcuador.ValidaIDCliente(ID, TipoID);
//         end;

//         if Mensaje <> '' then begin
//             Evento.TextoRespuesta := Mensaje;
//             Evento.AccionRespuesta := 'ERROR';
//         end
//         else
//             Evento.AccionRespuesta := 'OK';

//         exit(Evento.aXml());
//     end;


//     procedure Devolver_Datos_Localizados(pEvento: DotNet ): Text
//     begin

//         case Pais of
//             1:
//                 exit(cDominicana.Devolver_Datos_Localizados(pEvento.IntDato1, pEvento.TextoDato, pEvento.TextoDato2, pEvento.IntDato2));
//             5:
//                 exit(cGuatemala.DevolverSiguienteNum(pEvento.TextoDato, pEvento.TextoDato2, pEvento.TextoDato6, pEvento.IntDato2));  //+#232158
//             6:
//                 exit(cSalvador.DevolverSiguienteNum(pEvento.IntDato1, pEvento.TextoDato, pEvento.TextoDato2, pEvento.IntDato2)); //+#325138
//             else
//                 exit(DevolverSiguienteNum(pEvento.TextoDato, pEvento.TextoDato2, pEvento.TextoDato6, pEvento.IntDato2));
//         end;
//     end;


//     procedure Devolver_NCF(prTrans: Record "Transacciones TPV"): Code[40]
//     var
//         rSalesInvH: Record "Sales Invoice Header";
//         rSalesCrH: Record "Sales Cr.Memo Header";
//         rSalesH: Record "Sales Header";
//     begin

//         rSalesH.Reset;
//         rSalesH.SetRange("No.", prTrans."No. Borrador");
//         if rSalesH.FindFirst then
//             exit(rSalesH."No. Fiscal TPV")
//         else
//             case prTrans."Tipo Transaccion" of
//                 prTrans."Tipo Transaccion"::Venta:
//                     begin
//                         if rSalesInvH.Get(prTrans."No. Registrado") then
//                             exit(rSalesInvH."No. Fiscal TPV")
//                     end;
//                 prTrans."Tipo Transaccion"::Anulacion,
//                 prTrans."Tipo Transaccion"::Abono:
//                     begin
//                         if rSalesCrH.Get(prTrans."No. Registrado") then
//                             exit(rSalesCrH."No. Fiscal TPV");
//                     end;
//             end;
//     end;


//     procedure Devolver_NCF_TransCaja(prTrans: Record "Transacciones Caja TPV"): Code[40]
//     var
//         rSalesInvH: Record "Sales Invoice Header";
//         rSalesCrH: Record "Sales Cr.Memo Header";
//         rSalesH: Record "Sales Header";
//     begin

//         rSalesH.Reset;
//         rSalesH.SetCurrentKey("Posting No.");
//         rSalesH.SetRange("Posting No.", prTrans."No. Registrado");
//         if rSalesH.FindFirst then
//             exit(rSalesH."No. Comprobante Fiscal")
//         else
//             case prTrans."Tipo transaccion" of
//                 prTrans."Tipo transaccion"::"Cobro TPV":
//                     begin
//                         if rSalesInvH.Get(prTrans."No. Registrado") then
//                             exit(rSalesInvH."No. Comprobante Fiscal")
//                     end;
//                 prTrans."Tipo transaccion"::Anulacion:
//                     begin
//                         if rSalesCrH.Get(prTrans."No. Registrado") then
//                             exit(rSalesCrH."No. Comprobante Fiscal");
//                     end;
//             end;
//     end;


//     procedure Desaparcar_Pedido(p_NumVenta: Code[20]): Text
//     var
//         rCabFac: Record "Sales Header";
//         Evento: DotNet ;
//         Error001: Label 'El pedido aparcado nº %1 se ha recuperado correctamente.';
//         Error002: Label 'El pedido aparcado nº %1 no se ha encontrado en la tabla Sales Header';
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         rCabFac.Reset;

//         if rCabFac.Get(rCabFac."Document Type"::Invoice, p_NumVenta) then begin
//             rCabFac.Aparcado := false;
//             rCabFac.Modify(false);
//             Evento.AccionRespuesta := 'Actualizar_Todo';
//             Evento.TextoRespuesta := StrSubstNo(Error001, p_NumVenta);
//             // Actualizar Totales
//             Actualizar_Totales(p_NumVenta, Evento, false, false);
//         end
//         else begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(Error002, p_NumVenta);
//         end;

//         exit(Evento.aXml());
//     end;


//     procedure AnulaA_AnuladoPor(prTrans: Record "Transacciones TPV"): Code[40]
//     var
//         prTrans2: Record "Transacciones TPV";
//         rSalesInvH: Record "Sales Invoice Header";
//         rSalesH: Record "Sales Header";
//         rSalesCrH: Record "Sales Cr.Memo Header";
//         wDoc: Text;
//         LF: Char;
//         CR: Char;
//         vueltas: Integer;
//     begin

//         LF := 10;
//         CR := 13;
//         wDoc := '';

//         rSalesH.Reset;
//         rSalesH.SetRange("No.", prTrans."No. Borrador");
//         if rSalesH.FindFirst then begin

//             case prTrans."Tipo Transaccion" of
//                 prTrans."Tipo Transaccion"::Venta:
//                     begin

//                         rSalesH.Reset;
//                         rSalesH.SetCurrentKey("Document Type", "Posting Date", "Anula a Documento");
//                         rSalesH.SetRange("Document Type", rSalesH."Document Type"::"Credit Memo");
//                         rSalesH.SetRange("Anula a Documento", prTrans."No. Registrado");

//                         if rSalesH.FindSet then begin
//                             repeat
//                                 wDoc += rSalesH."No. Fiscal TPV";
//                                 vueltas += 1;
//                                 if vueltas < rSalesH.Count then
//                                     wDoc += Format(CR, 0, '<CHAR>') + Format(LF, 0, '<CHAR>');
//                             until rSalesH.Next = 0;
//                             exit(wDoc);
//                         end;

//                     end;

//                 prTrans."Tipo Transaccion"::Anulacion,
//                 prTrans."Tipo Transaccion"::Abono:
//                     begin
//                         prTrans2.Reset;
//                         prTrans2.SetCurrentKey("No. Registrado");
//                         prTrans2.SetRange("No. Registrado", rSalesH."Anula a Documento");
//                         if prTrans2.FindFirst then
//                             exit(Devolver_NCF(prTrans2));
//                     end;
//             end;

//         end
//         else begin

//             case prTrans."Tipo Transaccion" of
//                 prTrans."Tipo Transaccion"::Venta:
//                     begin

//                         rSalesCrH.Reset;
//                         rSalesCrH.SetCurrentKey("Posting Date", "Anula a Documento");
//                         rSalesCrH.SetRange("Anula a Documento", prTrans."No. Registrado");

//                         if rSalesCrH.FindSet then begin
//                             repeat
//                                 wDoc += rSalesCrH."No. Fiscal TPV";
//                                 vueltas += 1;
//                                 if vueltas < rSalesCrH.Count then
//                                     wDoc += Format(CR, 0, '<CHAR>') + Format(LF, 0, '<CHAR>');
//                             until rSalesCrH.Next = 0;
//                             exit(wDoc);
//                         end;
//                     end;

//                 prTrans."Tipo Transaccion"::Anulacion,
//                 prTrans."Tipo Transaccion"::Abono:
//                     begin

//                         rSalesCrH.Reset;
//                         rSalesCrH.Get(prTrans."No. Registrado");

//                         prTrans2.Reset;
//                         prTrans2.SetCurrentKey("No. Registrado");
//                         prTrans2.SetRange("No. Registrado", rSalesCrH."Anula a Documento");
//                         if prTrans2.FindFirst then
//                             exit(Devolver_NCF(prTrans2));
//                     end;

//             end;

//         end;
//     end;


//     procedure DevolverSiguienteNum(pTienda: Code[20]; pTPV: Code[20]; pSerie: Text; pAnul: Integer): Text
//     var
//         Evento: DotNet ;
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         text001: Label 'NCF Actualizado CORRECTAMENTE';
//         rConfTPV: Record "Configuracion TPV";
//         Serie: Code[20];
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Commit;
//         Evento.TipoEvento := 20;

//         if pSerie = '' then begin
//             rConfTPV.Get(pTienda, pTPV);
//             if pAnul > 0 then
//                 //+#116527
//                 //Serie := rConfTPV."NCF Credito fiscal NCR"
//                 Serie := ObtenerSerieFiscal(rConfTPV, 1)
//             //-#116527

//             else
//                 //+#116527
//                 //Serie := rConfTPV."NCF Credito fiscal";
//                 Serie := ObtenerSerieFiscal(rConfTPV, 0);
//             //-#116527
//         end
//         else
//             Serie := pSerie;

//         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(Serie, WorkDate);
//         Evento.TextoDato2 := Serie;

//         Evento.TextoRespuesta := text001;
//         Evento.AccionRespuesta := 'OK';
//         exit(Evento.aXml())
//     end;


//     procedure Linea_LocalizadaOFF(var prOrigen: Record "Sales Line"; var prDestino: Record "Sales Line")
//     begin

//         case Pais of
//             5:
//                 cGuatemala.Linea_LocalizadaOFF(prOrigen, prDestino);
//             6:
//                 cSalvador.Linea_LocalizadaOFF(prOrigen, prDestino);
//             7:
//                 cHonduras.Linea_LocalizadaOFF(prOrigen, prDestino);
//             9:
//                 cCostaRica.Linea_LocalizadaOFF(prOrigen, prDestino);  //#148807
//         end;
//     end;


//     procedure Actualiza_Venta_Contacto(par_Doc: Code[20]; par_Contacto: Code[20]): Text
//     var
//         rSalesH: Record "Sales Header";
//         rSalesLin: Record "Sales Line";
//         rContact: Record Contact;
//         Evento: DotNet ;
//         Error001: Label 'No existe el Colegio %1';
//         Text001: Label 'Colegio Actualizado Correctamente';
//         rTienda: Record Tiendas;
//         Location: Code[10];
//         dto: Decimal;
//         rTPV: Record "Configuracion TPV";
//         lNumLog: Integer;
//         lrAuxTienda: Record Tiendas;
//         lrVentas: Record "Sales Header";
//         lTienda: Code[20];
//         lTPV: Code[20];
//     begin

//         //+144756
//         //... Obtenemos el valor más apropiado de la tienda y .... registramos el LOG.
//         lTienda := '';
//         lTPV := 'XXX';

//         lrVentas.Reset;
//         lrVentas.SetCurrentKey("No.", "Document Type");
//         lrVentas.SetRange("No.", par_Doc);
//         if lrVentas.FindFirst then begin
//             lTienda := lrVentas.Tienda;
//             lTPV := lrVentas.TPV;
//         end
//         else begin
//             if lTienda = '' then
//                 if lrAuxTienda.FindFirst then
//                     lTienda := lrAuxTienda."Cod. Tienda";
//         end;

//         lNumLog := IniciarLog(6, lTienda, lTPV);
//         //-144756

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Evento.TipoEvento := 23;

//         case Pais of
//             1, 2, 3, 4, 5, 7, 8, 9:
//                 begin
//                     Evento.AccionRespuesta := 'OK';
//                     exit(Evento.aXml());
//                 end;
//         end;

//         //+#144756
//         ModificarDatosLog(lNumLog, 2, lrVentas."Document Type", par_Doc, lrVentas."Posting No.", lrVentas."No. Fiscal TPV", lrVentas."No. Comprobante Fiscal", par_Contacto);
//         //-#144756

//         rSalesH.Reset;
//         if not rSalesH.Get(rSalesH."Document Type"::Invoice, par_Doc) then begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(Error001, par_Contacto);
//             exit(Evento.aXml());
//         end;

//         //+#144756
//         ModificarDatosLog(lNumLog, 3, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", par_Contacto);
//         //-#144756

//         rTienda.Get(rSalesH.Tienda);
//         rTPV.Get(rSalesH.Tienda, rSalesH.TPV);

//         //+#175576
//         //IF rTPV."Venta Movil" THEN BEGIN
//         if rTPV."Venta Movil" or (rTPV."Precio por contacto" = rTPV."Precio por contacto"::"En todos los casos") then begin
//             //-#1775576
//             //+#144756
//             ModificarDatosLog(lNumLog, 4, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", par_Contacto);
//             //-#144756

//             if par_Contacto <> '' then begin
//                 rContact.Reset;
//                 if not rContact.Get(par_Contacto) then begin
//                     Evento.AccionRespuesta := 'OK';
//                     exit(Evento.aXml());
//                 end
//                 else
//                     if rContact."Cod. Almacen" <> '' then
//                         Location := rContact."Cod. Almacen"
//                     else
//                         Location := rTienda."Cod. Almacen";
//             end
//             else
//                 Location := rTienda."Cod. Almacen";

//             //+#144756
//             ModificarDatosLog(lNumLog, 5, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", par_Contacto + ': ' + Location);
//             //-#144756

//             rSalesH.SetHideValidationDialog(true);

//             //+#175576
//             //rSalesH.VALIDATE("Location Code"       , Location);
//             if rTPV."Venta Movil" then
//                 rSalesH.Validate("Location Code", Location);
//             //-#175576

//             //#+325138
//             //... Tratamiento especial para El Salvador.
//             //rSalesH.VALIDATE("Location Code"       , Location);
//             if Pais <> 6 then
//                 rSalesH.Validate("Location Code", Location);
//             //#-325138

//             rSalesH.Validate("Sell-to Contact No.", par_Contacto);
//             rSalesH.Validate("Bill-to Contact No.", par_Contacto);
//             rSalesH.Validate("Cod. Colegio", par_Contacto);
//             rSalesH.Modify(false);

//             rSalesLin.Reset;
//             rSalesLin.SetRange("Document Type", rSalesH."Document Type");
//             rSalesLin.SetRange("Document No.", rSalesH."No.");
//             if rSalesLin.FindFirst then begin
//                 rSalesLin.SetHideValidationDialog(true);
//                 repeat
//                     //+#175576
//                     //rSalesLinVALIDATE("Location Code"       , Location);
//                     if rTPV."Venta Movil" then
//                         rSalesLin.Validate("Location Code", Location);
//                     //-#175576

//                     //+#325138
//                     //... Tratamiento especial para El Salvador.
//                     //rSalesLin.VALIDATE("Location Code",Location);
//                     if Pais <> 6 then
//                         rSalesLin.Validate("Location Code", Location);
//                     //-#325138

//                     rSalesLin.Validate("Cod. Colegio", rSalesH."Cod. Colegio"); //+#144756
//                     dto := rSalesLin."Line Discount %";
//                     rSalesLin.Validate(Quantity);
//                     rSalesLin.Validate("Line Discount %", dto);
//                     rSalesLin.Modify(false);
//                 until rSalesLin.Next = 0;
//             end;

//             Evento.AccionRespuesta := 'Actualizar_Todo';
//             if par_Contacto <> '' then
//                 Evento.TextoRespuesta := Text001;

//             Actualizar_Totales(rSalesH."No.", Evento, false, (rSalesH."Document Type" = rSalesH."Document Type"::"Credit Memo"));

//             //+#144756
//             ModificarDatosLog(lNumLog, 6, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", par_Contacto + ': ' + Location);
//             //-#144756

//             exit(Evento.aXml());

//         end
//         else begin
//             //+#144756
//             ModificarDatosLog(lNumLog, 7, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV", rSalesH."No. Comprobante Fiscal", par_Contacto + ': ' + Location);
//             //-#144756

//             Evento.AccionRespuesta := 'OK';
//             Actualizar_Totales(rSalesH."No.", Evento, false, (rSalesH."Document Type" = rSalesH."Document Type"::"Credit Memo"));
//             exit(Evento.aXml());
//         end;
//     end;


//     procedure ControlDeAcceso(pTienda: Code[20]; pBloquear: Boolean)
//     var
//         lrMySession: Record "Active Session";
//         lrTienda: Record Tiendas;
//         lNumVeces: Integer;
//         lContador: Integer;
//         lIDSesionActual: Integer;
//     begin
//         //#381937
//         //... Prescindimos de este control.
//         exit;

//         //+90735
//         lrMySession.Reset;
//         lrMySession.SetRange("User ID", UserId);
//         if not lrMySession.FindFirst then
//             exit;

//         if pBloquear then begin
//             lrTienda.Reset;
//             lrTienda.Get(pTienda);
//             //... Revisamos si alguién está teoricamente realizando una transacción potencialmente conflictiva.
//             //... En ese caso, esperamos un poco ... y volvemos a intentar hasta 5 veces, cada 2 segundos.
//             //... Conviene no penalizar demasiado la transacción actual, no sea que sea sólo una falsa alarma.
//             //... De todas formas, damos hasta 10 segundos para que finalice la transacción que presuntamente está operando.
//             lContador := 1;
//             lNumVeces := 7;
//             lIDSesionActual := lrTienda."ID Sesion";
//             while (lrTienda."ID Sesion" <> 0) and (lrTienda."ID Sesion" <> lrMySession."Session ID") and (lContador <= lNumVeces) do begin
//                 Sleep(2000);
//                 lrTienda.Get(pTienda);
//                 //... Revisamos si una 3era sesion ha cogido el control. En este caso, ampliamos el tiempo.
//                 if (lrTienda."ID Sesion" <> 0) and (lIDSesionActual <> lrTienda."ID Sesion") then begin
//                     lIDSesionActual := lrTienda."ID Sesion";
//                     lContador := 1;
//                 end
//                 else
//                     lContador := lContador + 1;
//             end;

//             //... Vamos a registrar que vamos a realizar la transacción, o notificamos que ya hemos acabado, según el valor del parámetro pBloquear
//             lrTienda.Reset;
//             lrTienda.LockTable;
//             lrTienda.Get(pTienda);
//             lrTienda."ID Sesion" := lrMySession."Session ID";
//             lrTienda.Modify;
//         end
//         else begin
//             //... Se supone que tenemos el bloqueo, pero si por lo que sea no fuera así y
//             //... otra transacción ha alterado el valor de "ID Sesion", no hacemos nada.
//             lrTienda.Reset;
//             lrTienda.LockTable;
//             lrTienda.Get(pTienda);
//             if lrTienda."ID Sesion" = lrMySession."Session ID" then begin
//                 lrTienda."ID Sesion" := 0;
//                 lrTienda.Modify;
//             end;
//         end;
//     end;


//     procedure IniciarLog(pProceso: Option Registrar,"Nueva Venta","Anular Factura","Eliminar Linea",Duplicacion,Serie,"Cambio Almacen",Cupon,"Crear Devolucion"; pTienda: Code[20]; pTPV: Code[20]): Integer
//     var
//         lrTienda: Record Tiendas;
//         lrLog: Record "Log procesos TPV";
//         lResult: Integer;
//     begin
//         //+88460
//         //... Iniciar Log.

//         lResult := 0;
//         if not lrTienda.Get(pTienda) then
//             exit(lResult);

//         lrLog.Reset;
//         //lrLog.LOCKTABLE;

//         lrLog.Init;
//         lrLog."ID Proceso" := pProceso;
//         lrLog."Punto de proceso" := 1;
//         lrLog.Tienda := pTienda;
//         lrLog.TPV := pTPV;
//         lrLog.Insert(true);

//         lResult := lrLog."No. Log";

//         exit(lResult);
//     end;


//     procedure ModificarDatosLog(pIDLog: Integer; pPunto: Integer; pTipoDocumento: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; pID36: Code[20]; pID112_114: Code[20]; pNumFiscalTPV: Code[50]; pNumComprobanteFiscal: Code[50]; pError: Text[1024])
//     var
//         lrTienda: Record Tiendas;
//         lrLog: Record "Log procesos TPV";
//         lResult: Integer;
//     begin
//         //+88460
//         //... Iniciar Log.

//         if pIDLog = 0 then
//             exit;

//         lrLog.Reset;
//         //lrLog.LOCKTABLE;
//         lrLog.Get(pIDLog);

//         lrLog."Punto de proceso" := pPunto;
//         lrLog."Tipo Documento" := pTipoDocumento;
//         lrLog."ID. Cab Venta" := pID36;
//         lrLog."ID. Historico" := pID112_114;
//         lrLog."No. Fiscal TPV" := pNumFiscalTPV;
//         lrLog."No. comprobante fiscal" := pNumComprobanteFiscal;
//         lrLog."Texto Error" := CopyStr(pError, 1, MaxStrLen(lrLog."Texto Error"));

//         //+#328529
//         if wCupon4Log <> '' then
//             lrLog.Cupon := wCupon4Log;
//         //-#328529

//         lrLog.Modify(true);
//     end;


//     procedure RegistrarError(pIdOperacion: Integer; pIdTienda: Code[20]; pIdTPV: Code[20]; pIdCabVenta: Code[20]; pTextoError: Text[1024])
//     var
//         lrAudi: Record "Log procesos TPV";
//         lrCV: Record "Sales Header";
//         lNumLog: Integer;
//         lOk: Boolean;
//     begin
//         //+#121213
//         lNumLog := IniciarLog(pIdOperacion, pIdTienda, pIdTPV);

//         if pIdCabVenta <> '' then begin  //+#148711

//             lOk := lrCV.Get(lrCV."Document Type"::Invoice, pIdCabVenta);
//             if not lOk then
//                 lOk := lrCV.Get(lrCV."Document Type"::"Credit Memo", pIdCabVenta);

//             if lOk then begin
//                 if lrCV."Venta TPV" then begin
//                     pTextoError := CopyStr(pTextoError, 1, MaxStrLen(lrAudi."Texto Error"));
//                     ModificarDatosLog(lNumLog, 100, lrCV."Document Type", lrCV."No.", lrCV."Posting No.", lrCV."No. Fiscal TPV", lrCV."No. Comprobante Fiscal", pTextoError);
//                 end;
//             end
//             //+#374964
//             //... No se estaban tratando los casos de error cuando el registro de la tienda es en linea.
//             else begin
//                 pTextoError := CopyStr(pTextoError, 1, MaxStrLen(lrAudi."Texto Error"));
//                 ModificarDatosLog(lNumLog, 100, 0, '', '', '', '', pTextoError);
//             end;
//             //-#374964

//         end
//         //+#148711
//         else begin
//             pTextoError := CopyStr(pTextoError, 1, MaxStrLen(lrAudi."Texto Error"));
//             ModificarDatosLog(lNumLog, 100, 0, '', '', '', '', pTextoError);
//         end;
//         //-#148711
//     end;


//     procedure FE_Por_Pais(lrCabVenta: Record "Sales Header"; pRegistroEnLinea: Boolean): Boolean
//     var
//         lResult: Boolean;
//         lcGuatemala: Codeunit "Funciones DsPOS - Guatemala";
//         lrCfgSant: Record "Config. Empresa";
//         lTipo: Integer;
//     begin
//         //+76946
//         //... Esta función, llama a la función de envio electronico de facturas.
//         //... En este momento sólo se habilita para Guatemala. Para hacerlo bien, deberá emplearse una puerta de enlace, para que esta codeunit no diera
//         //... errores de compilación.
//         //... La otra solución es copiar la codeunit de funciones de Guatemala en cada instalación.
//         //...

//         lResult := true;

//         case Pais of
//             5:
//                 begin
//                     //IF lrCfgSant.FINDFIRST THEN BEGIN  //+#336189
//                     //  IF lrCfgSant."Funcionalidad FE Activa" THEN BEGIN //+#336189
//                     Commit;
//                     lcGuatemala.Parametros(lrCabVenta, pRegistroEnLinea);
//                     if not lcGuatemala.Run then
//                         lResult := false;
//                 end;
//         //END; //+#336189
//         //END; //+#336189
//         end;

//         exit(lResult);
//     end;


//     procedure GrabarTextoAvisoFE(pTienda: Code[20]; pTPV: Code[20]; pMensaje: Text[1024])
//     var
//         lrTPV: Record "Configuracion TPV";
//     begin
//         //+#76946
//         lrTPV.Reset;
//         //lrTPV.LOCKTABLE;
//         lrTPV.Get(pTienda, pTPV);
//         lrTPV."Texto aviso FE" := CopyStr(pMensaje, 1, 250);
//         lrTPV.Modify;
//     end;


//     procedure TestFE(lrCabVenta: Record "Sales Header"): Boolean
//     var
//         lrNoSeriesLine: Record "No. Series Line";
//         lResult: Boolean;
//         lOk: Boolean;
//         lcGuatemala: Codeunit "Funciones DsPOS - Guatemala";
//     begin
//         //+#76946
//         lResult := false;
//         lOk := false;

//         //... Sólo se realizará la comprobación si el pais es guatemala, sino habrá que activarlo explicitamente.
//         if Pais = 5 then begin
//             //+#232158
//             //... Todas las ventas son electrónicas.
//             lResult := true;
//         end;

//         exit(lResult);
//     end;


//     procedure TestFE_Factura(lrSIH: Record "Sales Invoice Header"): Boolean
//     var
//         lrNoSeriesLine: Record "No. Series Line";
//         lResult: Boolean;
//         lrCfgSanti: Record "Config. Empresa";
//     begin
//         //+#76946
//         lResult := false;

//         //... Sólo se realizará la comprobación si el pais es guatemala, sino habrá que activarlo explicitamente.
//         if Pais = 5 then begin

//             //+#232158
//             //... Todas las ventas son electrónicas.
//             lResult := true;
//             //-#232158

//         end;

//         exit(lResult);
//     end;


//     procedure TestFE_NCR(lrSCMH: Record "Sales Cr.Memo Header"): Boolean
//     var
//         lrNoSeriesLine: Record "No. Series Line";
//         lResult: Boolean;
//         lrCfgSanti: Record "Config. Empresa";
//     begin
//         //+#76946
//         lResult := false;

//         //... Sólo se realizará la comprobación si el pais es guatemala, sino habrá que activarlo explicitamente.
//         if Pais = 5 then begin

//             //+#232158
//             //... Todas las ventas son electrónicas.
//             lResult := true;
//             //-#232158

//         end;

//         exit(lResult);
//     end;


//     procedure ObtenerSerieFiscal(lrConfigTPV: Record "Configuracion TPV"; pTipoDocumento: Option Factura,NCR): Code[20]
//     var
//         lrCfgEmpresa: Record "Config. Empresa";
//         lResult: Code[20];
//     begin
//         //+116527
//         case pTipoDocumento of
//             pTipoDocumento::Factura:
//                 lResult := lrConfigTPV."NCF Credito fiscal";
//             pTipoDocumento::NCR:
//                 lResult := lrConfigTPV."NCF Credito fiscal NCR";
//         end;

//         //+#232158
//         //... Se elimina el uso de series fiscales.
//         /*
//         //... Se contemplan excepciones localizadas para la obtención de la serie fiscal.
//         //... Al final se ha creado una redundancia, con lo cual el valor correcto ya está establecido.
//         CASE Pais OF
//           5: cGuatemala.ObtenerSerieFiscal(lrConfigTPV,pTipoDocumento,lResult);
//         END;
//         */
//         //-#232158


//         exit(lResult);

//     end;


//     procedure Post_Registrar(var rSalesH: Record "Sales Header"; pRegistroEnLinea: Boolean; recTPV: Record "Configuracion TPV")
//     var
//         lcParaguay: Codeunit "Funciones DsPOS - Paraguay";
//         lcDominicana: Codeunit "Funciones DsPOS - Dominicana";
//     begin
//         //+#120811
//         //... Una vez que se ha efectuado el registro del documento, interesará cambiar una serie de valores.
//         //... El caso concreto ha ocurrido en Paraguay, para el registro en Linea, donde hay que asignar las series NCF
//         case Pais of
//             1:
//                 lcDominicana.Post_Registrar(rSalesH, pRegistroEnLinea, recTPV); //+#103585
//             3:
//                 lcParaguay.Post_Registrar(rSalesH, pRegistroEnLinea, recTPV);
//         end;
//         //-#120811
//     end;


//     procedure TestIDYaUtilizado(rSalesHeader: Record "Sales Header"; pNotificar: Boolean; var vNotificacion: Text[1024]): Boolean
//     var
//         lrSalesLine: Record "Sales Line";
//         lrPagosTPV: Record "Pagos TPV";
//         TextL001: Label 'Ya había lineas de venta con este mismo código. Hay que revisar la configuración de series.';
//         TextL002: Label 'Ya había lineas de pago con este mismo código. Hay que revisar la configuración de series.';
//         lResult: Boolean;
//     begin
//         //+#12123
//         //... He visto que se puede llegar a utilizar un ID venta ya usado.
//         //... Se commprueban lineas de venta y lineas de pago, aunque se podrían revisar también las tablas "Transacciones Caja TPV" y "Transacciones TPV"
//         lResult := false;

//         lrSalesLine.Reset;
//         lrSalesLine.SetRange("Document Type", rSalesHeader."Document Type");
//         lrSalesLine.SetRange("Document No.", rSalesHeader."No.");
//         if lrSalesLine.FindFirst then begin
//             lResult := true;
//             vNotificacion := TextL001;
//         end;

//         if not lResult then begin
//             lrPagosTPV.Reset;
//             lrPagosTPV.SetRange("No. Borrador", rSalesHeader."No.");
//             if lrPagosTPV.FindFirst then begin
//                 lResult := true;
//                 vNotificacion := TextL002;
//             end;
//         end;

//         if lResult and pNotificar then
//             Message(vNotificacion);

//         exit(lResult);
//     end;


//     procedure Actualiza_Venta_Contacto_2(var rSalesH: Record "Sales Header"): Text
//     var
//         rSalesLin: Record "Sales Line";
//         lrContact: Record Contact;
//         lrTienda: Record Tiendas;
//         lLocation: Code[10];
//         lrTPV: Record "Configuracion TPV";
//         lNumLog: Integer;
//         lDto: Decimal;
//         lCupon: Code[20];
//     begin
//         //+#144756

//         if Pais in [1, 2, 3, 4, 5, 7, 8, 9] then
//             exit;

//         lNumLog := IniciarLog(6, rSalesH.Tienda, rSalesH.TPV);

//         if rSalesH."Cod. Colegio" = '' then
//             exit;

//         ModificarDatosLog(lNumLog, 102, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV",
//                           rSalesH."No. Comprobante Fiscal", rSalesH."Cod. Colegio");

//         lrTienda.Get(rSalesH.Tienda);
//         lrTPV.Get(rSalesH.Tienda, rSalesH.TPV);

//         //+#175576
//         //IF lrTPV."Venta Movil" THEN BEGIN
//         if lrTPV."Venta Movil" or (lrTPV."Precio por contacto" = lrTPV."Precio por contacto"::"En todos los casos") then begin
//             //-#1775576

//             ModificarDatosLog(lNumLog, 103, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV",
//                               rSalesH."No. Comprobante Fiscal", rSalesH."Cod. Colegio");

//             lLocation := lrTienda."Cod. Almacen";

//             if lrContact.Get(rSalesH."Cod. Colegio") then
//                 if lrContact."Cod. Almacen" <> '' then
//                     lLocation := lrContact."Cod. Almacen";

//             //IF lLocation <> rSalesH."Location Code" THEN BEGIN  //+#175576 -

//             rSalesH.SetHideValidationDialog(true);

//             //+#175576
//             //rSalesH.VALIDATE("Location Code"       , lLocation);
//             if lrTPV."Venta Movil" then
//                 rSalesH.Validate("Location Code", lLocation);
//             //-#175576

//             rSalesH.Validate("Sell-to Contact No.", rSalesH."Cod. Colegio");
//             rSalesH.Validate("Bill-to Contact No.", rSalesH."Cod. Colegio");
//             rSalesH.Validate("Cod. Colegio", rSalesH."Cod. Colegio");
//             rSalesH.Modify(false);

//             rSalesLin.Reset;
//             rSalesLin.SetRange("Document Type", rSalesH."Document Type");
//             rSalesLin.SetRange("Document No.", rSalesH."No.");
//             if rSalesLin.FindFirst then begin
//                 rSalesLin.SetHideValidationDialog(true);
//                 repeat
//                     //+#175576
//                     //rSalesLin.VALIDATE("Location Code"       , lLocation);
//                     if lrTPV."Venta Movil" then
//                         rSalesLin.Validate("Location Code", lLocation);
//                     //-#175576

//                     rSalesLin.Validate("Cod. Colegio", rSalesH."Cod. Colegio");
//                     lDto := rSalesLin."Line Discount %";

//                     //+#287606
//                     //... Al efectuar el VALIDATE sobre el campo "Quantity", se pierde el valor del cupon. Lo guardamos para luego recuperarlo.
//                     lCupon := rSalesLin."Cod. Cupon";
//                     //+#287606

//                     rSalesLin.Validate(Quantity);

//                     rSalesLin."Cod. Cupon" := lCupon; //+#287606

//                     rSalesLin.Validate("Line Discount %", lDto);
//                     rSalesLin.Modify(false);
//                 until rSalesLin.Next = 0;
//             end;

//             ModificarDatosLog(lNumLog, 104, rSalesH."Document Type", rSalesH."No.", rSalesH."Posting No.", rSalesH."No. Fiscal TPV",
//                               rSalesH."No. Comprobante Fiscal", rSalesH."Cod. Colegio" + ': ' + lLocation);

//             //END; //+#175576

//         end;
//     end;


//     procedure TestFormaPago(lrSH: Record "Sales Header"; var vMensajeError: Text[1024]): Boolean
//     var
//         lrPagos: Record "Pagos TPV";
//         lrPagos2: Record "Pagos TPV";
//         lrAuxPagos: Record "Pagos TPV";
//         lrNCR: Record "Sales Cr.Memo Header";
//         lResult: Boolean;
//         TextL001: Label 'En el NCR %1M Se ha indicado el  cliente %2 para liquidar la venta con cliente %3';
//         TextL002: Label 'Se ha indicado el NCR %1 para liquidar la venta. Sin embargo dicho NCR ha excedido ya su crédito.';
//         TextL003: Label 'No se ha encontrado el NCR %1';
//         lrTMP_NCR: Record "Sales Cr.Memo Header" temporary;
//         TextL004: Label 'El NCR %1 se ha registrado con divisa %2. Faltaría adaptar los cobros en divisa para la compensación con NCR.';
//         lImporteTotal: Decimal;
//         lImportePendiente: Decimal;
//         lImporteTotalCompensado: Decimal;
//         lrFP: Record "Formas de Pago";
//     begin
//         //+#70132
//         //... Antes de registrar, por si acaso, revisamos que no estemos liquidando de más, mediante la forma de pago mediante NCR.
//         //... Se revisará:
//         //... 1) Que el cliente sea el mismo, 2) Que el NCR sea en divisa loca,
//         //... 3) Que el importe pendiente de liquidar en el documento NCR sea inferior o igual, al importe total ligado al NCR indicado en el pago.
//         //... 4) Que el "Importe total compensado" no exceda el importe total del NCR.
//         //...

//         lResult := true;

//         //+#232158 - Se deja esta acción desactivada para no crear campos en la tabla 114. Se puede activar en cualquier momento.
//         /*
//         lrPagos.RESET;
//         lrPagos.SETCURRENTKEY("No. Borrador");
//         lrPagos.SETRANGE("No. Borrador",lrSH."No.");
//         lrPagos.SETFILTER("NCR regis. de compensación",'<>%1','');
        
//         //... En primer lugar, ajustamos el valor del NCR de compensación por si se hubiera cambiado la forma de pago, y hubiera quedado algún valor.
//         IF lrPagos.FINDFIRST THEN
//           REPEAT
//             lrFP.GET(lrPagos."Forma pago TPV");
//             IF lrFP."Tipo Compensacion NC" <> lrFP."Tipo Compensacion NC"::Sí THEN BEGIN
//               lrPagos2 := lrPagos;
//               lrPagos2."NCR regis. de compensación" := '';
//               lrPagos2.MODIFY;
//             END;
//           UNTIL lrPagos.NEXT=0;
        
        
//         IF lrPagos.FINDFIRST THEN
//           REPEAT
//             IF NOT lrTMP_NCR.GET(lrPagos."NCR regis. de compensación") THEN BEGIN
//               lrTMP_NCR.INIT;
//               lrTMP_NCR."No." := lrPagos."NCR regis. de compensación";
//               lrTMP_NCR.INSERT;
        
//               lrAuxPagos.RESET;
//               lrAuxPagos.SETCURRENTKEY("No. Borrador");
//               lrAuxPagos.SETRANGE("No. Borrador",lrSH."No.");
//               lrAuxPagos.SETRANGE("NCR regis. de compensación",lrPagos."NCR regis. de compensación");
//               lrAuxPagos.CALCSUMS("Importe (DL)");
        
//               IF lrNCR.GET(lrPagos."NCR regis. de compensación") THEN BEGIN
//                 IF lrNCR."Sell-to Customer No." <> lrSH."Sell-to Customer No." THEN BEGIN
//                   lResult:= FALSE;
//                   vMensajeError := STRSUBSTNO(TextL001,lrNCR."No.",lrNCR."Sell-to Customer No.",lrSH."Sell-to Customer No." );
//                 END
//                 ELSE BEGIN
//                   //RRT.ATT
//                   IF FALSE AND (lrNCR."Currency Code" <> '') THEN BEGIN  //... Dejo desactivada la comprobación de divisa. Se usará siempre la divisa local.
//                     lResult := FALSE;
//                     vMensajeError := STRSUBSTNO(TextL004,lrNCR."No.",lrNCR."Currency Code" );
//                   END
//                   ELSE BEGIN
//                     lrNCR.CALCFIELDS("Importe total LCY","Importe pendiente LCY","Importe total compensado (LCY)");
//                     lImporteTotal           := -1 * lrNCR."Importe total LCY";
//                     lImportePendiente       := -1 * lrNCR."Importe pendiente LCY";
//                     lImporteTotalCompensado := lrNCR."Importe total compensado (LCY)" + lrAuxPagos."Importe (DL)";
//                     //... Con la comprobacion del importe pendiente sería suficiente. De momento para asegurar, lo dejo así.
//                     IF ( lImporteTotal < lImporteTotalCompensado) OR
//                        ( lImportePendiente < lrAuxPagos."Importe (DL)") THEN BEGIN
//                       lResult := FALSE;
//                       vMensajeError := STRSUBSTNO(TextL002,lrNCR."No.");
//                     END;
//                   END;
        
//                 END;
//               END
//               ELSE BEGIN
//                 lResult := FALSE;
//                 vMensajeError := STRSUBSTNO(TextL003,lrNCR."No.");
//               END;
//             END;
//           UNTIL (lrPagos.NEXT=0) OR (NOT lResult);
//         */
//         //-#232158

//         exit(lResult);

//     end;


//     procedure ImportePropuestoPagoNCR(p_Evento: DotNet ): Text
//     var
//         lrNCR: Record "Sales Cr.Memo Header";
//         lrSH: Record "Sales Header";
//         lNCR: Code[20];
//         lrPagosTPV: Record "Pagos TPV";
//         lImporteVentaPdte: Decimal;
//         lResult: Decimal;
//         lDocVenta: Code[20];
//         lImportePendiente: Decimal;
//         lImporteTotal: Decimal;
//         Evento: DotNet ;
//         TextL001: Label 'No se ha podido determinar ningún importe aplicable para este NCR';
//         TextL002: Label 'En el NCR %1 se ha indicado el  cliente %2 para liquidar la venta con cliente %3';
//         TextL003: Label 'No se ha encontrado el NCR indicado %1';
//         lSeguir: Boolean;
//     begin
//         //+#70132
//         //... Esta función debe integrarse con la DLL.
//         //... Se debe recibir un primer parametro con el documento de venta y un segundo parametro con el código del NCR asociado.
//         lResult := 0;
//         lDocVenta := p_Evento.TextoDato;
//         lNCR := p_Evento.TextoDato2;

//         if lrSH.Get(lrSH."Document Type"::Invoice, lDocVenta) then
//             lrSH.CalcFields("Amount Including VAT");

//         lSeguir := true;
//         if not lrNCR.Get(lNCR) then
//             lSeguir := false;

//         //+#232158
//         //... Desactivamos para no tener que crear el campo en la tabla 114.
//         /*
//         IF lSeguir THEN BEGIN
        
//           lrPagosTPV.RESET;
//           lrPagosTPV.SETCURRENTKEY("No. Borrador");
//           lrPagosTPV.SETRANGE("No. Borrador",lDocVenta);
//           lrPagosTPV.CALCSUMS("Importe (DL)");
        
//           lImporteVentaPdte := lrSH."Amount Including VAT" - lrPagosTPV."Importe (DL)";
        
//           IF lImporteVentaPdte > 0 THEN BEGIN
        
//             //... Elegimos el valor de lResult. Debe ser el valor mininimo entre:
//             //... 1. El importe pendiente de la venta.
//             //... 2. La diferencia entre el total del NCR y el importe total que se ha compensado (este valor puede haber sido incrementado teoricamente en otra máquina).
//             //... 3. El importe de la NCR pendiente de liquidar.
        
//             lResult := lImporteVentaPdte;  //... 1
//             lrNCR.CALCFIELDS("Importe total LCY","Importe pendiente LCY","Importe total compensado (LCY)");
//             lImporteTotal     := -1 * lrNCR."Importe total LCY";
//             lImportePendiente := -1 * lrNCR."Importe pendiente LCY";
        
//             IF ( lImporteTotal - lrNCR."Importe total compensado (LCY)") < lResult THEN
//               lResult := lImporteTotal - lrNCR."Importe total compensado (LCY)"; //... 2
        
//             IF lImportePendiente < lResult THEN
//               lResult := lImportePendiente;  //... 3
        
//           END;
        
//         END;
//         */
//         //+#232158

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Evento.TipoEvento := p_Evento.TipoEvento;

//         if not lSeguir then begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := StrSubstNo(TextL003, lrNCR."No.");
//             exit(Evento.aXml());
//         end;

//         //-#232158
//         /*
//         IF lrNCR."Sell-to Customer No." <> lrSH."Sell-to Customer No." THEN BEGIN
//           Evento.AccionRespuesta := 'ERROR';
//           Evento.TextoRespuesta  := STRSUBSTNO(TextL002,lrNCR."No.",lrNCR."Sell-to Customer No.",lrSH."Sell-to Customer No.");
//           EXIT(Evento.aXml());
//         END;
//         */
//         //-#232158

//         if lResult = 0 then begin
//             Evento.AccionRespuesta := 'ERROR';
//             Evento.TextoRespuesta := TextL001;
//             exit(Evento.aXml());
//         end;

//         Evento.AccionRespuesta := 'OK';
//         Evento.DatoDecimal := lResult;

//         exit(Evento.aXml());

//     end;


//     procedure AntesDeImprimir(pCodVenta: Code[20])
//     begin
//         //+#184407
//         case Pais of
//             //... Antes de imprimir debe llamarse a las funciones FE de envio eletrónico.
//             9:
//                 cCostaRica.AntesDeImprimir(pCodVenta);
//         end;
//     end;


//     procedure ActualizarEstadoRegistro(lrSH: Record "Sales Header")
//     var
//         lrSL: Record "Sales Line";
//         lrPagosTPV: Record "Pagos TPV";
//     begin
//         //+#211509
//         //... Actualizamos el valor del campo "Registrado TPV" en la tabla 37 - "Sales Line".
//         lrSL.Reset;
//         lrSL.SetRange("Document Type", lrSH."Document Type");
//         lrSL.SetRange("Document No.", lrSH."No.");
//         if lrSL.FindFirst then
//             repeat
//                 lrSL."Registrado TPV" := true;
//                 lrSL.Modify;
//             until lrSL.Next = 0;

//         //... También actualizamos el campo en la tabla "Pagos TPV".
//         lrPagosTPV.Reset;
//         lrPagosTPV.SetRange("No. Borrador", lrSH."No.");
//         if lrPagosTPV.FindFirst then
//             repeat
//                 lrPagosTPV."Registrado TPV" := true;
//                 lrPagosTPV.Modify;
//             until lrPagosTPV.Next = 0;
//     end;


//     procedure CalculoSeriesNCF(pEvento: DotNet ): Text
//     var
//         lcSalvador: Codeunit "Funciones DsPOS - Salvador";
//     begin
//         //+#325138
//         //En el Salvador, las series NCF se obtienen a partir de un valor localizado en la pantalla DS-POS.
//         case Pais of
//             6:
//                 exit(lcSalvador.CalculoSeriesNCF(pEvento));
//         end;

//         exit('');
//     end;


//     procedure Log_InfoComplementaria(pCupon: Code[20])
//     begin
//         //#328529
//         wCupon4Log := pCupon;
//     end;


//     procedure ObtenerCantidadYaDevuelta(lrLinNCR: Record "Sales Line"; var vCantidadOriginal: Decimal; var vCantidadYaDevuelta: Decimal): Boolean
//     var
//         lrNCR: Record "Sales Header";
//         lrLinVenta: Record "Sales Line";
//         lrLinHistVenta: Record "Sales Invoice Line";
//         lResult: Boolean;
//     begin
//         //+#355717B

//         lResult := false;

//         if lrNCR.Get(lrLinNCR."Document Type", lrLinNCR."Document No.") then begin
//             if RegistroEnLinea(lrNCR.Tienda) then begin
//                 if lrLinHistVenta.Get(lrLinNCR."Devuelve a Documento", lrLinNCR."Devuelve a Linea Documento") then
//                     if lrLinHistVenta."No." = lrLinNCR."No." then begin
//                         vCantidadOriginal := lrLinHistVenta.Quantity;
//                         if lrLinHistVenta."Cantidad devuelta TPV" >= 0 then begin
//                             vCantidadYaDevuelta := lrLinHistVenta."Cantidad devuelta TPV";
//                             lResult := true;
//                         end;
//                     end;
//             end
//             else begin
//                 lrLinVenta.Reset;
//                 lrLinVenta.SetRange("Document Type", lrLinVenta."Document Type"::Invoice);
//                 lrLinVenta.SetRange("Posting No.", lrLinNCR."Devuelve a Documento");
//                 lrLinVenta.SetRange("Line No.", lrLinNCR."Devuelve a Linea Documento");
//                 lrLinVenta.SetRange("No.", lrLinNCR."No.");  //... Por si acaso.
//                 if lrLinVenta.FindFirst then begin
//                     vCantidadOriginal := lrLinVenta.Quantity;
//                     if lrLinVenta."Cantidad devuelta TPV" >= 0 then begin
//                         vCantidadYaDevuelta := lrLinVenta."Cantidad devuelta TPV";
//                         lResult := true;
//                     end;
//                 end;
//             end;
//         end;

//         exit(lResult);
//     end;


//     procedure CalcularImporteAsignacionNCR(lrPagos: Record "Pagos TPV"; pModo: Option Test,Asignacion; var vMensaje: Text; var vImporte: Decimal; var vImporteDL: Decimal): Boolean
//     var
//         lrNCR: Record "Sales Header";
//         lrPagosDev: Record "Pagos TPV";
//         TextL001: Label 'No se puede crear la nota de crédito por no poder precisar las formas de pago correctas. La anulación debe realizarse mediante devolución.';
//     begin
//         //+#355717B
//         //... Buscamos las devoluciones asociadas a una factura, y vemos el importe ya descontado en esa forma de pago.

//         vImporte := lrPagos.Importe;
//         vImporteDL := lrPagos."Importe (DL)";

//         vMensaje := '';

//         lrNCR.Reset;
//         lrNCR.SetRange("Document Type", lrNCR."Document Type"::"Credit Memo");
//         lrNCR.SetRange("Venta TPV", true);
//         lrNCR.SetRange(Tienda, lrPagos.Tienda);
//         lrNCR.SetRange("Anula a Documento", lrPagos."No. Factura");
//         if lrNCR.FindFirst then
//             repeat

//                 lrPagosDev.Reset;
//                 lrPagosDev.SetCurrentKey("No. Borrador");
//                 lrPagosDev.SetRange("No. Borrador", lrNCR."No.");
//                 lrPagosDev.SetRange("Forma pago TPV", lrPagos."Forma pago TPV");
//                 lrPagosDev.SetRange(Cambio, lrPagos.Cambio);  //+#381937
//                 if lrPagosDev.FindFirst then
//                     //... Puede haber cambio, así que puede haber 2 lineas de pago para una misma forma de pago.
//                     repeat
//                         vImporte := vImporte + lrPagosDev.Importe; //Se suma ya que las devoluciones aparecen en negativo.
//                         vImporteDL := vImporteDL + lrPagosDev."Importe (DL)";

//                         //... Si ocurre la siguiente condición es porque en la devolución se ha usado una forma de pago F1, con un importe mayor que en
//                         //... la misma forma de pago en la factura original.
//                         if (vImporte < 0) and (not lrPagosDev.Cambio) then begin   //+#381937
//                             if pModo = pModo::Test then begin
//                                 vMensaje := TextL001;
//                                 exit(false);
//                             end
//                             else
//                                 Error(TextL001);
//                         end;

//                     until lrPagosDev.Next = 0;

//             until lrNCR.Next = 0;

//         exit(true);
//     end;


//     procedure CalcularImporteAsignacionNCR_2(lrPagos: Record "Pagos TPV"; pModo: Option Test,Asignacion; var vMensaje: Text; var vImporte: Decimal; var vImporteDL: Decimal): Boolean
//     var
//         lrNCR: Record "Sales Cr.Memo Header";
//         lrPagosDev: Record "Pagos TPV";
//         TextL001: Label 'No se puede crear la nota de crédito por no poder precisar las formas de pago correctas. La anulación debe realizarse mediante devolución.';
//     begin
//         //+#355717B
//         //... Buscamos las devoluciones asociadas a una factura, y vemos el importe ya descontado en esa forma de pago.

//         vImporte := lrPagos.Importe;
//         vImporteDL := lrPagos."Importe (DL)";

//         vMensaje := '';

//         lrNCR.Reset;
//         lrNCR.SetRange("Venta TPV", true);
//         lrNCR.SetRange(Tienda, lrPagos.Tienda);
//         lrNCR.SetRange("Anula a Documento", lrPagos."No. Factura");
//         if lrNCR.FindFirst then
//             repeat

//                 lrPagosDev.Reset;
//                 lrPagosDev.SetCurrentKey("No. Nota Credito");
//                 lrPagosDev.SetRange("No. Nota Credito", lrNCR."No.");
//                 lrPagosDev.SetRange("Forma pago TPV", lrPagos."Forma pago TPV");
//                 if lrPagosDev.FindFirst then
//                     //... Puede haber cambio, así que puede haber 2 lineas de pago para una misma forma de pago.
//                     repeat
//                         vImporte := vImporte + lrPagosDev.Importe; //Se suma ya que las devoluciones aparecen en negativo.
//                         vImporteDL := vImporteDL + lrPagosDev."Importe (DL)";

//                         //... Si ocurre la siguiente condición es porque en la devolución se ha usado una forma de pago F1, con un importe mayor que en
//                         //... la misma forma de pago en la factura original.
//                         if vImporte < 0 then begin
//                             if pModo = pModo::Test then begin
//                                 vMensaje := TextL001;
//                                 exit(false);
//                             end
//                             else
//                                 Error(TextL001);
//                         end;

//                     until lrPagosDev.Next = 0;

//             until lrNCR.Next = 0;

//         exit(true);
//     end;


//     procedure TestViabilidadNCR(lrCV: Record "Sales Header"; var vMensaje: Text): Boolean
//     var
//         TextL001: Label 'Esta venta ya tiene una NCR asociada. Complete la anulación vía devolución.';
//         TextL002: Label 'Se ha realizado una devolución con una forma de pago %1 que no se utilizó en la factura original. La anulación deberá realizarse mediante devolución.';
//         lrNCR: Record "Sales Header";
//         lrPagosFactura: Record "Pagos TPV";
//         lrPagosDev: Record "Pagos TPV";
//         lrTienda: Record Tiendas;
//         TextL003: Label 'Esta venta ya tiene una devolución asociada. Complete la anulación vía devolución.';
//     begin
//         //+#355717B
//         //... Validamos que la NCR se pueda crear.


//         //+#374964
//         //... Si hay establecida una forma de pago fija para la NCR, no tiene sentido esta validaci?n.
//         if lrTienda.Get(lrCV.Tienda) then
//             if lrTienda."Forma pago para NCR" <> '' then
//                 exit(true);
//         //-#374964

//         //... Si existe alguna devolución asociada a la factura original, se permite la NCR.
//         //... Sin embargo, si ya existe alguna NCR, no.

//         vMensaje := '';

//         lrNCR.Reset;
//         lrNCR.SetRange("Document Type", lrNCR."Document Type"::"Credit Memo");
//         lrNCR.SetRange("Venta TPV", true);
//         lrNCR.SetRange(Tienda, lrCV.Tienda);
//         lrNCR.SetRange("Anula a Documento", lrCV."Posting No.");
//         lrNCR.SetRange(Devolucion, false);
//         if lrNCR.FindFirst then begin
//             vMensaje := TextL001;
//             exit(false);
//         end;

//         lrNCR.SetRange(Devolucion, true);

//         //+#373762
//         //... Se elimina la coexistencia de devoluciones y de NCR para un docuemento de venta.
//         //... Sólo se permite si la NCR se construye con una forma de pago fija.
//         if lrNCR.FindFirst then begin
//             vMensaje := TextL003;
//             exit(false);
//         end;
//         //-#373762

//         if lrNCR.FindFirst then
//             repeat

//                 lrPagosDev.Reset;
//                 lrPagosDev.SetCurrentKey("No. Borrador");
//                 lrPagosDev.SetRange("No. Borrador", lrNCR."No.");
//                 if lrPagosDev.FindFirst then
//                     repeat

//                         lrPagosFactura.Reset;
//                         lrPagosFactura.SetRange("No. Factura", lrNCR."Anula a Documento");
//                         lrPagosFactura.SetRange("Forma pago TPV", lrPagosDev."Forma pago TPV");

//                         //... Si alguna devolución vemos tiene alguna forma de pago diferente de la efectuada con la factura original,
//                         //... obligamos a que se realice la anulación vía devolución.... Así se deberá indicar con que medios de pago se realiza la devolución.
//                         if not lrPagosFactura.FindFirst then begin
//                             vMensaje := StrSubstNo(TextL002, lrPagosDev."Forma pago TPV");
//                             exit(false);
//                         end;

//                     until lrPagosDev.Next = 0;

//             until lrNCR.Next = 0;

//         exit(true);
//     end;


//     procedure TestViabilidadNCR_2(lrSIH: Record "Sales Invoice Header"; var vMensaje: Text): Boolean
//     var
//         TextL001: Label 'Esta venta ya tiene una NCR asociada. Complete la anulación vía devolución.';
//         TextL002: Label 'Se ha realizado una devolución con una forma de pago %1 que no se utilizó en la factura original. La anulación deberá realizarse mediante devolución.';
//         lrNCR: Record "Sales Cr.Memo Header";
//         lrPagosFactura: Record "Pagos TPV";
//         lrPagosDev: Record "Pagos TPV";
//         lrTienda: Record Tiendas;
//         TextL003: Label 'Esta venta ya tiene una devolución asociada. Complete la anulación vía devolución.';
//     begin
//         //+#355717B
//         //... Validamos que la NCR se pueda crear.

//         //+#374964
//         //... Si hay establecida una forma de pago fija para la NCR, no tiene sentido esta validaci?n.
//         if lrTienda.Get(lrSIH.Tienda) then
//             if lrTienda."Forma pago para NCR" <> '' then
//                 exit(true);
//         //-#374964

//         //... Si existe alguna devolución asociada a la factura original, se permite la NCR.
//         //... Sin embargo, si ya existe alguna NCR, no.

//         vMensaje := '';

//         lrNCR.Reset;
//         lrNCR.SetRange("Venta TPV", true);
//         lrNCR.SetRange(Tienda, lrSIH.Tienda);
//         lrNCR.SetRange("Anula a Documento", lrSIH."No.");
//         lrNCR.SetRange(Devolucion, false);
//         if lrNCR.FindFirst then begin
//             vMensaje := TextL001;
//             exit(false);
//         end;

//         lrNCR.SetRange(Devolucion, true);

//         //+#373762
//         //... Se elimina la coexistencia de devoluciones y de NCR para un docuemento de venta.
//         //... Sólo se permite si la NCR se construye con una forma de pago fija.
//         if lrNCR.FindFirst then begin
//             vMensaje := TextL003;
//             exit(false);
//         end;
//         //-#373762

//         if lrNCR.FindFirst then
//             repeat

//                 lrPagosDev.Reset;
//                 lrPagosDev.SetCurrentKey("No. Nota Credito");
//                 lrPagosDev.SetRange("No. Nota Credito", lrNCR."No.");
//                 if lrPagosDev.FindFirst then
//                     repeat

//                         lrPagosFactura.Reset;
//                         lrPagosFactura.SetRange("No. Factura", lrNCR."Anula a Documento");
//                         lrPagosFactura.SetRange("Forma pago TPV", lrPagosDev."Forma pago TPV");

//                         //... Si alguna devolución vemos tiene alguna forma de pago diferente de la efectuada con la factura original,
//                         //... obligamos a que se realice la anulación vía devolución.... Así se deberá indicar con que medios de pago se realiza la devolución.
//                         if not lrPagosFactura.FindFirst then begin
//                             vMensaje := StrSubstNo(TextL002, lrPagosDev."Forma pago TPV");
//                             exit(false);
//                         end;

//                     until lrPagosDev.Next = 0;

//             until lrNCR.Next = 0;

//         exit(true);
//     end;


//     procedure RelacionaDevolucion_0(var pSalesHeader: Record "Sales Header")
//     var
//         rLin: Record "Sales Line";
//     begin
//         //+#383107
//         rLin.Reset;
//         rLin.SetCurrentKey(Devuelto, "Devuelve a Documento");
//         rLin.SetRange("Document No.", pSalesHeader."No.");
//         rLin.SetRange("Document Type", pSalesHeader."Document Type");
//         rLin.SetFilter("Devuelve a Documento", '<>%1', '');
//         if rLin.FindSet then
//             pSalesHeader."Anula a Documento" := rLin."Devuelve a Documento";
//     end;


//     procedure RevisarAplicacionDescuentos(var p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         lrCV: Record "Sales Header";
//         lDtoAplicado: Boolean;
//         lcEcuador: Codeunit "Funciones DsPOS - Ecuador";
//         lDevolucion: Boolean;
//     begin
//         //#373762
//         //... Esta funcionalidad está activa sólo para Ecuador. De momento.

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := p_Evento.TipoEvento;
//         Evento.AccionRespuesta := '';


//         lDevolucion := true;

//         lrCV.Reset;
//         if lrCV.Get(lrCV."Document Type"::Invoice, p_Evento.TextoDato3) then begin

//             lDevolucion := false;


//             lDtoAplicado := false;
//             case Pais of
//                 4:
//                     lDtoAplicado := lcEcuador.RevisarAplicacionDescuentos(false, p_Evento.TextoDato3, p_Evento.TextoDato4, p_Evento.TextoDato6);
//             end;

//             /*
//             IF lDtoAplicado THEN BEGIN
//               Evento.AccionRespuesta := 'Actualizar_Todo';
//               Actualizar_Totales(p_Evento.TextoDato3,Evento,FALSE,FALSE);
//             END;
//             */

//         end;

//         //... Se actualiza en cualquier caso.
//         Evento.AccionRespuesta := 'Actualizar_Todo';
//         Actualizar_Totales(p_Evento.TextoDato3, Evento, false, lDevolucion);

//         exit(Evento.aXml());

//     end;


//     procedure RetrocederAplicacionDescuentos(var p_Evento: DotNet ): Text
//     var
//         Evento: DotNet ;
//         lrCV: Record "Sales Header";
//         lRetrocedido: Boolean;
//         lcEcuador: Codeunit "Funciones DsPOS - Ecuador";
//         lDevolucion: Boolean;
//     begin
//         //#373762
//         //... Esta funcionalidad está activa sólo para Ecuador. De momento.

//         lRetrocedido := false;

//         if IsNull(Evento) then
//             Evento := Evento.Evento();

//         Evento.TipoEvento := p_Evento.TipoEvento;
//         Evento.AccionRespuesta := '';

//         lDevolucion := true;

//         lrCV.Reset;
//         if lrCV.Get(lrCV."Document Type"::Invoice, p_Evento.TextoDato3) then begin
//             lDevolucion := false;

//             case Pais of
//                 4:
//                     lRetrocedido := lcEcuador.AplicarDescuento(lrCV, 0);
//             end;

//             /*
//             IF lRetrocedido THEN BEGIN
//               //... Se han modificado los descuentos de las lineas, los pagos, y los totales. Es decir: Actualizar_Todo.
//               Evento.AccionRespuesta := 'Actualizar_Todo';
//               Actualizar_Totales(p_Evento.TextoDato3,Evento,FALSE,FALSE);
//             END;
//             */

//         end;

//         //... Se actualiza en cualquier caso.
//         Evento.AccionRespuesta := 'Actualizar_Todo';
//         Actualizar_Totales(p_Evento.TextoDato3, Evento, false, lDevolucion);

//         exit(Evento.aXml());

//     end;
// }

