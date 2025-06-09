tableextension 50128 tableextension50128 extends "Service Item"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
    }
    var
        Text016: Label 'You cannot change the %1 because there are outstanding service orders/quotes attached to it.';
}

