tableextension 50144 tableextension50144 extends "Warehouse Journal Line"
{
    fields
    {
        modify("Location Code")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
            Description = '001';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 8)".

        modify("Item No.")
        {
            TableRelation = Item WHERE(Type = CONST(Inventory),
                                        Inactivo = CONST(false));
            Description = '001';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(76046; Barcode; Code[22])
        {
            Caption = 'Barcode';
            DataClassification = ToBeClassified;
            Description = 'DSPOS1.01';

            trigger OnLookup()
            var
                ICR: Record "Item Reference";
            begin
                ICR.Reset;
                TestField("Item No.");
                ICR.SetRange("Item No.", "Item No.");
                ICR.FindFirst;

                if PAGE.RunModal(PAGE::"Item References", ICR) = ACTION::LookupOK then begin
                    Barcode := ICR."Reference No.";
                end;
            end;

            trigger OnValidate()
            var
                ICR: Record "Item Reference";
            begin
                ICR.SetCurrentKey("Reference No.");
                ICR.SetRange("Reference No.", Barcode);
                ICR.FindFirst;
                Validate("Item No.", ICR."Item No.");
                if ICR."Unit of Measure" <> '' then
                    Validate("Unit of Measure Code", ICR."Unit of Measure");

                if ICR."Variant Code" <> '' then
                    Validate("Variant Code", ICR."Variant Code");
            end;
        }
    }
}

