tableextension 50110 tableextension50110 extends "Item Reference"
{

    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ("Cross-Reference Type No." <> '') and
       ("Cross-Reference Type" = "Cross-Reference Type"::" ")
    then
    #4..6
    if "Unit of Measure" = '' then
      Validate("Unit of Measure",Item."Base Unit of Measure");
    CreateItemVendor;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9

    //001
    ValidaCodBarra;
    //001
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*

    //001
    ValidaCodBarra;
    //001
    */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if ("Cross-Reference Type No." <> '') and
       ("Cross-Reference Type" = "Cross-Reference Type"::" ")
    then
    #4..10
      if "Cross-Reference Type" = "Cross-Reference Type"::Vendor then
        CreateItemVendor;
    end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //001
    ValidaCodBarra;
    //001

    #1..13
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateItemVendorNo(PROCEDURE 3)".

    //procedure UpdateItemVendorNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if not MultipleCrossReferencesExist(ItemCrossReference) then
      if ItemVend.Get(ItemCrossReference."Cross-Reference Type No.",ItemCrossReference."Item No.",ItemCrossReference."Variant Code") then begin
        ItemVend."Vendor Item No." := NewCrossRefNo;
        ItemVend.Modify;
      end;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    if not MultipleCrossReferencesExist(ItemCrossReference) then
      if ItemVend.Get(ItemCrossReference."Cross-Reference Type No.",ItemCrossReference."Item No.",ItemCrossReference."Variant Code") then begin
        ItemVend.Validate("Vendor Item No.",NewCrossRefNo);
        ItemVend.Modify;
      end;
    */
    //end;

    procedure ValidaCodBarra()
    begin
        //001
        if "Reference Type" = "Reference Type"::"Bar Code" then begin
            rItemCrossRef.Reset;
            rItemCrossRef.SetRange("Reference Type", rItemCrossRef."Reference Type"::"Bar Code");
            rItemCrossRef.SetRange(rItemCrossRef."Reference No.", "Reference No.");
            if rItemCrossRef.FindFirst then
                Error(Error001);
        end;
        //001
    end;

    var
        rItemCrossRef: Record "Item Reference";
        Error001: Label 'Barcode already exist';
}

