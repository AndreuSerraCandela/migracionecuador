tableextension 50035 tableextension50035 extends "Requisition Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item),
                                     "Worksheet Template Name" = FILTER(<> ''),
                                     "Journal Batch Name" = FILTER(<> '')) Item WHERE(Type = CONST(Inventory),
                                                                                    Inactivo = CONST(false))
            ELSE
            IF (Type = CONST(Item),
                                                                                             "Worksheet Template Name" = CONST(''),
                                                                                             "Journal Batch Name" = CONST('')) Item;
            Description = '001';
        }

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 7)".

        modify("Vendor No.")
        {
            TableRelation = Vendor WHERE(Inactivo = CONST(false));
            Description = '001';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            Inactivo = CONST(false));
            Description = '001';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Expected Operation Cost Amt.")
        {
            Caption = 'Expected Operation Cost Amt.';
        }
        modify("Expected Component Cost Amt.")
        {
            Caption = 'Expected Component Cost Amt.';
        }
    }
}

