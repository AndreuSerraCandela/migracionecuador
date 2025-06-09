pageextension 50086 pageextension50086 extends "Employment Contracts"
{
    layout
    {
        addafter(Description)
        {
            field(Undefined; rec.Undefined)
            {
            ApplicationArea = All;
            }
            field(Duracion; rec.Duracion)
            {
            ApplicationArea = All;
            }
        }
    }
}

