report 56089 "Cdad Enviada No Fact. Cosng."
{
    DefaultLayout = RDLC;
    RDLCLayout = './CdadEnviadaNoFactCosng.rdlc';

    dataset
    {
        dataitem("Transfer Line"; "Transfer Line")
        {
            DataItemTableView = SORTING ("Item Category Code");
            RequestFilterFields = "Item Category Code", "Shipment Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Transfer_Line__Item_Category_Code_; "Item Category Code")
            {
            }
            column(DescCategoria; DescCategoria)
            {
            }
            column(wVtaBruta; wVtaBruta)
            {
            }
            column(Transfer_Line__Qty__in_Transit_; "Qty. in Transit")
            {
            }
            column(Transfer_Line__Qty__in_Transit__Control1000000015; "Qty. in Transit")
            {
            }
            column(wVtaBruta_Control1000000016; wVtaBruta)
            {
            }
            column(Transfer_LineCaption; Transfer_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
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
            column("Cód__Categoría_ProductoCaption"; Cód__Categoría_ProductoCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Transfer_Line_Document_No_; "Document No.")
            {
            }
            column(Transfer_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                wVtaBruta := "Qty. in Transit" * "Precio Venta Consignacion"; //+#139
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Item Category Code");
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
        Transfer_LineCaptionLbl: Label 'Transfer Line';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Vta__BrutaCaptionLbl: Label 'Vta. Bruta';
        CantidadCaptionLbl: Label 'Cantidad';
        "DescripciónCaptionLbl": Label 'Descripción';
        "Cód__Categoría_ProductoCaptionLbl": Label 'Cód. Categoría Producto';
        TotalCaptionLbl: Label 'Total';
}

