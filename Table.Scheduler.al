table 64833 Scheduler
{
    DataCaptionFields = "No.", Description;
    /*     DrillDownPageID = 64847;
        LookupPageID = 64847; */

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;
        }
        field(5; Description; Text[30])
        {
        }
        field(6; "Job Type"; Option)
        {
            OptionMembers = Replicator,Navision;

            trigger OnValidate()
            begin
                if "Job Type" = "Job Type"::Replicator then
                    "Codeunit No." := 0
                else begin
                    "Specfication No." := '';
                    "Replicator Group Code" := '';
                end;
            end;
        }
        field(10; "Specfication No."; Code[20])
        {
            TableRelation = Specification."No.";

            trigger OnValidate()
            begin
                if "Specfication No." <> '' then begin
                    TestField("Job Type", "Job Type"::Replicator);
                    "Replicator Group Code" := '';
                end;
            end;
        }
        field(11; "Replicator Group Code"; Code[20])
        {
            TableRelation = "Replicator Group".Code;

            trigger OnValidate()
            begin
                if "Replicator Group Code" <> '' then begin
                    TestField("Job Type", "Job Type"::Replicator);
                    "Specfication No." := '';
                end;
            end;
        }
        field(15; Status; Option)
        {
            OptionMembers = Ok,Processing,Error,Stopped;
        }
        field(16; "Error Handling"; Option)
        {
            OptionMembers = Skip,Retry,Stop;
        }
        field(17; Interval; Integer)
        {
            BlankZero = true;
        }
        field(18; Unit; Option)
        {
            BlankZero = true;
            OptionMembers = ,"Minute(s)","Hour(s)","Day(s)","Week(s)","Month(s)";
        }
        field(20; Sunday; Boolean)
        {
            InitValue = true;
        }
        field(21; Monday; Boolean)
        {
            InitValue = true;
        }
        field(22; Tuesday; Boolean)
        {
            InitValue = true;
        }
        field(23; Wednesday; Boolean)
        {
            InitValue = true;
        }
        field(24; Thursday; Boolean)
        {
            InitValue = true;
        }
        field(25; Friday; Boolean)
        {
            InitValue = true;
        }
        field(26; Saturday; Boolean)
        {
            InitValue = true;
        }
        field(28; "Start Time"; Time)
        {
        }
        field(29; "End Time"; Time)
        {
        }
        field(30; "Last Date"; Date)
        {
        }
        field(31; "Last Time"; Time)
        {
        }
        field(32; "Next Date"; Date)
        {
        }
        field(33; "Next Time"; Time)
        {
        }
        field(40; "Codeunit No."; Integer)
        {
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Codeunit));

            trigger OnValidate()
            begin
                if "Codeunit No." <> 0 then
                    TestField("Job Type", "Job Type"::Navision);
            end;
        }
        field(50; "No. Series"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Job Type", "Next Date", "Next Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        tags.SetRange("Scheduler No.", "No.");
        tags.DeleteAll;
    end;

    trigger OnInsert()
    begin
        ReplicatorSetup.Get;
        if "No." = '' then
            ReplicatorSetup.TestField("Scheduler Nos.");
        //NoSeriesMgt.InitSeries(ReplicatorSetup."Scheduler Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        Rec."No. series" := ReplicatorSetup."Scheduler Nos.";
        if NoSeriesMgt.AreRelated(ReplicatorSetup."Scheduler Nos.", xRec."No. Series") then
            Rec."No. Series" := xRec."No. Series";
        Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series");
    end;

    var
        tags: Record "Scheduler Tag";
        ReplicatorSetup: Record "Replicator Setup";
        Sched: Record Scheduler;
        NoSeriesMgt: Codeunit "No. Series";


    procedure AssistEdit(OldSched: Record Scheduler): Boolean
    begin
        Sched := Rec;
        ReplicatorSetup.Get;
        ReplicatorSetup.TestField("Scheduler Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ReplicatorSetup."Scheduler Nos.", OldSched."No. Series", "No. Series") then begin
            ReplicatorSetup.Get;
            ReplicatorSetup.TestField("Scheduler Nos.");
            NoSeriesMgt.GetNextNo(Sched."No.");
            Rec := Sched;
            exit(true);
        end;
    end;
}

