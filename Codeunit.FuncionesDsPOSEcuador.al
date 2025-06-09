// codeunit 76020 "Funciones DsPOS - Ecuador"
// {
//     // #355717, RRT, 21.01.2021. Se introduce la funcionalidad de los cupones.
//     // #380380, RRT, 11.05.2021. En ocasiones no se estaba validando el valor RUC con el tipo de documento correcto.
//     // #373762, RRT, 09.04.2021. Aplicar descuentos automáticos por la forma de pago.
//     // #410299, RRT, 10.09.2021. Modificar el valor del campo "Fact.-a Nombre" a CONSUMIDOR FINAL, si el RUC es 9999999999999, para su aceptacion por SRI.


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


//     procedure Nueva_Venta(p_Tienda: Code[20]; p_IdTPV: Code[20]; p_Cajero: Code[20]; var p_SalesHeader: Record "Sales Header"): Code[20]
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
//         rNIT: Record "Clientes TPV";
//         rConfTPV: Record "Configuracion TPV";
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         NoSeriesLine: Record "No. Series Line";
//         Error004: Label 'El nº de Autorización esta caducado';
//         cduSan: Codeunit "Funciones Santillana";
//         Error005: Label 'Nº de Autorización no puede ser blanco para serie %1';
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
//         Error008: Label 'Establecimiento no puede ser blanco para serie %1';
//         Error009: Label 'Punto de Emision no puede ser blanco para serie %1';
//         lrCfgSales: Record "Sales & Receivables Setup";
//         lSerieEnvios: Code[20];
//         lMensaje: Text[250];
//         lcFunEcuador: Codeunit "Funciones Ecuador";
//     begin

//         i := 1;
//         while i <= (p_Evento.TextoPais.Length - 1) do begin
//             TextoNet[i] := p_Evento.TextoPais.GetValue(i);
//             if IsNull(TextoNet[i]) then
//                 TextoNet[i] := '';
//             i += 1;
//         end;

//         //+#355717
//         if lrCfgSales.FindFirst then
//             if lrCfgSales."Posted Shipment Nos." <> '' then
//                 lSerieEnvios := lrCfgSales."Posted Shipment Nos.";
//         //-#355717

//         rConfTPV.Get(p_Evento.TextoDato, p_Evento.TextoDato2);

//         if not (p_SalesH.Devolucion) then begin

//             // Guardamos la Cédula Para futuros Casos
//             if rNIT.Get(TextoNet[1].ToString()) then
//                 rNIT.Delete;

//             rNIT.Init;
//             rNIT.Identificacion := TextoNet[1].ToString();
//             rNIT.Direccion := TextoNet[2].ToString();
//             rNIT.Nombre := TextoNet[3].ToString();
//             rNIT.Telefono := TextoNet[4].ToString();
//             rNIT."E-Mail" := TextoNet[5].ToString();
//             Evaluate(rNIT."Tipo ID", TextoNet[6].ToString());
//             rNIT."Tipo ID" += 1;

//             //+#380380
//             lMensaje := ValidaIDCliente(rNIT.Identificacion, rNIT."Tipo ID");
//             if lMensaje <> '' then
//                 exit(lMensaje);
//             //-#380380

//             rNIT.Insert(false);

//             p_SalesH."VAT Registration No." := rNIT.Identificacion;
//             p_SalesH."Bill-to Name" := rNIT.Nombre;
//             p_SalesH."Bill-to Address" := rNIT.Direccion;
//             p_SalesH."No. Telefono" := rNIT.Telefono;
//             p_SalesH."E-Mail" := rNIT."E-Mail";

