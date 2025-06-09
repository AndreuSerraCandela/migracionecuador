table 64832 "Action"
{

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
        }
        field(5; "Source Counter"; BigInteger)
        {
        }
        field(10; WhatToDo; Option)
        {
            OptionMembers = Update,Add,Delete,UpdateAdd;
        }
        field(11; "Move Action"; Boolean)
        {
        }
        field(12; "Table No."; Integer)
        {
        }
        field(14; "Key"; Text[250])
        {
        }
        field(20; "Change Date"; Date)
        {
        }
        field(21; "Change Time"; Time)
        {
        }
        field(22; "Changed by User"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Counter")
        {
        }
    }

    fieldgroups
    {
    }
}

