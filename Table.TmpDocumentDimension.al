table 80015 "Tmp Document Dimension"
{
    Caption = 'Document Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE ("Object Type" = CONST (Table));
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(6; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code"));
        }
    }

    keys
    {
        key(Key1; "Table ID", "Document Type", "Document No.", "Line No.", "Dimension Code")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Code", "Dimension Value Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'You can not rename a %1.';
        Text001: Label 'You have changed a dimension.\\';
        Text002: Label 'Do you want to update the lines?';
        Text003: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        UpdateLine: Option NotSet,Update,DoNotUpdate;
        Text004: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to the general ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text005: Label 'Canceled.';
        Text006: Label 'You may have changed a dimension. Some lines are already shipped. When you post the line with the changed dimension to the general ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to update the lines?';
}

