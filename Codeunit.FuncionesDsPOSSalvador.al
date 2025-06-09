// codeunit 76027 "Funciones DsPOS - Salvador"
// {
//     // #81410  17/07/2017  PLB: Varias tablas reunumeradas
//     // #82483  16/08/2017  PLB: No. comprobante fiscal en el diario al registrar pago
//     // #325138 23/07/2020  RRT: Se han añadido 2 nuevos campos para la venta a crédito fiscal.
//     //         06.08.2020  RRT: Corrección de un error.
//     // 
//     // #347435 RRT 05.08.2020: Gestión de cupones electrónicos. Es análogo al desarrollo de Guatemala.


//     trigger OnRun()
//     begin
//     end;

//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";


//     procedure VaciaCampos_Pais()
//     var
//         rConfTPV: Record "Configuracion TPV";
//     begin

//         rConfTPV.ModifyAll("NCF Credito fiscal", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal NCR", '');

//         //+#325138
//         rConfTPV.ModifyAll("NCF Credito fiscal 2", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal NCR 2", '');
//         //-#325138
//     end;


//     procedure Comprobaciones_Iniciales(p_Tienda: Code[20]; p_IdTPV: Code[20])
//     var
//         rConfTPV: Record "Configuracion TPV";
//         recTienda: Record Tiendas;
//     begin

//         rConfTPV.Get(p_Tienda, p_IdTPV);
//         recTienda.Get(p_Tienda);

//         rConfTPV.TestField("NCF Credito fiscal");

//         if recTienda."Permite Anulaciones en POS" then begin
//             rConfTPV.TestField("NCF Credito fiscal NCR");
//             rConfTPV.TestField("NCF Credito fiscal NCR 2"); //+#325138
//         end;
//     end;


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; var p_SalesHeader: Record "Sales Header"): Code[20]
//     var
//         rTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//     begin

//         with p_SalesHeader do begin
//             rTPV.Reset;
//             rTPV.Get(p_Tienda, p_IdTPV);
//             Commit;
//             case "Document Type" of
//                 "Document Type"::Invoice:
//                     exit(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal", p_SalesHeader."Posting Date"));
//                 "Document Type"::"Credit Memo":
//                     exit(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal NCR", p_SalesHeader."Posting Date"));
//             end;
//         end;
//     end;


//     procedure Registrar(var p_SalesH: Record "Sales Header"; var p_Evento: DotNet ): Text
//     var
//         Cust: Record Customer;
//         CustPostGroup: Record "Customer Posting Group";
//         Error001: Label 'Debe Espeficiar "Grupo contable cliente" para el cliente %1';
//         Error002: Label 'No Existe Grupo Contable Cliente %1';
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         Error003: Label 'Imposible Modificar Cab. Venta';
//         rClientesTPV: Record "Clientes TPV";
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesLine: Record "No. Series Line";
//         cduSan: Codeunit "Funciones Santillana";
//         SalesLine: Record "Sales Line";
//         intNoInicioSerie: Integer;
//         intNoFinalSerie: Integer;
//         intFactura: Integer;
//         TextoNet: array[10] of DotNet String;
//         i: Integer;
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rCab: Record "Sales Header";
//         rHistCab: Record "Sales Invoice Header";
//         Error004: Label 'La Serie NCF No tiene más numeros';
//         lTipoVentaTPV: Integer;
//     begin

//         i := 1;
//         while i <= (p_Evento.TextoPais.Length - 1) do begin
//             TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//             if IsNull(TextoNet[i]) then
//                 TextoNet[i] := '';
//             i += 1;
//         end;

//         rConfTPV.Get(p_Evento.TextoDato, p_Evento.TextoDato2);

//         //#325138
//         lTipoVentaTPV := 0;
//         if TextoNet[7].ToString = '1' then
//             lTipoVentaTPV := 1;
//         //-#325138

//         with p_SalesH do begin

//             Cust.Get("Sell-to Customer No.");
//             if Cust."Customer Posting Group" = '' then
//                 exit(StrSubstNo('%1', Error001, "Sell-to Customer No."));

//             if not CustPostGroup.Get(Cust."Customer Posting Group") then
//                 exit(StrSubstNo('%1', Error002, Cust."Customer Posting Group"));

//             if not (Devolucion) then begin

//                 // Guardamos la Cédula Para Fututos Casos
//                 if rClientesTPV.Get(TextoNet[1].ToString()) then
//                     rClientesTPV.Delete;