//             //+#355717
//             p_SalesH."Tipo Documento SrI" := p_SalesH."Tipo Documento SrI"::RUC;
//             case rNIT."Tipo ID" of
//                 4:
//                     p_SalesH."Tipo Documento SrI" := p_SalesH."Tipo Documento SrI"::Cedula;
//                 5:
//                     p_SalesH."Tipo Documento SrI" := p_SalesH."Tipo Documento SrI"::Pasaporte;
//             //... De momento, no.
//             //6: p_SalesH."Tipo Documento" := p_SalesH."Tipo Documento"::"Consumidor Final";
//             end;
//             //-#355717

//             if (p_SalesH."No. Fiscal TPV" = '') then begin

//                 p_SalesH."No. Serie NCF Facturas" := rConfTPV."NCF Credito fiscal";

//                 NoSeriesLine.Reset;
//                 NoSeriesLine.SetRange("Series Code", rConfTPV."NCF Credito fiscal");
//                 NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//                 NoSeriesLine.SetFilter("Fecha Caducidad", '>=%1|%2', WorkDate, 0D);
//                 NoSeriesLine.SetRange(Open, true);
//                 if NoSeriesLine.FindLast then begin

//                     if NoSeriesLine.Establecimiento = '' then
//                         exit(StrSubstNo(Error008, NoSeriesLine."Series Code"));

//                     if NoSeriesLine."Punto de Emision" = '' then
//                         exit(StrSubstNo(Error009, NoSeriesLine."Series Code"));

//                     p_SalesH."Establecimiento Factura" := NoSeriesLine.Establecimiento;
//                     p_SalesH."Punto de Emision Factura" := NoSeriesLine."Punto de Emision";
//                     p_SalesH."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";

//                 end
//                 else
//                     exit(Error004);

//                 p_SalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal", p_SalesH."Posting Date", true);
//                 p_SalesH."No. Fiscal TPV" := p_SalesH."No. Comprobante Fiscal";

//                 //+#355717
//                 if lSerieEnvios <> '' then
//                     if p_SalesH."Shipping No. Series" = '' then
//                         p_SalesH.Validate("Shipping No. Series", lSerieEnvios);
//                 //-#355717

//             end;

//         end
//         else begin  // DEVOLUCIONES

//             p_SalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//             NoSeriesLine.Reset;
//             NoSeriesLine.SetRange("Series Code", rConfTPV."NCF Credito fiscal NCR");
//             NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//             NoSeriesLine.SetFilter("Fecha Caducidad", '>=%1|%2', WorkDate, 0D);
//             NoSeriesLine.SetRange(Open, true);
//             if NoSeriesLine.FindLast then begin

//                 if NoSeriesLine.Establecimiento = '' then
//                     exit(StrSubstNo(Error008, NoSeriesLine."Series Code"));

//                 if NoSeriesLine."Punto de Emision" = '' then
//                     exit(StrSubstNo(Error009, NoSeriesLine."Series Code"));

//                 p_SalesH."Establecimiento Factura" := NoSeriesLine.Establecimiento;
//                 p_SalesH."Punto de Emision Factura" := NoSeriesLine."Punto de Emision";
//                 p_SalesH."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";
//             end
//             else
//                 exit(Error004);

//             if cfComunes.RegistroEnLinea(p_SalesH.Tienda) then begin
//                 rHistCab.Get(p_SalesH."Anula a Documento");
//                 p_SalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//                 p_SalesH."Punto de Emision Fact. Rel." := rHistCab."Punto de Emision Factura";
//                 p_SalesH."Establecimiento Fact. Rel" := rHistCab."Establecimiento Factura";
//             end
//             else begin
//                 rCab.SetCurrentKey("Posting No.");
//                 rCab.SetRange("Posting No.", p_SalesH."Anula a Documento");
//                 rCab.FindFirst;
//                 p_SalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//                 p_SalesH."Punto de Emision Fact. Rel." := rCab."Punto de Emision Factura";
//                 p_SalesH."Establecimiento Fact. Rel" := rCab."Establecimiento Factura";
//             end;

//             p_SalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR", p_SalesH."Posting Date", true);
//             p_SalesH."No. Fiscal TPV" := p_SalesH."No. Comprobante Fiscal";

