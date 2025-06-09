codeunit 65006 Varios
{
    Permissions = TableData "Sales Shipment Header" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Transfer Shipment Header" = rimd;

    trigger OnRun()
    begin

        //recRem.GET('VR-344368');
        //recRem."Ship-to Name" := 'Corporación de la Asociación de Los Adventistas';
        //recRem.MODIFY;

        //recRem.GET('VR-344360');
        //recRem."Ship-to Name" := 'Corporación de la Asociación de Los Adventistas';
        //recRem.MODIFY;
    end;

    var
        recFacCmp: Record "Purch. Inv. Header";
        recNC: Record "Sales Cr.Memo Header";
        Text001: Label 'La remisión %1 ya tiene otra fecha';
        recRem: Record "Sales Shipment Header";
        dt1: DateTime;
        dt2: DateTime;
        durDiferencia: Duration;


    procedure ActualizaFechaTransPed(codPrmPedido: Code[20]; datPrmFechaIni: Date; datPrmFechaFin: Date)
    var
        recRemVta: Record "Sales Shipment Header";
    begin

        //recRemVta.GET(codPrmRem);
        recRemVta.Reset;
        recRemVta.SetCurrentKey("Order No.");
        recRemVta.SetRange("Order No.", codPrmPedido);
        recRemVta.FindFirst;
        if (recRemVta."Fecha inicio trans." <> 0D) and (recRemVta."Fecha inicio trans." <> datPrmFechaIni) then
            Error(Text001, recRemVta."No.");
        if (recRemVta."Fecha fin trans." <> 0D) and (recRemVta."Fecha fin trans." <> datPrmFechaFin) then
            Error(Text001, recRemVta."No.");

        recRemVta."Fecha inicio trans." := datPrmFechaIni;
        recRemVta."Fecha fin trans." := datPrmFechaFin;
        recRemVta.Modify;
    end;


    procedure ActualizaFechaTransRem(codPrmRem: Code[20]; datPrmFechaIni: Date; datPrmFechaFin: Date)
    var
        recRemVta: Record "Sales Shipment Header";
    begin

        recRemVta.Get(codPrmRem);
        recRemVta."Fecha inicio trans." := datPrmFechaIni;
        recRemVta."Fecha fin trans." := datPrmFechaFin;
        recRemVta.Modify;
    end;


    procedure CorregirSubtotalFactura(codPrmFac: Code[20])
    var
        recImpuesto: Record "Impuestos FE";
        recDetalle: Record "Detalle FE";
    begin

        recImpuesto.Reset;
        recImpuesto.SetFilter("No. documento", codPrmFac);
        if recImpuesto.FindSet then
            repeat
                recDetalle.Get(recImpuesto."No. documento", recImpuesto."No. linea");
                recImpuesto.Subtotal := recDetalle.Cantidad * recDetalle."Precio Unitario";
                recImpuesto.Modify;
            until recImpuesto.Next = 0;
    end;


    procedure CorregirFechaTransfer(codPrmTranfer: Code[20])
    var
        recTransfer: Record "Transfer Shipment Header";
    begin
        recTransfer.Get(codPrmTranfer);
        recTransfer."Receipt Date" := 20150123D;
        if recTransfer."Shipping Agent Code" = '' then
            recTransfer."Shipping Agent Code" := 'UIO-0003';
        recTransfer.Modify;
    end;


    procedure CorregirTipoComprobanteRetencion(codPrmDoc: Code[20])
    var
        recFacCmp: Record "Purch. Inv. Header";
        recRetFe: Record "Retenciones FE";
    begin
        recFacCmp.Get(codPrmDoc);

        recRetFe.Reset;
        recRetFe.SetRange("No. documento", codPrmDoc);
        if recRetFe.FindSet then
            repeat
                recRetFe."Cod. doc. sustento" := recFacCmp."Tipo de Comprobante";
                recRetFe.Comprobante := recFacCmp."Desc. Tipo de Comprobante";
                recRetFe.Modify;
            until recRetFe.Next = 0;
    end;


    procedure CorregirDireccionTransfer(codPrmTransfer: Code[20])
    var
        recTransfer: Record "Transfer Shipment Header";
        recAlmacen: Record Location;
    begin

        recTransfer.Get(codPrmTransfer);
        recAlmacen.Get(recTransfer."Transfer-to Code");
        recTransfer."Transfer-to Name" := recAlmacen.Name;
        recTransfer."Transfer-to Name 2" := recAlmacen."Name 2";
        recTransfer."Transfer-to Address" := recAlmacen.Address;
        recTransfer."Transfer-to Address 2" := recAlmacen."Address 2";
        recTransfer."Transfer-to Post Code" := recAlmacen."Post Code";
        recTransfer."Transfer-to City" := recAlmacen.City;
        recTransfer."Transfer-to County" := recAlmacen.County;
        recTransfer."Trsf.-to Country/Region Code" := recAlmacen."Country/Region Code";
        recTransfer.Modify;
    end;


    procedure ActualizarAutorizacionRetenciones()
    var
        recDocFe: Record "Documento FE";
    begin

        recDocFe.Reset;
        recDocFe.SetRange("Tipo documento", recDocFe."Tipo documento"::Retencion);
        if recDocFe.FindSet then
            repeat
                ActualizarAutorizaHistoricos(recDocFe, recDocFe."No. autorizacion");
            until recDocFe.Next = 0;
    end;


    procedure ActualizarAutorizaHistoricos(recPrmDocFE: Record "Documento FE"; codPrmAutorizacion: Code[40])
    var
        recCabFac: Record "Sales Invoice Header";
        recCabRemVta: Record "Sales Shipment Header";
        recCabRemTrans: Record "Transfer Shipment Header";
        recCabNC: Record "Sales Cr.Memo Header";
        recHistRet: Record "Historico Retencion Prov.";
        recHistRetDoc: Record "Retencion Doc. Reg. Prov.";
        recLinRetFE: Record "Retenciones FE";
        recDocFE: Record "Documento FE";
        optTipo: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
    begin

        recHistRet.Reset;
        recHistRet.SetRange("No. documento", recPrmDocFE."No. documento");
        if recHistRet.FindSet then
            recHistRet.ModifyAll("No. autorizacion NCF", codPrmAutorizacion);

        recHistRetDoc.Reset;
        recHistRetDoc.SetRange("Tipo documento", optTipo);
        recHistRetDoc.SetRange("No. documento", recPrmDocFE."No. documento");
        if recHistRetDoc.FindSet then
            recHistRetDoc.ModifyAll("No. autorizacion NCF", codPrmAutorizacion);

    end;


    procedure ResetFechasCompras()
    var
        recFac: Record "Purch. Inv. Header";
        recRetencion: Record "Historico Retencion Prov.";
    begin
        recFac.ModifyAll("Document Date", WorkDate);
        if recRetencion.FindSet then
            repeat
                recRetencion."Fecha Registro" := WorkDate;
                recRetencion.Modify;
            until recRetencion.Next = 0;
    end;
}

