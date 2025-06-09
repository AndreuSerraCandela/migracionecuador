// codeunit 76022 "Funciones DsPOS - Guatemala"
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
//     // #232158 RRT 12.06.2019: Cambios en FE.
//     // #232158b RRT 18.11.2019: Adaptación para que las firmas en los documentos de la empresa <ACTIVA EDUCA> se realicen con la anterior FE.
//     // #328529 RRT 05.08.2020: Gestión de cupones electrónicos.
//     // #336189 RRT 24.09.2020: Error al imprimir en una tienda en línea.

//     Permissions = TableData "Sales Invoice Header" = rimd,
//                   TableData "Sales Cr.Memo Header" = rimd,
//                   TableData TableData51040 = rimd;

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

//             //#+232158
//             //... De momento se plantea firmar solo desde la tienda. Si hay que cambiarlo, quitaremos la condicion IF FALSE THEN..
//             wModo::FE:
//                 if false then
//                     FE(rGblCabVenta);
//         //#-232158

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
//         Text100: Label 'Este documento (%1) ya ha sido enviado electrónicamente';
//         Text101: Label 'Revisar el log del documento %1';
//         Text102: Label 'Revise la llamada a la funcion Factura_DSPOS_20';
//         wEvitarMensajeFE: Boolean;
//         wRollBackSiErrorEnFE: Boolean;
//         wTextoErrorFE: Text[1024];


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
//         //+#232158
//         //... Las series dejan de usarse. No obstante, lo cambio de forma casi reversible, por si acaso...
//         exit;
//         /*
        
//         //+#116527
//         GestionSeriesNCF_TPV(p_Tienda,p_IdTPV);
//         //-#116527
        
//         recTienda.GET(p_Tienda);
        
//         rConfTPV.GET(p_Tienda,p_IdTPV);
//         rConfTPV.TESTFIELD("NCF Credito fiscal");
        
//         IF recTienda."Permite Anulaciones en POS" THEN
//           rConfTPV.TESTFIELD("NCF Credito fiscal NCR");
        
//         //+#116527
//         IF TestSeriesResguardo(p_Tienda,p_IdTPV) THEN BEGIN
//           rConfTPV.TESTFIELD("NCF Credito fiscal resguardo");
//           IF recTienda."Permite Anulaciones en POS" THEN
//             rConfTPV.TESTFIELD("NCF Credito fiscal NCR resg.");
//           END
//         ELSE BEGIN
//           rConfTPV.TESTFIELD("NCF Credito fiscal habitual");
//           IF recTienda."Permite Anulaciones en POS" THEN
//             rConfTPV.TESTFIELD("NCF Credito fiscal NCR habit.");
//         END;
//         //-#116527
        
//         */
//         //-232158

//     end;


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; var p_SalesHeader: Record "Sales Header"): Code[20]
//     var
//         rTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         lSerie: Code[20];
//     begin
//         //+#232158
//         //... Se abandona el uso de las NCF.
//         exit;

//         /*
//         WITH p_SalesHeader DO BEGIN
        
//           rTPV.RESET;
//           rTPV.GET(p_Tienda,p_IdTPV);
        
//           COMMIT;
        
//           CASE "Document Type" OF
//             "Document Type"::Invoice:
//               BEGIN
//                 //+#116527
//                 //EXIT(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal", p_SalesHeader."Posting Date"));
//                 lSerie := cfComunes.ObtenerSerieFiscal(rTPV,0);
//                 EXIT(NoSeriesManagement.TryGetNextNo(lSerie, p_SalesHeader."Posting Date"));
//                 //-#116527
//               END;
        
//             "Document Type"::"Credit Memo":
//               BEGIN
//                 //+#116527
//                 //EXIT(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal NCR", p_SalesHeader."Posting Date"));
//                 lSerie := cfComunes.ObtenerSerieFiscal(rTPV,1);
//                 EXIT(NoSeriesManagement.TryGetNextNo(lSerie, p_SalesHeader."Posting Date"));
//                 //-#116527
//               END;
//           END;
//         END;
//         */
//         //-#232158

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
//                 rClientesTPV."E-Mail" := TextoNet[5].ToString();  //+#232158

