tableextension 50033 tableextension50033 extends "Source Code"
{
    fields
    {
        field(76228; "Source Counter POS"; Integer)
        {
            Caption = 'Source Counter POS';
            DataClassification = ToBeClassified;
            Description = 'DsPOS Standard';
        }
    }


    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
    /*
    //+
    "Source Counter POS" += 1;
    //-
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    //+
    "Source Counter POS" += 1;
    //-
    */
    //end;
}