//                 rClientesTPV.Init;
//                 rClientesTPV.Identificacion := TextoNet[1].ToString();
//                 rClientesTPV.Direccion := TextoNet[2].ToString();
//                 rClientesTPV.Nombre := TextoNet[3].ToString();
//                 rClientesTPV.Telefono := TextoNet[4].ToString();
//                 rClientesTPV.Insert(false);

//                 "VAT Registration No." := rClientesTPV.Identificacion;
//                 "Bill-to Name" := rClientesTPV.Nombre;
//                 "Bill-to Address" := rClientesTPV.Direccion;
//                 "Sell-to Customer Name" := rClientesTPV.Nombre;
//                 "Sell-to Address" := rClientesTPV.Direccion;
//                 "No. Telefono" := rClientesTPV.Telefono;
//                 "External Document No." := "No.";

//                 //+#325138
//                 //
//                 //"No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal";
//                 if VentaAConsumidorFinal(lTipoVentaTPV) then begin
//                     "No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal";
//                     "Tipo venta TPV" := "Tipo venta TPV"::"Consumidor final";
//                 end
//                 else begin
//                     "No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal 2";
//                     "Tipo venta TPV" := "Tipo venta TPV"::"Credito fiscal";
//                 end;
//                 //-#325138

//                 ActualizaCupon(p_SalesH);

//                 if ("No. Fiscal TPV" = '') then begin

//                     NoSeriesLine.Reset;
//                     NoSeriesLine.SetRange("Series Code", "No. Serie NCF Facturas");
//                     NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//                     NoSeriesLine.SetRange(Open, true);
//                     if not NoSeriesLine.FindLast then
//                         exit(Error004);

//                     "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Facturas", "Posting Date", true);
//                     "No. Fiscal TPV" := "No. Comprobante Fiscal";

//                 end;

//             end
//             else begin  // DEVOLUCIONES

//                 //+#325138
//                 //
//                 //"No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//                 if VentaAConsumidorFinal(lTipoVentaTPV) then begin
//                     "No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//                     "Tipo venta TPV" := "Tipo venta TPV"::"Consumidor final";
//                 end
//                 else begin
//                     "No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR 2";
//                     "Tipo venta TPV" := "Tipo venta TPV"::"Credito fiscal";
//                 end;
//                 //-#325138


//                 NoSeriesLine.Reset;
//                 NoSeriesLine.SetRange("Series Code", rConfTPV."NCF Credito fiscal NCR");
//                 NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//                 NoSeriesLine.SetRange(Open, true);
//                 if not NoSeriesLine.FindLast then
//                     exit(Error004);

//                 if cfComunes.RegistroEnLinea(Tienda) then begin
//                     rHistCab.Get("Anula a Documento");
//                     "No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//                     RetrocedeCupon("Anula a Documento", true, p_SalesH."No.");
//                 end
//                 else begin
//                     rCab.SetCurrentKey("Posting No.");
//                     rCab.SetRange("Posting No.", "Anula a Documento");
//                     rCab.FindFirst;
//                     "No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//                     RetrocedeCupon("Anula a Documento", false, p_SalesH."No.");
//                 end;

//                 "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Abonos", "Posting Date", true);
//                 "No. Fiscal TPV" := "No. Comprobante Fiscal";

//             end;

//         end;
//     end;


//     procedure Ejecutar_Accion(var p_Evento: DotNet ; var p_EventoRespuesta: DotNet )
//     begin

//         case p_Evento.TextoDato4 of
//             'CUPON':
//                 AplicaCupon(p_Evento, p_EventoRespuesta);
//             'ELIMINARCUPON':
//                 EliminaCupon(p_Evento, p_EventoRespuesta);
//         end;
//     end;


//     procedure Imprimir(codPrmTienda: Code[20]; codPrmDoc: Code[20]): Boolean
//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rSalesH: Record "Sales Header";
//         rSalesInv: Record "Sales Invoice Header";
//     begin
//         exit(true);
//     end;


//     procedure RelacionaAnulacion(var pSalesH: Record "Sales Header"; CodTienda: Code[20])
//     var
//         rCab: Record "Sales Header";
//         rHistCab: Record "Sales Invoice Header";
//     begin

//         if pSalesH."Posting No." <> '' then begin
//             rCab.SetCurrentKey("Posting No.");
//             rCab.SetRange("Posting No.", pSalesH."Anula a Documento");
//             rCab.FindFirst;
//             pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//         end
//         else begin
//             rHistCab.Get(pSalesH."Anula a Documento");
//             pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//         end;

