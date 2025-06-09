report 56122 "Ventas por Productos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './VentasporProductos.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            //DataItemLinkReference = "Value Entry";
            RequestFilterFields = "No.";
            column(USERID; UserId)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Value_EntryCaption; Value_EntryCaptionLbl)
            {
            }
            column("Venta_LíquidaCaption"; Venta_LíquidaCaptionLbl)
            {
            }
            column(Importe_CosteCaption; Importe_CosteCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(No__ProductoCaption; No__ProductoCaptionLbl)
            {
            }
            column(Venta_NetaCaption; Venta_NetaCaptionLbl)
            {
            }
            column(Importe_CosteCaption_Control1000000015; Importe_CosteCaption_Control1000000015Lbl)
            {
            }
            column(Importe_CosteCaption_Control1000000016; Importe_CosteCaption_Control1000000016Lbl)
            {
            }
            column(Item_No_; "No.")
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item No." = FIELD ("No.");
                DataItemTableView = SORTING ("Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type", "Variance Type", "Item Charge No.", "Location Code", "Variant Code") WHERE ("Item Ledger Entry Type" = FILTER (Sale));
                RequestFilterFields = "Item No.", "Posting Date", "Source No.", "Document No.", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group";
                column(Cost_Amount__Actual____1; "Cost Amount (Actual)" * -1)
                {
                }
                column(Sales_Amount__Actual____Discount_Amount_; "Sales Amount (Actual)" - "Discount Amount")
                {
                }
                column(Value_Entry__Sales_Amount__Actual__; "Sales Amount (Actual)")
                {
                }
                column(Invoiced_Quantity___1; "Invoiced Quantity" * -1)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Item_Description; Item.Description)
                {
                }
                column(Value_Entry__Item_No__; "Item No.")
                {
                }
                column(Item__Item_Category_Code_; Item."Item Category Code")
                {
                }
                column(Item__Global_Dimension_1_Code_; Item."Global Dimension 1 Code")
                {
                }
                column(Value_Entry_Entry_No_; "Entry No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    vtaejemplar := vtaejemplar + "Invoiced Quantity";
                    vtaneta := vtaneta + "Sales Amount (Actual)" - "Discount Amount";
                    vtaliquida := vtaliquida + "Sales Amount (Actual)";
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Item No.");
                    //CurrReport.CreateTotals("Value Entry"."Sales Amount (Actual)", "Value Entry"."Discount Amount");
                end;
            }
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
        Descripcion1: Record Item;
        vtaneta: Decimal;
        vtaejemplar: Integer;
        vtaliquida: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Value_EntryCaptionLbl: Label 'Value Entry';
        "Venta_LíquidaCaptionLbl": Label 'Venta Líquida';
        Importe_CosteCaptionLbl: Label 'Importe Coste';
        CantidadCaptionLbl: Label 'Cantidad';
        "DescripciónCaptionLbl": Label 'Descripción';
        No__ProductoCaptionLbl: Label 'No. Producto';
        Venta_NetaCaptionLbl: Label 'Venta Neta';
        Importe_CosteCaption_Control1000000015Lbl: Label 'Importe Coste';
        Importe_CosteCaption_Control1000000016Lbl: Label 'Importe Coste';
}

