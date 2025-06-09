#pragma implicitwith disable
page 76235 "Headline RC Payroll"
{
    ApplicationArea = all;
    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;
    SourceTable = "Headline RC Payroll";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                Visible = UserGreetingVisible;
                field(GreetingText; GreetingText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Greeting headline';
                    Editable = false;
                    Visible = UserGreetingVisible;
                }
            }
            group(Control1000000001)
            {
                ShowCaption = false;
                Visible = DefaultFieldsVisible;
                field(NewsText; NewsText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'News headline';
                    DrillDown = true;
                    Editable = false;
                    Visible = DefaultFieldsVisible;

                    trigger OnDrillDown()
                    begin
                        Empl.Reset;
                        Empl.SetCurrentKey("Mes Nacimiento", "Dia nacimiento");
                        Empl.SetRange("Mes Nacimiento", Date2DMY(Today, 2));
                        Empl.SetRange("Dia nacimiento", Date2DMY(Today, 1));

                        EmplList.SetTableView(Empl);
                        EmplList.Run;

                        Clear(EmplList);
                    end;
                }
            }
            group(Control1000000003)
            {
                ShowCaption = false;
                Visible = DefaultFieldsVisible;
                field(DocumentationText; DocumentationText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documentation headline';
                    DrillDown = true;
                    Editable = false;
                    Visible = DefaultFieldsVisible;

                    trigger OnDrillDown()
                    begin
                        HyperLink(DocumentationUrlTxt);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ComputeDefaultFieldsVisibility;
    end;

    trigger OnOpenPage()
    var
        Uninitialized: Boolean;
    begin
        if not Rec.Get then
            if Rec.WritePermission then begin
                Rec.Init;
                Rec.Insert;
            end else
                Uninitialized := true;

        if not Uninitialized and Rec.WritePermission then begin
            Rec."Workdate for computations" := WorkDate;
            Rec.Modify;
            ScheduleTask(CODEUNIT::"Headline RC Payroll");
        end;

        GreetingText := HeadlineManagement.GetUserGreetingText();
        DocumentationText := StrSubstNo(DocumentationTxt, PRODUCTNAME.Short);


        NewsText := CopyStr(StrSubstNo(NewsTxt, ListaCumpleanos), 1, MaxStrLen(NewsText));

        if Uninitialized then
            // table is uninitialized because of permission issues. OnAfterGetRecord won't be called
            ComputeDefaultFieldsVisibility;

        Commit; // not to mess up the other page parts that may do IF CODEUNIT.RUN()
    end;

    var
        Empl: Record Employee;
        EmplList: Page "Employee List";
        HeadlineManagement: Codeunit "Headlines";

        DefaultFieldsVisible: Boolean;
        DocumentationTxt: Label 'Want to learn more about %1?', Comment = '%1 is the NAV short product name.';
        DocumentationUrlTxt: Label 'https://go.microsoft.com/fwlink/?linkid=867580', Locked = true;
        GreetingText: Text[250];
        DocumentationText: Text[250];
        NewsText: Text;
        ListaCumpleanos: Text;
        UserGreetingVisible: Boolean;
        NewsTxt: Label 'Today''s birthdays %1';

    local procedure ComputeDefaultFieldsVisibility()
    var
        ExtensionHeadlinesVisible: Boolean;
    begin
        OnIsAnyExtensionHeadlineVisible(ExtensionHeadlinesVisible);
        DefaultFieldsVisible := not ExtensionHeadlinesVisible;
        UserGreetingVisible := HeadlineManagement.ShouldUserGreetingBeVisible;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnIsAnyExtensionHeadlineVisible(var ExtensionHeadlinesVisible: Boolean)
    begin
    end;

    local procedure ScheduleTask(CodeunitId: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
        DummyRecordId: RecordId;
    begin
        //OnBeforeScheduleTask(CodeunitId);
        IF NOT TASKSCHEDULER.CANCREATETASK THEN
            EXIT;
        IF NOT JobQueueEntry.WRITEPERMISSION THEN
            EXIT;

        JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SETRANGE("Object ID to Run", CodeunitId);
        JobQueueEntry.SETRANGE(Status, JobQueueEntry.Status::"In Process");
        IF NOT JobQueueEntry.ISEMPTY THEN
            EXIT;

        JobQueueEntry.ScheduleJobQueueEntry(CodeunitId, DummyRecordId);
    end;
}

#pragma implicitwith restore

