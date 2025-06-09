tableextension 50127 tableextension50127 extends "Service Line"
{
    fields
    {
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Attached to Line No.")
        {
            Caption = 'Attached to Line No.';
        }
        modify("Area")
        {
            Caption = 'Area';
        }
        modify("VAT Bus. Posting Group")
        {
            Caption = 'VAT Bus. Posting Group';
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Job Planning Line No.")
        {
            Caption = 'Job Planning Line No.';
        }
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        modify("Whse. Outstanding Qty. (Base)")
        {
            Caption = 'Whse. Outstanding Qty. (Base)';
        }
        field(76042; "Tipo de bien-servicio"; Option)
        {
            Caption = 'Type of Good/Service';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
            OptionCaption = 'Good,Service,Selective,Tips,Other';
            OptionMembers = Bienes,Servicios,"Selectivo al consumo","Propina legal",Otros;
        }
    }


    //Unsupported feature: Code Modification on "UpdateDimSetupByDefaultDim(PROCEDURE 95)".

    //procedure UpdateDimSetupByDefaultDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if SourceNo = '' then
      exit;

    SourceCodeSetup.Get;
    DefaultDimensionPriority.SetRange("Source Code",SourceCodeSetup."Service Management");
    DefaultDimensionPriority.SetRange("Table ID",SourceID);
    if DefaultDimensionPriority.IsEmpty then
      exit;

    DefaultDim.SetRange("Table ID",SourceID);
    DefaultDim.SetRange("No.",SourceNo);
    if DefaultDim.FindSet then
    #13..17
          TableAdded := true;
        end;
      until (DefaultDim.Next = 0) or TableAdded;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    #10..20
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "UpdateDimSetupByDefaultDim(PROCEDURE 95).SourceCodeSetup(Variable 1009)".


    //Unsupported feature: Deletion (VariableCollection) on "UpdateDimSetupByDefaultDim(PROCEDURE 95).DefaultDimensionPriority(Variable 1008)".
}