//             //+#355717
//             rNIT.Init;
//             Evaluate(rNIT."Tipo ID", TextoNet[6].ToString());
//             rNIT."Tipo ID" += 1;

//             p_SalesH."Tipo Documento SrI" := p_SalesH."Tipo Documento SrI"::RUC;

//             case rNIT."Tipo ID" of
//                 4:
//                     p_SalesH."Tipo Documento SrI" := p_SalesH."Tipo Documento SrI"::Cedula;
//                 5:
//                     p_SalesH."Tipo Documento SrI" := p_SalesH."Tipo Documento SrI"::Pasaporte;
//             //... De momento, no.
//             //6: p_SalesH."Tipo Documento" := p_SalesH."Tipo Documento"::"Consumidor Final";
//             end;
//             //-#355717


//         end;
//     end;


//     procedure Ejecutar_Accion(var p_Evento: DotNet ; var p_EventoRespuesta: DotNet )
//     begin
//         //+#355717. Se introduce la funcionalidad de los cupones.

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


//     procedure ValidaIDCliente(pID: Code[20]; pTipo: Integer): Text
//     var
//         TextError: Text;
//         cFuncEcuador: Codeunit "Funciones Ecuador";
//         TextL001: Label 'El Tipo ID Pasaporte, debe tener un máximo de 13 carácteres.';
//         TextL002: Label 'El Tipo ID Consumidor Final, debe tener 13 carácteres numéricos.';
//     begin
//         //+#355717
//         //EXIT(cFuncEcuador.ValidaDigitosRUC(pID,pTipo,TRUE));
//         case pTipo of
//             5:
//                 if StrLen(pID) > 13 then
//                     exit(TextL001);

//             6:
//                 if StrLen(pID) <> 13 then
//                     exit(TextL002);

//             else
//                 exit(cFuncEcuador.ValidaDigitosRUC(pID, pTipo, true));
//         end;
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
//             pSalesH."Punto de Emision Fact. Rel." := rCab."Punto de Emision Factura";
//             pSalesH."Establecimiento Fact. Rel" := rCab."Establecimiento Factura";
//         end
//         else begin
//             rHistCab.Get(pSalesH."Anula a Documento");
//             pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//             pSalesH."Punto de Emision Fact. Rel." := rHistCab."Punto de Emision Factura";
//             pSalesH."Establecimiento Fact. Rel" := rHistCab."Establecimiento Factura";
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
//         Error008: Label 'Establecimiento no puede ser blanco para serie %1';
//         Error009: Label 'Punto de Emision no puede ser blanco para serie %1';
//     begin

//         rConfTPV.Get(pSalesH.Tienda, pSalesH.TPV);
//         pSalesH."No. Serie NCF Abonos" := rConfTPV."NCF Credito fiscal NCR";

//         NoSeriesLine.Reset;
//         NoSeriesLine.SetRange("Series Code", rConfTPV."NCF Credito fiscal NCR");
//         NoSeriesLine.SetRange("Starting Date", 0D, WorkDate);
//         NoSeriesLine.SetFilter("Fecha Caducidad", '>=%1|%2', WorkDate, 0D);
//         NoSeriesLine.SetRange(Open, true);
//         if NoSeriesLine.FindLast then begin

//             if NoSeriesLine.Establecimiento = '' then
//                 exit(StrSubstNo(Error008, NoSeriesLine."Series Code"));

//             if NoSeriesLine."Punto de Emision" = '' then
//                 exit(StrSubstNo(Error009, NoSeriesLine."Series Code"));

//             pSalesH."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";
//             pSalesH."Establecimiento Factura" := NoSeriesLine.Establecimiento;
//             pSalesH."Punto de Emision Factura" := NoSeriesLine."Punto de Emision";

//         end
//         else
//             exit(Error004);

