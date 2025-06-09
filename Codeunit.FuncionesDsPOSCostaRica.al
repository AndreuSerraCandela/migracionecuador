// codeunit 76017 "Funciones DsPOS - Costa Rica"
// {
//     // #184407, RRT, 10.04.2019: Despues de registrar un documento y antes de imprimirlo debe enviarse el documento electrónicamente.
//     // #217374, RRT, 29.08.2019: Revisiones para FE.
//     // #308268, RRT, 16.03.2020: Funcion para poder cambiar el tipo de documento a tiquete.

//     Permissions = TableData "Sales Invoice Header" = rm,
//                   TableData "Sales Cr.Memo Header" = rm;

//     trigger OnRun()
//     begin
//         //+#217374
//         //... El otro modo sería el que contemplara la firma electronica desde DS-POS.
//         case wModo of
//             wModo::FE:
//                 FE(rGblCabVenta);
//         end;
//     end;

//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rGblCabVenta: Record "Sales Header";
//         wNumLog: Integer;
//         wModo: Option ,FE;
//         wEvitarMensajeFE: Boolean;
//         ID_ACEPTADO: Label 'aceptado';
//         ID_RECHAZADO: Label 'rechazado';


//     procedure VaciaCampos_Pais()
//     var
//         rConfTPV: Record "Configuracion TPV";
//     begin
//     end;


//     procedure Comprobaciones_Iniciales(p_Tienda: Code[20]; p_IdTPV: Code[20])
//     var
//         rConfTPV: Record "Configuracion TPV";
//         recTienda: Record Tiendas;
//     begin

//         rConfTPV.Get(p_Tienda, p_IdTPV);
//         recTienda.Get(p_Tienda);

//         rConfTPV.TestField("No. serie Facturas");
//         rConfTPV.TestField("No. serie facturas Reg.");

//         if recTienda."Permite Anulaciones en POS" then begin
//             rConfTPV.TestField("No. serie notas credito");
//             rConfTPV.TestField("No. serie notas credito reg.");
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
//                     exit(NoSeriesManagement.TryGetNextNo(rTPV."No. serie facturas Reg.", p_SalesHeader."Posting Date"));
//                 "Document Type"::"Credit Memo":
//                     exit(NoSeriesManagement.TryGetNextNo(rTPV."No. serie notas credito reg.", p_SalesHeader."Posting Date"));
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
//         rClientesTPV: Record "Pedidos Aparcados";
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
//     begin

//         i := 1;
//         while i <= (p_Evento.TextoPais.Length - 1) do begin
//             TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//             if IsNull(TextoNet[i]) then
//                 TextoNet[i] := '';
//             i += 1;
//         end;

//         rConfTPV.Get(p_Evento.TextoDato, p_Evento.TextoDato2);

//         with p_SalesH do begin

//             Cust.Get("Sell-to Customer No.");
//             if Cust."Customer Posting Group" = '' then
//                 exit(StrSubstNo('%1', Error001, "Sell-to Customer No."));

//             if not CustPostGroup.Get(Cust."Customer Posting Group") then
//                 exit(StrSubstNo('%1', Error002, Cust."Customer Posting Group"));

//             //+#217374
//             if not cfComunes.RegistroEnLinea(Tienda) then
//                 DatosParaFE(p_SalesH);
//             //-#217374

//             if not (Devolucion) then begin

//                 // Guardamos la Cédula Para Fututos Casos
//                 if rClientesTPV.Get(TextoNet[1].ToString()) then
//                     rClientesTPV.Delete;

//                 rClientesTPV.Init;
//                 rClientesTPV."No." := TextoNet[1].ToString();
//                 rClientesTPV."Numero Colegio" := TextoNet[2].ToString();
//                 rClientesTPV."Numero Cliente" := TextoNet[3].ToString();
//                 rClientesTPV.Identificacion := TextoNet[4].ToString();
//                 rClientesTPV.Insert(false);

//                 "VAT Registration No." := rClientesTPV."No.";
//                 "Bill-to Name" := rClientesTPV."Numero Cliente";
//                 "Bill-to Address" := rClientesTPV."Numero Colegio";
//                 "Sell-to Customer Name" := rClientesTPV."Numero Cliente";
//                 "Sell-to Address" := rClientesTPV."Numero Colegio";
//                 "No. Telefono" := rClientesTPV.Identificacion;
//                 "External Document No." := "No.";


//                 ActualizaCupon(p_SalesH);

//                 if ("No. Fiscal TPV" = '') then
//                     "No. Fiscal TPV" := "Posting No.";


