codeunit 76007 "Pre Tr-Order to Tr-Order (Y/N)"
{
    TableNo = "Transfer Header";

    trigger OnRun()
    begin
        if GuiAllowed then
            if not Confirm(Text000, false) then
                exit;

        TH.Copy(Rec);
        TransPreorderToOrder.Run(Rec);
        TransPreorderToOrder.GetSalesOrderHeader(TransferHeader2);
        Commit;

        Filtro := TH."No." + '*';
        TH.Reset;
        TH.SetFilter("No.", Filtro);
        TotalPed := TH.Count;

        Message(Text001, Rec."No.", TotalPed, TransferHeader2."No.");
    end;

    var
        Text000: Label 'Do you want to convert the pre order to an order?';
        Text001: Label 'Pre order %1 generated %2 orders and the las is %3';
        TH: Record "Transfer Header";
        TransPreorderToOrder: Codeunit "Pre Tr-Order to Tr-Order";
        TransferHeader2: Record "Transfer Header";
        TotalPed: Integer;
        Filtro: Text[150];
}

