pageextension 50090 pageextension50090 extends "Purchase Order Subform"
{
    layout
    {
        modify("No.")
        {
            ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
        }
        modify("IC Partner Ref. Type")
        {
            ToolTip = 'Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
        }
        modify(Description)
        {
            ToolTip = 'Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.';
        }
        modify(Quantity)
        {
            ToolTip = 'Specifies the number of units of the item specified on the line.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
        }
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if this vendor charges you sales tax for purchases.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        }
        modify("Tax Group Code")
        {
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        modify("Use Tax")
        {
            ToolTip = 'Specifies a U.S. sales tax that is paid on items purchased by a company that are used by the company, instead of being sold to a customer.';
        }
        modify("Allow Invoice Disc.")
        {
            ToolTip = 'Specifies if the invoice line is included when the invoice discount is calculated.';
        }
        modify("Inv. Discount Amount")
        {
            ToolTip = 'Specifies the total calculated invoice discount amount for the line.';
        }
        modify("Quantity Received")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
        }
        modify("Quantity Invoiced")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
        }
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
        }
        modify("Job Planning Line No.")
        {
            ToolTip = 'Specifies the job planning line number to which the usage should be linked when the Job Journal is posted. You can only link to Job Planning Lines that have the Apply Usage Link option enabled.';
        }
        modify("Job Line Type")
        {
            ToolTip = 'Specifies the type of planning line that was created when the job ledger entry is posted from the purchase line. If the field is empty, no planning lines were created for this entry.';
        }
        modify("Job Unit Price")
        {
            ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
        }
        modify("Job Line Amount")
        {
            ToolTip = 'Specifies the line amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Discount Amount")
        {
            ToolTip = 'Specifies the line discount amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Discount %")
        {
            ToolTip = 'Specifies the line discount percentage of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Unit Price (LCY)")
        {
            ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
        }
        modify("Job Total Price (LCY)")
        {
            ToolTip = 'Specifies the gross amount of the line, in the local currency.';
        }
        modify("Job Line Amount (LCY)")
        {
            ToolTip = 'Specifies the line amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            ToolTip = 'Specifies the line discount amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Appl.-to Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
        }
        modify("Deferral Code")
        {
            ToolTip = 'Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Invoice Discount Amount")
        {
            ToolTip = 'Specifies the amount that is calculated and shown in the Invoice Discount Amount field. The invoice discount amount is deducted from the value shown in the Total Amount Incl. Tax field.';
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
        addafter("VAT Prod. Posting Group")
        {

        }
    }
    actions
    {
        modify("Event")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify("Reservation Entries")
        {
            ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';
        }
        modify("Item Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify(ItemChargeAssignment)
        {
            ToolTip = 'Assign additional direct costs, for example for freight, to the item on the line.';
        }
        modify(DeferralSchedule)
        {
            ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';
        }
        modify("E&xplode BOM")
        {
            ToolTip = 'Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.';
        }
        modify("Insert Ext. Texts")
        {
            ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';
        }
        modify(Reserve)
        {
            ToolTip = 'Reserve the quantity that is required on the document line that you opened this window for.';
        }
        modify(OrderTracking)
        {
            ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';
        }
        modify("Sales &Order")
        {
            ToolTip = 'Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.';
        }
        modify(Action1901038504)
        {
            ToolTip = 'Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.';
        }
        modify(BlanketOrder)
        {
            ToolTip = 'View the blanket purchase order.';
        }
        addafter("Item Tracking Lines")
        {
            action("&Item Charges Split")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Item Charges Split';
                Image = Split;


                trigger OnAction()
                begin
                    //001
                    SplitIC;
                end;
            }
        }
    }

    procedure SplitIC()
    var
        PurchLinSIC: Record "Purchase Line";
    begin
        CurrPage.SetSelectionFilter(PurchLinSIC);
        REPORT.Run(REPORT::"Split Item Charge", false, false, PurchLinSIC);
    end;

    procedure Distribucion()
    var
        PurchLin: Record "Purchase Line";
    begin
        CurrPage.SetSelectionFilter(PurchLin);
        REPORT.Run(REPORT::"Split CC Distribution", false, false, PurchLin);
    end;
}

