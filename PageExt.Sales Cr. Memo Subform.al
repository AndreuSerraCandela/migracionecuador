pageextension 50144 pageextension50144 extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("No.")
        {
            ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
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
        modify("Unit Price")
        {
            ToolTip = 'Specifies the price for one unit on the sales line.';
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
        // modify("Amount Including VAT")
        // {
        //     ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated sales lines.';
        // }
        modify("Inv. Discount Amount")
        {
            ToolTip = 'Specifies the invoice discount amount for the line.';
        }
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
        }
        modify("Appl.-from Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
        }
        modify("Appl.-to Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
        }
        modify("Deferral Code")
        {
            ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("TotalSalesLine.""Line Amount""")
        {
            ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document.';
        }
        modify("Invoice Disc. Pct.")
        {
            ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';
        }

        // modify("Retention Attached to Line No.")
        // {
        //     Visible = false;
        // }
        // modify("Retention VAT %")
        // {
        //     Visible = false;
        // }
        addafter("Line Amount")
        {

        }
    }
    actions
    {
        modify(InsertExtTexts)
        {
            ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';
        }
        modify(DeferralSchedule)
        {
            ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';
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
        modify(ItemTrackingLines)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
    }


    // trigger OnOpenPage()
    // var
    //     einvoiceMgt: Codeunit "E-Invoice Mgt.";
    // begin
    //     // Obtener la configuración de ventas


    //     // Verificar si el entorno PAC está habilitado
    //     /*       IsPACEnabled := EInvoiceMgt.IsPACEnvironmentEnabled; */
    // end;
}

