xmlport 76227 "Exporta Discounts Groups"
{

    schema
    {
        textelement(Discounts_Group)
        {
            tableelement(itemdiscgroup; "Item Discount Group")
            {
                XmlName = 'ItemDiscGroup';
                fieldelement(ItemDiscGroup_Code; ItemDiscGroup.Code)
                {
                }
                fieldelement(ItemDiscGroup_Desc; ItemDiscGroup.Description)
                {
                }
            }
            tableelement("Customer Discount Group"; "Customer Discount Group")
            {
                XmlName = 'CustDiscGrp';
                fieldelement(CustDiscGrp_Code; "Customer Discount Group".Code)
                {
                }
                fieldelement(CustDiscGrp_Desc; "Customer Discount Group".Description)
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

