xmlport 76011 "Exporta Clientes"
{
    Caption = 'Export Customers';

    schema
    {
        textelement(Cliente)
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
            tableelement(saleslinediscgrp_1; "Price List Line")
            {
                XmlName = 'SalesLineDiscGrp_1';
                SourceTableView = where("Amount Type" = const(Discount));
                fieldelement(SalesLineDiscGrp_1_Code; SalesLineDiscGrp_1."Price List Code")
                {
                }
                fieldelement(SalesLineDiscGrp_1_SalesCode; SalesLineDiscGrp_1."Assign-to No.")
                {
                }
                fieldelement(SalesLineDiscGrp_1_Currency; SalesLineDiscGrp_1."Currency Code")
                {
                }
                fieldelement(SalesLineDiscGrp_1_StartDate; SalesLineDiscGrp_1."Starting Date")
                {
                }
                fieldelement(SalesLineDiscGrp_1_LinDiscPorce; SalesLineDiscGrp_1."Line Discount %")
                {
                }
                fieldelement(SalesLineDiscGrp_1_SalesType; SalesLineDiscGrp_1."Source Type")
                {
                }
                fieldelement(SalesLineDiscGrp_1_MinimumQ; SalesLineDiscGrp_1."Minimum Quantity")
                {
                }
                fieldelement(SalesLineDiscGrp_1_EndingDate; SalesLineDiscGrp_1."Ending Date")
                {
                }
                fieldelement(SalesLineDiscGrp_1_Type; SalesLineDiscGrp_1."Asset Type")
                {
                }
                fieldelement(SalesLineDiscGrp_1_UnitOfMeasure; SalesLineDiscGrp_1."Unit of Measure Code")
                {
                }
                fieldelement(SalesLineDiscGrp_1_VariantCode; SalesLineDiscGrp_1."Variant Code")
                {
                }
            }
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
                    tableelement(custdiscgroup; "Customer Discount Group")
                    {
                        LinkFields = Code = FIELD("Customer Disc. Group");
                        LinkTable = Customer;
                        XmlName = 'CustDiscGroup';
                        fieldelement(CodDiscGrp; CustDiscGroup.Code)
                        {
                        }
                        fieldelement(DescrDiscGrp; CustDiscGroup.Description)
                        {
                        }
                    }
                    tableelement("Customer Discount Group"; "Customer Discount Group")
                    {
                        XmlName = 'CustDiscGrp';
                        fieldelement(CustDiscGrpCode; "Customer Discount Group".Code)
                        {
                        }
                        fieldelement(CustDiscGrpDesc; "Customer Discount Group".Description)
                        {
                        }
                    }
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