//                 rClientesTPV.Insert(false);

//                 "VAT Registration No." := rClientesTPV.Identificacion;
//                 "Bill-to Name" := rClientesTPV.Nombre;
//                 "Bill-to Address" := rClientesTPV.Direccion;
//                 "Sell-to Customer Name" := rClientesTPV.Nombre;
//                 "Sell-to Address" := rClientesTPV.Direccion;
//                 "No. Telefono" := rClientesTPV.Telefono;
//                 "E-Mail" := rClientesTPV."E-Mail"; //+#232158
//                 "External Document No." := "No.";
//                 //+#116527
//                 //"No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal";
//                 //"No. Serie NCF Facturas" := cfComunes.ObtenerSerieFiscal(rConfTPV,0);  //+#232158
//                 //-#116527

//                 ActualizaCupon(p_SalesH);

//                 //+#232158
//                 //... Ya no se usa el número fiscal.
//                 /*
//                 IF ("Nº Fiscal TPV" = '') THEN BEGIN

//                   NoSeriesLine.RESET;
//                   NoSeriesLine.SETRANGE("Series Code"   , "No. Serie NCF Facturas");
//                   NoSeriesLine.SETRANGE("Starting Date" , 0D ,WORKDATE);
//                   NoSeriesLine.SETRANGE(Open,TRUE);
//                   IF NOT NoSeriesLine.FINDLAST THEN
//                     EXIT(Error004);

//                   "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Facturas" , "Posting Date" , TRUE);
//                   "Nº Fiscal TPV"          := "No. Comprobante Fiscal";
//                 END;
//                 */

//                 //+#232158
//                 //... Asignamos el código de registro.
//                 "No. Comprobante Fiscal" := "Posting No.";
//                 "No. Fiscal TPV" := "No. Comprobante Fiscal";
//                 //-#232158

//             end
//             else begin  // DEVOLUCIONES

//                 //+#116527
//                 //"No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//                 //"No. Serie NCF Abonos" := cfComunes.ObtenerSerieFiscal(rConfTPV,1);  //+#232158
//                 //-#116527

//                 //+#232158
//                 //... Con FE2.0 ya no se utilizan series.
//                 /*
//                 NoSeriesLine.RESET;

//                 //+#116527
//                 //NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//                 NoSeriesLine.SETRANGE("Series Code", "No. Serie NCF Abonos");
//                 //-#116527

//                 NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//                 NoSeriesLine.SETRANGE(Open,TRUE);
//                 IF NOT NoSeriesLine.FINDLAST THEN
//                   EXIT(Error004);
//                 */
//                 //-#232158

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

//                 //+#232158
//                 //...
//                 /*
//                 "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Abonos" , "Posting Date" , TRUE);
//                 "Nº Fiscal TPV"          := "No. Comprobante Fiscal";
//                 */

//                 //+#232158
//                 //... Asignamos el código de registro.
//                 "No. Comprobante Fiscal" := "Posting No.";
//                 "No. Fiscal TPV" := "No. Comprobante Fiscal";
//                 //-#232158

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


//     procedure Imprimir(codPrmTienda: Code[20]; codPrmDoc: Code[20]; var vTextoError: Text[1024]): Integer
//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         lrSalesH: Record "Sales Header";
//         TextL001: Label 'Ha ocurrido un error en la facturacion electronica';
//         lResult: Integer;
//         recTienda: Record Tiendas;
//         i: Integer;
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//     begin
//         //fes mig
//         /*
//         //#232158
//         {
//         IF cfComunes.RegistroEnLinea(codPrmTienda) THEN
//           EXIT(TRUE)
//         ELSE
//           EXIT(TRUE)
//         }
        
