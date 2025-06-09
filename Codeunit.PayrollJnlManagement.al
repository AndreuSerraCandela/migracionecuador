codeunit 76054 PayrollJnlManagement
{
    Permissions = TableData "Job Journal Template" = imd,
                  TableData "Job Journal Batch" = imd,
                  TableData "Job Entry No." = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'JOB';
        Text001: Label 'Job Journal';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        LastJobJnlLine: Record "Payroll - Job Journal Line";
        OpenFromBatch: Boolean;


    procedure TemplateSelection(PageID: Integer; RecurringJnl: Boolean; var JobJnlLine: Record "Payroll - Job Journal Line"; var JnlSelected: Boolean)
    var
        JobJnlTemplate: Record "Payroll - Job Journal Template";
    begin
        JnlSelected := true;

        JobJnlTemplate.Reset;
        JobJnlTemplate.SetRange("Page ID", PageID);

        case JobJnlTemplate.Count of
            0:
                begin
                    JobJnlTemplate.Init;
                    JobJnlTemplate.Name := Text000;
                    JobJnlTemplate.Description := Text001;
                    JobJnlTemplate.Validate("Page ID", PageID);
                    JobJnlTemplate.Insert;
                    Commit;
                end;
            1:
                JobJnlTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, JobJnlTemplate) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            JobJnlLine.FilterGroup := 2;
            JobJnlLine.SetRange("Journal Template Name", JobJnlTemplate.Name);
            JobJnlLine.FilterGroup := 0;
            if OpenFromBatch then begin
                JobJnlLine."Journal Template Name" := '';
                PAGE.Run(JobJnlTemplate."Page ID", JobJnlLine);
            end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var JobJnlBatch: Record "Payroll - Job Journal Batch")
    var
        JobJnlLine: Record "Payroll - Job Journal Line";
        JobJnlTemplate: Record "Payroll - Job Journal Template";
    begin
        OpenFromBatch := true;
        JobJnlTemplate.Get(JobJnlBatch."Journal Template Name");
        JobJnlTemplate.TestField("Page ID");
        JobJnlBatch.TestField(Name);

        JobJnlLine.FilterGroup := 2;
        JobJnlLine.SetRange("Journal Template Name", JobJnlTemplate.Name);
        JobJnlLine.FilterGroup := 0;

        JobJnlLine."Journal Template Name" := '';
        JobJnlLine."Journal Batch Name" := JobJnlBatch.Name;
        PAGE.Run(JobJnlTemplate."Page ID", JobJnlLine);
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10]; var JobJnlLine: Record "Payroll - Job Journal Line")
    begin
        CheckTemplateName(JobJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
        JobJnlLine.FilterGroup := 2;
        JobJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        JobJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var JobJnlBatch: Record "Payroll - Job Journal Batch")
    var
        JobJnlTemplate: Record "Payroll - Job Journal Template";
        JobJnlLine: Record "Payroll - Job Journal Line";
        JnlSelected: Boolean;
    begin
        if JobJnlBatch.GetFilter("Journal Template Name") <> '' then
            exit;
        JobJnlBatch.FilterGroup(2);
        if JobJnlBatch.GetFilter("Journal Template Name") <> '' then begin
            JobJnlBatch.FilterGroup(0);
            exit;
        end;
        JobJnlBatch.FilterGroup(0);

        if not JobJnlBatch.Find('-') then begin
            if not JobJnlTemplate.FindFirst then
                TemplateSelection(0, false, JobJnlLine, JnlSelected);
            if JobJnlTemplate.FindFirst then
                CheckTemplateName(JobJnlTemplate.Name, JobJnlBatch.Name);
            if not JobJnlTemplate.FindFirst then
                TemplateSelection(0, true, JobJnlLine, JnlSelected);
            if JobJnlTemplate.FindFirst then
                CheckTemplateName(JobJnlTemplate.Name, JobJnlBatch.Name);
        end;
        JobJnlBatch.Find('-');
        JnlSelected := true;
        if JobJnlBatch.GetFilter("Journal Template Name") <> '' then
            JobJnlTemplate.SetRange(Name, JobJnlBatch.GetFilter("Journal Template Name"));
        case JobJnlTemplate.Count of
            1:
                JobJnlTemplate.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, JobJnlTemplate) = ACTION::LookupOK;
        end;
        if not JnlSelected then
            Error('');

        JobJnlBatch.FilterGroup(2);
        JobJnlBatch.SetRange("Journal Template Name", JobJnlTemplate.Name);
        JobJnlBatch.FilterGroup(0);
    end;


    procedure CheckTemplateName(CurrentJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        JobJnlBatch: Record "Payroll - Job Journal Batch";
    begin
        JobJnlBatch.SetRange("Journal Template Name", CurrentJnlTemplateName);
        if not JobJnlBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then begin
            if not JobJnlBatch.FindFirst then begin
                JobJnlBatch.Init;
                JobJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
                JobJnlBatch.SetupNewBatch;
                JobJnlBatch.Name := Text004;
                JobJnlBatch.Description := Text005;
                JobJnlBatch.Insert(true);
                Commit;
            end;
            CurrentJnlBatchName := JobJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10]; var JobJnlLine: Record "Payroll - Job Journal Line")
    var
        JobJnlBatch: Record "Payroll - Job Journal Batch";
    begin
        JobJnlBatch.Get(JobJnlLine.GetRangeMax("Journal Template Name"), CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10]; var JobJnlLine: Record "Payroll - Job Journal Line")
    begin
        JobJnlLine.FilterGroup := 2;
        JobJnlLine.SetRange("Journal Batch Name", CurrentJnlBatchName);
        JobJnlLine.FilterGroup := 0;
        if JobJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10]; var JobJnlLine: Record "Payroll - Job Journal Line"): Boolean
    var
        JobJnlBatch: Record "Payroll - Job Journal Batch";
    begin
        Commit;
        JobJnlBatch."Journal Template Name" := JobJnlLine.GetRangeMax("Journal Template Name");
        JobJnlBatch.Name := JobJnlLine.GetRangeMax("Journal Batch Name");
        JobJnlBatch.FilterGroup(2);
        JobJnlBatch.SetRange("Journal Template Name", JobJnlBatch."Journal Template Name");
        JobJnlBatch.FilterGroup(0);
        if PAGE.RunModal(0, JobJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := JobJnlBatch.Name;
            SetName(CurrentJnlBatchName, JobJnlLine);
        end;
    end;


    procedure GetNames(var JobJnlLine: Record "Payroll - Job Journal Line"; var JobDescription: Text[50]; var AccName: Text[50])
    var
        Job: Record Job;
        Res: Record Resource;
        Item: Record Item;
        GLAcc: Record "G/L Account";
    begin
        if (JobJnlLine."Job No." = '') or
           (JobJnlLine."Job No." <> LastJobJnlLine."Job No.")
        then begin
            JobDescription := '';
            if Job.Get(JobJnlLine."Job No.") then
                JobDescription := Job.Description;
        end;
        /*GRN No va por el momento
        IF (JobJnlLine.Type <> LastJobJnlLine.Type) OR
           (JobJnlLine."No." <> LastJobJnlLine."No.")
        THEN BEGIN
          AccName := '';
          IF JobJnlLine."No." <> '' THEN
            CASE JobJnlLine.Type OF
              JobJnlLine.Type::Resource:
                IF Res.GET(JobJnlLine."No.") THEN
                  AccName := Res.Name;
              JobJnlLine.Type::Item:
                IF Item.GET(JobJnlLine."No.") THEN
                  AccName := Item.Description;
              JobJnlLine.Type::"G/L Account":
                IF GLAcc.GET(JobJnlLine."No.") THEN
                  AccName := GLAcc.Name;
            END;
        END;
        */
        LastJobJnlLine := JobJnlLine;

    end;
}

