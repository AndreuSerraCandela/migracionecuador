pageextension 50044 pageextension50044 extends "Post Codes"
{
    layout
    {
        addafter(County)
        {
            field(Colonia; rec.Colonia)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

