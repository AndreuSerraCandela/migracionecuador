report 56103 "Consignacion Producto/Cliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ConsignacionProductoCliente.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Consignment Product/Customer';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", Positive, "Location Code", "Variant Code");
            RequestFilterFields = "Item No.", Positive, "Location Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial_; "Importe Cons. Neto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial_; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry__Invoiced_Quantity_; "Invoiced Quantity")
            {
            }
            column(Item_Ledger_Entry__Location_Code_; "Location Code")
            {
            }
            column(Item_Ledger_Entry__Descripcion_Producto_; "Descripcion Producto")
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(TotalFor___FIELDCAPTION__Item_No___; TotalFor + FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry__Invoiced_Quantity__Control1000000043; "Invoiced Quantity")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial__Control1000000044; "Importe Cons. bruto Inicial")
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial__Control1000000045; "Importe Cons. Neto Inicial")
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry__Descripcion_Producto_Caption; FieldCaption("Descripcion Producto"))
            {
            }
            column(Item_Ledger_Entry__Location_Code_Caption; FieldCaption("Location Code"))
            {
            }
            column(Item_Ledger_Entry__Invoiced_Quantity_Caption; FieldCaption("Invoiced Quantity"))
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__bruto_Inicial_Caption; FieldCaption("Importe Cons. bruto Inicial"))
            {
            }
            column(Item_Ledger_Entry__Importe_Cons__Neto_Inicial_Caption; FieldCaption("Importe Cons. Neto Inicial"))
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            column(Item_Ledger_Entry_Positive; Positive)
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
        TotalFor: Label 'Total para ';
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
}

