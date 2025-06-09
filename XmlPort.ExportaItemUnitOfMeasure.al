xmlport 76017 "Exporta Item Unit Of Measure"
{

    schema
    {
        textelement(Item_Unit_Of_Measure)
        {
            tableelement(itemunitofmeasure; "Item Unit of Measure")
            {
                XmlName = 'ItemUnitOfMeasure';
                fieldelement(ItemUnitOfMeasure_ItemNo; ItemUnitOfMeasure."Item No.")
                {
                }
                fieldelement(ItemUnitOfMeasure_Code; ItemUnitOfMeasure.Code)
                {
                }
                fieldelement(ItemUnitOfMeasure_Qty; ItemUnitOfMeasure."Qty. per Unit of Measure")
                {
                }
                fieldelement(ItemUnitOfMeasure_Length; ItemUnitOfMeasure.Length)
                {
                }
                fieldelement(ItemUnitOfMeasure_Width; ItemUnitOfMeasure.Width)
                {
                }
                fieldelement(ItemUnitOfMeasure_Height; ItemUnitOfMeasure.Height)
                {
                }
                fieldelement(ItemUnitOfMeasure_Cubaje; ItemUnitOfMeasure.Cubage)
                {
                }
                fieldelement(ItemUnitOfMeasure_Weight; ItemUnitOfMeasure.Weight)
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

