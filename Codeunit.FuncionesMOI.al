codeunit 56004 "Funciones MOI"
{
    //         MOI 01/04/2015  Se crea la CU para Ecuador
    //         MOI 21/04/2015  Se crea la funcion ModificaRUC
    //         MOI 10/04/2015  Se crea la funcion EstaEnLicencia
    //         MOI 26/05/2015  Se crea la funcion EliminarDevolucion
    // #30539  11/09/2015  MOI   Se crea la funcion BloquearProveedores
    // #39836  15/12/2015  MOI   Se crea la funcion ModificaNCF
    // NOTA: A partir de ahora es mas eficiente tener una CU por pais (Mismo numero en todos los paises) e ir haciendo según soliciten.

    Permissions = TableData "Purch. Inv. Header" = m;

    trigger OnRun()
    var
        lTextSelectorEcuador: Label '1 Modifica RUC en Historico Factura Venta,2 Objeto en Licencia,3 Eliminar Devolucion,4 Bloquear Proveedores,5 Modifica NCF Factura Compra';
    begin
        //Ecuador
        case (StrMenu(lTextSelectorEcuador, 0, 'Funciones MOI - Funciones Ecuador')) of
            1:
                if ModificaRUC then
                    Message(TextProcesoCorrecto);
            2:
                if EstaEnLicencia then
                    Message(TextProcesoCorrecto);
            3:
                if EliminarDevolucion then
                    Message(TextProcesoCorrecto);
            4:
                if BloquearProveedores then
                    Message(TextProcesoCorrecto);
            5:
                if ModificaNCF then
                    Message(TextProcesoCorrecto);
            else
                Message(ErrorProcesoCancelado);
        end;
    end;

    var
        ErrorProcesoCancelado: Label 'Proceso cancelado por el usuario.';
        TextProcesoCorrecto: Label 'Proceso finalizado con exito.';


    procedure EstaEnLicencia(): Boolean
    var
        lpPaginaMOI: Page PaginaMOI;
        lrPermisosLicencia: Record "License Permission";
    begin
        //Abre una pagina para preguntar si un objeto en cuestion está en la licencia.
        //Si no aparece ningun permiso es que no
        Clear(lpPaginaMOI);

        lpPaginaMOI.SetVisibleTipo(true);
        lpPaginaMOI.SetVisibleID(true);

        if lpPaginaMOI.RunModal = ACTION::OK then begin
            lrPermisosLicencia.Reset;
            lrPermisosLicencia.SetRange(lrPermisosLicencia."Object Type", lpPaginaMOI.GetTipo());
            lrPermisosLicencia.SetRange(lrPermisosLicencia."Object Number", lpPaginaMOI.GetID());

            if lrPermisosLicencia.FindFirst then begin
                if (lrPermisosLicencia."Read Permission" = lrPermisosLicencia."Read Permission"::" ") and
                  (lrPermisosLicencia."Insert Permission" = lrPermisosLicencia."Insert Permission"::" ") and
                  (lrPermisosLicencia."Modify Permission" = lrPermisosLicencia."Modify Permission"::" ") and
                  (lrPermisosLicencia."Delete Permission" = lrPermisosLicencia."Delete Permission"::" ") and
                  (lrPermisosLicencia."Execute Permission" = lrPermisosLicencia."Execute Permission"::" ") then begin
                    Message('No se tiene permiso');
                end
                else
                    Message('Los permisos que se tienen son:\Lectura=%1\Insercion=%2\Modificacion=%3\Eliminacion=%4\Ejecucion=%5',
                            lrPermisosLicencia."Read Permission",
                            lrPermisosLicencia."Insert Permission",
                            lrPermisosLicencia."Modify Permission",
                            lrPermisosLicencia."Delete Permission",
                            lrPermisosLicencia."Execute Permission");
            end
            else begin
                Message('No se tiene permiso');
            end;
            exit(true);
        end
        else begin
            Message(ErrorProcesoCancelado);
            exit(false);
        end;
    end;


    procedure ModificaRUC(): Boolean
    var
        lpPaginaMOI: Page PaginaMOI;
        lrHistoricoFacturaVenta: Record "Sales Invoice Header";
    begin
        //Abre una pagina y pregunta en que factura se quiere poner el RUC.
        Clear(lpPaginaMOI);

        lpPaginaMOI.SetVisibleFactura(true);
        lpPaginaMOI.SetVisibleRUC(true);

        if lpPaginaMOI.RunModal = ACTION::OK then begin
            lrHistoricoFacturaVenta.Reset;
            if lrHistoricoFacturaVenta.Get(lpPaginaMOI.GetFactura()) then begin
                lrHistoricoFacturaVenta."VAT Registration No." := lpPaginaMOI.GetRUC();
                lrHistoricoFacturaVenta.Modify(true);
                exit(true);
            end
            else
                Message('No existe la factura indicada');
        end
        else begin
            Message(ErrorProcesoCancelado);
            exit(false);
        end;
    end;


    procedure EliminarDevolucion(): Boolean
    var
        lpPaginaMOI: Page PaginaMOI;
        lrSalesHeader: Record "Sales Header";
    begin
        //Esta funcion abre una pagina y pregunta q devolucion de venta se quiere eliminar.
        //Al existir las predevoluciones, no se pueden borrar las devoluciones de la 36.
        Clear(lpPaginaMOI);

        lpPaginaMOI.SetVisibleNoDevolucion(true);

        if lpPaginaMOI.RunModal = ACTION::OK then begin
            lrSalesHeader.Reset;
            lrSalesHeader.SetRange(lrSalesHeader."Document Type", lrSalesHeader."Document Type"::"Return Order");
            lrSalesHeader.SetRange(lrSalesHeader."No.", lpPaginaMOI.GetNoDevolucion);
            if lrSalesHeader.FindFirst then begin
                exit(lrSalesHeader.Delete);
            end;
        end;
    end;


    procedure BloquearProveedores(): Boolean
    var
        lrProveedores: Record Vendor;
    begin
        //#30539:Inicio
        /*Segun la peticion, hay que bloquear todos los proveedores que tenga la direccion de correo con @ unicamente*/
        lrProveedores.Reset;
        lrProveedores.SetRange("E-Mail", '@');
        lrProveedores.ModifyAll(lrProveedores.Blocked, lrProveedores.Blocked::All);
        lrProveedores.SetRange("E-Mail", '');
        lrProveedores.ModifyAll(lrProveedores.Blocked, lrProveedores.Blocked::" ");
        exit(true);
        //#30539:Fin

    end;


    procedure ModificaNCF(): Boolean
    var
        lpPaginaMOI: Page PaginaMOI;
        lrHistoricoFacturaCompra: Record "Purch. Inv. Header";
        lrRetencionesFE: Record "Retenciones FE";
    /*       lcuComprobanteselectronicos: Codeunit "Comprobantes electronicos"; */
    begin
        //#39836:Inicio
        Clear(lpPaginaMOI);

        lpPaginaMOI.SetVisibleFactura(true);
        lpPaginaMOI.SetVisibleNCF(true);

        if lpPaginaMOI.RunModal = ACTION::OK then begin
            if lrHistoricoFacturaCompra.Get(lpPaginaMOI.GetFactura()) then begin
                lrHistoricoFacturaCompra."No. Comprobante Fiscal" := lpPaginaMOI.GetNCF();
                lrHistoricoFacturaCompra.Modify(false);
            end;
            lrRetencionesFE.Reset;
            lrRetencionesFE.SetRange(lrRetencionesFE."No. documento", lpPaginaMOI.GetFactura());
            if lrRetencionesFE.FindSet(true) then
                repeat
                    /* lrRetencionesFE."Num. doc. sustento" := lcuComprobanteselectronicos.PADSTR2(lrHistoricoFacturaCompra.Establecimiento, 3, '0') +
                                                                        lcuComprobanteselectronicos.PADSTR2(lrHistoricoFacturaCompra."Punto de Emision", 3, '0') +
                                                                        lcuComprobanteselectronicos.PADSTR2(lpPaginaMOI.GetNCF(), 9, '0'); */

                    lrRetencionesFE.Modify();
                until lrRetencionesFE.Next = 0;
            exit(true);
        end
        else begin
            Message(ErrorProcesoCancelado);
            exit(false);
        end;
        //#39836:Fin
    end;
}

