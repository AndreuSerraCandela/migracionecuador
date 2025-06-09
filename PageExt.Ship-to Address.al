pageextension 50039 pageextension50039 extends "Ship-to Address"
{
    layout
    {


        addafter(City)
        {

            field(Colonia; rec.Colonia)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Contact)
        {

            field("Horario Entrega"; rec."Horario Entrega")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Entrega En"; rec."Entrega En")
            {
                ApplicationArea = Basic, Suite;
            }
        }

    }

}

