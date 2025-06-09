xmlport 76020 "Exporta Productos"
{

    schema
    {
        textelement(Productos)
        {
            tableelement(Item; Item)
            {
                XmlName = 'Item';
                fieldelement(Item_No; Item."No.")
                {
                }
                fieldelement(Item_No2; Item."No. 2")
                {
                }
                fieldelement(Item_Desc; Item.Description)
                {
                }
                fieldelement(Item_SearchDesc; Item."Search Description")
                {
                }
                fieldelement(Item_Desc2; Item."Description 2")
                {
                }
                fieldelement(Item_BaseUnitOfMeasure; Item."Base Unit of Measure")
                {
                }
                fieldelement(Item_InvPostGroup; Item."Inventory Posting Group")
                {
                }
                fieldelement(Item_ItemDiscGroup; Item."Item Disc. Group")
                {
                }
                fieldelement(Item_AllowInvDisc; Item."Allow Invoice Disc.")
                {
                }
                fieldelement(Item_UnitPrice; Item."Unit Price")
                {
                }
                fieldelement(Item_Blocked; Item.Blocked)
                {
                }
                fieldelement(Item_VatBussPostGrpPrice; Item."VAT Bus. Posting Gr. (Price)")
                {
                }
                fieldelement(Item_GenProdPostGrp; Item."Gen. Prod. Posting Group")
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

