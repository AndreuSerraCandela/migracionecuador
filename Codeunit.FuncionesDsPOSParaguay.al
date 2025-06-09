// codeunit 76026 "Funciones DsPOS - Paraguay"
// {
//     // #45324   FAA  10/02/2016  Se crea la funcionalidad de Cupones en el POS
//     // #120811  RRT  16.02.2018  Intentar evitar saltos de NCF
//     //               17.04.2018  Corrección de un error detectado que hubiera ocurrido en las tiendas que no están en linea.
//     // 
//     // #123105, RRT, 19.04.2018: Renumeración de los objetos de cupones en el rango 56mil.
//     // 
//     // #120811  RRT  05.05.2018: El comprobante fiscal también debe rectificarse en las tablas 17 y 25.
//     // #193222  RRT  21.01.2019: Una venta POS al imprimir se refleja como de contado cuando es de crédito.

//     Permissions = TableData "G/L Entry" = rm,
//                   TableData "Cust. Ledger Entry" = rm,
//                   TableData "Sales Invoice Header" = rm,
//                   TableData "Sales Cr.Memo Header" = rm;

//     trigger OnRun()
//     begin
//     end;


//     procedure VaciaCampos_Pais()
//     var
//         rConfTPV: Record "Configuracion TPV";
//     begin

//         rConfTPV.ModifyAll("NCF Credito fiscal NCR", '');
//         rConfTPV.ModifyAll("NCF Credito fiscal", '');
//     end;


//     procedure Comprobaciones_Iniciales(p_Tienda: Code[20]; p_IdTPV: Code[20])
//     var
//         rConfTPV: Record "Configuracion TPV";
//         rAut: Record "_Autoriz. Manuales TPV BO";
//         text001: Label 'No se han definido Aurotizaciones Manuales para la tienda %1';
//         recNoSeries: Record "No. Series";
//         Error001: Label 'El nº de Serie de Ventas computerizadas esta caducada';
//         rTienda: Record Tiendas;
//     begin

//         rConfTPV.Get(p_Tienda, p_IdTPV);
//         rConfTPV.TestField("NCF Credito fiscal");
//         rTienda.Get(p_Tienda);
//         if rTienda."Permite Anulaciones en POS" then
//             rConfTPV.TestField("NCF Credito fiscal NCR");
//     end;


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; var p_SalesHeader: Record "Sales Header"): Text
//     var
//         rTPV: Record "Configuracion TPV";
//         NoSeriesManagement: Codeunit NoSeriesManagement;
//     begin

//         // Obtenemos el Nº Siguiente de la Serie Fiscal (No aumentamos)
//         // Solo paramostrarlo en POS.

//         rTPV.Reset;
//         rTPV.Get(p_Tienda, p_IdTPV);
//         Commit;
//         case p_SalesHeader."Document Type" of
//             p_SalesHeader."Document Type"::Invoice:
//                 exit(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal", p_SalesHeader."Posting Date"));
//             p_SalesHeader."Document Type"::"Credit Memo":
//                 exit(NoSeriesManagement.TryGetNextNo(rTPV."NCF Credito fiscal NCR", p_SalesHeader."Posting Date"));
//         end;
//     end;


//     procedure Registrar(var p_SalesH: Record "Sales Header"; var p_Evento: DotNet ): Text
//     var
//         Error001: Label 'Debe Espeficiar "Grupo contable cliente" para el cliente %1';
//         Error002: Label 'No Existe Grupo Contable Cliente %1';
//         Error003: Label 'Imposible Modificar Cab. Venta';
//         rClientesTPV: Record "_Clientes TPV";
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         NoSeriesLine: Record "No. Series Line";
//         Error004: Label 'El nº de Autorización esta caducado';
//         cduSan: Codeunit "Funciones Santillana";
//         Error005: Label 'Nº de Autoriación no puede ser blanco para serie %1';
//         Error006: Label 'El Nº de Factura Manual debe ser superior o igual a %1';
//         Error007: Label 'El Nº de Factura Manual debe ser inferior o igual a %1';
//         SalesLine: Record "Sales Line";
//         intNoInicioSerie: Integer;
//         intNoFinalSerie: Integer;
//         intFactura: Integer;
//         TextoNet: array[10] of DotNet String;
//         i: Integer;
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rCab: Record "Sales Header";
//         rHistCab: Record "Sales Invoice Header";
//         TextL001: Label 'SIN_ASIGNAR';
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