//         //+#325138
//         //... La siguiente asignación no la entiendo. Se está asignando una serie de documentos registrados.
//         //... Como parece una cuestión anterior a la modificación, de momento lo dejo así.
//         //... Pensándolo mejor, asterisco esta linea. El problemas es en las notas de crédito, y no en las devoluciones.
//         //pSalesH."No. Serie NCF Abonos"        := pSalesH."Posting No. Series";
//     end;


//     procedure AnularFactura(var pSalesH: Record "Sales Header"): Text
//     var
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         NoSeriesLine: Record "No. Series Line";
//         Error004: Label 'La Serie NCF No contiene mas numeros';
//         Error005: Label 'Nº de Autoriación no puede ser blanco para serie %1';
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rHistCab: Record "Sales Invoice Header";
//         rCab: Record "Sales Header";
//         lVentaACredito: Boolean;
//         lRegistroEnLinea: Boolean;
//     begin
//         //fes mig
//         /*
//         rConfTPV.GET(pSalesH.Tienda,pSalesH.TPV);
        
//         //#325138
//         //... Se hace la comprobacion de si es registro en linea, antes.
//         IF cfComunes.RegistroEnLinea(pSalesH.Tienda) THEN BEGIN
//           rHistCab.GET(pSalesH."Anula a Documento");
//           lRegistroEnLinea := TRUE;
//         END
//         ELSE BEGIN
//           rCab.SETCURRENTKEY("Posting No.");
//           rCab.SETRANGE("Posting No." , pSalesH."Anula a Documento");
//           rCab.FINDFIRST;
//           lRegistroEnLinea := FALSE;
//         END;
//         //-#325138
        
//         //+#325138
//         //pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//         lVentaACredito := FALSE;
//         IF lRegistroEnLinea THEN BEGIN
//           IF rHistCab."Tipo venta TPV" = rHistCab."Tipo venta TPV"::"2" THEN
//             lVentaACredito := TRUE;
//         END
//         ELSE BEGIN
//           IF rCab."Tipo venta TPV" = rCab."Tipo venta TPV"::"Credito fiscal" THEN
//             lVentaACredito := TRUE;
//         END;
        
//         IF lVentaACredito THEN BEGIN
//           pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR 2";
//           pSalesH."Tipo venta TPV"       := pSalesH."Tipo venta TPV"::"Credito fiscal";
//         END
//         ELSE BEGIN
//           pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//           pSalesH."Tipo venta TPV"       := pSalesH."Tipo venta TPV"::"Consumidor final";
//         END;
//         //-#325138
        
//         NoSeriesLine.RESET;
//         //+#325138
//         //NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SETRANGE("Series Code"      , pSalesH."No. Serie NCF Abonos");
//         //-#325138
        
//         NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//         NoSeriesLine.SETRANGE(Open,TRUE);
//         IF NOT NoSeriesLine.FINDLAST THEN
//           EXIT(Error004);
        
//         //+#325138
//         //pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , pSalesH."Posting Date" , TRUE);
//         pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(pSalesH."No. Serie NCF Abonos" , pSalesH."Posting Date" , TRUE);
//         //-#325138
        
//         pSalesH."No. Fiscal TPV"          := pSalesH."No. Comprobante Fiscal";
        
        
//         //+#325138
//         //... Hemos averiguado ya el documento relacionado, así como si el registro es en linea.
//         {
//         IF cfComunes.RegistroEnLinea(pSalesH.Tienda) THEN BEGIN
//           rHistCab.GET(pSalesH."Anula a Documento");
//           pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//           pSalesH."Cod. Cupon"                  := rHistCab."Cod. Cupon";
//           RetrocedeCupon(pSalesH."Anula a Documento",TRUE,pSalesH."No.");
//         END
//         ELSE BEGIN
//           rCab.SETCURRENTKEY("Posting No.");
//           rCab.SETRANGE("Posting No." , pSalesH."Anula a Documento");
//           rCab.FINDFIRST;
//           pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//           pSalesH."Cod. Cupon"                  := rCab."Cod. Cupon";
//           RetrocedeCupon(pSalesH."Anula a Documento",FALSE,pSalesH."No.");
//         END;
//         }
//         IF lRegistroEnLinea THEN BEGIN
//           pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//           pSalesH."Cod. Cupon"                  := rHistCab."Cod. Cupon";
//           RetrocedeCupon(pSalesH."Anula a Documento",TRUE,pSalesH."No.");
//         END
//         ELSE BEGIN
//           pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//           pSalesH."Cod. Cupon"                  := rCab."Cod. Cupon";
//           RetrocedeCupon(pSalesH."Anula a Documento",FALSE,pSalesH."No.");
//         END;
        
        
//         //-325138
//         */
//         //fes mig

//     end;


