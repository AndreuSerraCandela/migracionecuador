page 56057 "Lista Pre-Pedidos Consignacion"
{
    ApplicationArea = all;

    Caption = 'Pre Consignment Order';
    CardPageID = "Pre-Transfer Order (Consig.)";
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Devolucion Consignacion" = FILTER(false),
                            "Pedido Consignacion" = CONST(true),
                            "Pre pedido" = FILTER(true));
    UsageCategory = Lists;

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
                field("Transfer-from Name 2"; rec."Transfer-from Name 2")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field(Status; rec.Status)
                {
                }
                field("Pedido Consignacion"; rec."Pedido Consignacion")
                {
                }
                field("Transfer-to Code"; rec."Transfer-to Code")
                {
                }
                field("Transfer-to Name"; rec."Transfer-to Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