//         IF NOT(p_SalesH.Devolucion) THEN BEGIN

//           p_SalesH."Tipo Documento Libro" := p_SalesH."Tipo Documento Libro"::"1";

//           // Guardamos la Cédula Para Fututos Casos
//           IF rClientesTPV.GET(TextoNet[1].ToString()) THEN
//             rClientesTPV.DELETE;

//           rClientesTPV.INIT;
//           rClientesTPV.Identificacion := TextoNet[1].ToString();
//           rClientesTPV.Direccion      := TextoNet[2].ToString();
//           rClientesTPV.Nombre         := TextoNet[3].ToString();
//           rClientesTPV.Telefono       := TextoNet[4].ToString();
//           rClientesTPV.INSERT(FALSE);

//           p_SalesH."VAT Registration No." := rClientesTPV.Identificacion;
//           p_SalesH."Bill-to Name"         := rClientesTPV.Nombre;
//           p_SalesH."Bill-to Address"      := rClientesTPV.Direccion;
//           p_SalesH."No. Telefono"          := rClientesTPV.Telefono;

//           ActualizaCupon(p_SalesH); //#45324

//           IF (p_SalesH."No. Fiscal TPV" = '') THEN BEGIN

//             p_SalesH."No. Serie NCF Facturas"  := rConfTPV."NCF Credito fiscal";

//             NoSeriesLine.RESET;
//             NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal");
//             NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//             NoSeriesLine.SETFILTER("Fecha Caducidad" , '>=%1|%2',WORKDATE,0D);
//             NoSeriesLine.SETRANGE(Open,TRUE);
//             IF NoSeriesLine.FINDLAST THEN BEGIN
//               IF NoSeriesLine."No. Autorizacion" = '' THEN
//                 EXIT(STRSUBSTNO(Error005,NoSeriesLine."Series Code"))
//               ELSE BEGIN
//                 p_SalesH."Establecimiento Factura"      := NoSeriesLine.Establecimiento;
//                 p_SalesH."Punto de Emision Factura"     := NoSeriesLine."Punto de Emision";
//                 p_SalesH."No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
//                 p_SalesH."Tipo de Comprobante"          := NoSeriesLine."Tipo Comprobante";
//               END;
//             END
//             ELSE
//               EXIT(Error004);

//             //+120811 - 17.04.2018
//             //... En el siguiente código se hacía referencia a "NCF credito fiscal NCR" en lugar de "NCF Credito fiscal".
//             //... Como no se publicó la actualiación para las tiendas, no ocurrió ningún error.
//             //-120811

//             //+120811
//             //... Visto los saltos de numeración NCF producidos en el caso de los registros en línea, no los asignamos hasta el final.
//             //p_SalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal" , p_SalesH."Posting Date" , TRUE);
//             IF cfComunes.RegistroEnLinea(p_SalesH.Tienda) THEN
//               p_SalesH."No. Comprobante Fiscal" := TextL001
//             ELSE
//               p_SalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal" , p_SalesH."Posting Date" , TRUE);
//             //-120811

//             p_SalesH."No. Fiscal TPV"          := p_SalesH."No. Comprobante Fiscal";

//           END;

//         END
//         ELSE BEGIN  // DEVOLUCIONES

//           p_SalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//           NoSeriesLine.RESET;
//           NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//           NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//           NoSeriesLine.SETFILTER("Fecha Caducidad" , '>=%1|%2',WORKDATE,0D);
//           NoSeriesLine.SETRANGE(Open,TRUE);
//           IF NoSeriesLine.FINDLAST THEN BEGIN
//             IF NoSeriesLine."No. Autorizacion" = '' THEN
//               EXIT(STRSUBSTNO(Error005,NoSeriesLine."Series Code"))
//             ELSE BEGIN
//               p_SalesH."Establecimiento Factura"      := NoSeriesLine.Establecimiento;
//               p_SalesH."Punto de Emision Factura"     := NoSeriesLine."Punto de Emision";
//               p_SalesH."No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
//               p_SalesH."Tipo de Comprobante"          := NoSeriesLine."Tipo Comprobante";
//             END;
//           END
//           ELSE
//             EXIT(Error004);

