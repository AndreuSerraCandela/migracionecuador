codeunit 76566 "ES NAS Handler"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if rec."Parameter String" <> '' then begin
            CreateNASProcessEntry(rec."Parameter String");

            Commit;
        end;

        ProcessNASEntries;
    end;

    var
        Text001: Label 'No %1 found.';
        Text002: Label 'Inserted %1 %2';


    procedure ProcessNASEntries()
    var
    //ESNASProcessEntry: Record "ES NAS Process Entry";
    //ESNASProcessEntry2: Record "ES NAS Process Entry";
    begin
        /*ESNASProcessEntry.Reset;
        ESNASProcessEntry.SetRange(Status, ESNASProcessEntry.Status::Ready);
        if ESNASProcessEntry.Find('-') then
            repeat
                ESNASProcessEntry2 := ESNASProcessEntry;
                ESNASProcessEntry2."Start Date Time" := CurrentDateTime;
                ESNASProcessEntry2."End Date Time" := 0DT;
                ESNASProcessEntry2.Status := ESNASProcessEntry2.Status::"In Process";
                ESNASProcessEntry2."Last Modified By User" := UserId;
                ESNASProcessEntry2.Modify;
                Commit;

                ClearLastError;
                if not CODEUNIT.Run(CODEUNIT::"ES NAS Processing", ESNASProcessEntry2) then begin
                    ESNASProcessEntry2.Status := ESNASProcessEntry2.Status::Error;
                    //ESNASProcessEntry2."Error Text" :=
                    //CopyStr(GetLastErrorText, 1, MaxStrLen(ESNASProcessEntry2."Error Text"));
                    ESNASProcessEntry2."Error Message" :=
                      CopyStr(GetLastErrorText, 1, MaxStrLen(ESNASProcessEntry2."Error Message"));
                end else
                    ESNASProcessEntry2.Status := ESNASProcessEntry2.Status::Finished;
                ESNASProcessEntry2."End Date Time" := CurrentDateTime;
                ESNASProcessEntry2.Modify;
                Commit;
            until ESNASProcessEntry.Next = 0;*/
    end;


    /*procedure CreateJobQueueEntry()
    var
        JobQueueProcess: Record "Job Queue Category";
        JobQueueEntry: Record "Job Queue Entry";
        ESSecuritySetup: Record "ES Security Setup";
        ESNASProcessEntry: Record "ES NAS Process Entry";
    begin
        //fes mig
    
        ESNASProcessEntry.RESET;
        ESNASProcessEntry.SETRANGE(Status,ESNASProcessEntry.Status::Ready);
        ESNASProcessEntry.FIND('-');
        
        ESSecuritySetup.GET;
        ESSecuritySetup.TESTFIELD("Job Queue Code");
        JobQueueSetup.GET(ESSecuritySetup."Job Queue Code");
        
        JobQueueProcess.RESET;
        IF NOT JobQueueProcess.FIND('-') THEN
          MESSAGE(Text001,JobQueueProcess.TABLECAPTION);
        
        JobQueueEntry.INIT;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"ES NAS Handler";
        JobQueueEntry."Parameter String" := '';
        JobQueueEntry.INSERT(TRUE);
        
        MESSAGE(Text002,JobQueueEntry.TABLECAPTION,JobQueueEntry.ID);
        
        //fes mig

    end;*/


    procedure CreateNASProcessEntry(ParameterString: Text[250])
    var
    /*   ESNASProcessEntry: Record "ES NAS Process Entry"; */
    begin
        /*    ESNASProcessEntry.Init;
           ESNASProcessEntry.Insert(true);

           case UpperCase(ParameterString) of
               '1', 'SYNCHRONIZE AND PUBLISH', 'SYNCANDPUB':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::"Synchronize and Publish";
               '2', 'SYNCHRONIZE', 'SYNC':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::Synchronize;
               '3', 'PUBLISH', 'PUB':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::Publish;
               '4', 'LIVE RESTORE POINT', 'LIVERP':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::"Live Restore Point";
               '5', 'EASY SECURITY RESTORE POINT', 'ESRP':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::"Easy Security Restore Point";
               '6', 'UPDATE FLADS LOOKUP DATA', 'FLADSLD':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::"Update FLADS Lookup Data";
               '7', 'COPY FLADS SETUP DATA', 'COPYFLADSSD':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::"Copy FLADS Setup Data";
               '8', 'COPY WINDOWS GROUPS', 'COPYWINDOWSGR':
                   ESNASProcessEntry.Type := ESNASProcessEntry.Type::"Copy Windows Groups";
           end;

           ESNASProcessEntry.TestField(Type);
           ESNASProcessEntry.Status := ESNASProcessEntry.Status::Ready;
           ESNASProcessEntry.Modify; */
    end;
}

