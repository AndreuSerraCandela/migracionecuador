report 56133 "Informe Detalle Consignación"
{
    DefaultLayout = RDLC;
    RDLCLayout = './InformeDetalleConsignación.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Consignment Detail Report';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
            RequestFilterFields = "Item No.", "Location Code", "Posting Date", "Document No.", "Entry Type";
            /*column(PageConst_________FORMAT_CurrReport_PAGENO_; PageConst + ' ' + Format(CurrReport.PageNo))
            {
            }*/
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(Item_Ledger_Entry__Location_Code_; "Location Code")
            {
            }
            column(Item_Ledger_Entry__Document_No__; "Document No.")
            {
            }
            column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Item_Ledger_Entry__Item_No___Control1000000018; "Item No.")
            {
            }
            column(Item_Ledger_Entry__Descripcion_Producto_; "Descripcion Producto")
            {
            }
            column(Invoiced_Quantity___1; "Invoiced Quantity" * -1)
            {
            }
            column(Importe_Cons__bruto_Inicial___1; "Importe Cons. bruto Inicial" * -1)
            {
            }
            column(Importe_Cons__Neto_Inicial___1; "Importe Cons. Neto Inicial" * -1)
            {
            }
            column(TotalFor___FIELDCAPTION__Item_No___; TotalFor + FieldCaption("Item No."))
            {
            }
            column(Invoiced_Quantity___1_Control1000000033; "Invoiced Quantity" * -1)
            {
            }
            column(Importe_Cons__bruto_Inicial___1_Control1000000034; "Importe Cons. bruto Inicial" * -1)
            {
            }
            column(Importe_Cons__Neto_Inicial___1_Control1000000035; "Importe Cons. Neto Inicial" * -1)
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Location_Code_Caption; FieldCaption("Location Code"))
            {
            }
            column(Item_Ledger_Entry__Document_No__Caption; FieldCaption("Document No."))
            {
            }
            column(Item_Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Item_Ledger_Entry__Item_No___Control1000000018Caption; FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry__Descripcion_Producto_Caption; FieldCaption("Descripcion Producto"))
            {
            }
            column(Invoiced_Quantity___1Caption; Invoiced_Quantity___1CaptionLbl)
            {
            }
            column(Vta__NetaCaption; Vta__NetaCaptionLbl)
            {
            }
            column("Vta__LíquidaCaption"; Vta__LíquidaCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Item No.");
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
        PageConst: Label 'Página';
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total para ';
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry';
        Invoiced_Quantity___1CaptionLbl: Label 'Label1000000025';
        Vta__NetaCaptionLbl: Label 'Vta. Neta';
        "Vta__LíquidaCaptionLbl": Label 'Vta. Líquida';
}

