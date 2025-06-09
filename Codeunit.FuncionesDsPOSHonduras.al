// codeunit 76025 "Funciones DsPOS - Honduras"
// {

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
//     end;


//     procedure Comprobaciones_Iniciales(p_Tienda: Code[20]; p_IdTPV: Code[20])
//     var
//         rConfTPV: Record "Configuracion TPV";
//         recTienda: Record Tiendas;
//     begin

//         rConfTPV.Get(p_Tienda, p_IdTPV);
//         recTienda.Get(p_Tienda);

//         rConfTPV.TestField("NCF Credito fiscal");

//         if recTienda."Permite Anulaciones en POS" then
//             rConfTPV.TestField("NCF Credito fiscal NCR");
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
//         rClientesTPV: Record "_Clientes TPV";
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
//         //fes mig
//         /*
//         i:= 1;
//         WHILE i <= (p_Evento.TextoPais.Length-1) DO BEGIN
//           TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//           IF ISNULL(TextoNet[i]) THEN
//             TextoNet[i] := '';
//           i += 1;
//         END;

//         rConfTPV.GET(p_Evento.TextoDato,p_Evento.TextoDato2);

//         WITH p_SalesH DO BEGIN

//           Cust.GET("Sell-to Customer No.");
//           IF Cust."Customer Posting Group" = '' THEN
//             EXIT(STRSUBSTNO('%1',Error001,"Sell-to Customer No."));

//           IF NOT CustPostGroup.GET(Cust."Customer Posting Group") THEN
//             EXIT(STRSUBSTNO('%1',Error002,Cust."Customer Posting Group"));

//           IF NOT(Devolucion) THEN BEGIN

//             // Guardamos la Cédula Para Fututos Casos
//             IF rClientesTPV.GET(TextoNet[1].ToString()) THEN
//               rClientesTPV.DELETE;

//             rClientesTPV.INIT;
//             rClientesTPV.Identificacion     := TextoNet[1].ToString();
//             rClientesTPV.Direccion          := TextoNet[2].ToString();
//             rClientesTPV.Nombre             := TextoNet[3].ToString();
//             rClientesTPV.Telefono           := TextoNet[4].ToString();
//             rClientesTPV.INSERT(FALSE);

//             "VAT Registration No."   := rClientesTPV.Identificacion;
//             "Bill-to Name"           := rClientesTPV.Nombre;
//             "Bill-to Address"        := rClientesTPV.Direccion;
//             "Sell-to Customer Name"  := rClientesTPV.Nombre;
//             "Sell-to Address"        := rClientesTPV.Direccion;
//             "No. Telefono"            := rClientesTPV.Telefono;
//             "External Document No."  := "No.";
//             "No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal";

//             ActualizaCupon(p_SalesH);

//             IF ("No. Fiscal TPV" = '') THEN BEGIN

//               NoSeriesLine.RESET;
//               NoSeriesLine.SETRANGE("Series Code"   , "No. Serie NCF Facturas");
//               NoSeriesLine.SETRANGE("Starting Date" , 0D ,WORKDATE);
//               NoSeriesLine.SETRANGE(Open,TRUE);

//               IF NOT NoSeriesLine.FINDLAST THEN
//                 EXIT(Error004);

//               "No. Autorizacion (CAI)"      := NoSeriesLine."No. Autorizacion (CAI)";
//               "Tipo Comprobante"            := NoSeriesLine."Tipo Comprobante";
//               "Establecimiento Factura"     := NoSeriesLine.Establecimiento;
//               "Punto de Emision Factura"    := NoSeriesLine."Punto de Emision";
//               "Fecha Caducidad Comprobante" := NoSeriesLine."Fecha Caducidad";
//               "No. Comprobante Fiscal"      := NoSeriesMgt.GetNextNo("No. Serie NCF Facturas" , "Posting Date" , TRUE);
//               "No. Fiscal TPV"               := "No. Comprobante Fiscal";

//             END;

//           END
//           ELSE BEGIN  // DEVOLUCIONES

//             "No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//             NoSeriesLine.RESET;
//             NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//             NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//             NoSeriesLine.SETRANGE(Open               , TRUE);

//             IF NOT NoSeriesLine.FINDLAST THEN
//               EXIT(Error004);

//             IF cfComunes.RegistroEnLinea(Tienda) THEN BEGIN

//               rHistCab.GET("Anula a Documento");

//               "No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";

//               RetrocedeCupon("Anula a Documento",TRUE,p_SalesH."No.");

//             END
//             ELSE BEGIN

//               rCab.SETCURRENTKEY("Posting No.");
//               rCab.SETRANGE     ("Posting No." , "Anula a Documento");
//               rCab.FINDFIRST;

//               "No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";

//               RetrocedeCupon("Anula a Documento",FALSE,p_SalesH."No.");

//             END;

//             "No. Comprobante Fiscal"      := NoSeriesMgt.GetNextNo("No. Serie NCF Abonos" , "Posting Date" , TRUE);
//             "No. Autorizacion (CAI)"      := NoSeriesLine."No. Autorizacion (CAI)";
//             "Tipo Comprobante"            := NoSeriesLine."Tipo Comprobante";
//             "Establecimiento Factura"     := NoSeriesLine.Establecimiento;
//             "Punto de Emision Factura"    := NoSeriesLine."Punto de Emision";
//             "Fecha Caducidad Comprobante" := NoSeriesLine."Fecha Caducidad";
//             "No. Fiscal TPV"               := "No. Comprobante Fiscal";

//           END;

//         END;
//         */
//         //fes mig

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

//         pSalesH."No. Serie NCF Abonos" := pSalesH."Posting No. Series";
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
//         //fes mig
//         /*
//         rConfTPV.GET(pSalesH.Tienda,pSalesH.TPV);

//         pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//         NoSeriesLine.RESET;
//         NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//         NoSeriesLine.SETRANGE(Open,TRUE);
//         IF NOT NoSeriesLine.FINDLAST THEN
//           EXIT(Error004);

//         pSalesH."No. Autorizacion (CAI)"      := NoSeriesLine."No. Autorizacion (CAI)";
//         pSalesH."Tipo Comprobante"            := NoSeriesLine."Tipo Comprobante";
//         pSalesH."Establecimiento Factura"     := NoSeriesLine.Establecimiento;
//         pSalesH."Punto de Emision Factura"    := NoSeriesLine."Punto de Emision";
//         pSalesH."Fecha Caducidad Comprobante" := NoSeriesLine."Fecha Caducidad";

//         pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , pSalesH."Posting Date" , TRUE);
//         pSalesH."No. Fiscal TPV"          := pSalesH."No. Comprobante Fiscal";

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
//         */
//         //fes mig

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
//             "No. Comprobante Fiscal" := pSalesH."No. Comprobante Fiscal";
//         end;
//     end;


//     procedure Guardar_Datos_Aparcados(prmNumVenta: Code[20]; p_Evento: DotNet )
//     var
//         rPedidosAparcados: Record "_Pedidos Aparcados";
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
// }

