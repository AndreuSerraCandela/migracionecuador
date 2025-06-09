page 76345 "Payroll - Job Journal"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Job Journal';
    DataCaptionFields = "Journal Batch Name";
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Job,Resource,Human Resource';
    SaveValues = true;
    SourceTable = "Payroll - Job Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    JobJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; rec."Document No.")
                {
                }
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Puesto trabajo"; rec."Puesto trabajo")
                {
                }
                field("Apellidos y Nombre"; rec."Apellidos y Nombre")
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                    Visible = false;
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("Job No."; rec."Job No.")
                {

                    trigger OnValidate()
                    begin
                        JobJnlManagement.GetNames(Rec, JobDescription, AccName);
                        //ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No."; rec."Job Task No.")
                {
                }
                field("Work Type Code"; rec."Work Type Code")
                {
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Tipo Tarifa"; rec."Tipo Tarifa")
                {
                }
                field("Precio Costo"; rec."Precio Costo")
                {
                }
                field(Quantity; rec.Quantity)
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                }
            }
            group(Control73)
            {
                ShowCaption = false;
                fixed(Control1902114901)
                {
                    ShowCaption = false;
                    group("Job Description")
                    {
                        Caption = 'Job Description';
                        field(JobDescription; JobDescription)
                        {
                            Editable = false;
                        }
                    }
                    group("Account Name")
                    {
                        Caption = 'Account Name';
                        field(AccName; AccName)
                        {
                            Caption = 'Account Name';
                            Editable = false;
                        }
                    }
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
        area(navigation)
        {
            group("&Job")
            {
                Caption = '&Job';
                Image = Job;
                action(Card)
                {
                    Caption = 'Card';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("Job No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    RunPageView = SORTING("Job No.", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
            group(Resource)
            {
                Caption = 'Resource';
                Image = Resource;
                action(Action1000000011)
                {
                    Caption = 'Card';
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Resource Card";
                    RunPageLink = "No." = FIELD("Resource No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Action1000000010)
                {
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "Resource No." = FIELD("Resource No.");
                    RunPageView = SORTING("Resource No.", "Posting Date");
                }
            }
            group(Employee)
            {
                Caption = 'Employee';
                Image = Employee;
                action(Action1000000014)
                {
                    Caption = 'Card';
                    Image = Employee;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "Ficha Empleados";
                    RunPageLink = "No." = FIELD("No. empleado");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalcRemainingUsage)
                {
                    Caption = 'Calc. Remaining Usage';
                    Ellipsis = true;
                    Image = CalculateRemainingUsage;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        JobCalcRemainingUsage: Report "Job Calc. Remaining Usage";
                    begin
                        rec.TestField("Journal Template Name");
                        rec.TestField("Journal Batch Name");
                        Clear(JobCalcRemainingUsage);
                        JobCalcRemainingUsage.SetBatch(rec."Journal Template Name", rec."Journal Batch Name");
                        //JobCalcRemainingUsage.SetDocNo("Document No.");
                        JobCalcRemainingUsage.RunModal;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    var
                        PJL: Record "Payroll - Job Journal Line";
                    begin
                        //ReportPrint.PrintJobJnlLine(Rec);

                        PJL.Reset;
                        PJL.SetRange("Journal Template Name", rec."Journal Template Name");
                        PJL.SetRange("Journal Batch Name", rec."Journal Batch Name");
                        REPORT.Run(REPORT::"Valida Diario Nom. - Proyectos", true, true, PJL);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Post Payroll - Job Journal", Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Job Jnl.-Post+Print", Rec);
                        //CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        ReserveJobJnlLine: Codeunit "Job Jnl. Line-Reserve";
    begin
        Commit;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin

        OpenedFromBatch := (rec."Journal Batch Name" <> '') and (rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := rec."Journal Batch Name";
            JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        JobJnlManagement.TemplateSelection(PAGE::"Payroll - Job Journal Batches", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        JobJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        JobJnlManagement: Codeunit PayrollJnlManagement;
        JobDescription: Text[50];
        AccName: Text[50];
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
    end;
}

