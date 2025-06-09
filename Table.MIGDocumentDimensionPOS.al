table 82516 "MIG Document Dimension POS"
{
    Caption = 'Document Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
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
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
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


    procedure UpdateGlobalDimCode(GlobalDimCodeNo: Integer; "Table ID": Integer; "Document Type": Option; "Document No.": Code[20]; "Line No.": Integer; NewDimValue: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ReminderHeader: Record "Reminder Header";
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        ServHeader: Record "Service Header";
        ServLine: Record "Service Line";
        ServItemLine: Record "Service Item Line";
        StdSalesLine: Record "Standard Sales Line";
        StdPurchLine: Record "Standard Purchase Line";
        StdServLine: Record "Standard Service Line";
    begin
    end;


    procedure UpdateLineDim()
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        ServItemLine: Record "Service Item Line";
        ServLine: Record "Service Line";
        Question: Text[250];
        UpdateDim: Boolean;
    begin
    end;


    procedure GetDimensions()
    begin
    end;


    procedure UpdateAllLineDim()
    begin
    end;

    local procedure InsertNew()
    begin
    end;


    procedure OnDeleteServRec()
    begin
    end;


    procedure UpdateServLineDim()
    begin
    end;


    procedure SetRecursiveValue(Recursive: Boolean)
    begin
    end;


    procedure UpdateAllServLineDim()
    begin
    end;
}

