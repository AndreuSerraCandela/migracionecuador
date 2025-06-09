// codeunit 76021 "Funciones DsPOS - Guat. Educa"
// {
//     // #76946, RRT, 21.09.2017: Implementacion FE en puntos de venta GT.
//     //         Las tiendas trabajan todas offline. Si se quisiera hacer registro en linea, habría que hacer un pequeño cambio.
//     //         En la función Factura y NotaCR() de la codeunit 50006 - "Factura Electronica NAV", habría que determinar si el tipo de generación es electrónico.
//     //         Habría que confirmarlo antes. De la misma forma, tambien conviene no se ejecuten los MESSAGES. En su lugar habría que devolver un ERROR(). Esto lo
//     //         podemos conseguir fácilmente con un nuevo parámetro.
//     // 
//     // #76946, RRT, 22.01.2018: Creación de las funciones FinalProcesoRegistro() y RevisarDatosFE_Pendientes()
//     // #116527 RRT, 25.01.2018: Incluir opcion para seleccionar facturas resguardo en TPV
//     // #126073 RRT, 12.03.2018: Mejoras.
//     // #126073 RRT, 23.04.2018: Que al ejecutar la función FE(), si ha habido error se notifique.
//     // #187632 RRT 18.12.2018: Si un documento no ha enviado electronicamente, no puede imprimirse tampoco según el formato electrónico.
//     // 
//     // #232158 RRT, 18.11.2019: Se ha recuperado la versión anterior de la codeunit 76022 para poder utilizarla en EDUCA.
//     //         La razón es que en <ACTIVA EDUCA>, debe seguir utilizandose la versión anterior de FE.

//     Permissions = TableData "Sales Invoice Header" = rimd,
//                   TableData "Sales Cr.Memo Header" = rimd,
//                   TableData TableData50009 = rimd,
//                   TableData TableData51000 = rimd,
//                   TableData TableData51002 = rimd;

//     trigger OnRun()
//     begin
//         //#126073 - 23.04.2018
//         //... Se añade el modo FE.

//         case wModo of
//             wModo::" ":
//                 //+76946
//                 //... Se realiza esta llamada desde POS.
//                 if rGblCabVenta."No." <> '' then
//                     FE_Pos(rGblCabVenta, wRegistroEnLinea);

//             wModo::FE:
//                 FE(rGblCabVenta);
//         end;
//     end;

//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         Text003: Label 'The digital stamp was not generated correctly. Go to the registered invoice and try to generate it.';
//         txt0001: Label 'There was a communication error';
//         Error001: Label 'This Invoice has no digital seal';
//         txt002: Label 'Folio successfully Voided';
//         txt004: Label 'The Folio is not properly voided. Go to the XML file and check';
//         txt005: Label 'No se encuentra la factura de venta relacionada (no. comprobante fiscal "%1"). ¿Quiere introducir la fecha de la factura de venta relacionada (necesario para continuar el proceso)?';
//         Error002: Label 'El proceso requiere que se indique la fecha de la factura de venta relacionada (no. comprobante fiscal "%1"). Proceso detenido por el usuario.';
//         Error003: Label 'La fecha introducida (%1) no puede ser mayor que la nota de crédito (%2).';
//         Error004: Label 'La fecha introducida (%1) es demasiado antigua.';
//         rGblCabVenta: Record "Sales Header";
//         wRegistroEnLinea: Boolean;
//         wSeriesNCF: Option Calculo,Habituales,Resguardo;
//         wModo: Option " ",FE;
//         wNumLog: Integer;
//         wEvitarMensajeFE: Boolean;


//     procedure VaciaCampos_Pais()
//     var
//         rConfTPV: Record "Configuracion TPV";
//     begin

//         rConfTPV.ModifyAll("NCF Consumidor final", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal", '');
//         rConfTPV.ModifyAll("NCF Regimenes especiales", '');
//         rConfTPV.ModifyAll("NCF Gubernamentales", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal NCR", '');

//         //+#116527
//         rConfTPV.ModifyAll("NCF Credito fiscal resguardo", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal NCR resg.", '');

//         rConfTPV.ModifyAll("NCF Credito fiscal habitual", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal NCR habit.", '');
//         //+#116527
//     end;


//     procedure Comprobaciones_Iniciales(p_Tienda: Code[20]; p_IdTPV: Code[20])
//     var
//         rConfTPV: Record "Configuracion TPV";
//         recTienda: Record Tiendas;
//         lrConfigEmpresa: Record "Config. Empresa";
//     begin

//         //+#116527
//         GestionSeriesNCF_TPV(p_Tienda, p_IdTPV);
//         //-#116527

//         recTienda.Get(p_Tienda);

//         rConfTPV.Get(p_Tienda, p_IdTPV);
//         rConfTPV.TestField("NCF Credito fiscal");

//         if recTienda."Permite Anulaciones en POS" then
//             rConfTPV.TestField("NCF Credito fiscal NCR");

//         //+#116527
//         if TestSeriesResguardo(p_Tienda, p_IdTPV) then begin
//             rConfTPV.TestField("NCF Credito fiscal resguardo");
//             if recTienda."Permite Anulaciones en POS" then
//                 rConfTPV.TestField("NCF Credito fiscal NCR resg.");
//         end
//         else begin
//             rConfTPV.TestField("NCF Credito fiscal habitual");
//             if recTienda."Permite Anulaciones en POS" then
//                 rConfTPV.TestField("NCF Credito fiscal NCR habit.");
//         end;
//         //-#116527
//     end;


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; var p_SalesHeader: Record "Sales Header"): Code[20]
//     var
//         rTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         lSerie: Code[20];
//     begin

//         with p_SalesHeader do begin

//             rTPV.Reset;
//             rTPV.Get(p_Tienda, p_IdTPV);

//             Commit;

//             case "Document Type" of
//                 "Document Type"::Invoice:
//                     begin
//                         //+#116527
//                         //EXIT(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal", p_SalesHeader."Posting Date"));
//                         lSerie := cfComunes.ObtenerSerieFiscal(rTPV, 0);
//                         exit(NoSeriesManagement.TryGetNextNo(lSerie, p_SalesHeader."Posting Date"));
//                         //-#116527
//                     end;

//                 "Document Type"::"Credit Memo":
//                     begin
//                         //+#116527
//                         //EXIT(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal NCR", p_SalesHeader."Posting Date"));
//                         lSerie := cfComunes.ObtenerSerieFiscal(rTPV, 1);
//                         exit(NoSeriesManagement.TryGetNextNo(lSerie, p_SalesHeader."Posting Date"));
//                         //-#116527
//                     end;
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
//                 //+#116527
//                 //"No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal";
//                 "No. Serie NCF Facturas" := cfComunes.ObtenerSerieFiscal(rConfTPV, 0);
//                 //-#116527

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

//                 //+#116527
//                 //"No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//                 "No. Serie NCF Abonos" := cfComunes.ObtenerSerieFiscal(rConfTPV, 1);
//                 //-#116527

//                 NoSeriesLine.Reset;

//                 //+#116527
//                 //NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//                 NoSeriesLine.SetRange("Series Code", "No. Serie NCF Abonos");
//                 //-#116527

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

//         if cfComunes.RegistroEnLinea(codPrmTienda) then
//             exit(true)
//         else
//             exit(true)
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
//         lSerieAbonos: Code[20];
//     begin

//         rConfTPV.Get(pSalesH.Tienda, pSalesH.TPV);

//         //+#116527
//         lSerieAbonos := cfComunes.ObtenerSerieFiscal(rConfTPV, 1);
//         //-#116527

//         //+#116527
//         //pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//         pSalesH."No. Serie NCF Abonos" := lSerieAbonos;
//         //-#116527

//         NoSeriesLine.Reset;

//         //+#116527
//         //NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SetRange("Series Code", lSerieAbonos);
//         //-#116527

//         NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//         NoSeriesLine.SetRange(Open, true);
//         if not NoSeriesLine.FindLast then
//             exit(Error004);

//         //+#116527
//         //pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , pSalesH."Posting Date" , TRUE);
//         pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(lSerieAbonos, pSalesH."Posting Date", true);
//         //-#116527

//         pSalesH."No. Fiscal TPV" := pSalesH."No. Comprobante Fiscal";

//         if cfComunes.RegistroEnLinea(pSalesH.Tienda) then begin
//             rHistCab.Get(pSalesH."Anula a Documento");
//             pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//             pSalesH."Cod. Cupon" := rHistCab."Cod. Cupon";
//             RetrocedeCupon(pSalesH."Anula a Documento", true, pSalesH."No.");
//         end
//         else begin
//             rCab.SetCurrentKey("Posting No.");
//             rCab.SetRange("Posting No.", pSalesH."Anula a Documento");
//             rCab.FindFirst;
//             pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//             pSalesH."Cod. Cupon" := rCab."Cod. Cupon";
//             RetrocedeCupon(pSalesH."Anula a Documento", false, pSalesH."No.");
//         end;
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
//         rSalesHeader: Record "Sales Header";
//     begin

//         // Almacenamos los datos recibidos
//         i := 1;
//         while i <= (p_Evento.TextoPais.Length - 1) do begin
//             TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//             if IsNull(TextoNet[i]) then
//                 TextoNet[i] := '';
//             i += 1;
//         end;

//         rSalesHeader.Reset;
//         rSalesHeader.Get(rSalesHeader."Document Type"::Invoice, prmNumVenta);


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


//     procedure FE(pSalesHeader: Record "Sales Header")
//     var
//         "**012**": Integer;
//         txtResp: array[7] of Text[1024];
//         rSIH: Record "Sales Invoice Header";
//         NoFactReg: Code[20];
//         rSCMH: Record "Sales Cr.Memo Header";
//     begin
//         //fes mig
//         /*
//         IF (pSalesHeader."Document Type" = pSalesHeader."Document Type"::Order) OR
//            (pSalesHeader."Document Type" = pSalesHeader."Document Type"::Invoice) THEN
//           BEGIN
//             IF rSIH.GET(pSalesHeader."Last Posting No.") THEN
//               //+76946
//               //... Se descartan las facturas que vienen del POS enc caso de haber generado ya el certificado digital.
//               IF (NOT rSIH."Venta TPV") OR (TestFaltaGenerarCertificado(0,pSalesHeader."No.",rSIH."No.",rSIH."Venta TPV")) THEN BEGIN
//                 //+#126073
//                 //... Sólo si el documento es de serie electrónica, no deben notificarse las anomalías.
//                 //... Tampoco se notificarán si estamos ejecutando el proceso de firmas por lotes, después del proceso de registro.
//                 IF wEvitarMensajeFE OR
//                    TestSerieDocElectronico(rSIH."No. Serie NCF Facturas",rSIH."No. Comprobante Fiscal") THEN
//                 //-#126073
//                   cuFE.EvitarNotificacionErrorFirma;
//               //-76946
//                 cuFE.Factura(rSIH);
//               END;
//           END;