//         lResult := 0;
//         i :=0;
//         recTienda.GET(codPrmTienda);
//         lrSalesH.RESET;
//         IF NOT cfComunes.RegistroEnLinea(codPrmTienda) THEN BEGIN
//           lrSalesH.SETRANGE("No.",codPrmDoc);
//           IF lrSalesH.FINDFIRST THEN BEGIN
        
//             IF NOT lrLog.GET(lrSalesH."Posting No.") THEN BEGIN
//               vTextoError := TextL001;
//               EXIT(-1);
//             END;
        
//             IF lrLog."Transaction Recibido" <> '' THEN BEGIN
//             // cambio para imprimir directo lrLog.GetPDF;
//                WHILE i < recTienda."Cantidad de Copias Contado" DO
//                 BEGIN
//                   i += 1;
//                    lrLog.PrintPDF;
//                  END;
        
        
//               lResult := 0;
//             END
//             ELSE BEGIN
//               IF lrLog."Numero de Acceso" <> '' THEN
//                BEGIN
        
//                 lrSalesH.RESET;
//                 lrSalesH.SETRANGE("Document Type", lrSalesH."Document Type"::"Credit Memo");
//                 lrSalesH.SETRANGE("No.",codPrmDoc);
//                 IF lrSalesH.FINDFIRST THEN
//                 WHILE i < recTienda."Cantidad copias nota credito"  DO BEGIN
//                   i += 1;
//                    REPORT.RUN(recTienda."ID Reporte nota credito FE",FALSE,FALSE,lrSalesH);
//                 END;
        
        
//                 lrSalesH.RESET;
//                 lrSalesH.SETRANGE("Document Type", lrSalesH."Document Type"::Invoice);
//                 lrSalesH.SETRANGE("No.",codPrmDoc);
//                 IF lrSalesH.FINDFIRST THEN
//                 WHILE i < recTienda."Cantidad de Copias Contado"  DO BEGIN
//                   i += 1;
//                    REPORT.RUN(recTienda."ID Reporte contado FE",FALSE,FALSE,lrSalesH);
//                 END;
        
        
//                 lResult := 1;
//               END
//               ELSE BEGIN
//                 lResult := -1;
//                 IF lrLog."Listado de Errores"  <> '' THEN
//                   vTextoError := lrLog."Listado de Errores"
//                 ELSE
//                   vTextoError := TextL001;
//               END;
//             END;
        
//           END;
//         END
//         ELSE BEGIN
//           //+#336189
//           IF lrSIH.GET(codPrmDoc) THEN BEGIN
        
//             IF NOT lrLog.GET(lrSIH."No.") THEN BEGIN
//               vTextoError := TextL001;
//               EXIT(-1);
//             END;
        
//             IF lrLog."Transaction Recibido" <> '' THEN BEGIN
//             // cambio para imprimir directo lrLog.GetPDF;
//                WHILE i < recTienda."Cantidad de Copias Contado" DO
//                 BEGIN
//                   i += 1;
//                    lrLog.PrintPDF;
//                  END;
        
//               lResult := 0;
//             END
//             ELSE BEGIN
//               IF lrLog."Numero de Acceso" <> '' THEN BEGIN
        
//                 WHILE i < recTienda."Cantidad de Copias Contado"  DO BEGIN
//                   i += 1;
//                    REPORT.RUN(recTienda."ID Reporte contado FE",FALSE,FALSE,lrSIH);
//                 END;
        
//                 lResult := 0;
        
//               END
//               ELSE BEGIN
//                 lResult := -1;
//                 IF lrLog."Listado de Errores"  <> '' THEN
//                   vTextoError := lrLog."Listado de Errores"
//                 ELSE
//                   vTextoError := TextL001;
//               END;
//             END;
        
//           END;
        
//           IF lrSCMH.GET(codPrmDoc) THEN BEGIN
        
//             IF NOT lrLog.GET(lrSCMH."No.") THEN BEGIN
//               vTextoError := TextL001;
//               EXIT(-1);
//             END;
        
