table 80115 "MIG Sales Cr.Memo Line"
{
    Caption = 'Sales Cr.Memo Line';
    DrillDownPageID = "Posted Sales Credit Memo Lines";
    LookupPageID = "Posted Sales Credit Memo Lines";
    Permissions = TableData "Item Ledger Entry" = r,
                  TableData "Value Entry" = r;

    fields
    {
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Cr.Memo Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(76015; "Tipo Documento Replicador"; Option)
        {
            Caption = 'Replicator Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Pre Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Pre Order";
        }
        field(76026; "No. Pedido Replicador"; Code[20])
        {
            Caption = 'Replicator Order No';
        }
        field(76020; "Cantidad 1 Replicador"; Decimal)
        {
            Description = 'Para Replicador';
        }
        field(76022; "Cantidad 2 Replicador"; Decimal)
        {
            Description = 'Para Replicador';
        }
        field(76027; "Cantidad 3 Replicador"; Decimal)
        {
            Description = 'Para Replicador';
        }
        field(76025; "Cantidad 4 Replicador"; Decimal)
        {
            Description = 'Para Replicador';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        SalesDocLineComments: Record "Sales Comment Line";
    begin
    end;
}