//         IF ((pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo") OR
//           (pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Return Order")) AND
//             (NOT pSalesHeader.Correction) THEN
//           BEGIN
//             IF rSCMH.GET(pSalesHeader."Last Posting No.") THEN
//               //+76946
//               //... Se descartan las facturas que vienen del POS enc caso de haber generado ya el certificado digital.
//               IF (NOT rSCMH."Venta TPV") OR (TestFaltaGenerarCertificado(1,pSalesHeader."No.",rSCMH."No.",rSCMH."Venta TPV")) THEN BEGIN
//                 //+#126073
//                 //... Sólo si el documento es de serie electrónica, no deben notificarse las anomalías.
//                 IF wEvitarMensajeFE OR
//                    TestSerieDocElectronico(rSCMH."No. Serie NCF Abonos",rSCMH."No. Comprobante Fiscal") THEN
//                 //-#126073
//                   cuFE.EvitarNotificacionErrorFirma;
//               //-76946
//                 cuFE.NotaCR(rSCMH);
//               END;
//           END;
//         */
//         //fes mig

//     end;


//     procedure Linea_LocalizadaOFF(var prOrigen: Record "Sales Line"; var prDestino: Record "Sales Line")
//     begin

//         prDestino."Cod. Cupon" := prOrigen."Cod. Cupon";
//     end;


//     procedure ExcepcionIva(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     begin
//     end;


//     procedure FE_Pos(pSalesHeader: Record "Sales Header"; pRegistroEnLinea: Boolean): Boolean
//     var
//         rSIH: Record "Sales Invoice Header";
//         rSCMH: Record "Sales Cr.Memo Header";
//         lResult: Boolean;
//     begin
//         //fes mig
//         /*
//         //+76946
//         //... Desde esta función se decidirá la función más adecuada.
//         IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::Invoice THEN BEGIN
//           IF pRegistroEnLinea THEN BEGIN
//             IF pSalesHeader."Last Posting No." <> '' THEN
//               IF rSIH.GET(pSalesHeader."Last Posting No.") THEN
//                 cuFE.Factura(rSIH)
//           END
//           ELSE BEGIN
//             Factura_DSPos(pSalesHeader);
//           END;
//         END;

//         IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo" THEN BEGIN
//           IF pRegistroEnLinea THEN BEGIN
//             IF pSalesHeader."Last Posting No." <> '' THEN
//               IF rSCMH.GET(pSalesHeader."Last Posting No.") THEN
//                 cuFE.NotaCR(rSCMH)
//           END
//           ELSE BEGIN
//             NotaCR_DSPos(pSalesHeader);
//           END;
//         END;
//         */
//         //fes mig

//     end;


//     procedure Factura_DSPos(rSIH: Record "Sales Header")
//     var
//         FileSystem: Automation;
//         Ano: Integer;
//         Mes: Integer;
//         Dia: Integer;
//         Folder: Text[1024];
//         Nombre: Text[30];
//         RespuestaTxt: array[10] of Text;
//         StringXML: BigText;
//         Url: Text;
//         rSIL: Record "Sales Line";
//         DtoLin: Decimal;
//         DtoFact: Decimal;
//         I: Integer;
//         I1: Integer;
//         DtoLinTotal: Decimal;
//         DtoFactTotal: Decimal;
//         Exento: Decimal;
//         LinEnvio: array[50] of Text[1024];
//         rCodAlmacen: Record Location;
//         rConfSant: Record "Config. Empresa";
//         rGLS: Record "General Ledger Setup";
//         Moneda: Code[20];
//         Tasa: Decimal;
//         txtTasa: Text[30];
//         ValorDescLin: Decimal;
//         TotalDescuentos: Decimal;
//         txtCant: Text[30];
//         txtPrecio: Text[30];
//         txtImp: Text[30];
//         Descripcion: Text;
//         txtDtoFact: Text[30];
//         txtValorNeto: Text[30];
//         txtIVA: Text[30];
//         txtTotal: Text[30];
//         TotalAmount: Decimal;
//         Check: Report "Check Translation Management";
//         OutTxt: array[2] of Text[80];
//         TotalAmountTxt: Text;
//         rVatEntry: Record "VAT Entry";
//         txtExento: Text[30];
//         ParteNumerica: Code[20];
//         ParteSerie: Code[20];
//         Encontrado: Boolean;
//         Serie: Code[10];
//         rNoSeriesLine: Record "No. Series Line";
//         lrNoSeriesLineAux: Record "No. Series Line";
//         NoFact: Code[20];
//         TG: Code[1];
//         k: Integer;
//         NoFactRel: Text[30];
//         SerieRel: Text[30];
//         Concepto: Text[30];
//         NombreComprador: Text[100];
//         Vendedores: Record "Salesperson/Purchaser";
//         TotalEjemplares: Integer;
//         PrecioN: Decimal;
//         txtPrecioConDes: Text[30];
//         txtImpDes: Text[30];
//         txtDes: Text[30];
//         txtImpSinDesc: Text[30];
//         Total: Decimal;
//         NombreVendedor: Text[100];
//         lSalir: Boolean;
//     begin
//         //fes mig
//         /*
//         //#76946
//         //... Esta funcion es una copia de la funcion Factura() de la codeunit 50006
//         //... rSIH Y rSIL, apuntan en esta función a las tablas 36 y 37.
//         //... Para que sea mas facil de actualizar y de mantener he optado por no cambiar el nombre.

//         //#76946, cambios posteriores en la funcion base se destacan como #76946b

//         //#76946b
//         lSalir := FALSE;
//         lrNoSeriesLineAux.RESET;
//         lrNoSeriesLineAux.SETRANGE("Series Code",rSIH."No. Serie NCF Facturas");
//         lrNoSeriesLineAux.SETFILTER("Starting No.",'<=%1',rSIH."No. Comprobante Fiscal");
//         lrNoSeriesLineAux.SETFILTER("Ending No.",'>=%1',rSIH."No. Comprobante Fiscal");
//         lrNoSeriesLineAux.FINDFIRST;

//         IF lrNoSeriesLineAux."Tipo Generacion" <> lrNoSeriesLineAux."Tipo Generacion"::"1" THEN
//           lSalir := TRUE;

//         IF NOT lrLog.GET(lrLog."Tipo documento"::"2",rSIH."No.") THEN BEGIN
//           lrLog.INIT;
//           lrLog."Tipo documento"  := lrLog."Tipo documento"::"2";
//           lrLog."Nº documento"    := rSIH."No.";
//           lrLog."Fecha registro"  := rSIH."Posting Date";

//           lrLog."Tipo generación" := lrNoSeriesLineAux."Tipo Generacion";

//           //... Sólo dejamos en estado pendiente, los de serie electrónica.
//           IF lrNoSeriesLineAux."Tipo Generacion" = lrNoSeriesLineAux."Tipo Generacion"::"1" THEN
//             lrLog.Estado:= lrLog.Estado::"1";

//           lrLog.INSERT(TRUE);
//           COMMIT;
//         END;

//         IF lSalir THEN
//           EXIT;
//         //#76946b

//         DtoLin := 0;
//         DtoFact := 0;
//         I := 0;
//         I1 := 0;
//         DtoLinTotal := 0;
//         DtoFactTotal := 0;
//         Exento := 0;
//         NombreComprador:='';
//         TotalEjemplares:=0;

//         //+#76946b
//         //Url :='https://www.ifacere.com/lineapruebas/sso_wsefactura.asmx/RegistraFacturaXML';
//         rConfSant.GET;
//         Url := rConfSant."URL Factura Cambiaria Electr";
//         //--#76946b

//         CLEAR(LinEnvio);

//         rCodAlmacen.GET(rSIH."Location Code");
//         rCodAlmacen.TESTFIELD("Cod. Sucursal");

//         rConfSant.GET;
//         rConfSant.TESTFIELD("Ubicacion XML Respuesta");

//         rSIH.CALCFIELDS(Amount);
//         rSIH.CALCFIELDS("Amount Including VAT");

//         //Divisa
//         IF rSIH."Currency Code" = '' THEN
//           BEGIN
//             rGLS.GET;
//             Moneda := UPPERCASE(rGLS."LCY Code");
//             Tasa := 1;
//             txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
//           END
//         ELSE
//           BEGIN
//             Moneda := UPPERCASE(rSIH."Currency Code");
//             Tasa := (rSIH."Amount Including VAT"/rSIH."Currency Factor");
//             Tasa := (Tasa/rSIH."Amount Including VAT");
//             txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
//           END;
//         //Fin Divisa

//         //Descuentos
//         rSIL.RESET;
//         rSIL.SETRANGE("Document No.",rSIH."No.");
//         rSIL.SETRANGE("Document Type",rSIH."Document Type"); //+76946
//         //rSIL.SETRANGE(Type,rSIL.Type::Item);
//         rSIL.SETFILTER("No.",'<>%1','');
//         IF rSIL.FINDSET THEN
//           REPEAT
//             I1 += 1;
//             ValorDescLin := 0;

//             IF rSIL."Line Discount %" <> 0 THEN
//               ValorDescLin :=  ((rSIL."Unit Price") * (rSIL."Line Discount %"))/100;

//             // Obtenemos configuracio contabilidad para redondear
//             rGLS.GET;
//             // rGLS."Unit-Amount Rounding Precision");
//             // rGLS."Amount Rounding Precision");

//             // Si los precios no tienen IVA los recalculamos
//             //MDM
//             IF NOT rSIH."Prices Including VAT" THEN BEGIN
//               rSIL."Unit Price"           := (rSIL."Unit Price" * (1 + rSIL."VAT %" / 100));
//               rSIL."Line Discount Amount" := (rSIL."Line Discount Amount"  * (1 + rSIL."VAT %" / 100));
//               rSIL."Inv. Discount Amount" := (rSIL."Inv. Discount Amount"  * (1 + rSIL."VAT %" / 100));
//             END;

//             //+76946b
//             //PrecioN  := ROUND((rSIL."Amount Including VAT" / rSIL.Quantity),0.0001  );
//             IF( rSIL.Quantity<>0) THEN
//               PrecioN  := ROUND((rSIL."Amount Including VAT" / rSIL.Quantity),rGLS."Unit-Amount Rounding Precision");
//             //-76946b

//             DtoLin  := rSIL."Line Discount Amount";
//             DtoFact := rSIL."Inv. Discount Amount";

//             DtoLinTotal  += DtoLin;
//             DtoFactTotal += DtoFact;

//             TotalDescuentos := DtoLin + DtoFact;


//             IF rSIL.Type =rSIL.Type::Item  THEN
//               TotalEjemplares +=  rSIL.Quantity;


//             txtPrecio        := FORMAT(rSIL."Unit Price", 0, '<Precision,2:5><Standard format,0>');
//             txtPrecioConDes  := FORMAT(PrecioN , 0, '<Precision,2:5><Standard format,0>');
//             txtCant   := FORMAT(rSIL.Quantity, 0 ,'<Precision,0:5><Standard format,0>');
//             txtImp    := FORMAT((rSIL."Amount Including VAT" + TotalDescuentos), 0 ,'<Precision,2:2><Standard format,0>');
//             txtImpSinDesc := FORMAT(ROUND((PrecioN * rSIL.Quantity), rGLS."Amount Rounding Precision"));