//     procedure ActualizaCupon(pSalesH: Record "Sales Header")
//     var
//         CantidadPendiente: Integer;
//         rSalesLines: Record "Sales Line";
//         lCabeceraModificada: Boolean;
//     begin
//         //fes mig
//         /*
//         lCabeceraModificada := FALSE;  //+#328529
        
//         rSalesLines.RESET;
//         rSalesLines.SETRANGE("Document Type" , pSalesH."Document Type");
//         rSalesLines.SETRANGE("Document No."  , pSalesH."No.");
//         rSalesLines.SETRANGE(Type            , rSalesLines.Type::Item);
//         IF rSalesLines.FINDSET THEN
//           REPEAT
//             IF rSalesLines."Cod. Cupon" <> '' THEN BEGIN
//               IF rLinCupon.GET(rSalesLines."Cod. Cupon",rSalesLines."No.") THEN
//                 BEGIN
//                   rLinCupon."Cantidad Pendiente" -= rSalesLines.Quantity;
//                   IF rLinCupon."Cantidad Pendiente" <= 0 THEN
//                     rLinCupon."Cantidad Pendiente" := 0;
//                   rLinCupon.MODIFY;
        
//                   //+#328529
//                   IF NOT lCabeceraModificada THEN BEGIN
//                     IF lrCabCupon.GET(rSalesLines."Cod. Cupon") THEN BEGIN
//                       IF NOT lrCabCupon.Usado THEN BEGIN
//                         lrCabCupon.Usado := TRUE;
//                         lrCabCupon.MODIFY;
//                         lCabeceraModificada := TRUE;
//                       END
//                     END;
//                   END;
//                   //-#328529
        
//                 END;
//             END;
//           UNTIL rSalesLines.NEXT = 0;
//         */
//         //fes mig

//     end;


//     procedure Ventas_Registrar_Localizado(var GenGnjLine: Record "Gen. Journal Line"; pSalesH: Record "Sales Header")
//     begin

//         with GenGnjLine do begin
//             "No. Comprobante Fiscal" := pSalesH."No. Comprobante Fiscal";
//         end;
//     end;


//     procedure Guardar_Datos_Aparcados(prmNumVenta: Code[20]; p_Evento: DotNet )
//     var
//         rPedidosAparcados: Record "Pedidos Aparcados";
//         TextoNet: array[10] of DotNet String;
//         i: Integer;
//     begin

//         // Almacenamos los datos recibidos
//         i := 1;
//         while i <= (p_Evento.TextoPais.Length - 1) do begin
//             TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//             if IsNull(TextoNet[i]) then
//                 TextoNet[i] := '';
//             i += 1;
//         end;

//         // Si ya existen datos aparcados los borramos
//         if rPedidosAparcados.Get(prmNumVenta) then
//             rPedidosAparcados.Delete;


//         // Guardamos los datos en la tabla
//         rPedidosAparcados.Init;
//         rPedidosAparcados."No." := prmNumVenta;
//         rPedidosAparcados."Numero Cliente" := TextoNet[7].ToString();
//         rPedidosAparcados."Numero Colegio" := TextoNet[8].ToString();
//         rPedidosAparcados."Nombre Colegio" := TextoNet[9].ToString();
//         rPedidosAparcados."Tipo Documento" := TextoNet[6].ToString();
//         rPedidosAparcados.Identificacion := TextoNet[1].ToString();
//         rPedidosAparcados.Nombre := TextoNet[3].ToString();
//         rPedidosAparcados.Direccion := TextoNet[2].ToString();
//         rPedidosAparcados."E-Mail" := TextoNet[5].ToString();
//         rPedidosAparcados.Telefono := TextoNet[4].ToString();
//         rPedidosAparcados.Insert(false);
//     end;


//     procedure EliminaCupon(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     var
//         rSalesLines: Record "Sales Line";
//         error001: Label 'El cupón %1 esta en estado de error : no impreso, anulado ó caducado';
//         error002: Label 'El cupón %1 no existe';
//         error003: Label 'El cupón %1 no tiene productos pendientes.';
//         error004: Label 'El cupón %1 no se ha podido borrar.';
//         text001: Label 'Cupón %1 aplicado correctamente';
//         Numero_Cupon: Code[20];
//         Numero_Documento: Code[20];
//         text002: Label 'Cupón %1 eliminado correctamente';
//     begin

//         // Nº de cupon recibido y Nº de Documento
//         Numero_Cupon := p_Evento.TextoDato6;
//         Numero_Documento := p_Evento.TextoDato3;