//             IF lrLog."Transaction Recibido" <> '' THEN BEGIN
//             // cambio para imprimir directo lrLog.GetPDF;
//                WHILE i < recTienda."Cantidad de Copias Contado" DO
//                 BEGIN
//                   i += 1;
//                    lrLog.PrintPDF;
//                  END;
        
//               lResult := 0;
//             END
//             ELSE BEGIN
//               IF lrLog."Numero de Acceso" <> '' THEN BEGIN
        
//                 WHILE i < recTienda."Cantidad copias nota credito"  DO BEGIN
//                    i += 1;
//                    REPORT.RUN(recTienda."ID Reporte nota credito FE",FALSE,FALSE,lrSCMH);
//                 END;
        
//                 lResult := 0;
        
//               END
//               ELSE BEGIN
//                 lResult := -1;
//                 IF lrLog."Listado de Errores"  <> '' THEN
//                   vTextoError := lrLog."Listado de Errores"
//                 ELSE
//                   vTextoError := TextL001;
//               END;
//             END;
        
//           END;
        
        
//         END;
        
        
//         EXIT(lResult);
//         */
//         //fes mig

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

//         //+#232158
//         /*
//         //+#116527
//         lSerieAbonos := cfComunes.ObtenerSerieFiscal(rConfTPV,1);
//         //-#116527
        
//         //+#116527
//         //pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";
//         pSalesH."No. Serie NCF Abonos" := lSerieAbonos;
//         //-#116527
        
//         NoSeriesLine.RESET;
        
//         //+#116527
//         //NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SETRANGE("Series Code"      , lSerieAbonos);
//         //-#116527
        
//         NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//         NoSeriesLine.SETRANGE(Open,TRUE);
//         IF NOT NoSeriesLine.FINDLAST THEN
//           EXIT(Error004);
//         */
//         //-#232158



//         //+#232158
//         //... Se deja de actualizar el NCF
//         /*
//         //+#116527
//         //pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , pSalesH."Posting Date" , TRUE);
//         pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(lSerieAbonos, pSalesH."Posting Date" , TRUE);
//         //-#116527
//         */
//         //-#232158

//         //+#232158
//         //... Asignamos el código de registro.
//         pSalesH."No. Comprobante Fiscal" := pSalesH."Posting No.";
//         //-#232158

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
//         Cupon   := p_Evento.TextoDato6;
        
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
//         //fes mig
//         /*
//         // Nº de cupon recibido y Nº de Documento
//         Numero_Cupon     := p_Evento.TextoDato6;
//         Numero_Documento := p_Evento.TextoDato3;
        
//         // Buscamos en la tabla 37 Sales Line
//         rSalesLines.RESET;
//         rSalesLines.SETRANGE("Document No."  , Numero_Documento);
//         rSalesLines.SETRANGE("Cod. Cupon"    , Numero_Cupon    );
//         rSalesLines.DELETEALL;
        
//         // Devolvemos el mensaje y la acción para actualizar las lineas
//         p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//         p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(text002, Numero_Cupon);
//         */
//         //fes mig

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
//         rSIH: Record "Sales Invoice Header";
//         rSCMH: Record "Sales Cr.Memo Header";
//     begin
//         //fes mig
//         /*
//         //+#232158
//         //... Se ha restrructurado el código.
//         IF (pSalesHeader."Document Type" = pSalesHeader."Document Type"::Order) OR
//            (pSalesHeader."Document Type" = pSalesHeader."Document Type"::Invoice) THEN
//           IF rSIH.GET(pSalesHeader."Last Posting No.") THEN
//             lcFE20.FacturaElectronica(rSIH);
        
//         IF ( (pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo") OR
//              (pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Return Order") ) AND (NOT pSalesHeader.Correction) THEN
//           IF rSCMH.GET(pSalesHeader."Last Posting No.") THEN
//             lcFE20.NotaCreditoElectronica(rSCMH);
//         */
//         //fes mig

//     end;


//     procedure Linea_LocalizadaOFF(var prOrigen: Record "Sales Line"; var prDestino: Record "Sales Line")
//     begin

//         prDestino."Cod. Cupon" := prOrigen."Cod. Cupon";
//     end;


