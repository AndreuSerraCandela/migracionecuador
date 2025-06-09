report 55001 "Factura Santillana Ecuador"
{
    // #1815 21/01/2014 PLB: Error de sobrepasamiento -> vPais de Text50 a Text150
    // #3476 11/09/2014 RRT: Quitar los datos de dirección del envío. Se especificarán como no visibles.
    // #4272 11/09/2014 RRT: Eliminar el campo "Cantidad solicitada".
    // #16268  16/04/2015  MOI: Se añade el campo Direccion Sucursal al dataset.
    DefaultLayout = RDLC;
    RDLCLayout = './FacturaSantillanaEcuador.rdlc';

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
            column(Sales_Invoice_Header__Bill_to_Customer_No__; DelChr("Bill-to Customer No.", '<>'))
            {
            }
            column(Sales_Invoice_Header__Bill_to_Address_; "Bill-to Address")
            {
            }
            column(Sales_Invoice_Header__Bill_to_Name_; "Bill-to Name")
            {
            }
            column(Sales_Invoice_Header__Posting_Date_; Format("Posting Date"))
            {
            }
            column(CondicionPago_________________FORMAT__Due_Date__; CondicionPago + '         ' + Format("Due Date"))
            {
            }
            column(Serie_Factura_________No__Comprobante_Fiscal_; "No. Comprobante Fiscal")
            {
            }
            column(CondicionPago_________________FORMAT__Order_Num__; "Order No.")
            {
            }
            column(Sales_Invoice_Header__Bill_to_city_; "Bill-to City")
            {
            }
            column(Sales_Invoice_Header__Bill_to_county_; "Bill-to County")
            {
            }
            column(rCliente__Phone_No1_; "Sell-to Phone")
            {
            }
            column(rCliente__Phone_No; "Ship-to Phone")
            {
            }
            column(Sales_Invoice_Header__Ship_to_Address; "Ship-to Address")
            {
            }
            column(Sales_Invoice_Header__Ship_to_Name_; "Ship-to Name")
            {
            }
            column(Sales_Invoice_Header__Ship_to_city; "Ship-to City")
            {
            }
            column(Sales_Invoice_Header__Ship_to_county; "Ship-to County")
            {
            }
            column(Sales_Invoice_Header__Ship_to_Code; "Ship-to Code" + ' - ' + "Ship-to Contact")
            {
            }
            column(Sales_Invoice_Header__Order_Date; Format("Order Date"))
            {
            }
            column(Sales_Invoice_Header__Shipment_Date; Format("Shipment Date"))
            {
            }
            column(Sales_Invoice_Header__Vendedor; "Salesperson Code" + ' - ' + VendorName)
            {
            }
            column(rCliente__No_Cliente; rCliente."No.")
            {
            }
            column(rCliente__No_Factura; "No.")
            {
            }
            column(Almacen; "Location Code")
            {
            }
            column(SCL_Comment; SCL.Comment)
            {
            }
            column(Ruc_Cliente; 'RUC: ' + "VAT Registration No.")
            {
            }
            column(CodDivLocalFormateada; CodDiv + ' ' + Format(TotFactura, 0, '<Precision,2:2><Standard format,0>'))
            {
                //Comentado DecimalPlaces = 2 : 2;
            }
            column(otros; ImporteSinCargos - Descuento)
            {
                DecimalPlaces = 2 : 2;
            }
            column(DescriptionLine_1_____________CurrName; txt005 + ' ' + DescriptionLine[1] + ' ** ' + CurrName)
            {
            }
            column(igv; igv)
            {
            }
            column(totDesc; Descuento)
            {
            }
            column(iBruto11; ImporteSinCargos)
            {
            }
            column(Sales_Invoice_Header__User_ID_; "User ID")
            {
            }
            column(Location_ID; Loc.City + ', ' + Format(Today))
            {
            }
            column(Cantidad_Total; CantENviada)
            {
                DecimalPlaces = 0 : 2;
            }
            column(FechaCaption; FechaCaptionLbl)
            {
            }
            column(Condiciones_de_PagoCaption; Condiciones_de_PagoCaptionLbl)
            {
            }
            column(PedidoCaption; PedidoCaptionLbl)
            {
            }
            column(Fecha_PedidoCaption; Fecha_PedidoCaptionLbl)
            {
            }
            column(EntregarCaption; EntregarCaptionLbl)
            {
            }
            column(VendedorCaption; VendedorCaptionLbl)
            {
            }
            column(No__de_Cliente___Caption; No__de_Cliente___CaptionLbl)
            {
            }
            column(No__de_Factura___Caption; No__de_Factura___CaptionLbl)
            {
            }
            column(BOD____Caption; BOD____CaptionLbl)
            {
            }
            column(Comentario_Caption; Comentario_CaptionLbl)
            {
            }
            column(No__de_Cliente_Caption; No__de_Cliente_CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(SUBTOTALCaption; SUBTOTALCaptionLbl)
            {
            }
            column(DESCUENTOCaption; DESCUENTOCaptionLbl)
            {
            }
            column(VALOR_NETOCaption; VALOR_NETOCaptionLbl)
            {
            }
            column(IVA_12_Caption; IVA_12_CaptionLbl)
            {
            }
            column(TOTALCaption; TOTALCaptionLbl)
            {
            }
            column(gtDireccion; gtDireccion)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") WHERE(Quantity = FILTER(<> 0), Type = FILTER(<> "Charge (Item)"));
                column(Sales_Invoice_Line__No__; "No.")
                {
                }
                column(Sales_Invoice_Line_Description; Description)
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
                column(Sales_Invoice_Line_Item_Cross_Ref; CodBarra)
                {
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
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);

                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PageNo := 1;

                    if CopyNo = NoLoops then begin
                        if not CurrReport.Preview then
                            SalesInvPrinted.Run("Sales Invoice Header");
                        CurrReport.Break;
                    end else
                        CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                        Clear(CopyTxt)
                    else
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies) + Customer."Invoice Copies";
                    if NoLoops <= 0 then
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                rDim: Record "Dimension Set Entry";
                lrNoSeriesLine: Record "No. Series Line";
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
                //MIG
                /*
                //Tipo Clinte
                PostedDocDim.RESET;
                PostedDocDim.SETRANGE("Table ID",112);
                PostedDocDim.SETRANGE("Document No.","No.");
                PostedDocDim.SETRANGE("Dimension Code",'TIPO_CLIENTE');
                PostedDocDim.SETRANGE("Line No.",0);
                IF PostedDocDim.FINDFIRST THEN
                  BEGIN
                    //TipoCliente := PostedDocDim."Dimension Value Code";
                    DimVal.RESET;
                    DimVal.SETRANGE("Dimension Code",PostedDocDim."Dimension Code");
                    DimVal.SETRANGE(Code,PostedDocDim."Dimension Value Code");
                    IF DimVal.FINDFIRST THEN
                      TipoCliente := DimVal.Name;
                  END;
                
                //Tipo Venta
                PostedDocDim.RESET;
                PostedDocDim.SETRANGE("Table ID",112);
                PostedDocDim.SETRANGE("Document No.","No.");
                PostedDocDim.SETRANGE("Dimension Code",'TIPO_VENTA');
                PostedDocDim.SETRANGE("Line No.",0);
                IF PostedDocDim.FINDFIRST THEN
                  BEGIN
                    //TipoCliente := PostedDocDim."Dimension Value Code";
                    DimVal.RESET;
                    DimVal.SETRANGE("Dimension Code",PostedDocDim."Dimension Code");
                    DimVal.SETRANGE(Code,PostedDocDim."Dimension Value Code");
                    IF DimVal.FINDFIRST THEN
                      TipoVenta := DimVal.Name;
                  END;
                */
                if "Sales Invoice Header"."Dimension Set ID" <> 0 then begin
                    if rDim.Get("Sales Invoice Header"."Dimension Set ID", 'TIPO_CLIENTE') then
                        TipoCliente := rDim."Dimension Value Name";
                    if rDim.Get("Sales Invoice Header"."Dimension Set ID", 'TIPO_VENTA') then
                        TipoVenta := rDim."Dimension Value Name";
                end;
                //-MIG
                if Cust.Get("Sell-to Customer No.") then
                    Nombre := UpperCase(Cust.Name);

                if PostCodes.Get("Sell-to Post Code", "Sell-to City") then begin
                    Provincia := PostCodes.County;
                    Departamento := PostCodes.Colonia;
                end;
                PuntoLlegada := "Sell-to Address" + ', ' + "Sell-to City" + ', ' + Provincia + ', ' + Departamento;

                //Para anular el ncf actual y generar uno nuevo - Error de impresion -
                ConfSant.Get;
                if ("No. Printed" > 0) and (not CurrReport.Preview) and (AnulaComp) then
                    if Confirm(txt0001, false, NoSerMagmnt.GetNextNo("No. Serie NCF Facturas", WorkDate, false)) then begin
                        NCFAnulados."No. documento" := "No.";
                        NCFAnulados."No. Serie NCF Facturas" := "No. Serie NCF Facturas";
                        NCFAnulados."No. Comprobante Fiscal" := "No. Comprobante Fiscal";
                        NCFAnulados."Fecha anulacion" := Today;
                        NCFAnulados."Tipo Documento" := 2;
                        NCFAnulados."No. Autorizacion" := "No. Autorizacion Comprobante";
                        NCFAnulados."Punto Emision" := "Punto de Emision Factura";
                        NCFAnulados.Establecimiento := "Establecimiento Factura";
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
                //MOI - 16/04/2015 (#16268):Inicio
                gtDireccion := lrNoSeriesLine.getDireccionSucursal("Sales Invoice Header"."No. Series", "Sales Invoice Header"."Posting Date");
                //MOI - 16/04/2015 (#16268):Fin
                // --------------------------------------- Codigo Dynasoft --------------------------------------------

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Anular Comprobante"; AnulaComp)
                {
                    ApplicationArea = All;
                    Caption = 'Void Fiscal No.';
                }
            }
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
        Text001: Label 'Page %1';
        wDiv: Code[10];
        VendorName: Text[50];
        Vendedor_Comprador: Record "Salesperson/Purchaser";
        vPais: Text[150];
        rPais: Record "Country/Region";
        Comentario: Text[1024];
        //ChkTransMgt: Report "Check Translation Management";
        DescriptionLine: array[2] of Text[250];
        CurrName: Text[30];
        Text002: Label 'Total %1';
        txtIva: Text[30];
        txt004: Label '(*) IVA';
        NoLineas: Integer;
        PT: Record "Payment Terms";
        CondicionPago: Text[100];
        iBruto: Decimal;
        totDesc: Decimal;
        igv: Decimal;
        otros: Decimal;
        TotFactura: Decimal;
        GLSetUp: Record "General Ledger Setup";
        CodDiv: Code[20];
        NCFAnulados: Record "NCF Anulados";
        NoSeriesMgt: Codeunit "No. Series";
        CLE: Record "Cust. Ledger Entry";
        SSH: Record "Sales Shipment Header";
        NoGuia: Code[50];
        Prueba: Decimal;
        Descuento: Decimal;
        SIL: Record "Sales Invoice Line";
        TipoCliente: Text[100];
        TipoVenta: Text[100];
        Loc: Record Location;
        DimVal: Record "Dimension Value";
        txt005: Label 'SON';
        Cust: Record Customer;
        Nombre: Text[250];
        PostCodes: Record "Post Code";
        Provincia: Text[150];
        Departamento: Text[150];
        PuntoLlegada: Text[500];
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        Customer: Record Customer;
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        CopyTxt: Text[10];
        Text000: Label 'COPY';
        ConfSant: Record "Config. Empresa";
        ImporteSinCargos: Decimal;
        ImporteCargos: Decimal;
        DescuentoCargos: Decimal;
        CantENviada: Decimal;
        CantSolicitada: Decimal;
        Vendedor: Text[30];
        ICR: Record "Item Reference";
        CodBarra: Code[20];
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        "//DYN": Integer;
        txt0001: Label 'This reprint will void the actual correlative and will assing a new one %1. Confirm that you want to proceed';
        AnulaComp: Boolean;
        NoSerMagmnt: Codeunit "No. Series";
        txt0002: Label 'The invoice must have at least 1 printed copy';
        FechaCaptionLbl: Label 'Fecha';
        Condiciones_de_PagoCaptionLbl: Label 'Condiciones de Pago';
        PedidoCaptionLbl: Label 'Pedido';
        Fecha_PedidoCaptionLbl: Label 'Fecha Pedido';
        EntregarCaptionLbl: Label 'Entregar';
        VendedorCaptionLbl: Label 'Vendedor';
        No__de_Cliente___CaptionLbl: Label 'No. de Cliente : ';
        No__de_Factura___CaptionLbl: Label 'No. de Factura : ';
        BOD____CaptionLbl: Label 'BOD. : ';
        Comentario_CaptionLbl: Label 'Comment: ';
        No__de_Cliente_CaptionLbl: Label 'No. Comprobante Fiscal: ';
        Total_CaptionLbl: Label 'VALOR TOTAL';
        SUBTOTALCaptionLbl: Label 'SUBTOTAL';
        DESCUENTOCaptionLbl: Label 'DESCUENTO';
        VALOR_NETOCaptionLbl: Label 'VALOR NETO';
        IVA_12_CaptionLbl: Label 'IVA 12%';
        TOTALCaptionLbl: Label 'TOTAL UNIDADES';
        gtDireccion: Text[50];


    procedure InitLogInteraction()
    begin
        //LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;
}

