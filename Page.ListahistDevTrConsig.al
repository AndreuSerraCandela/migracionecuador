page 56051 "Lista hist. Dev. Tr. Consig."
{
    ApplicationArea = all;
    CardPageID = "Hist. Dev. Transf. (Consig.)";
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Receipt Header";
    SourceTableView = SORTING ("No.")
                      ORDER(Ascending)
                      WHERE ("Pedido Consignacion" = FILTER (true),
                            "Devolucion Consignacion" = FILTER (true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("Transfer-from Code"; rec."Transfer-from Code")
                {
                }
                field("Transfer-from Name"; rec."Transfer-from Name")
                {
                }
                field("Transfer-to Code"; rec."Transfer-to Code")
                {
                }
                field("Transfer-to Name"; rec."Transfer-to Name")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Transfer Order No."; rec."Transfer Order No.")
                {
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                }
                field("Receipt Date"; rec."Receipt Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

