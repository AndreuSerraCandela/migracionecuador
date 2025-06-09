xmlport 76027 "Exporta SalesLineDisc"
{

    schema
    {
        textelement(Sales_Line_Disc)
        {
            tableelement(saleslinedisc; "Price List Line") //"Sales Line Discount")
            {
                XmlName = 'SalesLineDisc';
                SourceTableView = where("Amount Type" = const(Discount));
                fieldelement(SalesLineDisc_code; SalesLineDisc."Price List Code")
                {
                }
                fieldelement(SalesLineDisc_SalesCode; SalesLineDisc."Assign-to No.")
                {
                }
                fieldelement(SalesLineDisc_CurrCode; SalesLineDisc."Currency Code")
                {
                }
                fieldelement(SalesLineDisc_StartDate; SalesLineDisc."Starting Date")
                {
                }
                fieldelement(SalesLineDisc_LineDiscPorc; SalesLineDisc."Line Discount %")
                {
                }
                fieldelement(SalesLineDisc_SalesType; SalesLineDisc."Source Type")
                {
                }
                fieldelement(SalesLineDisc_MinimunQty; SalesLineDisc."Minimum Quantity")
                {
                }
                fieldelement(SalesLineDisc_EndingDate; SalesLineDisc."Ending Date")
                {
                }
                fieldelement(SalesLineDisc_Type; SalesLineDisc."Asset Type")
                {
                }
                fieldelement(SalesLineDisc_UnitOfMeasure; SalesLineDisc."Unit of Measure Code")
                {
                }
                fieldelement(SalesLineDisc_VariantCode; SalesLineDisc."Variant Code")
                {
                }
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
}

