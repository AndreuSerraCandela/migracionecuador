tableextension 50142 tableextension50142 extends "Bin Content"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(76012; "Item Description"; Text[200])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

