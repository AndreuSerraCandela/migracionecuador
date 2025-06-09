report 66002 "_Fact. Pto. Vta. Ecuador"
{
    // #1379 CAT 08/01/14 Printamos la forma de pago.
    DefaultLayout = RDLC;
    RDLCLayout = './FactPtoVtaEcuador.66002.rdlc';

    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Shipment Buffer" = rm,
                  TableData "NCF Anulados" = rim;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.";
            column(Sales_Invoice_Header__Posting_Date_; Format("Posting Date"))
            {
            }
            column(TIME; Time)
            {
            }
            column(rCliente__No_Cliente; "Bill-to Customer No." + ' - ' + "Bill-to Name")
            {
            }
            column(rCliente__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(Sales_Invoice_Header__Bill_to_Address_; "Bill-to Address")
            {
            }
            column(rCliente__Phone_No1_; "No. Telefono")
            {
            }
            column(Sales_Invoice_Header_TPV; TPV)
            {
            }
            column(Sales_Invoice_Header__No__Comprobante_Fiscal_; "No. Comprobante Fiscal")
            {
            }
            column(FormaPagoTPV; FormaPagoTPV)
            {
            }
            column(Sales_Invoice_Header__User_ID_2; Format(Today))
            {
            }
            column(CodDivLocalFormateada; CodDiv + ' ' + Format(TotFactura, 0, '<Precision,2:2><Standard format,0>'))
            {
                //Comentado DecimalPlaces = 2 : 2;
            }
            column(Sales_Invoice_Header__User_ID_; "User ID")
            {
            }
            column(igv; igv)
            {
            }
            column(totDesc; Descuento)
            {
            }
            column(iBruto11; ImporteSinCargos - Descuento)
            {
            }
            column(DescriptionLine_1_____________CurrName; txt005 + ' ' + DescriptionLine[1] + ' ** ' + CurrName)
            {
            }
            column(Sales_Invoice_Line_Quantity_Control1000000004; CantENviada)
            {
                DecimalPlaces = 0 : 2;
            }
            column(ABS_Exento_; Abs(Exento))
            {
            }
            column(ABS_Grabado_; Abs(Grabado))
            {
                DecimalPlaces = 0 : 2;
            }
            column(Cambio; Cambio)
            {
            }
            column(Recibe; Recibe)
            {
            }
            column(FechaCaption; FechaCaptionLbl)
            {
            }
            column(No__de_Cliente___Caption; No__de_Cliente___CaptionLbl)
            {
            }
            column(VendedorCaption; VendedorCaptionLbl)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(EntregarCaption; EntregarCaptionLbl)
            {
            }
            column(Cantidad_Enviada; Cantidad_EnviadaLbl)
            {
            }
            column(Cod_ProductoCaption; Cod_ProductoCaptionLbl)
            {
            }
            column(Precio_UnitarioCaption; Precio_UnitarioCaptionLbl)
            {
            }
            column(Pct_DescCaption; Pct_DescCaptionLbl)
            {
            }
            column(Importe_Linea; Importe_LineaLbl)
            {
            }
            column(Desc_ProductoCaption; Desc_ProductoCaptionLbl)
            {
            }
            column(F__Pago_Caption; F__Pago_CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(IVA_12_Caption; IVA_12_CaptionLbl)
            {
            }
            column(DESCUENTOCaption; DESCUENTOCaptionLbl)
            {
            }
            column(SUBTOTALCaption; SUBTOTALCaptionLbl)
            {
            }
            column(TOTALCaption; TOTALCaptionLbl)
            {
            }
            column(Tarifa_IVA_12____Caption; Tarifa_IVA_12____CaptionLbl)
            {
            }
            column(Tarifa_IVA_0____Caption; Tarifa_IVA_0____CaptionLbl)
            {
            }
            column(Cambio__Caption; Cambio__CaptionLbl)
            {
            }
            column(Recibe__Caption; Recibe__CaptionLbl)
            {
            }
            column(Sales_Invoice_Header_No_; "No.")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", Type, "No.") WHERE(Quantity = FILTER(<> 0), Type = FILTER(<> "Charge (Item)"));
                column(Sales_Invoice_Line_Description; Description)
                {
                }
                column(Sales_Invoice_Line__No__; "No.")
                {
                }
                column(Sales_Invoice_Line__Amount_Including_VAT_; "Amount Including VAT")
                {
                    DecimalPlaces = 0 : 2;
                }
                column(Sales_Invoice_Line__Unit_Price_; "Unit Price")
                {
                }
                column(Sales_Invoice_Line__Line_Discount___; "Line Discount %")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Sales_Invoice_Line_Quantity; Quantity)
                {
                }
                column(Sales_Invoice_Line_Description_Control1000000039; Description)
                {
                }
                column(Sales_Invoice_Line__Amount_Including_VAT__Control1000000040; "Amount Including VAT")
                {
                    DecimalPlaces = 0 : 2;
                }
                column(Sales_Invoice_Line__Unit_Price__Control1000000041; "Unit Price")
                {
                }
                column(Sales_Invoice_Line__No___Control1000000042; "No.")
                {
                }
                column(Sales_Invoice_Line_Quantity_Control1000000050; Quantity)
                {
                }
                column(Sales_Invoice_Line__Line_Discount____Control1000000053; "Line Discount %")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Sales_Invoice_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Invoice_Line_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ICR.SetRange(ICR."Item No.", "No.");
                    ICR.SetRange(ICR."Unit of Measure", "Unit of Measure");
                    if not ICR.FindFirst then begin
                        ICR.Reset;
                        ICR.SetRange(ICR."Item No.", "No.");
                        if ICR.FindFirst then
                            CodBarra := ICR."Reference No."
                        else
                            CodBarra := ''
                    end;


                    /*
                    Descuento += "Line Discount Amount";
                    ImporteSinCargos += Amount + "Line Discount Amount";
                    Descuento += "Line Discount Amount";
                    CantENviada += Quantity;
                    CantSolicitada += "Cantidad Solicitada";
                    igv += "Amount Including VAT" - Amount;
                    */

                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CREATETOTALS(Amount,"Unit Price","Line Discount Amount","Amount Including VAT",Quantity);
                    //CurrReport.CREATETOTALS(ImporteSinCargos,Descuento,CantENviada,CantSolicitada,igv);
                end;
            }

            trigger OnAfterGetRecord()
            var
                rLocFormaPagoTPV: Record "Formas de Pago TPV";
            begin

                Comentario := '';
                iBruto := 0;
                ImporteCargos := 0;
                ImporteSinCargos := 0;
                DescuentoCargos := 0;
                CantENviada := 0;
                CantSolicitada := 0;
                igv := 0;


                rCliente.Get("Sell-to Customer No.");

                if Loc.Get("Location Code") then;

                if "Currency Code" <> '' then begin
                    Currency.Get("Currency Code");
                    CurrName := Currency.Description;
                    CodDiv := "Currency Code";
                end
                else begin
                    CurrName := GLSetUp."Nombre Divisa Local";
                    CodDiv := GLSetUp."LCY Code";
                end;


                if Vendedor_Comprador.Get("Salesperson Code") then
                    VendorName := Vendedor_Comprador.Name;

                if PT.Get("Payment Terms Code") then
                    CondicionPago := PT.Description;

                SCL.SetRange("Document Type", SCL."Document Type"::"Posted Invoice");
                SCL.SetRange("No.", "No.");

                if SCL.FindFirst then
                    Comentario := SCL.Comment;

                CalcFields(Amount, "Amount Including VAT");

                if "Amount Including VAT" - Amount <> 0 then
                    txtIva := txt004
                else
                    txtIva := '';

                //ChkTransMgt.FormatNoText(DescriptionLine, "Amount Including VAT", 2058, "Currency Code");

                TotFactura := "Amount Including VAT";


                SIL.Reset;
                SIL.SetRange("Document No.", "No.");
                SIL.SetFilter(Type, '<>%1', SIL.Type::"Charge (Item)");
                if SIL.FindSet then
                    repeat
                        ImporteSinCargos += SIL.Amount + SIL."Line Discount Amount";
                        Descuento += SIL."Line Discount Amount";
                        CantENviada += SIL.Quantity;
                        CantSolicitada += SIL."Cantidad Solicitada";
                        igv += SIL."Amount Including VAT" - SIL.Amount;
                    until SIL.Next = 0;

                /*
                //Datos para Historico de RTC
                SIL.RESET;
                SIL.SETRANGE("Document No.","No.");
                SIL.SETFILTER(Type,'<>%1',SIL.Type::"Charge (Item)");
                IF SIL.FINDSET THEN
                  REPEAT
                    ImporteSinCargos += SIL.Amount + SIL."Line Discount Amount";
                    Descuento += SIL."Line Discount Amount";
                    CantENviada += SIL.Quantity;
                    igv += SIL."Amount Including VAT" - SIL.Amount;
                  UNTIL SIL.NEXT = 0;
                
                
                SIL.RESET;
                SIL.SETRANGE("Document No.","No.");
                SIL.SETRANGE(SIL.Type,SIL.Type::"Charge (Item)");
                IF SIL.FINDSET THEN
                  REPEAT
                    ImporteCargos += SIL.Amount + SIL."Line Discount Amount";
                    DescuentoCargos += SIL."Line Discount Amount";
                    igv += SIL."Amount Including VAT" - SIL.Amount;
                  UNTIL SIL.NEXT = 0;
                
                */
                //Datos Dimensiones

                //Tipo Clinte
                //PostedDocDim.RESET;
                //PostedDocDim.SETRANGE("Table ID",112);
                //PostedDocDim.SETRANGE("Document No.","No.");
                //PostedDocDim.SETRANGE("Dimension Code",'TIPO_CLIENTE');
                //PostedDocDim.SETRANGE("Line No.",0);
                //IF PostedDocDim.FINDFIRST THEN
                //  BEGIN
                //    //TipoCliente := PostedDocDim."Dimension Value Code";
                //    DimVal.RESET;
                //    DimVal.SETRANGE("Dimension Code",PostedDocDim."Dimension Code");
                //    DimVal.SETRANGE(Code,PostedDocDim."Dimension Value Code");
                //    IF DimVal.FINDFIRST THEN
                //      TipoCliente := DimVal.Name;
                //  END;
                recDimEntry.Reset;
                recDimEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                recDimEntry.SetRange("Dimension Code", 'TIPO_CLIENTE');
                if recDimEntry.FindFirst then begin
                    //TipoCliente := PostedDocDim."Dimension Value Code";
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", recDimEntry."Dimension Code");
                    DimVal.SetRange(Code, recDimEntry."Dimension Value Code");
                    if DimVal.FindFirst then
                        TipoCliente := DimVal.Name;
                end;

                //Tipo Venta
                //PostedDocDim.RESET;
                //PostedDocDim.SETRANGE("Table ID",112);
                //PostedDocDim.SETRANGE("Document No.","No.");
                //PostedDocDim.SETRANGE("Dimension Code",'TIPO_VENTA');
                //PostedDocDim.SETRANGE("Line No.",0);
                //IF PostedDocDim.FINDFIRST THEN
                //  BEGIN
                //    //TipoCliente := PostedDocDim."Dimension Value Code";
                //    DimVal.RESET;
                //    DimVal.SETRANGE("Dimension Code",PostedDocDim."Dimension Code");
                //    DimVal.SETRANGE(Code,PostedDocDim."Dimension Value Code");
                //    IF DimVal.FINDFIRST THEN
                //      TipoVenta := DimVal.Name;
                //  END;

                recDimEntry.Reset;
                recDimEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                recDimEntry.SetRange("Dimension Code", 'TIPO_VENTA');
                if recDimEntry.FindFirst then begin
                    //TipoCliente := PostedDocDim."Dimension Value Code";
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", recDimEntry."Dimension Code");
                    DimVal.SetRange(Code, recDimEntry."Dimension Value Code");
                    if DimVal.FindFirst then
                        TipoCliente := DimVal.Name;
                end;



                if Cust.Get("Sell-to Customer No.") then
                    Nombre := UpperCase(Cust.Name);

                if PostCodes.Get("Sell-to Post Code", "Sell-to City") then begin
                    Provincia := PostCodes.County;
                    Departamento := PostCodes.Colonia;
                end;
                PuntoLlegada := "Sell-to Address" + ', ' + "Sell-to City" + ', ' + Provincia + ', ' + Departamento;


                //GRN Para anular el ncf actual y generar uno nuevo - Error de impresion -
                ConfSant.Get;
                if ConfSant."Anula NCF al Reimprimir" then begin
                    if ("No. Printed" > 0) and (not CurrReport.Preview) then begin
                        NCFAnulados."No. documento" := "No.";
                        NCFAnulados."No. Serie NCF Facturas" := "No. Serie NCF Facturas";
                        NCFAnulados."No. Comprobante Fiscal" := "No. Comprobante Fiscal";
                        NCFAnulados."Fecha anulacion" := Today;
                        NCFAnulados."Tipo Documento" := NCFAnulados."Tipo Documento"::Invoice;//AMS
                        NCFAnulados.Insert;
                        "No. Comprobante Fiscal" := NoSeriesMgt.GetNextNo("No. Serie NCF Facturas", Today, true);
                        Modify;

                        CLE.SetCurrentKey("Document No.", "Document Type", "Customer No.");
                        CLE.SetRange("Document No.", "No.");
                        CLE.SetRange("Document Type", CLE."Document Type"::Invoice);
                        CLE.SetRange("Customer No.", "Sell-to Customer No.");
                        CLE.FindFirst;
                        CLE."No. Comprobante Fiscal" := "No. Comprobante Fiscal";
                        CLE.Modify;
                    end;
                end;
                /*
               //Numero Guia de Remision
               SSH.RESET;
               SSH.SETRANGE(SSH."Order No.","Order No.");
               IF SSH.FINDFIRST THEN
                 NoGuia := SSH."Serie Remision" + '-'+SSH."No. Comprobante Fisc. Remision"
               ELSE
                 NoGuia := '';
               */

                if LogInteraction then
                    if not CurrReport.Preview then begin
                        /*    IF "Bill-to Contact No." <> '' THEN
                              SegManagement.LogDocument(
                                4,"No.",0,0,DATABASE::Contact,"Bill-to Contact No.","Salesperson Code",
                                "Campaign No.","Posting Description",'')
                            ELSE
                              SegManagement.LogDocument(
                                4,"No.",0,0,DATABASE::Customer,"Bill-to Customer No.","Salesperson Code",
                                "Campaign No.","Posting Description",'');
                         */
                    end;

                // --------------------------------------- Codigo Dynasoft --------------------------------------------
                SCL.SetRange("Document Type", SCL."Document Type"::Invoice);
                SCL.SetRange("No.", "No.");
                if SCL.FindFirst then;
                /*
                // --------------------------------------- Codigo Dynasoft --------------------------------------------
                //INICIO #1379
                FormaPagoTPV := "Sales Invoice Header"."Forma de Pago TPV";
                IF rLocFormaPagoTPV.Devolucion THEN
                  FormaPagoTPV := 'N/C'
                ELSE
                  IF rLocFormaPagoTPV.GET("Forma de Pago TPV") THEN BEGIN
                    CASE rLocFormaPagoTPV."Forma Pago Agrupacion" OF
                      rLocFormaPagoTPV."Forma Pago Agrupacion"::Efectivo             : FormaPagoTPV := 'Efectivo';
                      rLocFormaPagoTPV."Forma Pago Agrupacion"::Cheque               : FormaPagoTPV := 'Ch';
                      rLocFormaPagoTPV."Forma Pago Agrupacion"::"Tarjeta de Credito" : FormaPagoTPV := 'T/C';
                      rLocFormaPagoTPV."Forma Pago Agrupacion"::"Tarjeta de Debito"  : FormaPagoTPV := 'T/D';
                    END;
                  END;
                IF FormaPagoTPV = 'CHEQUE' THEN FormaPagoTPV := 'Ch';
                //FIN #1379
                */

                //fes mig
                /*
                PTPV.RESET;
                PTPV.SETRANGE("No. pedido","Order No.");
                PTPV.SETRANGE("No. Factura","No.");
                PTPV.SETFILTER("Forma pago TPV",'<>%1','CAMBIO');
                IF PTPV.FINDFIRST THEN
                  FormaPagoTPV := PTPV."Forma pago TPV";
                */
                //fes mig

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GLSetUp.Get;
        GLSetUp.TestField("LCY Code");
        GLSetUp.TestField("Nombre Divisa Local");

        rEmpresa.Get();
        rEmpresa.CalcFields(Picture);
        rPais.SetRange(Code, rEmpresa."Country/Region Code");
        rPais.FindFirst;
        vPais := rEmpresa.City + ', ' + rPais.Name + ' ' + rEmpresa."Post Code";
    end;

    var
        SCL: Record "Sales Comment Line";
        ArchiveSH: Record "Sales Header Archive";
        ArchiveSL: Record "Sales Line Archive";
        SalesShptLine: Record "Sales Shipment Line";
        VatEntry: Record "VAT Entry";
        Currency: Record Currency;
        rEmpresa: Record "Company Information";
        rCliente: Record Customer;
        ConfSantillana: Record "Config. Empresa";
        ConfigLinRep: Record "Config. Max. Lineas Reportes";
        PTPV: Record "Tipos de Tarjeta";
        FPTPV: Record "Formas de Pago TPV";
        Vendedor_Comprador: Record "Salesperson/Purchaser";
        rPais: Record "Country/Region";
        //ChkTransMgt: Report "Check Translation Management";
        PT: Record "Payment Terms";
        GLSetUp: Record "General Ledger Setup";
        NCFAnulados: Record "NCF Anulados";
        CLE: Record "Cust. Ledger Entry";
        SSH: Record "Sales Shipment Header";
        SIL: Record "Sales Invoice Line";
        Loc: Record Location;
        DimVal: Record "Dimension Value";
        Cust: Record Customer;
        PostCodes: Record "Post Code";
        Customer: Record Customer;
        ICR: Record "Item Reference";
        ConfSant: Record "Config. Empresa";
        recDimEntry: Record "Dimension Set Entry";
        NoSeriesMgt: Codeunit "No. Series";
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        SegManagement: Codeunit SegManagement;
        wDiv: Code[10];
        VendorName: Text[50];
        vPais: Text[50];
        Comentario: Text[1024];
        DescriptionLine: array[2] of Text[250];
        CurrName: Text[30];
        txtIva: Text[30];
        NoLineas: Integer;
        CondicionPago: Text[100];
        iBruto: Decimal;
        totDesc: Decimal;
        igv: Decimal;
        otros: Decimal;
        TotFactura: Decimal;
        CodDiv: Code[20];
        NoGuia: Code[50];
        Prueba: Decimal;
        Descuento: Decimal;
        TipoCliente: Text[100];
        TipoVenta: Text[100];
        Nombre: Text[250];
        Provincia: Text[150];
        Departamento: Text[150];
        PuntoLlegada: Text[500];
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        CopyTxt: Text[10];
        ImporteSinCargos: Decimal;
        ImporteCargos: Decimal;
        DescuentoCargos: Decimal;
        CantENviada: Decimal;
        CantSolicitada: Decimal;
        Vendedor: Text[30];
        CodBarra: Code[20];
        LogInteraction: Boolean;
        Text001: Label 'Page %1';
        Text002: Label 'Total %1';
        txt004: Label '(*) IVA';
        txt005: Label 'SON';
        Text000: Label 'COPY';
        Grabado: Decimal;
        Exento: Decimal;
        Cambio: Decimal;
        Recibe: Decimal;
        FormaPagoTPV: Text[30];
        FechaCaptionLbl: Label 'Fecha: ';
        No__de_Cliente___CaptionLbl: Label 'Cliente : ';
        VendedorCaptionLbl: Label 'Telefono:';
        RUC_CaptionLbl: Label 'RUC:';
        EntregarCaptionLbl: Label 'CAJA : ';
        Cantidad_EnviadaLbl: Label 'Cant.';
        Cod_ProductoCaptionLbl: Label 'Codigo / Desc.';
        Precio_UnitarioCaptionLbl: Label 'Precio Uni.';
        Pct_DescCaptionLbl: Label '% Desc';
        Importe_LineaLbl: Label 'TOTAL';
        Desc_ProductoCaptionLbl: Label 'Desc_Producto';
        F__Pago_CaptionLbl: Label 'F. Pago:';
        Total_CaptionLbl: Label 'Total ';
        IVA_12_CaptionLbl: Label 'IVA 12%';
        DESCUENTOCaptionLbl: Label 'Tot. Desc.:';
        SUBTOTALCaptionLbl: Label 'SUBTOTAL';
        TOTALCaptionLbl: Label 'No. Items : ';
        Tarifa_IVA_12____CaptionLbl: Label 'Tarifa IVA 12% : ';
        Tarifa_IVA_0____CaptionLbl: Label 'Tarifa IVA 0% : ';
        Cambio__CaptionLbl: Label 'Cambio: ';
        Recibe__CaptionLbl: Label 'Recibe: ';
        recDim: Integer;


    procedure InitLogInteraction()
    begin
        //LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;
}

