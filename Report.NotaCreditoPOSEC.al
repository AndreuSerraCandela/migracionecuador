report 65021 "_Nota Credito POS-EC"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NotaCreditoPOSEC.rdlc';
    Caption = 'Sales Credit Memo';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Credit Memo';
            column(CopyTxt; CopyTxt)
            {
            }
            column(Bodega; 'Bod.: ' + "Location Code")
            {
            }
            column(rCliente__No_Cliente; "Bill-to Customer No." + ' - ' + "Bill-to Name")
            {
            }
            column(rCliente__Phone_No1_; "No. Telefono")
            {
            }
            column(Sales_Invoice_Header_TPV; TPV)
            {
            }
            column(D________No__Comprobante_Fiscal_; 'D.: ' + "No. Comprobante Fiscal")
            {
            }
            column(FormaPagoTPV; FormaPagoTPV)
            {
            }
            column(TIME; Format(Time))
            {
            }
            column(rCliente__VAT_Registration_No__; "VAT Registration No.")
            {
            }
            column(Sales_Invoice_Header__Bill_to_Address_; "Bill-to Address")
            {
            }
            column(Sales_Invoice_Header__Posting_Date_; Format("Posting Date"))
            {
            }
            column(NoDocExt; 'Aplica a factura: ' + SIH."No. Serie NCF Facturas" + ' - ' + "No. Comprobante Fiscal Rel.")
            {
            }
            column(Bodega2; Bodega2)
            {
                Description = '"Serie Factura" + ''-''+"No. Comprobante Fiscal"';
            }
            column(ABS_Exento_; Abs(Exento))
            {
            }
            column(ABS_Grabado_; Abs(Grabado))
            {
                DecimalPlaces = 0 : 2;
            }
            column(DescriptionLine_1_____________CurrName; txt005 + ' ' + DescriptionLine[1] + ' ** ' + CurrName)
            {
            }
            column(iBruto11; ImporteSinCargos - Descuento)
            {
            }
            column(igv; igv)
            {
            }
            column(CodDivLocalFormateada; CodDiv + ' ' + Format(TotFactura, 0, '<Precision,2:2><Standard format,0>'))
            {
                //ComentadoDecimalPlaces = 2 : 2;
            }
            column(totDesc; Descuento)
            {
            }
            column(Sales_Invoice_Line_Quantity_Control1000000004; CantENviada)
            {
                DecimalPlaces = 0 : 2;
            }
            column(Cambio; Cambio)
            {
            }
            column(Recibe; Recibe)
            {
            }
            column(Sales_Invoice_Header__User_ID_2; Format(Today))
            {
            }
            column(Sales_Invoice_Header__User_ID_; "User ID")
            {
            }
            column(Pct_DescCaption; Pct_DescCaptionLbl)
            {
            }
            column(Importe_Linea; Importe_LineaLbl)
            {
            }
            column(EntregarCaption; EntregarCaptionLbl)
            {
            }
            column(VendedorCaption; VendedorCaptionLbl)
            {
            }
            column(F__Pago_Caption; F__Pago_CaptionLbl)
            {
            }
            column(Precio_UnitarioCaption; Precio_UnitarioCaptionLbl)
            {
            }
            column(Desc_ProductoCaption; Desc_ProductoCaptionLbl)
            {
            }
            column(Cod_ProductoCaption; Cod_ProductoCaptionLbl)
            {
            }
            column(FechaCaption; FechaCaptionLbl)
            {
            }
            column(No__de_Cliente___Caption; No__de_Cliente___CaptionLbl)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(Cantidad_Enviada; Cantidad_EnviadaLbl)
            {
            }
            column(Tarifa_IVA_12____Caption; Tarifa_IVA_12____CaptionLbl)
            {
            }
            column(Tarifa_IVA_0____Caption; Tarifa_IVA_0____CaptionLbl)
            {
            }
            column(SUBTOTALCaption; SUBTOTALCaptionLbl)
            {
            }
            column(IVA_12_Caption; IVA_12_CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(DESCUENTOCaption; DESCUENTOCaptionLbl)
            {
            }
            column(TOTALCaption; TOTALCaptionLbl)
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
            dataitem("Sales Invoice Line"; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", Type, "No.") WHERE(Quantity = FILTER(<> 0), Type = FILTER(<> "Charge (Item)"));
                column(Sales_Invoice_Line_Description; Description)
                {
                }
                column(Sales_Invoice_Line__No__; "No.")
                {
                }
                column(Sales_Invoice_Line__Unit_Price_; "Unit Price")
                {
                }
                column(Sales_Invoice_Line_Quantity; Quantity)
                {
                }
                column(Sales_Invoice_Line__Line_Discount___; "Line Discount %")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Sales_Invoice_Line__Amount_Including_VAT_; "Amount Including VAT")
                {
                    DecimalPlaces = 0 : 2;
                }
                column(Sales_Invoice_Line_Description_Control1000000039; Description)
                {
                }
                column(Sales_Invoice_Line__No___Control1000000042; "No.")
                {
                }
                column(Sales_Invoice_Line_Quantity_Control1000000050; Quantity)
                {
                }
                column(Sales_Invoice_Line__Unit_Price__Control1000000041; "Unit Price")
                {
                }
                column(Sales_Invoice_Line__Line_Discount____Control1000000053; "Line Discount %")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Sales_Invoice_Line__Amount_Including_VAT__Control1000000040; "Amount Including VAT")
                {
                    DecimalPlaces = 0 : 2;
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
                end;

                trigger OnPostDataItem()
                begin
                    Grabado := 0;
                    Exento := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Comentario := '';
                iBruto := 0;
                ImporteCargos := 0;
                ImporteSinCargos := 0;
                DescuentoCargos := 0;
                CantENviada := 0;
                igv := 0;

                Cliente.Get("Sell-to Customer No.");

                if Loc.Get("Location Code") then;

                if "Currency Code" <> '' then begin
                    Currency.Get("Currency Code");
                    CurrName := Currency.Description;
                    CodDivLocal := "Currency Code";
                end
                else begin
                    CurrName := GLSetUp."Nombre Divisa Local";
                    CodDivLocal := GLSetUp."LCY Code";
                end;

                if Vendedor_Comprador.Get("Salesperson Code") then
                    Vend := 'Vendedor: ' + Vendedor_Comprador.Code + ' - ' + CopyStr(Vendedor_Comprador.Name, 1, 30);

                Bodega2 := 'Bod.: ' + "Location Code" + ' - ' + Loc.Name;


                if PT.Get("Payment Terms Code") then
                    CondicionPago := PT.Description;

                SCL.SetRange("Document Type", SCL."Document Type"::"Posted Credit Memo");
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

                //Datos para Historico de RTC
                SIL.Reset;
                SIL.SetRange("Document No.", "No.");
                SIL.SetFilter(Type, '<>%1', SIL.Type::"Charge (Item)");
                if SIL.FindSet then
                    repeat
                        ImporteSinCargos += SIL.Amount + SIL."Line Discount Amount";
                        Descuento += SIL."Line Discount Amount";
                        CantENviada += SIL.Quantity;
                        //    CantSolicitada += SIL."Cantidad Solicitada";
                        //    CantUnidades += SIL.Quantity;
                        igv += SIL."Amount Including VAT" - SIL.Amount;
                    until SIL.Next = 0;

                SIL.Reset;
                SIL.SetRange("Document No.", "No.");
                SIL.SetRange(SIL.Type, SIL.Type::"Charge (Item)");
                if SIL.FindSet then
                    repeat
                        ImporteCargos += SIL.Amount + SIL."Line Discount Amount";
                        DescuentoCargos += SIL."Line Discount Amount";
                        igv += SIL."Amount Including VAT" - SIL.Amount;
                    until SIL.Next = 0;


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

                if PostCodes.Get(Cust."Post Code", Cust.City) then begin
                    Provincia := PostCodes.County;
                    Departamento := PostCodes.Colonia;
                end;
                PuntoLlegada := "Bill-to Address" + ', ' + "Bill-to City" + ', ' + Provincia + ', ' + Departamento;

                //PTPV.RESET;
                //PTPV.SETRANGE("No. pedido","Order No.");
                //PTPV.SETRANGE("No. Factura","No.");
                //PTPV.SETFILTER("Forma pago TPV",'<>%1','CAMBIO');
                //IF PTPV.FINDFIRST THEN
                //  FormaPagoTPV := PTPV."Forma pago TPV";
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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
        CompanyInformation.Get;

        GLSetUp.Get;
        GLSetUp.TestField("LCY Code");
        GLSetUp.TestField("Nombre Divisa Local");

        CompanyInformation.CalcFields(Picture);
        rPais.SetRange(Code, CompanyInformation."Country/Region Code");
        rPais.FindFirst;
        vPais := CompanyInformation.City + ', ' + CompanyInformation.Name + ' ' + CompanyInformation."Post Code";
    end;

    var
        CompanyInformation: Record "Company Information";
        Text000: Label 'COPY';
        Text001: Label 'Transferred from page %1';
        Text002: Label 'Transferred to page %1';
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        Text009: Label 'VOID CREDIT MEMO';
        Cliente: Record Customer;
        Loc: Record Location;
        Currency: Record Currency;
        GLSetUp: Record "General Ledger Setup";
        Vendedor_Comprador: Record "Salesperson/Purchaser";
        PT: Record "Payment Terms";
        SCL: Record "Sales Comment Line";
        //ChkTransMgt: Report "Check Translation Management";
        SIL: Record "Sales Cr.Memo Line";
        DimVal: Record "Dimension Value";
        Cust: Record Customer;
        PostCodes: Record "Post Code";
        rPais: Record "Country/Region";
        SIH: Record "Sales Invoice Header";
        ICR: Record "Item Reference";
        PTPV: Record "Tipos de Tarjeta";
        recDimEntry: Record "Dimension Set Entry";
        CopyTxt: Text[10];
        Comentario: Text[1024];
        iBruto: Decimal;
        ImporteCargos: Decimal;
        ImporteSinCargos: Decimal;
        DescuentoCargos: Decimal;
        igv: Decimal;
        CurrName: Text[30];
        CodDivLocal: Code[20];
        CondicionPago: Text[100];
        txtIva: Text[30];
        DescriptionLine: array[2] of Text[250];
        TotFactura: Decimal;
        Descuento: Decimal;
        TipoCliente: Text[100];
        TipoVenta: Text[100];
        Nombre: Text[250];
        Provincia: Text[150];
        Departamento: Text[150];
        PuntoLlegada: Text[500];
        vPais: Text[50];
        txt004: Label '(*) IVA';
        Vend: Text[50];
        Bodega2: Text[50];
        CodBarra: Code[20];
        Grabado: Decimal;
        Exento: Decimal;
        Cambio: Decimal;
        Recibe: Decimal;
        FormaPagoTPV: Text[30];
        txt005: Label 'SON';
        CodDiv: Code[20];
        CantENviada: Decimal;
        Pct_DescCaptionLbl: Label '% Desc';
        Importe_LineaLbl: Label 'TOTAL';
        EntregarCaptionLbl: Label 'CAJA : ';
        VendedorCaptionLbl: Label 'Telefono:';
        F__Pago_CaptionLbl: Label 'F. Pago:';
        Precio_UnitarioCaptionLbl: Label 'Precio Uni.';
        Desc_ProductoCaptionLbl: Label 'Desc_Producto';
        Cod_ProductoCaptionLbl: Label 'Codigo / Desc.';
        FechaCaptionLbl: Label 'Fecha: ';
        No__de_Cliente___CaptionLbl: Label 'Cliente : ';
        RUC_CaptionLbl: Label 'RUC:';
        Cantidad_EnviadaLbl: Label 'Cant.';
        Tarifa_IVA_12____CaptionLbl: Label 'Tarifa IVA 12% : ';
        Tarifa_IVA_0____CaptionLbl: Label 'Tarifa IVA 0% : ';
        SUBTOTALCaptionLbl: Label 'SUBTOTAL';
        IVA_12_CaptionLbl: Label 'IVA 12%';
        Total_CaptionLbl: Label 'Total ';
        DESCUENTOCaptionLbl: Label 'Tot. Desc.:';
        TOTALCaptionLbl: Label 'No. Items : ';
        Cambio__CaptionLbl: Label 'Cambio: ';
        Recibe__CaptionLbl: Label 'Recibe: ';
}

