tableextension 50120 tableextension50120 extends "Warehouse Activity Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 18)".


        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 19)".


        //Unsupported feature: Code Modification on ""Qty. to Handle"(Field 26).OnValidate".

        //trigger  to Handle"(Field 26)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IsHandled := false;
        OnBeforeValidateQtyToHandle(Rec,IsHandled);
        if not IsHandled then
        #4..34
           ("Action Type" <> "Action Type"::Place) and ("Lot No." <> '') and (CurrFieldNo <> 0)
        then
          CheckReservedItemTrkg(1,"Lot No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..37

        if ("Qty. to Handle" = 0) and RegisteredWhseActLineIsEmpty then
          UpdateReservation(Rec,false)
        */
        //end;
    }
    keys
    {
        key(Key20; "Source Document", "Source No.")
        {
        }
    }

    var
        Text016: Label 'Reserved item %1 is not on inventory.';
}