//             txtImpDes  := FORMAT((rSIL."Line Discount Amount") , 0, '<Precision,2:2><Standard format,0>');
//             txtDes  := FORMAT((rSIL."Line Discount %") , 0, '<Precision,2:2><Standard format,0>');
//             Descripcion := CONVERTSTR(CONVERTSTR(rSIL.Description,'+',' '),'&',' ');
//             Total  += ROUND( (PrecioN * rSIL.Quantity ), rGLS."Amount Rounding Precision");
//             LinEnvio[I1] :=
//            '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION>'+Descripcion +'</DESCRIPCION>'+
//            '<METRICA>'+rSIL."Unit of Measure Code"+'</METRICA>'+
//            '<PRECIOUNITARIO>'+txtPrecioConDes+'</PRECIOUNITARIO>'+
//            '<VALOR>'+txtImpSinDesc+'</VALOR>'+
//            '<DETALLE1><![CDATA['+rSIL."No."+']]></DETALLE1>'+
//            '<DETALLE2><![CDATA['+txtPrecio+']]></DETALLE2>'+
//            '<DETALLE3><![CDATA['+txtImp+']]></DETALLE3>'+
//            '<DETALLE4><![CDATA['+txtDes+'%]]></DETALLE4>'+
//            '<DETALLE5><![CDATA['+txtImpDes+']]></DETALLE5>'+
//            '</LINEA>';

//           UNTIL rSIL.NEXT = 0;

//         IF ROUND(Total) <> rSIH."Amount Including VAT" THEN
//            rSIH."Amount Including VAT" := Total;

//         txtDtoFact := FORMAT(ROUND(DtoLinTotal + DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
//         //Fin Descuentos

//         //Importes
//         txtValorNeto := FORMAT((rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
//         txtIVA := FORMAT((rSIH."Amount Including VAT" - rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
//         //+#1585

//         //txtTotal := FORMAT(ROUND(rSIH."Amount Including VAT"-(DtoLinTotal + DtoFactTotal)),0,'<Precision,2:2><Standard format,0>');
//         txtTotal := FORMAT((rSIH."Amount Including VAT"-DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
//         TotalAmount := ROUND(rSIH."Amount Including VAT"-DtoFactTotal);
//         Check.FormatNoText(OutTxt,TotalAmount,2058,Moneda);
//         TotalAmountTxt  := OutTxt[1]+OutTxt[2];
//         //-#1585
//         //Fin Importes

//         //Mov. IVA
//         //+76946
//         Exento := CalcularExento(rSIH);
//         {
//         rVatEntry.RESET;
//         rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
//         rVatEntry.SETRANGE(rVatEntry."Document No.",rSIH."No.");
//         rVatEntry.SETRANGE(rVatEntry."Posting Date",rSIH."Posting Date");
//         rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::Invoice);
//         IF rVatEntry.FINDSET THEN
//           REPEAT
//             IF rVatEntry.Amount = 0 THEN
//               BEGIN
//                 Exento += rVatEntry.Base;
//               END;
//           UNTIL rVatEntry.NEXT = 0;
//         }
//         //-76946

//         txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
//         //Fin Mov. IVA

//         //Datos Factura
//         I := 0;
//         ParteNumerica := '';
//         ParteSerie := '';
//         Encontrado := FALSE;
//         REPEAT
//           I += 1;
//           IF COPYSTR(rSIH."No. Comprobante Fiscal",I,1) = '-' THEN
//             Encontrado := TRUE;
//         UNTIL (I >= STRLEN(rSIH."No. Comprobante Fiscal")) OR (Encontrado); //+76946 -> Cambiado "I = " por "I >="

//         NoFact := COPYSTR(rSIH."No. Comprobante Fiscal",I+1,(STRLEN(rSIH."No. Comprobante Fiscal")-(I)));
//         Serie := COPYSTR(rSIH."No. Comprobante Fiscal",1,I-1);
//         //Fin Datos Cab. Factura

//         rNoSeriesLine.RESET;
//         rNoSeriesLine.SETRANGE("Series Code",rSIH."No. Serie NCF Facturas");
//         rNoSeriesLine.SETFILTER("Starting No.",'<=%1',rSIH."No. Comprobante Fiscal");
//         rNoSeriesLine.SETFILTER("Ending No.",'>=%1',rSIH."No. Comprobante Fiscal");
//         rNoSeriesLine.FINDFIRST;

//         rNoSeriesLine.TESTFIELD("Tipo Generacion");
//         IF rNoSeriesLine."Tipo Generacion" = rNoSeriesLine."Tipo Generacion"::"2" THEN
//           TG := 'C'
//         ELSE
//           TG := 'O';


//         //Guardar XML de Respuesta
//         Dia := DATE2DMY(WORKDATE,1);
//         Mes := DATE2DMY(WORKDATE,2);
//         Ano := DATE2DMY(WORKDATE,3);

//         //+76496
//         //... Parece que no se usa.
//         {
//         IF ISCLEAR(FileSystem) THEN
//         CREATE(FileSystem,FALSE,TRUE);
//         Folder := rConfSant."Ubicacion XML Respuesta";
//         }
//         //-76496


//         //IF ISCLEAR(Fiel_ifacere) THEN
//         //  CREATE(Fiel_ifacere,FALSE,true);

//         //Fiel_ifacere.RutaApp := Folder;
//         //Fiel_ifacere.ArchivoXML := rSIH."No. Comprobante Fiscal"+'.xml';
//         //Fiel_ifacere.Produccion := '1';
//         //Fiel_ifacere.TipoDocumento := 'F';
//         //LLenar Variables

//         IF Vendedores.GET(rSIH."Collector Code") THEN
//           NombreComprador := Vendedores.Code+' '+Vendedores.Name;

//         //+76946
//         IF Vendedores.GET(rSIH."Salesperson Code") THEN
//           NombreVendedor := Vendedores.Code+' - '+Vendedores.Name;
//         //-76946

//         //Cabecera
//         StringXML.ADDTEXT('pXmlFactura=<FACTURA><ENCABEZADO><NOFACTURA>'+NoFact+'</NOFACTURA><RESOLUCION>');
//         StringXML.ADDTEXT( rNoSeriesLine."No. Resolucion"+'</RESOLUCION>');
//         StringXML.ADDTEXT( '<IDSERIE>'+Serie+'</IDSERIE><EMPRESA>'+rConfSant."ID Empresa FE"+'</EMPRESA><SUCURSAL>');
//         StringXML.ADDTEXT( rCodAlmacen."Cod. Sucursal"+'</SUCURSAL><CAJA>1</CAJA><USUARIO />');
//         StringXML.ADDTEXT( '<FECHAEMISION>'+FORMAT(rSIH."Posting Date")+'</FECHAEMISION>');
//         StringXML.ADDTEXT( '<GENERACION>'+TG+'</GENERACION><MONEDA>'+Moneda+'</MONEDA><TASACAMBIO>'+txtTasa+'</TASACAMBIO>');
//         StringXML.ADDTEXT( '<NOMBRECONTRIBUYENTE><![CDATA['+rSIH."Sell-to Customer Name"+']]></NOMBRECONTRIBUYENTE>');
//         StringXML.ADDTEXT( '<DIRECCIONCONTRIBUYENTE><![CDATA['+rSIH."Sell-to Address" + ' ' +rSIH."Sell-to Address 2" + ' '+rSIH."Sell-to County"+' '+rSIH."Sell-to City"+']]></DIRECCIONCONTRIBUYENTE>');  //+76946b
//         StringXML.ADDTEXT( '<NITCONTRIBUYENTE>'+rSIH."VAT Registration No."+'</NITCONTRIBUYENTE><VALORNETO>');
//         StringXML.ADDTEXT( txtValorNeto+'</VALORNETO><IVA>'+txtIVA+'</IVA><TOTAL>'+txtTotal+'<');
//         StringXML.ADDTEXT( '/TOTAL><DESCUENTO>0</DESCUENTO><EXENTO>0</EXENTO></ENCABEZADO>');
//         StringXML.ADDTEXT( '<OPCIONAL>');
//         //-MDM-Agregar Opcionales Cabecera
//         StringXML.ADDTEXT( '<OPCIONAL1><![CDATA['+rSIH."No. Comprobante Fiscal"+']]></OPCIONAL1>');
//         StringXML.ADDTEXT( '<OPCIONAL2><![CDATA['+ NombreComprador+ ']]></OPCIONAL2>');
//         StringXML.ADDTEXT( '<OPCIONAL3><![CDATA['+rSIH."No."+']]></OPCIONAL3>');
//         StringXML.ADDTEXT( '<OPCIONAL4><![CDATA['+rSIH."Sell-to Customer No."+']]></OPCIONAL4>');
//         StringXML.ADDTEXT( '<OPCIONAL5><![CDATA['+FORMAT(TotalEjemplares)+']]></OPCIONAL5>');
//         StringXML.ADDTEXT( '<OPCIONAL6><![CDATA['+txtDtoFact+']]></OPCIONAL6>');
//         StringXML.ADDTEXT( '<OPCIONAL7><![CDATA['+''+']]></OPCIONAL7>');
//         StringXML.ADDTEXT( '<OPCIONAL8><![CDATA['+rSIH."No."+']]></OPCIONAL8>');  //+76946
//         StringXML.ADDTEXT( '<OPCIONAL9><![CDATA['+NombreVendedor+']]></OPCIONAL9>');  //+76946b
//         StringXML.ADDTEXT( '<OPCIONAL10><![CDATA['+rSIH."Payment Terms Code"+']]></OPCIONAL10>'); //+76946b

//         //MDM
//         StringXML.ADDTEXT( '<TOTAL_LETRAS>'+TotalAmountTxt+'</TOTAL_LETRAS>');
//         StringXML.ADDTEXT( '</OPCIONAL><DETALLE>');

//         k:=0;
//         REPEAT
//          k+=1;
//          StringXML.ADDTEXT( LinEnvio[k]);

//         UNTIL k >= I1; //+76946 -> Cambiado "k = " por "k >="

//         //Lineas

//         StringXML.ADDTEXT( '</DETALLE></FACTURA>');

//         //#60099:INI
//         //IF USERID = 'SGTNAV2012\DYNASOFT' THEN BEGIN
//         //  lcFuncionesFE.GuardarXML(rSIH."No.",StringXML);  //+76946
//         // ERROR('Entorno de pruebas - FA');
//         //END;
//         //#60099:FIN

//         //WebService
//         //Fiel_ifacere.EjecutaWebService;


//         COPYARRAY(RespuestaTxt,WebService.Factura(Url,StringXML),1,10);

//         {
//         //$001
//         IF NOT recAuxFac.GET(rSIH."No.") THEN BEGIN
//           recAuxFac.INIT;
//           recAuxFac."No. Documento" := rSIH."No.";
//           recAuxFac.INSERT;
//         END;
//         //$001
//         }

//           IF RespuestaTxt[1] = 'true' THEN
//               BEGIN
//                 //...
//                 IF TG = 'O' THEN
//                   lrLog.CAE := RespuestaTxt[5]
//                 ELSE
//                   lrLog.CAEC := RespuestaTxt[5];
//                 lrLog."Respuesta CAE/CAEC" := RespuestaTxt[2];
//                 lrLog.pIdSat := RespuestaTxt[3];
//                 lrLog."No. Resolucion" := rNoSeriesLine."No. Resolucion";
//                 lrLog."Fecha Resolucion" := rNoSeriesLine."Fecha Resolucion";
//                 lrLog."Serie Desde" := rNoSeriesLine."Starting No.";
//                 lrLog."Serie hasta" := rNoSeriesLine."Ending No.";
//                 lrLog."Serie Resolucion" := Serie;
//                 lrLog.pSerie        := RespuestaTxt[4];
//                 lrLog.pNoDocumento  := RespuestaTxt[8];
//                 lrLog.pDte          := RespuestaTxt[9];

