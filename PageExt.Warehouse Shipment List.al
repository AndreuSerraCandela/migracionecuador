pageextension 50123 pageextension50123 extends "Warehouse Shipment List"
{
    layout
    {
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        addafter("Sorting Method")
        {
            field("No. Serie NCF Remision"; rec."No. Serie NCF Remision")
            {
                ApplicationArea = Basic, Suite, warehouse;
                Caption = 'Remission Series No.';

                trigger OnValidate()
                begin
                    /*//001
                    CALCFIELDS("Siguiente No. NCF Rem.");
                    ProximoNo := ("Siguiente No. NCF Rem.");
                    ProximoNo := INCSTR(ProximoNo);
                    //001*/

                end;
            }
        }
        addafter("Shipment Method Code")
        {
            field("No. Pedido"; rec."No. Pedido")
            {
            ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Registered P&ick Lines")
        {
            ToolTip = 'View the list of warehouse picks that have been made for the order.';
        }
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify("Re&open")
        {
            ToolTip = 'Reopen the document for additional warehouse activity.';
        }
    }

    var
        WhseDocPrint: Codeunit "Warehouse Document-Print";
        "***Santillana***": Integer;
        ProximoNo: Code[20];
        ProximoNo_Fact: Code[20];
        SH: Record "Sales Header";
        WSL: Record "Warehouse Shipment Line";
        WHSL: Record "Warehouse Shipment Line";
        TH: Record "Transfer Header";
        NoSeries: Record "No. Series";
        NoSeries2: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        Location: Record Location;
        WSH: Record "Warehouse Shipment Header";
}

