tableextension 50021 tableextension50021 extends Job
{
    fields
    {
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }

        //Unsupported feature: Property Modification (Data type) on ""Bill-to City"(Field 61)".


        //Unsupported feature: Code Modification on "Status(Field 19).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if xRec.Status <> Status then begin
          if Status = Status::Completed then
            Validate(Complete,true);
          if xRec.Status = xRec.Status::Completed then
            if DIALOG.Confirm(StatusChangeQst) then
              Validate(Complete,false)
            else
              Status := xRec.Status;
          Modify;
          JobPlanningLine.SetCurrentKey("Job No.");
          JobPlanningLine.SetRange("Job No.","No.");
          if JobPlanningLine.FindSet then begin
            if CheckReservationEntries then
              repeat
                JobPlanningLineReserve.DeleteLine(JobPlanningLine);
              until JobPlanningLine.Next = 0;
            JobPlanningLine.ModifyAll(Status,Status);
            PerformAutoReserve(JobPlanningLine);
          end;
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..11
          JobPlanningLine.ModifyAll(Status,Status);
        end;
        */
        //end;
    }
}

