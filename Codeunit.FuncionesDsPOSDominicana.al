// codeunit 76018 "Funciones DsPOS - Dominicana"
// {
//     // #103585, #120811:  RRT  17.04.2018    Intentar evitar saltos de NCF, al igual que se hizo para Paraguay (#120811)
//     // #120811  RRT  05.05.2018: El comprobante fiscal también debe rectificarse en las tablas 17 y 21
//     // #70132   RRT  03.07.2018: Poder utilizar un NCR como medio de pago
//     // #136849  RRT  19.07.2018: Asignar valor al campo "Fecha vencimiento NCF"
//     // #244394  RRT  22.07.2019: Excepciones para el cálculo del descuento.
//     // #246468  RRT  25.07.2019: Renumeración de las tablas "Pedidos aparcados" y "Dimensiones POS"
//     // #248158  RRT  08.10.2019: Provocar error en el registro si el RNC no esta activo y el tipo de NCF no es consumidor final.
//     // #312844  RRT  08.05.2020: En el tipo de RNC Credito fiscal, se actuará igual que con el consumidor final.
//     // #332026  RRT  07.10.2020: Gestión de cupones.

//     Permissions = TableData "G/L Entry" = rm,
//                   TableData "Cust. Ledger Entry" = rm,
//                   TableData "Sales Invoice Header" = rm,
//                   TableData "Sales Cr.Memo Header" = rm;

//     trigger OnRun()
//     begin
//     end;

//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rTMPLineas: Record "Sales Line" temporary;


//     procedure VaciaCampos_Pais()
//     var
//         rConfTPV: Record "Configuracion TPV";
//     begin

//         rConfTPV.ModifyAll("NCF Consumidor final", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal", '');
//         rConfTPV.ModifyAll("NCF Regimenes especiales", '');
//         rConfTPV.ModifyAll("NCF Gubernamentales", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal NCR", '');
//     end;


//     procedure Comprobaciones_Iniciales(p_Tienda: Code[20]; p_IdTPV: Code[20])
//     var
//         rConfTPV: Record "Configuracion TPV";
//         recTienda: Record Tiendas;
//     begin

//         rConfTPV.Get(p_Tienda, p_IdTPV);

//         rConfTPV.TestField("NCF Consumidor final");
//         rConfTPV.TestField("NCF Credito fiscal");
//         rConfTPV.TestField("NCF Regimenes especiales");
//         rConfTPV.TestField("NCF Gubernamentales");
//     end;


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; var p_SalesHeader: Record "Sales Header"): Code[20]
//     var
//         rTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//     begin

//         with p_SalesHeader do begin

//             //fes mig "Tipo Comprobante" := "Tipo Comprobante"::"1";

//             rTPV.Reset;
//             rTPV.Get(p_Tienda, p_IdTPV);
//             Commit;

//             case "Document Type" of
//                 "Document Type"::Invoice:
//                     exit(NoSeriesManagement.TryGetNextNo(rTPV."NCF Consumidor final", p_SalesHeader."Posting Date"));
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
//         TextL001: Label 'SIN_ASIGNAR';
//         lTipoRNC: Integer;
//         ErrorL001: Label 'El RNC %1 no ha sido encontrado en el archivo de la DGII. No puede registrarse la venta para este tipo de NCF';
//         ErrorL002: Label 'El RNC %1 ha sido encontrado en el archivo de la DGII pero está marcado como no activo. Debe registrar la venta con el tipo de NCF de consumidor final.';
//         lRNC: Text[50];
//         lAuxRNC: Text[50];
//         lTextoError: Text[250];
//         lImporteDtoPdte: Decimal;
//         ErrorL003: Label 'Esta venta tiene un aprovechamiento del cupón de %1. El máximo aprovechamiento disponible es de %2. Por favor, aplique el cupón de nuevo para actualizar los descuentos.';
//         lDescuento: Decimal;
//         lrSL: Record "Sales Line";
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

//           EVALUATE("Tipo Comprobante" , TextoNet[6].ToString());
//           "Tipo Comprobante" +=1;

//           //+#248158
//           //... Si es consumidor final, no realizamos ninguna comprobación.
//           lRNC:= TextoNet[1].ToString();
//           lAuxRNC := lRNC;
//           Formatear(lRNC,11);
//           EVALUATE(lTipoRNC,TextoNet[6].ToString());

//           //+#312844: Saltamos la comprobación si es CREDITO FISCAL o CONSUMIDOR FINAL.
//           //IF lTipoRNC <> 0 THEN BEGIN
//           IF lTipoRNC > 1 THEN BEGIN
//           //-#312844
//             IF NOT lrCliDescargados.GET(lRNC) THEN
//               EXIT(STRSUBSTNO(ErrorL001,lAuxRNC))
//             ELSE BEGIN
//               IF lrCliDescargados.Estado <> 'ACTIVO' THEN
//                 EXIT(STRSUBSTNO(ErrorL002,lAuxRNC))
//             END;
//           END;
//           //-#248158


