pageextension 50117 pageextension50117 extends "Price List Lines"
{
    layout
    {

        modify(Control1)
        {
            Editable = wEditable;
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Unit Price")
        {
            ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
        }
    }
    var
        lrProd: Record Item;

    var
        "***Santillana***": Integer;
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;


    //Unsupported feature: Code Insertion on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //begin
    /*

    if not wEditable then // MdM
      cFunMdm.SetEditableError(TableCaption);
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //begin
    /*

    if not wEditable then // MdM
      cFunMdm.SetEditableError(TableCaption);
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModifyRecord".

    //trigger OnModifyRecord(): Boolean
    //begin
    /*

    if not wEditable then // MdM
      cFunMdm.SetEditableError(TableCaption);
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: lrProd)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsOnMobile := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone;
    GetRecFilters;
    SetRecFilters;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3

    // <MdM>
    if lrProd.Get("Item No.") then
      wEditable := cFunMdm.GetEditableP(lrProd, true)
    else
      wEditable := cFunMdm.GetEditable;
    CurrPage.Editable := wEditable;
    // </MdM>
    */
    //end;
}

