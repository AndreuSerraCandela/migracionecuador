tableextension 50133 tableextension50133 extends "Whse. Item Tracking Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

    }
    keys
    {
        key(Key10; "Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.", "Location Code")
        {
            MaintainSQLIndex = true;
        }
    }
}

