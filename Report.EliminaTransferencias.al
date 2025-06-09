report 56034 "Elimina Transferencias"
{
    Caption = 'Delete Sales orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING ("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                TL.Reset;
                TL.SetRange("Document No.", "No.");
                TL.SetFilter("Outstanding Quantity", '<>%1', 0);
                if TL.FindFirst then
                    CurrReport.Skip;

                /*
                TL.RESET;
                TL.SETRANGE("Document No.","No.");
                TL.SETFILTER(TL."Cantidad pendiente BO",'<>%1',0);
                IF TL.FINDFIRST THEN
                   CurrReport.SKIP;
                */

                WhseShptLine.Reset;
                WhseShptLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WhseShptLine.SetRange("Source Type", DATABASE::"Transfer Line");
                WhseShptLine.SetRange("Source Subtype", 0);
                WhseShptLine.SetRange("Source No.", "No.");
                if not WhseShptLine.FindFirst then begin
                    WhseActivLine.Reset;
                    WhseActivLine.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.", "Source Subline No.");
                    WhseActivLine.SetRange("Source Type", DATABASE::"Transfer Line");
                    WhseActivLine.SetRange("Source Subtype", 0);
                    WhseActivLine.SetRange("Source No.", "No.");
                    if not WhseActivLine.FindFirst then begin
                        ReleaseTransferDoc.Reopen("Transfer Header");
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
        if "Transfer Header".GetFilter("Posting Date") = '' then
            Error(Error001);
    end;

    var
        Text001: Label 'Deleting orders  #1########## @2@@@@@@@@@@@@@';
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseActivLine: Record "Warehouse Activity Line";
        TL: Record "Transfer Line";
        ReleaseTransferDoc: Codeunit "Release Transfer Document";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Text002: Label '%1 orders out of a total of %2 have now been deleted.';
        CounterOK: Integer;
        Error001: Label 'Date Filter must be specified';
}

