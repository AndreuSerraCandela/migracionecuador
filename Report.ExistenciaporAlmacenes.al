report 56099 "Existencia por Almacenes"
{
    // Si da error de clave, activar el grupo de claves "ConvLoc"
    DefaultLayout = RDLC;
    RDLCLayout = './ExistenciaporAlmacenes.rdlc';


    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = SORTING ("Item No.", "Location Code");
            RequestFilterFields = "Item No.", "Location Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(rItem_Description; rItem.Description)
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(Location_Code__; ("Location Code"))
            {
            }
            column(Item_Ledger_Entry_Quantity; Quantity)
            {
            }
            column(rAlmacen_Name; rAlmacen.Name)
            {
            }
            column(Total_Producto___; 'Total Producto ')
            {
            }
            column(Item_Ledger_Entry_Quantity_Control1000000025; Quantity)
            {
            }
            column(Item_Ledger_EntryCaption; Item_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Cod__AlmacénCaption"; Cod__AlmacénCaptionLbl)
            {
            }
            column(NombreCaption; NombreCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            column(Item_Ledger_Entry_Location_Code; "Item Ledger Entry"."Location Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //+#139
                if "Item No." <> rItem."No." then
                    rItem.Get("Item No.");

                if "Location Code" <> rAlmacen.Code then
                    rAlmacen.Get("Location Code");

                if Quantity = 0 then
                    CurrReport.Skip;
                //-#139
            end;

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
        rItem: Record Item;
        rAlmacen: Record Location;
        Item_Ledger_EntryCaptionLbl: Label 'Item Ledger Entry';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Cod__AlmacénCaptionLbl": Label 'Cod. Almacén';
        NombreCaptionLbl: Label 'Nombre';
        CantidadCaptionLbl: Label 'Cantidad';
}

