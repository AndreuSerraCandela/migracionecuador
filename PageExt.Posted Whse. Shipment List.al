pageextension 50124 pageextension50124 extends "Posted Whse. Shipment List"
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
        addafter("Assigned User ID")
        {
            field("No. Pedido"; rec."No. Pedido")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

