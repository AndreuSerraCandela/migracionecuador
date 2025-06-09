pageextension 50115 pageextension50115 extends "Sales Return Order Subform"
{
    layout
    {
        modify("IC Partner Ref. Type")
        {
            ToolTip = 'Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on "Description(Control 6)".

        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Unit Cost (LCY)")
        {
            ToolTip = 'Specifies the unit cost of the item on the line.';
        }
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area code for the customer.';
        }
        modify("Tax Group Code")
        {
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        modify("Allow Invoice Disc.")
        {
            ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
        }
        modify("Quantity Invoiced")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Appl.-from Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
        }
        modify("Appl.-to Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify(ShortcutDimCode3)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 3.';
        }
        modify(ShortcutDimCode4)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 4.';
        }
        modify(ShortcutDimCode5)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 5.';
        }
        modify(ShortcutDimCode6)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 6.';
        }
        modify(ShortcutDimCode7)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 7.';
        }
        modify(ShortcutDimCode8)
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 8.';
        }
        modify("Invoice Discount Amount")
        {
            ToolTip = 'Specifies a discount amount that is deducted from the value in the Total Incl. Tax field. You can enter or change the amount manually.';
        }
        modify("Invoice Disc. Pct.")
        {
            ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';
        }
        modify("Total Amount Excl. VAT")
        {
            ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
        }
        modify("Total VAT Amount")
        {
            ToolTip = 'Specifies the sum of Tax amounts on all lines in the document.';
        }
        modify("Total Amount Incl. VAT")
        {
            ToolTip = 'Specifies the sum of the value in the Line Amount Incl. Tax field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
        }
        addafter(Quantity)
        {
            field("Clas Dev"; rec."Clas Dev")
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
        modify(Reserve)
        {
            ToolTip = 'Reserve the quantity that is required on the document line that you opened this window for.';
        }
        modify("Order &Tracking")
        {
            ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';
        }
        modify("Item Charge &Assignment")
        {
            ToolTip = 'Assign additional direct costs, for example for freight, to the item on the line.';
        }
        modify(ItemTrackingLines)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify(DeferralSchedule)
        {
            ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';
        }
        addafter("Order &Tracking")
        {
            separator(Action1000000000)
            {
            }
            action("<Action1000000001>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'D&istribuir Cargos a Productos';

                trigger OnAction()
                begin
                    //001
                    SplitIC;
                    //001
                end;
            }
        }
    }

    procedure SplitIC()
    var
        SalesLinSIC: Record "Sales Line";
    begin
        CurrPage.SetSelectionFilter(SalesLinSIC);
        REPORT.Run(REPORT::"Split Sales Item Charge.", false, false, SalesLinSIC);
    end;
}