//                 //+76946b
//                 lrLog.Estado := lrLog.Estado::"2";
//                 lrLog.MODIFY(TRUE);
//                 //-76946b

//               END
//             ELSE
//               BEGIN

//                 //+76946b
//                 lrLog."Descripción error" := COPYSTR(RespuestaTxt[2],1,250);
//                 lrLog.MODIFY(TRUE);

//                 //... Así provocaremos que no se imprima y que se notifique el error.
//                 COMMIT;
//                 ERROR(Text003);
//                 //-76946b

//                 IF GUIALLOWED THEN
//                   BEGIN
//                     //MESSAGE(COPYSTR(RespuestaTxt[2],1,250));
//                     //MESSAGE(Text003);
//                   END;
//               END;


//         //CLEAR(Fiel_ifacere);
//         COMMIT;
//         */
//         //fes mig

//     end;


//     procedure NotaCR_DSPos(rSCMH: Record "Sales Header")
//     var
//         rSCML: Record "Sales Line";
//         rSIH: Record "Sales Invoice Header";
//         PeticionFecha: Page "Petición de Fecha";
//         FileSystem: Automation;
//         Ano: Integer;
//         Mes: Integer;
//         Dia: Integer;
//         Folder: Text[1024];
//         Nombre: Text[30];
//         FechaFacRel: Date;
//         RespuestaTxt: array[10] of Text;
//         StringXML: BigText;
//         Url: Text;
//         DtoLin: Decimal;
//         DtoFact: Decimal;
//         I: Integer;
//         I1: Integer;
//         DtoLinTotal: Decimal;
//         DtoFactTotal: Decimal;
//         Exento: Decimal;
//         LinEnvio: array[50] of Text[1024];
//         rCodAlmacen: Record Location;
//         rConfSant: Record "Config. Empresa";
//         rGLS: Record "General Ledger Setup";
//         Moneda: Code[20];
//         Tasa: Decimal;
//         txtTasa: Text[30];
//         ValorDescLin: Decimal;
//         TotalDescuentos: Decimal;
//         txtCant: Text[30];
//         txtPrecio: Text[30];
//         txtImp: Text[30];
//         Descripcion: Text;
//         txtDtoFact: Text[30];
//         txtValorNeto: Text[30];
//         txtIVA: Text[30];
//         txtTotal: Text[30];
//         TotalAmount: Decimal;
//         Check: Report "Check Translation Management";
//         OutTxt: array[2] of Text[80];
//         TotalAmountTxt: Text;
//         rVatEntry: Record "VAT Entry";
//         txtExento: Text[30];
//         ParteNumerica: Code[20];
//         ParteSerie: Code[20];
//         Encontrado: Boolean;
//         Serie: Code[10];
//         rNoSeriesLine: Record "No. Series Line";
//         lrNoSeriesLineAux: Record "No. Series Line";
//         NoFact: Code[20];
//         TG: Code[1];
//         k: Integer;
//         NoFactRel: Text[30];
//         SerieRel: Text[30];
//         Concepto: Text[30];
//         NombreComprador: Text[100];
//         Vendedores: Record "Salesperson/Purchaser";
//         TotalEjemplares: Integer;
//         PrecioN: Decimal;
//         txtPrecioConDes: Text[30];
//         txtImpDes: Text[30];
//         txtDes: Text[30];
//         txtImpSinDesc: Text[30];
//         Total: Decimal;
//         TotalBruto: Decimal;
//         txtTotalBruto: Text[30];
//         lVendedor: Code[30];
//         lFechaFacturaRelacionada: Date;
//         NombreVendedor: Text[100];
//         lSalir: Boolean;
//     begin
//         //fes mig
//         /*
//         //#76946
//         //... Esta funcion es una copia de la funcion Factura() de la codeunit 50006
//         //... rSCMH Y rSCML, apuntan en esta función a las tablas 36 y 37.
//         //... Para que sea mas facil de actualizar y de mantener he optado por no cambiar el nombre.

//         //#76946, cambios posteriores en la funcion base se destacan como #76946b

//         //#76946b
//         lSalir := FALSE;
//         lrNoSeriesLineAux.RESET;
//         lrNoSeriesLineAux.SETRANGE("Series Code",rSCMH."No. Serie NCF Abonos");
//         lrNoSeriesLineAux.SETFILTER("Starting No.",'<=%1',rSCMH."No. Comprobante Fiscal");
//         lrNoSeriesLineAux.SETFILTER("Ending No.",'>=%1',rSCMH."No. Comprobante Fiscal");
//         lrNoSeriesLineAux.FINDFIRST;

//         IF lrNoSeriesLineAux."Tipo Generacion" <> lrNoSeriesLineAux."Tipo Generacion"::"1" THEN
//           lSalir := TRUE;

//         IF NOT lrLog.GET(lrLog."Tipo documento"::"3",rSCMH."No.") THEN BEGIN
//           lrLog.INIT;
//           lrLog."Tipo documento"  := lrLog."Tipo documento"::"3";
//           lrLog."Nº documento"    := rSCMH."No.";
//           lrLog."Fecha registro"  := rSCMH."Posting Date";
//           lrLog."Tipo generación" := lrNoSeriesLineAux."Tipo Generacion";

//           //... Sólo dejamos en estado pendiente, los de serie electrónica.
//           IF lrNoSeriesLineAux."Tipo Generacion" = lrNoSeriesLineAux."Tipo Generacion"::"1" THEN
//             lrLog.Estado:= lrLog.Estado::"1";

//           lrLog.INSERT(TRUE);
//           COMMIT;
//         END;
//         //#76946b

//         IF lSalir THEN
//           EXIT;

//         rSCMH.TESTFIELD("No. Comprobante Fiscal Rel.");
//         DtoLin := 0;
//         DtoFact := 0;
//         I := 0;
//         I1 := 0;
//         NombreComprador:='';
//         TotalEjemplares:=0;

//         //+76946b
//         //Url := 'https://www.ifacere.com/lineapruebas/sso_wsefactura.asmx/RegistraNotaCreditoXML';
//         rConfSant.GET;
//         Url := rConfSant."URL Nota de Credito Electronic";
//         //-76946b

//         CLEAR(LinEnvio);

//         rCodAlmacen.GET(rSCMH."Location Code");
//         rCodAlmacen.TESTFIELD("Cod. Sucursal");

//         rConfSant.GET;
//         rConfSant.TESTFIELD("Ubicacion XML Respuesta");

//         rSCMH.CALCFIELDS(Amount);
//         rSCMH.CALCFIELDS("Amount Including VAT");

//         //Divisa
//         IF rSCMH."Currency Code" = '' THEN
//           BEGIN
//             rGLS.GET;
//             Moneda := UPPERCASE(rGLS."LCY Code");
//             Tasa := 1;
//             txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
//           END
//         ELSE
//           BEGIN
//             Moneda := UPPERCASE(rSCMH."Currency Code");
//             Tasa := (rSCMH."Amount Including VAT"/rSCMH."Currency Factor");
//             Tasa := (Tasa/rSCMH."Amount Including VAT");
//             txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
//           END;
//         //Fin Divisa

//         //Descuentos
//         rSCML.RESET;
//         rSCML.SETRANGE("Document No.",rSCMH."No.");
//         rSCML.SETRANGE("Document Type",rSCMH."Document Type");  //+76946
//         rSCML.SETFILTER("No.",'<>%1','');
//         IF rSCML.FINDSET THEN
//           REPEAT
//             I1 += 1;


//             // Obtenemos configuracio contabilidad para redondear
//             rGLS.GET;

//             // Si los precios no tienen IVA los recalculamos
//             IF NOT rSCMH."Prices Including VAT" THEN BEGIN

//               rSCML."Unit Price"           := ROUND((rSCML."Unit Price"            * (1 + rSCML."VAT %" / 100)) , rGLS."Unit-Amount Rounding Precision");
//               rSCML."Line Discount Amount" := ROUND((rSCML."Line Discount Amount"  * (1 + rSCML."VAT %" / 100)) , rGLS."Amount Rounding Precision");
//               rSCML."Inv. Discount Amount" := ROUND((rSCML."Inv. Discount Amount"  * (1 + rSCML."VAT %" / 100)) , rGLS."Amount Rounding Precision");

//             END;

//             //MDM
//             IF( rSCML.Quantity<>0) THEN
//               PrecioN  := ROUND((rSCML."Amount Including VAT" / rSCML.Quantity),rGLS."Unit-Amount Rounding Precision");

//             DtoLin  := rSCML."Line Discount Amount";
//             DtoFact := rSCML."Inv. Discount Amount";

//             DtoLinTotal  += DtoLin;
//             DtoFactTotal += DtoFact;

//             TotalDescuentos := DtoLin + DtoFact;

//         //MDM

//             IF rSCML.Type =rSCML.Type::Item  THEN
//               TotalEjemplares +=  rSCML.Quantity;


//             txtPrecio        := FORMAT((rSCML."Unit Price") , 0, '<Precision,2:5><Standard format,0>');
//             txtPrecioConDes  := FORMAT(PrecioN, 0, '<Precision,2:5><Standard format,0>');
//             txtCant   := FORMAT(ROUND(rSCML.Quantity), 0 ,'<Precision,0:5><Standard format,0>');
//             txtImp    := FORMAT(ROUND((rSCML."Amount Including VAT" + TotalDescuentos), rGLS."Amount Rounding Precision"), 0 ,'<Precision,2:2><Standard format,0>');
//             txtImpSinDesc := FORMAT(ROUND((PrecioN * rSCML.Quantity), rGLS."Amount Rounding Precision"));
//             txtImpDes  := FORMAT((rSCML."Line Discount Amount") , 0, '<Precision,2:2><Standard format,0>');
//             txtDes  := FORMAT((rSCML."Line Discount %") , 0, '<Precision,2:2><Standard format,0>');
//             Descripcion := CONVERTSTR(CONVERTSTR(rSCML.Description,'+',' '),'&',' ');
//             Total  += ROUND((PrecioN * rSCML.Quantity) ,rGLS."Amount Rounding Precision");


//             LinEnvio[I1] :=
//            '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION>'+Descripcion +'</DESCRIPCION>'+
//            '<METRICA>'+rSCML."Unit of Measure Code"+'</METRICA>'+
//            '<PRECIOUNITARIO>'+txtPrecioConDes+'</PRECIOUNITARIO>'+
//            '<VALOR>'+txtImpSinDesc+'</VALOR>'+
//            '<DETALLE1><![CDATA['+rSCML."No."+']]></DETALLE1>'+
//            '<DETALLE2><![CDATA['+txtPrecio+']]></DETALLE2>'+
//            '<DETALLE3><![CDATA['+txtImp+']]></DETALLE3>'+
//            '<DETALLE4><![CDATA['+txtDes+'%]]></DETALLE4>'+
//            '<DETALLE5><![CDATA['+txtImpDes+']]></DETALLE5>'+
//            '</LINEA>';




//         //MDM



//           UNTIL rSCML.NEXT = 0;

