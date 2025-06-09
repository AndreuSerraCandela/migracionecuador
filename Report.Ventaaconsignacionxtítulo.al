report 56131 "Venta a consignacion x título"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Ventaaconsignacionxtítulo.rdlc';
    ApplicationArea = Suite, Basic;
    Caption = 'Consignment sale x title';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Location Code");
            RequestFilterFields = "Document No.", "Remaining Quantity", "Item No.", "Location Code", "Global Dimension 1 Code", "Posting Date";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Item_Ledger_Entry__Location_Code_; "Location Code")
            {
            }
            column(Item_Ledger_Entry__Location_Code__Control1000000011; "Location Code")
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(Item_Ledger_Entry__Descripcion_Producto_; "Descripcion Producto")
            {
            }
            column(Item_Ledger_Entry__Remaining_Quantity_; "Remaining Quantity")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial_; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
            {
            }
            column(TotalFor___FIELDCAPTION__Location_Code__; TotalFor + ' ' + "Location Code")
            {
            }
            column(Item_Ledger_Entry__Remaining_Quantity__Control1000000029; "Remaining Quantity")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial__Control1000000030; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial__Control1000000031; "Importe Cons. Neto Inicial")
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Location_Code__Control1000000011Caption; FieldCaption("Location Code"))
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry__Descripcion_Producto_Caption; FieldCaption("Descripcion Producto"))
            {
            }
            column(Item_Ledger_Entry__Remaining_Quantity_Caption; FieldCaption("Remaining Quantity"))
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial_Caption; FieldCaption("Importe Cons. bruto Inicial"))
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial_Caption; FieldCaption("Importe Cons. Neto Inicial"))
            {
            }
            column(Item_Ledger_Entry__Location_Code_Caption; FieldCaption("Location Code"))
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Location Code");
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
        TotalFor: Label 'Total para almacén';
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