//           IF cfComunes.RegistroEnLinea(p_SalesH.Tienda) THEN BEGIN
//             rHistCab.GET(p_SalesH."Anula a Documento");
//             p_SalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//             RetrocedeCupon(p_SalesH."Anula a Documento",TRUE,p_SalesH."No."); //#45324
//           END
//           ELSE BEGIN
//             rCab.SETCURRENTKEY("Posting No.");
//             rCab.SETRANGE("Posting No." , p_SalesH."Anula a Documento");
//             rCab.FINDFIRST;
//             p_SalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//          END;

//           //+120811
//           //... Visto los saltos de numeración NCF producidos en el caso de los registros en línea, no los asignamos hasta el final.
//           //p_SalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , p_SalesH."Posting Date" , TRUE);
//           IF cfComunes.RegistroEnLinea(p_SalesH.Tienda) THEN
//             p_SalesH."No. Comprobante Fiscal" := TextL001
//           ELSE
//             p_SalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , p_SalesH."Posting Date" , TRUE);
//           //-120811

//           p_SalesH."No. Fiscal TPV" := p_SalesH."No. Comprobante Fiscal";

//         END;
//         */
//         //fes mig

//     end;


//     procedure Ejecutar_Accion(var p_Evento: DotNet ; var p_EventoRespuesta: DotNet )
//     begin
//         //#45324
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
//     end;


//     procedure AnularFactura(var pSalesH: Record "Sales Header"): Text
//     var
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         NoSeriesLine: Record "No. Series Line";
//         Error004: Label 'El nº de Autorización esta caducado';
//         Error005: Label 'Nº de Autoriación no puede ser blanco para serie %1';
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rHistCab: Record "Sales Invoice Header";
//         rCab: Record "Sales Header";
//     begin
//         //fes mig
//         /*
//         rConfTPV.GET(pSalesH.Tienda,pSalesH.TPV);

//         pSalesH."Tipo Documento Libro" := pSalesH."Tipo Documento Libro"::"3";
//         pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//         NoSeriesLine.RESET;
//         NoSeriesLine.SETRANGE("Series Code"      , rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SETRANGE("Starting Date"    , 0D ,WORKDATE);
//         NoSeriesLine.SETFILTER("Fecha Caducidad" , '>=%1|%2',WORKDATE,0D);
//         NoSeriesLine.SETRANGE(Open,TRUE);
//         IF NoSeriesLine.FINDLAST THEN BEGIN
//           IF NoSeriesLine."No. Autorizacion" = '' THEN
//             EXIT(STRSUBSTNO(Error005,NoSeriesLine."Series Code"))
//           ELSE BEGIN
//             pSalesH."Establecimiento Factura"      := NoSeriesLine.Establecimiento;
//             pSalesH."Punto de Emision Factura"     := NoSeriesLine."Punto de Emision";
//             pSalesH."No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
//             pSalesH."Tipo de Comprobante"          := NoSeriesLine."Tipo Comprobante";
//           END;
//         END
//         ELSE
//           EXIT(Error004);

//         pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR" , pSalesH."Posting Date" , TRUE);
//         pSalesH."No. Fiscal TPV"          := pSalesH."No. Comprobante Fiscal";

//         IF cfComunes.RegistroEnLinea(pSalesH.Tienda) THEN BEGIN
//           rHistCab.GET(pSalesH."Anula a Documento");
//           pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//           pSalesH."Cod. Cupon"                  := rHistCab."Cod. Cupon";  //#45324
//           RetrocedeCupon(pSalesH."Anula a Documento",TRUE,pSalesH."No.");  //#45324

//         END
//         ELSE BEGIN
//           rCab.SETCURRENTKEY("Posting No.");
//           rCab.SETRANGE("Posting No." , pSalesH."Anula a Documento");
//           rCab.FINDFIRST;
//           pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//           pSalesH."Cod. Cupon"                  := rCab."Cod. Cupon";       //#45324
//           RetrocedeCupon(pSalesH."Anula a Documento",FALSE,pSalesH."No.");  //#45324

//         END;
//         */
//         //fes mig

//     end;


