table 64835 "Replicator Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(10; "Date Shut Down"; Date)
        {
        }
        field(11; "Time Shut Down"; Time)
        {
        }
        field(12; "Repeat Interval (sec.)"; Integer)
        {
            InitValue = 5;
        }
        field(13; Running; Boolean)
        {

            trigger OnValidate()
            begin
                if (not Running) and xRec.Running then
                    if not Confirm(
                      'Please ensure that the Scheduler is not\' +
                      'running somewhere else - continue?', false)
                    then
                        Error('Stop the scheduler from the workstation running it.');
                if Running and (not xRec.Running) then
                    Error('You can start the Automatic Scheduler from the main menu.');
            end;
        }
        field(14; "Register Scheduler actions"; Boolean)
        {
        }
        field(15; "Calcdate Day char"; Text[1])
        {
            InitValue = 'D';
        }
        field(16; "Calcdate Month char"; Text[1])
        {
            InitValue = 'M';
        }
        field(20; "Specification Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(21; "Scheduler Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(30; "Local Database Code"; Code[20])
        {
            TableRelation = Databaseupg.Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                /*          if "Local Database Code" <> '' then
                             if Database2.Count() > 0 then
                                 Database2.Get("Local Database Code"); */
            end;
        }
        field(31; "Central Database Code"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                /*                if "Central Database Code" <> '' then
                                   if Database2.Count() > 0 then
                                       Database2.Get("Central Database Code"); */
            end;
        }
        field(40; "Shut Down Date (Sched)"; Date)
        {
        }
        field(41; "Shut Down Time (Sched)"; Time)
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
    /*         Database2: Record Database; */
}

