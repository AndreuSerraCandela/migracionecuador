codeunit 56203 "Async MdX NAV WS"
{
    TableNo = "Async NAV WS Process Queue";

    trigger OnRun()
    var
        MdeMgnt: Codeunit "MdE Management";
        IsError: Boolean;
    begin
        rec.SetRange("Process Status", rec."Process Status"::Error);
        if rec.FindFirst then
            repeat
                ClearLastError;
                if not CODEUNIT.Run(CODEUNIT::"Async SendPostRequest", Rec) then begin
                    rec.SetProcessResponse(GetLastErrorText);
                    rec."Process Status" := rec."Process Status"::Error;
                    rec.Modify;
                end;
            until rec.Next = 0;
    end;


    procedure StartNewQueue(ProcessCode: Code[50]; ProcessURLWS: Text[150]; ProcessSoapAction: Text[50]; ProcessData: Text; var QueueId: Integer; var ResponseMessage: Text) Success: Boolean
    begin
        Success := TryCreateNewQueue(ProcessCode, ProcessURLWS, ProcessSoapAction, ProcessData, QueueId);
        if not Success then
            ResponseMessage := GetLastErrorText;
    end;


    procedure GetQueueStatus(QueueId: Integer; var Status: Text; var ResponseMessage: Text) Success: Boolean
    begin
        Success := TryGetQueueStatus(QueueId, Status);
        if not Success then
            ResponseMessage := GetLastErrorText;
    end;

    local procedure TryCreateNewQueue(ProcessCode: Code[50]; ProcessURLWS: Text[150]; ProcessSoapAction: Text[50]; ProcessData: Text; var QueueId: Integer) Success: Boolean
    var
        AsyncNAVProcessQueue: Record "Async NAV WS Process Queue";
    begin
        AsyncNAVProcessQueue.Init;
        AsyncNAVProcessQueue."Entry No." := 0;
        AsyncNAVProcessQueue."Process Code" := ProcessCode;
        AsyncNAVProcessQueue.SetProcessData(ProcessData);
        AsyncNAVProcessQueue."Process User Id" := UserId;
        AsyncNAVProcessQueue."URL Web Service" := ProcessURLWS;
        AsyncNAVProcessQueue."Soap Action" := ProcessSoapAction;
        if not AsyncNAVProcessQueue.Insert(true) then
            exit(false);
        QueueId := AsyncNAVProcessQueue."Entry No.";
        Commit;

        exit(OnNewQueueInserted(AsyncNAVProcessQueue));
    end;

    local procedure TryGetQueueStatus(QueueId: Integer; var Status: Text) Success: Boolean
    var
        AsyncNAVProcessQueue: Record "Async NAV WS Process Queue";
    begin
        if AsyncNAVProcessQueue.Get(QueueId) then begin
            Success := true;
            Status := Format(AsyncNAVProcessQueue."Process Status");
        end else
            Success := false;
    end;

    local procedure OnNewQueueInserted(AsyncNAVProcessQueue: Record "Async NAV WS Process Queue") Success: Boolean
    begin
        exit(true);
    end;
}

