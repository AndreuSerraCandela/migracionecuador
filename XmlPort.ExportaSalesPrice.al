xmlport 76018 "Exporta Sales Price"
{

    schema
    {
        textelement(SalesPrice)
        {
            tableelement("Sales Price"; "Price List Line") //"Sales Price")
            {
                XmlName = 'SalesPrice';
                SourceTableView = where("Amount Type" = const(Price));
                fieldelement(ItemNo; "Sales Price"."Product No.")
                {
                }
                fieldelement(SalesCode; "Sales Price"."Assign-to No.")
                {
                }
                fieldelement(CurrencyCode; "Sales Price"."Currency Code")
                {
                }
                fieldelement(StartingDate; "Sales Price"."Starting Date")
                {
                }
                fieldelement(UnitPrice; "Sales Price"."Unit Price")
                {
                }
                fieldelement(PriceIncVat; "Sales Price"."Price Includes VAT")
                {
                }
                fieldelement(AllowInvDisc; "Sales Price"."Allow Invoice Disc.")
                {
                }
                fieldelement(VatBusPostingGrp; "Sales Price"."VAT Bus. Posting Gr. (Price)")
                {
                }
                fieldelement(SalesType; "Sales Price"."Source Type")
                {
                }
                fieldelement(MinimunQty; "Sales Price"."Minimum Quantity")
                {
                }
                fieldelement(EndingDate; "Sales Price"."Ending Date")
                {
                }
                fieldelement(UnitOfMeasure; "Sales Price"."Unit of Measure Code")
                {
                }
                fieldelement(VariantCode; "Sales Price"."Variant Code")
                {
                }
                fieldelement(AllowLineDisc; "Sales Price"."Allow Line Disc.")
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

