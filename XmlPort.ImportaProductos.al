xmlport 76022 "Importa Productos"
{

    schema
    {
        textelement(Productos)
        {
            textelement(Item)
            {
                textelement(Item_No)
                {
                }
                textelement(Item_No2)
                {
                }
                textelement(Item_Desc)
                {
                }
                textelement(Item_SearchDesc)
                {
                }
                textelement(Item_Desc2)
                {
                }
                textelement(Item_BaseUnitOfMeasure)
                {
                }
                textelement(Item_InvPostGroup)
                {
                }
                textelement(Item_ItemDiscGroup)
                {
                }
                textelement(Item_AllowInvDisc)
                {
                }
                textelement(Item_UnitPrice)
                {
                }
                textelement(Item_Blocked)
                {
                }
                textelement(Item_VatBussPostGrpPrice)
                {
                }
                textelement(Item_GenProdPostGrp)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, Item_No);

                    if rItem1.Get(Item_No) then
                        Existe := true
                    else
                        Existe := false;


                    rItem.Init;
                    rItem.Validate("No.", Item_No);
                    rItem.Validate("No. 2", Item_No2);
                    rItem.Validate(Description, Item_Desc);
                    rItem.Validate("Search Description", Item_SearchDesc);
                    rItem.Validate("Description 2", Item_Desc2);
                    //IF NOT Existe THEN
                    //IF Existe THEN
                    //  rItem.VALIDATE("Base Unit of Measure",Item_BaseUnitOfMeasure);
                    rItem."Base Unit of Measure" := Item_BaseUnitOfMeasure;
                    rItem."Sales Unit of Measure" := Item_BaseUnitOfMeasure;
                    rItem."Purch. Unit of Measure" := Item_BaseUnitOfMeasure;


                    rItem.Validate("Inventory Posting Group", Item_InvPostGroup);
                    rItem.Validate("Item Disc. Group", Item_ItemDiscGroup);
                    Evaluate(rItem."Unit Price", Item_UnitPrice);
                    if Item_Blocked = 'TRUE' then
                        rItem.Validate(Blocked, true)
                    else
                        rItem.Validate(Blocked, false);
                    rItem.Validate("VAT Bus. Posting Gr. (Price)", Item_VatBussPostGrpPrice);
                    rItem.Validate("Gen. Prod. Posting Group", Item_GenProdPostGrp);
                    if not rItem.Insert then
                        rItem.Modify;
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
        rItem: Record Item;
        rItem1: Record Item;
        Existe: Boolean;
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1#########';
}

