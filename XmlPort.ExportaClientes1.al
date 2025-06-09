xmlport 76015 "Exporta Clientes_1"
{
    Caption = 'Export Customers';

    schema
    {
        textelement(Cliente)
        {
            tableelement(Customer; Customer)
            {
                XmlName = 'Customer';
                fieldelement(NoCliente; Customer."No.")
                {
                }
                fieldelement(NombreCliente; Customer.Name)
                {
                }
                fieldelement(AliasCliente; Customer."Search Name")
                {
                }
                fieldelement(DireccionCliente; Customer.Address)
                {
                }
                fieldelement(CiudadCliente; Customer.City)
                {
                }
                fieldelement(TelCliente; Customer."Phone No.")
                {
                }
                fieldelement(LimiteDeCredito; Customer."Credit Limit (LCY)")
                {
                }
                fieldelement(CustPostingGroup; Customer."Customer Posting Group")
                {
                }
                fieldelement(CurrencyCode; Customer."Currency Code")
                {
                }
                fieldelement(CustPriceGroup; Customer."Customer Price Group")
                {
                }
                fieldelement(PaymentTermsCode; Customer."Payment Terms Code")
                {
                }
                fieldelement(SalesPerson; Customer."Salesperson Code")
                {
                }
                fieldelement(CustDicGroup; Customer."Customer Disc. Group")
                {
                }
                fieldelement(LocCode; Customer."Location Code")
                {
                }
                fieldelement(FaxNo; Customer."Fax No.")
                {
                }
                fieldelement(VatRegNo; Customer."VAT Registration No.")
                {
                }
                fieldelement(GenBusPostGrp; Customer."Gen. Bus. Posting Group")
                {
                }
                fieldelement(PostCode; Customer."Post Code")
                {
                }
                fieldelement(eMail; Customer."E-Mail")
                {
                }
                fieldelement(VatBusPostGrp; Customer."VAT Bus. Posting Group")
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

    var
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1########## @2@@@@@@@@@@@@@';
}

