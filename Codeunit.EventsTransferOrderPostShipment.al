codeunit 55039 "Events TransfOrder-Post Ship"
{
    Permissions = TableData "G/L Entry" = r,
                TableData "Item Entry Relation" = i;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRun(var TransferHeader: Record "Transfer Header")
    begin
        //011
        ValidaCampo.Maestros(5740, TransferHeader."No.");
        ValidaCampo.Dimensiones(5740, TransferHeader."No.", 0, 0);
        //011

        //005
        ConfSant.GET;
        IF ConfSant."Funcionalidad Consig. Activa" THEN BEGIN
            //003
            TransferHeader.TESTFIELD("External Document No.");
            TransferHeader.TESTFIELD("Cod. Vendedor");
        END;
        //003

        //007
        IF ConfSant."Habilitar NCF en Consignacion" THEN BEGIN
            Location.GET(TransferHeader."Transfer-from Code");
            Location2.GET(TransferHeader."Transfer-to Code");
            IF (NOT TransferHeader."Devolucion Consignacion") AND (NOT TransferHeader.Correccion) THEN
                TransferHeader.TESTFIELD("No. Serie Comprobante Fiscal");
        END;
        //007
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCheckInvtPostingSetup', '', false, false)]
    local procedure OnAfterCheckInvtPostingSetup(var TransferHeader: Record "Transfer Header")
    var
        recTransportista: Record "Shipping Agent";
    begin
        //$014
        IF TransferHeader."No. Serie Comprobante Fiscal" <> '' THEN BEGIN
            recNoSeries.GET(TransferHeader."No. Serie Comprobante Fiscal");
            IF recNoSeries."Facturacion electronica" THEN BEGIN
                TransferHeader.TESTFIELD("Shipping Agent Code");
                recTransportista.GET(TransferHeader."Shipping Agent Code");
                recTransportista.TESTFIELD(Name);
                recTransportista.TESTFIELD("Tipo id.");
                recTransportista.TESTFIELD("VAT Registration No.");
                recTransportista.TESTFIELD(Placa);

                TransferHeader.TESTFIELD("Shipment Date");
                TransferHeader.TESTFIELD("Receipt Date");
                IF TransferHeader."Receipt Date" < TransferHeader."Shipment Date" THEN
                    ERROR(Err004);
            END;
        END;
        //$014
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeCopyTransLines', '', false, false)]
    local procedure OnBeforeCopyTransLines(TransferHeader: Record "Transfer Header")
    var
        lcuFuncionesEcuador: Codeunit "Funciones Ecuador";
    begin
        //#14637:Inicio
        lcuFuncionesEcuador.ActualizaDespachado(TransferHeader);
        //#14637:Fin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferShipmentLine: Record "Transfer Shipment Line"; TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        //002
        ItemJournalLine."Precio Unitario Cons. Inicial" := TransferShipmentLine."Precio Venta Consignacion";
        ItemJournalLine."Descuento % Cons. Inicial" := TransferShipmentLine."Descuento % Consignacion";
        ItemJournalLine."Importe Cons. bruto Inicial" := TransferShipmentLine."Precio Venta Consignacion" * -TransferShipmentLine.Quantity;
        ItemJournalLine."Importe Cons Neto Inicial" := -TransferShipmentLine."Importe Consignacion";
        ItemJournalLine."Pedido Consignacion" := TransferShipmentHeader."Pedido Consignacion";
        ItemJournalLine."Devolucion Consignacion" := TransferShipmentHeader."Devolucion Consignacion";
        ItemJournalLine."No. Mov. Prod. Cosg. a Liq." := TransferShipmentLine."No. Linea Pedido Consignacion";
        //002

        ItemJournalLine.ISBN := TransferShipmentLine.ISBN; //008
    end;

    //Pendiente modificar metodo ReserveItemJnlLine

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header")
    var
        NoSeriesMgt: Codeunit "No. Series";
        txt009: Label 'ANULADO';
    begin
        //002
        TransShptHeader."No. Serie Comprobante Fiscal" := TransHeader."No. Serie Comprobante Fiscal";
        TransShptHeader."Prioridad entrega consignacion" := TransHeader."Prioridad entrega consignacion";
        TransShptHeader."Cod. Vendedor" := TransHeader."Cod. Vendedor";
        TransShptHeader."Pedido Consignacion" := TransHeader."Pedido Consignacion";
        TransShptHeader."Devolucion Consignacion" := TransHeader."Devolucion Consignacion";
        //002

        //007
        IF ConfSant."Habilitar NCF en Consignacion" THEN BEGIN
            IF (NOT TransHeader."Devolucion Consignacion") AND (NOT TransHeader.Correccion) THEN BEGIN
                IF TransShptHeader."No. Comprobante Fiscal" = '' THEN
                    TransShptHeader."No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo(
                                                  TransHeader."No. Serie Comprobante Fiscal", TransHeader."Posting Date", TRUE);
                BuscaNoAutNCF(TransShptHeader."No. Serie Comprobante Fiscal", TransShptHeader);
                //015+
                //IF ValidaNCF(TransShptHeader."No. Comprobante Fiscal",TransShptHeader."No. Autorizacion Comprobante") THEN
                IF ValidaNCF(TransShptHeader."No. Comprobante Fiscal", TransShptHeader."No. Autorizacion Comprobante",
                    TransShptHeader."Punto de Emision Remision", TransShptHeader."Establecimiento Remision") THEN
                    //015-
                    ERROR(Err003, TSH."No.");
            END;
            IF TransHeader.Correccion THEN //010 INICIO - Anulacion de NCF por correccion
              BEGIN
                TransHeader.TESTFIELD("No. Correlativo a Anular");
                TSH.RESET;
                TSH.SETCURRENTKEY("No. Comprobante Fiscal");
                TSH.SETRANGE("No. Comprobante Fiscal", TransHeader."No. Correlativo a Anular");
                TSH.FINDFIRST;
                NCFAnulado.INIT;
                NCFAnulado.VALIDATE("No. documento", TSH."No.");
                NCFAnulado.VALIDATE("No. Comprobante Fiscal", TSH."No. Comprobante Fiscal");
                NCFAnulado.VALIDATE("No. Serie NCF Facturas", TSH."No. Serie Comprobante Fiscal");
                NCFAnulado.VALIDATE("Fecha anulacion", WORKDATE);
                NCFAnulado.VALIDATE("Tipo Documento", NCFAnulado."Tipo Documento"::"Remision Transferencia");
                //NCFAnulado.VALIDATE(Serie,TSH.Serie);
                NCFAnulado.INSERT;
                TSH1.GET(TSH."No.");
                TSH1.VALIDATE("NCF Anulado", TRUE);
                TSH1.VALIDATE("No. NCF Anulado", TSH."No. Comprobante Fiscal");
                //TSH1.VALIDATE("No. Serie Anulada",TSH.Serie);
                TSH1.VALIDATE("No. Comprobante Fiscal", txt009);
                TSH1.MODIFY;
                //010 FIN - Anulacion de NCF por correccion
            END;
        END;
        //007

        //#27882
        TransShptHeader."Hora ingreso" := TransHeader."Hora ingreso";
        TransShptHeader."Hora registro" := TransHeader."Hora registro";
        //#27882
    end;

    var
        //Traducción Francés Text001
        CFuncionesSantillana: Codeunit "Funciones Santillana";
        ReleaseTransferDoc: Codeunit "Release Transfer Document";
        ConfSant: Record "Config. Empresa";
        ValidaCampo: Codeunit "Valida Campos Requeridos";
        Location: Record Location;
        Location2: Record Location;
        SSH: Record "Sales Shipment Header";
        TSH: Record "Transfer Shipment Header";
        NCFAnulado: Record "NCF Anulados";
        TSH1: Record "Transfer Shipment Header";
        recNoSeries: Record "No. Series";
        Err003: Label 'Correlative number already exists and Shipment %1';//ESM=N£mero de Correlativo ya existe en Remisi¢n %1';
        Err004: Label 'La fecha de recepción no puede ser inferior a la fecha de envío.';

    PROCEDURE ValidaNCF(NCF: Code[20]; Naut: Code[30]; PuntoREmision: Code[3]; EstablecimientoRemision: Code[3]): Boolean;
    VAR
        NoSerieLine: Record "No. Series Line";
        UltcuatroTXT: Text[30];
        UltCuatro: Decimal;
        Longitud: Integer;
        NCFaBuscar: Text[30];
        Encontrado: Boolean;
        UltimoNumero: Integer;
        UltimoNumerotxt: Text[30];
        NuevoNum: Integer;
    BEGIN
        Encontrado := FALSE;
        TSH.RESET;
        TSH.SETRANGE("No. Comprobante Fiscal", NCF);
        TSH.SETRANGE("No. Autorizacion Comprobante", Naut);
        //015+
        TSH.SETRANGE("Establecimiento Remision", PuntoREmision);
        TSH.SETRANGE("Punto de Emision Factura", EstablecimientoRemision);
        //015-
        IF TSH.FINDFIRST THEN
            Encontrado := TRUE;

        SSH.RESET;
        SSH.SETRANGE("No. Comprobante Fisc. Remision", NCF);
        SSH.SETRANGE("No. Autorizacion Remision", Naut);
        //015+
        SSH.SETRANGE("Establecimiento Remision", PuntoREmision);
        SSH.SETRANGE("Punto de Emision Factura", EstablecimientoRemision);
        //015-
        IF SSH.FINDFIRST THEN
            Encontrado := TRUE;

        EXIT(Encontrado);
    END;

    PROCEDURE BuscaNoAutNCF(NoSerieNCF: Code[20]; var TransShptHeader: Record "Transfer Shipment Header");
    VAR
        NoSeriesLine: Record "No. Series Line";
    BEGIN
        //Se busca el No. de Autorizacion. Santillana Ecuador
        NoSeriesLine.RESET;
        NoSeriesLine.SETRANGE("Series Code", NoSerieNCF);
        NoSeriesLine.SETFILTER("Starting No.", '<=%1', TransShptHeader."No. Comprobante Fiscal");
        NoSeriesLine.SETFILTER("Ending No.", '>=%1', TransShptHeader."No. Comprobante Fiscal");
        NoSeriesLine.FINDFIRST;
        NoSeriesLine.CALCFIELDS("Facturacion electronica");         //$013
        IF NOT NoSeriesLine."Facturacion electronica" THEN          //
            NoSeriesLine.TESTFIELD("No. Autorizacion");
        NoSeriesLine.TESTFIELD(Establecimiento);
        NoSeriesLine.TESTFIELD("Punto de Emision");
        NoSeriesLine.TESTFIELD("Tipo Comprobante");
        TransShptHeader."No. Autorizacion Comprobante" := NoSeriesLine."No. Autorizacion";
        TransShptHeader."Tipo de Comprobante" := NoSeriesLine."Tipo Comprobante";
        TransShptHeader."Establecimiento Remision" := NoSeriesLine.Establecimiento;
        TransShptHeader."Punto de Emision Remision" := NoSeriesLine."Punto de Emision";
    END;

    /*

      Proyecto: Microsoft Dynamics Nav 2009
      AMS     : Agustin Mendez
      FES     : Fausto Serrata
      --------------------------------------------------------------------------
      No.     Fecha           Firma         Descripcion
      ------------------------------------------------------------------------
      001     04-Junio-09     AMS           Validamos que no hayan productos pendientes
                                            de entrega a clientes antes de enviar el actual.
      002     08-Junio-09     AMS           Pasamos los importes de consignacion a los historicos.
      003     08-Junio-09     AMS           Validamos Obligatorio No. Doc. Externo para devoluciones.
      004     08-Junio-09     AMS           Validamos Limite de credito excedido.
      005     28-Julio-10     AMS           La fecha de registro y de envio debe ser la fecha de trabajo
      006     06-Agosto-10    AMS           Funcionalidad para devolver envios desde transferencias
      007     16-Oct-12       AMS           NCF en Consignacion.
      008     21-Oct-12       AMS           ISBN
      011     28-Oct-12       AMS           Validacion de campos requeridos
      012     05-Dic-12       AMS           Cantidad de bultos
      $013    08/01/15        JML           Cambios en control de NCF para facturaci¢n electr¢nica.
                                            Cuando la serie es de Facturaci¢n electr¢nica no tiene autorizaci¢n.
      $014    24/01/15        JML           Campos obligatorios para facturaci¢n electr¢nica
      #14637  17/04/2015      MOI           Una vez acabado el proceso de registro, se tiene q actualizar el campo Despachado.
      #27882  01/02/2016      MOI           Se transfieren los nuevos campos de la tabla 5740 a la tabla 5744.
      015     26-FEB-2021     FES           SANTINAV-2204: Validar Punto Emision Remision y Establecimiento Remision en funcion ValidaNCF
    */
}