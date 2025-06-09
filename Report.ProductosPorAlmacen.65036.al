report 65036 "__Productos Por Almacen"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ProductosPorAlmacen.65036.rdlc';

    dataset
    {
        dataitem(Location; Location)
        {
            DataItemTableView = SORTING(Code);
            RequestFilterFields = "Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(USERID; UserId)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(LocationCaption; LocationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cod__AlmacenCaption; Cod__AlmacenCaptionLbl)
            {
            }
            column(TipoCaption; TipoCaptionLbl)
            {
            }
            column(Cod__ProductoCaption; Cod__ProductoCaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(CantidadCaption; CantidadCaptionLbl)
            {
            }
            column("Línea_de_NegocioCaption"; Línea_de_NegocioCaptionLbl)
            {
            }
            column(Costo_UnitarioCaption; Costo_UnitarioCaptionLbl)
            {
            }
            column(Costo_TotalCaption; Costo_TotalCaptionLbl)
            {
            }
            column(Ultima_compraCaption; Ultima_compraCaptionLbl)
            {
            }
            column(Precio_VentaCaption; Precio_VentaCaptionLbl)
            {
            }
            column(Location_Code; Code)
            {
            }
            dataitem(Item; Item)
            {
                DataItemTableView = SORTING("No.") ORDER(Ascending);
                RequestFilterFields = "No.";
                column(Item__No__; "No.")
                {
                }
                column(Item_Description; Description)
                {
                }
                column(Location_Code_Control1000000008; Location.Code)
                {
                }
                column(Item_Inventory; Inventory)
                {
                }
                column(Item__Global_Dimension_1_Code_; "Global Dimension 1 Code")
                {
                }
                column(Item__Unit_Cost_; "Unit Cost")
                {
                }
                column(Inventory____Unit_Cost_; Inventory * "Unit Cost")
                {
                }
                column(UltFechaCompra; UltFechaCompra)
                {
                }
                column(Precio; Precio)
                {
                }
                column(FORMAT_TipoAlmacen_; Format(TipoAlmacen))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Item.CalcFields(Inventory);
                    if Item.Inventory = 0 then
                        CurrReport.Skip;
                    //Ultima Compra
                    PurchInvLine.Reset;
                    PurchInvLine.SetCurrentKey(Type, "No.", "Posting Date");
                    PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                    PurchInvLine.SetRange("No.", "No.");
                    if PurchInvLine.FindLast then
                        UltFechaCompra := PurchInvLine."Posting Date"
                    else
                        UltFechaCompra := 0D;

                    //Precio
                    SalesPrice.Reset;
                    SalesPrice.SetRange("Asset Type", SalesPrice."Asset Type"::Item);
                    SalesPrice.SetRange("Product No.", "No.");
                    SalesPrice.SetFilter("Starting Date", '<=%1', WorkDate);
                    SalesPrice.SetRange("Ending Date", 0D, WorkDate);
                    if SalesPrice.FindLast then
                        Precio := SalesPrice."Unit Price"
                    else
                        Precio := 0;

                    //Tipo Almacen
                    if Cust.Get(Location.Code) then
                        TipoAlmacen := 1
                    else
                        TipoAlmacen := 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Location Filter", Location.Code);
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

    trigger OnPreReport()
    begin
        Filtros := Location.GetFilters + ' ' + Item.GetFilters;
    end;

    var
        PurchInvLine: Record "Purch. Inv. Line";
        SalesPrice: Record "Price List Line";
        UltFechaCompra: Date;
        Cust: Record Customer;
        Precio: Decimal;
        TipoAlmacen: Option Regular,"Consignación";
        Filtros: Text[1024];
        LocationCaptionLbl: Label 'Location';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        Cod__AlmacenCaptionLbl: Label 'Cod. Almacen';
        TipoCaptionLbl: Label 'Tipo';
        Cod__ProductoCaptionLbl: Label 'Cod. Producto';
        "DescripciónCaptionLbl": Label 'Descripción';
        CantidadCaptionLbl: Label 'Cantidad';
        "Línea_de_NegocioCaptionLbl": Label 'Línea de Negocio';
        Costo_UnitarioCaptionLbl: Label 'Costo Unitario';
        Costo_TotalCaptionLbl: Label 'Costo Total';
        Ultima_compraCaptionLbl: Label 'Ultima compra';
        Precio_VentaCaptionLbl: Label 'Precio Venta';
}