//             end
//             else begin  // DEVOLUCIONES

//                 if cfComunes.RegistroEnLinea(Tienda) then begin
//                     rHistCab.Get("Anula a Documento");
//                     RetrocedeCupon("Anula a Documento", true, p_SalesH."No.");
//                 end
//                 else begin
//                     rCab.SetCurrentKey("Posting No.");
//                     rCab.SetRange("Posting No.", "Anula a Documento");
//                     rCab.FindFirst;
//                     RetrocedeCupon("Anula a Documento", false, p_SalesH."No.");
//                 end;

//                 "No. Fiscal TPV" := "Posting No.";

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
//     begin

//         rConfTPV.Get(pSalesH.Tienda, pSalesH.TPV);

//         pSalesH."No. Fiscal TPV" := pSalesH."Posting No.";

//         if cfComunes.RegistroEnLinea(pSalesH.Tienda) then begin
//             rHistCab.Get(pSalesH."Anula a Documento");
//             pSalesH."Cod. Cupon" := rHistCab."Cod. Cupon";
//             RetrocedeCupon(pSalesH."Anula a Documento", true, pSalesH."No.");
//         end
//         else begin
//             rCab.SetCurrentKey("Posting No.");
//             rCab.SetRange("Posting No.", pSalesH."Anula a Documento");
//             rCab.FindFirst;
//             pSalesH."Cod. Cupon" := rCab."Cod. Cupon";
//             RetrocedeCupon(pSalesH."Anula a Documento", false, pSalesH."No.");

//             //+#217374
//             DatosParaFE(pSalesH);
//             //-#217374

//         end;
//     end;


//     procedure ActualizaCupon(pSalesH: Record "Sales Header")
//     var
//         CantidadPendiente: Integer;
//         rSalesLines: Record "Sales Line";
//     begin
//         //fes mig
//         /*
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
//                 END;
//             END;
//           UNTIL rSalesLines.NEXT = 0;
//         */
//         //fes mig

//     end;


//     procedure Ventas_Registrar_Localizado(var GenGnjLine: Record "Gen. Journal Line"; pSalesH: Record "Sales Header")
//     begin

//         with GenGnjLine do begin
//         end;
//     end;


//     procedure Guardar_Datos_Aparcados(prmNumVenta: Code[20]; p_Evento: DotNet )
//     var
//         rPedidosAparcados: Record "Clientes TPV";
//         TextoNet: array[10] of DotNet String;
//         i: Integer;
//     begin
//         //fes mig
//         /*
//         // Almacenamos los datos recibidos
//         i:= 1;
//         WHILE i <= (p_Evento.TextoPais.Length-1) DO BEGIN
//           TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//           IF ISNULL(TextoNet[i]) THEN
//             TextoNet[i] := '';
//           i += 1;
//         END;

//         // Si ya existen datos aparcados los borramos
//         IF rPedidosAparcados.GET(prmNumVenta) THEN
//           rPedidosAparcados.DELETE;


//         // Guardamos los datos en la tabla
//         rPedidosAparcados.INIT;
//         rPedidosAparcados.Identificacion                := prmNumVenta;
//         rPedidosAparcados.Nombre     := TextoNet[7].ToString();
//         rPedidosAparcados.Direccion     := TextoNet[8].ToString();
//         rPedidosAparcados."Nombre Colegio"     := TextoNet[9].ToString();
//         rPedidosAparcados."Tipo Documento"     := TextoNet[6].ToString();
//         rPedidosAparcados.Telefono       := TextoNet[1].ToString();
//         rPedidosAparcados."Tipo ID"               := TextoNet[3].ToString();
//         rPedidosAparcados.Direccion            := TextoNet[2].ToString();
//         rPedidosAparcados."E-Mail"             := TextoNet[5].ToString();
//         rPedidosAparcados.Telefono             := TextoNet[4].ToString();
//         rPedidosAparcados.INSERT(FALSE);
//         */
//         //fes mig

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
//         text001: Label 'Cupón %1 aplicado correctamente';
//         wCupon: Text;
//         Cupon: Code[20];
//     begin
//         //fes mig
//         /*
//         Cupon := p_Evento.TextoDato6;

//         IF rCabCupon.GET(Cupon) THEN BEGIN

//           IF (rCabCupon.Impreso) AND (WORKDATE >= rCabCupon."Valido Desde") AND (WORKDATE <= rCabCupon."Valido Hasta") AND
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


//     procedure AntesDeImprimir(pCodVenta: Code[20])
//     begin
//         //+#184407