//           //+#332026
//           //... Por si acaso, se volvera a validar el uso del cupón....
//           IF p_SalesH."Cod. Cupon" <> '' THEN BEGIN
//             IF ValidacionesCupon(p_SalesH."No.",p_SalesH."Cod. Cupon",lRNC,0,lTextoError,lImporteDtoPdte) THEN BEGIN
//               lDescuento := 0;
//               lrSL.RESET;
//               lrSL.SETRANGE("Document Type",p_SalesH."Document Type");
//               lrSL.SETRANGE("Document No.",p_SalesH."No.");
//               IF lrSL.FINDFIRST THEN
//                 REPEAT
//                   lDescuento := lDescuento + lrSL."Line Discount Amount";
//                 UNTIL lrSL.NEXT=0;

//               IF lDescuento > lImporteDtoPdte THEN
//                 EXIT(STRSUBSTNO(ErrorL003,lDescuento,lImporteDtoPdte));
//             END
//             ELSE
//               EXIT(lTextoError);
//           END;
//           //- #332026

//           IF NOT(Devolucion) THEN BEGIN

//             // Guardamos la Cédula Para Fututos Casos
//             IF rClientesTPV.GET(TextoNet[1].ToString()) THEN
//               rClientesTPV.DELETE;

//             rClientesTPV.INIT;
//             rClientesTPV.Identificacion     := TextoNet[1].ToString();
//             rClientesTPV.Direccion          := TextoNet[2].ToString();
//             rClientesTPV.Nombre             := TextoNet[3].ToString();
//             rClientesTPV.Telefono           := TextoNet[4].ToString();
//             rClientesTPV."Tipo Comprobante" := "Tipo Comprobante";
//             rClientesTPV.INSERT(FALSE);

//             "VAT Registration No."  := rClientesTPV.Identificacion;
//             "Bill-to Name"          := COPYSTR(rClientesTPV.Nombre,1,MAXSTRLEN("Bill-to Name"));
//             "Bill-to Address"       := COPYSTR(rClientesTPV.Direccion,1,MAXSTRLEN("Bill-to Address"));
//             "Sell-to Customer Name" := COPYSTR(rClientesTPV.Nombre,1,MAXSTRLEN("Sell-to Customer Name"));
//             "Sell-to Address"       := COPYSTR(rClientesTPV.Direccion,1,MAXSTRLEN("Sell-to Address"));
//             "No. Telefono"           := COPYSTR(rClientesTPV.Telefono,1,MAXSTRLEN("No. Telefono"));

//             //+#332026
//             IF "Cod. Cupon" <> '' THEN
//               IF lrCupon.GET("Cod. Cupon") THEN BEGIN
//                 IF lrCupon."Nombre Colegio" <> '' THEN
//                   "Nombre Colegio" := lrCupon."Nombre Colegio";

//                 IF lrCupon."Cod. Colegio" <> '' THEN
//                   "Cod. Colegio" := lrCupon."Cod. Colegio";
//               END;
//             //-#332026

//             "External Document No." := "No.";

//             IF ("No. Fiscal TPV" = '') THEN BEGIN

//               CASE "Tipo Comprobante" OF
//                 "Tipo Comprobante"::"1":"No. Serie NCF Facturas" := rConfTPV."NCF Consumidor final";
//                 "Tipo Comprobante"::"2":"No. Serie NCF Facturas"   := rConfTPV."NCF Credito fiscal";
//                 "Tipo Comprobante"::"3":"No. Serie NCF Facturas" := rConfTPV."NCF Regimenes especiales";
//                 "Tipo Comprobante"::"4":"No. Serie NCF Facturas"      := rConfTPV."NCF Gubernamentales";
//               END;

//               NoSeriesLine.RESET;
//               NoSeriesLine.SETRANGE("Series Code"   , "No. Serie NCF Facturas");
//               NoSeriesLine.SETRANGE("Starting Date" , 0D ,WORKDATE);
//               NoSeriesLine.SETRANGE(Open,TRUE);
//               IF NOT NoSeriesLine.FINDLAST THEN
//                 EXIT(Error004);

//               IF "No. Comprobante Fiscal" = '' THEN BEGIN

//                 //+120811
//                 //... NO LO APLICO SI NO SE PRODUCE ERROR DE SALTO DE NUMERACION!!!.
//                 //... Visto los saltos de numeración NCF producidos en Paraguay para el caso de los registros en línea, no los asignamos hasta el final.
//                 //"No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Facturas" , "Posting Date" , TRUE);
//                 //... Se aplica.
//                 IF cfComunes.RegistroEnLinea(Tienda) THEN
//                   "No. Comprobante Fiscal" := TextL001
//                 ELSE
//                   "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Facturas" , "Posting Date" , TRUE);

//                 //-120811
//               END;

//               //+#136849
//               "Ultimo. No. NCF"  := NoSeriesLine."Expiration date";
//               //-#136849

//               "No. Fiscal TPV"          := "No. Comprobante Fiscal";

//             END;

//           END
//           ELSE BEGIN  // DEVOLUCIONES

//             "No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//             NoSeriesLine.RESET;
//             NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//             NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//             NoSeriesLine.SETRANGE(Open,TRUE);
//             IF NOT NoSeriesLine.FINDLAST THEN
//               EXIT(Error004);

//             IF cfComunes.RegistroEnLinea(Tienda) THEN BEGIN
//               rHistCab.GET("Anula a Documento");
//               "No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//             END
//             ELSE BEGIN
//               rCab.SETCURRENTKEY("Posting No.");
//               rCab.SETRANGE("Posting No." , "Anula a Documento");
//               rCab.FINDFIRST;
//               "No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//            END;

