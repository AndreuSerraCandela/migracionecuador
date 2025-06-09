pageextension 50085 pageextension50085 extends "Grounds for Termination"
{
    layout
    {
        addafter(Description)
        {
            field(Preaviso; rec.Preaviso)
            {
            ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Cesantia; rec.Cesantia)
            {
            ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Vacaciones; rec.Vacaciones)
            {
            ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
            field(Regalia; rec.Regalia)
            {
            ApplicationArea = All;
                Importance = Additional;
                Visible = false;
            }
        }
    }
}

