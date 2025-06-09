tableextension 50087 tableextension50087 extends "Job Queue Entry"
{
    fields
    {
        field(75000; "Hold On Finish"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
    }


    //Unsupported feature: Code Modification on "ShowErrorMessage(PROCEDURE 8)".

    //procedure ShowErrorMessage();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    e := GetErrorMessage;
    if e = '' then
      e := NoErrMsg;
    Message('%1',e);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

    // ++ 001-YFC
    //IF rec.Status = rec.Status::Error THEN
      NotificarError.Run(Rec);
    // -- 001-YFC
    */
    //end;


    //Unsupported feature: Code Modification on "CleanupAfterExecution(PROCEDURE 11)".

    //procedure CleanupAfterExecution();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "Notify On Success" then
      CODEUNIT.Run(CODEUNIT::"Job Queue - Send Notification",Rec);

    if "Recurring Job" then begin
      ClearServiceValues;
      if Status = Status::"On Hold with Inactivity Timeout" then
        "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeHoldDuetoInactivityJob(Rec,CurrentDateTime)
      else
        "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeForRecurringJob(Rec,CurrentDateTime);
      EnqueueTask;
    end else
      Delete;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

      // + MdM
      if "Hold On Finish" then
        SetStatusValue(Status::"On Hold")
      else
      // - MdM

      ClearServiceValues;

      "Hold On Finish" := false;  //MdM

    #6..12
    */
    //end;


    var
        NotificarError: Codeunit "Notificar Errores Colas";
}

