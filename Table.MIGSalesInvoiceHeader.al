table 80112 "MIG Sales Invoice Header"
{
    Caption = 'Sales Invoice Header';

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
        field(55040; "Forma de Pago TPV"; Code[20])
        {
            Description = 'Ecuador';
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
        field(76018; "Factura comprimida"; Code[20])
        {
            Caption = 'Compressed invoice';
        }
        field(76015; "Importe ITBIS Incl."; Decimal)
        {
        }
        field(76026; "Venta a credito"; Boolean)
        {
        }
        field(76020; "Importe a liquidar"; Decimal)
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
        field(76025; "Anulada TPV"; Boolean)
        {
            Caption = 'Replicator Shipment No. Series';
        }
        field(76017; "No. nota credito TPV"; Code[20])
        {
            Caption = 'Nº nota credito TPV';
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

