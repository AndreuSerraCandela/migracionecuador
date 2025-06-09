pageextension 50043 pageextension50043 extends "Assembly BOM"
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
        addfirst(Control1)
        {
            field("Parent Item No."; rec."Parent Item No.")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
    }
    actions
    {
        modify("E&xplode BOM")
        {
            ToolTip = 'Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.';
        }
        modify(CalcUnitPrice)
        {
            ToolTip = 'Calculate the unit price based on the unit cost and the profit percentage.';
        }
        modify("Cost Shares")
        {
            ToolTip = 'View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.';
        }
    }

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;


    trigger OnOpenPage()
    var
        lrProd: Record Item;
    begin
        // <MdM>
        if lrProd.Get(Rec."Parent Item No.") then
            wEditable := cFunMdm.GetEditableP(lrProd, false)
        else
            wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;
        // </MdM>
    end;
}

