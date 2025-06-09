table 56021 "Lin. Hoja de Ruta"
{
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // FES   : Fausto Serrata
    // YFC     : Yefrecis Franciscof Cruz
    // ------------------------------------------------------------------------------
    // No.           Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // #32014        FAA           28/09/2015      Cambios nuevos en la hoja de ruta.
    // santinav-559  FES           16-10-2019      Adicionar campos Horario entrega y Entrega en a
    //                                             hoja de ruta para reporte resumido
    // 001           YFC           18/05/2020       SANTINAV-1401
    // 002           LDP           23/04/2024       SANTINAV-6431


    fields
    {
        field(1; "No. Hoja Ruta"; Code[20])
        {
            Caption = 'Route Sheet No.';
        }
        field(2; "No. Linea"; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "No. Conduce"; Code[20])
        {
            Caption = 'Shipment No.';
            TableRelation = IF ("Tipo Envio" = FILTER("Pedido Venta")) "Sales Shipment Header"
            ELSE
            IF ("Tipo Envio" = FILTER(Transferencia)) "Transfer Shipment Header";

            trigger OnValidate()
            begin
                if "Tipo Envio" = "Tipo Envio"::Transferencia then begin
                    //Se valida que no exista en alguna otra hoja de ruta
                    LHRR.Reset;
                    LHRR.SetRange("No. Conduce", "No. Conduce");
                    LHRR.SetRange("No entregado", false);
                    if LHRR.FindFirst then begin
                        CHRR.Get(LHRR."No. Hoja Ruta");
                        if not CHRR.Anulada then
                            Error(Error003, LHRR."No. Hoja Ruta", LHRR."No. Linea");
                    end;

                    LHR.Reset;
                    LHR.SetFilter("No. Hoja Ruta", '<>%1', "No. Hoja Ruta");
                    LHR.SetRange("No. Conduce", "No. Conduce");
                    if LHR.FindFirst then
                        Error(Error004, LHR."No. Hoja Ruta", LHR."No. Linea");

                    if TSH.Get("No. Conduce") then begin
                        "Cod. Cliente" := TSH."Transfer-to Code";
                        "Nombre Cliente" := TSH."Transfer-to Name";
                        "No. Pedido" := TSH."No.";
                        "Fecha Pedido" := TSH."Posting Date";
                        "No. Guia" := TSH."No. Comprobante Fiscal";
                        "Cantidad de Bultos" := TSH."Cantidad de Bultos";
                        "Comprobante Fiscal" := TSH."No. Comprobante Fiscal";
                        "Direccion de Envio" := TSH."Transfer-to Address";
                        "Ship-to City" := TSH."Transfer-to City";//002+-
                    end;
                end;


                if "Tipo Envio" = "Tipo Envio"::"Pedido Venta" then begin
                    //Se valida que no exista en alguna otra hoja de ruta
                    LHRR.Reset;
                    LHRR.SetRange("No. Conduce", "No. Conduce");
                    LHRR.SetRange("No entregado", false);
                    if LHRR.FindFirst then begin
                        CHRR.Get(LHRR."No. Hoja Ruta");
                        if not CHRR.Anulada then
                            Error(Error003, LHRR."No. Hoja Ruta", LHRR."No. Linea");
                    end;

                    LHR.Reset;
                    LHR.SetFilter("No. Hoja Ruta", '<>%1', "No. Hoja Ruta");
                    LHR.SetRange("No. Conduce", "No. Conduce");
                    if LHR.FindFirst then
                        Error(Error004, LHR."No. Hoja Ruta", LHR."No. Linea");

                    if SHH.Get("No. Conduce") then begin
                        Cust.Get(SHH."Sell-to Customer No.");
                        "Cod. Cliente" := Cust."No.";
                        "Nombre Cliente" := Cust.Name;
                        "No. Pedido" := SHH."Order No.";
                        "Fecha Pedido" := SHH."Order Date";
                        "No. Guia" := SHH."No. Comprobante Fisc. Remision";
                        "Cantidad de Bultos" := SHH."Cantidad de Bultos";
                        "Comprobante Fiscal" := SHH."No. Comprobante Fiscal Factura";
                        "Direccion de Envio" := Cust.Address;
                        Alias := Cust."Search Name";
                        "Ship-to City" := SHH."Ship-to City";//002+-;

                        //santinav-559++
                        if STA.Get(SHH."Sell-to Customer No.", SHH."Ship-to Code") then begin
                            "Horario Entrega" := STA."Horario Entrega";
                            "Entrega En" := STA."Entrega En";
                        end;
                        //santinav-559-
                        // ++ 001-YFC
                        // IF SIH.GET(SHH."Order No.")  THEN BEGIN
                        SIH.Reset;
                        SIH.SetCurrentKey("Order No.");
                        SIH.SetRange("Order No.", SHH."Order No.");
                        if SIH.FindFirst then begin
                            "Numero Guia" := SIH."Numero Guia";
                            "Nombre Guia" := SIH."Nombre Guia";
                        end;
                        // -- 001-YFC

                    end;
                end;
            end;
        }
        field(4; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(5; "Nombre Cliente"; Text[200])
        {
            Caption = 'Customer Name';
            Description = '#56924';
        }
        field(6; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Packages Qty.';
        }
        field(7; Peso; Decimal)
        {
            Caption = 'Weight';
        }
        field(8; "Unidad Medida"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(9; Valor; Decimal)
        {
            Caption = 'Value';
        }
        field(10; "No. Guia"; Code[20])
        {
            Caption = 'Shipment Guide No.';
        }
        field(11; Comentarios; Text[250])
        {
            Caption = 'Comments';
        }
        field(12; "Fecha Entrega Requerida"; Date)
        {
            Caption = 'Required Delivery Date';
        }
        field(13; "Condiciones de Envio"; Text[200])
        {
            Caption = 'Shipping Conditions';
        }
        field(14; "No. Pedido"; Code[20])
        {
            Caption = 'Order No.';
        }
        field(15; "Fecha Pedido"; Date)
        {
            Caption = 'Order Date';
        }
        field(16; "No Entregado"; Boolean)
        {
            Caption = 'Voided';
        }
        field(17; "Tipo Envio"; Option)
        {
            Caption = 'Shippment Type';
            OptionCaption = ' ,Transfer,Sales Order';
            OptionMembers = " ",Transferencia,"Pedido Venta";
        }
        field(20; "Comprobante Fiscal"; Code[19])
        {
            Caption = 'Comprobante Fiscal';
            Description = '#32014';

            trigger OnValidate()
            var
                recSalesSHeader: Record "Sales Shipment Header";
                recLinHojaRutaReg: Record "Lin. Hoja de Ruta Reg.";
                recCabHojaRutaReg: Record "Cab. Hoja de Ruta Reg.";
                recLineaHojaRuta: Record "Lin. Hoja de Ruta";
                recCustomer: Record Customer;
                Text100: Label 'No. Comprobante Fiscal no Existe';
                Text101: Label 'Primero debe indicar si es pedido de venta o transferencia';
                recTranShipHeader: Record "Transfer Shipment Header";
            begin
                ////Pedido Venta #32014 ++++

                if ("Comprobante Fiscal" <> '') and ("Tipo Envio" = "Tipo Envio"::" ") then
                    Error(Text101);

                if ("Comprobante Fiscal" <> '') and ("Tipo Envio" = "Tipo Envio"::"Pedido Venta") then begin
                    //Se valida que no exista en alguna otra hoja de ruta
                    recLinHojaRutaReg.Reset;
                    recLinHojaRutaReg.SetRange("Comprobante Fiscal", "Comprobante Fiscal");
                    recLinHojaRutaReg.SetRange("No entregado", false);
                    if recLinHojaRutaReg.FindFirst then begin
                        recCabHojaRutaReg.Get(recLinHojaRutaReg."No. Hoja Ruta");
                        if not recCabHojaRutaReg.Anulada then
                            Error(Error003, recLinHojaRutaReg."No. Hoja Ruta", recLinHojaRutaReg."No. Linea");
                    end;

                    recLineaHojaRuta.Reset;
                    recLineaHojaRuta.SetFilter("No. Hoja Ruta", '<>%1', "No. Hoja Ruta");
                    recLineaHojaRuta.SetRange("Comprobante Fiscal", "Comprobante Fiscal");
                    if recLineaHojaRuta.FindFirst then
                        Error(Error004, recLineaHojaRuta."No. Hoja Ruta", recLineaHojaRuta."No. Linea");

                end;

                if "Comprobante Fiscal" <> '' then
                    recSalesSHeader.SetRange("No. Comprobante Fiscal Factura", "Comprobante Fiscal");
                if recSalesSHeader.FindSet then begin
                    recCustomer.Get(recSalesSHeader."Sell-to Customer No.");
                    "Cod. Cliente" := recCustomer."No.";
                    "Nombre Cliente" := recCustomer.Name;
                    "Direccion de Envio" := recSalesSHeader."Ship-to Address";
                    "No. Conduce" := recSalesSHeader."No.";
                    "No. Pedido" := recSalesSHeader."Order No.";
                    "Fecha Pedido" := recSalesSHeader."Order Date";
                    "No. Guia" := recSalesSHeader."No. Comprobante Fisc. Remision";
                    "Cantidad de Bultos" := recSalesSHeader."Cantidad de Bultos";
                    Alias := recCustomer."Search Name";
                    "Ship-to City" := recSalesSHeader."Ship-to City";//002+-

                    //santinav-559++
                    if STA.Get(recSalesSHeader."Sell-to Customer No.", recSalesSHeader."Ship-to Code") then begin
                        "Horario Entrega" := STA."Horario Entrega";
                        "Entrega En" := STA."Entrega En";
                    end;
                    //santinav-559-
                    // ++ 001-YFC
                    //IF SIH.GET(recSalesSHeader."Order No.")  THEN BEGIN
                    SIH.Reset;
                    SIH.SetCurrentKey("Order No.");
                    SIH.SetRange("Order No.", recSalesSHeader."Order No.");
                    if SIH.FindFirst then begin
                        "Numero Guia" := SIH."Numero Guia";
                        "Nombre Guia" := SIH."Nombre Guia";
                    end;
                    // -- 001-YFC


                end;




                ////////Pedidos Transferencia
                if ("Comprobante Fiscal" <> '') and ("Tipo Envio" = "Tipo Envio"::" ") then
                    Error(Text101);

                if ("Comprobante Fiscal" <> '') and ("Tipo Envio" = "Tipo Envio"::Transferencia) then begin
                    if "Tipo Envio" = "Tipo Envio"::Transferencia then begin
                        //Se valida que no exista en alguna otra hoja de ruta
                        recLinHojaRutaReg.Reset;
                        recLinHojaRutaReg.SetRange("Comprobante Fiscal", "Comprobante Fiscal");
                        recLinHojaRutaReg.SetRange("No entregado", false);
                        if recLinHojaRutaReg.FindFirst then begin
                            recCabHojaRutaReg.Get(recLinHojaRutaReg."No. Hoja Ruta");
                            if not recCabHojaRutaReg.Anulada then
                                Error(Error003, recLinHojaRutaReg."No. Hoja Ruta", recLinHojaRutaReg."No. Linea");
                        end;

                        recLineaHojaRuta.Reset;
                        recLineaHojaRuta.SetFilter("No. Hoja Ruta", '<>%1', "No. Hoja Ruta");
                        recLineaHojaRuta.SetRange("Comprobante Fiscal", "Comprobante Fiscal");
                        if recLineaHojaRuta.FindFirst then
                            Error(Error004, recLineaHojaRuta."No. Hoja Ruta", recLineaHojaRuta."No. Linea");

                        if "Comprobante Fiscal" <> '' then
                            recTranShipHeader.SetRange("No. Comprobante Fiscal", "Comprobante Fiscal");
                        if recTranShipHeader.FindSet then begin
                            "No. Conduce" := recTranShipHeader."No.";
                            "Cod. Cliente" := recTranShipHeader."Transfer-to Code";
                            "Nombre Cliente" := recTranShipHeader."Transfer-to Name";
                            "No. Pedido" := recTranShipHeader."No.";
                            "Fecha Pedido" := recTranShipHeader."Posting Date";
                            "No. Guia" := recTranShipHeader."No. Comprobante Fiscal";
                            "Cantidad de Bultos" := recTranShipHeader."Cantidad de Bultos";
                            "Direccion de Envio" := recTranShipHeader."Transfer-to Address";
                            Alias := Cust."Search Name";
                            "Ship-to City" := recTranShipHeader."Transfer-to City";//002+-
                        end;
                    end;
                end;
                //#32014 ---
            end;
        }
        field(21; "Direccion de Envio"; Text[100])
        {
            Caption = 'Dirección de Envio';
            Description = '#34387';
        }
        field(22; Alias; Text[80])
        {
            Caption = 'Alias';
        }
        field(23; "Horario Entrega"; Text[100])
        {
            Description = 'Santinav-599';
        }
        field(24; "Entrega En"; Text[100])
        {
            Description = 'Santinav-599';
        }
        field(55048; "Numero Guia"; Code[20])
        {
            Caption = 'Número de Guía';
            Description = 'SANTINAV-1401';
        }
        field(55049; "Nombre Guia"; Code[20])
        {
            Caption = 'Nombre de Guía';
            Description = 'SANTINAV-1401';
        }
        field(55055; "Ship-to City"; Text[60])
        {
            Caption = 'Ship-to City';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6431';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "No. Hoja Ruta", "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; "No. Guia")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record Customer;
        SHH: Record "Sales Shipment Header";
        Error001: Label 'This Guide No. already exists in the Route Sheet %1, Line %2';
        Error002: Label 'This Guide No. already exists in the Posted Route Sheet %1, Line %2';
        LHRR: Record "Lin. Hoja de Ruta Reg.";
        LHR: Record "Lin. Hoja de Ruta";
        CHRR: Record "Cab. Hoja de Ruta Reg.";
        TSH: Record "Transfer Shipment Header";
        Error003: Label 'This Guide No. already exists in the Route Sheet %1, Line %2';
        Error004: Label 'This Guide No. already exists in the Route Sheet %1, Line %2';
        STA: Record "Ship-to Address";
        SIH: Record "Sales Invoice Header";


    procedure NumGuia()
    var
        CHR: Record "Cab. Hoja de Ruta";
        SA: Record "Shipping Agent";
        NosSeries: Record "No. Series";
        NoSerieMagmt: Codeunit "No. Series";
        LHR: Record "Lin. Hoja de Ruta";
        LHRR: Record "Lin. Hoja de Ruta Reg.";
    begin
        CHR.Get("No. Hoja Ruta");
        CHR.TestField("Cod. Transportista");
        SA.Get(CHR."Cod. Transportista");
        if SA."No. Serie Guias" <> '' then begin
            if "No. Guia" = '' then begin
                "No. Guia" := NoSerieMagmt.GetNextNo(SA."No. Serie Guias", WorkDate, true);

                LHR.Reset;
                LHR.SetCurrentKey("No. Guia");
                LHR.SetRange("No. Guia", "No. Guia");
                if LHR.FindFirst then
                    Error(Error001, "No. Guia", LHR."No. Linea");

                LHRR.Reset;
                LHRR.SetCurrentKey("No. Guia");
                LHRR.SetRange("No. Guia", "No. Guia");
                if LHRR.FindFirst then
                    Error(Error002, "No. Guia", LHRR."No. Linea");

                Modify;
            end;
        end;
    end;
}