//         //Factura ELectronica
//         //+#217374
//         //... La firma electronica se realizará en Central.
//         //lcFE_CR.TiqueteElectronica(pCodVenta);
//         //-#217374
//         //Factura ELectronica
//     end;


//     procedure FE(pSalesHeader: Record "Sales Header")
//     var
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//         lOk: Boolean;
//     begin
//         //fes mig
//         /*
//         //+#217374
//         CASE pSalesHeader."Document Type" OF
//           pSalesHeader."Document Type"::Invoice:
//             BEGIN
//               IF lrSIH.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//                 IF lrSIH."Tipo Doc Electronico" = lrSIH."Tipo Doc Electronico"::"0" THEN BEGIN
//                   lrSIH."Tipo Doc Electronico" := lrSIH."Tipo Doc Electronico"::"1";
//                   lrSIH.MODIFY;
//                 END;

//                 lOk := FALSE;
//                 IF lrLog.GET(3,lrSIH."No.") THEN BEGIN
//                   IF (lrLog.Estado = '') OR (lrLog.Estado = 'procesando') THEN BEGIN
//                     lcFE.Parametros(TRUE,lrSIH.Tienda);
//                     lcFE.ComprobarDocumentoElectronicoLOG(lrLog);
//                     lOk := TRUE;
//                   END;
//                 END;
//                 IF NOT lOk THEN
//                   lcFE.TiqueteElectronico_vCentral(lrSIH."No.");
//               END;
//             END;

//           pSalesHeader."Document Type"::"Credit Memo":
//             BEGIN
//               IF lrSCMH.GET(pSalesHeader."Last Posting No.") THEN
//                 //... Estos datos puede ser que no se hayan grabado en la tienda. Lo hacemos ahora, antes de la firma.
//                 IF lrSCMH."No. Doc Historico" = '' THEN BEGIN
//                   lrSIH.GET(lrSCMH."Anula a Documento");
//                   lrSCMH."No. Doc Historico"    := lrSIH."No.";
//                   lrSCMH."Numero Referencia FE" := lrSIH.Consecutivo;
//                   //... Para la siguiente asignacion no comprobamos que la factura sea tiquete o factura. Debe ser siempre tiquete.
//                   lrSCMH."Tipo Doc. Ref NC"     := lrSCMH."Tipo Doc. Ref NC"::"2";
//                   IF lrSCMH.Devolucion THEN
//                     lrSCMH."Codigo Referencia" := lrSCMH."Codigo Referencia"::"2"
//                   ELSE
//                     lrSCMH."Codigo Referencia" := lrSCMH."Codigo Referencia"::"1";
//                   lrSCMH.MODIFY;

//                 END;
//                 lOk := FALSE;
//                 IF lrLog.GET(1,lrSCMH."No.") THEN BEGIN
//                   IF (lrLog.Estado = '') OR (lrLog.Estado = 'procesando') THEN BEGIN
//                     lcFE.Parametros(TRUE,lrSCMH.Tienda);
//                     lcFE.ComprobarDocumentoElectronicoLOG(lrLog);
//                     lOk := TRUE;
//                   END;
//                 END;
//                 IF NOT lOk THEN
//                   lcFE.TiqueteElectronicoNCR_vCentral(lrSCMH."No.");
//             END;
//         END;
//         */
//         //fes mig

//     end;


//     procedure FinalProcesoRegistro(pNumLog: Integer)
//     begin
//         //+#217374
//         //... Los que hayan quedado pendientes de firma, se intentarán firmar.
//         wNumLog := pNumLog;
//         FirmarRegistrados;
//     end;


//     procedure Parametros_2(rp_CabVenta: Record "Sales Header"; pNumLog: Integer; pEvitarMensajeFE: Boolean)
//     begin
//         //+#217374
//         rGblCabVenta := rp_CabVenta;
//         wNumLog := pNumLog;
//         wModo := wModo::FE;
//         wEvitarMensajeFE := pEvitarMensajeFE;
//     end;


//     procedure LogFirmaEnCentral(pSalesHeader: Record "Sales Header"; pError: Text[1024])
//     var
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//         lEstado: Integer;
//         lcLote: Codeunit "Registrar Ventas en Lote DsPOS";
//         TextL001: Label 'Obtención certificado digital sin error para %1';
//         TextL002: Label 'Error: %1';
//         TextL003: Label 'No se configuió firmar %1';
//         TextL004: Label 'Pendiente de comprobar la firma para %1';
//     begin
//         //fes mig
//         /*
//         //+#217374
//         //... Registramos el LOG de la firma.
//         //...

