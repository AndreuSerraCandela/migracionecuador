report 56036 "Ajusta Backorder"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {

            trigger OnAfterGetRecord()
            begin
                SL.Reset;
                SL.SetRange("Document Type", "Document Type");
                SL.SetRange("Document No.", "No.");
                if SL.FindSet then
                    repeat
                        if SalesInfoPaneMgt.CalcAvailability_BackOrder(SL) <= 0 then begin
                            WHSL.Reset;
                            WHSL.SetRange("Source No.", SL."Document No.");
                            WHSL.SetRange("Item No.", SL."No.");
                            if not WHSL.FindFirst then begin
                                Ajuste := 0;
                                Ajuste := SL.Quantity - SL."Quantity Shipped";
                                SL.Quantity := SL."Quantity Shipped";
                                SL.Validate(Quantity);
                                Cust.Get("Sales Header"."Sell-to Customer No.");
                                if Cust."Admite Pendientes en Pedidos" then
                                    SL."Cantidad pendiente BO" := Ajuste;
                                SL.Modify;
                            end;
                        end

                    until SL.Next = 0;
            end;
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

    labels
    {
    }

    var
        SL: Record "Sales Line";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
        Ajuste: Decimal;
        WHSL: Record "Warehouse Shipment Line";
        Cust: Record Customer;
}

