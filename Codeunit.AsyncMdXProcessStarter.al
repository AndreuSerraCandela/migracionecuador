codeunit 56204 "Async MdX Process Starter"
{
    // Dynamics.is - Gunnar Ðór Gestsson

    TableNo = "Async NAV WS Process Queue";

    trigger OnRun()
    begin
        StartAsyncSendPostRequest(Rec);
    end;

    local procedure StartAsyncSendPostRequest(AsyncNAVProcessQueue: Record "Async NAV WS Process Queue")
    var
        NewSessionId: Integer;
    begin
        if AsyncNAVProcessQueue."Process Code" in ['IRM', 'WS_RESPUESTA_MDE', 'HORARIOSCECO', 'CECO'] then begin
            AsyncNAVProcessQueue.Find;
            AsyncNAVProcessQueue."Process Status" := AsyncNAVProcessQueue."Process Status"::Pending;
            AsyncNAVProcessQueue."Process Start Date & Time" := CurrentDateTime;
            AsyncNAVProcessQueue.Modify;
            Commit;
            StartSession(NewSessionId, CODEUNIT::"Async SendPostRequest", CompanyName, AsyncNAVProcessQueue);
        end;
    end;
}

