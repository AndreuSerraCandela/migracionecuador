table 80037 "MIG Sales Line"
{
    Caption = 'Sales Line';
    DrillDownPageID = "Sales Lines";
    LookupPageID = "Sales Lines";
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            //OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Pre Order';
            //OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Pre Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(76046; "Anulada en TPV"; Boolean)
        {
            Caption = 'POS Void';
        }
        field(76029; "Precio anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Price';
        }
        field(76011; "Cantidad anulacion TPV"; Decimal)
        {
            Caption = 'Void POS Qty.';
        }
        field(76016; "Cantidad agregada"; Decimal)
        {
        }
        field(76018; "Cod. Vendedor"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
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
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        SalesCommentLine: Record "Sales Comment Line";
    begin
    end;

    trigger OnInsert()
    var
        SL: Record "Sales Line";
    begin
    end;
}

