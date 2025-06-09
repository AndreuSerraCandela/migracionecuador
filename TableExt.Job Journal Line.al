tableextension 50029 tableextension50029 extends "Job Journal Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("Job Planning Line No.")
        {
            Caption = 'Job Planning Line No.';
        }

        //Unsupported feature: Code Insertion on ""Unit of Measure Code"(Field 18)".

        //trigger OnLookup(var Text: Text): Boolean
        //var
        //ItemUnitOfMeasure: Record "Item Unit of Measure";
        //ResourceUnitOfMeasure: Record "Resource Unit of Measure";
        //UnitOfMeasure: Record "Unit of Measure";
        //Resource: Record Resource;
        //"Filter": Text;
        //begin
        /*
        */
        //end;
    }
}

