table 64822 Specification
{
    DataCaptionFields = "No.", Description;
    /*     DrillDownPageID = 64832;
        LookupPageID = 64832; */

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(5; "Replicator Group Code"; Code[20])
        {
            TableRelation = "Replicator Group".Code;
        }
        field(6; "Seq. No."; Integer)
        {
        }
        field(7; Enabled; Boolean)
        {
            InitValue = true;
        }
        field(10; Description; Text[80])
        {
        }
        field(14; "Transfer Type"; Option)
        {
            InitValue = Normal;
            OptionMembers = ,Normal,,,"ToDo Table","By Actions",Objects,Backup,BackupCompare,CompanyExport,CompanyImport;

            trigger OnValidate()
            begin
                /*IF "Transfer Type" <> xRec."Transfer Type" THEN
                  FieldLookupFunctions.TransferTypeOnValidate(Rec);*/ //fes mig

            end;
        }
        field(15; WhatToDo; Option)
        {
            InitValue = "Update-Add";
            OptionMembers = ,Update,Add,"Update-Add",Delete,"Update-Delete","Add-Delete","Update-Add-Delete";

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.WhatToDoOnValidate(Rec);
            end;
        }
        field(16; "Field List Type"; Option)
        {
            InitValue = "All Fields";
            OptionMembers = "Exclude List","Include List","All Fields";

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.FieldListTypeOnValidate(Rec,"Field List Type" <> xRec."Field List Type");
            end;
        }
        field(17; "Sequential Read"; Option)
        {
            InitValue = "Source+Dest";
            OptionMembers = "Source+Dest","Source only","Dest only";

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SequentialReadOnValidate(Rec);
            end;
        }
        field(19; "Source Design"; Code[20])
        {
            TableRelation = Databaseupg.Code;

            trigger OnValidate()
            begin
                //fes mig IF ("Source Design" <> xRec."Source Design") AND (xRec."Source Design" <> '') THEN
                //fes mig  FieldLookupFunctions.SourceDesignOnValidate(Rec);
            end;
        }
        field(20; "Source Database"; Code[20])
        {
            NotBlank = true;
            TableRelation = DatabaseUPG.Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if DB.Get("Source Database") then
                    Validate("Source Design", DB."Assume Design");
            end;
        }
        field(28; "Source Table No"; Integer)
        {
            TableRelation = IF ("Source Design" = FILTER('')) AllObj."Object ID" WHERE("Object Type" = CONST(Table))
            ELSE
            IF ("Source Design" = FILTER(<> '')) "Database Table"."Table No." WHERE("Database Code" = FIELD("Source Design"));

            trigger OnValidate()
            begin
                /*IF ("Source Table No" <> xRec."Source Table No") AND (xRec."Source Table No" <> 0) THEN
                  FieldLookupFunctions.SourceTableNoOnValidate(Rec);
                VALIDATE("Source Table Name");
                IF "Dest. Table No." = 0 THEN BEGIN
                  "Dest. Table No." := "Source Table No";
                  IF FieldLookupFunctions.DestTableNoExists(Rec) THEN
                    VALIDATE("Dest. Table No.","Source Table No")
                  ELSE
                    "Dest. Table No." := 0;
                END;*/
                //fes mig

            end;
        }
        field(29; "Source Table Name"; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SourceTableNameOnValidate(Rec);
            end;
        }
        field(30; "Source Key"; Text[80])
        {
        }
        field(31; "Source Key Fields"; Text[250])
        {
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //fes mig FieldLookupFunctions.SourceKeyFieldsOnLookup(Rec);
            end;

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SourceKeyFieldsOnValidate(Rec);
            end;
        }
        field(33; "Source Filter"; Boolean)
        {
            CalcFormula = Exist("Field Filter" WHERE("Specification No." = FIELD("No."),
                                                      Type = CONST("Source Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Source Flag Field"; Integer)
        {

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SourceFlagFieldOnValidate(Rec);
            end;
        }
        field(36; "Source Flag Field Name"; Text[30])
        {
            Editable = false;
            FieldClass = Normal;

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SourceFlagFieldNameOnValidate(Rec);
            end;
        }
        field(37; "Source Counter Field"; Integer)
        {

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SourceCounterFieldOnValidate(Rec);
            end;
        }
        field(38; "Source Counter Name"; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.SourceCounterNameOnValidate(Rec);
            end;
        }
        field(39; "Dest. Design"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;

            trigger OnValidate()
            begin
                //fes mig IF ( "Dest. Design" <> xRec."Dest. Design" ) AND (xRec."Dest. Design" <> '') THEN
                //fes mig FieldLookupFunctions.DestDesignOnValidate(Rec);
            end;
        }
        field(40; "Dest. Database"; Code[20])
        {
            TableRelation = DatabaseUPG.Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if ("Source Database" = "Dest. Database") then
                    Message('%1 is the same as %2\' +
                      'Please ensure that this is what you want.',
                      FieldName("Source Database"), FieldName("Dest. Database"));
                if DB.Get("Dest. Database") then
                    Validate("Dest. Design", DB."Assume Design");
            end;
        }
        field(48; "Dest. Table No."; Integer)
        {
            TableRelation = IF ("Dest. Design" = FILTER('')) AllObj."Object ID" WHERE("Object Type" = CONST(Table))
            ELSE
            IF ("Dest. Design" = FILTER(<> '')) "Database Table"."Table No." WHERE("Database Code" = FIELD("Dest. Design"));

            trigger OnValidate()
            begin
                /*IF ("Dest. Table No." <> xRec."Dest. Table No.") AND (xRec."Dest. Table No." <> 0) THEN
                  FieldLookupFunctions.DestTableNoOnValidate(Rec);*/ //fes mig
                if ("Transfer Type" <> "Transfer Type"::Normal) and ("Dest. Table No." <> 0) then
                    if "Dest. Table No." <> "Source Table No" then
                        Error('%1 and %2 must be the same when using %3.',
                          FieldName("Dest. Table No."), FieldName("Source Table No"), "Transfer Type");
                Validate("Dest. Table Name");

            end;
        }
        field(49; "Dest. Table Name"; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin

                //fes mig FieldLookupFunctions.DestTableNameOnValidate(Rec);
            end;
        }
        field(50; "Dest. Key"; Text[80])
        {
        }
        field(51; "Dest. Key Fields"; Text[250])
        {
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            begin

                //fes mig FieldLookupFunctions.DestKeyFieldsOnLookup(Rec);
            end;

            trigger OnValidate()
            begin

                //fes mig FieldLookupFunctions.DestKeyFieldsOnValidate(Rec);
            end;
        }
        field(53; "Dest. Filter"; Boolean)
        {
            CalcFormula = Exist("Field Filter" WHERE("Specification No." = FIELD("No."),
                                                      Type = CONST("Dest. Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Main Spec."; Code[20])
        {
            TableRelation = Specification;
        }
        field(55; "Dest. Update SC."; Code[20])
        {
            TableRelation = Specification."No.";
        }
        field(56; "Dest. Return Changes"; Boolean)
        {
        }
        field(57; "Log Changes"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Log Changes" = false then begin
                    "Source UserID Field" := 0;
                    "Source UserID Name" := '';
                end;
            end;
        }
        field(58; "Source UserID Field"; Integer)
        {

            trigger OnLookup()
            begin

                //fes mig FieldLookupFunctions.SourceUserIDFieldOnLookup(Rec);
            end;

            trigger OnValidate()
            begin
                Validate("Source UserID Name");
            end;
        }
        field(59; "Source UserID Name"; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin

                //fes mig FieldLookupFunctions.SourceUserIDNameOnValidate(Rec);
            end;
        }
        field(60; "Commit per"; Integer)
        {
        }
        field(61; "Buffer Size (Records)"; Integer)
        {
        }
        field(62; "Action Table No."; Integer)
        {
            TableRelation = IF ("Source Design" = FILTER('')) AllObj."Object ID" WHERE("Object Type" = CONST(Table))
            ELSE
            IF ("Source Design" = FILTER(<> '')) "Database Table"."Table No." WHERE("Database Code" = FIELD("Source Design"));

            trigger OnValidate()
            begin
                Validate("Action Table Name")
            end;
        }
        field(63; "Action Table Name"; Text[30])
        {

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.ActionTableNameOnValidate(Rec);
            end;
        }
        field(64; "Move Actions"; Boolean)
        {
        }
        field(65; "Dest. Check SC. No."; Integer)
        {

            trigger OnLookup()
            begin
                //fes mig FieldLookupFunctions.DestCheckSCFieldOnLookup(Rec);
            end;

            trigger OnValidate()
            begin
                Validate("Dest. Check SC. Name");
            end;
        }
        field(66; "Dest. Check SC. Name"; Text[30])
        {

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.DestCheckSCNameOnValidate(Rec);
            end;
        }
        field(67; "Sub Specifications"; Boolean)
        {
            CalcFormula = Exist(Specification WHERE("Main Spec." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(68; "Field List"; Boolean)
        {
            CalcFormula = Exist("Field List" WHERE("Specification No." = FIELD("No."),
                                                    "List Type" = CONST("Field Transfer List")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; "Table-Linking"; Boolean)
        {
            CalcFormula = Exist("Field List" WHERE("Specification No." = FIELD("No."),
                                                    "List Type" = CONST("Key Field Links")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "No. Series"; Code[10])
        {
        }
        field(71; "Changes Only (from SQL)"; Boolean)
        {

            trigger OnValidate()
            begin
                //fes mig FieldLookupFunctions.ChangesOnlyOnValidate(Rec);
            end;
        }
        field(80; Text; Text[50])
        {
        }
        field(81; "Code"; Code[50])
        {
        }
        field(82; "Integer"; Integer)
        {
        }
        field(83; Decimal; Decimal)
        {
        }
        field(84; Date; Date)
        {
        }
        field(85; Time; Time)
        {
        }
        field(86; Option; Option)
        {
            OptionMembers = "";
        }
        field(87; Boolean; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Replicator Group Code", "Seq. No.", Enabled)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        FieldList.SetRange("Specification No.", "No.");
        FieldList.DeleteAll();
        FieldFilter.SetRange("Specification No.", "No.");
        FieldFilter.DeleteAll();
        LinkedTableFilter.SetRange("Specification No.", "No.");
        LinkedTableFilter.DeleteAll();
        Spec.SetRange("Main Spec.", "No.");
        Spec.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        ReplicatorSetup.Get;
        if "No." = '' then
            ReplicatorSetup.TestField("Specification Nos.");
        //NoSeriesMgt.InitSeries(ReplicatorSetup."Specification Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        Rec."No. series" := ReplicatorSetup."Specification Nos.";
        if NoSeriesMgt.AreRelated(ReplicatorSetup."Specification Nos.", xRec."No. Series") then
            Rec."No. Series" := xRec."No. Series";
        Rec."No." := NoSeriesMgt.GetNextNo(Rec."No. Series", 0D);

        if ("Main Spec." <> '') then begin
            Spec.Get("Main Spec.");
            "Replicator Group Code" := Spec."Replicator Group Code";
            "Source Design" := Spec."Source Design";
            "Source Database" := Spec."Source Database";
            "Dest. Design" := Spec."Dest. Design";
            "Dest. Database" := Spec."Dest. Database";
        end;
    end;

    var
        FieldList: Record "Field List";
        FieldFilter: Record "Field Filter";
        LinkedTableFilter: Record "Linked Table Filter";
        DB: Record DatabaseUPG;
        Spec: Record Specification;
        ReplicatorSetup: Record "Replicator Setup";
        DatabaseTables: Record "Database Table";
        AllObj: Record AllObj;
        NoSeriesMgt: Codeunit "No. Series";


    procedure AssistEdit(OldSpec: Record Specification): Boolean
    begin
        Spec := Rec;
        ReplicatorSetup.Get;
        ReplicatorSetup.TestField("Specification Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ReplicatorSetup."Specification Nos.", OldSpec."No. Series", "No. Series") then begin
            ReplicatorSetup.Get;
            ReplicatorSetup.TestField("Specification Nos.");
            NoSeriesMgt.GetNextNo(Spec."No.");
            Rec := Spec;
            exit(true);
        end;
    end;
}

