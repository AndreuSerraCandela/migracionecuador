xmlport 76016 "Importa Clientes"
{
    Caption = 'Export Customers';

    schema
    {
        textelement(Cliente)
        {
            textelement(ItemDiscGroup)
            {
                textelement(ItemDiscGroup_Code)
                {
                }
                textelement(ItemDiscGroup_Desc)
                {
                }

                trigger OnBeforePassVariable()
                begin
                    rItemDiscGroup.Init;
                    rItemDiscGroup.Validate(Code, ItemDiscGroup_Code);
                    rItemDiscGroup.Validate(Description, ItemDiscGroup_Desc);
                    if not rItemDiscGroup.Insert then
                        rItemDiscGroup.Modify;
                end;

                trigger OnAfterAssignVariable()
                begin
                    rItemDiscGroup.Init;
                    rItemDiscGroup.Validate(Code, ItemDiscGroup_Code);
                    rItemDiscGroup.Validate(Description, ItemDiscGroup_Desc);
                    if not rItemDiscGroup.Insert then
                        rItemDiscGroup.Modify;
                end;
            }
            textelement(SalesLineDiscGrp_1)
            {
                textelement(SalesLineDiscGrp_1_Code)
                {
                }
                textelement(SalesLineDiscGrp_1_SalesCode)
                {
                }
                textelement(SalesLineDiscGrp_1_Currency)
                {
                }
                textelement(SalesLineDiscGrp_1_StartDate)
                {
                }
                textelement(SalesLineDiscGrp_1_LinDiscPorce)
                {
                }
                textelement(SalesLineDiscGrp_1_SalesType)
                {
                }
                textelement(SalesLineDiscGrp_1_MinimumQ)
                {
                }
                textelement(SalesLineDiscGrp_1_EndingDate)
                {
                }
                textelement(SalesLineDiscGrp_1_Type)
                {
                }
                textelement(SalesLineDiscGrp_1_UnitOfMeasure)
                {
                }
                textelement(SalesLineDiscGrp_1_VariantCode)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    rSalesLineDiscGroup.Init;
                    if Format(SalesLineDiscGrp_1_Type) = 'Item' then
                        rSalesLineDiscGroup.Validate("Asset Type", rSalesLineDiscGroup."Asset Type"::Item)
                    else
                        rSalesLineDiscGroup.Validate("Asset Type", rSalesLineDiscGroup."Asset Type"::"Item Discount Group");

                    rSalesLineDiscGroup.Validate("Price List Code", SalesLineDiscGrp_1_Code);

                    if Format(SalesLineDiscGrp_1_SalesType) = 'Customer' then
                        rSalesLineDiscGroup.Validate("Source Type", rSalesLineDiscGroup."Source Type"::Customer);
                    if Format(SalesLineDiscGrp_1_SalesType) = 'Customer Disc. Group' then
                        rSalesLineDiscGroup.Validate("Source Type", rSalesLineDiscGroup."Source Type"::"Customer Disc. Group");
                    if Format(SalesLineDiscGrp_1_SalesType) = 'All Customers' then
                        rSalesLineDiscGroup.Validate("Source Type", rSalesLineDiscGroup."Source Type"::"All Customers");
                    if Format(SalesLineDiscGrp_1_SalesType) = 'Campaign' then
                        rSalesLineDiscGroup.Validate("Source Type", rSalesLineDiscGroup."Source Type"::Campaign);
                    rSalesLineDiscGroup.Validate("Assign-to No.", SalesLineDiscGrp_1_SalesCode);

                    if SalesLineDiscGrp_1_StartDate <> '' then begin
                        Evaluate(Dia, (CopyStr(SalesLineDiscGrp_1_StartDate, 1, 2)));
                        Evaluate(mes, (CopyStr(SalesLineDiscGrp_1_StartDate, 4, 2)));
                        Evaluate(anio, (CopyStr(SalesLineDiscGrp_1_StartDate, 7, 2)));
                        rSalesLineDiscGroup.Validate("Starting Date", DMY2Date(Dia, mes, anio + 2000));
                    end;
                    rSalesLineDiscGroup.Validate("Currency Code", SalesLineDiscGrp_1_Currency);
                    if rSalesLineDiscGroup."Asset Type" = rSalesLineDiscGroup."Asset Type"::Item then
                        rSalesLineDiscGroup.Validate("Variant Code", SalesLineDiscGrp_1_VariantCode);
                    if rSalesLineDiscGroup."Asset Type" = rSalesLineDiscGroup."Asset Type"::Item then
                        rSalesLineDiscGroup.Validate("Unit of Measure Code", SalesLineDiscGrp_1_UnitOfMeasure);

                    if SalesLineDiscGrp_1_MinimumQ <> '' then
                        Evaluate(rSalesLineDiscGroup."Minimum Quantity", SalesLineDiscGrp_1_MinimumQ);
                    if SalesLineDiscGrp_1_LinDiscPorce <> '' then
                        Evaluate(rSalesLineDiscGroup."Line Discount %", SalesLineDiscGrp_1_LinDiscPorce);

                    if SalesLineDiscGrp_1_EndingDate <> '' then begin
                        Evaluate(Dia, (CopyStr(SalesLineDiscGrp_1_EndingDate, 1, 2)));
                        Evaluate(mes, (CopyStr(SalesLineDiscGrp_1_EndingDate, 4, 2)));
                        Evaluate(anio, (CopyStr(SalesLineDiscGrp_1_EndingDate, 7, 2)));
                        rSalesLineDiscGroup.Validate("Ending Date", DMY2Date(Dia, mes, anio + 2000));
                    end;

                    if not rSalesLineDiscGroup.Insert then
                        rSalesLineDiscGroup.Modify(true);
                end;
            }
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
                    textelement(CustDiscGroup)
                    {
                        textelement(CodDiscGrp)
                        {
                        }
                        textelement(DescrDiscGrp)
                        {
                        }

                        trigger OnAfterAssignVariable()
                        begin
                            rCustDiscGroup.Init;
                            rCustDiscGroup.Validate(Code, CodDiscGrp);
                            rCustDiscGroup.Validate(Description, DescrDiscGrp);
                            if not rCustDiscGroup.Insert then
                                rCustDiscGroup.Modify;
                        end;
                    }
                    textelement(CustDiscGrp)
                    {
                        textelement(CustDiscGrpCode)
                        {
                        }
                        textelement(CustDiscGrpDesc)
                        {

                            trigger OnAfterAssignVariable()
                            begin
                                rCustDiscGroup.Init;
                                rCustDiscGroup.Validate(Code, CustDiscGrpCode);
                                rCustDiscGroup.Validate(Description, CustDiscGrpDesc);
                                if not rCustDiscGroup.Insert then
                                    rCustDiscGroup.Modify;
                            end;
                        }
                    }
                }

                trigger OnAfterAssignVariable()
                begin
                    rCliente.Init;
                    rCliente.Validate("No.", NoCliente);
                    rCliente.Validate(Name, NombreCliente);
                    rCliente.Validate("Search Name", AliasCliente);
                    rCliente.Validate(Address, DireccionCliente);
                    rCliente.Validate(City, CiudadCliente);
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
                    rCliente.Validate("Post Code", PostCode);
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

    var
        rCliente: Record Customer;
        rSalesLineDiscGroup: Record "Price List Line"; //"Sales Line Discount";
        Dia: Integer;
        mes: Integer;
        anio: Integer;
        rCustDiscGroup: Record "Customer Discount Group";
        rItemDiscGroup: Record "Item Discount Group";
}

