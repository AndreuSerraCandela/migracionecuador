report 56098 "Back Orders Cliente"
{
    // ------------------------------------------------------------------------
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 139         11/12/2013      RRT           Adaptación informes a RTC.
    // 
    // #56090      27/09/2016      PLB           Utilizar función disponibilidad backorder en lugar de la estándar
    DefaultLayout = RDLC;
    RDLCLayout = './BackOrdersCliente.rdlc';


    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            RequestFilterFields = "Document No.", "No.", "Sell-to Customer No.", "Shipment Date", "Location Code", "Shortcut Dimension 1 Code", "Outstanding Quantity";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Sales_Line__Document_No__; "Document No.")
            {
            }
            column(Sales_Line__No__; "No.")
            {
            }
            column(Sales_Line_Description; Description)
            {
            }
            column(Sales_Line_Quantity; Quantity)
            {
            }
            column(Sales_Line__Quantity_Shipped_; "Quantity Shipped")
            {
            }
            column(Sales_Line__Sales_Line___Outstanding_Quantity_; "Sales Line"."Outstanding Quantity")
            {
            }
            column(Sales_Line__Location_Code_; "Location Code")
            {
            }
            column(rCliente__No________rCliente_Name; rCliente."No." + ' ' + rCliente.Name)
            {
            }
            column(Sales_Line_Quantity_Control1000000010; Quantity)
            {
            }
            column(Sales_Line__Quantity_Shipped__Control1000000011; "Quantity Shipped")
            {
            }
            column(Sales_Line__Sales_Line___Outstanding_Quantity__Control1000000013; "Sales Line"."Outstanding Quantity")
            {
            }
            column(Sales_LineCaption; Sales_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Sales_Line__No__Caption; FieldCaption("No."))
            {
            }
            column(Sales_Line_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Sales_Line_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Sales_Line__Quantity_Shipped_Caption; FieldCaption("Quantity Shipped"))
            {
            }
            column(Back_OrderCaption; Back_OrderCaptionLbl)
            {
            }
            column(AlmacenCaption; AlmacenCaptionLbl)
            {
            }
            column(Pedidos_en_FirmeCaption; Pedidos_en_FirmeCaptionLbl)
            {
            }
            column(ClienteCaption; ClienteCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Sales_Line_Document_Type; "Document Type")
            {
            }
            column(Sales_Line_Line_No_; "Line No.")
            {
            }
            column(Sales_Line_Type; Type)
            {
            }
            column(Sales_Line_Sell_to_Customer_No_; "Sell-to Customer No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                wCantPendConsg := 0;

                rSalesHeader.Get("Document Type", "Document No.");

                if rSalesHeader."Venta TPV" then
                    CurrReport.Skip;

                //IF SalesInfoPaneMgt.CalcAvailability("Sales Line") >= 0 THEN //-#56090
                if SalesInfoPaneMgt.CalcAvailability_BackOrder("Sales Line") >= 0 then //+#56090
                    CurrReport.Skip;

                //+139
                if not rCliente.Get("Sell-to Customer No.") then
                    Clear(rCliente);
                //-139
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
            end;
        }
        dataitem("Transfer Line"; "Transfer Line")
        {
            DataItemTableView = SORTING ("Item No.") ORDER(Ascending);
            RequestFilterFields = "Document No.", "Item No.", "Transfer-to Code", "Shipment Date", "Transfer-from Code", "Shortcut Dimension 1 Code", "Outstanding Quantity";
            column(Transfer_Line__Document_No__; "Document No.")
            {
            }
            column(Transfer_Line__Item_No__; "Item No.")
            {
            }
            column(Transfer_Line_Description; Description)
            {
            }
            column(Transfer_Line__Transfer_from_Code_; "Transfer-from Code")
            {
            }
            column(Transfer_Line_Quantity; Quantity)
            {
            }
            column(Transfer_Line__Quantity_Shipped_; "Quantity Shipped")
            {
            }
            column(Transfer_Line__Outstanding_Quantity_; "Outstanding Quantity")
            {
            }
            column(rCliente__No________rCliente_Name_Control1000000052; rCliente."No." + ' ' + rCliente.Name)
            {
            }
            column(Transfer_Line_Quantity_Control1000000042; Quantity)
            {
            }
            column(Transfer_Line__Quantity_Shipped__Control1000000046; "Quantity Shipped")
            {
            }
            column(Transfer_Line__Outstanding_Quantity__Control1000000048; "Outstanding Quantity")
            {
            }
            column(Pedidos_en_ConsignacionCaption; Pedidos_en_ConsignacionCaptionLbl)
            {
            }
            column(No__DocumentoCaption; No__DocumentoCaptionLbl)
            {
            }
            column(N_Caption; N_CaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(AlmacenCaption_Control1000000032; AlmacenCaption_Control1000000032Lbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column(Cantidad_enviadaCaption; Cantidad_enviadaCaptionLbl)
            {
            }
            column(Back_OrderCaption_Control1000000036; Back_OrderCaption_Control1000000036Lbl)
            {
            }
            column(ClienteCaption_Control1000000050; ClienteCaption_Control1000000050Lbl)
            {
            }
            column(TotalCaption_Control1000000039; TotalCaption_Control1000000039Lbl)
            {
            }
            column(Transfer_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                rTransferHeader.Get("Document No.");
                if (not rTransferHeader."Pedido Consignacion") or (rTransferHeader."Devolucion Consignacion") then
                    CurrReport.Skip;

                //+139
                if not rCliente.Get("Transfer-to Code") then
                    Clear(rCliente);
                //-139
            end;

            trigger OnPreDataItem()
            begin
                //+139
                Clear(rCliente);
                //-139
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total para ';
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
        wCantPendConsg: Decimal;
        rSalesHeader: Record "Sales Header";
        rTransferHeader: Record "Transfer Header";
        rTransferLines: Record "Transfer Line";
        wCantDisp: Decimal;
        AvailableToPromise: Codeunit "Available to Promise";
        rItem: Record Item;
        rCliente: Record Customer;
        Sales_LineCaptionLbl: Label 'Sales Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Back_OrderCaptionLbl: Label 'Back Order';
        AlmacenCaptionLbl: Label 'Almacen';
        Pedidos_en_FirmeCaptionLbl: Label 'Pedidos en Firme';
        ClienteCaptionLbl: Label 'Cliente';
        TotalCaptionLbl: Label 'Total';
        Pedidos_en_ConsignacionCaptionLbl: Label 'Pedidos en Consignacion';
        No__DocumentoCaptionLbl: Label 'No. Documento';
        N_CaptionLbl: Label 'Nº';
        "DescripciónCaptionLbl": Label 'Descripción';
        AlmacenCaption_Control1000000032Lbl: Label 'Almacen';
        CantidadCaptionLbl: Label 'Cantidad';
        Cantidad_enviadaCaptionLbl: Label 'Cantidad enviada';
        Back_OrderCaption_Control1000000036Lbl: Label 'Back Order';
        ClienteCaption_Control1000000050Lbl: Label 'Cliente';
        TotalCaption_Control1000000039Lbl: Label 'Total';
}

