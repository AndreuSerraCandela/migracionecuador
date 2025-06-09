xmlport 76295 "Importa Item Cross Ref"
{

    schema
    {
        textelement(Item_Cross_Ref)
        {
            textelement(ItemCrossRef)
            {
                textelement(ItemCrossRef_ItemNo)
                {
                }
                textelement(ItemCrossRef_VariantCode)
                {
                }
                textelement(ItemCrossRef_UnitOfMeasure)
                {
                }
                textelement(ItemCrossRef_CrossRefType)
                {
                }
                textelement(ItemCrossRef_CrossRefTypeNo)
                {
                }
                textelement(ItemCrossRef_CrossRefNo)
                {
                }
                textelement(ItemCrossRef_CrossRefDesc)
                {
                }
                textelement(ItemCrossRef_CrossRefDescBarCode)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, ItemCrossRef_ItemNo);
                    rItemCrossRef.Init;
                    rItemCrossRef.Validate("Item No.", ItemCrossRef_ItemNo);
                    rItemCrossRef.Validate("Variant Code", ItemCrossRef_VariantCode);
                    rItemCrossRef.Validate("Unit of Measure", ItemCrossRef_UnitOfMeasure);
                    rItemCrossRef.Validate("Reference Type", 3);
                    rItemCrossRef.Validate("Reference Type No.", ItemCrossRef_CrossRefTypeNo);
                    rItemCrossRef.Validate("Reference No.", ItemCrossRef_CrossRefNo);
                    rItemCrossRef.Validate(Description, ItemCrossRef_CrossRefDesc);
                    if not rItemCrossRef.Insert then
                        rItemCrossRef.Modify;
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
        rItemCrossRef: Record "Item Reference";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1#########';
}

