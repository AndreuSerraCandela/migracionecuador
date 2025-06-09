table 76091 "Default Dimension Temp"
{
    Caption = 'Default Dimension';

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;

            trigger OnLookup()
            var
            /*                 TempObject: Record "Object" temporary; */
            begin
            end;

            trigger OnValidate()
            var
            /*                TempObject: Record "Object" temporary; */
            begin
            end;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
        }
        field(4; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
        }
        field(5; "Value Posting"; Option)
        {
            Caption = 'Value Posting';
            OptionCaption = ' ,Code Mandatory,Same Code,No Code';
            OptionMembers = " ","Code Mandatory","Same Code","No Code";
        }
        field(6; "Table Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Table),
                                                                           "Object ID" = FIELD("Table ID")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Multi Selection Action"; Option)
        {
            Caption = 'Multi Selection Action';
            OptionCaption = ' ,Change,Delete';
            OptionMembers = " ",Change,Delete;
        }
    }

    keys
    {
        key(Key1; "Table ID", "No.", "Dimension Code")
        {
            Clustered = true;
        }
        key(Key2; "Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'You can''t rename a %1.';
}

