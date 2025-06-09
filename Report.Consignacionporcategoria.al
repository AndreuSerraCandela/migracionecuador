report 56073 "Consignacion por categoria"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Consignacionporcategoria.rdlc';
    ApplicationArea = Suite, Basic;
    Caption = 'Consignment by category';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item Category Code", "Posting Date", "Item No.", "Location Code") ORDER(Ascending);
            RequestFilterFields = "Item Category Code", "Posting Date", "Item No.", "Location Code";
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
            column(Item_Ledger_Entry__Item_Category_Code_; "Item Category Code")
            {
            }
            column(Item_Ledger_Entry_Quantity; Quantity)
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial_; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
            {
            }
            column(DescCat; DescCat)
            {
            }
            column(Item_Ledger_Entry_Quantity_Control1000000007; Quantity)
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial__Control1000000008; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial__Control1000000009; "Importe Cons. Neto Inicial")
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Categoría_ProductoCaption"; Categoría_ProductoCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column(Vta__NetaCaption; Vta__NetaCaptionLbl)
            {
            }
            column(Vta__LiquidaCaption; Vta__LiquidaCaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if rItemCatCode.Get("Item Category Code") then
                    DescCat := rItemCatCode.Description
                else
                    DescCat := '';
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Item Category Code");
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
        Filtros := "Item Ledger Entry".GetFilters;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total para ';
        Filtros: Text[800];
        rItemCatCode: Record "Item Category";
        DescCat: Text[100];
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Categoría_ProductoCaptionLbl": Label 'Categoría Producto';
        CantidadCaptionLbl: Label 'Cantidad';
        Vta__NetaCaptionLbl: Label 'Vta. Neta';
        Vta__LiquidaCaptionLbl: Label 'Vta. Liquida';
        "DescripciónCaptionLbl": Label 'Descripción';
        TotalCaptionLbl: Label 'Total';
}