//         // Buscamos en la tabla 37 Sales Line
//         rSalesLines.Reset;
//         rSalesLines.SetRange("Document No.", Numero_Documento);
//         rSalesLines.SetRange("Cod. Cupon", Numero_Cupon);
//         rSalesLines.DeleteAll;

//         // Devolvemos el mensaje y la acción para actualizar las lineas
//         p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//         p_Evento_Respuesta.TextoRespuesta := StrSubstNo(text002, Numero_Cupon);
//     end;


//     procedure RetrocedeCupon(pDocOrigen: Code[20]; pOnLine: Boolean; pDocAnula: Code[20])
//     var
//         rLinFac: Record "Sales Invoice Line";
//         rLin: Record "Sales Line";
//         rCab: Record "Sales Header";
//         rLinOrigen: Record "Sales Line";
//         rCabFac: Record "Sales Invoice Header";
//         rLinOrigenFac: Record "Sales Invoice Line";
//     begin
//         //fes mig
//         /*
//         IF pOnLine THEN BEGIN
//           rLin.RESET;
//           rLin.SETRANGE("Document Type" , rLin."Document Type"::"Credit Memo");
//           rLin.SETRANGE("Document No."  , pDocAnula);
//           IF rLin.FINDFIRST THEN BEGIN
//             REPEAT
//               rLinOrigenFac.RESET;
//               rLinOrigenFac.SETRANGE("Document No."  , pDocOrigen);
//               rLinOrigenFac.SETRANGE("No."           , rLin."No.");
//               IF rLinOrigenFac.FINDFIRST THEN BEGIN
//                 REPEAT
//                   IF rLinOrigenFac."Cod. Cupon" <> '' THEN BEGIN
//                     IF rLinCupon.GET(rLinOrigenFac."Cod. Cupon",rLin."No.") THEN BEGIN
//                       rLinCupon."Cantidad Pendiente" += rLin.Quantity;
//                       rLinCupon.MODIFY(FALSE);
//                     END;
//                   END;
//                 UNTIL rLinOrigenFac.NEXT = 0;
//               END;
//             UNTIL rLin.NEXT = 0;
//           END;
//         END
//         ELSE BEGIN
//           rLin.RESET;
//           rLin.SETRANGE("Document Type" , rLin."Document Type"::"Credit Memo");
//           rLin.SETRANGE("Document No."  , pDocAnula);
//           IF rLin.FINDFIRST THEN BEGIN
//             rCab.RESET;
//             rCab.SETCURRENTKEY("Posting No.");
//             rCab.SETRANGE("Posting No." , pDocOrigen);
//             IF NOT rCab.FINDFIRST THEN
//               EXIT;
//             REPEAT
//               rLinOrigen.RESET;
//               rLinOrigen.SETRANGE("Document Type" , rLinOrigen."Document Type"::Invoice);
//               rLinOrigen.SETRANGE("Document No."  , rCab."No.");
//               rLinOrigen.SETRANGE("No."           , rLin."No.");
//               IF rLinOrigen.FINDFIRST THEN BEGIN
//                 REPEAT
//                   IF rLinOrigen."Cod. Cupon" <> '' THEN BEGIN
//                     IF rLinCupon.GET(rLinOrigen."Cod. Cupon",rLin."No.") THEN BEGIN
//                       rLinCupon."Cantidad Pendiente" += rLin.Quantity;
//                       rLinCupon.MODIFY(FALSE);
//                     END;
//                   END;
//                 UNTIL rLinOrigen.NEXT = 0;
//               END;
//             UNTIL rLin.NEXT = 0;
//           END;
//         END;
//         */
//         //fes mig

//     end;


//     procedure AplicaCupon(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     var
//         rSalesLine: Record "Sales Line";
//         NoLinea: Integer;
//         error001: Label 'El cupón %1 esta en estado de error : no impreso, anulado ó caducado';
//         error002: Label 'El cupón %1 no existe';
//         error003: Label 'El cupón %1 no tiene productos pendientes.';
//         rSalesH: Record "Sales Header";
//         error004: Label 'El cupón %1 ya esta aplicado en esta venta.';
//         error005: Label 'Imposible Aplicar cupones para diferentes colegios en la misma venta.';
//         error006: Label 'El cupón electrónico %1 debe ser usado en la tienda %2. Seleccione por favor otro cupón.';
//         error007: Label 'El cupón electrónico %1 ya está siendo aplicado en el punto de venta %2 en estos instantes. Seleccione por favor otro cupón.';
//         text001: Label 'Cupón %1 aplicado correctamente';
//         wCupon: Text;
//         Cupon: Code[20];
//         lTienda: Code[20];
//         lTPV: Code[20];
//         lTPVConflicto: Code[20];
//         lNumLog: Integer;
//         lcComunes: Codeunit "Funciones DsPOS - Comunes";
//     begin
//         //fes mig
//         /*
//         Cupon := p_Evento.TextoDato6;
        