//             IF "No. Comprobante Fiscal" = '' THEN BEGIN
//               //+120811
//               //... NO LO APLICO SI NO SE PRODUCE ERROR DE SALTO DE NUMERACION!!!.
//               //... Visto los saltos de numeración NCF producidos en Paraguay para el caso de los registros en línea, no los asignamos hasta el final.
//               //... Se aplica
//               //"No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , "Posting Date" , TRUE);


//               IF cfComunes.RegistroEnLinea(Tienda) THEN
//                 "No. Comprobante Fiscal" := TextL001
//               ELSE
//                 "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , "Posting Date" , TRUE);

//               //-120811
//             END;

//             //+#136849
//             "Ultimo. No. NCF"  := NoSeriesLine."Expiration date";
//             //-#136849

//             "No. Fiscal TPV"          := "No. Comprobante Fiscal";

//           END;

//         END;
//         */
//         //fes mig

//     end;


//     procedure Ejecutar_Accion(var p_Evento: DotNet ; var p_EventoRespuesta: DotNet )
//     begin
//         //+#
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

//         //pSalesH."Nº Fiscal TPV"               := pSalesH."Posting No.";
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

//         rConfTPV.Get(pSalesH.Tienda, pSalesH.TPV);

//         pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//         NoSeriesLine.Reset;
//         NoSeriesLine.SetRange("Series Code", rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//         NoSeriesLine.SetRange(Open, true);
//         if not NoSeriesLine.FindLast then
//             exit(Error004);

//         if pSalesH."No. Comprobante Fiscal" = '' then
//             pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR", pSalesH."Posting Date", true);
//         pSalesH."No. Fiscal TPV" := pSalesH."No. Comprobante Fiscal";

//         if cfComunes.RegistroEnLinea(pSalesH.Tienda) then begin
//             rHistCab.Get(pSalesH."Anula a Documento");
//             pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//         end
//         else begin
//             rCab.SetCurrentKey("Posting No.");
//             rCab.SetRange("Posting No.", pSalesH."Anula a Documento");
//             rCab.FindFirst;
//             pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//         end;
//     end;


//     procedure Devolver_Datos_Localizados(pTipo: Option " ","Consumidor Final","Credito Fiscal","Regimen Especial",Gubernamental; pTienda: Code[20]; pTPV: Code[20]; pDevolucion: Integer): Text
//     var
//         Evento: DotNet ;
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//         text001: Label 'NCF Actualizado CORRECTAMENTE según tipo de cliente';
//     begin

//         if IsNull(Evento) then
//             Evento := Evento.Evento;

//         Commit;
//         Evento.TipoEvento := 20;
//         rConfTPV.Get(pTienda, pTPV);

//         if pDevolucion > 0 then begin
//             Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Credito fiscal NCR", WorkDate);
//             Evento.TextoDato2 := rConfTPV."NCF Credito fiscal NCR";
//         end
//         else begin
//             case pTipo of
//                 pTipo::"Consumidor Final":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Consumidor final", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Consumidor final";
//                     end;
//                 pTipo::"Credito Fiscal":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Credito fiscal", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Credito fiscal";
//                     end;

//                 pTipo::"Regimen Especial":
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Regimenes especiales", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Regimenes especiales";
//                     end;
//                 pTipo::Gubernamental:
//                     begin
//                         Evento.TextoDato := NoSeriesManagement.TryGetNextNo(rConfTPV."NCF Gubernamentales", WorkDate);
//                         Evento.TextoDato2 := rConfTPV."NCF Gubernamentales";
//                     end;
//             end;
//         end;

//         Evento.TextoRespuesta := text001;
//         Evento.AccionRespuesta := 'OK';
//         exit(Evento.aXml())
//     end;


//     procedure Devolver_Tipo_NCF(prTrans: Record "Transacciones TPV"): Code[20]
//     var
//         rSalesInvH: Record "Sales Invoice Header";
//         rSalesCrH: Record "Sales Cr.Memo Header";
//         rSalesH: Record "Sales Header";
//         TipoCF: Option " ","Consumidor Final","Credito Fiscal","Regimen Especial",Gubernamental;
//     begin
//         //fes mig
//         /*
//         TipoCF := 0;

//         IF cfComunes.RegistroEnLinea(prTrans."Cod. tienda") THEN BEGIN
//           CASE prTrans."Tipo Transaccion" OF
//             prTrans."Tipo Transaccion"::Venta:
//               BEGIN
//                 IF rSalesInvH.GET(prTrans."No. Registrado") THEN
//                   TipoCF := rSalesInvH."Tipo Comprobante"
//               END;
//             prTrans."Tipo Transaccion"::Anulacion,
//             prTrans."Tipo Transaccion"::Abono:
//               BEGIN
//                 IF rSalesCrH.GET(prTrans."No. Registrado") THEN
//                   TipoCF := rSalesCrH."Tipo Comprobante";
//               END;
//           END;
//         END
//         ELSE BEGIN
//           rSalesH.RESET;
//           rSalesH.SETRANGE("No." , prTrans."No. Borrador");
//           IF rSalesH.FINDFIRST THEN
//             TipoCF := rSalesH."Tipo Comprobante";
//         END;

//         CASE TipoCF OF
//           TipoCF::"Consumidor Final":EXIT('Cons. Final');
//           TipoCF::"Credito Fiscal":EXIT('Cred. Fiscal');
//           TipoCF::"Regimen Especial":EXIT('Reg. Especial');
//           TipoCF::Gubernamental:EXIT('Gubernamental');
//         END;
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


