report 56079 "Inventario Productos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './InventarioProductos.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = Inventory;
            DataItemTableView = SORTING("No.") WHERE(Blocked = FILTER(false));
            RequestFilterFields = Inventory, "Location Filter";
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
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item__Base_Unit_of_Measure_; "Base Unit of Measure")
            {
            }
            column(Item_Inventory; Inventory)
            {
            }
            column(Item_Item__Global_Dimension_1_Code_; Item."Global Dimension 1 Code")
            {
            }
            column(ItemCaption; ItemCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption; FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Item__Base_Unit_of_Measure_Caption; FieldCaption("Base Unit of Measure"))
            {
            }
            column(Item_InventoryCaption; FieldCaption(Inventory))
            {
            }
            column("Lín__NegocioCaption"; Lín__NegocioCaptionLbl)
            {
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
        ItemCaptionLbl: Label 'Item';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        "Lín__NegocioCaptionLbl": Label 'Lín. Negocio';
}