//     procedure Devolver_NCF(prTrans: Record "Transacciones Caja TPV"; IncluyeTodo: Boolean): Text
//     var
//         cfComunes: Codeunit "Funciones DsPOS - Comunes";
//         rSalesInvH: Record "Sales Invoice Header";
//         rSalesCrH: Record "Sales Cr.Memo Header";
//         rSalesH: Record "Sales Header";
//         recTPV: Record "Configuracion TPV";
//         CduPOS: Codeunit "Funciones Addin DSPos";
//     begin

//         recTPV.Reset;
//         recTPV.SetCurrentKey("Usuario windows");
//         recTPV.SetRange("Usuario windows", CduPOS.TraerUsuarioWindows);

//         if cfComunes.RegistroEnLinea(prTrans."Cod. tienda") or not (recTPV.FindFirst) then begin
//             case prTrans."Tipo transaccion" of
//                 prTrans."Tipo transaccion"::"Cobro TPV":
//                     begin
//                         if rSalesInvH.Get(prTrans."No. Registrado") then
//                             if IncluyeTodo then
//                                 exit(rSalesInvH."Establecimiento Factura" + '-' +
//                                      rSalesInvH."Punto de Emision Factura" + '-' +
//                                      rSalesInvH."No. Comprobante Fiscal")
//                             else
//                                 exit(rSalesInvH."No. Comprobante Fiscal");
//                     end;
//                 prTrans."Tipo transaccion"::Anulacion:
//                     begin
//                         if rSalesCrH.Get(prTrans."No. Registrado") then
//                             if IncluyeTodo then
//                                 exit(rSalesCrH."Establecimiento Factura" + '-' +
//                                      rSalesCrH."Punto de Emision Factura" + '-' +
//                                      rSalesCrH."No. Comprobante Fiscal")
//                             else
//                                 exit(rSalesCrH."No. Comprobante Fiscal");
//                     end;
//             end;
//         end
//         else begin
//             rSalesH.Reset;
//             rSalesH.SetCurrentKey("Posting No.");
//             rSalesH.SetRange("Posting No.", prTrans."No. Registrado");
//             if rSalesH.FindFirst then
//                 if IncluyeTodo then
//                     exit(rSalesH."Establecimiento Factura" + '-' +
//                          rSalesH."Punto de Emision Factura" + '-' +
//                          rSalesH."No. Comprobante Fiscal")
//                 else
//                     exit(rSalesH."No. Comprobante Fiscal");
//         end;

//         exit('');
//     end;


//     procedure Ventas_Registrar_Localizado(var GenGnjLine: Record "Gen. Journal Line"; pSalesH: Record "Sales Header")
//     begin

//         with GenGnjLine do begin
//             Establecimiento := pSalesH."Establecimiento Factura";
//             "Punto de Emision" := pSalesH."Punto de Emision Factura";
//             "Tipo de Comprobante" := pSalesH."Tipo de Comprobante";
//             "No. Autorizacion Comprobante" := pSalesH."No. Autorizacion Comprobante";
//             "Fecha Caducidad" := pSalesH."Fecha Caducidad Comprobante";
//             "No. Comprobante Fiscal" := pSalesH."No. Fiscal TPV";
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


//     procedure Fue_Venta_Credito(pNumVenta: Code[20]): Boolean
//     var
//         rCab: Record "Sales Header";
//         rHistCab: Record "Sales Invoice Header";
//         rPagos: Record "Pagos TPV";
//         wTotalPagos: Decimal;
//     begin

//         if rCab.Get(rCab."Document Type"::Invoice, pNumVenta) then begin
//             rCab.CalcFields("Amount Including VAT");
//             rPagos.SetRange("No. Borrador", rCab."No.");
//             if rPagos.FindSet then
//                 repeat
//                     wTotalPagos += rPagos."Importe (DL)";
//                 until rPagos.Next = 0;
//             exit(wTotalPagos < rCab."Amount Including VAT");
//         end
//         else
//             if rHistCab.Get(pNumVenta) then begin
//                 rHistCab.CalcFields("Amount Including VAT");
//                 rPagos.SetCurrentKey("No. Factura", "Cod. divisa");
//                 rPagos.SetRange("No. Factura", rHistCab."No.");
//                 if rPagos.FindSet then
//                     repeat
//                         wTotalPagos += rPagos."Importe (DL)";
//                     until rPagos.Next = 0;
//                 exit(wTotalPagos < rHistCab."Amount Including VAT"); //#+193222 - En lugar de rHistCab, ponía rCab
//             end;

