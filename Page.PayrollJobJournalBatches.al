page 76346 "Payroll - Job Journal Batches"
{
    ApplicationArea = all;
    Caption = 'Job Journal Batches';
    DataCaptionExpression = DataCaption;
    Editable = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Payroll - Job Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; rec.Name)
                {
                }
                field(Description; rec.Description)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Journal")
            {
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    JobJnlMgt.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        //ReportPrint.PrintJobJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Job Jnl.-B.Post";
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Job Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                }
            }
        }
    }

    trigger OnInit()
    begin
        rec.SetRange("Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetupNewBatch;
    end;

    trigger OnOpenPage()
    begin
        JobJnlMgt.OpenJnlBatch(Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        JobJnlMgt: Codeunit PayrollJnlManagement;

    local procedure DataCaption(): Text[250]
    var
        JobJnlTemplate: Record "Payroll - Job Journal Template";
    begin
        if not CurrPage.LookupMode then
            if rec.GetFilter("Journal Template Name") <> '' then
                if rec.GetRangeMin("Journal Template Name") = rec.GetRangeMax("Journal Template Name") then
                    if JobJnlTemplate.Get(rec.GetRangeMin("Journal Template Name")) then
                        exit(JobJnlTemplate.Name + ' ' + JobJnlTemplate.Description);
    end;
}

