pageextension 50137 pageextension50137 extends "Posted Assembly Order"
{
    layout
    {
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Unit Cost")
        {
            ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
        }
    }
    actions
    {
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify("Item &Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify(Print)
        {
            ToolTip = 'Print the information in the window. A print request window opens where you can specify what to include on the print-out.';
        }
        modify(Navigate)
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify("Undo Post")
        {
            Enabled = UndoPostEnabledExpr;
        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //+#14195
        UndoPostEnabledExpr := not Rec."Revertido completamente" and not Rec.IsAsmToOrder;
        //-#14195
    end;

    var
        UndoPostEnabledExpr: Boolean;
}