//         //+#328529
//         lTienda := p_Evento.TextoDato;
//         lTPV    := p_Evento.TextoDato2;
//         //-#328529
        
//         IF rCabCupon.GET(Cupon) THEN BEGIN
        
//           //+#328529
//           //... Los cupones electronicos no se espera que se impriman.
//           //IF (rCabCupon.Impreso) AND (WORKDATE >= rCabCupon."Valido Desde") AND (WORKDATE <= rCabCupon."Valido Hasta") AND
//           IF ( (rCabCupon.Impreso) OR (rCabCupon.Digital)) AND (WORKDATE >= rCabCupon."Valido Desde") AND (WORKDATE <= rCabCupon."Valido Hasta") AND
//           //-#328529
//              (rCabCupon.Anulado = FALSE) THEN BEGIN
        
//             rLinCupon.RESET;
//             rLinCupon.SETRANGE("No. Cupon" , Cupon);
//             rLinCupon.SETFILTER("Cantidad Pendiente", '>%1',0);
        
//             IF rLinCupon.FINDSET THEN BEGIN
        
//               NoLinea := 0;
        
//               rSalesLine.RESET;
//               rSalesLine.SETRANGE("Document Type" , rSalesLine."Document Type"::Invoice);
//               rSalesLine.SETRANGE("Document No."  , p_Evento.TextoDato3);
//               IF rSalesLine.FINDSET THEN REPEAT
        
//                 NoLinea := rSalesLine."Line No.";
        
//                 IF rSalesLine."Cod. Cupon" = Cupon THEN BEGIN
//                   p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                   p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error004,Cupon);
//                   EXIT;
//                 END;
        
//                 IF (rSalesLine."Cod. Cupon" <> '') AND
//                    (rSalesLine."Cod. Cupon" <> rCabCupon."No. Cupon") THEN BEGIN
//                   rCabCupon2.RESET;
//                   rCabCupon2.GET(rSalesLine."Cod. Cupon");
//                   IF rCabCupon."Cod. Colegio" <> rCabCupon2."Cod. Colegio" THEN BEGIN
//                     p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                     p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error005,Cupon);
//                     EXIT;
//                   END;
//                 END;
        
//               UNTIL rSalesLine.NEXT = 0;
        
//               //+#328529
//               //... Si el cupon es electronico, examinaremos que:
//               //...    a) No corresponda a otra tienda.
//               //...    b) No esté siendo aplicado en otro equipo de la tienda en este mismo instante.
        
//               IF rCabCupon.Digital THEN BEGIN
//                 //... Punto a.
//                 //... Se supone que no deberiamos poder llegar a este punto, pero por si acaso lo valido.
//                 IF (rCabCupon.Tienda <> '') AND (rCabCupon.Tienda <> lTienda) THEN BEGIN
//                   p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                   p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error006,Cupon,rCabCupon.Tienda);
//                   EXIT;
//                 END;
        
//                 //... Punto b.
//                 IF TestCuponEnUso(Cupon,lTienda,lTPV,lTPVConflicto) THEN BEGIN
//                   p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                   p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error007,Cupon,lTPVConflicto);
//                   EXIT;
//                 END;
//               END;
//               //+#328529
        
//               REPEAT
//                 IF rLinCupon."Cantidad Pendiente" >0 THEN BEGIN
//                   NoLinea += 10000;
        
//                   rSalesLine.RESET;
//                   rSalesLine.INIT;
//                   rSalesLine.VALIDATE("Document Type"   , rSalesLine."Document Type"::Invoice);
//                   rSalesLine.VALIDATE("Document No."    , p_Evento.TextoDato3);
//                   rSalesLine.VALIDATE("Line No."        , NoLinea);
//                   rSalesLine.VALIDATE(Type              , rSalesLine.Type::Item);
//                   rSalesLine.VALIDATE("No."             , rLinCupon."Cod. Producto");
        
//                   IF rLinCupon.Cantidad > 0 THEN
//                     rSalesLine.VALIDATE(Quantity        , rLinCupon.Cantidad)
//                   ELSE
//                    rSalesLine.VALIDATE(Quantity         , 1);
        
//                   rSalesLine.VALIDATE("Line Discount %" , rLinCupon."% Descuento");
//                   rSalesLine."Cod. Cupon"               := Cupon;
//                   rSalesLine.INSERT(TRUE);
//                 END;
//               UNTIL rLinCupon.NEXT = 0;
        
