tableextension 50145 tableextension50145 extends "Warehouse Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 8)".

        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(56000; "Existe en T32"; Boolean)
        {
            CalcFormula = Exist ("Item Ledger Entry" WHERE ("Document No." = FIELD ("Reference No."),
                                                           "Item No." = FIELD ("Item No."),
                                                           "Location Code" = FIELD ("Location Code")));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key10; "Item No.", "Bin Code", "Location Code", "Variant Code", "Registering Date")
        {
            SumIndexFields = "Qty. (Base)";
        }
    }
}