//         IF Total <> rSCMH."Amount Including VAT" THEN
//            rSCMH."Amount Including VAT" := Total;


//         txtDtoFact := FORMAT(ROUND(DtoLinTotal + DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
//         //Fin Descuentos

//         //Importes
//         txtValorNeto := FORMAT(ROUND(rSCMH.Amount),0,'<Precision,2:2><Standard format,0>');
//         txtIVA := FORMAT(ROUND(rSCMH."Amount Including VAT" - rSCMH.Amount),0,'<Precision,2:2><Standard format,0>');
//         //INICIO #1926
//         //txtTotal := FORMAT(ROUND(rSCMH."Amount Including VAT"-(DtoLinTotal + DtoFactTotal)),0,'<Precision,2:2><Standard format,0>');
//         txtTotal := FORMAT(ROUND(rSCMH."Amount Including VAT" - DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
//         TotalAmount := ROUND(rSCMH."Amount Including VAT"-DtoFactTotal);
//         Check.FormatNoText(OutTxt,TotalAmount,2058,Moneda);
//         TotalAmountTxt  := OutTxt[1]+OutTxt[2];
//         TotalBruto    := (rSCMH.Amount + ROUND(DtoLinTotal + DtoFactTotal));
//         txtTotalBruto := FORMAT(ROUND(TotalBruto),0,'<Precision,2:2><Standard format,0>');


//         //FIN #1926
//         //Fin Importes

//         //Mov. IVA
//         //+76946
//         Exento := CalcularExento(rSCMH);
//         {
//         rVatEntry.RESET;
//         rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
//         rVatEntry.SETRANGE(rVatEntry."Document No.",rSCMH."No.");
//         rVatEntry.SETRANGE(rVatEntry."Posting Date",rSCMH."Posting Date");
//         rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::"Credit Memo");
//         IF rVatEntry.FINDSET THEN
//           REPEAT
//             IF rVatEntry.Amount = 0 THEN
//               BEGIN
//                 Exento += rVatEntry.Base;
//               END;
//           UNTIL rVatEntry.NEXT = 0;
//         }
//         //-76946

//         txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
//         //Fin Mov. IVA

//         //Datos Factura
//         I := 0;
//         ParteNumerica := '';
//         ParteSerie := '';
//         Encontrado := FALSE;
//         REPEAT
//           I += 1;
//           IF COPYSTR(rSCMH."No. Comprobante Fiscal",I,1) = '-' THEN
//             Encontrado := TRUE;
//         UNTIL (I >= STRLEN(rSCMH."No. Comprobante Fiscal")) OR (Encontrado); //+76946 -> Cambiado "I = " por "I >="

//         NoFact := COPYSTR(rSCMH."No. Comprobante Fiscal",I+1,(STRLEN(rSCMH."No. Comprobante Fiscal")-(I)));
//         Serie := COPYSTR(rSCMH."No. Comprobante Fiscal",1,I-1);
//         //Fin Datos Cab. Factura

//         //Para No. Comp. Relacionado
//         I := 0;
//         ParteNumerica := '';
//         ParteSerie := '';
//         Encontrado := FALSE;
//         REPEAT
//           I += 1;
//           IF COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",I,1) = '-' THEN
//             Encontrado := TRUE;
//         UNTIL (I >= STRLEN(rSCMH."No. Comprobante Fiscal Rel.")) OR (Encontrado); //+76946 -> Cambiado "I = " por "I >="

//         NoFactRel := COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",I+1,(STRLEN(rSCMH."No. Comprobante Fiscal Rel.")-(I)));
//         SerieRel := COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",1,I-1);
//         //Para No. Comp. Relacionado

//         //+76946
//         BuscarCabVentaRelacionado(rSCMH,lFechaFacturaRelacionada,lVendedor);
//         //-76946

//         rNoSeriesLine.RESET;
//         rNoSeriesLine.SETRANGE("Series Code",rSCMH."No. Serie NCF Abonos");
//         //rNoSeriesLine.SETRANGE(Open,true);
//         rNoSeriesLine.SETFILTER("Starting No.",'<=%1',rSCMH."No. Comprobante Fiscal");
//         rNoSeriesLine.SETFILTER("Ending No.",'>=%1',rSCMH."No. Comprobante Fiscal");
//         rNoSeriesLine.FINDFIRST;

//         rNoSeriesLine.TESTFIELD("Tipo Generacion");
//         IF rNoSeriesLine."Tipo Generacion" = rNoSeriesLine."Tipo Generacion"::"2" THEN
//           TG := 'C'
//         ELSE
//           TG := 'O';


//         //+76496
//         //... Parece que no se usa.
//         //Folder := rConfSant."Ubicacion XML Respuesta";
//         //-76946

//         //IF ISCLEAR(Fiel_ifacere) THEN
//         //  CREATE(Fiel_ifacere,FALSE,true);
//         //Fiel_ifacere.RutaApp := Folder;
//         //Fiel_ifacere.ArchivoXML := rSCMH."No. Comprobante Fiscal"+'.xml';
//         //Fiel_ifacere.Produccion := '1';
//         //Fiel_ifacere.TipoDocumento := 'N';

//         //+76946
//         //... Esta comprobacion no se implementa ya que la factura original no ha sido registrada.
//         //... Si hay que realizar un cambio, se hará.
//         {
//         IF NOT rSIH.GET(rSCMH."Applies-to Doc. No.") THEN
//           BEGIN
//             rSIH.RESET;
//             rSIH.SETCURRENTKEY(rSIH."No. Comprobante Fiscal");
//             rSIH.SETRANGE(rSIH."No. Comprobante Fiscal",rSCMH."No. Comprobante Fiscal Rel.");

//             //+#60330
//             //rSIH.FINDFIRST;
//             IF NOT rSIH.FINDFIRST THEN BEGIN
//               IF NOT CONFIRM(txt005, TRUE, rSCMH."No. Comprobante Fiscal Rel.") THEN
//                 ERROR(Error002, rSCMH."No. Comprobante Fiscal Rel.");
//               IF PeticionFecha.RUNMODAL <> ACTION::Yes THEN
//                 ERROR(Error002, rSCMH."No. Comprobante Fiscal Rel.");
//               FechaFacRel := PeticionFecha.DevolverFecha();
//               IF FechaFacRel > rSCMH."Posting Date" THEN
//                 ERROR(Error003, FechaFacRel, rSCMH."Posting Date");
//               IF FechaFacRel < CALCDATE('<-1Y>', WORKDATE) THEN
//                 ERROR(Error004, FechaFacRel);
//               rSIH."Posting Date" := FechaFacRel;
//             END;
//             //-#60330

//           END;
//         }
//         //-76946

//         //+76946
//         //IF rSCMH."Pre-Assigned No." <> '' THEN
//         IF NOT rSCMH.Devolucion THEN
//         //-76946
//           Concepto := 'ANULACION'
//         ELSE
//           Concepto := 'DEVOLUCION';

//         //+76946
//         //IF Vendedores.GET(rSIH."Collector Code") THEN
//         IF Vendedores.GET(lVendedor) THEN
//         //-76946
//          NombreComprador := Vendedores.Code+' '+Vendedores.Name;

//         IF Vendedores.GET(rSCMH."Salesperson Code") THEN
//          NombreVendedor := Vendedores.Code+' - '+Vendedores.Name;

//         //Cabecera
//         StringXML.ADDTEXT( 'pXmlNotaCredito=<NOTACREDITO><ENCABEZADO><NODOCUMENTO>'+NoFact+'</NODOCUMENTO><RESOLUCION>');
//         StringXML.ADDTEXT( rNoSeriesLine."No. Resolucion"+'</RESOLUCION>');
//         StringXML.ADDTEXT( '<IDSERIE>'+Serie+'</IDSERIE><EMPRESA>'+rConfSant."ID Empresa FE"+'</EMPRESA><SUCURSAL>');
//         StringXML.ADDTEXT( rCodAlmacen."Cod. Sucursal"+'</SUCURSAL><CAJA>1</CAJA><USUARIO />');
//         StringXML.ADDTEXT( '<FECHAEMISION>'+FORMAT(rSCMH."Posting Date")+'</FECHAEMISION>');
//         StringXML.ADDTEXT( '<GENERACION>'+TG+'</GENERACION><MONEDA>'+Moneda+'</MONEDA><TASACAMBIO>'+txtTasa+'</TASACAMBIO>');
//         StringXML.ADDTEXT( '<NOMBRECONTRIBUYENTE><![CDATA['+rSCMH."Sell-to Customer Name"+']]></NOMBRECONTRIBUYENTE>');
//         StringXML.ADDTEXT( '<DIRECCIONCONTRIBUYENTE><![CDATA['+ rSCMH."Sell-to Address" + ' ' + rSCMH."Sell-to Address 2" + ' '+ rSCMH."Sell-to County"+' '+ rSCMH."Sell-to City"+']]></DIRECCIONCONTRIBUYENTE>');

//         StringXML.ADDTEXT( '<NITCONTRIBUYENTE>'+rSCMH."VAT Registration No."+'</NITCONTRIBUYENTE><VALORNETO>');
//         StringXML.ADDTEXT( txtValorNeto+'</VALORNETO><IVA>'+txtIVA+'</IVA><TOTAL>'+txtTotal+'<');
//         StringXML.ADDTEXT( '/TOTAL><DESCUENTO>0</DESCUENTO>');
//         StringXML.ADDTEXT( '<NOFACTURA>'+NoFactRel+'</NOFACTURA>');
//         StringXML.ADDTEXT( '<SERIEFACTURA>'+SerieRel+'</SERIEFACTURA>');

//         //+76946
//         //StringXML.ADDTEXT( '<FECHAFACTURA>'+FORMAT(rSIH."Posting Date")+'</FECHAFACTURA>');
//         StringXML.ADDTEXT( '<FECHAFACTURA>'+FORMAT(lFechaFacturaRelacionada)+'</FECHAFACTURA>');
//         //-76946

