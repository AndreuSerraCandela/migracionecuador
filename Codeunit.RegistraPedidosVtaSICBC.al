codeunit 50118 "Registra Pedidos Vta. SIC_BC"
{
    //  Proyecto: Implementacion Microsoft Dynamics Nav
    // 
    //  LDP: Luis Jose De La Cruz Paredes
    //  ------------------------------------------------------------------------
    //  No.        Fecha           Firma    Descripcion
    //  ------------------------------------------------------------------------
    //  001        24/03/2023      LDP      Registro firmas DSPOS por lote.
    //  002        20/11/2023      LDP      Se actualiza fecha deeste campo para eviar error de firma de documento.
    //  003        04/12/2023      LDP      Se filtra por campo "External Document No.", no solo por "No. Documento SIC."
    //                                      para evitar error "Ya tiene factura" en Notas Creditos.
    //  004        12/01/2023      LDP      Nueva version de funcion registrar factura "RegistraFacturaVs2".

    Permissions = TableData "Sales Header" = rimd,
                  TableData "Gen. Journal Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Cabecera Log Registro POS" = rimd;

    trigger OnRun()
    begin
        //VerificarDocumento();
        //RegistraFactura();//004+-
        RegistraFacturaVs2();//004+-
                             //LiquidarPendiente();

        /*// Solo para liquidar documentos masivos
        StarDate := 01012022D;
        
        SalesInvHeader.RESET;
        SalesInvHeader.SETFILTER("Posting Date",'%1..',StarDate);
        //SalesInvHeader.SETRANGE("No.",'VFR10-001725');
        SalesInvHeader.SETRANGE("Venta TPV",TRUE);
        IF SalesInvHeader.FINDSET THEN BEGIN
          REPEAT
            //SalesInvHeader2.RESET;
            SalesInvHeader2.GET(SalesInvHeader."No.");
            SalesInvHeader2.CALCFIELDS("Remaining Amount");
            //SalesInvHeader.CALCFIELDS("Remaining Amount");
            IF SalesInvHeader2."Remaining Amount" > 1 THEN
               RegistrarCobrosSCR2(SalesInvHeader."No.");
        
          UNTIL SalesInvHeader.NEXT=0;
          MESSAGE('Finalizado!');
        END;
        */

    end;

    var
        SH: Record "Sales Header";
        SSH: Record "Sales Shipment Header";
        SalesPostPrint_WMS: Codeunit "Sales-Post + Print SIC_BC";
        SH2: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvHeader2: Record "Sales Invoice Header";
        Customer: Record Customer;
        I: Integer;
        Registrar: Boolean;
        Registrar2: Boolean;
        TipoBloqueo: Enum "Customer Blocked";
        CustomerNo: Code[20];
        SalesLine2: Record "Sales Line";
        Item: Record Item;
        RegistrarVentasenLoteDsPOS: Codeunit "Registrar Ventas en Lote DsPOS";
        Text002: Label 'Registrada Correctamente';
        Numlogs: Integer;
        rCabLog: Record "Cabecera Log Registro POS";
        Transfer_SIC: Codeunit Transfer_SIC;
        StarDate: Date;
        Fecha: Date;
        MediosdePagoSIC: Record "Medios de Pago SIC";
        CabVentasSIC: Record "Cab. Ventas SIC";
        LineasVentasSIC: Record "Lineas Ventas SIC";
        Importe: Decimal;
        wFechaProceso: Date;
        SalesLine: Record "Sales Line";
        MediosdePagosSIC: Record "Medios de Pago SIC";
        LiqFechaAnt: Boolean;
        FechaLiq: Date;
        bancoLiq: Code[20];
        "ParametrosLocxPaís": Record "Parametros Loc. x País";
        CantidadLin: Integer;
        SIH: Record "Sales Invoice Header";
        MontoVenta: Decimal;
        SNRH: Record "Sales Cr.Memo Header";
        MontoDevolucion: Decimal;
        Error001: Label 'El monto devuelto es mayor al de la venta';


    procedure RegistraFactura()
    var
        LineasVentasSIC: Record "Lineas Ventas SIC";
        Text001: Label 'Please check the order amount and the amount in the intermediate table  | %1  | %2  | %3';
        SL_: Record "Sales Line";
        propina: Decimal;
        Text002: Label 'Error en los medios de pagos  | %1  | %2  | %3';
        MediosdePagosSIC: Record "Medios de Pago SIC";
        SH_: Record "Sales Header";
    begin
        Transfer_SIC.ActualizarMediodepago();
        rCabLog.Init;
        rCabLog.Fecha := WorkDate;
        rCabLog."Hora Inicio" := FormatTime(Time);
        rCabLog.Insert(true);
        Numlogs := rCabLog."No. Log";
        Fecha := 20230301D;
        I := 0;
        SH.Reset;
        SH.SetCurrentKey("Venta TPV", "No. Documento SIC");
        SH.SetRange("Document Type", SH."Document Type"::Invoice, SH."Document Type"::"Credit Memo");
        SH.SetFilter("No. Documento SIC", '<>%1', '');
        SH.SetRange("Venta TPV", true);
        //SH.SETRANGE("No.",'PV2-000007814');
        //SH.SETFILTER("No.",'=%1','NCY1-000039');
        //SH.SETFILTER("Posting Date",'..%1',Fecha);
        //LDP-001++ //Valida que la venta de las facturas no sea menor a las devoluciones de esta.
        /*
        IF SH."Document Type" = SH."Document Type"::"Credit Memo" THEN
           IF SH.FINDFIRST THEN
          BEGIN
            SIH.RESET;
            SNRH.RESET;
            SIH.SETRANGE("No.", SH."No. Comprobante Fiscal Rel.");
            //SH.SETRANGE("No. Comprobante Fiscal Rel.", SIH."No.");
            MontoVenta:= SIH."Amount Including VAT";
            SNRH.SETRANGE("No. Comprobante Fiscal Rel.", SIH."No.");
            MontoDevolucion := SNRH."Amount Including VAT";
              IF (MontoVenta - MontoDevolucion - SH."Amount Including VAT") > 0.01 THEN
                 BEGIN
                  ERROR:= Error001;
                 END;
          END;
        */
        //LDP-001+-//Valida que la venta de las facturas no sea menor a las devoluciones de esta.


        //SH.VALIDATE("Amoun Incluiding Vat");
        //LDP-001+-
        //SH.SETFILTER("Error Registro",'=%1','');
        //SH.SETFILTER("No.",'<>%1','VFZ1T02-001778');
        //SH.SETCURRENTKEY("Actualizado WMS");
        //SH.SETRANGE("No.",'NCY1-000038');//LDP - 12/12/2023 //Para probar liquidacion factura por Hamlet
        //SH.SETRANGE("No.",No_Documento_Registrar);//Prueba+-
        propina := 0;

        if SH.FindSet() then
            repeat
                //RegistrarVentasenLoteDsPOS.AsignarDimensiones(SH);
                Registrar := true;
                if wFechaProceso <> 0D then begin
                    SH."Posting Date" := wFechaProceso;
                    SH."Document Date" := wFechaProceso;// 002+-
                    SH.Modify;
                end;

                //      SL_.RESET;
                //      SL_.SETRANGE("Document No.",SH."No.");
                //      SL_.SETRANGE("Document Type",SH."Document Type");
                //      SL_.SETRANGE("Location Code",SH."Location Code");
                //      SL_.CALCSUMS("Amount Including VAT");
                //      IF SL_.FINDSET(TRUE,FALSE) THEN BEGIN
                //        REPEAT
                //          IF (SL_.COUNT > 0) AND (SL_."Amount Including VAT" <= 0) THEN BEGIN
                //            SL_.DELETE;
                //            Registrar:=FALSE;
                //          END;
                //        UNTIL SL_.NEXT=0;
                //      END;

                SL_.Reset;
                SL_.SetRange("Document No.", SH."No.");
                SL_.SetRange("Document Type", SH."Document Type");
                SL_.SetRange("Location Code", SH."Location Code");
                SL_.CalcSums("Amount Including VAT");
                if SL_.FindSet() then begin
                    repeat
                        LineasVentasSIC.Reset;
                        LineasVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                            //LineasVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                        LineasVentasSIC.SetRange("Location Code", SH."Location Code");
                        LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+- Se agrega Filtro por campo SIC
                        LineasVentasSIC.SetRange("No. linea", SL_."Line No.");
                        LineasVentasSIC.SetRange(codproducto, SL_."No.");
                        if not LineasVentasSIC.FindFirst then begin
                            //SL_.DELETE; //001+- 17/11/2023 //No es necesario que borre las lineas si no  valida en tablas intermedia.
                            SH."Error Registro" := 'No se encuetran las líneas en tablas intermedias para validacion de importe';//001+- 17/11/2023
                            SH.Modify;
                            Registrar := false;
                        end;
                    until SL_.Next = 0;
                end;
                //
                SalesLine.Reset;
                SalesLine.SetRange("Document No.", SH."No.");
                //SalesLine.SETRANGE(Type,SalesLine.Type::Item);
                SalesLine.SetRange("Document Type", SH."Document Type");
                SalesLine.SetRange("Location Code", SH."Location Code");
                SalesLine.CalcSums("Amount Including VAT");
                CantidadLin := SalesLine.Count;
                ParametrosLocxPaís.Reset;
                ParametrosLocxPaís.SetRange(País, 'EC');//LDP-001+-
                if ParametrosLocxPaís.FindFirst then begin
                    if CantidadLin > ParametrosLocxPaís."Cantidad Lin. por factura" then
                        Registrar := false;
                end;
                //ConfigMaxLineasReportes
                SalesLine.Reset;
                SalesLine.SetRange("Document No.", SH."No.");
                SalesLine.SetRange("Document Type", SH."Document Type");
                SalesLine.SetRange("Location Code", SH."Location Code");
                SalesLine.CalcSums("Amount Including VAT");
                //01/01/2023+ LDP+- Se busca el importe total de las líneas en medios de pagos de tabla intermedia.
                Clear(Importe);
                Importe := 0;
                MediosdePagosSIC.Reset;
                //MediosdePagosSIC.SETCURRENTKEY("Location Code","No. Serie Pos");
                MediosdePagosSIC.SetCurrentKey("No. documento", "No. documento SIC", "Location Code");//LDP-001+- Se establece SetCurrenKey //01/01/2024 //LDP+- "No. documento" a setcurrentkey
                MediosdePagosSIC.SetRange("No. documento", SH."No.");//LDP-001+- Se filtra por No.
                MediosdePagosSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+-
                                                                                       //MediosdePagosSIC.SETRANGE("Fecha registro",SH."Posting Date");
                MediosdePagosSIC.SetRange("Location Code", SH."Location Code");
                if MediosdePagosSIC.FindSet then begin
                    repeat
                        Importe += MediosdePagosSIC.Importe;
                    until MediosdePagosSIC.Next = 0;
                end;
                /* //LDP+ Ya se filtra por tipo de documento al inicio, no es necesario filtrar nuevamente.
                IF SH."Document Type" = SH."Document Type"::Invoice THEN BEGIN
                   MediosdePagosSIC.SETRANGE("Tipo documento",1);//01/01/2024 //LDP+-
                {ELSE
                  MediosdePagosSIC.SETRANGE("Tipo documento",2);}
                    IF MediosdePagosSIC.FINDSET THEN BEGIN
                      REPEAT
                        Importe+= MediosdePagosSIC.Importe;
                      UNTIL MediosdePagosSIC.NEXT=0;
                    END;
                END;
                */ //LDP- Ya se filtra por tipo de documento al inicio, no es necesario filtrar nuevamente.
                   //01/01/2024 //LDP-
                   //01/01/2024+ //LDP+
                if ((Importe - SalesLine."Amount Including VAT") > 1) or ((Importe - SalesLine."Amount Including VAT") < -1) then begin
                    Registrar := false;
                    SH."Error Registro" := 'El importe en las líneas no coincide con el importe en Medios de Pago SIC';
                    SH.Modify;
                end;
                /* -No se hace necesario validar nueva vez el importe
                IF ((Importe - SalesLine."Amount Including VAT") > 1) OR ((Importe - SalesLine."Amount Including VAT") < -1) THEN
                  Importe:=0;
                IF Importe=0 THEN BEGIN
                    MediosdePagosSIC.RESET;
                    //MediosdePagosSIC.SETCURRENTKEY("Location Code","No. Serie Pos");
                    MediosdePagoSIC.SETRANGE("No. documento",SH."No.");//LDP-001+-
                    MediosdePagosSIC.SETRANGE("No. documento SIC",SH."No. Documento SIC");//LDP-001+-
                    //MediosdePagosSIC.SETRANGE("No. documento SIC",SH."External Document No.");//LDP-001+-
                    //MediosdePagosSIC.SETRANGE("Fecha registro",SH."Posting Date");
                    MediosdePagosSIC.SETRANGE("Location Code",SH."Location Code");
                    IF SH."Document Type" = SH."Document Type"::Invoice THEN BEGIN
                       MediosdePagosSIC.SETRANGE("Tipo documento",1);
                    {ELSE
                      MediosdePagosSIC.SETRANGE("Tipo documento",2);}
                        IF MediosdePagosSIC.FINDSET THEN BEGIN
                          REPEAT
                            Importe+= MediosdePagosSIC.Importe;
                          UNTIL MediosdePagosSIC.NEXT=0;
                        END;
                    END;
                END;
                */
                //01/01/2024+ //LDP- -No se hace necesario validar nueva vez el importe.

                LineasVentasSIC.Reset;
                LineasVentasSIC.SetCurrentKey("No. documento", "No. documento SIC");//01/01/2024+ //LDP
                LineasVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                    //LineasVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                                                                    //LineasVentasSIC.SETRANGE("Location Code",SH."Location Code");//01/01/2024+ //LDP
                LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+-

                //LDP+- //01/01/2024+ Comentado, porque ya se filtra por No. documento,No. documento SIC
                /*
                IF SH."Document Type" = SH."Document Type"::"Credit Memo" THEN BEGIN
                  LineasVentasSIC.SETRANGE("Tipo documento",2);
                END ELSE BEGIN
                  LineasVentasSIC.SETRANGE("Tipo documento",1);
                END;
                */
                //LDP+- //01/01/2024-

                LineasVentasSIC.CalcSums("Importe ITBIS Incluido");
                LineasVentasSIC.CalcSums(Importe);

                propina := LineasVentasSIC."Importe ITBIS Incluido" * 0.1;
                if SH."Posting No." = '' then begin
                    SH."Posting No." := SH."No.";
                    SH.Modify;
                end;

                //***************************************************************************
                //Validacion del monto de la cabecera
                CabVentasSIC.Reset;
                CabVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                 //CabVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                CabVentasSIC.SetRange("Cod. Almacen", SH."Location Code");
                CabVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");

                LineasVentasSIC.Reset;
                LineasVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                    //LineasVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                LineasVentasSIC.SetRange("Location Code", SH."Location Code");
                LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");

                if SH."Document Type" = SH."Document Type"::"Credit Memo" then begin
                    LineasVentasSIC.SetRange("Tipo documento", 2);
                    CabVentasSIC.SetRange("Tipo documento", 2);
                end else begin
                    LineasVentasSIC.SetRange("Tipo documento", 1);
                    CabVentasSIC.SetRange("Tipo documento", 1);
                end;
                LineasVentasSIC.CalcSums("Importe ITBIS Incluido");
                LineasVentasSIC.CalcSums(Importe);
                if CabVentasSIC.FindFirst then;
                //Valido si las lineas estan completas

                if ((CabVentasSIC.Monto) - SalesLine."Amount Including VAT") > 1 then begin
                    Transfer_SIC.TransferLineaActualizada3(SH."No.", SH."Document Type", SH."Location Code", SH."No. Documento SIC");
                    Registrar := false;
                end;
                //****************************************************************************
                SalesLine.Reset;
                SalesLine.SetCurrentKey("Document No.");
                SalesLine.SetRange("Document No.", SH."No.");
                SalesLine.SetRange("Document Type", SH."Document Type");
                //SalesLine.SETRANGE("No. Documento SIC",SH. "No. Documento SIC");//"LDP-001+-"
                SalesLine.SetRange("Location Code", SH."Location Code");
                SalesLine.CalcSums("Amount Including VAT");
                //IF ((Importe - SalesLine."Amount Including VAT") > 1) OR ((Importe - SalesLine."Amount Including VAT") < -1) AND (SH."Document Type" = SH."Document Type"::Invoice )THEN //01/01/2024 //LDP+ comentado ya que solo considera un tipo de documento.
                if ((Importe - SalesLine."Amount Including VAT") > 1) or ((Importe - SalesLine."Amount Including VAT") < -1) then //01/01/2024 //LDP
                  begin
                    Registrar := false;
                    //              SH_.RESET;
                    //              SH_.SETRANGE("No.",SH."No.");
                    //              SH_.SETRANGE("Document Type",SH."Document Type");
                    //              IF SH_.FINDSET(TRUE,FALSE) THEN BEGIN
                    SH."Error Registro" := 'El importe en el medio de pago es mayor al del documento';
                    SH.Modify;
                    //CrearPago(SH."No.",SH."Posting No.",SH."Location Code");
                    //END;
                end;

                //////////////////
                //01/01/2024 //LDP+ Comentado, ya que este filtro se ha realizado más arriba.
                /*
                CLEAR(Importe);
                 Importe:=0;
                 MediosdePagosSIC.RESET;
                 MediosdePagosSIC.SETRANGE("No. documento",SH."No.");//LDP-001+-
                 //MediosdePagosSIC.SETCURRENTKEY("Location Code","No. Serie Pos");
                 MediosdePagosSIC.SETRANGE("No. documento SIC",SH."No. Documento SIC");
                 //MediosdePagosSIC.SETRANGE("Fecha registro",SH."Posting Date");
                 MediosdePagosSIC.SETRANGE("Location Code",SH."Location Code");
                 IF SH."Document Type" = SH."Document Type"::Invoice THEN BEGIN
                    MediosdePagosSIC.SETRANGE("Tipo documento",1);
                 {ELSE
                   MediosdePagosSIC.SETRANGE("Tipo documento",2);}
                     IF MediosdePagosSIC.FINDSET THEN BEGIN
                       REPEAT
                         Importe+= MediosdePagosSIC.Importe;
                       UNTIL MediosdePagosSIC.NEXT=0;
                     END;
                 END;

                 IF (Importe - SalesLine."Amount Including VAT") > 1 THEN
                   Importe:=0;
                 IF Importe=0 THEN BEGIN
                     MediosdePagosSIC.RESET;
                     MediosdePagosSIC.SETCURRENTKEY("Location Code","No. Serie Pos");
                     //MediosdePagosSIC.SETRANGE("No. Serie Pos",SH."Posting No.");//LDP-001+-
                     //MediosdePagosSIC.SETRANGE("No. Serie Pos",SH."External Document No.");//LDP-001+-
                     MediosdePagosSIC.SETRANGE("No. documento",SH."No.");//LDP-001+-
                     MediosdePagosSIC.SETRANGE("No. documento SIC",SH."No. Documento SIC");//LDP-001+-
                     //MediosdePagosSIC.SETRANGE("Fecha registro",SH."Posting Date");
                     MediosdePagosSIC.SETRANGE("Location Code",SH."Location Code");
                     IF SH."Document Type" = SH."Document Type"::Invoice THEN BEGIN
                        MediosdePagosSIC.SETRANGE("Tipo documento",1);
                     {ELSE
                       MediosdePagosSIC.SETRANGE("Tipo documento",2);}
                         IF MediosdePagosSIC.FINDSET THEN BEGIN
                           REPEAT
                             Importe+= MediosdePagosSIC.Importe;
                           UNTIL MediosdePagosSIC.NEXT=0;
                         END;
                     END;
                 END;
                 */
                //01/01/2024 //LDP- Comentado, ya que este filtro se ha realizado más arriba.

                //IF  ((Importe - SalesLine."Amount Including VAT") < 1) OR ((Importe - SalesLine."Amount Including VAT") < -1) AND (SH."Document Type" = SH."Document Type"::Invoice )THEN//01/01/2023 //LDP+-
                if ((Importe - SalesLine."Amount Including VAT") < 1) or ((Importe - SalesLine."Amount Including VAT") < -1) then //01/01/2023 //LDP+- Para notas de creditos y pedidios
                  begin
                    Registrar := true;
                    //              SH_.RESET;
                    //              SH_.SETRANGE("No.",SH."No.");
                    //              SH_.SETRANGE("Document Type",SH."Document Type");
                    //              IF SH_.FINDSET(TRUE,FALSE) THEN BEGIN
                    //                SH_."Error Registro":= '';
                    //                SH_.MODIFY;
                    //
                    //              END;
                end;
                //////////////////

                // Si el usuario esta bloqueado lo desbloquea
                Clear(CustomerNo);
                if Customer.Get(SH."Sell-to Customer No.") then;
                if Customer.Blocked <> Customer.Blocked::" " then begin
                    TipoBloqueo := Customer.Blocked;
                    CustomerNo := SH."Sell-to Customer No.";
                    Customer.Blocked := Customer.Blocked::" ";
                    Customer.Modify;
                end;

                //01/01/2024 //LDP+ Comentado, ya que este filtro se ha realizado más arriba.
                /*
                CabVentasSIC.RESET;
                CabVentasSIC.SETRANGE("No. documento",SH."No.");//LDP-001+-
                //CabVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                CabVentasSIC.SETRANGE("Cod. Almacen",SH."Location Code");
                CabVentasSIC.SETRANGE("No. documento SIC",SH."No. Documento SIC");//LDP-001+-
                CabVentasSIC.SETRANGE(Fecha,SH."Posting Date");
                CabVentasSIC.SETRANGE("Tipo documento",1);
                IF (CabVentasSIC.FINDFIRST) AND (SH."Document Type" <> SH."Document Type"::"Credit Memo") THEN BEGIN
                */
                //01/01/2024 //LDP- Comentado, ya que este filtro se ha realizado más arriba.

                if ((CabVentasSIC.Monto - SalesLine."Amount Including VAT") > 1) or ((CabVentasSIC.Monto - SalesLine."Amount Including VAT") < -1) then begin
                    Registrar := false;
                    //              SH_.RESET;
                    //              SH_.SETRANGE("No.",SH."No.");
                    //              SH_.SETRANGE("Document Type",SH."Document Type");
                    //              IF SH_.FINDSET(TRUE,FALSE) THEN BEGIN
                    SH."Error Registro" := 'Error favor verificar el monto de las lineas';
                    SH.Modify;
                    //END;
                end;
                //END;

                if (LineasAEnviar) and (Registrar) then begin
                    SH."Error Registro" := '';
                    SH.Validate(Status, SH.Status::Released);
                    SH.Validate(Ship, true);
                    SH.Validate(Invoice, true);
                    SH.Modify(true);
                    Commit;
                    if not SalesPostPrint_WMS.Run(SH) then begin
                        SH2.Reset;

                        if SH2.Get(SH."Document Type", SH."No.") then begin //JPG PARA EVISTAR ERROR DE CABECERA YA MODIFICADA
                            SH2."Error Registro" := CopyStr(GetLastErrorText, 1, 100);
                            if SH2.Modify then;

                            RegistrarVentasenLoteDsPOS.InsertarDetalleSIC(SH, 0, true, CopyStr(GetLastErrorText, 1, 100), Numlogs);//LDP-001+-
                        end;
                    end
                    else begin
                        I += 1;
                        SH2.Reset;
                        RegistrarVentasenLoteDsPOS.InsertarDetalleSIC(SH, 0, false, 'El documento fue instertado correctamente Documento No_ ' + SH."No.", Numlogs);//LDP-001+-
                        if SH2.Get(SH."Document Type", SH."No.") then begin
                            SH2."Error Registro" := '';
                            if SH2.Modify then;
                            //001-LDP++
                            //FE_2_0(SH);
                            //001-LDP+-
                        end;
                    end;
                end else begin
                    if (SH."Error Registro" <> '')
                     then begin // si ya tiene factura eliminar log error
                        SalesInvHeader.Reset;
                        SalesInvHeader.SetCurrentKey("External Document No.", "No. Documento SIC");//001+- /04/12/2023
                                                                                                   //SalesInvHeader.SETRANGE("Order No.",SH."No.");
                        SalesInvHeader.SetRange("External Document No.", SH."No.");//003+- //04/12/2023
                        SalesInvHeader.SetRange("No. Documento SIC", SH."No. Documento SIC");//LDP-001+-
                        if SalesInvHeader.FindFirst then begin
                            SH_.Reset;
                            SH_.SetRange("No.", SH."No.");
                            SH_.SetRange("Document Type", SH."Document Type");
                            if SH_.FindSet() then begin
                                SH_."Error Registro" := 'Ya tiene factura';
                                if SH_.Modify then;
                            end;
                            //COMMIT;
                        end;
                    end;
                end;

                // Le coloca el estado anterior al usuario
                if Customer.Get(CustomerNo) then begin
                    Customer.Blocked := TipoBloqueo;
                    Customer.Modify;
                end;
            //
            until SH.Next = 0; //OR (I >= 10);

        // rCabLog."Fecha Fin" := WORKDATE;
        // rCabLog."Hora Fin"  := FormatTime(TIME);
        // rCabLog.MODIFY(FALSE);

        rCabLog."Fecha Fin" := WorkDate;
        rCabLog."Hora Fin" := FormatTime(Time);
        rCabLog.Modify(false);

    end;


    procedure RegistraFacturaManual()
    var
        LineasVentasSIC: Record "Cab. Ventas SIC";
        SalesLine: Record "Sales Line";
        Text001_: Label 'Please check the order amount and the amount in the intermediate table  | %1  | %2  | %3';
        propina: Decimal;
        Text002_: Label 'Error en los medios de pagos  | %1  | %2  | %3';
        rCabLog: Record "Cabecera Log Registro POS";
        CduPOS: Codeunit "Funciones Addin DSPos";
        recTPV: Record "Configuracion TPV";
        Seleccion: Integer;
        PagFecha: Page "Petición de Fecha";
        Text000: Label 'Registrar Facturas en su Fecha.,Solicitar Nueva Fecha de Registro.';
        Text001: Label 'Se procederá a Registrar y Liquidar todas las ventas de Tienda\¿Desea Continuar?';
        Text002: Label 'Proceso Terminado';
        Error001: Label 'Cancelado a Petición del Usuario';
        Error002: Label 'Proceso Sólo Disponible en Servidor Central';
        Error003: Label 'La fecha de registro no puede ser inferior a la fecha actual';
    begin

        if GuiAllowed then begin

            wFechaProceso := 0D;
            if not Confirm(Text001, false) then
                Error(Error001);

            Seleccion := StrMenu(Text000, 1);
            if Seleccion = 0 then
                Error(Error001);

            if Seleccion = 2 then begin
                Clear(PagFecha);
                PagFecha.LookupMode(true);

                if PagFecha.RunModal = ACTION::Yes then begin
                    wFechaProceso := PagFecha.DevolverFecha();
                    case true of
                        (wFechaProceso = 0D):
                            Error(Error001);
                        //(wFechaProceso < WORKDATE):ERROR(Error003);
                        (wFechaProceso < WorkDate):
                            Error(Error003);
                    end;
                end
                else
                    Error(Error001);

            end;

        end;

        //VerificarDocumento();
        //RegistraFactura();
        RegistraFacturaVs2();//004+-
    end;


    procedure VerificarDocumento()
    var
        SH_: Record "Sales Header";
        SL_: Record "Sales Line";
    begin
        SH.Reset;
        SH.SetCurrentKey("Venta TPV", "No. Documento SIC");
        SH.SetRange("Document Type", SH."Document Type"::Invoice, SH."Document Type"::"Credit Memo");
        SH.SetFilter("No. Documento SIC", '<>%1', '');
        SH.SetRange("Venta TPV", true);
        if SH.FindSet then begin
            repeat
                //***************************************************************************
                //          Validacion del montode la cabecera
                CabVentasSIC.Reset;
                CabVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                 //CabVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                CabVentasSIC.SetRange("Cod. Almacen", SH."Location Code");
                CabVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+-

                LineasVentasSIC.Reset;
                LineasVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                    //LineasVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                LineasVentasSIC.SetRange("Location Code", SH."Location Code");
                LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+-

                if SH."Document Type" = SH."Document Type"::"Credit Memo" then begin
                    LineasVentasSIC.SetRange("Tipo documento", 2);
                    CabVentasSIC.SetRange("Tipo documento", 2);
                end else begin
                    LineasVentasSIC.SetRange("Tipo documento", 1);
                    CabVentasSIC.SetRange("Tipo documento", 1);
                end;
                LineasVentasSIC.CalcSums("Importe ITBIS Incluido");
                LineasVentasSIC.CalcSums(Importe);
                if CabVentasSIC.FindFirst then;
                // Valido si las lineas estan completas
                SalesLine.Reset;
                SalesLine.SetRange("Document No.", SH."No.");
                SalesLine.SetRange("Document Type", SH."Document Type");
                SalesLine.SetRange("Location Code", SH."Location Code");
                SalesLine.CalcSums("Amount Including VAT");
                if ((CabVentasSIC.Monto) - SalesLine."Amount Including VAT") > 1 then begin
                    //Transfer_SIC.TransferLineaActualizada3(SH."External Document No.",SH."Document Type",SH."Location Code");//LDP-001+-Se filtra por No. Documento Sic.
                    Transfer_SIC.TransferLineaActualizada3(SH."No.", SH."Document Type", SH."Location Code", SH."No. Documento SIC");//LDP-001+-Se filtra por No. Documento Sic.
                                                                                                                                     //Registrar := FALSE;
                end;

                SL_.Reset;
                SL_.SetRange("Document No.", SH."No.");
                SL_.SetRange("Document Type", SH."Document Type");
                SL_.SetRange("Location Code", SH."Location Code");
                SL_.CalcSums("Amount Including VAT");
                if SL_.FindSet() then begin
                    repeat
                        LineasVentasSIC.Reset;
                        LineasVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                            //LineasVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                        LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+-
                        LineasVentasSIC.SetRange("Location Code", SH."Location Code");
                        LineasVentasSIC.SetRange("No. linea", SL_."Line No.");
                        LineasVentasSIC.SetRange(codproducto, SL_."No.");
                        if not LineasVentasSIC.FindFirst then begin
                            //SL_.DELETE; //001+- 17/11/2023 //No es necesario que borre las lineas si no  valida en tablas intermedia.
                            SH."Error Registro" := 'No se encuetran las lineas en tablas intermedias para validacion de importe';//001+- 17/11/2023
                            SH.Modify;
                            Registrar := false;
                        end;
                    until SL_.Next = 0;
                end;


                Clear(Importe);
                Importe := 0;
                MediosdePagosSIC.Reset;
                MediosdePagosSIC.SetCurrentKey("Location Code", "No. Serie Pos");
                MediosdePagosSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                     //MediosdePagosSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                MediosdePagosSIC.SetRange("No. documento SIC", SH."No. Documento SIC");
                //MediosdePagosSIC.SETRANGE("Fecha registro",SH."Posting Date");
                MediosdePagosSIC.SetRange("Location Code", SH."Location Code");
                if SH."Document Type" = SH."Document Type"::Invoice then begin
                    MediosdePagosSIC.SetRange("Tipo documento", 1);
                    /*ELSE
                      MediosdePagosSIC.SETRANGE("Tipo documento",2);*/
                    if MediosdePagosSIC.FindSet then begin
                        repeat
                            Importe += MediosdePagosSIC.Importe;
                        until MediosdePagosSIC.Next = 0;
                    end;
                end;
                if Importe < SalesLine."Amount Including VAT" then
                    Importe := 0;
                if Importe = 0 then begin
                    MediosdePagosSIC.Reset;
                    MediosdePagosSIC.SetCurrentKey("Location Code", "No. Serie Pos");
                    //MediosdePagosSIC.SETRANGE("No. Serie Pos",SH."Posting No.");//LDP-001+-
                    //MediosdePagosSIC.SETRANGE("No. Serie Pos",SH."No.");//LDP-001+-
                    MediosdePagosSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                    MediosdePagosSIC.SetRange("No. documento SIC", SH."No. Documento SIC");
                    //MediosdePagosSIC.SETRANGE("Fecha registro",SH."Posting Date");
                    //MediosdePagosSIC.SETRANGE("Location Code",SH."Location Code");
                    if SH."Document Type" = SH."Document Type"::Invoice then begin
                        MediosdePagosSIC.SetRange("Tipo documento", 1);
                        /*ELSE
                          MediosdePagosSIC.SETRANGE("Tipo documento",2);*/
                        if MediosdePagosSIC.FindSet then begin
                            repeat
                                Importe += MediosdePagosSIC.Importe;
                            until MediosdePagosSIC.Next = 0;
                        end;
                    end;
                end;
                //****************************************************************************

                if ((Importe - SalesLine."Amount Including VAT") > 1) or ((Importe - SalesLine."Amount Including VAT") < -1) and (SH."Document Type" = SH."Document Type"::Invoice) then begin
                    //Registrar:= FALSE;
                    SH_.Reset;
                    SH_.SetRange("No.", SH."No.");
                    SH_.SetRange("Document Type", SH."Document Type");
                    if SH_.FindSet() then begin
                        SH_."Error Registro" := 'El importe en el medio de pago es mayor al del documento';
                        SH_.Modify;
                        //CrearPago(SH."No.",SH."Posting No.",SH."Location Code");
                        //CrearPago(SH."External Document No.",SH."Posting No.",SH."Location Code");
                        CrearPago(SH."No.", SH."Posting No.", SH."Location Code");
                    end;
                end;
            until SH.Next = 0;
        end;

    end;

    local procedure LineasAEnviar(): Boolean
    var
        SL_: Record "Sales Line";
    begin
        SL_.Reset;
        SL_.SetRange("Document Type", SH."Document Type");
        SL_.SetRange("Document No.", SH."No.");
        if SH."Document Type" = SH."Document Type"::Invoice then
            SL_.SetFilter("Qty. to Ship", '<>%1', 0);
        if not SL_.FindFirst then begin
            RegistrarVentasenLoteDsPOS.InsertarDetalleSIC(SH, 0, true, 'Error: no se encontraron lineas a enviar ', Numlogs);
            exit(false);
        end
        else
            exit(true);
    end;


    procedure RegistraNotaCR()
    var
        LineasVentasSIC: Record "Lineas Ventas SIC";
        SalesLine: Record "Sales Line";
        Text001: Label 'Please check the order amount and the amount in the intermediate table  | %1  | %2  | %3';
        propina: Decimal;
        Text002: Label 'Error en los medios de pagos  | %1  | %2  | %3';
    begin
        I := 0;
        SH.Reset;
        SH.SetRange("Document Type", SH."Document Type"::"Credit Memo");
        //SH.SETFILTER("No.",'=%1','VNC01-1010000001');
        //SH.SETCURRENTKEY("Actualizado WMS");
        SH.SetRange("Venta TPV", true);
        propina := 0;

        propina := 0;
        // rCabLog.INIT;
        // rCabLog.Fecha          := WORKDATE;
        // rCabLog."Hora Inicio"  := FormatTime(TIME);
        // rCabLog.INSERT(TRUE);
        // Numlogs := rCabLog."No. Log";

        if SH.FindSet then
            repeat
                Registrar := true;
                SH.SetHideValidationDialog(true);
                // IF SH.Origen = SH.Origen::"Punto de Venta" THEN BEGIN
                SalesLine.Reset;
                SalesLine.SetRange("Document No.", SH."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("Document Type", SH."Document Type");
                SalesLine.CalcSums("Amount Including VAT");
                SalesLine.CalcSums(Amount);

                LineasVentasSIC.Reset;
                LineasVentasSIC.SetRange("No. documento", SH."No.");//LDP-001+-
                                                                    //LineasVentasSIC.SETRANGE("No. documento",SH."External Document No.");//LDP-001+-
                LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");//LDP-001+-
                if SH."Document Type" = SH."Document Type"::"Credit Memo" then begin
                    LineasVentasSIC.SetRange("Tipo documento", 2);
                end else begin
                    LineasVentasSIC.SetRange("Tipo documento", 1);
                end;
                LineasVentasSIC.CalcSums("Importe ITBIS Incluido");
                LineasVentasSIC.CalcSums(Importe);

                propina := LineasVentasSIC."Importe ITBIS Incluido" * 0.1;

                //        IF  COPYSTR(SH."No. Comprobante Fiscal",1,3) = 'B14' THEN BEGIN
                //            IF ABS(ROUND(ROUND(SalesLine.Amount,0.04,'<'),1,'=') - ROUND(ROUND((LineasVentasSIC.Importe ),0.01,'>'),1,'=')) > 1.5 THEN BEGIN
                //              //ERROR(Text001 ,FORMAT(ROUND(ROUND(SalesLine."Amount Including VAT",0.04,'<'),1,'=') ),FORMAT(ROUND(ROUND(LineasVentasSIC."Importe ITBIS Incluido",0.01,'>'),1,'=')),SH."No.");
                //              SH."Error Registro":=STRSUBSTNO(Text001 ,FORMAT(ROUND(ROUND(SalesLine.Amount,0.04,'<'),1,'=') ),FORMAT(ROUND(ROUND(LineasVentasSIC.Importe,0.01,'>'),1,'=')),SH."No.");
                //              SH.MODIFY;
                //              Registrar := FALSE;
                //            END;
                //        END ELSE BEGIN
                //            IF ABS(ROUND(ROUND(SalesLine."Amount Including VAT",0.04,'<'),1,'=') - ROUND(ROUND((LineasVentasSIC."Importe ITBIS Incluido" ),0.01,'>'),1,'=')) > 1.5 THEN BEGIN
                //              //ERROR(Text001 ,FORMAT(ROUND(ROUND(SalesLine."Amount Including VAT",0.04,'<'),1,'=') ),FORMAT(ROUND(ROUND(LineasVentasSIC."Importe ITBIS Incluido",0.01,'>'),1,'=')),SH."No.");
                //              SH."Error Registro":=STRSUBSTNO(Text001 ,FORMAT(ROUND(ROUND(SalesLine."Amount Including VAT",0.04,'<'),1,'=') ),FORMAT(ROUND(ROUND(LineasVentasSIC."Importe ITBIS Incluido",0.01,'>'),1,'=')),SH."No.");
                //              SH.MODIFY;
                //              Registrar := FALSE;
                //            END;
                //        END;

                // Si el usuario esta bloqueado lo desbloquea
                Clear(CustomerNo);
                if Customer.Get(SH."Sell-to Customer No.") then;
                if Customer.Blocked <> Customer.Blocked::" " then begin
                    TipoBloqueo := Customer.Blocked;
                    CustomerNo := SH."Sell-to Customer No.";
                    Customer.Blocked := Customer.Blocked::" ";
                    Customer.Modify;
                end;
                //
                //        SalesLine2.RESET;
                //        SalesLine2.SETRANGE("Document No.",SH."No.");
                //        SalesLine2.SETRANGE(Type,SalesLine2.Type::Item);
                //        IF SalesLine2.FINDSET THEN BEGIN
                //          REPEAT
                //          IF Item.GET(SalesLine2."No.") THEN;
                //          IF Item."Prevent Negative Inventory" <> Item."Prevent Negative Inventory"::No THEN BEGIN
                //            Item."Prevent Negative Inventory" := Item."Prevent Negative Inventory"::No;
                //            Item.MODIFY;
                //          END;
                //          UNTIL SalesLine2.NEXT=0;
                //        END;

                if (Registrar) then begin
                    SH.Validate(Status, SH.Status::Released);
                    //SH.VALIDATE(Ship,FALSE);
                    //SH.VALIDATE(Invoice,FALSE);
                    SH.Modify();
                    Commit;
                    if not SalesPostPrint_WMS.Run(SH) then begin
                        SH2.Reset;

                        if SH2.Get(SH."Document Type", SH."No.") then begin //JPG PARA EVISTAR ERROR DE CABECERA YA MODIFICADA
                            SH2."Error Registro" := CopyStr(GetLastErrorText, 1, 100);
                            //MESSAGE(FORMAT(COPYSTR(GETLASTERRORTEXT,1,130)));
                            if SH2.Modify then;
                        end;
                    end
                    else begin
                        I += 1;
                        SH2.Reset;
                        if SH2.Get(SH."Document Type", SH."No.") then begin
                            SH2."Error Registro" := StrSubstNo(Text002, Format(Round(Round(SalesLine."Amount Including VAT", 0.04, '<'), 1, '=')), Format(Round(Round(LineasVentasSIC."Importe ITBIS Incluido", 1.01, '>'), 1, '=')), SH."No.");
                            if SH2.Modify then;
                        end;
                    end;
                end else begin
                    //      IF SH."Error Registro" <> '' THEN BEGIN // si ya tiene factura eliminar log error
                    //        SalesInvHeader.RESET;
                    //        SalesInvHeader.SETRANGE("Order No.",SH."No.");
                    //        IF SalesInvHeader.FINDFIRST THEN
                    //          BEGIN
                    //            SH."Error Registro" := '';
                    //            IF SH.MODIFY THEN;
                    //            //COMMIT;
                    //        END;
                    //      END;
                end;

                // Le coloca el estado anterior al usuario
                if Customer.Get(CustomerNo) then begin
                    Customer.Blocked := TipoBloqueo;
                    Customer.Modify;
                end;
                //
                RegistrarVentasenLoteDsPOS.InsertarDetalleSIC(SH, 0, false, StrSubstNo(Text002, SH."No. Fiscal TPV"), Numlogs);
            until (SH.Next = 0); //OR (I >= 10);
        // rCabLog."Fecha Fin" := WORKDATE;
        // rCabLog."Hora Fin"  := FormatTime(TIME);
        // rCabLog.MODIFY(FALSE);
    end;


    procedure Numlog(numL: Integer)
    begin
        Numlogs := numL;
    end;


    procedure FormatTime(timEntrada: Time): Time
    var
        texHora: Text;
        timSalida: Time;
    begin

        texHora := Format(timEntrada);
        Evaluate(timSalida, texHora);
        exit(timSalida);
    end;


    procedure RegistrarCobrosSCR2(DocNum: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIL: Record "Sales Invoice Line";
    begin

        NoLin := 0;

        dImporte := 0;
        ImporteNeto := 0;

        SIH2.Reset;
        SIH2.Get(DocNum);
        SIH2.CalcFields("Remaining Amount");


        SIH.Reset;
        SIH.SetRange("No.", DocNum);
        if (SIH.FindFirst) and (SIH2."Remaining Amount" > 1) then;
        // Cajaxsucursal.SETRANGE(Caja,SalesInvHeader."Shortcut Dimension 1 Code");
        // IF Cajaxsucursal.FINDFIRST THEN

        MediosdePagoMG.Reset;
        MediosdePagoMG.SetCurrentKey("Tipo documento", "No. documento");
        MediosdePagoMG.SetRange("Tipo documento", 1, 2);
        MediosdePagoMG.SetFilter("No. documento", '%1|%2', SIH."Order No.", SIH."Pre-Assigned No.");//LDP-001+-
        //MediosdePagoMG.SETFILTER("No. documento SIC",'%1|%2',SIH."No. Documento SIC",SIH."No. Documento SIC");//LDP-001+-
        MediosdePagoMG.SetFilter("Cod. medio de pago", '<>%1&<>%2', '', '99');

        if SIH."Venta TPV" = true then begin
            if MediosdePagoMG.FindSet then
                repeat
                    NoLin += 1000;

                    ConfMediosdepagos.Get(MediosdePagoMG."Cod. medio de pago");
                    if ConfMediosdepagos.Credito then
                        exit;

                    SIL.Reset;
                    SIL.SetRange("Document No.", SIH."No.");
                    SIL.CalcSums("Amount Including VAT");

                    Bancostienda.Reset;
                    Bancostienda.SetRange("Cod. Tienda", SIH.Tienda);
                    if Bancostienda.FindFirst then;

                    Bancostienda.TestField("Cod. Banco");

                    //ConfMediosdepagos.TESTFIELD("Account No.");
                    GenJnlLine.Init;
                    GenJnlLine."Line No." := NoLin;
                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine."Document No." := SIH."No.";
                    GenJnlLine."Posting Date" := SIH."Posting Date";
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate("Account No.", SIH."Sell-to Customer No.");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                    //GenJnlLine.VALIDATE("Bal. Account No.",Conceptos.Codigo);
                    GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SIH."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                    GenJnlLine.Validate("Credit Amount", MediosdePagoMG.Importe);
                    //GenJnlLine.VALIDATE("Credit Amount",SalesInvoiceLine."Amount Including VAT");
                    //MESSAGE('%1',dImporte);
                    GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                    GenJnlLine.Validate("Applies-to Doc. No.", SIH."No.");
                    //GenJnlLine.VALIDATE("Dimension Set ID" ,SIH."Dimension Set ID");
                    GenJnlLine."Salespers./Purch. Code" := SIH."Salesperson Code";
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", SIH."Shortcut Dimension 1 Code");
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", SIH."Shortcut Dimension 2 Code");


                    OldCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                    OldCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                    OldCustLedgEntry.SetRange("Customer No.", SIH."Sell-to Customer No.");
                    //OldCustLedgEntry.SETRANGE(Open,FALSE);
                    OldCustLedgEntry.SetRange(Open, true);
                    if OldCustLedgEntry.FindFirst then begin
                        OldCustLedgEntry.Open := true;
                        OldCustLedgEntry."Forma de Pago" := ConfMediosdepagos."Cod. Forma Pago";//LDP-DSPOS+- Para que la forma de pago del pago sea la misma que la del documento registrado.
                        OldCustLedgEntry.Modify(true);
                    end;

                    GenJnlPostLine.RunWithCheck(GenJnlLine);
                until MediosdePagoMG.Next = 0;
        end;
    end;

    local procedure TryCreateNewQueue(ProcessCode: Code[50]; ProcessURLWS: Text[150]; ProcessSoapAction: Text[50]; ProcessData: Text; ResponseData: Text; var QueueId: Integer; NumeroAcceso: Code[20]; TransationId: Text[50]; TransationIdRecibido: Text[50]; Solictud_XML_Enviada: Text; Solictud_XML_Recibida: Text; Solictud_PDF_Enviada: Text; Solictud_PDF_Recibida: Text; ListadoErrores: Text[250]; FechaDocumento: Text[20]; Xml_SF: Text) Success: Boolean
    var
        AsyncNAVProcessQueue: Record "Conf. Medios de pago";
    begin
        //LDP-001+-
        /*
        AsyncNAVProcessQueue.LOCKTABLE;
        IF NOT AsyncNAVProcessQueue.GET(ProcessCode) THEN
        BEGIN
        AsyncNAVProcessQueue.INIT;
        AsyncNAVProcessQueue."Entry No." := 0;
        END;

      WITH AsyncNAVProcessQueue DO BEGIN

        IF NumeroAcceso <> '' THEN
        "Process Status" :=1
        ELSE
        "Process Status" :=2;
        "Process Code" := ProcessCode;
        "Process Start Date & Time" := CURRENTDATETIME;
      //  IF Xml_SF <> '' THEN
      //  SetProcessDataSF(Xml_SF);
      //  IF ProcessData <>'' THEN
      //  SetProcessData(ProcessData);
      //  IF ResponseData <>'' THEN
      //  SetProcessResponse(ResponseData);

        "Process User Id" := USERID;
        "URL Web Service" := ProcessURLWS;
        "Soap Action" := ProcessSoapAction;
        "Transaction Id" := TransationId;
        "Numero de Acceso"   := NumeroAcceso;
        "Listado de Errores" := ListadoErrores;
        "Transaction Recibido" := TransationIdRecibido;
        FechaEmisionDocumento  := FechaDocumento;
      //  IF Solictud_PDF_Enviada <> '' THEN
      //  SetSolicitudPDF_Enviado(Solictud_PDF_Enviada);
      //  IF Solictud_PDF_Recibida <>'' THEN
      //  SetSolicitudPDF_Recibido(Solictud_PDF_Recibida);
      //  IF Solictud_XML_Enviada <>'' THEN
      //  SetSolicitudXML_Enviado(Solictud_XML_Enviada);
      //  IF Solictud_XML_Recibida <> '' THEN
      //  SetSolicitudXML_Recibido(Solictud_XML_Recibida);
        IF NumeroAcceso <> '' THEN
        "Numero de Acceso Origen"  :=  NumeroAcceso;
        IF MODIFY(TRUE) THEN
         EXIT(TRUE);
       IF NOT INSERT(TRUE) THEN
          EXIT(FALSE);
        QueueId := "Entry No.";

        //IF NOT wEvitarCommit THEN //#232158
          COMMIT;
      END;

      //EXIT(OnNewQueueInserted(AsyncNAVProcessQueue));
      */
        //LDP-001+-

    end;


    procedure CrearPago(NumDoc: Code[20]; NumRDoc: Code[20]; LCode: Code[20])
    var
        CabVentasSIC: Record "Cab. Ventas SIC";
        LineasVentasSIC: Record "Lineas Ventas SIC";
        MPSIC: Record "Medios de Pago SIC";
        MPSIC2: Record "Medios de Pago SIC";
        MPSIC3: Record "Medios de Pago SIC";
        MPSIC4: Record "Medios de Pago SIC";
        SalesHeader: Record "Sales Header";
        NumSIC: Code[20];
        Import: Decimal;
        SIH: Record "Sales Invoice Header";
    begin


        SalesHeader.Reset;
        SIH.SetRange("No.", NumDoc);
        if SIH.FindFirst then;
        SIH.CalcFields("Amount Including VAT");
        CabVentasSIC.Reset;
        CabVentasSIC.SetRange("No. documento SIC", SIH."No. Documento SIC");
        //CabVentasSIC.SETRANGE(Fecha,SalesHeader."Posting Date");



        if CabVentasSIC.FindFirst then begin
            NumSIC := ConvertStr(CabVentasSIC."No. documento", '-', ',');
            LineasVentasSIC.Reset;
            LineasVentasSIC.SetRange("No. documento", CabVentasSIC."No. documento");
            LineasVentasSIC.SetRange("No. documento SIC", CabVentasSIC."No. documento SIC");
            //LineasVentasSIC.SETRANGE("Location Code",LCode);
            LineasVentasSIC.CalcSums("Importe ITBIS Incluido");


            Clear(Import);
            MPSIC3.Reset;
            //MPSIC3.SETCURRENTKEY("No. documento SIC","No. Serie Pos");
            MPSIC3.SetRange("No. documento SIC", SIH."No. Documento SIC");
            MPSIC3.SetRange("No. documento", SIH."No.");//LDP+-
            //MPSIC3.SETRANGE("No. Serie Pos",SIH."No.");
            MPSIC3.CalcSums(Importe);
            Import := MPSIC3.Importe;
            //MPSIC3.DELETEALL(TRUE);
            if MPSIC3.FindSet then begin
                repeat
                    if CabVentasSIC.Monto <> Import then
                        //MPSIC3.DELETE;//001+- 17/11/2023 //No es necesario borrar el registro.
                        SH."Error Registro" := 'El importe en el medio de pago es mayor al del documento';//001+- //Se agrega descripcion error. 17/11/2023
                    SH.Modify;
                until MPSIC3.Next = 0;
            end else begin

                MPSIC4.Reset;
                //MPSIC3.SETCURRENTKEY("No. documento SIC","No. Serie Pos");
                //MPSIC4.SETRANGE("No. Serie Pos",SIH."No.");//LDP-001+-
                MPSIC4.SetRange("No. documento", SIH."No.");//LDP-001+-
                MPSIC4.SetRange("No. documento SIC", SIH."No. Documento SIC");//LDP-001+-
                                                                              //MPSIC4.SETRANGE("No. Serie Pos",SIH."External Document No.");//LDP-001+-
                MPSIC4.CalcSums(Importe);
                //MPSIC3.DELETEALL(TRUE);
                if MPSIC4.FindSet and (CabVentasSIC.Monto <> MPSIC4.Importe) then begin
                    repeat
                        //MPSIC4.DELETE;//001+- 17/11/2023 //No es necesario borrar el registro.
                        SH."Error Registro" := 'El importe en el medio de pago es mayor al del documento';//001+- //Se agrega descripcion error. 17/11/2023
                        SH.Modify;
                    until MPSIC4.Next = 0;
                end;
            end;


            //IF ((CabVentasSIC.Monto - LineasVentasSIC."Importe ITBIS Incluido") >= -1) AND ( (CabVentasSIC.Monto - LineasVentasSIC."Importe ITBIS Incluido") <= 1) THEN
            if (CabVentasSIC.Monto <> MPSIC3.Importe) then begin
                MPSIC.Reset;
                MPSIC.SetCurrentKey("No. Serie Pos");
                MPSIC.SetRange("No. Serie Pos", NumRDoc);
                if not MPSIC.FindFirst then begin
                    MPSIC2.Init;
                    MPSIC2."Tipo documento" := 1;
                    MPSIC2."No. documento" := NumDoc;
                    MPSIC2."Location Code" := CabVentasSIC."Cod. Almacen";
                    MPSIC2."No. Serie Pos" := NumRDoc;
                    MPSIC2.Importe := CabVentasSIC.Monto;
                    MPSIC2."Cod. medio de pago" := '2';
                    MPSIC2."No. documento Pos" := SelectStr(2, NumSIC);
                    MPSIC2."No. linea" := '1';
                    MPSIC2."Fecha registro" := CabVentasSIC.Fecha;
                    MPSIC2."No. documento SIC" := SIH."No. Documento SIC";
                    if not MPSIC2.Insert(true) then begin
                        //              MPSIC.RESET;
                        //              MPSIC.SETCURRENTKEY("No. Serie Pos");
                        //              MPSIC.SETRANGE("No. documento",SELECTSTR(2,NumSIC)+'-1');
                        //              IF MPSIC.FINDFIRST THEN
                        //                BEGIN
                        //                  MPSIC2.INIT;
                        //                  MPSIC2."Tipo documento":=1;
                        //                  MPSIC2."No. documento":= NumDoc;
                        //                  MPSIC2."Location Code":=CabVentasSIC."Cod. Almacen";
                        //                  MPSIC2."No. Serie Pos":=NumRDoc;
                        //                  MPSIC2.Importe:= CabVentasSIC.Monto;
                        //                  MPSIC2."Cod. medio de pago":='2';
                        //                  MPSIC2."No. documento Pos":=SELECTSTR(2,NumSIC);
                        //                  MPSIC2."No. linea":='1';
                        //                  MPSIC2."Fecha registro":=CabVentasSIC.Fecha;
                        //                  MPSIC2."No. documento SIC":=SH."No. Documento SIC";
                        //                  IF MPSIC2.INSERT THEN;
                        //              END;
                    end;
                    Registrar2 := true;
                end;



            end;
            //        MPSIC3.RESET;
            //        MPSIC3.SETRANGE("No. documento SIC",SalesHeader."No. Documento SIC");
            //        IF MPSIC3.FINDSET(TRUE,TRUE) THEN BEGIN
            //        REPEAT
            //            MPSIC3.DELETE;
            //        UNTIL MPSIC3.NEXT=0;
            //        END;
            //
            //        MPSIC3.RESET;
            //        MPSIC3.SETRANGE("No. Serie Pos",NumRDoc);
            //        IF MPSIC3.FINDSET(TRUE,TRUE) THEN BEGIN
            //        REPEAT
            //            MPSIC3.DELETE;
            //        UNTIL MPSIC3.NEXT=0;
            //        END;
            Clear(Importe);
            MPSIC.Reset;
            MPSIC.SetRange("No. documento SIC", SalesHeader."No. Documento SIC");
            MPSIC.CalcSums(Importe);
            Importe := MPSIC2.Importe;
            if Importe = 0 then begin
                Clear(Importe);
                MPSIC2.Reset;
                MPSIC2.SetRange("No. Serie Pos", NumRDoc);
                MPSIC2.CalcSums(Importe);
                Importe := MPSIC2.Importe;
                Registrar2 := false;
            end;

            if (not Registrar2) then begin
                MPSIC.Reset;
                MPSIC.SetCurrentKey("No. Serie Pos");
                MPSIC.SetRange("No. Serie Pos", NumRDoc);
                if not MPSIC.FindFirst then begin
                    MPSIC2.Init;
                    MPSIC2."Tipo documento" := 1;
                    MPSIC2."No. documento" := NumDoc;
                    MPSIC2."Location Code" := CabVentasSIC."Cod. Almacen";
                    MPSIC2."No. Serie Pos" := NumRDoc;
                    MPSIC2.Importe := CabVentasSIC.Monto;
                    MPSIC2."Cod. medio de pago" := '2';
                    MPSIC2."No. documento Pos" := SelectStr(2, NumSIC);
                    MPSIC2."No. linea" := '1';
                    MPSIC2."Fecha registro" := CabVentasSIC.Fecha;
                    if not MPSIC2.Insert(true) then begin
                        //              MPSIC.RESET;
                        //              MPSIC.SETCURRENTKEY("No. Serie Pos");
                        //              MPSIC.SETRANGE("No. documento",SELECTSTR(2,NumSIC)+'-1');
                        //              IF MPSIC.FINDFIRST THEN
                        //                BEGIN
                        //                  MPSIC2.INIT;
                        //                  MPSIC2."Tipo documento":=1;
                        //                  MPSIC2."No. documento":= NumDoc;
                        //                  MPSIC2."Location Code":=CabVentasSIC."Cod. Almacen";
                        //                  MPSIC2."No. Serie Pos":=NumRDoc;
                        //                  MPSIC2.Importe:= CabVentasSIC.Monto;
                        //                  MPSIC2."Cod. medio de pago":='2';
                        //                  MPSIC2."No. documento Pos":=SELECTSTR(2,NumSIC);
                        //                  MPSIC2."No. linea":='1';
                        //                  MPSIC2."Fecha registro":=CabVentasSIC.Fecha;
                        //                  IF MPSIC2.INSERT THEN;
                        //              END;
                    end;
                end;
            end;
        end;
    end;


    procedure RegistrarCobrosSGT(DocNum: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        NoLin: Integer;
        dImporte: Integer;
        ImporteNeto: Integer;
        MediosdePagoMG: Record "Medios de Pago SIC";
        MP: Record "Medios de Pago SIC";
        ConfMediosdepagos: Record "Conf. Medios de pago";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Msg001: Label 'Liq. pago Doc. %1';
        Bancostienda: Record "Bancos tienda";
        SIH: Record "Sales Invoice Header";
        SIH2: Record "Sales Invoice Header";
        SIH3: Record "Sales Invoice Header";
        MediosdePagoMG2: Record "Flash ventas (Cantidades)";
        MPMG2: Record "Flash ventas (Cantidades)";
        SCrMLine: Record "Sales Cr.Memo Line";
        SCRM: Record "Sales Cr.Memo Header";
        SCRM2: Record "Sales Cr.Memo Header";
        MP_: Record "Medios de Pago SIC";
        Registrar: Boolean;
    begin

        NoLin := 0;

        dImporte := 0;
        ImporteNeto := 0;
        Registrar := true;

        // Cajaxsucursal.SETRANGE(Caja,SalesInvHeader."Shortcut Dimension 1 Code");
        // IF Cajaxsucursal.FINDFIRST THEN
        SIH2.Reset;
        SIH2.SetRange("No.", DocNum);
        if SIH2.FindFirst then;


        // MediosdePagoMG.RESET;
        // //MediosdePagoMG.SETCURRENTKEY("Tipo documento","No. documento","Location Code");
        // MediosdePagoMG.SETRANGE("Tipo documento",1,2);
        // MediosdePagoMG.SETFILTER("No. Serie Pos",'%1',SIH2."No.");
        // //MediosdePagoMG.SETRANGE("Location Code",SIH2."Location Code");
        // MediosdePagoMG.SETFILTER("Cod. medio de pago",'<>%1&<>%2','','99');
        // SIH2.CALCFIELDS("Amount Including VAT");
        // MediosdePagoMG.CALCSUMS(Importe);
        // //IF NOT MediosdePagoMG.FINDFIRST THEN
        //  IF (SIH2."Amount Including VAT" - MediosdePagoMG.Importe) >1 THEN
        //    CrearPago(SIH2."No.",SIH2."No.",SIH2."Location Code");


        MediosdePagoMG.Reset;
        MediosdePagoMG.SetCurrentKey("Tipo documento", "No. documento", "Location Code");
        MediosdePagoMG.SetRange("Tipo documento", 1, 2);
        MediosdePagoMG.SetFilter("No. documento SIC", '%1', SIH2."No. Documento SIC");
        //MediosdePagoMG.SETRANGE("Location Code",SIH2."Location Code");
        MediosdePagoMG.SetFilter("Cod. medio de pago", '<>%1&<>%2', '', '99');


        if (MediosdePagoMG.FindSet) and (SIH2."Venta TPV" = true) and (SIH2."No." <> '') then begin
            repeat
                NoLin += 10000;
                Registrar := true;
                ConfMediosdepagos.Get(MediosdePagoMG."Cod. medio de pago");
                if ConfMediosdepagos.Credito then
                    exit;
                // Valida si la factura tiene importe pendiente .
                SIH3.Reset;
                SIH3.SetRange("No.", SIH2."No.");
                if SIH3.FindFirst then begin
                    SIH3.CalcFields("Remaining Amount");
                    if SIH3."Remaining Amount" = 0 then
                        exit;
                end;

                SalesInvoiceLine.Reset;
                SalesInvoiceLine.SetRange("Document No.", SIH2."No.");
                SalesInvoiceLine.CalcSums("Amount Including VAT");

                MP_.Reset;
                MP_.SetRange("No. documento SIC", SIH2."No. Documento SIC");
                MP_.CalcSums(Importe);

                if (SalesInvoiceLine."Amount Including VAT" - MP_.Importe) > 1 then
                    Registrar := false;

                Bancostienda.Reset;
                Bancostienda.SetRange("Cod. Tienda", SIH2.Tienda);
                if Bancostienda.FindFirst then;

                Bancostienda.TestField("Cod. Banco");


                //ConfMediosdepagos.TESTFIELD("Account No.");
                GenJnlLine.Init;
                GenJnlLine."Line No." := NoLin;
                GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine."Document No." := SIH2."No.";
                if LiqFechaAnt then
                    GenJnlLine."Posting Date" := FechaLiq
                else
                    GenJnlLine."Posting Date" := SIH2."Posting Date";

                GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                GenJnlLine.Validate("Account No.", SIH2."Sell-to Customer No.");
                GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                if bancoLiq <> '' then
                    GenJnlLine.Validate("Bal. Account No.", bancoLiq)
                else
                    GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                //GenJnlLine.VALIDATE("Bal. Account No.",Conceptos.Codigo);
                GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SIH2."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine.Validate("Credit Amount", MediosdePagoMG.Importe);
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                //GenJnlLine.VALIDATE("Credit Amount",SalesInvoiceLine."Amount Including VAT");
                //MESSAGE('%1',dImporte);
                GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::Invoice);
                GenJnlLine.Validate("Applies-to Doc. No.", SIH2."No.");
                GenJnlLine.Validate("Dimension Set ID", SIH2."Dimension Set ID");
                GenJnlLine."Salespers./Purch. Code" := SIH2."Salesperson Code";
                GenJnlLine.Validate("Shortcut Dimension 1 Code", SIH2."Shortcut Dimension 1 Code");
                GenJnlLine.Validate("Shortcut Dimension 2 Code", SIH2."Shortcut Dimension 2 Code");
                //
                //          OldCustLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
                //          OldCustLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                //          OldCustLedgEntry.SETRANGE("Customer No.",SIH2."Sell-to Customer No.");
                //          OldCustLedgEntry.SETRANGE(Open,FALSE);
                //          IF OldCustLedgEntry.FINDFIRST THEN BEGIN
                //            OldCustLedgEntry.Open := TRUE;
                //            OldCustLedgEntry.MODIFY(TRUE);
                //          END;
                if Registrar then
                    GenJnlPostLine.RunWithCheck(GenJnlLine);

            until MediosdePagoMG.Next = 0;

            SIH.Reset;
            SIH.SetRange("No.", SIH2."No.");
            if SIH.FindSet() then begin
                SIH."Liquidado TPV" := true;
                SIH.Modify;
            end;
        end else begin
            //008

            SCRM.Reset;
            SCRM.SetRange("No.", DocNum);
            if not SCRM.FindFirst then
                exit;

            SIH2.Reset;
            SIH2.SetCurrentKey("Order No.");
            SIH2.SetRange("Order No.", SCRM."No. Comprobante Fiscal Rel.");
            SIH2.SetRange("Location Code", SCRM."Location Code");
            if SIH2.FindFirst then;

            MediosdePagoMG.Reset;
            MediosdePagoMG.SetCurrentKey("Tipo documento", "No. Serie Pos");
            MediosdePagoMG.SetRange("Tipo documento", 1, 2);
            MediosdePagoMG.SetFilter("No. Serie Pos", '%1', SIH2."No.");
            MediosdePagoMG.SetRange("Location Code", SIH2."Location Code");
            MediosdePagoMG.SetFilter("Cod. medio de pago", '<>%1&<>%2', '', '99');
            if MediosdePagoMG.FindSet then begin
                repeat
                    NoLin += 10000;
                    Bancostienda.Reset;
                    Bancostienda.SetRange("Cod. Tienda", SCRM.Tienda);
                    if Bancostienda.FindFirst then;

                    // Valida si la factura tiene importe pendiente .
                    SCRM2.Reset;
                    SCRM2.SetRange("No.", SCRM."No.");
                    if SCRM2.FindFirst then begin
                        SCRM2.CalcFields("Remaining Amount");
                        if SCRM2."Remaining Amount" = 0 then
                            exit;
                    end;

                    Bancostienda.TestField("Cod. Banco");
                    //ConfMediosdepagos.TESTFIELD("Account No.");
                    GenJnlLine.Init;
                    GenJnlLine."Line No." := NoLin;
                    //GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                    GenJnlLine."Document No." := SCRM."No.";
                    GenJnlLine."Posting Date" := SCRM."Posting Date";
                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
                    GenJnlLine.Validate("Account No.", SCRM."Sell-to Customer No.");
                    GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                    GenJnlLine.Validate("Bal. Account No.", Bancostienda."Cod. Banco");
                    //GenJnlLine.VALIDATE("Bal. Account No.",Conceptos.Codigo);
                    GenJnlLine.Description := CopyStr(StrSubstNo(Msg001, SCRM."No." + ', ' + ConfMediosdepagos."Cod. Forma Pago"), 1, MaxStrLen(GenJnlLine.Description));
                    GenJnlLine.Validate(Amount, MediosdePagoMG.Importe);
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
                    //GenJnlLine.VALIDATE("Credit Amount",SalesInvoiceLine."Amount Including VAT");
                    //MESSAGE('%1',dImporte);
                    GenJnlLine.Validate("Applies-to Doc. Type", GenJnlLine."Applies-to Doc. Type"::"Credit Memo");
                    GenJnlLine.Validate("Applies-to Doc. No.", SCRM."No.");
                    GenJnlLine."Currency Factor" := SCRM."Currency Factor";
                    //GenJnlLine.VALIDATE("Dimension Set ID" ,SIH."Dimension Set ID");
                    GenJnlLine."Salespers./Purch. Code" := SCRM."Salesperson Code";
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", SCRM."Shortcut Dimension 1 Code");
                    GenJnlLine.Validate("Shortcut Dimension 2 Code", SCRM."Shortcut Dimension 2 Code");

                    OldCustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                    OldCustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                    //OldCustLedgEntry.SETRANGE("Customer No.",SalesCrMemoHeader."Sell-to Customer No.");
                    //OldCustLedgEntry.SETRANGE(Open,FALSE);
                    if OldCustLedgEntry.FindFirst then begin
                        OldCustLedgEntry.Positive := false;
                        OldCustLedgEntry."Forma de Pago" := ConfMediosdepagos."Cod. Forma Pago";//LDP-DSPOS+- Para que la forma de pago del pago sea la misma que la del documento registrado.
                        OldCustLedgEntry.Modify(true);
                    end;

                    GenJnlPostLine.RunWithCheck(GenJnlLine);
                until MediosdePagoMG.Next = 0;
            end;

            SCRM.Reset;
            SCRM.SetRange("No.", SCRM."No.");
            if SCRM.FindSet() then begin
                SCRM."Liquidado TPV" := true;
                SCRM.Modify;
            end;

        end;
    end;


    procedure LiquidarPendiente()
    var
        SIH: Record "Sales Invoice Header";
        SCMH: Record "Sales Cr.Memo Header";
        MP: Record "Medios de Pago SIC";
    begin

        SIH.Reset;
        SIH.SetFilter("No. Documento SIC", '<>%1', '');
        SIH.SetFilter("Posting Date", '%1..', 20230201D);
        //SIH.SETFILTER("No.",'=%1','VFRZ1T05-000548');
        //SIH.SETRANGE("Location Code",'TIENDA MNS');
        if SIH.FindSet then begin
            repeat
                SIH.CalcFields("Remaining Amount");

                if SIH."Remaining Amount" <> 0 then begin
                    //        MP.RESET;
                    //        MP.SETCURRENTKEY("No. Serie Pos");
                    //        MP.SETRANGE("No. Serie Pos",SIH."No.");
                    //        IF NOT MP.FINDFIRST THEN
                    //          CrearPago(SIH."Order No.",SIH."No.",SIH."Location Code");

                    RegistrarCobrosSGT(SIH."No.");
                end;
            until SIH.Next = 0;
        end;
    end;

    local procedure FirmaE()
    var
        Log: Record "Log comprobantes electronicos";
        FE: Codeunit "Procesar lote FE";
        SIH: Record "Sales Invoice Header";
    begin
        //LDP-001+-
        /*
        SIH.RESET;
        SIH.SETFILTER("No. Documento SIC",'<>%1','');
        
        IF SIH.FINDSET THEN BEGIN
          REPEAT
              IF NOT  Log.GET(SIH."No.") THEN  BEGIN
                IF Log."Transaction Recibido" = '' THEN
                  BEGIN
                  IF SIH."Payment Terms Code" =  'CONTADO' THEN
                  FE.FacturaElectronica(SIH)
                  ELSE
                  FE.FacturaCambiariaElectronica(SIH);
                  END;
              END;
          UNTIL SIH.NEXT=0;
        END;
        */
        //LDP-001+-

    end;


    procedure ParametroLiquidacion(FechaAnt: Boolean; Fecha: Date; Banco: Code[20])
    begin

        LiqFechaAnt := FechaAnt;
        FechaLiq := Fecha;
        bancoLiq := Banco;
    end;


    procedure FE_2_0(SalesHeader: Record "Sales Header")
    var
        "**012**": Integer;
    /*         cuFE: Codeunit "Comprobantes electronicos";
            txtResp: array[7] of Text[1024];
            rSIH: Record "Sales Invoice Header";
            NoFactReg: Code[20];
            rSCMH: Record "Sales Cr.Memo Header";
            lcGuat: Codeunit "Funciones DsPOS - Guatemala"; */
    begin
        //LDP-001+-
        /*
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN
          BEGIN
            IF rSIH.GET(SalesHeader."Last Posting No.") THEN
                cuFE.FacturaElectronica(rSIH);
          END;
        
        IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") OR
          (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")) AND
            (NOT SalesHeader.Correction) THEN
         BEGIN
          IF rSCMH.GET(SalesHeader."Last Posting No.") THEN
           BEGIN
                  //-76946
                   cuFE.NotaCreditoElectronica(rSCMH);
        
           END;
        
          END;
          */
        //LDP-001+-

    end;


    procedure RegistraFacturaVs2()
    var
        LineasVentasSIC: Record "Lineas Ventas SIC";
        Text001: Label 'Please check the order amount and the amount in the intermediate table  | %1  | %2  | %3';
        SL_: Record "Sales Line";
        propina: Decimal;
        Text002: Label 'Error en los medios de pagos  | %1  | %2  | %3';
        MediosdePagosSIC: Record "Medios de Pago SIC";
        SH_: Record "Sales Header";
        Error001: Label 'Cant. líneas no permitidas para registro';
        Error002: Label 'Montos en tablas no coinciden';
        Error003: Label 'Imp. med. pagos no coincide con cabecera';
        Error004: Label 'Imp. cab. SIC no coincide con imp. líneas';
        Error005: Label 'Imp. en "Med. Pagos SIC" no debe ser 0';
        ImporteLinSIC: Decimal;
        ImporteMPSIC: Decimal;
        ImporteSalesLine: Decimal;
        Text003: Label 'El documento fue instertado correctamente Documento No. ';
        Error006: Label 'No Existe "No. Documento" = %1, en tabla intermedia "Cab. Ventas SIC';
        ConfigEmpresa: Record "Config. Empresa";
        TotContador: Integer;
        Contador: Integer;
        Window: Dialog;
        Text004: Label 'Processing  #1########## @2@@@@@@@@@@@@@';
        Error007: Label '''%1, = %2, existe en Historico';
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        //002+ ////Nueva version de funcion registrar pedidos dspos
        ConfigEmpresa.Get;
        rCabLog.Reset;
        rCabLog.Init;
        rCabLog.Fecha := WorkDate;
        rCabLog."Hora Inicio" := FormatTime(Time);
        rCabLog.Insert(true);
        Numlogs := rCabLog."No. Log";
        I := 0;

        SH.Reset;
        SH.SetCurrentKey("Document Type", "No. Documento SIC", "Venta TPV");
        SH.SetRange("Document Type", SH."Document Type"::Invoice, SH."Document Type"::"Credit Memo");
        SH.SetRange("Venta TPV", true);
        SH.SetFilter("No. Documento SIC", '<>%1', '');//002+-
        //SH.SETRANGE("No.",'NCY2-000036');
        TotContador := SH.Count;
        Contador := 0;
        Window.Open(Text004);
        if SH.FindSet() then
            repeat
                //Pantalla de progreso de registro de documentos.
                if TotContador = 0 then TotContador := 1;
                if GuiAllowed then begin
                    Contador := Contador + 1;
                    Window.Update(1, CabVentasSIC."No. documento");
                    Window.Update(2, Round(Contador / TotContador * 10000, 1));
                end;
                //Pantalla de progreso de registro de documentos.

                //Para crear el reembolso contra NCR //LDP //31/01/2024
                if (SH."Document Type" = SH."Document Type"::"Credit Memo") and ((SH."Applies-to Doc. No." <> '') or
                  (SH."Applies-to Doc. Type" <> SH."Applies-to Doc. Type"::" "))
                  then begin
                    SH."Applies-to Doc. No." := '';
                    SH."Applies-to Doc. Type" := SH."Applies-to Doc. Type"::" ";
                    SH.Modify;
                end;
                //Para crear el reembolso contra NCR //LDP //31/01/2024

                CabVentasSIC.Reset;
                LineasVentasSIC.Reset;
                MediosdePagoSIC.Reset;
                Clear(ImporteLinSIC);
                Clear(ImporteMPSIC);
                Clear(ImporteSalesLine);
                ImporteLinSIC := 0;
                ImporteMPSIC := 0;
                Registrar := true;

                if wFechaProceso <> 0D then begin
                    SH."Posting Date" := wFechaProceso;
                    SH."Document Date" := wFechaProceso;// 002+-
                    SH.Modify;
                end;

                // Valida si cantidad lineas es permitida para registro.//09-01-2024 //LDP+-
                SalesLine.Reset;
                SalesLine.SetRange("Document No.", SH."No.");
                SalesLine.SetRange("Document Type", SH."Document Type");
                CantidadLin := SalesLine.Count;

                if CantidadLin > ConfigEmpresa."Cantidad Lin. por factura" then begin
                    Registrar := false;
                    SH."Error Registro" := Error001;
                    SH.Modify;
                end;
                // Valida si cantidad lineas es permitida para registro.//09-01-2024 //LDP+-

                // Si el usuario esta bloqueado lo desbloquea
                Clear(CustomerNo);
                if Customer.Get(SH."Sell-to Customer No.") then;
                if Customer.Blocked <> Customer.Blocked::" " then begin
                    TipoBloqueo := Customer.Blocked;
                    CustomerNo := SH."Sell-to Customer No.";
                    Customer.Blocked := Customer.Blocked::" ";
                    Customer.Modify;
                end;
                //Si el usuario esta bloqueado lo desbloquea

                //Se valida el monto de tablas cabecera, medios de pago, Lineas ventas sic y Lines de venta
                CabVentasSIC.SetRange("No. documento", SH."No.");
                CabVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");
                if not CabVentasSIC.FindFirst then begin
                    Registrar := false;
                    SH."Error Registro" := StrSubstNo(Error006, SH."No.");
                    SH.Modify;
                end;

                if Registrar = true then begin
                    LineasVentasSIC.SetRange("No. documento", SH."No.");
                    LineasVentasSIC.SetRange("No. documento SIC", SH."No. Documento SIC");
                    if LineasVentasSIC.FindSet then
                        repeat
                            ImporteLinSIC += LineasVentasSIC."Importe ITBIS Incluido";
                        until LineasVentasSIC.Next = 0;

                    MediosdePagoSIC.SetRange("No. documento", SH."No.");
                    MediosdePagoSIC.SetRange("No. documento SIC", SH."No. Documento SIC");
                    if MediosdePagoSIC.FindSet then
                        repeat
                            ImporteMPSIC += MediosdePagoSIC.Importe;
                        until MediosdePagoSIC.Next = 0;

                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SH."Document Type");
                    SalesLine.SetRange("Document No.", SH."No.");
                    SalesLine.CalcSums("Amount Including VAT");
                    if SalesLine.FindSet then
                        repeat
                            ImporteSalesLine += SalesLine."Amount Including VAT";
                        until SalesLine.Next = 0;

                    if ImporteMPSIC = 0 then begin
                        Registrar := false;
                        SH."Error Registro" := Error005;
                        SH.Modify;
                    end else
                        if (((ImporteMPSIC - ImporteSalesLine) < -1)) or (((ImporteMPSIC - ImporteSalesLine) > 1)) then begin
                            Registrar := false;
                            SH."Error Registro" := Error003;
                            SH.Modify;
                        end else
                            if (((CabVentasSIC.Monto - ImporteSalesLine) < -1)) or (((CabVentasSIC.Monto - ImporteSalesLine) > 1)) then begin
                                Registrar := false;
                                SH."Error Registro" := Error004;
                                SH.Modify;
                            end else
                                if (((ImporteLinSIC - ImporteSalesLine) < -1) or ((ImporteLinSIC - ImporteSalesLine) > 1)) or
                                  (((ImporteMPSIC - ImporteSalesLine) < -1) or ((ImporteMPSIC - ImporteSalesLine) > 1)) then begin
                                    Registrar := false;
                                    SH."Error Registro" := Error002;
                                    SH.Modify;
                                end;
                end;

                //LDP+ Si existe SIC en historico no registrar //15/01/2024
                if (SH."Document Type" = SH."Document Type"::Order) or (SH."Document Type" = SH."Document Type"::Invoice) then begin
                    SalesInvoiceHeader.Reset;
                    SalesInvoiceHeader.SetCurrentKey("No. Documento SIC");
                    SalesInvoiceHeader.SetRange("No. Documento SIC", SH."No. Documento SIC");
                    if SalesInvoiceHeader.FindFirst then begin
                        Registrar := false;
                        SH."Error Registro" := StrSubstNo(Error007, SalesInvoiceHeader.FieldCaption("No. Documento SIC"), SH."No. Documento SIC");
                        SH.Modify;
                    end else
                        if (SH."Document Type" = SH."Document Type"::"Credit Memo") or (SH."Document Type" = SH."Document Type"::"Return Order") then begin
                            SalesCrMemoHeader.Reset;
                            SalesCrMemoHeader.SetCurrentKey("No. Documento SIC");
                            SalesCrMemoHeader.SetRange("No. Documento SIC", SH."No. Documento SIC");
                            if SalesCrMemoHeader.FindFirst then begin
                                Registrar := false;
                                SH."Error Registro" := StrSubstNo(Error007, SalesCrMemoHeader.FieldCaption("No. Documento SIC"), SH."No. Documento SIC");
                                SH.Modify;
                            end;
                        end;
                end;
                //LDP- Si existe SIC en historico no registrar //15/01/2024
                //Se valida el monto de tablas cabecera, medios de pago, Lineas ventas sic y Lines de venta.

                if (LineasAEnviar) and (Registrar) then begin
                    SH."Error Registro" := '';
                    SH.Validate(Status, SH.Status::Released);
                    SH.Validate(Ship, true);
                    SH.Validate(Invoice, true);
                    SH.Modify(true);
                    Commit;
                    if not SalesPostPrint_WMS.Run(SH) then begin
                        SH2.Reset;
                        if SH2.Get(SH."Document Type", SH."No.") then begin
                            SH2."Error Registro" := CopyStr(GetLastErrorText, 1, 42);
                            if SH2.Modify then;
                            RegistrarVentasenLoteDsPOS.InsertarDetalleSIC(SH, 0, true, CopyStr(GetLastErrorText, 1, 100), Numlogs);
                        end;
                    end
                    else begin
                        I += 1;
                        SH2.Reset;
                        RegistrarVentasenLoteDsPOS.InsertarDetalleSIC(SH, 0, false, Text003 + SH."No.", Numlogs);//LDP-001+-//004+
                        if SH2.Get(SH."Document Type", SH."No.") then begin
                            SH2."Error Registro" := '';
                            if SH2.Modify then;
                        end;
                    end;
                end;

                // Le coloca el estado anterior al usuario
                if Customer.Get(CustomerNo) then begin
                    Customer.Blocked := TipoBloqueo;
                    Customer.Modify;
                end;
            //Le coloca el estado anterior al usuario

            until SH.Next = 0;

        rCabLog."Fecha Fin" := WorkDate;
        rCabLog."Hora Fin" := FormatTime(Time);
        rCabLog.Modify(false);

        //002- //Nueva version de funcion registrar pedidos dspos //LDP+- //12-01-2024+-
    end;
}

