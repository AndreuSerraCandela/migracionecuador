pageextension 50092 pageextension50092 extends "Item Units of Measure"
{
    layout
    {
        modify(Control1)
        {
            Editable = wEditableMdM;
        }
        modify("Qty. per Unit of Measure")
        {
            ToolTip = 'Specifies how many of the base unit of measure are contained in one unit of the item.';
        }
        modify(Weight)
        {
            Enabled = wEditableMdM;
        }
        modify(ItemUnitOfMeasure)
        {
            Editable = wEditableMdM;
        }
    }
    var
        lrProd: Record Item;

    var
        wEditableMdM: Boolean;
        cFunMdm: Codeunit "Funciones MdM";

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        // <MdM>
        if lrProd.Get(Rec."Item No.") then
            wEditableMdM := cFunMdm.GetEditableP(lrProd, true)
        else
            wEditableMdM := cFunMdm.GetEditable;
        // </MdM>
    end;
}

