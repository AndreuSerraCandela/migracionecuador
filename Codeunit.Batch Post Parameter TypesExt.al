codeunit 55036 "BatchPostParameterTypesExt"
{
    trigger OnRun()
    begin

    end;

    procedure ReplaceEndingDate(): Integer
    begin
        exit(Parameter::"Replace Ending Date"); //001+-
    end;

    procedure EndingDate(): Integer
    begin
        exit(Parameter::"Ending Date"); //001+-
    end;

    var
        myInt: Integer;
        Parameter: Option Invoice,Ship,Receive,"Posting Date","Replace Posting Date","Replace Document Date","Calculate Invoice Discount",Print,"Ending Date","Replace Ending Date";
}