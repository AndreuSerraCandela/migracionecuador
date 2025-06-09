report 56088 "Cantidad Enviada no facturada"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CantidadEnviadanofacturada.rdlc';

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING ("Item Category Code");
            RequestFilterFields = "Item Category Code", "Location Code", "Shipment Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(Sales_Line__Shipped_Not_Invoiced_; "Shipped Not Invoiced")
            {
            }
            column(Sales_Line__Item_Category_Code_; "Item Category Code")
            {
            }
            column(wVtaBruta; wVtaBruta)
            {
            }
            column(DescCategoria; DescCategoria)
            {
            }
            column(Sales_Line__Shipped_Not_Invoiced__Control1000000010; "Shipped Not Invoiced")
            {
            }
            column(wVtaBruta_Control1000000013; wVtaBruta)
            {
            }
            column(Sales_LineCaption; Sales_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Cód__Categoría_ProductoCaption"; Cód__Categoría_ProductoCaptionLbl)
            {
            }
            column(Vta__BrutaCaption; Vta__BrutaCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Sales_Line_Document_Type; "Document Type")
            {
            }
            column(Sales_Line_Document_No_; "Document No.")
            {
            }
            column(Sales_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                wVtaBruta := "Shipped Not Invoiced" * "Unit Price"; //+#139

                //+#139
                if "Item Category Code" <> rItemCatCode.Code then begin
                    if rItemCatCode.Get("Item Category Code") then
                        DescCategoria := rItemCatCode.Description
                    else
                        DescCategoria := '';
                end;
                //-#139
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Item Category Code");
                Filtros := "Sales Line".GetFilters;

                //CurrReport.CreateTotals(wVtaBruta);
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
        Filtros: Text[1000];
        wVtaBruta: Decimal;
        wVtaBrutaTotal: Decimal;
        rItemCatCode: Record "Item Category";
        DescCategoria: Text[290];
        Sales_LineCaptionLbl: Label 'Sales Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Cód__Categoría_ProductoCaptionLbl": Label 'Cód. Categoría Producto';
        Vta__BrutaCaptionLbl: Label 'Vta. Bruta';
        CantidadCaptionLbl: Label 'Cantidad';
        "DescripciónCaptionLbl": Label 'Descripción';
        TotalCaptionLbl: Label 'Total';
}