//     procedure FE_Pos(pSalesHeader: Record "Sales Header"; pRegistroEnLinea: Boolean): Boolean
//     var
//         rSIH: Record "Sales Invoice Header";
//         rSCMH: Record "Sales Cr.Memo Header";
//         lResult: Boolean;
//     begin
//         //fes mig
//         /*
//         //+232158
//         //... Reestructuración de esta función.
//         IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::Invoice THEN BEGIN
//           IF pRegistroEnLinea THEN BEGIN
//             IF pSalesHeader."Last Posting No." <> '' THEN
//               IF rSIH.GET(pSalesHeader."Last Posting No.") THEN
//                 lcFE20.FacturaElectronica(rSIH);
//           END
//           ELSE
//             Factura_DSPos_20(0,pSalesHeader);
//         END;
        
//         IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo" THEN BEGIN
//           IF pRegistroEnLinea THEN BEGIN
//             IF pSalesHeader."Last Posting No." <> '' THEN
//               IF rSCMH.GET(pSalesHeader."Last Posting No.") THEN
//                 lcFE20.NotaCreditoElectronica(rSCMH);
//           END
//           ELSE
//             Factura_DSPos_20(1,pSalesHeader);
//         END;
//         */
//         //fes mig

//     end;


//     procedure Parametros(rp_CabVenta: Record "Sales Header"; pRegistroEnLinea: Boolean)
//     begin
//         //+76946
//         //... Asignamos valor a los parámetros.
//         rGblCabVenta := rp_CabVenta;
//         wRegistroEnLinea := pRegistroEnLinea;
//     end;


//     procedure FinalProcesoRegistro(pNumLog: Integer)
//     var
//         lcGuatEduca: Codeunit "Funciones DsPOS - Guat. Educa";
//     begin
//         //-#232158b
//         //... Se recogen las modificaciones del 18.11.19 para considerar que la FE en <ACTIVA EDUCA> debe ser la anterior.

//         if TestFE20 then begin
//             wNumLog := pNumLog;
//             FirmarRegistrados;
//         end
//         else begin
//             lcGuatEduca.FinalProcesoRegistro(pNumLog);
//         end;
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
//         lrSIH: Record "Sales Invoice Header";
//         lrSCMH: Record "Sales Cr.Memo Header";
//         lCaso: Integer;
//         lcLote: Codeunit "Registrar Ventas en Lote DsPOS";
//         TextL000: Label 'Error: %1';
//         TextL001: Label 'No se pudo relacionar la información FE para %1';
//         TextL002: Label 'No se se ha encontrado información FE para %1';
//         TextL003: Label 'No se configuió firmar %1';
//         TextL004: Label 'Obtención certificado digital sin error para %1';
//     begin
//         //fes mig
//         /*
//         //+#126073
//         //... Registramos el LOG de la firma.
//         //...
//         lcLote.Parametros(wNumLog);
        
//         lCaso := 0;
        
//         IF pError = '' THEN BEGIN
//           lCaso := 1;
        
//           IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::Invoice THEN BEGIN
//             IF lrSIH.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//               lrSIH.CALCFIELDS("Relacion Log FE","Firma realizada FE");
//               IF NOT lrSIH."Relacion Log FE" THEN
//                 lCaso := 2
//               ELSE
//                 IF NOT lrSIH."Firma realizada FE" THEN BEGIN
//                   lCaso := 3;
//                   IF lrLog.GET(lrSIH."No.") THEN BEGIN
//                     IF lrLog."Listado de Errores" <> '' THEN BEGIN
//                       pError := COPYSTR(lrLog."Listado de Errores",1,1024);
//                       lCaso  := 0;
//                     END;
//                   END;
//                 END
//                 ELSE
//                   lCaso := 4;
        
//             END;
//           END;
        