//         pSalesH."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(rConfTPV."NCF Credito fiscal NCR", pSalesH."Posting Date", true);
//         pSalesH."No. Fiscal TPV" := pSalesH."No. Comprobante Fiscal";

//         if cfComunes.RegistroEnLinea(pSalesH.Tienda) then begin
//             rHistCab.Get(pSalesH."Anula a Documento");
//             pSalesH."No. Comprobante Fiscal Rel." := rHistCab."No. Comprobante Fiscal";
//             pSalesH."Punto de Emision Fact. Rel." := rHistCab."Punto de Emision Factura";
//             pSalesH."Establecimiento Fact. Rel" := rHistCab."Establecimiento Factura";

//             //+#355717
//             pSalesH."Tipo Documento SrI" := rHistCab."Tipo Documento";
//             //-#355717

//         end
//         else begin
//             rCab.SetCurrentKey("Posting No.");
//             rCab.SetRange("Posting No.", pSalesH."Anula a Documento");
//             rCab.FindFirst;
//             pSalesH."No. Comprobante Fiscal Rel." := rCab."No. Comprobante Fiscal";
//             pSalesH."Punto de Emision Fact. Rel." := rCab."Punto de Emision Factura";
//             pSalesH."Establecimiento Fact. Rel" := rCab."Establecimiento Factura";

//             //+#355717
//             pSalesH."Tipo Documento SrI" := rCab."Tipo Documento SrI";
//             //-#355717

//         end;
//     end;


//     procedure Guardar_Datos_Aparcados(prmNumVenta: Code[20]; p_Evento: DotNet )
//     var
//         rPedidosAparcados: Record "Pedidos Aparcados";
//         TextoNet: array[10] of DotNet String;
//         i: Integer;
//     begin
//         //+#355717
//         //... Añadir esta funcionalidad. Hay una llamada a esta función desde cComunes.

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


//     procedure Ventas_Registrar_Localizado(var GenGnjLine: Record "Gen. Journal Line"; pSalesH: Record "Sales Header")
//     begin
//         //+#355717
//         //... Añadir esta proceso. Hay una llamada a esta función desde "Ventas-Registrar DsPOS"

//         with GenGnjLine do begin
//             "No. Comprobante Fiscal" := pSalesH."No. Comprobante Fiscal";
//         end;
//     end;


//     procedure ActualizaCupon(pSalesH: Record "Sales Header")
//     var
//         rLinCupon: Record "Lin. Cupon.";
//         CantidadPendiente: Integer;
//         rSalesLines: Record "Sales Line";
//     begin
//         //+#355717. Se introduce la funcionalidad de los cupones.

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
//         //+#355717. Se introduce la funcionalidad de los cupones.

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
//         //+#355717. Se introduce la funcionalidad de los cupones.

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
//         //+#355717. Se introduce la funcionalidad de los cupones.

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


//     procedure LigarItemEntryEnLinNCR(var lrCV: Record "Sales Header")
//     var
//         lrSL: Record "Sales Line";
//         lrILE: Record "Item Ledger Entry";
//     begin
//         //+#377515
//         lrCV.TestField("Document Type", lrCV."Document Type"::"Credit Memo");
//         lrCV.TestField("Registrado TPV", true);

//         lrSL.Reset;
//         lrSL.SetRange("Document Type", lrCV."Document Type");
//         lrSL.SetRange("Document No.", lrCV."No.");
//         if lrSL.FindFirst then
//             repeat
//                 if (lrSL."Devuelve a Documento" <> '') and (lrSL."Devuelve a Linea Documento" > 0) then begin

//                     lrILE.Reset;
//                     lrILE.SetCurrentKey("Document No.");
//                     lrILE.SetRange("Document No.", lrSL."Devuelve a Documento");
//                     lrILE.SetRange("Document Line No.", lrSL."Devuelve a Linea Documento");
//                     lrILE.SetRange("Item No.", lrSL."No.");
//                     if lrILE.FindFirst then begin
//                         lrSL.Validate("Appl.-from Item Entry", lrILE."Entry No.");
//                         lrSL.Modify(true);
//                     end;

