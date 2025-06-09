xmlport 76030 "Exporta Item Cross Ref"
{

    schema
    {
        textelement(Item_Cross_Ref)
        {
            tableelement(itemcrossref; "Item Reference")
            {
                XmlName = 'ItemCrossRef';
                fieldelement(ItemCrossRef_ItemNo; ItemCrossRef."Item No.")
                {
                }
                fieldelement(ItemCrossRef_VariantCode; ItemCrossRef."Variant Code")
                {
                }
                fieldelement(ItemCrossRef_UnitOfMeasure; ItemCrossRef."Unit of Measure")
                {
                }
                fieldelement(ItemCrossRef_CrossRefType; ItemCrossRef."Reference Type")
                {
                }
                fieldelement(ItemCrossRef_CrossRefTypeNo; ItemCrossRef."Reference Type No.")
                {
                }
                fieldelement(ItemCrossRef_CrossRefNo; ItemCrossRef."Reference No.")
                {
                }
                fieldelement(ItemCrossRef_CrossRefDesc; ItemCrossRef.Description)
                {
                }
                fieldelement(ItemCrossRef_CrossRefDescBarCode; ItemCrossRef.Description)
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

