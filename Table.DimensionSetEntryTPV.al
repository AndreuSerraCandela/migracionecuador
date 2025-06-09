table 76009 "Dimension Set Entry TPV"
{
    Caption = 'Dimension Set Entry';
    DrillDownPageID = "Dimension Set Entries";
    LookupPageID = "Dimension Set Entries";
    Permissions = TableData "Dimension Set Entry" = ri,
                  TableData "Dimension Set Tree Node" = rim;

    fields
    {
        field(1; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Description = 'DsPOS Standar';
        }
        field(2; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            Description = 'DsPOS Standar';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(3; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            Description = 'DsPOS Standar';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code" = FIELD ("Dimension Code"));
        }
        field(4; "Dimension Value ID"; Integer)
        {
            Caption = 'Dimension Value ID';
            Description = 'DsPOS Standar';
        }
        field(5; "Dimension Name"; Text[30])
        {
            CalcFormula = Lookup (Dimension.Name WHERE (Code = FIELD ("Dimension Code")));
            Caption = 'Dimension Name';
            Description = 'DsPOS Standar';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Dimension Value Name"; Text[50])
        {
            CalcFormula = Lookup ("Dimension Value".Name WHERE ("Dimension Code" = FIELD ("Dimension Code"),
                                                               Code = FIELD ("Dimension Value Code")));
            Caption = 'Dimension Value Name';
            Description = 'DsPOS Standar';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Dimension Set ID", "Dimension Code")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Value ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin
        Error(Error001);
    end;

    var
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        Error001: Label 'No se puede renombrar';
}

