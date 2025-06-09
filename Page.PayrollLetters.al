page 76347 "Payroll Letters"
{
    ApplicationArea = all;
    Caption = 'Letters';
    PageType = List;
    SourceTable = "Payroll Letters";
    SourceTableView = SORTING("Report ID", "Company Name", Type);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; rec.Code)
                {
                    Visible = false;
                }
                field("Report ID"; rec."Report ID")
                {
                    Visible = false;
                }
                field("Report Name"; rec."Report Name")
                {
                }
                field("Company Name"; rec."Company Name")
                {
                    Visible = false;
                }
                field(Type; rec.Type)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Last Modified"; rec."Last Modified")
                {
                    Visible = false;
                }
                field("Last Modified by User"; rec."Last Modified by User")
                {
                    Visible = false;
                }
                field(Email; Email)
                {
                    Caption = 'E-Mail responsable';
                    Editable = false;
                }
                field(Publish; rec.Publish)
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
                Visible = false;
            }
            systempart(Control12; Links)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(RunReport)
            {
                Caption = 'Run Report';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    rec.RunCustomReport(gEmp_Code);
                end;
            }
            action(Configurar)
            {
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //Verifico si es un informe con empresa
                    PayrollLetters.DeleteAll;

                    CustomReportLayout.Reset;
                    CustomReportLayout.SetRange("Report ID", 76200, 76077);
                    CustomReportLayout.SetFilter("Company Name", '<>%1', '');
                    if CustomReportLayout.FindSet then
                        repeat
                            if CompanyName = CustomReportLayout."Company Name" then begin
                                PayrollLetters.Init;
                                PayrollLetters.Validate(Code, CustomReportLayout.Code);
                                PayrollLetters.Validate("Report ID", CustomReportLayout."Report ID");
                                PayrollLetters.Validate("Company Name", CustomReportLayout."Company Name");
                                if not PayrollLetters.Insert(true) then
                                    PayrollLetters.Modify;
                            end;
                        until CustomReportLayout.Next = 0;

                    //Si no lo encuentro con empresa lo inserto sin empresa
                    CustomReportLayout.Reset;
                    CustomReportLayout.SetRange("Report ID", 76200, 76077);
                    CustomReportLayout.SetRange("Company Name", '');
                    if CustomReportLayout.FindSet then
                        repeat
                            PayrollLetters.Init;
                            PayrollLetters.Validate(Code, CustomReportLayout.Code);
                            PayrollLetters.Validate("Report ID", CustomReportLayout."Report ID");
                            if not PayrollLetters.Insert(true) then
                                PayrollLetters.Modify;
                        until CustomReportLayout.Next = 0;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        CurrPage.Caption := GetPageCaption;
        ReportLayoutSelection.SetTempLayoutSelected('');
    end;

    trigger OnClosePage()
    var
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        ReportLayoutSelection.SetTempLayoutSelected('');
    end;

    trigger OnOpenPage()
    var
        FileMgt: Codeunit "File Management";
    begin
        PageName := CurrPage.Caption;
        CurrPage.Caption := GetPageCaption;

        RepresentantesEmpresa.Reset;
        RepresentantesEmpresa.SetRange(RepresentantesEmpresa.Figurar, RepresentantesEmpresa.Figurar::"Todo tipo documento");
        RepresentantesEmpresa.FindFirst;
        //Email := RepresentantesEmpresa."E-mail";
    end;

    var
        CustomReportLayout: Record "Custom Report Layout";
        PayrollLetters: Record "Payroll Letters";
        RepresentantesEmpresa: Record "Representantes Empresa";
        IsWindowsClient: Boolean;
        UpdateSuccesMsg: Label 'The %1 layout has been updated to use the current report design.';
        UpdateNotRequiredMsg: Label 'The %1 layout is up-to-date. No further updates are required.';
        PageName: Text;
        CaptionTxt: Label '%1 - %2 %3', Locked = true;
        gEmp_Code: Code[20];
        Email: Text;

    local procedure GetPageCaption(): Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
        FilterText: Text;
        ReportID: Integer;
    begin
        if rec."Report ID" <> 0 then
            exit(StrSubstNo(CaptionTxt, PageName, rec."Report ID", rec."Report Name"));
        rec.FilterGroup(4);
        FilterText := rec.GetFilter("Report ID");
        rec.FilterGroup(0);
        if Evaluate(ReportID, FilterText) then
            if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, ReportID) then
                exit(StrSubstNo(CaptionTxt, PageName, ReportID, AllObjWithCaption."Object Caption"));
        exit(PageName);
    end;


    procedure ReceiveParams(Emp_Code: Code[20])
    begin
        gEmp_Code := Emp_Code;
    end;
}

