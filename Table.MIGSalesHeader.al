table 80036 "MIG Sales Header"
{
    Caption = 'Sales Header';
    LookupPageID = "Sales List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(53000; "ID Cajero"; Code[20])
        {
            Caption = 'Cashier ID';
        }
        field(53001; "Hora creacion"; Time)
        {
            Caption = 'Creation time';
        }
        field(53002; "Tipo pedido"; Option)
        {
            Caption = 'Order type';
            OptionCaption = ' ,TPV,Mobile';
            OptionMembers = " ",TPV,Movilidad;
        }
        field(53003; TPV; Code[20])
        {
        }
        field(53004; "Factura comprimida"; Code[20])
        {
            Caption = 'Compressed invoice';
        }
        field(53006; "Venta a credito"; Boolean)
        {
        }
        field(53007; "Importe a liquidar"; Decimal)
        {
        }
        field(53008; Tienda; Code[20])
        {
            TableRelation = "Bancos tienda";
        }
        field(55040; "Forma de pago TPV"; Code[20])
        {
        }
        field(99999; "Pedidos TPV sin lineas"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
    end;
}