//         StringXML.ADDTEXT( '<CONCEPTO>'+Concepto+'</CONCEPTO>');
//         StringXML.ADDTEXT( '</ENCABEZADO>');
//         StringXML.ADDTEXT( '<OPCIONAL>');
//         StringXML.ADDTEXT( '<TOTAL_LETRAS>'+TotalAmountTxt+'</TOTAL_LETRAS>');
//         StringXML.ADDTEXT( '<OPCIONAL1><![CDATA['+rSCMH."No. Comprobante Fiscal"+']]></OPCIONAL1>');
//         StringXML.ADDTEXT( '<OPCIONAL2><![CDATA['+rSCMH."Salesperson Code"+']]></OPCIONAL2>');
//         StringXML.ADDTEXT( '<OPCIONAL3><![CDATA['+NombreComprador+ ']]></OPCIONAL3>');
//         StringXML.ADDTEXT( '<OPCIONAL4><![CDATA['+rSCMH."No."+']]></OPCIONAL4>');
//         StringXML.ADDTEXT( '<OPCIONAL5><![CDATA['+rSCMH."Sell-to Customer No."+']]></OPCIONAL5>');
//         StringXML.ADDTEXT( '<OPCIONAL6><![CDATA['+FORMAT(TotalEjemplares)+']]></OPCIONAL6>');
//         StringXML.ADDTEXT( '<OPCIONAL7><![CDATA['+rSCMH."Posting Description"+']]></OPCIONAL7>');
//         StringXML.ADDTEXT( '<OPCIONAL8><![CDATA['+txtTotalBruto+']]></OPCIONAL8>');
//         StringXML.ADDTEXT( '<OPCIONAL9><![CDATA['+txtDtoFact+']]></OPCIONAL9>');
//         StringXML.ADDTEXT( '<OPCIONAL10><![CDATA['+txtValorNeto+']]></OPCIONAL10>');
//         StringXML.ADDTEXT( '<OPCIONAL11><![CDATA['+txtDtoFact+']]></OPCIONAL11>');
//         StringXML.ADDTEXT( '<OPCIONAL12><![CDATA['+txtTotal+']]></OPCIONAL12>');
//         StringXML.ADDTEXT( '<OPCIONAL13><![CDATA['+NombreVendedor+']]></OPCIONAL13>');
//         StringXML.ADDTEXT( '<OPCIONAL14><![CDATA['+rSCMH."Payment Terms Code"+']]></OPCIONAL14>');
//         StringXML.ADDTEXT( '<OPCIONAL15><![CDATA[ AFECTA A FACTURA :'+rSCMH."No. Comprobante Fiscal Rel."+','+rSCMH."Applies-to Doc. No."+','+FORMAT(rSIH."Posting Date")+']]></OPCIONAL15>');

//         StringXML.ADDTEXT( '</OPCIONAL><DETALLE>');


//         k:=0;
//         REPEAT
//          k+=1;
//          StringXML.ADDTEXT( LinEnvio[k]);

//         UNTIL k >= I1; //+76946 -> Cambiado "k = " por "k >="

//         //Lineas

//         StringXML.ADDTEXT( '</DETALLE></NOTACREDITO>');

//         //#60099:INI
//         IF USERID = 'SGTNAV2012\DYNASOFT' THEN BEGIN
//           lcFuncionesFE.GuardarXML(rSCMH."No.",StringXML); //+76946
//         //  ERROR('Entorno de pruebas - NC');
//         END;

//         //WebService
//         //Fiel_ifacere.EjecutaWebService;
//         COPYARRAY(RespuestaTxt,WebService.NotadeCredito(Url,StringXML),1,10);

//         {
//         //$001
//         IF NOT recAuxNC.GET(rSCMH."No.") THEN BEGIN
//           recAuxNC.INIT;
//           recAuxNC."No. Documento" := rSCMH."No.";
//           recAuxNC.INSERT;
//         END;
//         //$001
//         }

//         IF RespuestaTxt[1] = 'true' THEN
//           BEGIN
//             rNoSeriesLine.RESET;
//             rNoSeriesLine.SETRANGE("Series Code",rSCMH."No. Serie NCF Abonos");
//             rNoSeriesLine.SETRANGE(Open,TRUE);
//             rNoSeriesLine.FINDFIRST;

//           //Respuestas
//            IF TG = 'O' THEN
//             lrLog.CAE :=  RespuestaTxt[5]
//             ELSE
//             lrLog.CAEC := RespuestaTxt[5];

//             lrLog."Respuesta CAE/CAEC" :=   RespuestaTxt[2];
//             lrLog.pIdSat := RespuestaTxt[3];
//             lrLog."No. Resolucion" := rNoSeriesLine."No. Resolucion";
//             lrLog."Fecha Resolucion" := rNoSeriesLine."Fecha Resolucion";
//             lrLog."Serie Desde" := rNoSeriesLine."Starting No.";
//             lrLog."Serie hasta" := rNoSeriesLine."Ending No.";
//             lrLog."Serie Resolucion" := Serie;

//             lrLog.pSerie        := RespuestaTxt[4];
//             lrLog.pNoDocumento  := RespuestaTxt[8];
//             lrLog.pDte          := RespuestaTxt[9];

//             //+76946b
//             lrLog.Estado := lrLog.Estado::"2";
//             lrLog.MODIFY(TRUE);
//             //-76946b

//         //$001

//           END
//         ELSE BEGIN
//           //+76946b
//           lrLog."Descripción error" := COPYSTR(RespuestaTxt[2],1,250);
//           lrLog.MODIFY(TRUE);

//           //... Así provocaremos que no se imprima y que se notifique el error.
//           COMMIT;
//           ERROR(Text003);
//           //-76946b

//           IF GUIALLOWED THEN
//             BEGIN
//               //MESSAGE(RespuestaTxt[1]);
//               //MESSAGE(FORMAT(COPYSTR(RespuestaTxt[2],1,250)));
//               //MESSAGE(Text003);
//             END;
//         END;

//         //CLEAR(Fiel_ifacere);
//         COMMIT;
//         */
//         //fes mig

//     end;


//     procedure CalcularExento(rCabVenta: Record "Sales Header"): Decimal
//     var
//         lrLinVenta: Record "Sales Line";
//         TempVATAmountLine: Record "VAT Amount Line" temporary;
//         lResult: Decimal;
//     begin
//         //#76946

//         lResult := 0;

//         lrLinVenta.Reset;
//         lrLinVenta.SetRange("Document Type", rCabVenta."Document Type");
//         lrLinVenta.SetRange("Document No.", rCabVenta."No.");
//         lrLinVenta.SetFilter(Type, '<>0');

//         if lrLinVenta.FindFirst then begin
//             lrLinVenta.CalcVATAmountLines(0, rCabVenta, lrLinVenta, TempVATAmountLine);

//             TempVATAmountLine.Reset;
//             TempVATAmountLine.SetRange("VAT %", 0);
//             if TempVATAmountLine.FindFirst then
//                 repeat
//                     lResult := lResult + TempVATAmountLine."VAT Base";
//                 until TempVATAmountLine.Next = 0;
//         end;

//         exit(lResult);
//     end;


//     procedure BuscarCabVentaRelacionado(lrCabVenta: Record "Sales Header"; var lFechaFacturaRelacionada: Date; var lVendedor: Code[10])
//     var
//         lrCVRel: Record "Sales Header";
//     begin
//         //#76946
//         lFechaFacturaRelacionada := lrCabVenta."Posting Date";
//         lVendedor := lrCabVenta."Collector Code";
//         if lrCabVenta."No. Comprobante Fiscal Rel." <> '' then begin
//             lrCVRel.Reset;
//             lrCVRel.SetCurrentKey("No. Comprobante Fiscal");
//             lrCVRel.SetRange("No. Comprobante Fiscal", lrCabVenta."No. Comprobante Fiscal Rel.");
//             if lrCVRel.FindFirst then begin
//                 if lrCVRel."Posting Date" <> 0D then
//                     lFechaFacturaRelacionada := lrCVRel."Posting Date";

//                 if lrCVRel."Collector Code" <> '' then
//                     lVendedor := lrCVRel."Collector Code";
//             end;
//         end;
//     end;


//     procedure Parametros(rp_CabVenta: Record "Sales Header"; pRegistroEnLinea: Boolean)
//     begin
//         //+76946
//         //... Asignamos valor a los parámetros.
//         rGblCabVenta := rp_CabVenta;
//         wRegistroEnLinea := pRegistroEnLinea;
//     end;


//     procedure TestFaltaGenerarCertificado(pTipoDocumento: Option Factura,"Nota crédito"; pCodigo: Code[20]; pCodigoRegis: Code[20]; pVentaTPV: Boolean): Boolean
//     var
//         lResult: Boolean;
//         lTipoDocumento: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//         lSerieElectronica: Boolean;
//     begin
//         //fes mig
//         /*
//         //+76946
//         //... Si falta certificado digital se notifica. Sólo se pretende cubrir la casuística de los documentos que vienen del TPV.
//         IF NOT pVentaTPV THEN
//           EXIT(TRUE);

//         lResult := TRUE;

//         CASE pTipoDocumento OF
//           pTipoDocumento::Factura: lTipoDocumento := lTipoDocumento::Invoice;
//           pTipoDocumento::"Nota crédito": lTipoDocumento := lTipoDocumento::"Credit Memo";
//         END;

//         IF lrLogFE.GET(lTipoDocumento,pCodigo) THEN BEGIN

//           //... Me comenta Robert que en la tienda sólo deben dejar de enviarse las facturas con linea de serie Tipo generación = Electrónico.
//           //... Lo normal es que se hayan enviado correctamente con la WS. Si no fuera el caso, tendrían el campo CAE sin valor y volveriamos a generar el certificado.
//           //... POR TANTO, y simplificando: SOLO descartaremos las facturas que tengan valor en el campo CAE.

//           //+#126073
//           {
//           IF lrLogFE."Tipo generación" <> lrLogFE."Tipo generación"::Electrónico THEN
//             EXIT(TRUE);
//           }
//           //-#126073

//           IF lrLogFE.CAE <> '' THEN
//             lResult := FALSE;

//           IF NOT lResult THEN BEGIN
//             //... Sólo podemos llegar a este código si CAE <> '', es decir si es electrónico y hay datos.
//             IF pTipoDocumento = pTipoDocumento::Factura THEN
//               InsertarRegFacAuxiliar(pCodigoRegis,lrLogFE);

//             IF pTipoDocumento = pTipoDocumento::"Nota crédito" THEN
//               InsertarRegNCRAuxiliar(pCodigoRegis,lrLogFE);

//             lrLogFE.VALIDATE(Estado,lrLogFE.Estado::"3");
//             lrLogFE.MODIFY;
//           END;

//         END;

//         //+#126073
//         //... Podría ocurrir que realmente ya estuviera firmada y no se hubiera replicado el LOG. Por tanto lo revisamos.
//         //... Sólo se comprobará para las series electrónicas.
//         IF lResult THEN BEGIN
//           CASE pTipoDocumento OF
//             pTipoDocumento::Factura:
//               BEGIN
//                 lSerieElectronica := FALSE;
//                 IF lrSIH.GET(pCodigoRegis) THEN
//                   //IF TestSerieDocElectronico(lrSIH."No. Serie NCF Facturas",lrSIH."No. Comprobante Fiscal") THEN BEGIN
//                   //  lSerieElectronica := TRUE;
//                     IF lrAuxFactura.GET(lrSIH."No.") THEN
//                       IF (lrAuxFactura.CAE <> '') OR (lrAuxFactura.CAEC <> '') THEN
//                         lResult  := FALSE;
//                   //END;

//                 //... Solo se validan las de serie eletronica. Si son de resguardo no se han firmado en la tienda.
//                 //... Cambio de planes. Si podemos obtener los datos de la firma, tanto da....
//                 //IF lSerieElectronica AND lResult THEN BEGIN
//                 IF lResult THEN BEGIN
//                   lcFE.EvitarNotificacionErrorFirma;
//                   lcFE.ValidarFactura(lrSIH);
//                   IF lrAuxFactura.GET(lrSIH."No.") THEN
//                     IF (lrAuxFactura.CAE <> '') OR (lrAuxFactura.CAEC <> '') THEN
//                       lResult := FALSE;
//                 END;
//               END;

