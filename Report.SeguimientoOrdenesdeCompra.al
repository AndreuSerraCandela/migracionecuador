report 56123 "Seguimiento Ordenes de Compra"
{
    DefaultLayout = RDLC;
    RDLCLayout = './SeguimientoOrdenesdeCompra.rdlc';
    Caption = 'Seguimiento Ord. Compra';

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            RequestFilterFields = "Document No.";
            column(txtReimpresion; txtReimpresion)
            {
            }
            column(vPais; vPais)
            {
            }
            column(rEmpresa_Address_________rEmpresa__Address_2_; CompanyInformation.Address + ' ' + CompanyInformation."Address 2")
            {
            }
            column(Email______CompanyInformation__E_Mail_; 'Email: ' + CompanyInformation."E-Mail")
            {
            }
            column("Página_Web______CompanyInformation__Home_Page_"; 'Página Web: ' + CompanyInformation."Home Page")
            {
            }
            column(Fax_______rEmpresa__Fax_No__; 'Fax.: ' + CompanyInformation."Fax No.")
            {
            }
            column(rEmpresa_Picture; CompanyInformation.Picture)
            {
            }
            column(Tel_______rEmpresa__Phone_No__; 'Tel.: ' + CompanyInformation."Phone No.")
            {
            }
            column(DimInvProt; DimInvProt)
            {
            }
            column(DimProt; DimProt)
            {
            }
            column(Purchase_Line__No__; PH."No.")
            {
            }
            column(Purchase_Line__Shortcut_Dimension_1_Code_; "Shortcut Dimension 1 Code")
            {
            }
            column(Purchase_Line__Order_Date_; "Order Date")
            {
            }
            column(Purchase_Line_Quantity; Quantity)
            {
            }
            column(Purchase_Line__Buy_from_Vendor_No__; PH."Promised Receipt Date")
            {
            }
            column(PH__Posting_Description_; "Direct Unit Cost")
            {
            }
            column(Purchase_Line_Type; Type)
            {
            }
            column(Purchase_Line__No___Control1000000015; PH."Expected Receipt Date")
            {
            }
            column(Purchase_Line_Description; Description)
            {
            }
            column(Purchase_Line__Outstanding_Quantity_; "Outstanding Quantity")
            {
            }
            column(Purchase_Line__Quantity_Received_; "Quantity Received")
            {
            }
            column(DimInvProtPRT; DimInvProtPRT)
            {
            }
            column(DimProtPRT; DimProtPRT)
            {
            }
            column(PH__Buy_from_Vendor_Name_; "Buy-from Vendor No." + '-' + PH."Buy-from Vendor Name")
            {
            }
            column(PH__Vendor_Order_No__; PH."Vendor Order No.")
            {
            }
            column(Purchase_Line_Quantity_Control1000000008; Quantity)
            {
            }
            column(Purchase_Line__Quantity_Received__Control1000000010; "Quantity Received")
            {
            }
            column(Purchase_Line__Outstanding_Quantity__Control1000000024; "Outstanding Quantity")
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Item_CodeCaption; Item_CodeCaptionLbl)
            {
            }
            column(DescCaption; DescCaptionLbl)
            {
            }
            column(PrecioUnitCaption; PrecioUnitCaptionLbl)
            {
            }
            column(Seguimiento_de_ProductosCaption; Seguimiento_de_ProductosCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(Ext__Doc__Number_Caption; Ext__Doc__Number_CaptionLbl)
            {
            }
            column(Received_Qty_Caption; Received_Qty_CaptionLbl)
            {
            }
            column(SHIP_TO_Caption; SHIP_TO_CaptionLbl)
            {
            }
            column(Page_No_Caption; Page_No_CaptionLbl)
            {
            }
            column(cantpend; cantpendLbl)
            {
            }
            column(Vendor_Order_No_Caption; Vendor_Order_No_CaptionLbl)
            {
            }
            column(Direct_Unit_CostCaption; Direct_Unit_CostCaptionLbl)
            {
            }
            column(Planned_Receipt_DateCaption; Planned_Receipt_DateCaptionLbl)
            {
            }
            column(Expected_Receipt_DateCaption; Expected_Receipt_DateCaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(Purchase_Line_Document_Type; "Document Type")
            {
            }
            column(Purchase_Line_Document_No_; "Document No.")
            {
            }
            column(Purchase_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                PH.Get("Document Type", "Document No.");
                //+MIGRACION 2013
                /*
                IF DD.GET(39,"Document Type","Document No.","Line No.",DimInvProt) THEN;
                DimInvProtPRT := DD."Dimension Value Code";
                IF DD.GET(39,"Document Type","Document No.","Line No.",DimProt) THEN;
                DimProtPRT := DD."Dimension Value Code";
                */
                if DD.Get("Dimension Set ID", DimInvProt) then;
                DimInvProtPRT := DD."Dimension Value Code";
                if DD.Get("Dimension Set ID", DimProt) then;
                DimProtPRT := DD."Dimension Value Code";
                //-MIGRACION 2013

                //CurrReport.CREATETOTALS("Amount Including VAT","Line Discount Amount","Line Amount", Quantity);

            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals("Purchase Line".Quantity, "Purchase Line"."Quantity Received", "Purchase Line"."Outstanding Quantity");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(DimInvProt; DimInvProt)
                {
                ApplicationArea = All;
                    Caption = 'Dim Inv. Prototipos';
                    TableRelation = Dimension;
                }
                field(DimProt; DimProt)
                {
                ApplicationArea = All;
                    Caption = 'Dim Prototipos';
                    TableRelation = Dimension;
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
        CompanyInformation.Get();
        //SalesSetup.GET;
        CompanyInformation.CalcFields(Picture);

        rPais.SetRange(Code, CompanyInformation."Country/Region Code");
        rPais.FindFirst;
        vPais := CompanyInformation.City + ', ' + rPais.Name + ' ' + CompanyInformation."Post Code";

        //FormatAddress.Company(CompanyAddress,CompanyInformation);
    end;

    var
        CompanyInformation: Record "Company Information";
        PH: Record "Purchase Header";
        Text000: Label 'COPY';
        rCliente: Record Customer;
        rSalesPerson: Record "Salesperson/Purchaser";
        DD: Record "Dimension Set Entry";
        NombreVendedor: Text[200];
        SubTotal: Decimal;
        vPais: Text[50];
        rPais: Record "Country/Region";
        txtReimpresion: Text[30];
        Texto_Footer: Text[1024];
        Text001: Label 'I, _____________________________________, reseller or authorized representative of %1 with Trader Registration Number, %2 certify that Tributables buy items listed here free of payment of the IVU to be for resale, manufacturing or other reasons specified in the Model SC 2916  of Treasury Department. Firm: ______________________________';
        DimInvProt: Code[20];
        DimProt: Code[20];
        DimInvProtPRT: Text[30];
        DimProtPRT: Text[30];
        DescriptionCaptionLbl: Label 'Vendor';
        Item_CodeCaptionLbl: Label 'Order No.';
        DescCaptionLbl: Label 'Dim Business';
        PrecioUnitCaptionLbl: Label 'Order Date';
        Seguimiento_de_ProductosCaptionLbl: Label 'Purchase Order Analysis';
        QuantityCaptionLbl: Label 'Qty.';
        Ext__Doc__Number_CaptionLbl: Label 'Description';
        Received_Qty_CaptionLbl: Label 'Received Qty.';
        SHIP_TO_CaptionLbl: Label 'Doc. Type';
        Page_No_CaptionLbl: Label 'Page No.';
        cantpendLbl: Label 'Out. Qty.';
        Vendor_Order_No_CaptionLbl: Label 'Vendor Order No.';
        Direct_Unit_CostCaptionLbl: Label 'Direct Unit Cost';
        Planned_Receipt_DateCaptionLbl: Label 'Planned Receipt Date';
        Expected_Receipt_DateCaptionLbl: Label 'Expected Receipt Date';
        Total_CaptionLbl: Label 'Total:';
}