//                 end;

//             until lrSL.Next = 0;
//     end;


//     procedure Ajustes_AntesDe_Registrar(var lrCV: Record "Sales Header")
//     var
//         TextL001: Label 'CONSUMIDOR FINAL';
//     begin
//         //+#380380
//         //... Para poder ser autorizado por SRI, si se trata de un consumidor final, el valor de "Bill-to Name" debe ser "CONSUMIDOR FINAL".
//         if lrCV."VAT Registration No." = '9999999999999' then begin
//             //... Se añade la segunda condición. Se entiende que si tiene menos de 4 caracteres posiblemente haya que cambiar el valor.

//             //+#410299
//             //... Se elimina la siguiente condición. Cualquier otro valor distintio de "CONSUMIDOR FINAL", no es aceptado por SRI.
//             //IF ( lrCV."Bill-to Name" IN ['','N/A','N/C','NN'] ) OR ( STRLEN(lrCV."Bill-to Name") <= 3 ) THEN BEGIN
//             //-#410299
//             lrCV."Bill-to Name" := TextL001;
//             lrCV.Modify(false);
//             //END;
//         end;
//     end;


//     procedure RevisarAplicacionDescuentos(pEsDevolucion: Boolean; pDocumento: Code[20]; pIdPago: Code[20]; pIdBoton: Text[20]): Boolean
//     var
//         lrCV: Record "Sales Header";
//         lrPagosTPV: Record "Pagos TPV";
//         lTenemosOtraFormaDePago: Boolean;
//         lDtoAplicacion: Decimal;
//         lrDtos: Record "Descuento x forma de pago";
//         lcComunes: Codeunit "Funciones DsPOS - Comunes";
//     begin
//         //+#373762

//         //... Si es devolución, ya están aplicados los descuentos que procedan....
//         if pEsDevolucion then
//             exit(false);


//         if not lrCV.Get(lrCV."Document Type"::Invoice, pDocumento) then
//             exit(false);


//         if pIdPago = '' then
//             case pIdBoton of
//                 'DSPOS_EXACTO':
//                     pIdPago := lcComunes.Efectivo_Local;
//                 'DSPOS_EFECTIVO':
//                     pIdPago := lcComunes.Efectivo_Local;
//             end;

//         if pIdPago = '' then
//             exit(false);

//         //... Revisamos si hay definida otra forma de pago.
//         lTenemosOtraFormaDePago := false;
//         lrPagosTPV.Reset;
//         lrPagosTPV.SetRange("No. Borrador", pDocumento);
//         lrPagosTPV.SetFilter("Forma pago TPV", '<>%1', pIdPago);
//         if lrPagosTPV.FindFirst then
//             lTenemosOtraFormaDePago := true;

//         if not lTenemosOtraFormaDePago then begin
//             lDtoAplicacion := 0;

//             lrDtos.Reset;
//             lrDtos.SetRange("ID Pago", pIdPago);
//             lrDtos.SetRange(Activo, true);
//             lrDtos.SetFilter("Fecha inicio", '<=%1', lrCV."Posting Date");
//             lrDtos.SetRange(Tienda, lrCV.Tienda);
//             lrDtos.SetRange(TPV, lrCV.TPV);

//             //... Si hemos introducido el descuento no por TPV, sino por tienda, o para todas las tiendas, también se aceptaría.
//             if lrDtos.Count = 0 then
//                 lrDtos.SetRange(TPV);

//             if lrDtos.Count = 0 then
//                 lrDtos.SetRange(Tienda);

//             if lrDtos.FindFirst then
//                 repeat
//                     if (lrDtos."Fecha final" = 0D) or (lrCV."Posting Date" <= lrDtos."Fecha final") then
//                         lDtoAplicacion := lrDtos."% Descuento linea";
//                 until (lrDtos.Next = 0) or (lDtoAplicacion > 0);

