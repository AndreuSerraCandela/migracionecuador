report 55007 "Operación Logistica Ecuador"
{
    // #13586  14/07/2015  MOI   Se modifica el report para añadir las fechas correctas y las horas correctas.
    //                           -"Fecha Aprobacion" por "Orden Date"
    //                           -"Fecha Lanzado" por "Fecha Aprobacion"
    //                           Se modifican los campos en el Layout
    //                           Se añaden los campos
    //                           -Fecha Envio
    //                           -Fecha Entrega
    //         15/07/2015  MOI   Se puede buscar por los filtros de navision
    //         20/07/2015  MOI   Se añade el filtro de fechas para los pedidos.
    //         21/07/2015  MOI   Se elimina el validate del campo NumeroPedido, ya que se puede borrar y buscar por fecha.
    //         22/07/2015  MOI   Los campos de horas deben ir en la misma fila que el resto de informacion.
    //                           El campo alias se obtiene del maestro de clientes.
    //                           Se incluye un campo nuevo que es el codigo del vendedor.
    //                           Añadir filtro por cliente
    //                           Añadir filtro por vendedor
    //                           Añadir los campos nombre transportista, comentario y numero de guia.
    // #27882  03/08/2015  MOI   Se añade el nombre del vendedor.
    //         06/08/2015  MOI   Al seleccionar el filtro de vendedor apuntaba a la tabla proveedor.
    // 
    // #51496  27/04/2016  JMB   Se añade el campo Cantidad de Cajas, proveniente de la tabla 56020 Cab. Hoja de Ruta
    // 
    // ---------------------------------
    // YFC     : Yefrecis Francisco Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC       01/6/2020       SANTINAV-1457
    // 002         YFC       22/10/2020      SANTINAV-1748
    DefaultLayout = RDLC;
    RDLCLayout = './OperaciónLogisticaEcuador.rdlc';

    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "External Document No.", "VAT Registration No.";
            column(fecha_PlanTransporte; CabH."Fecha Planificacion Transporte")
            {
            }
            column(ExternalDocumentNo_SalesInvoiceHeader; "Sales Invoice Header"."External Document No.")
            {
            }
            column(VATRegistrationNo_SalesInvoiceHeader; "Sales Invoice Header"."VAT Registration No.")
            {
            }
            column(NumeroGuia_SalesInvoiceHeader; "Sales Invoice Header"."Numero Guia")
            {
            }
            column(NombreGuia_SalesInvoiceHeader; "Sales Invoice Header"."Nombre Guia")
            {
            }
            column(No_Pedido; "Sales Invoice Header"."Order No.")
            {
            }
            column(Establecimiento_Factura; "Sales Invoice Header"."Establecimiento Factura")
            {
            }
            column("Punto_Emisión_Factura"; "Sales Invoice Header"."Punto de Emision Factura")
            {
            }
            column(No_comprobante_Fiscal; "Sales Invoice Header"."No. Comprobante Fiscal")
            {
            }
            column(Numero_Cliente; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(Nombre_Cliente; "Sales Invoice Header"."Bill-to Name")
            {
            }
            column(Alias; gcAlias)
            {
            }
            column(Codigo_Almacen; "Sales Invoice Header"."Location Code")
            {
            }
            column(Ciudad_Envio; "Sales Invoice Header"."Ship-to City")
            {
            }
            column(Fecha_Ingreso_Pedido; DT2Date("Sales Invoice Header"."Fecha Creacion Pedido"))
            {
            }
            column(Hora_Ingreso_Pedido; "Sales Invoice Header"."Fecha Creacion Pedido")
            {
            }
            column(Fecha_Aprobacion_Pedido; "Sales Invoice Header"."Fecha Aprobacion")
            {
            }
            column(Hora_Aprobacion_Pedido; HoraAprobacion)
            {
            }
            column(Fecha_Factura; "Sales Invoice Header"."Posting Date")
            {
            }
            column(Hora_Factura; HoraFactura)
            {
            }
            column(Fecha_Envio; vFechaDespacho)
            {
            }
            column(Hora_Envio; vHoraDespacho)
            {
            }
            column(Fecha_Entrega; "Sales Invoice Header"."Fecha Recepcion")
            {
            }
            column(Filtro_No_Order; vNOrden)
            {
            }
            column(Fecha_Inicial; vFechaIn)
            {
            }
            column(Fecha_Final; vFechaOut)
            {
            }
            column(Filtro_Fecha_Caption; vFiltroFecha)
            {
            }
            column(Nombre_Reporte; Text001)
            {
            }
            column(Filtro_No_order_Caption; Text002)
            {
            }
            column(No_Order_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Order No."))
            {
            }
            column(Establecimiento_Factura_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Establecimiento Factura"))
            {
            }
            column(Punto_Emision_Factura_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Punto de Emision Factura"))
            {
            }
            column(No_Comprobante_Fiscal_caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."No. Comprobante Fiscal"))
            {
            }
            column(Numero_Cliente_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Sell-to Customer No."))
            {
            }
            column(NombreCliente_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Bill-to Name"))
            {
            }
            column(Alias_Caption; Text009)
            {
            }
            column(Location_Code_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Location Code"))
            {
            }
            column(Ciudad_Envio_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Ship-to City"))
            {
            }
            column(Fecha_Ingreso_Pedido_Caption; Text012)
            {
            }
            column(Fecha_Aprobacion_Caption; Text013)
            {
            }
            column(Fecha_Facturacion_Caption; Text014)
            {
            }
            column(Fecha_Envio_Caption; Text015)
            {
            }
            column(No_Factura_Caption; Text017)
            {
            }
            column(Fecha_Entrega_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Fecha Recepcion"))
            {
            }
            column(CodigoVendedor_Caption; "Sales Invoice Header".FieldCaption("Sales Invoice Header"."Salesperson Code"))
            {
            }
            column(CodigoVendedor; "Sales Invoice Header"."Salesperson Code")
            {
            }
            column(NombreVendedor_Caption; Text016)
            {
            }
            column(NombreVendedor; gtVendedor)
            {
            }
            column(NoGuia; gcNoGuia)
            {
            }
            column(Transportista; gtTransportista)
            {
            }
            column(Comentario; gtComentario)
            {
            }
            column(CantidadDeCajas; giCantidadDeCajas)
            {
            }
            column(NumeroGuia; gcNumeroGuia)
            {
            }

            trigger OnAfterGetRecord()
            var
                lrCustomer: Record Customer;
                lrShipmentAgent: Record "Shipping Agent";
                lrLineaHojaRutaRegistrada: Record "Lin. Hoja de Ruta Reg.";
                lrCabeceraHojaRutaRegistrada: Record "Cab. Hoja de Ruta Reg.";
                lrVendedor: Record "Salesperson/Purchaser";
                lrLin2: Record "Lin. Hoja de Ruta Reg.";
            begin
                lrCustomer.Get("Sales Invoice Header"."Sell-to Customer No.");
                gcAlias := lrCustomer."Search Name";

                Clear(gcNoGuia);
                Clear(gtComentario);
                Clear(gtTransportista);
                //#27882:Inicio
                Clear(gtVendedor);

                // ++ 002-YFC
                Clear(CabH);
                Clear(gcNumeroGuia);
                Clear(giCantidadDeCajas);
                Clear(vHoraDespacho);
                Clear(vFechaDespacho);
                Clear(HoraAprobacion);
                Clear(HoraFactura);

                HoraFactura := Format("Sales Invoice Header"."Posting Time");
                HoraAprobacion := Format("Sales Invoice Header"."Hora Aprobacion");

                // -- 002-YFC

                // ++ 001-YFC
                LinH.Reset;
                LinH.SetCurrentKey("No. Pedido");
                LinH.SetRange("No. Pedido", "Order No.");
                if LinH.FindFirst then
                    CabH.Get(LinH."No. Hoja Ruta");

                // -- 001-YFC

                if lrVendedor.Get("Sales Invoice Header"."Salesperson Code") then
                    gtVendedor := lrVendedor.Name;
                //#27882:Fin

                if "Sales Invoice Header"."Order No." <> '' then begin
                    lrLineaHojaRutaRegistrada.Reset;
                    lrLineaHojaRutaRegistrada.SetRange(lrLineaHojaRutaRegistrada."No. Pedido", "Sales Invoice Header"."Order No.");
                    if lrLineaHojaRutaRegistrada.FindFirst then begin

                        gcNoGuia := lrLineaHojaRutaRegistrada."No. Hoja Ruta";
                        gtComentario := lrLineaHojaRutaRegistrada.Comentarios;
                        gcNumeroGuia := lrLineaHojaRutaRegistrada."Numero Guia";
                        lrCabeceraHojaRutaRegistrada.Get(lrLineaHojaRutaRegistrada."No. Hoja Ruta");

                        // JPT 12/05/17 #71176 "debe tomar de la fecha de planificacion de la hoja de ruta registrada"
                        vFechaDespacho := lrCabeceraHojaRutaRegistrada."Fecha Planificacion Transporte";
                        vHoraDespacho := Format(lrCabeceraHojaRutaRegistrada.Hora); // 002-YFC

                        //aqui se obtiene el transportista
                        if lrShipmentAgent.Get(lrCabeceraHojaRutaRegistrada."Cod. Transportista") then
                            gtTransportista := lrShipmentAgent.Name;

                        //#51496:Inicio
                        // JPT 12/05/17 #71176Debe tomar las cajas por pedido de la celda cantidad de bultos de la hora de ruta registrada
                        //giCantidadDeCajas := lrCabeceraHojaRutaRegistrada."Cantidad de cajas";
                        Clear(giCantidadDeCajas);
                        Clear(lrLin2);
                        lrLin2.SetRange("No. Hoja Ruta", lrCabeceraHojaRutaRegistrada."No. Hoja Ruta");
                        lrLin2.SetRange("No. Pedido", "Order No.");
                        if lrLin2.FindSet then begin
                            repeat
                                giCantidadDeCajas += lrLin2."Cantidad de Bultos";
                            until lrLin2.Next = 0;
                        end;

                        //#51496:Fin
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //IF vNOrden = '' THEN
                //  ERROR(err001);

                if vNOrden <> '' then
                    SetFilter("Order No.", vNOrden);

                if (vFechaIn <> 0D) and (vFechaOut <> 0D) then begin
                    SetRange("Posting Date", vFechaIn, vFechaOut);
                end
                else begin
                    if vFechaIn <> 0D then begin
                        SetRange("Posting Date", vFechaIn, WorkDate);
                    end
                    else begin
                        if vFechaOut <> 0D then
                            SetRange("Posting Date", 0D, vFechaOut);
                    end;
                end;

                if gcCliente <> '' then
                    SetFilter("Sell-to Customer No.", gcCliente);

                if gcVendedor <> '' then
                    SetFilter("Salesperson Code", gcVendedor);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(NumeroPedido; vNOrden)
                {
                    Caption = 'Número de Pedido';
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lrSalesInvoiceHeader: Record "Sales Invoice Header";
                        lpSalesInvoiceHeader: Page "Posted Sales Invoices";
                    begin
                        Clear(lpSalesInvoiceHeader);
                        lpSalesInvoiceHeader.Editable(false);

                        lrSalesInvoiceHeader.Reset;

                        lpSalesInvoiceHeader.SetTableView(lrSalesInvoiceHeader);
                        lpSalesInvoiceHeader.SetRecord(lrSalesInvoiceHeader);
                        lpSalesInvoiceHeader.LookupMode(true);

                        if lpSalesInvoiceHeader.RunModal = ACTION::LookupOK then begin
                            lpSalesInvoiceHeader.GetRecord(lrSalesInvoiceHeader);
                            vNOrden := lrSalesInvoiceHeader."Order No.";
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        //IF vNOrden = '' THEN
                        //  ERROR(err001);
                    end;
                }
                field(FechaInicial; vFechaIn)
                {
                    Caption = 'Fecha Inicio';
                    ApplicationArea = Basic, Suite;
                }
                field(FechaFinal; vFechaOut)
                {
                    Caption = 'Fecha Fin';
                    ApplicationArea = Basic, Suite;
                }
                field(Cliente; gcCliente)
                {
                    TableRelation = Customer;
                    Caption = 'Cliente';
                    ApplicationArea = Basic, Suite;
                }
                field(Vendedor; gcVendedor)
                {
                    TableRelation = "Salesperson/Purchaser";
                    Caption = 'Vendedor';
                    ApplicationArea = Basic, Suite;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        vNOrden: Code[100];
        Text001: Label 'Reporte de Operación de Logistica';
        Text002: Label 'No. de Orden';
        Text003: Label 'No de Orden';
        Text004: Label 'Establecimiento o Factura';
        Text005: Label 'Punto de Emisión Factura';
        Text006: Label 'No. Comprobante Fiscal';
        Text007: Label 'Vendido a No. de Cliente';
        Text008: Label 'Facturado a Nombre ';
        Text009: Label 'Alias';
        Text010: Label 'Código de Localización';
        Text011: Label 'Ciudad de Envio';
        Text012: Label 'Fecha Creación Pedido';
        Text013: Label 'Fecha Aprobación del Pedido';
        Text014: Label 'Fecha de Facturación';
        Text015: Label 'Fecha de Despacho';
        Text016: Label 'Nombre Vendedor';
        Text017: Label 'No. Factura:';
        err001: Label 'Debe asignar un filtro de pedido.';
        vFechaIn: Date;
        vFechaOut: Date;
        vFiltroFecha: Text[100];
        vFechaDespacho: Date;
        vHoraDespacho: Text;
        rSalesHeader: Record "Sales Header";
        gcAlias: Code[60];
        gcCliente: Code[10];
        gcVendedor: Code[10];
        gtTransportista: Text[60];
        gtComentario: Text[250];
        gcNoGuia: Code[20];
        gcNumeroGuia: Code[20];
        gtVendedor: Text[60];
        giCantidadDeCajas: Integer;
        CabH: Record "Cab. Hoja de Ruta";
        LinH: Record "Lin. Hoja de Ruta";
        HoraAprobacion: Text;
        HoraFactura: Text;
}

