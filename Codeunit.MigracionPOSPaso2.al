codeunit 80002 "Migracion POS Paso 2"
{

    trigger OnRun()
    begin

        dlgProgreso.Open(Text002 + Text003 + Text004);
        dlgProgreso.Update(1, Text001);

        RecuperarConfig;
        RecuperarHistoricos;
    end;

    var
        Text001: Label 'Recuperando datos';
        Text002: Label '########################################1\\';
        Text003: Label '########################################2\';
        Text004: Label '########################################3';
        dlgProgreso: Dialog;


    procedure RecuperarConfig()
    var
        recConfiguracionTPV: Record "Configuracion General DsPOS";
        recGrupoCajeros: Record "Grupos Cajeros";
        recUsuariosTPV: Record Cajeros;
        recTPV: Record "Configuracion TPV";
        recTiendas: Record Tiendas;
        recMenuVentasTPV: Record "Menus TPV";
        recBotones: Record Botones;
        recAcciones: Record Acciones;
        recSalesHeaderPOS: Record "Sales Invoice Header";
        recSalesLinePOS: Record "Sales Invoice Line";
        recFormasPagoTPV: Record "Formas de Pago";
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
        intProcesados: Integer;
        intTotal: Integer;
        rPais: Record "Country/Region";
        rBancosTie: Record "Bancos tienda";
    begin


        recTMPTiendas.Reset;
        if recTMPTiendas.FindSet then begin
            dlgProgreso.Update(2, recTMPTiendas.TableCaption);
            intTotal := recTMPTiendas.Count;
            intProcesados := 0;
            repeat

                recTiendas.Init;
                recTiendas."Cod. Tienda" := recTMPTiendas."Cod. Tienda";
                recTiendas.Descripcion := recTMPTiendas.Descripcion;
                recTiendas."Cod. Almacen" := recTMPTiendas."Cod. Almacen";

                if recTiendas."Cod. Pais" = '' then
                    recTiendas."Cod. Pais" := 'EC';

                rPais.Get(recTiendas."Cod. Pais");
                recTiendas."Nombre Pais" := rPais.Name;

                recTiendas."Descripcion recibo TPV" := recTMPTiendas."Descripcion recibo TPV";
                recTiendas."Descripcion recibo TPV 2" := recTMPTiendas."Descripcion recibo TPV 3";
                recTiendas."Descripcion recibo TPV 3" := recTMPTiendas."Descripcion recibo TPV 3";
                recTiendas."Descripcion recibo TPV 4" := recTMPTiendas."Descripcion recibo TPV 4";

                recTiendas."Control de caja" := true;
                recTiendas."Descuadre maximo en caja" := 100;
                recTiendas."Arqueo de caja obligatorio" := true;

                recTMPTPV.Reset;
                recTMPTPV.SetRange(Tienda, recTMPTiendas."Cod. Tienda");
                if recTMPTPV.FindFirst then begin
                    recTiendas."ID Reporte contado" := recTMPTPV."ID Reporte contado";
                    recTiendas."ID Reporte venta a credito" := recTMPTPV."ID Reporte venta a credito";
                    recTiendas."ID Reporte cuadre" := recTMPTPV."ID Reporte cuadre";

                    //recTiendas."ID Reporte nota credito"    :=

                    recTiendas."Cantidad de Copias Contado" := 1;
                    recTiendas."Cantidad de Copias Credito" := 1;
                    recTiendas."Cantidad copias nota credito" := 1;
                end;

                recTiendas."Registro En Linea" := true;
                recTiendas."Agrupar Lineas" := true;

                rBancosTie.Reset;
                rBancosTie.Init;
                rBancosTie."Cod. Tienda" := recTiendas."Cod. Tienda";
                rBancosTie."Cod. Divisa" := '';
                rBancosTie."Cod. Banco" := recTMPTiendas."Cod. Banco";
                rBancosTie."Nombre Banco" := recTMPTiendas."Nombre Banco";
                rBancosTie.Insert(false);

                recTiendas.Insert;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPTiendas.Next = 0;
        end;


        recTMPTPV.Reset;
        if recTMPTPV.FindSet then begin
            dlgProgreso.Update(2, recTMPTPV.TableCaption);
            intTotal := recTMPTPV.Count;
            intProcesados := 0;
            repeat

                recTPV.Init;
                recTPV.Tienda := CopyStr(recTMPTPV.Tienda, 1, MaxStrLen(recTPV.Tienda));
                recTPV."Id TPV" := CopyStr(recTMPTPV."TPV ID", 1, MaxStrLen(recTPV."Id TPV"));
                recTPV.Descripcion := recTMPTPV.Descripcion;

                recTPV."No. serie Facturas" := recTMPTPV."No. serie Pedidos";

                //    recTPV."No. serie facturas Reg."      :=
                //    recTPV."No. serie notas credito"      :=
                //    recTPV."No. serie notas credito reg." :=

                //      recTPV."Menu de acciones"             := recTMPTPV."Menu de acciones";
                //      recTPV."Menu de productos"            := recTMPTPV."Menu de productos";
                //      recTPV."Menu de Formas de Pago"       := recTMPTPV."Menu de formas de pago";
                recTPV."NCF Consumidor final" := recTMPTPV."NCF Consumidor final";
                recTPV."NCF Credito fiscal" := recTMPTPV."NCF Credito fiscal";
                recTPV."NCF Regimenes especiales" := recTMPTPV."NCF Regimenes especiales";
                recTPV."NCF Gubernamentales" := recTMPTPV."NCF Gubernamentales";
                recTPV.Insert;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPTPV.Next = 0;
        end;

        recTMPGrupoCajeros.Reset;
        if recTMPGrupoCajeros.FindSet then begin
            dlgProgreso.Update(2, recTMPGrupoCajeros.TableCaption);
            intTotal := recTMPGrupoCajeros.Count;
            intProcesados := 0;
            repeat
                recTiendas.Reset;
                if recTiendas.FindSet then
                    repeat
                        recGrupoCajeros.Init;
                        recGrupoCajeros.Tienda := recTiendas."Cod. Tienda";
                        recGrupoCajeros.Grupo := recTMPGrupoCajeros.Grupo;
                        recGrupoCajeros.Descripcion := recTMPGrupoCajeros.Descripcion;
                        recGrupoCajeros."Cliente al contado" := recTMPGrupoCajeros."Cliente al contado";
                        recGrupoCajeros.Insert;
                    until recTiendas.Next = 0;
                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPGrupoCajeros.Next = 0;
        end;

        recTMPUsuariosTPV.Reset;
        if recTMPUsuariosTPV.FindSet then begin
            dlgProgreso.Update(2, recTMPUsuariosTPV.TableCaption);
            intTotal := recTMPUsuariosTPV.Count;
            intProcesados := 0;
            repeat
                recUsuariosTPV.Init;
                recUsuariosTPV.Tienda := recTMPUsuariosTPV.Tienda;
                recUsuariosTPV.ID := recTMPUsuariosTPV.ID;
                recUsuariosTPV.Descripcion := recTMPUsuariosTPV.Descripcion;
                recUsuariosTPV."Grupo Cajero" := recTMPUsuariosTPV."Grupo Cajero";
                recUsuariosTPV.Contrasena := recTMPUsuariosTPV.Contraseña;
                recUsuariosTPV.Tipo := recTMPUsuariosTPV.Tipo;
                recUsuariosTPV.Insert;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPUsuariosTPV.Next = 0;
        end;

        //WITH recTMPMenuVentasTPV DO BEGIN
        //  RESET;
        //  IF FINDSET THEN BEGIN
        //    dlgProgreso.UPDATE(2, TABLECAPTION);
        //    intTotal := COUNT;
        //    intProcesados := 0;
        //    REPEAT
        //      recMenuVentasTPV.INIT;
        //      recMenuVentasTPV."Menu ID"             := "Menu ID";
        //      recMenuVentasTPV.Descripcion           := Descripcion;
        //      recMenuVentasTPV.INSERT;
        //
        //      intProcesados += 1;
        //      dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
        //    UNTIL NEXT = 0;
        //  END;
        //END;


        //WITH recTMPBotones DO BEGIN
        //  RESET;
        //  IF FINDSET THEN BEGIN
        //    dlgProgreso.UPDATE(2, TABLECAPTION);
        //    intTotal := COUNT;
        //    intProcesados := 0;
        //    REPEAT
        //      recBotones.INIT;
        //      recBotones."ID Menu"     := "ID Menu";
        //      recBotones."ID boton"    := "ID boton";
        //      recBotones.Descripcion   := Descripcion;
        //      recBotones.Accion        := Accion;
        //      recBotones.Etiqueta      := Etiqueta;
        //      recBotones.Activo        := Activo;
        //      recBotones."Descuento %" := "Descuento %";
        //      recBotones.Seguridad     := Seguridad;
        //      recBotones.Pago          := Pago;
        //      recBotones.Tipo          := Tipo;
        //      recBotones."No."         := "No.";
        //      recBotones.INSERT;
        //
        //      intProcesados += 1;
        //      dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
        //    UNTIL NEXT = 0;
        //  END;
        //END;

        recTMPFormasPagoTPV.Reset;
        if recTMPFormasPagoTPV.FindSet then begin
            dlgProgreso.Update(2, recTMPFormasPagoTPV.TableCaption);
            intTotal := recTMPFormasPagoTPV.Count;
            intProcesados := 0;
            repeat

                recFormasPagoTPV.Init;
                recFormasPagoTPV."ID Pago" := recTMPFormasPagoTPV."ID Pago";
                recFormasPagoTPV.Descripcion := recTMPFormasPagoTPV.Descripcion;
                recFormasPagoTPV."Cod. divisa" := recTMPFormasPagoTPV."Cod. divisa";
                recFormasPagoTPV."Abre cajon" := recTMPFormasPagoTPV."Abre cajon";
                recFormasPagoTPV.Insert;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPFormasPagoTPV.Next = 0;
        end;
    end;


    procedure RecuperarHistoricos()
    var
        recCustomer: Record Customer;
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recSalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesInvoiceLine: Record "Sales Invoice Line";
        recSalesMemoHeader: Record "Sales Cr.Memo Header";
        recSalesMemoLine: Record "Sales Cr.Memo Line";
        recCedulasRUCs: Record "_Clientes TPV";
        recPagosTPV: Record "Pagos TPV";
        recTMPCustomer: Record "MIG Customer";
        recTMPSalesHeader: Record "MIG Sales Header";
        recTMPSalesLine: Record "MIG Sales Line";
        recTMPSalesInvoiceHeader: Record "MIG Sales Invoice Header";
        recTMPSalesInvoiceLine: Record "MIG Sales Invoice Line";
        recTMPSalesMemoHeader: Record "MIG Sales Cr.Memo Header";
        recTMPSalesMemoLine: Record "MIG Sales Cr.Memo Line";
        recTMPCedulasRUCs: Record "MIG Cedulas/RUCs";
        recTMPPagosTPV: Record "MIG Pagos TPV";
        intProcesados: Integer;
        intTotal: Integer;
    begin

        recTMPCustomer.Reset;
        if recTMPCustomer.FindSet then begin
            dlgProgreso.Update(2, recTMPCustomer.TableCaption);
            intTotal := recTMPCustomer.Count;
            intProcesados := 0;
            repeat

                if recCustomer.Get(recTMPCustomer."No.") then begin
                    recCustomer."Permite venta a credito" := recTMPCustomer."Permite venta a credito";
                    recCustomer."Colegio por defecto POS" := recTMPCustomer."Colegio por defecto POS";
                    recCustomer.Modify;
                end;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPCustomer.Next = 0;

        end;

        recTMPCedulasRUCs.Reset;
        if recTMPCedulasRUCs.FindSet then begin
            dlgProgreso.Update(2, recTMPCedulasRUCs.TableCaption);
            intTotal := recTMPCedulasRUCs.Count;
            intProcesados := 0;
            repeat
                recCedulasRUCs.Init;
                recCedulasRUCs.TransferFields(recTMPCedulasRUCs);
                recCedulasRUCs.Insert;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPCedulasRUCs.Next = 0;
        end;

        recTMPSalesHeader.Reset;
        if recTMPSalesHeader.FindSet then begin
            dlgProgreso.Update(2, recTMPSalesHeader.TableCaption);
            intTotal := recTMPSalesHeader.Count;
            intProcesados := 0;
            repeat

                if recSalesHeader.Get(recTMPSalesHeader."Document Type", recTMPSalesHeader."No.") then begin

                    if recTMPSalesHeader."Tipo pedido" = recTMPSalesHeader."Tipo pedido"::TPV then
                        recSalesHeader."Venta TPV" := true;

                    recSalesHeader."ID Cajero" := recTMPSalesHeader."ID Cajero";
                    recSalesHeader."Hora creacion" := recTMPSalesHeader."Hora creacion";
                    recSalesHeader.TPV := recTMPSalesHeader.TPV;
                    //        recSalesHeader."Factura comprimida"     := "Factura comprimida";
                    recSalesHeader."Venta a credito" := recTMPSalesHeader."Venta a credito";
                    //        recSalesHeader."Importe a liquidar"     := "Importe a liquidar";
                    recSalesHeader.Tienda := recTMPSalesHeader.Tienda;
                    //        recSalesHeader."Forma de pago TPV"      := "Forma de pago TPV";
                    //        recSalesHeader."Pedidos TPV sin lineas" := "Pedidos TPV sin lineas";
                    recSalesHeader.Modify;
                end;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPSalesHeader.Next = 0;

        end;

        recTMPSalesLine.Reset;
        if recTMPSalesLine.FindSet then begin
            dlgProgreso.Update(2, recTMPSalesLine.TableCaption);
            intTotal := recTMPSalesLine.Count;
            intProcesados := 0;
            repeat

                if recSalesLine.Get(recTMPSalesLine."Document Type", recTMPSalesLine."Document No.", recTMPSalesLine."Line No.") then begin
                    recSalesLine."Anulada en TPV" := recTMPSalesLine."Anulada en TPV";
                    recSalesLine."Precio anulacion TPV" := recTMPSalesLine."Precio anulacion TPV";
                    recSalesLine."Cantidad anulacion TPV" := recTMPSalesLine."Cantidad anulacion TPV";
                    recSalesLine."Cantidad agregada" := recTMPSalesLine."Cantidad agregada";
                    recSalesLine."Cod. Vendedor" := recTMPSalesLine."Cod. Vendedor";
                    recSalesLine.Modify;
                end;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPSalesLine.Next = 0;
        end;

        recTMPSalesInvoiceHeader.Reset;
        if recTMPSalesInvoiceHeader.FindSet then begin
            dlgProgreso.Update(2, recTMPSalesInvoiceHeader.TableCaption);
            intTotal := recTMPSalesInvoiceHeader.Count;
            intProcesados := 0;
            repeat

                recSalesInvoiceHeader.Get(recTMPSalesInvoiceHeader."No.");
                recSalesInvoiceHeader.Tienda := recTMPSalesInvoiceHeader.Tienda;
                recSalesInvoiceHeader."ID Cajero" := recTMPSalesInvoiceHeader."ID Cajero";
                recSalesInvoiceHeader."Hora creacion" := recTMPSalesInvoiceHeader."Hora creacion";

                if recTMPSalesInvoiceHeader."Tipo pedido" = recTMPSalesInvoiceHeader."Tipo pedido"::TPV then
                    recSalesInvoiceHeader."Venta TPV" := true;

                recSalesInvoiceHeader."Forma de Pago TPV" := recTMPSalesInvoiceHeader."Forma de Pago TPV";
                recSalesInvoiceHeader."Hora creacion" := recTMPSalesInvoiceHeader."Hora creacion";
                recSalesInvoiceHeader.TPV := recTMPSalesInvoiceHeader.TPV;
                //      recSalesInvoiceHeader."Factura comprimida"   := "Factura comprimida";
                //      recSalesInvoiceHeader."Importe ITBIS Incl."  := "Importe ITBIS Incl.";
                recSalesInvoiceHeader."Venta a credito" := recTMPSalesInvoiceHeader."Venta a credito";
                //      recSalesInvoiceHeader."Importe a liquidar"   := "Importe a liquidar";
                //      recSalesInvoiceHeader."Anulada TPV"          := "Anulada TPV";
                //      recSalesInvoiceHeader."No. nota credito TPV" := "No. nota credito TPV";
                recSalesInvoiceHeader.Modify;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPSalesInvoiceHeader.Next = 0;
        end;


        //WITH recTMPSalesInvoiceLine DO BEGIN
        //  RESET;
        //  IF FINDSET THEN BEGIN
        //    dlgProgreso.UPDATE(2, TABLECAPTION);
        //    intTotal := COUNT;
        //    intProcesados := 0;
        //    REPEAT
        //
        //      IF recSalesInvoiceLine.GET(recTMPSalesInvoiceLine."Document No.", recTMPSalesInvoiceLine."Line No.") THEN BEGIN
        //        recSalesInvoiceLine."Anulada en TPV"            := "Anulada en TPV";
        //        recSalesInvoiceLine."Precio anulacion TPV"      := "Precio anulacion TPV";
        //        recSalesInvoiceLine."Cantidad anulacion TPV"    := "Cantidad anulacion TPV";
        //        recSalesInvoiceLine."Cantidad agregada"         := "Cantidad agregada";
        //        recSalesInvoiceLine."Cod. Vendedor"             := "Cod. Vendedor";
        //        recSalesInvoiceLine.MODIFY;
        //      END;
        //
        //      intProcesados += 1;
        //      dlgProgreso.UPDATE(3, TraerLinProgreso(intProcesados,intTotal));
        //    UNTIL NEXT = 0;
        //  END;
        //END;

        recTMPSalesMemoHeader.Reset;
        if recTMPSalesMemoHeader.FindSet then begin
            dlgProgreso.Update(2, recTMPSalesMemoHeader.TableCaption);
            intTotal := recTMPSalesMemoHeader.Count;
            intProcesados := 0;
            repeat

                recSalesMemoHeader.Get(recTMPSalesMemoHeader."No.");
                if recTMPSalesMemoHeader."Tipo pedido" = recTMPSalesMemoHeader."Tipo pedido"::TPV then
                    recSalesMemoHeader."Venta TPV" := true;

                recSalesMemoHeader."ID Cajero" := recTMPSalesMemoHeader."ID Cajero";
                recSalesMemoHeader."Hora creacion" := recTMPSalesMemoHeader."Hora creacion";
                recSalesMemoHeader.Tienda := recTMPSalesMemoHeader.Tienda;
                recSalesMemoHeader.TPV := recTMPSalesMemoHeader.TPV;
                recSalesMemoHeader.Modify;

                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPSalesMemoHeader.Next = 0;
        end;

        recTMPPagosTPV.Reset;
        if recTMPPagosTPV.FindSet then begin
            dlgProgreso.Update(2, recTMPPagosTPV.TableCaption);
            intTotal := recTMPPagosTPV.Count;
            intProcesados := 0;
            repeat
                recPagosTPV.Init;
                recPagosTPV."No. Borrador" := recTMPPagosTPV."No. pedido";
                recPagosTPV."Forma pago TPV" := recTMPPagosTPV."Forma pago TPV";
                if recPagosTPV."Forma pago TPV" = 'CAMBIO' then
                    recPagosTPV.Cambio := true;
                recPagosTPV.Tienda := recTMPPagosTPV.Tienda;
                recPagosTPV.TPV := recTMPPagosTPV.TPV;
                recPagosTPV."Cod. divisa" := recTMPPagosTPV."Cod. divisa";
                recPagosTPV."Importe (DL)" := recTMPPagosTPV."Importe (DL)";
                recPagosTPV.Importe := recTMPPagosTPV.Importe;
                recPagosTPV.Cajero := recTMPPagosTPV.Cajero;
                recPagosTPV.Fecha := recTMPPagosTPV.Fecha;
                recPagosTPV.Hora := recTMPPagosTPV.Hora;
                recPagosTPV."No. Factura" := recTMPPagosTPV."No. Factura";
                //      recPagosTPV."Tipo Tarjeta"         := recTMPPagosTPV."Tipo Tarjeta";
                recPagosTPV."No. Tarjeta" := recTMPPagosTPV."No. Tarjeta";
                recPagosTPV."No. Cheque" := recTMPPagosTPV."No. Cheque";
                //      recPagosTPV."Banco Cheque"         := recTMPPagosTPV."Banco Cheque";
                //      recPagosTPV."No. Nota Credito"     :=
                //      recPagosTPV."Factor divisa"        :=
                //      recPagosTPV."Importe Total divisa" :=
                recPagosTPV.Insert;
                intProcesados += 1;
                dlgProgreso.Update(3, TraerLinProgreso(intProcesados, intTotal));
            until recTMPPagosTPV.Next = 0;
        end;
    end;


    procedure TraerLinProgreso(intPrmProcesados: Integer; intPrmTotal: Integer): Text
    var
        blnMostrar: Boolean;
    begin
        exit(Format(intPrmProcesados) + ' de ' + Format(intPrmTotal));
    end;
}