//             if lDtoAplicacion > 0 then begin
//                 //... Para que no se llegue a aplicar 2 o mas veces el descuento, primero eliminamos el descuento que se haya podido realizar.
//                 AplicarDescuento(lrCV, 0);
//                 if AplicarDescuento(lrCV, lDtoAplicacion) then
//                     exit(true);
//             end;
//         end
//         else begin
//             if AplicarDescuento(lrCV, 0) then
//                 exit(true);
//         end;

//         exit(false);
//     end;


//     procedure AplicarDescuento(lrCV: Record "Sales Header"; pDto: Decimal): Boolean
//     var
//         lrLV: Record "Sales Line";
//         lPrecio: Decimal;
//         lContador: Integer;
//         lDtoAux: Decimal;
//         lResult: Boolean;
//     begin
//         //+#373762

//         //... Esta variable nos indica si realmente se ha aplicado algun descuento. Tiene que ver con el refresco de la pantalla que se pueda realizar.
//         lResult := false;

//         lrLV.Reset;
//         lrLV.SetRange("Document Type", lrCV."Document Type");
//         lrLV.SetRange("Document No.", lrCV."No.");

//         //... La primera vez hacemos un TEST por si hay error. El segundo recorrido, aplicamos el descuento.
//         for lContador := 1 to 2 do begin

//             if lrLV.FindFirst then
//                 repeat

//                     //... Con esta accion, retrocedemos el descuento automatico que se pudiera hager aplicado anteriormente.
//                     lDtoAux := 0;
//                     if lrLV."Line Discount %" >= lrLV."% Dto por forma de pago" then
//                         lDtoAux := lrLV."Line Discount %" - lrLV."% Dto por forma de pago";

//                     //... Conservamos el descuento que pudiera haber.
//                     lDtoAux := lDtoAux + pDto;

//                     //... Por si acaso,.... no la liamos. Mejor no hacer nada...
//                     if (lDtoAux > 100) or (lDtoAux < 0) then
//                         exit(false);
//                     //...

//                     if lContador = 2 then begin
//                         if lDtoAux <> lrLV."Line Discount %" then begin
//                             lPrecio := lrLV."Unit Price";
//                             lrLV.Validate("Line Discount %", lDtoAux);
//                             lrLV.Validate("Unit Price", lPrecio);
//                             //... La siguiente asignación no puede estar antes de la de "Line Discount %", ya que asigna al campo "% Dto por forma ..." el valor 0.
//                             lrLV.Validate("% Dto por forma de pago", pDto);

//                             lrLV.Modify(false);
//                             lResult := true;
//                         end;

//                     end;

//                 until lrLV.Next = 0;

//         end;

//         exit(lResult);
//     end;


//     procedure ExistenDescuentosPorFormaPago(pEsDevolucion: Boolean; pDocumento: Code[20]; pIDPago: Code[20]): Boolean
//     var
//         lrCV: Record "Sales Header";
//         lrLV: Record "Sales Line";
//         lResult: Boolean;
//     begin
//         //+#373762
//         //... Si es devolución, ya están aplicados los descuentos que procedan....
//         if pEsDevolucion then
//             exit(false);

//         if not lrCV.Get(lrCV."Document Type"::Invoice, pDocumento) then
//             exit(false);

//         //... Examinamos si hemos aplicado descuento automatico por forma de pago.
//         lrLV.Reset;
//         lrLV.SetCurrentKey("Document Type", "Document No.");
//         lrLV.SetRange("Document Type", lrLV."Document Type"::Invoice);
//         lrLV.SetRange("Document No.", pDocumento);
//         lrLV.SetFilter("% Dto por forma de pago", '<>%1', 0);
//         if lrLV.Count > 0 then
//             lResult := AplicarDescuento(lrCV, 0);

//         exit(lResult);
//     end;
// }

