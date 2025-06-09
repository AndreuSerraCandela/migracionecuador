page 56048 "Lista Dev. Pedidos Consig."
{
    ApplicationArea = all;

    Caption = 'Return Orders Consignment List';
    CardPageID = "Pedido Devolucion Consignacion";
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Header";
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Devolucion Consignacion" = FILTER(true),
                            "Pedido Consignacion" = CONST(true));
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
            }
        }
    }

    actions
    {
    }
}