//         exit(false);
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
//         rLinCupon: Record "Lin. Cupon.";
//         rCab: Record "Sales Header";
//         rLinOrigen: Record "Sales Line";
//         rCabFac: Record "Sales Invoice Header";
//         rLinOrigenFac: Record "Sales Invoice Line";
//     begin

//         if pOnLine then begin
//             rLin.Reset;
//             rLin.SetRange("Document Type", rLin."Document Type"::"Credit Memo");
//             rLin.SetRange("Document No.", pDocAnula);
//             if rLin.FindFirst then begin
//                 repeat
//                     rLinOrigenFac.Reset;
//                     rLinOrigenFac.SetRange("Document No.", pDocOrigen);
//                     rLinOrigenFac.SetRange("No.", rLin."No.");
//                     if rLinOrigenFac.FindFirst then begin
//                         repeat
//                             if rLinOrigenFac."Cod. Cupon" <> '' then begin
//                                 if rLinCupon.Get(rLinOrigenFac."Cod. Cupon", rLin."No.") then begin
//                                     rLinCupon."Cantidad Pendiente" += rLin.Quantity;
//                                     rLinCupon.Modify(false);
//                                 end;
//                             end;
//                         until rLinOrigenFac.Next = 0;
//                     end;
//                 until rLin.Next = 0;
//             end;
//         end
//         else begin
//             rLin.Reset;
//             rLin.SetRange("Document Type", rLin."Document Type"::"Credit Memo");
//             rLin.SetRange("Document No.", pDocAnula);
//             if rLin.FindFirst then begin
//                 rCab.Reset;
//                 rCab.SetCurrentKey("Posting No.");
//                 rCab.SetRange("Posting No.", pDocOrigen);
//                 if not rCab.FindFirst then
//                     exit;
//                 repeat
//                     rLinOrigen.Reset;
//                     rLinOrigen.SetRange("Document Type", rLinOrigen."Document Type"::Invoice);
//                     rLinOrigen.SetRange("Document No.", rCab."No.");
//                     rLinOrigen.SetRange("No.", rLin."No.");
//                     if rLinOrigen.FindFirst then begin
//                         repeat
//                             if rLinOrigen."Cod. Cupon" <> '' then begin
//                                 if rLinCupon.Get(rLinOrigen."Cod. Cupon", rLin."No.") then begin
//                                     rLinCupon."Cantidad Pendiente" += rLin.Quantity;
//                                     rLinCupon.Modify(false);
//                                 end;
//                             end;
//                         until rLinOrigen.Next = 0;
//                     end;
//                 until rLin.Next = 0;
//             end;
//         end;
//     end;


//     procedure AplicaCupon(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     var
//         rCabCupon: Record "Cab. Cupon.";
//         rCabCupon2: Record "Cab. Cupon.";
//         rLinCupon: Record "Lin. Cupon.";
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

//         Cupon := p_Evento.TextoDato6;

//         if rCabCupon.Get(Cupon) then begin

//             if (rCabCupon.Impreso) and (WorkDate >= rCabCupon."Valido Desde") and (WorkDate <= rCabCupon."Valido Hasta") and
//                (rCabCupon.Anulado = false) then begin

//                 rLinCupon.Reset;
//                 rLinCupon.SetRange("No. Cupon", Cupon);
//                 rLinCupon.SetFilter("Cantidad Pendiente", '>%1', 0);

//                 if rLinCupon.FindSet then begin

//                     NoLinea := 0;

//                     rSalesLine.Reset;
//                     rSalesLine.SetRange("Document Type", rSalesLine."Document Type"::Invoice);
//                     rSalesLine.SetRange("Document No.", p_Evento.TextoDato3);
//                     if rSalesLine.FindSet then
//                         repeat

//                             NoLinea := rSalesLine."Line No.";

//                             if rSalesLine."Cod. Cupon" = Cupon then begin
//                                 p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                                 p_Evento_Respuesta.TextoRespuesta := StrSubstNo(error004, Cupon);
//                                 exit;
//                             end;

