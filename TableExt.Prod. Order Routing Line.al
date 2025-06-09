tableextension 50106 tableextension50106 extends "Prod. Order Routing Line"
{
    fields
    {
        modify("Work Center Group Code")
        {
            Caption = 'Work Center Group Code';
        }
        modify("Expected Operation Cost Amt.")
        {
            Caption = 'Expected Operation Cost Amt.';
        }
    }

    //Unsupported feature: Code Modification on "ShiftTimeForwardOnParentProdOrderLines(PROCEDURE 29)".

    //procedure ShiftTimeForwardOnParentProdOrderLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ParentProdOrderLine.SetRange(Status,ChildProdOrderLine.Status);
    ParentProdOrderLine.SetRange("Prod. Order No.",ChildProdOrderLine."Prod. Order No.");
    ParentProdOrderLine.SetRange("Planning Level Code",ChildProdOrderLine."Planning Level Code" - 1);
    #4..11
          if GuiAllowed then
            ShowMessage(TimeShiftedOnParentLineMsg);
          ParentProdOrderLine.Validate("Starting Date-Time",ChildProdOrderLine."Ending Date-Time");
          if ParentProdOrderLine."Planning Level Code" = 0 then
            ReservationCheckDateConfl.ProdOrderLineCheck(ParentProdOrderLine,true);

          if ParentProdOrderLine."Ending Date-Time" < ParentProdOrderLine."Starting Date-Time" then
            ParentProdOrderLine."Ending Date-Time" := ParentProdOrderLine."Starting Date-Time";
          ParentProdOrderLine.Modify(true);
          ShiftTimeForwardOnParentProdOrderLines(ParentProdOrderLine);
        end;
      until ParentProdOrderLine.Next = 0;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    #18..23
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "ShiftTimeForwardOnParentProdOrderLines(PROCEDURE 29).ReservationCheckDateConfl(Variable 1002)".

}