//             pTipoDocumento::"Nota crédito":
//               BEGIN
//                 lSerieElectronica := FALSE;
//                 IF lrSCMH.GET(pCodigoRegis) THEN
//                   //IF TestSerieDocElectronico(lrSCMH."No. Serie NCF Abonos",lrSCMH."No. Comprobante Fiscal") THEN BEGIN
//                   //  lSerieElectronica := TRUE;
//                     IF lrAuxNC.GET(lrSCMH."No.") THEN
//                       IF (lrAuxNC.CAE <> '') OR (lrAuxNC.CAEC <> '') THEN
//                         lResult  := FALSE;
//                   //END;

//                 //... Solo se validan las de serie eletronica. Si son de resguardo no se han firmado en la tienda.
//                 //... Cambio de planes. Si podemos obtener los datos de la firma, tanto da....
//                 //IF lSerieElectronica AND lResult THEN BEGIN
//                 IF lResult THEN BEGIN
//                   lcFE.EvitarNotificacionErrorFirma;
//                   lcFE.ValidarNotaCR(lrSCMH);
//                   IF lrAuxNC.GET(lrSCMH."No.") THEN
//                     IF (lrAuxNC.CAE <> '') OR (lrAuxNC.CAEC <> '') THEN
//                       lResult := FALSE;
//                 END;
//               END;
//           END;
//         END;
//         //-#126073

//         EXIT(lResult);
//         */
//         //fes mig

//     end;


//     procedure InsertarRegFacAuxiliar(pCodigo: Code[20])
//     begin
//         //fes mig
//         /*
//         //+76946
//         //... Insertamos los valores recogidos en la tienda Pos.
//         IF NOT lrHistFacAux.GET(pCodigo) THEN BEGIN
//           lrHistFacAux.INIT;
//           lrHistFacAux."No. Documento" := pCodigo;
//           lrHistFacAux.INSERT;
//         END;

//         IF (lrHistFacAux.CAE = '') AND (lrHistFacAux.CAEC = '') AND (lrHistFacAux."Respuesta CAE/CAEC" = '') THEN BEGIN
//           lrHistFacAux.TRANSFERFIELDS(lrLog,FALSE);
//           lrHistFacAux.MODIFY;
//         END;
//         */
//         //fes mig

//     end;


//     procedure InsertarRegNCRAuxiliar(pCodigo: Code[20])
//     begin
//         //fes mig
//         /*
//         //+76946
//         //... Insertamos los valores recogidos en la tienda Pos.
//         IF NOT lrHistNCRAux.GET(pCodigo) THEN BEGIN
//           lrHistNCRAux.INIT;
//           lrHistNCRAux."No. Documento" := pCodigo;
//           lrHistNCRAux.INSERT;
//         END;

//         IF (lrHistNCRAux.CAE = '') AND (lrHistNCRAux.CAEC = '') AND (lrHistNCRAux."Respuesta CAE" = '') THEN BEGIN
//           lrHistNCRAux.TRANSFERFIELDS(lrLog,FALSE);
//           lrHistNCRAux.MODIFY;
//         END;
//         */
//         //fes mig

//     end;


//     procedure FinalProcesoRegistro(pNumLog: Integer)
//     begin
//         //+76946
//         RevisarDatosFE_Pendientes;

//         //#126073
//         //... Los que hayan quedado pendientes de firma, se intentarán firmar.
//         wNumLog := pNumLog;
//         FirmarRegistrados;
//     end;


//     procedure RevisarDatosFE_Pendientes(): Integer
//     var
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//         lCuenta: Integer;
//         lWindow: Dialog;
//     begin
//         //fes mig
//         /*
//         //+76946
//         lCuenta := 0;
//         lWindow.OPEN('Traspasando datos FE ####################1');
//         lrLog.RESET;
//         lrLog.SETCURRENTKEY("Tipo generación",Estado);
//         lrLog.SETRANGE("Tipo generación",lrLog."Tipo generación"::"1");
//         lrLog.SETRANGE(Estado,lrLog.Estado::"2");
//         lrLog.SETFILTER(CAE,'<>%1','');
//         //lrLog.SETRANGE("Fecha traspaso",0D);

//         IF lrLog.FINDFIRST THEN

//           REPEAT

//             lWindow.UPDATE(1,lrLog."Nº documento");

//             IF lrLog."Tipo documento" = lrLog."Tipo documento"::"2" THEN BEGIN
//               lrSIH.RESET;
//               lrSIH.SETCURRENTKEY("Pre-Assigned No.");
//               lrSIH.SETRANGE("Pre-Assigned No.",lrLog."Nº documento");
//               IF lrSIH.FINDFIRST THEN BEGIN

//                 IF NOT lrFacAux.GET(lrSIH."No.") THEN BEGIN
//                   lrFacAux.INIT;
//                   lrFacAux."No. Documento" := lrSIH."No.";
//                   lrFacAux.INSERT;
//                 END;

//                 //... Identificamos que quizás no hay nada grabado.
//                 IF( lrFacAux.CAE = '') AND (lrFacAux.CAEC = '') AND (lrFacAux."Respuesta CAE/CAEC" = '') THEN BEGIN
//                   lrFacAux.TRANSFERFIELDS(lrLog,FALSE);
//                   lrFacAux.MODIFY;

//                   lrLogX := lrLog;
//                   lrLogX.VALIDATE(Estado,lrLogX.Estado::"3");
//                   lrLogX.MODIFY;

//                   lCuenta := lCuenta + 1;
//                 END
//                 //+#126073
//                 //... Si ya tenemos los datos de la firma, ponemos el registro en estado de Resuelto.
//                 ELSE BEGIN
//                   lrLogX := lrLog;
//                   lrLogX.VALIDATE(Estado,lrLogX.Estado::"4");
//                   lrLogX.MODIFY;
//                 END;
//                 //-#126073
//               END;
//             END
//             ELSE BEGIN
//               IF lrLog."Tipo documento" = lrLog."Tipo documento"::"3" THEN BEGIN
//                 lrSCMH.RESET;
//                 lrSCMH.SETCURRENTKEY("Pre-Assigned No.");
//                 lrSCMH.SETRANGE("Pre-Assigned No.",lrLog."Nº documento");
//                 IF lrSCMH.FINDFIRST THEN BEGIN
//                   IF NOT lrNCRAux.GET(lrSCMH."No.") THEN BEGIN
//                     lrNCRAux.INIT;
//                     lrNCRAux."No. Documento" := lrSCMH."No.";
//                     lrNCRAux.INSERT;
//                   END;

//                   IF( lrNCRAux.CAE = '') AND (lrNCRAux.CAEC = '') AND (lrNCRAux."Respuesta CAE" = '') THEN BEGIN
//                     lrNCRAux.TRANSFERFIELDS(lrLog,FALSE);
//                     lrNCRAux.MODIFY;

//                     lrLogX := lrLog;
//                     lrLogX.VALIDATE(Estado,lrLogX.Estado::"3");
//                     lrLogX.MODIFY;

//                     lCuenta := lCuenta + 1;
//                   END
//                   //+#126073
//                   //... Si ya tenemos los datos de la firma, ponemos el registro en estado de Resuelto.
//                   ELSE BEGIN
//                     lrLogX := lrLog;
//                     lrLogX.VALIDATE(Estado,lrLogX.Estado::"4");
//                     lrLogX.MODIFY;
//                   END;
//                   //-#126073
//                 END;
//               END;
//             END;
//           UNTIL lrLog.NEXT=0;

//         lWindow.CLOSE;

//         EXIT(lCuenta);
//         */
//         //fes mig

//     end;


//     procedure ObtenerSerieFiscal(lrConfigTPV: Record "Configuracion TPV"; pTipoDocumento: Option Factura,NCR; var vSerie: Code[20])
//     var
//         lrCfgEmpresa: Record "Config. Empresa";
//     begin
//         //+116527
//         //... Pese a la redundancia "controlada", mejor dejar activada esta opción. Realiza el cálculo que debe ser, aunque la serie indicada en el TPV no fuera
//         //... la correcta.
//         if TestSeriesResguardo(lrConfigTPV.Tienda, lrConfigTPV."Id TPV") then begin
//             case pTipoDocumento of
//                 pTipoDocumento::Factura:
//                     if lrConfigTPV."NCF Credito fiscal resguardo" <> '' then
//                         vSerie := lrConfigTPV."NCF Credito fiscal resguardo";

//                 pTipoDocumento::NCR:
//                     if lrConfigTPV."NCF Credito fiscal NCR resg." <> '' then
//                         vSerie := lrConfigTPV."NCF Credito fiscal NCR resg.";
//             end;

//         end
//         else begin
//             case pTipoDocumento of
//                 pTipoDocumento::Factura:
//                     if lrConfigTPV."NCF Credito fiscal habitual" <> '' then
//                         vSerie := lrConfigTPV."NCF Credito fiscal habitual";

//                 pTipoDocumento::NCR:
//                     if lrConfigTPV."NCF Credito fiscal NCR habit." <> '' then
//                         vSerie := lrConfigTPV."NCF Credito fiscal NCR habit.";
//             end;
//         end;
//     end;


//     procedure GestionSeriesNCF()
//     var
//         lrConfigTPV: Record "Configuracion TPV";
//     begin
//         //+116527
//         lrConfigTPV.Reset;
//         if lrConfigTPV.FindFirst then
//             repeat
//                 GestionSeriesNCF_TPV(lrConfigTPV.Tienda, lrConfigTPV."Id TPV");
//             until lrConfigTPV.Next = 0;
//     end;


//     procedure GestionSeriesNCF_TPV(pIdTienda: Code[20]; pIdTPV: Code[20])
//     var
//         lSeriesResguardo: Boolean;
//         lHayCambios: Boolean;
//         lrConfigEmpresa: Record "Config. Empresa";
//         lrConfigTPV: Record "Configuracion TPV";
//     begin
//         //+116527
//         //... Mediante esta función pretendemos asegurar el correcto valor de la redundancia controlada, en los campos de NCF.
//         //... Como los campos con sufijo "habitual", se han creado en último lugar, por si tuvieran un valor VACIO. (Eso en principio, sólo ocurriría al principio de
//         //... haberlos creados), se actualizarán si es necesario.

//         lSeriesResguardo := false;
//         lHayCambios := false;

//         lrConfigTPV.Reset;
//         lrConfigTPV.LockTable;
//         lrConfigTPV.Get(pIdTienda, pIdTPV);

//         //... Situación inicial posible.
//         if lrConfigTPV."NCF Credito fiscal habitual" = '' then begin
//             lHayCambios := true;
//             lrConfigTPV."NCF Credito fiscal habitual" := lrConfigTPV."NCF Credito fiscal";
//         end;

//         if lrConfigTPV."NCF Credito fiscal NCR habit." = '' then begin
//             lHayCambios := true;
//             lrConfigTPV."NCF Credito fiscal NCR habit." := lrConfigTPV."NCF Credito fiscal NCR";
//         end;
//         //....

//         case wSeriesNCF of
//             wSeriesNCF::Calculo:
//                 if TestSeriesResguardo(pIdTienda, pIdTPV) then
//                     lSeriesResguardo := true;

//             wSeriesNCF::Habituales:
//                 lSeriesResguardo := false;
//             wSeriesNCF::Resguardo:
//                 lSeriesResguardo := true;
//         end;

//         if not lSeriesResguardo then begin

//             //... Revisamos la coherencia de "NCF credito fiscal"
//             if lrConfigTPV."NCF Credito fiscal" <> lrConfigTPV."NCF Credito fiscal habitual" then begin
//                 lHayCambios := true;
//                 lrConfigTPV."NCF Credito fiscal" := lrConfigTPV."NCF Credito fiscal habitual";
//             end;

