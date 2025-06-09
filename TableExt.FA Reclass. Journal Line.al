tableextension 50109 tableextension50109 extends "FA Reclass. Journal Line"
{
    fields
    {
        modify("FA No.")
        {
            TableRelation = "Fixed Asset" WHERE (Inactive = CONST (false));
            Description = '001';
        }
        modify("New FA No.")
        {
            TableRelation = "Fixed Asset" WHERE (Inactive = CONST (false));
            Description = '001';
        }
    }
}

