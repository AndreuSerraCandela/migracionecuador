xmlport 76026 "Importa Clientes_1"
{
    Caption = 'Export Customers';

    schema
    {
        textelement(Cliente)
        {
            textelement(Customer)
            {
                textelement(NoCliente)
                {
                }
                textelement(NombreCliente)
                {
                }
                textelement(AliasCliente)
                {
                }
                textelement(DireccionCliente)
                {
                }
                textelement(CiudadCliente)
                {
                }
                textelement(TelCliente)
                {
                }
                textelement(LimiteDeCredito)
                {
                }
                textelement(CustPostingGroup)
                {
                }
                textelement(CurrencyCode)
                {
                }
                textelement(CustPriceGroup)
                {
                }
                textelement(PaymentTermsCode)
                {
                }
                textelement(SalesPerson)
                {
                }
                textelement(CustDicGroup)
                {
                }
                textelement(LocCode)
                {
                }
                textelement(FaxNo)
                {
                }
                textelement(VatRegNo)
                {
                }
                textelement(GenBusPostGrp)
                {
                }
                textelement(PostCode)
                {
                }
                textelement(eMail)
                {
                }
                textelement(VatBusPostGrp)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, NoCliente);
                    rCliente.Init;
                    rCliente.Validate("No.", NoCliente);
                    rCliente.Validate(Name, NombreCliente);
                    rCliente.Validate("Search Name", AliasCliente);
                    rCliente.Address := DireccionCliente;
                    rCliente.City := CiudadCliente;
                    rCliente.Validate("Phone No.", TelCliente);
                    Evaluate(rCliente."Credit Limit (LCY)", LimiteDeCredito);
                    rCliente.Validate("Customer Posting Group", CustPostingGroup);
                    rCliente.Validate("Currency Code", CurrencyCode);
                    rCliente.Validate("Customer Price Group", CustPriceGroup);
                    rCliente.Validate("Payment Terms Code", PaymentTermsCode);
                    rCliente.Validate("Salesperson Code", SalesPerson);
                    rCliente.Validate("Customer Disc. Group", CustDicGroup);
                    rCliente.Validate("Location Code", LocCode);
                    rCliente.Validate("Fax No.", FaxNo);
                    rCliente."VAT Registration No." := VatRegNo;
                    rCliente.Validate("Gen. Bus. Posting Group", GenBusPostGrp);
                    rCliente."Post Code" := PostCode;
                    rCliente.Validate("E-Mail", eMail);
                    rCliente.Validate("VAT Bus. Posting Group", VatBusPostGrp);
                    if not rCliente.Insert then
                        rCliente.Modify;
                end;
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

    trigger OnPostXmlPort()
    begin
        Window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        Window.Open(txt001);
    end;

    var
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1#########';
        rCliente: Record Customer;
}