//           IF pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo" THEN BEGIN
//             IF lrSCMH.GET(pSalesHeader."Last Posting No.") THEN BEGIN
//               lrSCMH.CALCFIELDS("Relacion Log FE","Firma realizada FE");
//               IF NOT lrSCMH."Relacion Log FE" THEN
//                 lCaso := 2
//               ELSE
//                 IF NOT lrSCMH."Firma realizada FE" THEN BEGIN
//                   lCaso := 3;
//                   IF lrLog.GET(lrSCMH."No.") THEN BEGIN
//                     IF lrLog."Listado de Errores" <> '' THEN BEGIN
//                       pError := COPYSTR(lrLog."Listado de Errores",1,1024);
//                       lCaso  := 0;
//                     END;
//                   END;
//                 END
//                 ELSE
//                   lCaso := 4;
//             END;
//           END;
//         END;
        
//         CASE lCaso OF
//           0: lcLote.InsertarDetalle(pSalesHeader,2,lCaso <> 4,STRSUBSTNO(TextL000,pError));
//           1: lcLote.InsertarDetalle(pSalesHeader,2,lCaso <> 4,STRSUBSTNO(TextL001,pSalesHeader."No."));
//           2: lcLote.InsertarDetalle(pSalesHeader,2,lCaso <> 4,STRSUBSTNO(TextL002,pSalesHeader."No."));
//           3: lcLote.InsertarDetalle(pSalesHeader,2,lCaso <> 4,STRSUBSTNO(TextL003,pSalesHeader."No."));
//           4: lcLote.InsertarDetalle(pSalesHeader,2,lCaso <> 4,STRSUBSTNO(TextL004,pSalesHeader."No."));
//         END;
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
//         lcGuatemala: Codeunit "Funciones DsPOS - Guatemala";
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
        
//           //+#232158
//           //... Mantenemos estos 2 filtros. De esta forma, nos ajustamos mejor al periodo de transición y no volvemos a enviar electrónicamente los
//           //... documentos de venta ya enviados.
//           SETRANGE("Respuesta CAE"   , FALSE);
//           SETRANGE("Respuesta CAEC"  , FALSE);
        
//           //+#232158
//           //... Cambio en la tabla de referencia.
//           //... Se comprueba que el registro de Log FE haya sido replicado. Se descartan los firmados.
//           SETRANGE("Relacion Log FE"  , TRUE);
//           SETRANGE("Firma realizada FE", FALSE);
//           //-#232158
        
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
//               lcGuatemala.Parametros_2(lrSalesH,wNumLog,TRUE);
//               IF lcGuatemala.RUN THEN
//                 lcGuatemala.LogFirmaEnCentral(lrSalesH,'')
//               ELSE
//                 lcGuatemala.LogFirmaEnCentral(lrSalesH,COPYSTR(GETLASTERRORTEXT,1,1024));
        
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
        
//           //+#232158
//           //... Mantenemos estos 2 filtros. De esta forma, nos ajustamos mejor al periodo de transición y no volvemos a enviar electrónicamente los
//           //... documentos de venta ya enviados.
//           SETRANGE("Respuesta CAE"   , FALSE);
//           SETRANGE("Respuesta CAEC"  , FALSE);
        
//           //+#232158
//           //... Cambio en la tabla de referencia.
//           //... Se comprueba que el registro de Log FE haya sido replicado. Se descartan los firmados.
//           SETRANGE("Relacion Log FE"  , TRUE);
//           SETRANGE("Firma realizada FE", FALSE);
//           //-#232158
        
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
//               lcGuatemala.Parametros_2(lrSalesH,wNumLog,TRUE);
//               IF lcGuatemala.RUN THEN
//                 lcGuatemala.LogFirmaEnCentral(lrSalesH,'')
//               ELSE
//                 lcGuatemala.LogFirmaEnCentral(lrSalesH,COPYSTR(GETLASTERRORTEXT,1,1024));
        
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


//     procedure Factura_DSPos_20(pTipo: Option Factura,NCR; lrSH: Record "Sales Header")
//     begin
//         //fes mig
//         /*
//         //+#232158
//         wTextoErrorFE := '';
        
