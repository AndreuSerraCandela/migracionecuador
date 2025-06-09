tableextension 50160 tableextension50160 extends "Posted Invt. Pick Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 19)".

    }
    procedure ShowRegisteredActivityDoc()
    var
        RegisteredWhseActivHeader: Record "Registered Whse. Activity Hdr.";
        RegisteredPickCard: Page "Registered Pick";
    begin
        RegisteredWhseActivHeader.SetRange("No.", "No.");
        RegisteredPickCard.SetTableView(RegisteredWhseActivHeader);
        RegisteredPickCard.RunModal;
    end;

    procedure ShowWhseEntries(RegisterDate: Date)
    var
        WhseEntry: Record "Warehouse Entry";
        WhseEntries: Page "Warehouse Entries";
    begin
        WhseEntry.SetCurrentKey("Reference No.", "Registering Date");
        WhseEntry.SetRange("Reference No.", "No.");
        WhseEntry.SetRange("Registering Date", RegisterDate);
        WhseEntry.SetRange("Reference Document", WhseEntry."Reference Document"::Pick);
        WhseEntries.SetTableView(WhseEntry);
        WhseEntries.RunModal;
    end;
}

