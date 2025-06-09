tableextension 50119 tableextension50119 extends "Warehouse Activity Header"
{

    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: lrWarehouseSetUp)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "No." = '' then begin
      TestNoSeries;
      NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
    end;

    NoSeriesMgt.SetDefaultSeries("Registering No. Series",GetRegisteringNoSeriesCode);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6

    //+#458785
    if Type = Type::Pick then
      if "Sorting Method" = "Sorting Method"::" " then
        if lrWarehouseSetUp.FindFirst then
          if lrWarehouseSetUp."Metodo clasificacion defecto" <> lrWarehouseSetUp."Metodo clasificacion defecto"::" " then
            "Sorting Method" := lrWarehouseSetUp."Metodo clasificacion defecto";
    //-#458785
    */
    //end;


    //Unsupported feature: Code Modification on "SortLinesBinShelf(PROCEDURE 12)".

    //procedure SortLinesBinShelf();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TempWarehouseActivityLine.DeleteAll;
    SeqNo := 0;
    WarehouseActivityLineLocal.Copy(WarehouseActivityLineParam);
    #4..15
    until WarehouseActivityLineLocal.Next = 0;
    case SortOrder of
      SortOrder::Bin:
        TempWarehouseActivityLine.SetCurrentKey("Activity Type","No.","Bin Code","Shelf No.");
      SortOrder::Shelf:
        TempWarehouseActivityLine.SetCurrentKey("Activity Type","No.","Shelf No.");
    end;
    #23..36
        end;
    until TempWarehouseActivityLine.Next = 0;
    SeqNo := NewSequenceNo;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..18
        TempWarehouseActivityLine.SetCurrentKey("Activity Type","No.","Bin Code");
    #20..39
    */
    //end;

    var
        lrWarehouseSetUp: Record "Warehouse Setup";
}

