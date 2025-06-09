report 56007 "Lista Inventario Consignacion"
{
    // ------------------------------------------------------------------------
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 139         28/11/2013      RRT           Adaptación informes a RTC. Pasar código de OnPreSection() a  OnAfterGetRecord()
    DefaultLayout = RDLC;
    RDLCLayout = './ListaInventarioConsignacion.rdlc';


    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Date Filter";
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
            column(GETFILTERS; GetFilters)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Inventario_en_Consignacion_; "Inventario en Consignacion")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Customer__Balance_en_Consignacion_; "Balance en Consignacion")
            {
            }
            column(Customer__Balance_en_Consignacion__Control1000000007; "Balance en Consignacion")
            {
            }
            column(Customer__Inventario_en_Consignacion__Control1000000010; "Inventario en Consignacion")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Consignation_Inventory_ListCaption; Consignation_Inventory_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption; FieldCaption("No."))
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(Customer__Inventario_en_Consignacion_Caption; FieldCaption("Inventario en Consignacion"))
            {
            }
            column(Customer__Balance_en_Consignacion_Caption; FieldCaption("Balance en Consignacion"))
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //+139
                if SoloBalance then
                    if "Inventario en Consignacion" = 0 then
                        CurrReport.Skip;
                //-139
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Mostrar sólo almacén con balance"; SoloBalance)
                {
                ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        SoloBalance: Boolean;
        Consignation_Inventory_ListCaptionLbl: Label 'Consignation Inventory List';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        TotalCaptionLbl: Label 'Total';
}

