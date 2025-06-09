codeunit 55030 "Events Release Sales Document"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnRunOnAfterCopy', '', false, false)]
    local procedure OnRunOnAfterCopy(var SalesHeaderCopy: Record "Sales Header")
    begin
        //IF NOT blnIgnorarControles THEN BEGIN   //005
        IF NOT SalesHeaderCopy.SetIgnorarControles THEN BEGIN   //005
                                                                //003
            IF UserSetUp.GET(USERID) THEN BEGIN
                IF UserSetUp."Usuario Movilidad" THEN
                    ERROR(Error001);
            END;
            //003
        END;
        SalesHeaderCopy.SetIgnorarControles := false; //Pendiente validar que con este nuevo campo se mantenga la funcionalidad

        //027
        ValidaReq.Documento(36, SalesHeaderCopy."Document Type".AsInteger(), SalesHeaderCopy."No.");
        //027
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        TestDim(SalesHeader); //001
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    var
        CantEnPedVe: Decimal;
        CantEnTrans: Decimal;
        CantidadResta: Decimal;
        SalesLine: Record "Sales Line";
    begin
        //002
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER(SalesLine.Type, '<>%1', SalesLine.Type::" ");
        IF SalesLine.FINDSET THEN
            REPEAT
                Alm.GET(SalesLine."Location Code");
                IF Alm."Cant. Lineas a Man. Por dia" <> 0 THEN BEGIN
                    //Lineas de venta
                    SalesLine.RESET;
                    SalesLine.SETCURRENTKEY("Location Code", "Shipment Date");
                    SalesLine.SETRANGE("Location Code", Alm.Code);
                    SalesLine.SETRANGE("Shipment Date", WORKDATE);
                    IF SalesLine.FINDSET THEN
                        REPEAT
                            CantEnPedVe += SalesLine.Quantity;
                        UNTIL SalesLine.NEXT = 0;

                    //Lineas de transferencia
                    TransHeader.RESET;
                    TransHeader.SETRANGE("Transfer-from Code", Alm.Code);
                    TransHeader.SETRANGE(TransHeader."Posting Date", WORKDATE);
                    TransHeader.SETRANGE(TransHeader.Status, TransHeader.Status::Released);
                    IF TransHeader.FINDSET THEN
                        REPEAT
                            TrasnLine.RESET;
                            TrasnLine.SETRANGE("Document No.", TransHeader."No.");
                            IF TrasnLine.FINDSET THEN
                                REPEAT
                                    CantEnTrans += TrasnLine.Quantity;
                                UNTIL TrasnLine.NEXT = 0;
                        UNTIL TransHeader.NEXT = 0;

                    CantidadResta := Alm."Cant. Lineas a Man. Por dia" - (CantEnPedVe + CantEnTrans);
                    IF (CantidadResta <= Alm."Aviso cuando resten") AND (CantidadResta > 0) THEN
                        MESSAGE(txt002, FORMAT(CantidadResta), Alm.Code);

                    IF (CantidadResta <= 0) THEN
                        MESSAGE(txt003, Alm.Code);
                END;
            UNTIL SalesLine.NEXT = 0;
        //002
    end;

    PROCEDURE TestDim(SalesHeader: Record "Sales Header");
    VAR
        GrDim: Record "Dimension Set Entry";
        ConfEmpresa: Record "Config. Empresa";
    BEGIN
        ConfEmpresa.GET();
        IF ConfEmpresa."Dim. Tipo Facturacion" <> '' THEN BEGIN
            GrDim.SETRANGE("Dimension Set ID", SalesHeader."Dimension Set ID");
            GrDim.SETRANGE("Dimension Code", ConfEmpresa."Dim. Tipo Facturacion");
            IF NOT GrDim.FINDFIRST THEN
                ERROR(Err001, GrDim.FIELDCAPTION("Dimension Code"), ConfEmpresa."Dim. Tipo Facturacion",
                                SalesHeader.FIELDCAPTION("Document Type"), SalesHeader."Document Type");
        END;
    END;

    /*PROCEDURE SetIgnorarControles(blnPrmIgnorar: Boolean); //Pendiente validar donde se llama y como podemos parsar el valor al cu
    BEGIN
        blnIgnorarControles := blnPrmIgnorar;
    END;*/

    var
        //Traducción francés Text002
        //Traducción español Text005
        Alm: Record Location;
        TransHeader: Record "Transfer Header";
        TrasnLine: Record "Transfer Line";
        UserSetUp: Record "User Setup";
        ValidaReq: Codeunit "Valida Campos Requeridos";
        blnIgnorarControles: Boolean;
        Err001: Label 'You must specify %1 %2 for %3 %4';//ESP=Se debe especificar %1 %2 para el %3 %4;ESM=Se debe especificar %1 %2 para el %3 %4';
        txt002: Label 'Restan %1 productos por manipular para el almacén %2 segun la capacidad máxima de manipulación del mismo';
        txt003: Label 'Items to be handled per day exceeded the estimated capacity for warehouse %1';//ESM=Cantidad de productos a manipular por d¡a a excedido la capacidad estimada para el almac‚n %1';
        Error001: Label 'Mobility users can not release Sales Orders';//ESM=Usuarios de Movilidad no pueden lanzar pedidos de venta';

    /*

          Proyecto: Implementacion Microsoft Dynamics Nav
          AMS     : Agustin Mendez
          GRN     : Guillermo Roman
          ------------------------------------------------------------------------
          No.     Fecha           Firma         Descripcion
          ------------------------------------------------------------------------
          001     07-Agosto-11     GRN          Se creo la funcion TestDim para validar
          002     02-Julio-12      AMS          Se envia mensaje de capacidad m xima de manipulaci¢n
          003     08-Agosto-12     AMS          Usuarios de movilidad no pueden lanzar pedidos de venta
          027     28/10/12         AMS          Valida Campos y Dimensiones Requeridas
    */

}