//                             if (rSalesLine."Cod. Cupon" <> '') and
//                                (rSalesLine."Cod. Cupon" <> rCabCupon."No. Cupon") then begin
//                                 rCabCupon2.Reset;
//                                 rCabCupon2.Get(rSalesLine."Cod. Cupon");
//                                 if rCabCupon."Cod. Colegio" <> rCabCupon2."Cod. Colegio" then begin
//                                     p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                                     p_Evento_Respuesta.TextoRespuesta := StrSubstNo(error005, Cupon);
//                                     exit;
//                                 end;
//                             end;

//                         until rSalesLine.Next = 0;

//                     repeat
//                         if rLinCupon."Cantidad Pendiente" > 0 then begin
//                             NoLinea += 10000;

//                             rSalesLine.Reset;
//                             rSalesLine.Init;
//                             rSalesLine.Validate("Document Type", rSalesLine."Document Type"::Invoice);
//                             rSalesLine.Validate("Document No.", p_Evento.TextoDato3);
//                             rSalesLine.Validate("Line No.", NoLinea);
//                             rSalesLine.Validate(Type, rSalesLine.Type::Item);
//                             rSalesLine.Validate("No.", rLinCupon."Cod. Producto");

//                             if rLinCupon.Cantidad > 0 then
//                                 rSalesLine.Validate(Quantity, rLinCupon.Cantidad)
//                             else
//                                 rSalesLine.Validate(Quantity, 1);

//                             rSalesLine.Validate("Line Discount %", rLinCupon."% Descuento");
//                             rSalesLine."Cod. Cupon" := Cupon;
//                             rSalesLine.Insert(true);
//                         end;
//                     until rLinCupon.Next = 0;

//                     rSalesH.Get(rSalesLine."Document Type"::Invoice, p_Evento.TextoDato3);
//                     with rSalesH do begin
//                         "Cod. Cupon" := Cupon;
//                         "Salesperson Code" := rCabCupon."Cod. Promotor";
//                         Modify(false);
//                     end;

//                     p_Evento_Respuesta.AccionRespuesta := 'Actualizar_Lineas';
//                     p_Evento_Respuesta.TextoRespuesta := StrSubstNo(text001, Cupon);

//                 end
//                 else begin
//                     p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                     p_Evento_Respuesta.TextoRespuesta := StrSubstNo(error003, Cupon);
//                 end;

//             end
//             else begin
//                 p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//                 p_Evento_Respuesta.TextoRespuesta := StrSubstNo(error001, Cupon);
//             end;

//         end
//         else begin
//             p_Evento_Respuesta.AccionRespuesta := 'ERROR';
//             p_Evento_Respuesta.TextoRespuesta := StrSubstNo(error002, Cupon);
//         end;
//     end;


//     procedure Linea_LocalizadaOFF(var prOrigen: Record "Sales Line"; var prDestino: Record "Sales Line")
//     begin

//         prDestino."Cod. Cupon" := prOrigen."Cod. Cupon";
//     end;


//     procedure ActualizaCupon(pSalesH: Record "Sales Header")
//     var
//         rLinCupon: Record "Lin. Cupon.";
//         CantidadPendiente: Integer;
//         rSalesLines: Record "Sales Line";
//     begin

//         rSalesLines.Reset;
//         rSalesLines.SetRange("Document Type", pSalesH."Document Type");
//         rSalesLines.SetRange("Document No.", pSalesH."No.");
//         rSalesLines.SetRange(Type, rSalesLines.Type::Item);
//         if rSalesLines.FindSet then
//             repeat
//                 if rSalesLines."Cod. Cupon" <> '' then begin
//                     if rLinCupon.Get(rSalesLines."Cod. Cupon", rSalesLines."No.") then begin
//                         rLinCupon."Cantidad Pendiente" -= rSalesLines.Quantity;
//                         if rLinCupon."Cantidad Pendiente" <= 0 then
//                             rLinCupon."Cantidad Pendiente" := 0;
//                         rLinCupon.Modify;
//                     end;
//                 end;
//             until rSalesLines.Next = 0;
//     end;


//     procedure ExcepcionIva(var p_Evento: DotNet ; var p_Evento_Respuesta: DotNet )
//     begin
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
//                             rSIH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal", rSIH."Posting Date", true);
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
//         //... Se añade la asignación en las tablas 17 y 25 del valor NCF, ya que en la modificación anterior no se tuvo en cuenta.
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
// }

