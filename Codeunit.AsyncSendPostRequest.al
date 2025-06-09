codeunit 56205 "Async SendPostRequest"
{
    // Dynamics.is - Gunnar Ðór Gestsson

    TableNo = "Async NAV WS Process Queue";

    trigger OnRun()
    var
        MdeMgnt: Codeunit "MdE Management";
        IsError: Boolean;
    begin
        rec.Find;
        rec.SetProcessResponse(MdeMgnt.SendPostRequestNoError(rec."URL Web Service", rec."Soap Action", rec.GetProcessData(), IsError));
        if IsError then
            rec."Process Status" := rec."Process Status"::Error
        else
            rec."Process Status" := rec."Process Status"::Completed;
        rec."Process End Date & Time" := CurrentDateTime;
        rec.Modify;
    end;
}