//               rSalesH.GET(rSalesLine."Document Type"::Invoice,p_Evento.TextoDato3);
//               WITH rSalesH DO BEGIN
//                 "Cod. Cupon"       := Cupon;
//                 "Salesperson Code" := rCabCupon."Cod. Vendedor";
//                 MODIFY(FALSE);
//               END;
        
//               //+#328529
//               lNumLog := lcComunes.IniciarLog(7,lTienda,lTPV);
//               lcComunes.Log_InfoComplementaria(rSalesH."Cod. Cupon");
//               lcComunes.ModificarDatosLog(lNumLog,110,rSalesH."Document Type",rSalesH."No.",rSalesH."Posting No.",rSalesH."No. Fiscal TPV",rSalesH."No. Comprobante Fiscal",'');
//               //-#328529
        
        
//               p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//               p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(text001,Cupon);
        
//             END
//             ELSE BEGIN
//               p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//               p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error003,Cupon);
//             END;
        
//           END
//           ELSE BEGIN
//             p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//             p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error001,Cupon);
//           END;
        
//         END
//         ELSE BEGIN
//           p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//           p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(error002,Cupon);
//         END;
//         */
//         //fes mig

//     end;


//     procedure Linea_LocalizadaOFF(var prOrigen: Record "Sales Line"; var prDestino: Record "Sales Line")
//     begin

//         prDestino."Cod. Cupon" := prOrigen."Cod. Cupon";
//     end;


//     procedure DiarioGeneralPago(var prGenJnlLine: Record "Gen. Journal Line"; prCodFormaPago: Code[20]; prNombreCliente: Text[80]; prNoFiscal: Code[10])
//     var
//         recFormaPago: Record "Formas de Pago";
//     begin
//         //+#78451

//         recFormaPago.Get(prCodFormaPago);
//         recFormaPago.TestField("Forma pago");

//         prGenJnlLine.TestField("VAT Registration No.");
//         prGenJnlLine.Description := CopyStr(prNombreCliente, 1, MaxStrLen(prGenJnlLine.Description));
//         prGenJnlLine."No. Comprobante Fiscal" := prNoFiscal; //+#82483
//     end;


//     procedure VentaAConsumidorFinal(pTipoVenta: Integer): Boolean
//     begin
//         //#325138
//         //0: -> Consumidor final // 1: -> Credito fiscal.
//         if pTipoVenta = 0 then
//             exit(true);

//         exit(false);
//     end;


//     procedure CalculoSeriesNCF(pEvento: DotNet ): Text
//     var
//         lEventoRespuesta: DotNet ;
//         lCredito: DotNet String;
//         lStrCredito: Text[10];
//         lNCF_Factura: Code[20];
//         lNCF_NCR: Code[20];
//         lIdTipoVenta: DotNet String;
//         lTipoVentaTPV: Integer;
//     begin
//         //#325138
//         lIdTipoVenta := pEvento.TextoPais.GetValue(7);
//         if IsNull(lIdTipoVenta) then
//             lIdTipoVenta := '';

//         lTipoVentaTPV := 0;
//         if lIdTipoVenta.ToString = '1' then
//             lTipoVentaTPV := 1;


//         if VentaAConsumidorFinal(lTipoVentaTPV) then
//             CalculoSeriesNCF_2(pEvento.TextoDato, pEvento.TextoDato2, true, lNCF_Factura, lNCF_NCR)
//         else
//             CalculoSeriesNCF_2(pEvento.TextoDato, pEvento.TextoDato2, false, lNCF_Factura, lNCF_NCR);

//         if IsNull(lEventoRespuesta) then
//             lEventoRespuesta := lEventoRespuesta.Evento;

//         lEventoRespuesta.AccionRespuesta := 'OK';
//         lEventoRespuesta.TextoDato := lNCF_Factura;
//         lEventoRespuesta.TextoDato2 := lNCF_NCR;

//         exit(lEventoRespuesta.aXml());
//     end;


//     procedure CalculoSeriesNCF_2(pTienda: Code[20]; pTPV: Code[20]; pCreditoFiscal: Boolean; var vNCF_Factura: Code[20]; var vNCF_NCR: Code[20])
//     var
//         lrTPV: Record "Configuracion TPV";
//     begin
//         //+#325138
//         lrTPV.Get(pTienda, pTPV);

