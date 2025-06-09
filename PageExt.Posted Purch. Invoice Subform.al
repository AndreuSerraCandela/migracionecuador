pageextension 50014 pageextension50014 extends "Posted Purch. Invoice Subform"
{
    layout
    {
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
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
        }
        modify("Depr. Acquisition Cost")
        {
            ToolTip = 'Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        addafter("Unit of Measure Code")
        {
        }
        addafter("Indirect Cost %")
        {

        }
        addafter("Tax Liable")
        {
            /*  field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
             {
                 ApplicationArea = Basic, Suite;
             } */
            field("Parte del IVA"; rec."Parte del IVA")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Posting Group"; rec."Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Propina; rec.Propina)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify(DeferralSchedule)
        {
            ToolTip = 'View the deferral schedule that governs how expenses paid with this purchase document were deferred to different accounting periods when the document was posted.';
        }
    }
}

