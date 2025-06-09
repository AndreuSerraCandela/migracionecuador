xmlport 76025 "Importa SalesLineDisc"
{

    schema
    {
        textelement(Sales_Line_Disc)
        {
            textelement(SalesLineDisc)
            {
                textelement(SalesLineDisc_code)
                {
                }
                textelement(SalesLineDisc_SalesCode)
                {
                }
                textelement(SalesLineDisc_CurrCode)
                {
                }
                textelement(SalesLineDisc_StartDate)
                {
                }
                textelement(SalesLineDisc_LineDiscPorc)
                {
                }
                textelement(SalesLineDisc_SalesType)
                {
                }
                textelement(SalesLineDisc_MinimunQty)
                {
                }
                textelement(SalesLineDisc_EndingDate)
                {
                }
                textelement(SalesLineDisc_Type)
                {
                }
                textelement(SalesLineDisc_UnitOfMeasure)
                {
                }
                textelement(SalesLineDisc_VariantCode)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, SalesLineDisc_code);
                    rSalesLineDisc.Init;
                    if (Format(SalesLineDisc_Type) = 'Item') or (Format(SalesLineDisc_Type) = 'Producto') then
                        rSalesLineDisc.Validate("Asset Type", rSalesLineDisc."Asset Type"::Item)
                    else
                        rSalesLineDisc.Validate("Asset Type", rSalesLineDisc."Asset Type"::"Item Discount Group");

                    rSalesLineDisc.Validate("Price List Code", SalesLineDisc_code);


                    if (Format(SalesLineDisc_SalesType) = 'Customer') or (Format(SalesLineDisc_SalesType) = 'Cliente') then
                        rSalesLineDisc.Validate("Source Type", 0);
                    if (Format(SalesLineDisc_SalesType) = 'Customer Disc. Group') or (Format(SalesLineDisc_SalesType) = 'Grupo dto. cliente') then
                        rSalesLineDisc.Validate("Source Type", 1);
                    if (Format(SalesLineDisc_SalesType) = 'All Customers') or (Format(SalesLineDisc_SalesType) = 'Todos los Clientes') then
                        rSalesLineDisc.Validate("Source Type", 2);
                    if (Format(SalesLineDisc_SalesType) = 'Campaign') or (Format(SalesLineDisc_SalesType) = 'Campaña') then
                        rSalesLineDisc.Validate("Source Type", 3);
                    rSalesLineDisc.Validate("Assign-to No.", SalesLineDisc_SalesCode);

                    if SalesLineDisc_StartDate <> '' then begin
                        Evaluate(Dia, (CopyStr(SalesLineDisc_StartDate, 1, 2)));
                        Evaluate(mes, (CopyStr(SalesLineDisc_StartDate, 4, 2)));
                        Evaluate(anio, (CopyStr(SalesLineDisc_StartDate, 7, 2)));
                        rSalesLineDisc.Validate("Starting Date", DMY2Date(Dia, mes, anio + 2000));
                    end;
                    rSalesLineDisc.Validate("Currency Code", SalesLineDisc_CurrCode);
                    if rSalesLineDisc."Asset Type" = rSalesLineDisc."Asset Type"::Item then
                        rSalesLineDisc.Validate("Variant Code", SalesLineDisc_VariantCode);
                    if rSalesLineDisc."Asset Type" = rSalesLineDisc."Asset Type"::Item then
                        rSalesLineDisc.Validate("Unit of Measure Code", SalesLineDisc_UnitOfMeasure);

                    if SalesLineDisc_MinimunQty <> '' then
                        Evaluate(rSalesLineDisc."Minimum Quantity", SalesLineDisc_MinimunQty);
                    if SalesLineDisc_LineDiscPorc <> '' then
                        Evaluate(rSalesLineDisc."Line Discount %", SalesLineDisc_LineDiscPorc);

                    if SalesLineDisc_EndingDate <> '' then begin
                        Evaluate(Dia, (CopyStr(SalesLineDisc_EndingDate, 1, 2)));
                        Evaluate(mes, (CopyStr(SalesLineDisc_EndingDate, 4, 2)));
                        Evaluate(anio, (CopyStr(SalesLineDisc_EndingDate, 7, 2)));
                        rSalesLineDisc.Validate("Ending Date", DMY2Date(Dia, mes, anio + 2000));
                    end;

                    if not rSalesLineDisc.Insert then
                        rSalesLineDisc.Modify(true);
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
        rSalesLineDisc: Record "Price List Line"; //"Sales Line Discount";
        Dia: Integer;
        mes: Integer;
        anio: Integer;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1#########';
}