//     procedure Post_Registrar(var vSalesHeader: Record "Sales Header"; pRegistroEnLinea: Boolean; rConfTPV: Record "Configuracion TPV")
//     var
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         rSIH: Record "Sales Invoice Header";
//         rSCMH: Record "Sales Cr.Memo Header";
//     begin
//         //+120811
//         //... Esta función podría servir para ejecutar una serie de acciones, una vez concluido el registro satisfactorio de la venta.
//         //... De momento, nos limitamos a la acción de "Asignar el número NCF". Sólo se realizará en el caso de registro en linea.

//         //... Si no se está registrando en línea, salimos de la función.
//         if not pRegistroEnLinea then exit;

//         case vSalesHeader."Document Type" of
//             vSalesHeader."Document Type"::Invoice:
//                 begin
//                     if vSalesHeader."Last Posting No." <> '' then
//                         if rSIH.Get(vSalesHeader."Last Posting No.") then begin
//                             rSIH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(vSalesHeader."No. Serie NCF Facturas", rSIH."Posting Date", true);
//                             rSIH."No. Fiscal TPV" := rSIH."No. Comprobante Fiscal";
//                             rSIH.Modify;

//                             vSalesHeader."No. Comprobante Fiscal" := rSIH."No. Comprobante Fiscal";
//                             vSalesHeader."No. Fiscal TPV" := vSalesHeader."No. Comprobante Fiscal";

//                             //... 06.05.2018
//                             Actualizar_NCF_2(rSIH."No.", rSIH."Posting Date", rSIH."No. Comprobante Fiscal");
//                             //...

//                         end;
//                 end;

//             vSalesHeader."Document Type"::"Credit Memo":
//                 begin
//                     if vSalesHeader."Last Posting No." <> '' then
//                         if rSCMH.Get(vSalesHeader."Last Posting No.") then begin
//                             rSCMH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR", rSCMH."Posting Date", true);
//                             rSCMH."No. Fiscal TPV" := rSCMH."No. Comprobante Fiscal";
//                             rSCMH.Modify;

//                             vSalesHeader."No. Comprobante Fiscal" := rSCMH."No. Comprobante Fiscal";
//                             vSalesHeader."No. Fiscal TPV" := vSalesHeader."No. Comprobante Fiscal";

//                             //... 06.05.2018
//                             Actualizar_NCF_2(rSCMH."No.", rSCMH."Posting Date", rSCMH."No. Comprobante Fiscal");
//                             //...

//                         end;
//                 end;
//         end;
//     end;


//     procedure Actualizar_NCF_2(pDocumento: Code[20]; pFecha: Date; pNCF: Code[20])
//     var
//         TextL001: Label 'SIN_ASIGNAR';
//         lrGLEntry: Record "G/L Entry";
//         lrGLEntry_2: Record "G/L Entry";
//         lrMovCli: Record "Cust. Ledger Entry";
//     begin
//         //+#120811
//         //... Se añade la asignación en las tablas 17 y 21 del valor NCF, ya que en la modificación anterior no se tuvo en cuenta.
//         //... Una alternativa a ESTA FUNCION podría ser el asignar el NCF en la CU 76019 - "Ventas-Registrar DsPOS".
//         //... Seguro que sería más adecuado, pero como veo que actualmente funciona bien, lo dejo aquí.
//         //... Así aseguramos mejor que no se produzcan saltos en el NCF, por si se ejecuta un COMMIT inadecuado en CU 76019.
//         //...

//         lrGLEntry_2.LockTable;
//         lrMovCli.LockTable;

//         lrGLEntry.Reset;
//         lrGLEntry.SetCurrentKey("Document No.", "Posting Date");
//         lrGLEntry.SetRange("Document No.", pDocumento);
//         lrGLEntry.SetRange("Posting Date", pFecha);
//         lrGLEntry.SetRange("No. Comprobante Fiscal", TextL001);
//         if lrGLEntry.FindFirst then
//             repeat

//                 lrGLEntry_2 := lrGLEntry;
//                 lrGLEntry_2."No. Comprobante Fiscal" := pNCF;
//                 lrGLEntry_2.Modify;

//                 if lrMovCli.Get(lrGLEntry_2."Entry No.") then begin
//                     if lrMovCli."No. Comprobante Fiscal" = TextL001 then begin
//                         lrMovCli."No. Comprobante Fiscal" := pNCF;
//                         lrMovCli.Modify;
//                     end;
//                 end;

//             until lrGLEntry.Next = 0;
//         //...
//     end;


//     procedure ActDatosPagoPorCompensacion(pDocNCR: Code[20]; var lrPagos: Record "Pagos TPV")
//     var
//         lrNCR: Record "Sales Cr.Memo Header";
//         lrFP_TPV: Record "Formas de Pago";
//         lrPagosAux: Record "Pagos TPV";
//         lOk: Boolean;
//         TextL001: Label 'REG_CAMBIO';
//     begin
//         //+#70132
//         if pDocNCR = '' then
//             exit;

//         lOk := false;

