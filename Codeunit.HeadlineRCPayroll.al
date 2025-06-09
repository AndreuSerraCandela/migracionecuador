codeunit 76043 "Headline RC Payroll"
{

    trigger OnRun()
    var
        HeadlineRCOrderProcessor: Record "Headline RC Payroll";
    begin
        HeadlineRCOrderProcessor.Get;
        WorkDate := HeadlineRCOrderProcessor."Workdate for computations";
        OnComputeHeadlines;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnComputeHeadlines()
    begin
    end;
}