//         lcLote.Parametros(wNumLog);
//         lEstado := -1;

//         IF pError = '' THEN BEGIN
//           lEstado := 0;
//           CASE pSalesHeader."Document Type" OF
//             pSalesHeader."Document Type"::Invoice:
//               IF lrSIH.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//                 IF UPPERCASE(lrSIH.Estado) = UPPERCASE(ID_ACEPTADO) THEN
//                   lEstado := 1;

//                 IF UPPERCASE(lrSIH.Estado) = '' THEN
//                   lEstado := 2;
//               END;

//             pSalesHeader."Document Type"::"Credit Memo":
//               IF lrSCMH.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//                 IF UPPERCASE(lrSCMH.Estado) = UPPERCASE(ID_ACEPTADO) THEN
//                   lEstado := 1;

//                 IF UPPERCASE(lrSCMH.Estado) = '' THEN
//                   lEstado := 2;
//               END;

//           END;
//         END;

//         CASE lEstado OF
//          -1: lcLote.InsertarDetalle(pSalesHeader,2,TRUE,STRSUBSTNO(TextL002,pError));
//           0: lcLote.InsertarDetalle(pSalesHeader,2,TRUE,STRSUBSTNO(TextL003,pSalesHeader."No. Fiscal TPV"));
//           1: lcLote.InsertarDetalle(pSalesHeader,2,FALSE,STRSUBSTNO(TextL001,pSalesHeader."No. Fiscal TPV"));
//           2: lcLote.InsertarDetalle(pSalesHeader,2,TRUE,STRSUBSTNO(TextL004,pSalesHeader."No. Fiscal TPV"));
//         END;
//         */
//         //fes mig

//     end;


//     procedure FirmarRegistrados()
//     var
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//         lProcesados: Integer;
//         lTotal: Integer;
//         cduPOS: Codeunit "Funciones DsPOS - Comunes";
//         TextL001: Label '<Firmando documentos DsPOS :\\Facturas @@@@@@@@@@@@@@@@@@@@1\Notas de crédito  @@@@@@@@@@@@@@@@@@@@2>';
//         rParametros: Record "Param. CDU DsPOS";
//         lrSalesH: Record "Sales Header";
//         lwProgreso: Dialog;
//         lcCostaRica: Codeunit "Funciones DsPOS - Costa Rica";
//         lFechaReferencia: Date;
//     begin
//         //fes mig
//         /*
//         //#217374

//         lFechaReferencia := TODAY;

//         IF GUIALLOWED THEN
//           lwProgreso.OPEN(TextL001);

//         SLEEP(3000);  //Intentar que de tiempo a comprobar.

//         lrSIH.RESET;
//         lrSIH.SETCURRENTKEY("Venta TPV","Posting Date",Estado);
//         lrSIH.SETRANGE("Venta TPV",TRUE);
//         lrSIH.SETRANGE("Posting Date", lFechaReferencia -31 , lFechaReferencia);
//         lrSIH.SETFILTER(Estado,'<>%1&<>%2',ID_ACEPTADO,ID_RECHAZADO);

//         IF lrSIH.FINDFIRST THEN BEGIN

//           lTotal      := lrSIH.COUNT;
//           lProcesados := 0;

//           REPEAT

//             CLEARLASTERROR;

//             lrSalesH.INIT;
//             lrSalesH."No."              := lrSIH."External Document No.";
//             lrSalesH."Document Type"    := lrSalesH."Document Type"::Invoice;
//             lrSalesH."No. Fiscal TPV"    := lrSIH. "No. Fiscal TPV";
//             lrSalesH."Posting Date"     := lrSIH."Posting Date";
//             lrSalesH.Tienda             := lrSIH.Tienda;
//             lrSalesH.TPV                := lrSIH.TPV;
//             lrSalesH."Posting No."      := lrSIH."No.";
//             lrSalesH."Last Posting No." := lrSIH."No.";

//             COMMIT;

//             //... Para poder ejecutar el RUN, lo haremos sobre otra instancia de la CU.
//             lcCostaRica.Parametros_2(lrSalesH,wNumLog,TRUE);
//             IF lcCostaRica.RUN THEN
//               lcCostaRica.LogFirmaEnCentral(lrSalesH,'')
//             ELSE
//               lcCostaRica.LogFirmaEnCentral(lrSalesH,COPYSTR(GETLASTERRORTEXT,1,1024));

