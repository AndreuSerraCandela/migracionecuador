page 55022 ModificaFechaRecepcion
{
    ApplicationArea = all;
    // #27882  03/08/2015  MOI   Se crea la pagina.


    Caption = 'Modifica Fecha Recepcion';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Sales Invoice Header" = rm;
    SourceTable = "Sales Invoice Header";
    SourceTableView = SORTING("Order No.")
                      ORDER(Ascending);
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order No."; rec."Order No.")
                {
                    Editable = false;
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                    Editable = false;
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                    Editable = false;
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    Editable = false;
                }
                field(Alias; getAlias(rec."Sell-to Customer No."))
                {
                    Editable = false;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    Editable = false;
                }
                field(NombreVendedor; getNombreVendedor(rec."Salesperson Code"))
                {
                    Editable = false;
                }
                field("Location Code"; rec."Location Code")
                {
                    Editable = false;
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                    Editable = false;
                }
                field("No. Guia"; getNoGuia(rec."Order No."))
                {
                    Editable = false;
                }
                field(Transportista; getNombreTransportista(rec."Order No."))
                {
                    Editable = false;
                }
                field(Comentario; getComentario(rec."Order No."))
                {
                    Editable = false;
                }
                field("Fecha ingreso"; rec."Order Date")
                {
                    Editable = false;
                }
                field("Hora ingreso"; rec."Order Time")
                {
                    Editable = false;
                }
                field("Fecha Aprobacion"; rec."Fecha Aprobacion")
                {
                    Editable = false;
                }
                field("Hora aprobacion"; rec."Hora Aprobacion")
                {
                    Editable = false;
                }
                field("Fecha Factura"; rec."Posting Date")
                {
                    Editable = false;
                }
                field("Hora factura"; rec."Posting Time")
                {
                    Editable = false;
                }
                field("Fecha envio"; rec."Shipment Date")
                {
                    Editable = false;
                }
                field("Hora envio"; rec."Shipment Time")
                {
                    Editable = false;
                }
                field("Fecha entrega"; rec."Fecha Recepcion")
                {
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }


    procedure getAlias(pComprador: Code[20]): Code[80]
    var
        lrCustomer: Record Customer;
    begin
        lrCustomer.Get(pComprador);
        exit(lrCustomer."Search Name");
    end;


    procedure getNombreVendedor(pVendedor: Code[20]): Text[50]
    var
        lrVendedor: Record "Salesperson/Purchaser";
    begin
        if lrVendedor.Get(pVendedor) then
            exit(lrVendedor.Name);
    end;


    procedure getNoGuia(pNoPedido: Code[20]): Code[20]
    var
        lrLineaHojaRutaRegistrada: Record "Lin. Hoja de Ruta Reg.";
    begin
        if pNoPedido <> '' then begin
            lrLineaHojaRutaRegistrada.Reset;
            lrLineaHojaRutaRegistrada.SetRange(lrLineaHojaRutaRegistrada."No. Pedido", pNoPedido);
            if lrLineaHojaRutaRegistrada.FindFirst then
                exit(lrLineaHojaRutaRegistrada."No. Hoja Ruta");
        end;
    end;


    procedure getNombreTransportista(pNoPedido: Code[20]): Text[50]
    var
        lrLineaHojaRutaRegistrada: Record "Lin. Hoja de Ruta Reg.";
        lrCabeceraHojaRutaRegistrada: Record "Cab. Hoja de Ruta Reg.";
        lrShipmentAgent: Record "Shipping Agent";
    begin
        if pNoPedido <> '' then begin
            lrLineaHojaRutaRegistrada.Reset;
            lrLineaHojaRutaRegistrada.SetRange(lrLineaHojaRutaRegistrada."No. Pedido", pNoPedido);
            if lrLineaHojaRutaRegistrada.FindFirst then begin
                lrCabeceraHojaRutaRegistrada.Get(lrLineaHojaRutaRegistrada."No. Hoja Ruta");
                if lrShipmentAgent.Get(lrCabeceraHojaRutaRegistrada."Cod. Transportista") then
                    exit(lrShipmentAgent.Name);
            end;
        end;
    end;


    procedure getComentario(pNoPedido: Code[20]): Text[250]
    var
        lrLineaHojaRutaRegistrada: Record "Lin. Hoja de Ruta Reg.";
    begin
        if pNoPedido <> '' then begin
            lrLineaHojaRutaRegistrada.Reset;
            lrLineaHojaRutaRegistrada.SetRange(lrLineaHojaRutaRegistrada."No. Pedido", pNoPedido);
            if lrLineaHojaRutaRegistrada.FindFirst then
                exit(lrLineaHojaRutaRegistrada.Comentarios);
        end;
    end;
}

