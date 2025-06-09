table 80114 "MIG Sales Cr.Memo Header"
{
    Caption = 'Sales Cr.Memo Header';
    LookupPageID = "Posted Sales Credit Memos";

    fields
    {
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(53008; Tienda; Code[20])
        {
            TableRelation = "Bancos tienda";
        }
        field(76046; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
        }
        field(76029; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
        }
        field(76011; "Tipo pedido"; Option)
        {
            Caption = 'Order type';
            OptionCaption = ' ,TPV,Mobile';
            OptionMembers = " ",TPV,Movilidad;
        }
        field(76016; TPV; Code[20])
        {
        }
        field(76022; "Tipo Documento Replicador"; Option)
        {
            Caption = 'Document Type';
            Description = 'Utilizado para Replicar del historico de facturas a borrador';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(76027; "No. Serie Envio Replicador"; Code[10])
        {
            Caption = 'Replicator Shipment No. Series';
            Description = 'Utilizado para Replicar del historico de facturas a borrador';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.")
        {
        }
    }
}