//         if pDocNCR <> TextL001 then begin
//             if lrNCR.Get(pDocNCR) then
//                 lOk := true;
//         end
//         else begin
//             //... Si se trata de un registro de CAMBIO, revisamos si la forma de pago asignada corresponde a NCR de compensación.
//             //... En este cao, cogemos el valor más adecuado.
//             if lrPagos.Cambio then begin
//                 lrPagosAux.Reset;
//                 lrPagosAux.SetCurrentKey("No. Borrador", "Forma pago TPV", Cambio);
//                 lrPagosAux.SetRange("No. Borrador", lrPagos."No. Borrador");
//                 lrPagosAux.SetRange("Forma pago TPV", lrPagos."Forma pago TPV");
//                 lrPagosAux.SetRange(Cambio, false);
//                 lrPagosAux.SetFilter("NCR regis. de compensacion", '<>%1', '');
//                 if lrNCR.FindFirst then
//                     lOk := true;
//             end;
//         end;


//         lrPagos."NCR regis. de compensacion" := '';
//         if lOk then
//             if lrFP_TPV.Get(lrPagos."Forma pago TPV") then
//                 if lrFP_TPV."Tipo Compensacion NC" = lrFP_TPV."Tipo Compensacion NC"::"Sí" then
//                     lrPagos."NCR regis. de compensacion" := lrNCR."No.";
//     end;


//     procedure CalculoDelDescuento(var lrSalesLine: Record "Sales Line"; pRNC: Code[20]; pBloqueado: Boolean; pDescuento: Decimal): Boolean
//     var
//         lrCli: Record Customer;
//         lrCDG: Record "Customer Discount Group";
//         lDescuento: Decimal;
//     begin
//         //+#244394
//         if not pBloqueado then begin
//             if pDescuento <> lrSalesLine."Line Discount %" then begin
//                 lrSalesLine.Validate("Line Discount %", pDescuento);
//                 exit(true);
//             end;
//         end;
//         exit(false);

//         //... Al final se aprovecha el mismo valor del descuento que se visualiza por pantalla.
//         /*
//         IF pRNC <> '' THEN BEGIN
//           lrCli.RESET;
//           lrCli.SETRANGE("VAT Registration No.",pRNC);
//           IF lrCli.FINDFIRST THEN
//             IF lrCli."Customer Disc. Group" <> '' THEN
//               IF lrCDG.GET(lrCli."Customer Disc. Group") THEN BEGIN
//                 lDescuento := ObtenerDescuento(lrCDG.Description);
//                 IF lDescuento >= 0 THEN
//                   lrSalesLine.VALIDATE("Line Discount %",lDescuento);
//               END;

//         END;
//         */

//     end;


//     procedure ObtenerDescuento(pTexto: Text): Decimal
//     var
//         lPos: Integer;
//         lFinal: Boolean;
//         lResult: Decimal;
//         lStrResult: Text[50];
//     begin
//         //+#244394
//         if Evaluate(lResult, pTexto) then
//             exit(lResult)
//         else begin
//             lStrResult := '';
//             lFinal := false;
//             lPos := StrPos(pTexto, '%');
//             while (lPos > 1) and (not lFinal) do begin
//                 lPos := lPos - 1;
//                 if CopyStr(pTexto, lPos, 1) in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] then
//                     lStrResult := CopyStr(pTexto, lPos, 1) + lStrResult
//                 else
//                     lFinal := true;
//             end;
//             if lStrResult <> '' then
//                 if Evaluate(lResult, lStrResult) then
//                     exit(lResult);
//         end;

//         exit(0);
//     end;


//     procedure Formatear(var vRNC: Text[20]; pSize: Integer)
//     var
//         lConta: Integer;
//         lLong: Integer;
//     begin
//         //#258158
//         lLong := StrLen(vRNC);
//         for lConta := lLong + 1 to pSize do
//             vRNC := '0' + vRNC;
//     end;


//     procedure AplicaCupon(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     var
//         lrSH: Record "Sales Header";
//         TextL001: Label 'Cupón %1 aplicado correctamente';
//         lRNC: Text[20];
//         lDescuento: Decimal;
//         lTextoError: Text[250];
//         lImporteDtoPdte: Decimal;
//         lTxtDescuento: Text[10];
//     begin
//         //fes mig
//         /*
//         //+#332026

//         lrSH.GET(lrSH."Document Type"::Invoice,p_Evento.TextoDato3);
//         lrCupon.GET(p_Evento.TextoDato6);

//         lRNC          := '';
//         lTxtDescuento := '0';
//         lDescuento    := 0;

//         IF NOT ISNULL(p_Evento.TextoPais.GetValue(1)) THEN
//           lRNC := p_Evento.TextoPais.GetValue(1);

//         IF NOT ISNULL(p_Evento.TextoPais.GetValue(3)) THEN
//           lTxtDescuento := p_Evento.TextoPais.GetValue(3);

//         IF lTxtDescuento <> '' THEN
//           EVALUATE(lDescuento,lTxtDescuento);

//         IF ValidacionesCupon(lrSH."No.",lrCupon."No. Cupon",lRNC,lDescuento,lTextoError,lImporteDtoPdte) THEN BEGIN
//           ActualizarLineas(lrSH,lrCupon,lImporteDtoPdte);
//           lrSH."Cod. Cupon" := lrCupon."No. Cupon";
//           lrSH."Salesperson Code" := lrCupon."Cod. Vendedor";
//           lrSH.MODIFY;
//           p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//           p_Evento_Respuesta.TextoRespuesta  := STRSUBSTNO(TextL001,lrCupon."No. Cupon");

