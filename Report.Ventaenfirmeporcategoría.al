report 56106 "Venta en firme por categoría"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Ventaenfirmeporcategoría.rdlc';

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING ("Cod. Oferta", "Posting Date", "Item Ledger Entry Type") ORDER(Ascending);
            RequestFilterFields = "Cod. Oferta", "Posting Date", "Source No.", "Item Ledger Entry Type", "Global Dimension 1 Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cost_Posted_to_G_L___1; "Cost Posted to G/L" * -1)
            {
            }
            column(Value_Entry__Discount_Amount_; "Discount Amount")
            {
            }
            column(Value_Entry__Sales_Amount__Actual__; "Sales Amount (Actual)")
            {
            }
            column(Value_Entry___Sales_Amount__Actual____Value_Entry___Discount_Amount_; "Value Entry"."Sales Amount (Actual)" - "Value Entry"."Discount Amount")
            {
            }
            column(Invoiced_Quantity___1; "Invoiced Quantity" * -1)
            {
            }
            column(Value_Entry__Value_Entry___Item_Category_Code_; "Value Entry"."Cod. Oferta")
            {
            }
            column(Value_EntryCaption; Value_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Cod__CategoríaCaption"; Cod__CategoríaCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column("Vta__LíquidaCaption"; Vta__LíquidaCaptionLbl)
            {
            }
            column(DescuentoCaption; DescuentoCaptionLbl)
            {
            }
            column(CostoCaption; CostoCaptionLbl)
            {
            }
            column(Vta__NetaCaption; Vta__NetaCaptionLbl)
            {
            }
            column(Value_Entry_Entry_No_; "Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Cod. Oferta");
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
        filtros: Text[800];
        rItemCatCode: Record "Item Category";
        DescCat: Text[100];
        Value_EntryCaptionLbl: Label 'Value Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Cod__CategoríaCaptionLbl": Label 'Cod. Categoría';
        CantidadCaptionLbl: Label 'Cantidad';
        "Vta__LíquidaCaptionLbl": Label 'Vta. Líquida';
        DescuentoCaptionLbl: Label 'Descuento';
        CostoCaptionLbl: Label 'Costo';
        Vta__NetaCaptionLbl: Label 'Vta. Neta';
}

