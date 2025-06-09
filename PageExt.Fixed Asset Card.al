pageextension 50094 pageextension50094 extends "Fixed Asset Card"
{
    layout
    {
        modify(DepreciationBookCode)
        {
            ToolTip = 'Specifies the depreciation book that is assigned to the fixed asset.';
            Editable = true; //Ya no toma la variable como indicador si es o no editable
        }
        modify(DepreciationTableCode)
        {
            ToolTip = 'Specifies the code of the depreciation table to use if you have selected the User-Defined option in the Depreciation Method field.';
        }
        modify("Budgeted Asset")
        {
            Visible = false;
        }
        // modify("Electronic Document")
        // {
        //     Visible = false;
        // }
        // modify("Vehicle Licence Plate")
        // {
        //     Visible = false;
        // }
        // modify("Vehicle Year")
        // {
        //     Visible = false;
        // }
        // modify("SAT Federal Autotransport")
        // {
        //     Visible = false;
        // }
        // modify("SAT Trailer Type")
        // {
        //     Visible = false;
        // }
        addafter(Description)
        {
            field("Description 2"; rec."Description 2")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Serial No.")
        {
            field("Cod. Barras"; rec."Cod. Barras")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }


    //Code Modification on "ShowAcquireNotification(PROCEDURE 7)". 
    //Ya no existe este metodo se había cambiado la siguiente línea
    //ShowAcquireNotification :=
    //(not Acquired) and FieldsForAcquitionInGeneralGroupAreCompleted and AtLeastOneDepreciationLineIsComplete;

}