//         END
//         ELSE BEGIN
//           p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//           p_Evento_Respuesta.TextoRespuesta  := lTextoError;
//         END;
//         */
//         //fes mig

//     end;


//     procedure EliminaCupon(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     var
//         lrSH: Record "Sales Header";
//         lrSL: Record "Sales Line";
//         lNumDoc: Code[20];
//         TextL001: Label 'Se ha desvinculado el cupon %1 de la venta';
//         TextL002: Label 'No se ha encontrado ningún cupón asociado a la venta';
//     begin
//         //+#332026

//         lNumDoc := p_Evento.TextoDato3;
//         lrSH.Get(lrSH."Document Type"::Invoice, lNumDoc);

//         //... Si no hay ningún cupón vinculado, salimos de la función. Notificamos error.
//         if lrSH."Cod. Cupon" = '' then begin
//             p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//             p_Evento_Respuesta.TextoRespuesta := TextL002;
//         end
//         else begin
//             //... Desvinculamos el cupon, en la cabecera y las líneas.
//             lrSH."Cod. Cupon" := '';
//             lrSH.Modify;

//             lrSL.Reset;
//             lrSL.SetRange(lrSL."Document Type", lrSL."Document Type"::Invoice);
//             lrSL.SetRange("Document No.", lNumDoc);
//             if lrSL.FindFirst then
//                 repeat
//                     lrSL.Validate("Line Discount %", 0);
//                     lrSL.Modify(false);
//                 until lrSL.Next = 0;

//             // Devolvemos el mensaje y la acción para actualizar las lineas
//             p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//             p_Evento_Respuesta.TextoRespuesta := StrSubstNo(TextL001, lrSH."Cod. Cupon");

//         end;
//     end;


//     procedure ValidacionesCupon(pDocumento: Code[20]; pCupon: Code[20]; pRNC: Text[20]; pDescuento: Decimal; var vTextoError: Text[250]; var vImporteDtoPdte: Decimal): Boolean
//     var
//         lrSIH: Record "Sales Invoice Header";
//         lrSH: Record "Sales Header";
//         lrSH2: Record "Sales Header";
//         lrSL: Record "Sales Line";
//         lrCV: Record "Sales Header";
//         TextL001: Label 'El cliente con RNC %1 ya tiene un descuento del %2. No puede aplicarse el cupón.';
//         TextL002: Label 'No se ha encontrado el cupon %1.';
//         TextL003: Label 'El uso del cupón está fuera del ámbito de validez (%1..%2)';
//         TextL004: Label 'El cupón %1, ha sido usado ya %3 veces. Está dispuesto para un máximo de %2 usos.';
//         lrSIL: Record "Sales Invoice Line";
//         lContaFR: Integer;
//         lContaFNR: Integer;
//         lImporteFR: Decimal;
//         lImporteFNR: Decimal;
//         TextL005: Label 'El cupón %1, ha sido aprovechado por un importe de descuento de %3. El cupón está configurado para un máximo de %2.';
//         TextL006: Label 'El cupón %1 ha sido configurado sin descuento a aplicar (%2%)';
//         lContaFNR2: Integer;
//         lImporteFNR2: Decimal;
//     begin
//         //fes mig
//         /*
//         //+#332026
//         vTextoError := '';

//         IF pDescuento > 0 THEN BEGIN
//           vTextoError := STRSUBSTNO(TextL001,pRNC,pDescuento);
//           EXIT(FALSE);
//         END;

//         IF NOT lrCupon.GET(pCupon) THEN BEGIN
//           vTextoError := STRSUBSTNO(TextL002,pCupon);
//           EXIT(FALSE);
//         END;

//         IF lrCupon."Descuento a Padres de Familia" <=0 THEN BEGIN
//           vTextoError := STRSUBSTNO(TextL006,pCupon,lrCupon."Descuento a Padres de Familia");
//           EXIT(FALSE);
//         END;

//         lrCV.GET(lrCV."Document Type"::Invoice,pDocumento);

//         IF (lrCV."Posting Date" < lrCupon."Valido Desde") OR (lrCV."Posting Date" > lrCupon."Valido Hasta") THEN BEGIN
//           vTextoError := STRSUBSTNO(TextL003,lrCupon."Valido Desde",lrCupon."Valido Hasta");
//           EXIT(FALSE);
//         END;

//         lrSIH.RESET;
//         //... Quizas haga falta un indice.
//         lrSIH.SETRANGE("Cod. Cupon",pCupon);
//         lContaFR := lrSIH.COUNT;

//         lrSH.RESET;
//         //... Quizas haga falta un indice.
//         lrSH.SETRANGE("Document Type",lrSH."Document Type"::Invoice);
//         lrSH.SETRANGE("Cod. Cupon",pCupon);
//         lrSH.SETRANGE("Venta TPV",FALSE);
//         lrSH.SETRANGE("Pago recibido",TRUE);
//         lContaFNR := lrSH.COUNT;

//         lrSH2.RESET;
//         //... Quizas haga falta un indice.
//         lrSH2.SETRANGE("Document Type",lrSH2."Document Type"::Invoice);
//         lrSH2.SETRANGE("Cod. Cupon",pCupon);
//         lrSH2.SETRANGE("Venta TPV",TRUE);
//         lrSH2.SETRANGE("Registrado TPV",TRUE);
//         lContaFNR2 := lrSH2.COUNT;

