table 64824 "Replicator Group"
{
/*     DrillDownPageID = 64824;
    LookupPageID = 64824;
 */
    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(5; Description; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Specification.SetCurrentKey("Replicator Group Code");
        Specification.SetRange("Replicator Group Code", Code);
        if Specification.Find('-') then
            Error('This %1 is used on %2 %3.',
              FieldName(Code), Specification.TableName, Specification."No.");
        Scheduler.SetRange("Replicator Group Code", Code);
        if Scheduler.Find('-') then
            Error('This %1 is used on %2 %3.',
              FieldName(Code), Scheduler.TableName, Scheduler."No.");
    end;

    trigger OnInsert()
    begin
        if Code = 'DESIGN' then
            Error('The Name "Design" is a reserved group name.');
        if Code = 'SCHEDULER' then
            Error('The Name "Scheduler" is a reserved group name.');
    end;

    var
        Specification: Record Specification;
        Scheduler: Record Scheduler;
}

