tableextension 50155 tableextension50155 extends "Whse. Worksheet Name"
{
    fields
    {
        modify("Location Code")
        {
            TableRelation = Location WHERE (Inactivo = CONST (false));
            Description = '001';
        }
    }
}