//             IF GUIALLOWED THEN BEGIN
//               lProcesados += 1;
//               lwProgreso.UPDATE(1, ROUND(lProcesados/lTotal*10000,1));
//             END;

//           UNTIL lrSIH.NEXT = 0;

//         END;

//         SLEEP(3000);

//         lrSCMH.RESET;
//         lrSCMH.SETCURRENTKEY("Venta TPV","Posting Date",Estado);
//         lrSCMH.SETRANGE("Venta TPV", TRUE);
//         lrSCMH.SETRANGE("Posting Date",lFechaReferencia -31 , lFechaReferencia);
//         lrSCMH.SETFILTER(Estado,'<>%1&<>%2',ID_ACEPTADO,ID_RECHAZADO);

//         IF lrSCMH.FINDFIRST THEN BEGIN

//           lTotal      := lrSCMH.COUNT;
//           lProcesados := 0;

//           REPEAT

//             CLEARLASTERROR;

//             lrSalesH.INIT;
//             lrSalesH."No."              := lrSCMH."External Document No.";
//             lrSalesH."Document Type"    := lrSalesH."Document Type"::"Credit Memo";
//             lrSalesH."No. Fiscal TPV"    := lrSCMH."No. Fiscal TPV";
//             lrSalesH."Posting Date"     := lrSCMH."Posting Date";
//             lrSalesH.Tienda             := lrSCMH.Tienda;
//             lrSalesH.TPV                := lrSCMH.TPV;
//             lrSalesH."Posting No."      := lrSCMH."No.";
//             lrSalesH."Last Posting No." := lrSCMH."No.";

//             COMMIT;

//             //... Para poder ejecutar el RUN, lo haremos sobre otra instancia de la CU.
//             lcCostaRica.Parametros_2(lrSalesH,wNumLog,TRUE);
//             IF lcCostaRica.RUN THEN
//               lcCostaRica.LogFirmaEnCentral(lrSalesH,'')
//             ELSE
//               lcCostaRica.LogFirmaEnCentral(lrSalesH,COPYSTR(GETLASTERRORTEXT,1,1024));

//             IF GUIALLOWED THEN BEGIN
//               lProcesados += 1;
//               lwProgreso.UPDATE(2, ROUND(lProcesados/lTotal*10000,1));
//             END;

//           UNTIL lrSCMH.NEXT = 0;

//         END;

//         IF GUIALLOWED THEN
//           lwProgreso.CLOSE;
//         */
//         //fes mig

//     end;


//     procedure DatosParaFE(var lrSalesH: Record "Sales Header")
//     var
//         lClave: Text[60];
//         lConsecutivo: Text[20];
//         lTipo: Code[2];
//     begin
//         //fes mig
//         /*
//         //+#217374
//         lTipo := '04';
//         IF lrSalesH."Document Type" = lrSalesH."Document Type"::"Credit Memo" THEN
//           lTipo := '03';
//         lcFE.Parametros(TRUE,lrSalesH.Tienda);
//         lClave := lcFE.GetClave(lrSalesH."Posting Date",lConsecutivo,lTipo);
//         lrSalesH.Clave := lClave;
//         lrSalesH.Consecutivo := lConsecutivo;

//         lrLog.INIT;
//         IF lTipo = '04' THEN
//           lrLog."Tipo Documento" := lrLog."Tipo Documento"::"3"
//         ELSE
//           lrLog."Tipo Documento":= lrLog."Tipo Documento"::"1";
//         lrLog.NoDocumento       := lrSalesH."Posting No.";
//         lrLog."Clave Doc"       := lClave;
//         lrLog."Consecutivo Doc" := lConsecutivo;
//         lrLog."Fecha Doc"       := CURRENTDATETIME;
//         lrLog.Estado            := '';
//         lrLog."Estado Interfaz" := lrLog."Estado Interfaz"::"1";
//         lrLog.INSERT(TRUE);
//         */
//         //fes mig

//     end;


//     procedure CambiarTipoDocumentoATiquete(pDocumento: Code[20])
//     var
//         lrSIH: Record "Sales Invoice Header";
//     begin
//         //fes mig
//         /*
//         //+#308268
//         IF lrSIH.GET(pDocumento) THEN BEGIN
//           IF lrSIH."Tipo Doc Electronico" = lrSIH."Tipo Doc Electronico"::"0" THEN BEGIN
//             lrSIH."Tipo Doc Electronico" := lrSIH."Tipo Doc Electronico"::"1";
//             lrSIH.MODIFY;
//           END;
//         END;
//         //-#308268
//         */
//         //fes mig

//     end;
// }

