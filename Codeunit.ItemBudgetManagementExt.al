codeunit 55049 "Item Budget Management Ext"
{
    Subtype = Normal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Budget Management", 'OnFindRecOnBeforeItemFind', '', false, false)]
    local procedure OnFindRecOnBeforeItemFindHandler(var Item: Record Item)
    begin
        Item.SetRange("Inactivo", false); 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Budget Management", 'OnNextRecOnBeforeItemFind', '', false, false)]
    local procedure OnNextRecOnBeforeItemFindHandler(var Item: Record Item)
    begin
        Item.SetRange("Inactivo", false);
    end;
}
