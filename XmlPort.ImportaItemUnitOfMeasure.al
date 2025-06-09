xmlport 76021 "Importa Item Unit Of Measure"
{

    schema
    {
        textelement(Item_Unit_Of_Measure)
        {
            textelement(ItemUnitOfMeasure)
            {
                textelement(ItemUnitOfMeasure_ItemNo)
                {
                }
                textelement(ItemUnitOfMeasure_Code)
                {
                }
                textelement(ItemUnitOfMeasure_Qty)
                {
                }
                textelement(ItemUnitOfMeasure_Length)
                {
                }
                textelement(ItemUnitOfMeasure_Width)
                {
                }
                textelement(ItemUnitOfMeasure_Height)
                {
                }
                textelement(ItemUnitOfMeasure_Cubaje)
                {
                }
                textelement(ItemUnitOfMeasure_Weight)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, ItemUnitOfMeasure_ItemNo);
                    rItemUnitOfMeasure.Init;
                    rItemUnitOfMeasure."Item No." := ItemUnitOfMeasure_ItemNo;
                    rItemUnitOfMeasure.Code := ItemUnitOfMeasure_Code;
                    Evaluate(rItemUnitOfMeasure."Qty. per Unit of Measure", ItemUnitOfMeasure_Qty);
                    Evaluate(rItemUnitOfMeasure.Length, ItemUnitOfMeasure_Length);
                    Evaluate(rItemUnitOfMeasure.Width, ItemUnitOfMeasure_Width);
                    Evaluate(rItemUnitOfMeasure.Height, ItemUnitOfMeasure_Height);
                    Evaluate(rItemUnitOfMeasure.Cubage, ItemUnitOfMeasure_Cubaje);
                    Evaluate(rItemUnitOfMeasure.Weight, ItemUnitOfMeasure_Weight);
                    if not rItemUnitOfMeasure.Insert then
                        rItemUnitOfMeasure.Modify;
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
        rItemUnitOfMeasure: Record "Item Unit of Measure";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1#########';
}