//         IF (lContaFR + lContaFNR + lContaFNR2) >= lrCupon."Cantidad Limite" THEN BEGIN
//           vTextoError := STRSUBSTNO(TextL004,pCupon,lrCupon."Cantidad Limite",lContaFR + lContaFNR + lContaFNR2);
//           EXIT(FALSE);
//         END;

//         //Revisamos las facturas registradas.
//         lImporteFR := 0;
//         IF lrSIH.FINDFIRST THEN
//           REPEAT
//             //lrSIH.CALCFIELDS("Invoice Discount Amount");
//             //lImporteFR := lImporteFR + lrSIH."Invoice Discount Amount";
//             lrSIL.RESET;
//             lrSIL.SETRANGE("Document No.",lrSIH."No.");
//             IF lrSIL.FINDFIRST THEN
//               REPEAT
//                 lImporteFR := lImporteFR + lrSIL."Line Discount Amount";
//               UNTIL lrSIL.NEXT=0;

//           UNTIL lrSIH.NEXT=0;

//         //Las facturas no registradas, pagadas.
//         lImporteFNR := 0;
//         IF lrSH.FINDFIRST THEN
//           REPEAT
//             lrSL.RESET;
//             lrSL.SETRANGE("Document Type",lrSH."Document Type");
//             lrSL.SETRANGE("Document No.",lrSH."No.");
//             IF lrSL.FINDFIRST THEN
//               REPEAT
//                 lImporteFNR := lImporteFNR + lrSL."Line Discount Amount";
//               UNTIL lrSL.NEXT=0;

//           UNTIL lrSH.NEXT=0;

//         //Las facturas no registradas provenientes de algún TPV. (Por si vinieran de una futura tienda y no están registradas)
//         lImporteFNR2 := 0;
//         IF lrSH2.FINDFIRST THEN
//           REPEAT
//             lrSL.RESET;
//             lrSL.SETRANGE("Document Type",lrSH2."Document Type");
//             lrSL.SETRANGE("Document No.",lrSH2."No.");
//             IF lrSL.FINDFIRST THEN
//               REPEAT
//                 lImporteFNR2 := lImporteFNR2 + lrSL."Line Discount Amount";
//               UNTIL lrSL.NEXT=0;

//           UNTIL lrSH2.NEXT=0;


//         IF (lImporteFR + lImporteFNR + lImporteFNR2) >= lrCupon."Importe Dto. Limite" THEN BEGIN
//           vTextoError := STRSUBSTNO(TextL005,pCupon,lrCupon."Importe Dto. Limite",lImporteFR + lImporteFNR + lImporteFNR2);
//           EXIT(FALSE);
//         END;

//         vImporteDtoPdte := lrCupon."Importe Dto. Limite" - (lImporteFR + lImporteFNR + lImporteFNR2);

//         EXIT(TRUE);
//         */
//         //fes mig

//     end;


//     procedure ActualizarLineas(lrSH: Record "Sales Header"; pImporteDtoCupon: Decimal)
//     var
//         lrSL: Record "Sales Line";
//         lMax: Decimal;
//         lDto: Decimal;
//         lStatus: Integer;
//         TextL001: Label 'La variable rTMPLineas no esta definida como temporal';
//     begin
//         //fes mig
//         /*
//         //+#332026

//         lMax := pImporteDtoCupon;
//         lDto := lrCupon."Descuento a Padres de Familia";
//         lStatus := 0;

//         //... Si la tabla no esta vacia, pensaremos que no se trata de una instancia temporal.
//         rTMPLineas.RESET;
//         IF rTMPLineas.COUNT > 0 THEN
//           ERROR(TextL001);

//         AjustarDescuento(lrSH."No.",lMax,FALSE,lDto,lStatus);

//         //... Ya hemos realizado el ajuste mediante la variable temporal.
//         IF rTMPLineas.FINDFIRST THEN
//           REPEAT
//             lrSL.GET(rTMPLineas."Document Type",rTMPLineas."Document No.",rTMPLineas."Line No.");
//             lrSL.VALIDATE("Line Discount %" , rTMPLineas."Line Discount %");
//             lrSL.MODIFY(FALSE);
//           UNTIL rTMPLineas.NEXT=0;
//         */
//         //fes mig

//     end;


//     procedure AjustarDescuento(pDocumento: Code[20]; pMax: Decimal; pAjustando: Boolean; var vDto: Decimal; var vStatus: Integer)
//     var
//         lrSL: Record "Sales Line";
//         lSuma: Decimal;
//         lIncremento: Decimal;
//         lDto2: Decimal;
//         TextL001: Label 'La variable rTMPLineas no esta definida como temporal';
//     begin
//         //+#332026
//         rTMPLineas.DeleteAll;

//         lrSL.Reset;
//         lrSL.SetCurrentKey("Document Type", "Document No.");
//         lrSL.SetRange("Document Type", lrSL."Document Type"::Invoice);
//         lrSL.SetRange("Document No.", pDocumento);

//         if lrSL.FindFirst then
//             repeat
//                 rTMPLineas.Init;
//                 rTMPLineas.TransferFields(lrSL, true);
//                 rTMPLineas.Validate("Line Discount %", 0);
//                 rTMPLineas.Insert;
//             until lrSL.Next = 0;

