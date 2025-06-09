codeunit 50000 "Creacion de AEN"
{
    // ---------------------------------
    // YFC     : Yefrecis Francisco Cruz
    // FES     : Fausto Serrata
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC      01/10/2020       SANTINAV-1410 - Creación de AEN- Modificación de formato impresión Picking masivo.
    // 002         YFC      09/12/2020       SANTINAV-1908  -  según almacén configurado para el usuario (Empleado Almacén)
    // 003         YFC      10/2/2021        SANTINAV-2115 - PICKING MASIVO - PROBLEMAS
    // 004         FES      16-MAR-2021      SANTINAV-2241: Adicionar Filtro para excluir lineas tipo comentario en los pedidos y evitar
    //                                       que se excluyan del proceso.
    // 005         FES       01-04-2021      SANTINAV-2283: Adicional filtro para evitar que se mezclen loas lineas de un envio con otro
    // 
    // 458785, RRT, 21.04.2022 - Poder sugerir el metodo de clasificacion por defecto segun el parametro "Metodo clasificacion defecto"
    // 
    // 006         FES       12-Dic-22022    Migración a BC. Corregir error heredado de la versión 2013r2.
    //                                       "Los cambios realizados en el registro Cab. Venta no se pueden guardar porque en la página hay
    //                                       información que no está actualizada. Cierre la página, vuelva a abrirla e inténtelo de nuevo".


    trigger OnRun()
    var
        Text001: Label 'Desea Ejecutar proceso de crear EAN y picking?';
        SalesHeader: Record "Sales Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        Text002: Label 'Proceso finalizado';
        Text004: Label 'Numero de Documento #########1\';
        Text003: Label 'Creando EAN-Pickin\\';
        dlgProgreso: Dialog;
        SalesLine: Record "Sales Line";
        ValidarLineas: Boolean;
        SalesHeader2: Record "Sales Header";
    begin
        // ++ 001-YFC

        if Confirm(Text001, true) then begin
            // dlgProgreso.OPEN(Text003+Text004);

            //Buscar pedidos
            SalesHeader.Reset;
            SalesHeader.SetCurrentKey("Document Type", Status, "Procesar EAN-Picking Masivo");
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
            SalesHeader.SetRange(Status, SalesHeader.Status::Released);
            SalesHeader.SetRange("Procesar EAN-Picking Masivo", true);
            SalesHeader.SetRange("Pre pedido", false);
            //SalesHeader.SETFILTER("Estatus EAN-Picking Masivo",'<>%1',SalesHeader."Estatus EAN-Picking Masivo"::Procesado); //003-YFC
            //SalesHeader.SETFILTER(SalesHeader."No.",'=%1','VPCC-008686'); // prueba  003-YFC
            if SalesHeader.FindSet then
                // dlgProgreso.UPDATE(1, Text004);
                repeat
                    //  dlgProgreso.UPDATE(2, SalesHeader."No.");

                    // ++ verifico si tiene Evnio almacen
                    WhseShptLine.Reset;
                    WhseShptLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                    WhseShptLine.SetRange("Source Type", 37);
                    WhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type");
                    WhseShptLine.SetRange("Source No.", SalesHeader."No.");
                    //WhseShptLine.SetRange("Source Line No.",);
                    if not WhseShptLine.FindFirst then begin
                        // ++ 002-YFC
                        Clear(WarehouseEmployee);
                        if WarehouseEmployee.Get(UserId, SalesHeader."Location Code") then begin
                            //ValidarLineas := TRUE;  //002+-
                            SalesLine.Reset;
                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            SalesLine.SetRange(Type, SalesLine.Type::Item);     //002+-
                            if SalesLine.FindSet then
                                repeat
                                    ValidarLineas := true;     //002+-
                                    Clear(WarehouseEmployee);
                                    if not WarehouseEmployee.Get(UserId, SalesLine."Location Code") then
                                        ValidarLineas := false;
                                until (SalesLine.Next = 0) or (ValidarLineas = false)
                            //002+
                            else begin
                                SalesHeader."Procesar EAN-Picking Masivo" := false;
                                SalesHeader.Validate("Estatus EAN-Picking Masivo", SalesHeader."Estatus EAN-Picking Masivo"::" ");    //No procesado
                                SalesHeader.Modify;
                            end;
                            //002-
                            if ValidarLineas then begin
                                Crear_EnvioAlmacen(SalesHeader);
                                RellenarCampos(SalesHeader);
                                //006+
                                //SalesHeader.VALIDATE("Estatus EAN-Picking Masivo",SalesHeader."Estatus EAN-Picking Masivo"::Procesado); //003-YFC
                                //SalesHeader.MODIFY;
                                SalesHeader2.Get(SalesHeader."Document Type", SalesHeader."No.");
                                SalesHeader2.Validate("Estatus EAN-Picking Masivo", SalesHeader."Estatus EAN-Picking Masivo"::Procesado);
                                SalesHeader2.Modify;
                                //006-
                            end;
                        end;
                        // -- 002-YFC
                        Commit; // para que se queden los que ya se procesaron, por si acaso el siguiente da error.
                    end
                    else begin
                        SalesHeader.Validate("Estatus EAN-Picking Masivo", SalesHeader."Estatus EAN-Picking Masivo"::Procesado); //003-YFC
                        SalesHeader.Modify;
                    end;
                // --
                until SalesHeader.Next = 0;
            Message(Text002);
            // dlgProgreso.CLOSE;
        end
        // -- 001-YFC
    end;

    var
        Text003: Label 'The warehouse shipment was not created because an open warehouse shipment exists for the Sales Header and Shipping Advice is %1.\\You must add the item(s) as new line(s) to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text004: Label 'No %1 was found. The warehouse shipment could not be created for order %2.';
        WarehouseEmployee: Record "Warehouse Employee";
        SH: Record "Sales Header";
        WSL: Record "Warehouse Shipment Line";
        WHSL: Record "Warehouse Shipment Line";
        TH: Record "Transfer Header";
        NoSeries: Record "No. Series";
        NoSeries2: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        Location: Record Location;


    procedure Crear_EnvioAlmacen(SH: Record "Sales Header")
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseRqst: Record "Warehouse Request";
    begin
        // ++  001-YFC

        // ++ Crear el Envio de Almacen
        //GetSourceDocOutbound.CreateFromSalesOrder(SH);

        SH.TestField(Status, SH.Status::Released);
        if SH.WhseShpmntConflict(SH."Document Type".AsInteger(), SH."No.", SH."Shipping Advice".AsInteger()) then
            Error(Text003, Format(SH."Shipping Advice"));
        GetSourceDocOutbound.CheckSalesHeader(SH, true);
        WhseRqst.SetRange(Type, WhseRqst.Type::Outbound);
        WhseRqst.SetRange("Source Type", DATABASE::"Sales Line");
        WhseRqst.SetRange("Source Subtype", SH."Document Type");
        WhseRqst.SetRange("Source No.", SH."No.");
        WhseRqst.SetRange("Document Status", WhseRqst."Document Status"::Released);
        GetRequireShipRqst(WhseRqst);
        OpenWarehouseShipmentPage(WhseRqst, SH);
        // --

        // ++ Buscar envio de almacen creado, para crearle picking
        WhseShptLine.Reset;
        WhseShptLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        WhseShptLine.SetRange("Source Type", 37);
        WhseShptLine.SetRange("Source Subtype", SH."Document Type");
        WhseShptLine.SetRange("Source No.", SH."No.");
        //WhseShptLine.SetRange("Source Line No.",);
        if WhseShptLine.FindFirst then begin
            WhseShptHeader.Get(WhseShptLine."No.");
            Crear_Picking(WhseShptLine, WhseShptHeader); //Enviar registro de la cabececra y de la linea
        end
        // -- 001-YFC
    end;


    procedure Crear_Picking(_WhseShptLine: Record "Warehouse Shipment Line"; _WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhseShipmentSubform: Page "Whse. Shipment Subform";
        rec_WhseShptLine: Record "Warehouse Shipment Line";
        rec_WhseShptHeader: Record "Warehouse Shipment Header";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
        CreatePickFromWhseShpt: Report "Creacion Picking Masivo";
        HideValidationDialog: Boolean;
    begin
        // ++ 001-YFC

        // Tablas:7320 y 7321
        // WhseShipmentSubform.PickCreate();   pagina donde se hace el proceso

        if _WhseShptHeader.Status = _WhseShptHeader.Status::Open then
            ReleaseWhseShipment.Release(_WhseShptHeader);

        //rec_WhseShptLine.CreatePickDoc(_WhseShptLine,_WhseShptHeader);  // codeUnit donde se ejecuta proceso, pero abre una ventana

        _WhseShptLine.SetFilter(Quantity, '>0');
        _WhseShptLine.SetRange("Completely Picked", false);
        _WhseShptLine.SetRange("No.", _WhseShptHeader."No.");  //005+-

        if _WhseShptLine.Find('-') then begin
            HideValidationDialog := true; // para simular lo que el estandar  y en la CD de validacionn mapear el reporte
            CreatePickFromWhseShpt.SetWhseShipmentLine(_WhseShptLine, _WhseShptHeader);
            CreatePickFromWhseShpt.SetHideValidationDialog(HideValidationDialog);
            CreatePickFromWhseShpt.UseRequestPage(not HideValidationDialog);

            //+#458785
            CreatePickFromWhseShpt.SortActivityByDefault;
            //-#458785

            CreatePickFromWhseShpt.RunModal;
            CreatePickFromWhseShpt.GetResultMessage;
            Clear(CreatePickFromWhseShpt);

        end;
        // -- 001-YFC
    end;

    local procedure GetRequireShipRqst(var WhseRqst: Record "Warehouse Request")
    var
        Location: Record Location;
        LocationCode: Text;
    begin
        if WhseRqst.FindSet then begin
            repeat
                if Location.RequireShipment(WhseRqst."Location Code") then
                    LocationCode += WhseRqst."Location Code" + '|';
            until WhseRqst.Next = 0;
            if LocationCode <> '' then
                LocationCode := CopyStr(LocationCode, 1, StrLen(LocationCode) - 1);
            WhseRqst.SetFilter("Location Code", LocationCode);
        end;
    end;

    local procedure OpenWarehouseShipmentPage(var WarehouseRequest: Record "Warehouse Request"; SH: Record "Sales Header")
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        GetSourceDocuments: Report "Get Source Documents Modifi_";
    begin
        if WarehouseRequest.FindFirst then begin
            GetSourceDocuments.UseRequestPage(false);
            GetSourceDocuments.SetTableView(WarehouseRequest);
            //fes mig aqui es la jugada
            GetSourceDocuments.RunModal;
            GetSourceDocuments.GetLastShptHeader(WarehouseShipmentHeader);
            //PAGE.RUN(PAGE::"Warehouse Shipment",WarehouseShipmentHeader);
        end else
            Message(Text004, WarehouseRequest.TableCaption, SH."No.");
    end;


    procedure RellenarCampos(var SH_: Record "Sales Header")
    var
        WSH: Record "Warehouse Shipment Header";
    begin
        //0001

        WHSL.Reset;
        WHSL.SetRange("Source No.", SH_."No.");
        WHSL.FindSet;
        repeat
            if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                GetLocation(SH."Location Code");
                WSH.Reset;
                WSH.SetRange("No.", WHSL."No.");
                if WSH.FindSet then;
                WSH.Validate("Shipping Agent Code", Location."Cod. Transportista");
                WSH.Validate("Fecha inicio transporte", WorkDate);
                WSH.Validate("Fecha fin transporte", CalcDate(Location."Outbound Whse. Handling Time", WorkDate));
                // ,Factura,Nota de Crédito,Remision,Retencion
                NoSeries.Reset;
                NoSeries.SetRange("Tipo Documento", NoSeries."Tipo Documento"::Factura);
                NoSeries.SetRange("Cod. Almacen", SH."Location Code");
                if NoSeries.FindFirst then;

                NoSeries2.Reset;
                NoSeries2.SetRange("Tipo Documento", NoSeries2."Tipo Documento"::Remision);
                NoSeries2.SetRange("Cod. Almacen", SH."Location Code");
                if NoSeries2.FindFirst then begin

                    NoSeriesLine.Reset;
                    NoSeriesLine.SetRange("Series Code", NoSeries.Code);
                    if NoSeriesLine.FindFirst then;

                    WSH."No. Serie NCF Factura" := NoSeries.Code;
                    WSH."No. Serie NCF Remision" := NoSeries2.Code;

                    WSH."Establecimiento Factura" := NoSeriesLine.Establecimiento;
                    WSH."Punto de Emision Factura" := NoSeriesLine."Punto de Emision";

                    SH."No. Serie NCF Facturas" := WSH."No. Serie NCF Factura";
                    SH."No. Serie NCF Remision" := WSH."No. Serie NCF Remision";
                    SH."Establecimiento Factura" := WSH."Establecimiento Factura";
                    SH."Punto de Emision Factura" := WSH."Punto de Emision Factura";
                    SH.Modify;
                end;
            end;

            //Transferencia
            if TH.Get(WHSL."Source No.") then begin
                TH.Validate(TH."No. Serie Comprobante Fiscal", WSH."No. Serie NCF Remision");
                TH.Modify;
            end;
            WSH.Modify;

        until WHSL.Next = 0;
        //001
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}