//             //... Revisamos la coherencia de "NCF credito fiscal NCR"
//             if lrConfigTPV."NCF Credito fiscal NCR" <> lrConfigTPV."NCF Credito fiscal NCR habit." then begin
//                 lHayCambios := true;
//                 lrConfigTPV."NCF Credito fiscal NCR" := lrConfigTPV."NCF Credito fiscal NCR habit.";
//             end;

//         end
//         else begin
//             //... Revisamos la coherencia de "NCF credito fiscal"
//             if lrConfigTPV."NCF Credito fiscal" <> lrConfigTPV."NCF Credito fiscal resguardo" then begin
//                 lHayCambios := true;
//                 lrConfigTPV."NCF Credito fiscal" := lrConfigTPV."NCF Credito fiscal resguardo";
//             end;

//             //... Revisamos la coherencia de "NCF credito fiscal NCR"
//             if lrConfigTPV."NCF Credito fiscal NCR" <> lrConfigTPV."NCF Credito fiscal NCR resg." then begin
//                 lHayCambios := true;
//                 lrConfigTPV."NCF Credito fiscal NCR" := lrConfigTPV."NCF Credito fiscal NCR resg.";
//             end;

//         end;

//         if lHayCambios then
//             lrConfigTPV.Modify;
//     end;


//     procedure IndicarSerieNCF(pOpcion: Option Habituales,Resguardo)
//     begin
//         //+#116527
//         //... Indicamos si las series que van a estar activas son las de resguardo o las habituale.
//         case pOpcion of
//             pOpcion::Habituales:
//                 wSeriesNCF := wSeriesNCF::Habituales;
//             pOpcion::Resguardo:
//                 wSeriesNCF := wSeriesNCF::Resguardo;
//         end;
//     end;


//     procedure TestSeriesResguardo(pTienda: Code[20]; pTPV: Code[20]): Boolean
//     var
//         lResult: Boolean;
//     begin
//         //fes mig
//         /*
//         //+116527
//         lResult := FALSE;
//         lrCfgLoc.RESET;
//         lrCfgLoc.SETRANGE("Tipo registro", lrCfgLoc."Tipo registro"::"0");
//         lrCfgLoc.SETRANGE(Tienda, pTienda);
//         lrCfgLoc.SETRANGE("Id TPV", pTPV);
//         IF lrCfgLoc.FINDFIRST THEN
//           IF lrCfgLoc."Series NCF activas" = lrCfgLoc."Series NCF activas"::"1" THEN
//             lResult := TRUE;

//         EXIT(lResult);
//         */
//         //fes mig

//     end;


//     procedure TestSerieDocElectronico(pSerie: Code[20]; pNumComprobante: Code[20]): Boolean
//     var
//         lrNoSeriesLine: Record "No. Series Line";
//         lResult: Boolean;
//     begin
//         //#126073
//         lResult := false;

//         lrNoSeriesLine.Reset;
//         lrNoSeriesLine.SetRange("Series Code", pSerie);
//         lrNoSeriesLine.SetFilter("Starting No.", '<=%1', pNumComprobante);
//         lrNoSeriesLine.SetFilter("Ending No.", '>=%1', pNumComprobante);
//         if lrNoSeriesLine.FindFirst then
//             if lrNoSeriesLine."Tipo Generacion" = lrNoSeriesLine."Tipo Generacion"::"Electrónico" then
//                 lResult := true;

//         exit(lResult);
//     end;


//     procedure Parametros_2(rp_CabVenta: Record "Sales Header"; pNumLog: Integer; pEvitarMensajeFE: Boolean)
//     begin
//         //+126073
//         rGblCabVenta := rp_CabVenta;
//         wNumLog := pNumLog;
//         wModo := wModo::FE;
//         wEvitarMensajeFE := pEvitarMensajeFE;
//     end;


//     procedure LogFirmaEnCentral(pSalesHeader: Record "Sales Header"; pError: Text[1024])
//     var
//         lOk: Boolean;
//         lcLote: Codeunit "Registrar Ventas en Lote DsPOS";
//         TextL001: Label 'Obtención certificado digital sin error para %1';
//         TextL002: Label 'Error: %1';
//         TextL003: Label 'No se configuiió firmar %1';
//     begin
//         //fes mig
//         /*
//         //+#126073
//         //... Registramos el LOG de la firma.
//         //...
//         lcLote.Parametros(wNumLog);

//         IF pError = '' THEN BEGIN
//           lOk := TRUE;
//           //... La siguiente comprobación es por si no se detecta error en la firma (por lo que sea), pero realmente no se han conseguido traer los
//           //... datos de la firma. En este caso, indicamos el error.
//           IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::Invoice THEN BEGIN
//             IF NOT lrAuxFac.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//               lOk := FALSE;
//             END
//             ELSE BEGIN
//               IF (lrAuxFac.CAE = '') AND (lrAuxFac.CAEC = '') THEN
//                 lOk := FALSE;
//             END;
//           END;

//           IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo" THEN BEGIN
//             IF NOT lrAuxNCR.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//               lOk := FALSE;
//             END
//             ELSE BEGIN
//               IF (lrAuxNCR.CAE = '') AND (lrAuxNCR.CAEC = '') THEN
//                 lOk := FALSE;
//             END;
//           END;

//           IF lOk THEN
//             lcLote.InsertarDetalle(pSalesHeader,2,NOT lOk,STRSUBSTNO(TextL001,pSalesHeader."No. Fiscal TPV"))
//           ELSE
//             lcLote.InsertarDetalle(pSalesHeader,2,NOT lOk,STRSUBSTNO(TextL003,pSalesHeader."No. Fiscal TPV"));
//         END
//         ELSE
//           lcLote.InsertarDetalle(pSalesHeader,2,TRUE,STRSUBSTNO(TextL002,pError));
//         */
//         //fes mig

//     end;


//     procedure FirmarRegistrados()
//     var
//         recCabFac: Record "Sales Invoice Header";
//         recCabNC: Record "Sales Cr.Memo Header";
//         lProcesados: Integer;
//         lTotal: Integer;
//         cduPOS: Codeunit "Funciones DsPOS - Comunes";
//         TextL001: Label '<Firmando documentos DsPOS :\\Facturas @@@@@@@@@@@@@@@@@@@@1\Notas de crédito  @@@@@@@@@@@@@@@@@@@@2>';
//         rParametros: Record "Param. CDU DsPOS";
//         lrSalesH: Record "Sales Header";
//         lwProgreso: Dialog;
//         lcGuatEduca: Codeunit "Funciones DsPOS - Guat. Educa";
//         lFechaReferencia: Date;
//     begin
//         //fes mig
//         /*
//         //+#126073

//         lFechaReferencia := TODAY;

//         IF GUIALLOWED THEN
//           lwProgreso.OPEN(TextL001);

//         WITH recCabFac DO BEGIN

//           RESET;
//           SETCURRENTKEY("Posting Date",Tienda,"Venta TPV");
//           SETRANGE("Posting Date"    , lFechaReferencia -31 , lFechaReferencia);
//           SETRANGE("Venta TPV"       , TRUE);
//           SETRANGE("Respuesta CAE"   , FALSE);
//           SETRANGE("Respuesta CAEC"  , FALSE);

//           IF FINDSET THEN BEGIN

//             lTotal      := COUNT;
//             lProcesados := 0;

//             REPEAT

//               CLEARLASTERROR;

//               lrSalesH.INIT;
//               lrSalesH."No."              := "External Document No.";
//               lrSalesH."Document Type"    := lrSalesH."Document Type"::Invoice;
//               lrSalesH."No. Fiscal TPV"    := "No. Fiscal TPV";
//               lrSalesH."Posting Date"     := "Posting Date";
//               lrSalesH.Tienda             := Tienda;
//               lrSalesH.TPV                := TPV;
//               lrSalesH."Posting No."      := "No.";
//               lrSalesH."Last Posting No." := "No.";

//               COMMIT;

//               //... Para poder ejecutar el RUN, lo haremos sobre otra instancia de la CU.
//               lcGuatEduca.Parametros_2(lrSalesH,wNumLog,TRUE);
//               IF lcGuatEduca.RUN THEN
//                 lcGuatEduca.LogFirmaEnCentral(lrSalesH,'')
//               ELSE
//                 lcGuatEduca.LogFirmaEnCentral(lrSalesH,COPYSTR(GETLASTERRORTEXT,1,1024));

//               IF GUIALLOWED THEN BEGIN
//                 lProcesados += 1;
//                 lwProgreso.UPDATE(1, ROUND(lProcesados/lTotal*10000,1));
//               END;

//             UNTIL NEXT = 0;

//           END;
//         END;

//         WITH recCabNC DO BEGIN

//           RESET;
//           SETCURRENTKEY("Posting Date",Tienda,"Venta TPV");
//           SETRANGE("Posting Date"    , lFechaReferencia -31 , lFechaReferencia);
//           SETRANGE("Venta TPV"       , TRUE);
//           SETRANGE("Respuesta CAE"   , FALSE);
//           SETRANGE("Respuesta CAEC"  , FALSE);

//           IF FINDSET THEN BEGIN

//             lTotal      := COUNT;
//             lProcesados := 0;

//             REPEAT

//               CLEARLASTERROR;

//               lrSalesH.INIT;
//               lrSalesH."No."              := "External Document No.";
//               lrSalesH."Document Type"    := lrSalesH."Document Type"::"Credit Memo";
//               lrSalesH."No. Fiscal TPV"    := "No. Fiscal TPV";
//               lrSalesH."Posting Date"     := "Posting Date";
//               lrSalesH.Tienda             := Tienda;
//               lrSalesH.TPV                := TPV;
//               lrSalesH."Posting No."      := "No.";
//               lrSalesH."Last Posting No." := "No.";

//               COMMIT;

//               //... Para poder ejecutar el RUN, lo haremos sobre otra instancia de la CU.
//               lcGuatEduca.Parametros_2(lrSalesH,wNumLog,TRUE);
//               IF lcGuatEduca.RUN THEN
//                 lcGuatEduca.LogFirmaEnCentral(lrSalesH,'')
//               ELSE
//                 lcGuatEduca.LogFirmaEnCentral(lrSalesH,COPYSTR(GETLASTERRORTEXT,1,1024));

//               IF GUIALLOWED THEN BEGIN
//                 lProcesados += 1;
//                 lwProgreso.UPDATE(2, ROUND(lProcesados/lTotal*10000,1));
//               END;

//             UNTIL NEXT = 0;

//           END;
//         END;

//         IF GUIALLOWED THEN
//           lwProgreso.CLOSE;
//         */
//         //fes mig

//     end;


//     procedure TestDocElectronico(lrSH: Record "Sales Header"): Boolean
//     var
//         lResult: Boolean;
//     begin
//         //fes mig
//         /*
//         //+#187632
//         lResult := FALSE;
//         IF lrAux.GET(lrSH."Document Type",lrSH."No.") THEN
//           IF lrAux."Tipo generación" = lrAux."Tipo generación"::"1" THEN
//             lResult := TRUE;
//         EXIT(lResult);
//         */
//         //fes mig

//     end;
// }

