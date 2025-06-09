codeunit 76057 "PreSales-Ord. to Ord. (Yes/No)"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin

        Rec.TestField("Document Type", Rec."Document Type"::Order);
        if GuiAllowed then
            if not Confirm(Text000, false) then
                exit;

        ConfSant.Get;
        if ConfSant."Cod. Auditoria en Ventas Oblg." then
            Rec.TestField("Reason Code");

        if (Rec."Document Type" = Rec."Document Type"::Order) then
            if Rec.CheckCustomerCreated(true) then
                Rec.Get(Rec."Document Type"::Order, Rec."No.")
            else
                exit;

        SH.Copy(Rec);
        SalesPreorderToOrder.Run(Rec);
        SalesPreorderToOrder.GetSalesOrderHeader(SalesHeader2);
        Commit;

        Filtro := SH."No." + '*';
        SH.Reset;
        SH.SetRange("Document Type", Rec."Document Type");
        SH.SetFilter("No.", Filtro);
        TotalPed := SH.Count;

        Message(Text001, Rec."No.", TotalPed, SalesHeader2."No.");
    end;

    var
        Text000: Label 'Do you want to convert the pre order to an order?';
        Text001: Label 'Pre order %1 generated %2 orders and the las is %3';
        SalesHeader2: Record "Sales Header";
        SH: Record "Sales Header";
        SalesPreorderToOrder: Codeunit "Pre Sales-Order to Order";
        TotalPed: Integer;
        Filtro: Text[150];
        ConfSant: Record "Config. Empresa";
}

