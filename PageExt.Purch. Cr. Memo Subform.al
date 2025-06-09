pageextension 50145 pageextension50145 extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify(FilteredTypeField)
        {
            ToolTip = 'Specifies the type of transaction that will be posted with the document line. If you select Comment, then you can enter any text in the Description field, such as a message to a customer. ';
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the code for the location where the items on the line will be located.';
        }
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify(Quantity)
        {
            ToolTip = 'Specifies the number of units of the item specified on the line.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Direct Unit Cost")
        {
            ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
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
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        }
        modify("Tax Group Code")
        {
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        modify("Use Tax")
        {
            ToolTip = 'Specifies that the purchase is subject to use tax. Use tax is a sales tax that is paid on items that are purchased by a company and are used by that company instead of being sold to a customer.';
        }
        // modify("Amount Including VAT")
        // {
        //     ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated purchase lines.';
        // }
        modify("Inv. Discount Amount")
        {
            ToolTip = 'Specifies the invoice discount amount for the line.';
        }
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
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
        modify("Job Line Amount (LCY)")
        {
            ToolTip = 'Specifies the line amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            ToolTip = 'Specifies the line discount amount of the job ledger entry that is related to the purchase line.';
        }
        modify("FA Posting Type")
        {
            Visible = true;
        }
        modify("Depreciation Book Code")
        {
            ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
        }
        modify("Depr. Acquisition Cost")
        {
            ToolTip = 'Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
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
        /*         addafter("Cross-Reference No.")
                {
                    field("Cod. Vendedor"; "Cod. Vendedor")
                    {
                    }
                } */
        addafter("IC Partner Reference")
        {
            /*             field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                        {
                            ApplicationArea = Basic, Suite;
                        } */
            field("Posting Group"; rec."Posting Group")
            {
                ApplicationArea = All;

            }
        }
    }
    actions
    {
        modify(InsertExtTexts)
        {
            ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';
        }
        modify("E&xplode BOM")
        {
            ToolTip = 'Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.';
        }
        modify("Event")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify("Item Charge &Assignment")
        {
            ToolTip = 'Assign additional direct costs, for example for freight, to the item on the line.';
        }
        modify("Item &Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
    }
}

