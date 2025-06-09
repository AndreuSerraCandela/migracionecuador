table 64839 "Replicator Report List"
{
    DataPerCompany = false;

    fields
    {
        field(1; Type; Option)
        {
            OptionMembers = Replicator;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Text; Text[30])
        {
        }
        field(4; "Report ID"; Integer)
        {
            /*             TableRelation = Object.ID WHERE (Type = CONST (Report)); */

            trigger OnValidate()
            begin
                CalcFields("Report Name");
                Text := "Report Name";
            end;
        }
        field(5; "Report Name"; Text[30])
        {
            /*             CalcFormula = Lookup (Object.Name WHERE (Type = CONST (Report),
                                                                ID = FIELD ("Report ID")));
                        Editable = false;
                        FieldClass = FlowField; */
        }
    }

    keys
    {
        key(Key1; Type, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