//         lFE20.EvitarCommit;
//         IF pTipo = pTipo::Factura THEN
//           lFE20.FacturaDsPosElectronica(lrSH)
//         ELSE
//           lFE20.NotaCreditoDsPosElectronica(lrSH);
        
//         IF NOT wRollBackSiErrorEnFE THEN
//           COMMIT;
        
//         //... Si se ha detectado un error, lo notificamos.
//         IF lrLog.GET(lrSH."Posting No.") THEN
//           IF lrLog."Listado de Errores" <>'' THEN BEGIN
//             wTextoErrorFE := lrLog."Listado de Errores";
//             //... El hecho que se devuelva error no tiene que ver con el Rollback, pero si con una notificacion controlada.
//             IF NOT wRollBackSiErrorEnFE THEN
//               ERROR(lrLog."Listado de Errores");
//           END;
//         */
//         //fes mig

//     end;


//     procedure DevolverSiguienteNum(pTienda: Code[20]; pTPV: Code[20]; pSerie: Text; pAnul: Integer): Text
//     var
//         Evento: DotNet ;
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         text001: Label 'NCF Actualizado CORRECTAMENTE';
//         rConfTPV: Record "Configuracion TPV";
//         Serie: Code[20];
//     begin
//         //+#232158
//         //... Dejan de devolverse series NCF. En realidad devolveremos valor en blanco.

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Commit;
//         Evento.TipoEvento := 20;

//         Evento.TextoDato := '0';
//         Evento.TextoDato2 := 'SERIE';

//         Evento.TextoRespuesta := text001;
//         Evento.AccionRespuesta := 'OK';
//         exit(Evento.aXml())
//     end;


//     procedure RollBackSiErrorEnFE()
//     begin
//         //+#232158
//         wRollBackSiErrorEnFE := true;
//     end;


//     procedure FacturacionElectronica(lrSH: Record "Sales Header"; pRegistroEnLinea: Boolean; pRollBackSiError: Boolean): Text[1024]
//     begin
//         //+#232158
//         if pRollBackSiError then
//             RollBackSiErrorEnFE;

//         FE_Pos(lrSH, pRegistroEnLinea);

//         exit(wTextoErrorFE);
//     end;


//     procedure ImprimirPDF(codPrmDoc: Code[20])
//     var
//         TextL001: Label 'Ha ocurrido un error en la facturacion electronica';
//         recCabVta: Record "Sales Header";
//     begin
//         //fes mig
//         /*
//          IF  lrLog.GET(codPrmDoc) THEN
//          BEGIN
//             IF lrLog."Transaction Recibido" <> '' THEN
//                lrLog.PrintPDF;
//            IF lrLog."Numero de Acceso" <>'' THEN
//             BEGIN
//              recCabVta.RESET;
//              recCabVta.SETRANGE("Document Type", recCabVta."Document Type"::"Credit Memo");
//              recCabVta.SETRANGE("No.",codPrmDoc);
//              IF recCabVta.FINDFIRST THEN BEGIN
//                 REPORT.RUN(76023,FALSE,FALSE,recCabVta);
//               END;
//              recCabVta.RESET;
//              recCabVta.SETRANGE("Document Type", recCabVta."Document Type"::Invoice);
//              recCabVta.SETRANGE("No.",codPrmDoc);
//              IF recCabVta.FINDFIRST THEN BEGIN
//                 REPORT.RUN(76024,FALSE,FALSE,recCabVta);
//               END;
//             END;
        
//          END;
//         */
//         //fes mig

//     end;


//     procedure TestFE20(): Boolean
//     var
//         lResult: Boolean;
//     begin
//         //fes mig
//         /*
//         //#232158b
//         //... Determinar si se está utilizando FE 2.0
//         lResult := TRUE;
//         IF lrCfgEle.FINDFIRST THEN BEGIN
//           IF NOT lrCfgEle."Facturacion Electronica Activa" THEN
//             lResult := FALSE;
//         END
//         ELSE
//           lResult := FALSE;
        
//         EXIT(lResult);
//         */
//         //fes mig

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

