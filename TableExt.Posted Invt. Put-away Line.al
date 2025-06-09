tableextension 50159 tableextension50159 extends "Posted Invt. Put-away Line"
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
        RegisteredPutAwayCard: Page "Registered Put-away";
    begin
        RegisteredWhseActivHeader.SetRange("No.", "No.");
        RegisteredPutAwayCard.SetTableView(RegisteredWhseActivHeader);
        RegisteredPutAwayCard.RunModal;
    end;

    procedure ShowWhseEntries(RegisterDate: Date)
    var
        WhseEntry: Record "Warehouse Entry";
        WhseEntries: Page "Warehouse Entries";
    begin
        WhseEntry.SetCurrentKey("Reference No.", "Registering Date");
        WhseEntry.SetRange("Reference No.", "No.");
        WhseEntry.SetRange("Registering Date", RegisterDate);
        WhseEntry.SetRange("Reference Document", WhseEntry."Reference Document"::"Put-away");
        WhseEntries.SetTableView(WhseEntry);
        WhseEntries.RunModal;
    end;
}

