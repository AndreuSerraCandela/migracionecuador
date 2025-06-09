tableextension 50154 tableextension50154 extends "Whse. Worksheet Line"
{
    fields
    {
        modify("Location Code")
        {
            TableRelation = Location WHERE(Inactivo = CONST(false));
            Description = '001';
        }
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

        //Unsupported feature: Property Modification (Data type) on "Description(Field 32)".


        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 33)".

    }

    //Unsupported feature: Code Modification on "SortWhseWkshLines(PROCEDURE 3)".

    //procedure SortWhseWkshLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WhseWkshLine.SetRange("Worksheet Template Name",WhseWkshTemplate);
    WhseWkshLine.SetRange(Name,WhseWkshName);
    WhseWkshLine.SetRange("Location Code",LocationCode);
    #4..12
          GetLocation(LocationCode);
          if Location."Bin Mandatory" then
            WhseWkshLine.SetCurrentKey(
              "Worksheet Template Name",Name,"Location Code","To Bin Code","Shelf No.")
          else
            WhseWkshLine.SetCurrentKey(
              "Worksheet Template Name",Name,"Location Code","Shelf No.");
    #20..33
        SequenceNo := SequenceNo + 10000;
      until WhseWkshLine.Next = 0;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..15
              "Worksheet Template Name",Name,"Location Code","To Bin Code")
    #17..36
    */
    //end;
}

