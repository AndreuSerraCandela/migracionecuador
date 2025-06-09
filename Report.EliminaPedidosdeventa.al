report 56033 "Elimina Pedidos de venta"
{
    Caption = 'Delete Sales orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING ("Document Type", "No.") WHERE ("Document Type" = CONST (Order), "Pre pedido" = CONST (false));
            RequestFilterFields = "No.", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                SL.Reset;
                SL.SetRange("Document Type", "Document Type");
                SL.SetRange("Document No.", "No.");
                SL.SetFilter("Qty. Shipped Not Invoiced", '<>%1', 0);
                if SL.FindFirst then
                    CurrReport.Skip;

                /*
                SL.RESET;
                SL.SETRANGE("Document Type","Document Type");
                SL.SETRANGE("Document No.","No.");
                SL.SETFILTER(SL."Cantidad pendiente BO",'<>%1',0);
                IF SL.FINDFIRST THEN
                   CurrReport.SKIP;
                */

                WhseShptLine.Reset;
                WhseShptLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WhseShptLine.SetRange("Source Type", DATABASE::"Sales Line");
                WhseShptLine.SetRange("Source Subtype", 1);
                WhseShptLine.SetRange("Source No.", "No.");
                if not WhseShptLine.FindFirst then begin
                    WhseActivLine.Reset;
                    WhseActivLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.");
                    WhseActivLine.SetRange("Source Type", DATABASE::"Sales Line");
                    WhseActivLine.SetRange("Source Subtype", 1);
                    WhseActivLine.SetRange("Source No.", "No.");
                    if not WhseActivLine.FindFirst then begin
                        if Delete(true) then
                            CounterOK += 1;
                    end;
                end;

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002, CounterOK, CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                CounterTotal := Count;
                Window.Open(Text001);
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

    trigger OnPreReport()
    begin
        if "Sales Header".GetFilter("Posting Date") = '' then
            Error(Error001);
    end;

    var
        Text001: Label 'Deleting orders  #1########## @2@@@@@@@@@@@@@';
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseActivLine: Record "Warehouse Activity Line";
        SL: Record "Sales Line";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text002: Label '%1 orders out of a total of %2 have now been deleted.';
        CounterOK: Integer;
        Error001: Label 'Date Filter must be specified';
}