//         lSuma := 0;
//         if rTMPLineas.FindFirst then
//             repeat
//                 rTMPLineas.Validate("Line Discount %", vDto);
//                 rTMPLineas.Modify;
//                 lSuma := lSuma + rTMPLineas."Line Discount Amount";

//             until (rTMPLineas.Next = 0) or (lSuma > pMax);


//         if lSuma > pMax then begin

//             case vStatus of
//                 0:
//                     vDto := vDto - 1;
//                 1:
//                     vDto := vDto - 0.1;
//                 2:
//                     vDto := vDto - 0.01;
//                 3:
//                     vDto := vDto - 0.001;
//                 4:
//                     vDto := vDto - 0.0001;
//                 5:
//                     vDto := vDto - 0.00001;
//             end;

//             if vStatus < 6 then
//                 if vDto >= 0 then
//                     AjustarDescuento(pDocumento, pMax, true, vDto, vStatus);
//         end
//         else begin
//             if pAjustando and (lSuma < pMax) then begin
//                 case vStatus of
//                     0:
//                         vDto := vDto + 1;
//                     1:
//                         vDto := vDto + 0.1;
//                     2:
//                         vDto := vDto + 0.01;
//                     3:
//                         vDto := vDto + 0.001;
//                     4:
//                         vDto := vDto + 0.0001;
//                     5:
//                         begin
//                             //... Se intentará redondear la parte residual examinando las líneas.
//                             AjusteFinal(pMax, lSuma, vDto);
//                             exit;
//                         end;

//                 end;

//                 vStatus := vStatus + 1;

//                 AjustarDescuento(pDocumento, pMax, true, vDto, vStatus);

//             end;

//         end;
//     end;


//     procedure AjusteFinal(pMax: Decimal; pSuma: Decimal; pDto: Decimal)
//     var
//         lFinal: Boolean;
//         lAux: Decimal;
//         lAux2: Decimal;
//         lSuma2: Decimal;
//         lContador: Integer;
//     begin
//         //+#332026
//         lContador := 1;  //... Por si se llegara a alguna interacción infinita.

//         if rTMPLineas.FindFirst then
//             repeat
//                 lFinal := false;
//                 repeat
//                     lContador := lContador + 1;
//                     lAux := rTMPLineas."Line Discount Amount";
//                     rTMPLineas.Validate("Line Discount %", rTMPLineas."Line Discount %" + 0.00001);
//                     lAux2 := rTMPLineas."Line Discount Amount";

//                     lSuma2 := pSuma - lAux + lAux2;
//                     if (lSuma2 >= pSuma) and (lSuma2 <= pMax) then begin
//                         pSuma := lSuma2;
//                         rTMPLineas.Modify;
//                     end
//                     else
//                         lFinal := true;

//                 until (pSuma >= pMax) or lFinal or (lContador >= 500);


//             until (rTMPLineas.Next = 0) or (pSuma >= pMax) or (lContador >= 500);
//     end;


//     procedure CambiarRNC(p_Evento: DotNet ; pIdPedido: Code[20]; pRNC: Code[10]; pBloqueado: Boolean; pDescuento: Decimal): Text
//     var
//         Evento: DotNet ;
//         lrSalesLine: Record "Sales Line";
//         lrSalesHeader: Record "Sales Header";
//         TextL001: Label 'Se ha desvinculado el cupón %1 de la venta al tener el cliente su propio descuento.';
//         lCuponEliminado: Code[20];
//         lResult: Text[1024];
//     begin
//         //#+244394
//         lResult := '';

//         lCuponEliminado := '';

//         //+#332026
//         lrSalesHeader.Get(lrSalesHeader."Document Type"::Invoice, pIdPedido);

//         //Si al cambiar de RNC hubiera un cupón relacionado, el cupón se desvinculará de la venta automáticamente.
//         //En las líneas de venta, se obtendrá el descuento correspondiente, unas líneas más abajo.
//         if pDescuento <> 0 then begin
//             lrSalesHeader.Get(lrSalesHeader."Document Type"::Invoice, pIdPedido);
//             if lrSalesHeader."Cod. Cupon" <> '' then begin
//                 lCuponEliminado := lrSalesHeader."Cod. Cupon";
//                 lrSalesHeader."Cod. Cupon" := '';
//                 lrSalesHeader.Modify;
//             end;
//         end;
//         //-#332026

//         //... Si no hay cupón relacionado, actualizamos las líneas de descuento.
//         //... Por el contrario, si hay cupón, no alteramos los descuentos.
//         //...
//         //... Es decir, una vez introducido el cupón, podemos cambiar el RNC y si no hay descuento asociado a dicho RNC, no alteramos los descuentos introducidos.
//         //...
//         if lrSalesHeader."Cod. Cupon" = '' then begin
//             lrSalesLine.Reset;
//             lrSalesLine.SetCurrentKey("Document No.");
//             lrSalesLine.SetRange("Document No.", pIdPedido);
//             if lrSalesLine.FindFirst then
//                 repeat
//                     if CalculoDelDescuento(lrSalesLine, pRNC, pBloqueado, pDescuento) then
//                         lrSalesLine.Modify;
//                 until lrSalesLine.Next = 0;
//         end;

//         if lCuponEliminado <> '' then
//             lResult := StrSubstNo(TextL001, lCuponEliminado);

//         exit(lResult);
//     end;
// }

