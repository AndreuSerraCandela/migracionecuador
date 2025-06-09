table 56200 "Async NAV WS Process Queue"
{
    // Dynamics.is - Gunnar Ðór Gestsson


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Process Code"; Code[50])
        {
        }
        field(3; "Process Data"; BLOB)
        {
        }
        field(4; "Process Status"; Option)
        {
            OptionMembers = Requested,Pending,Completed,Error;
        }
        field(5; "Process Response"; BLOB)
        {
        }
        field(6; "Process Start Date & Time"; DateTime)
        {
        }
        field(7; "Process End Date & Time"; DateTime)
        {
        }
        field(8; "Process User Id"; Code[50])
        {
        }
        field(9; "URL Web Service"; Text[150])
        {
        }
        field(10; "Soap Action"; Text[50])
        {
        }
        field(11; "Received Data"; BLOB)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetProcessData() ProcessData: Text
    var
        InStr: InStream;
        ReadPart: Text;
    begin
        if not "Process Data".HasValue then exit('');
        CalcFields("Process Data");
        "Process Data".CreateInStream(InStr);
        while InStr.ReadText(ReadPart) > 0 do
            ProcessData += ReadPart;
    end;


    procedure SetProcessData(ProcessData: Text)
    var
        OutStr: OutStream;
    begin
        Clear("Process Data");
        "Process Data".CreateOutStream(OutStr);
        OutStr.WriteText(ProcessData);
    end;


    procedure GetProcessResponse() ProcessResponse: Text
    var
        InStr: InStream;
        ReadPart: Text;
    begin
        if not "Process Response".HasValue then exit('');
        CalcFields("Process Response");
        "Process Response".CreateInStream(InStr);
        while InStr.ReadText(ReadPart) > 0 do
            ProcessResponse += ReadPart;
    end;


    procedure SetProcessResponse(ProcessResponse: Text)
    var
        OutStr: OutStream;
    begin
        Clear("Process Response");
        "Process Response".CreateOutStream(OutStr);
        OutStr.WriteText(ProcessResponse);
    end;


    procedure GetReceivedData() ReceivedData: Text
    var
        InStr: InStream;
        ReadPart: Text;
    begin
        //+#101415
        if not "Received Data".HasValue then exit('');
        CalcFields("Received Data");
        "Received Data".CreateInStream(InStr);
        while InStr.ReadText(ReadPart) > 0 do
            ReceivedData += ReadPart;
    end;
}