//         if pCreditoFiscal then begin
//             vNCF_Factura := lrTPV."NCF Credito fiscal 2";
//             vNCF_NCR := lrTPV."NCF Credito fiscal NCR 2";
//         end
//         else begin
//             vNCF_Factura := lrTPV."NCF Credito fiscal";
//             vNCF_NCR := lrTPV."NCF Credito fiscal NCR";
//         end;
//     end;


//     procedure DevolverSiguienteNum(pTipo: Option "Consumidor Final","Credito Fiscal"; pTienda: Code[20]; pTPV: Code[20]; pDevolucion: Integer): Text
//     var
//         Evento: DotNet ;
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         TextL001: Label 'NCF Actualizado CORRECTAMENTE según tipo de cliente';
//         TextL002: Label 'No se ha detectado el tipo de venta';
//         lError: Boolean;
//     begin
//         //+#325138

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Commit;
//         Evento.TipoEvento := 20;
//         rConfTPV.Get(pTienda, pTPV);
//         lError := false;

//         if pDevolucion > 0 then begin
//             case pTipo of
//                 pTipo::"Consumidor Final":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Credito fiscal NCR", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Credito fiscal NCR";
//                     end;

//                 pTipo::"Credito Fiscal":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Credito fiscal NCR 2", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Credito fiscal NCR 2";
//                     end;
//                 else
//                     lError := true;
//             end;
//         end
//         else begin
//             case pTipo of
//                 pTipo::"Consumidor Final":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Credito fiscal", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Credito fiscal";
//                     end;

//                 pTipo::"Credito Fiscal":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Credito fiscal 2", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Credito fiscal 2";
//                     end;
//                 else
//                     lError := true;
//             end;
//         end;

//         if lError then begin
//             Evento.TextoRespuesta := TextL002;
//             Evento.AccionRespuesta := 'ERROR';
//         end
//         else begin
//             Evento.TextoRespuesta := TextL001;
//             Evento.AccionRespuesta := 'OK';
//         end;

//         exit(Evento.aXml())
//     end;


//     procedure TestCuponEnUso(pCupon: Code[20]; pTienda: Code[20]; pTPVRef: Code[20]; var vTPVConflicto: Code[20]): Boolean
//     var
//         lrTPV: Record "Configuracion TPV";
//     begin
//         //#328529
//         //... Se revisa si algún otro punto de venta está utilizando el cupon.
//         lrTPV.Reset;
//         lrTPV.SetRange(Tienda, pTienda);
//         lrTPV.SetFilter("Id TPV", '<>%1', pTPVRef);
//         lrTPV.SetFilter("Usuario windows", '<>%1', '');
//         if lrTPV.FindFirst then
//             repeat
//                 if TestLogCuponEnUso(pCupon, lrTPV.Tienda, lrTPV."Id TPV") then begin
//                     vTPVConflicto := lrTPV."Id TPV";
//                     exit(true);
//                 end;

//             until lrTPV.Next = 0;


//         exit(false);
//     end;


//     procedure TestLogCuponEnUso(pCupon: Code[20]; pTienda: Code[20]; pTPV: Code[20]): Boolean
//     var
//         lrLog: Record "Log procesos TPV";
//         lrLogAux: Record "Log procesos TPV";
//     begin
//         //#328529
//         //... Se revisa si algún otro punto de venta está utilizando el cupon.
//         lrLog.Reset;
//         lrLog.SetCurrentKey(Tienda, TPV, Cupon);
//         lrLog.SetRange(Tienda, pTienda);
//         lrLog.SetRange(TPV, pTPV);
//         lrLog.SetRange(Cupon, pCupon);

//         //... Este será sin duda el caso general. Conviene que sea rápido.
//         if not lrLog.FindLast then
//             exit(false);

//         //... Si fue usado hace más de 1 día, ni lo revisamos.
//         if lrLog."Fecha creacion" < Today then
//             exit(false);

//         lrLogAux.Reset;
//         lrLogAux.SetCurrentKey("No. Log");
//         lrLogAux.Get(lrLog."No. Log");

//         //... Estamos analizando sólo 1 TPV. No nos interesa el resto.
//         lrLogAux.SetRange(TPV, pTPV);
//         repeat
//             //... Si con posterioridad, hemos encontrado una operación de registro o el inicio de una nueva venta, es porque se puede aplicar este cupón.
//             //... En caso contrario, no.
//             if lrLogAux."ID Proceso" in [lrLogAux."ID Proceso"::Registrar, lrLogAux."ID Proceso"::"Nueva Venta"] then
//                 exit(false);

//         until lrLogAux.Next = 0;


//         //... Si hemos llegado hasta aquí es porque se está usando el cupón desde otro punto de venta en este mismo momento.
//         exit(true);
//     end;
// }

