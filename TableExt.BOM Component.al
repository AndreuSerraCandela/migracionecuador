tableextension 50169 tableextension50169 extends "BOM Component"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(75000; Orden; Integer)
        {
            Caption = 'Orden';
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
    }
}

