pageextension 50010 pageextension50010 extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify(Quantity)
        {
            ToolTip = 'Specifies the number of units of the item specified on the line.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Unit Price")
        {
            ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
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
        modify("Line Discount Amount")
        {
            Visible = true;
        }
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
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
        addafter("Tax Liable")
        {
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("ShortcutDimCode[8]")
        {
            /*           field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                      {
                          ApplicationArea = Basic, Suite;
                      }
                      field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                      {
                          ApplicationArea = Basic, Suite;
                      } */
            field(ClasDev; rec.ClasDev)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Appl.-from Item Entry"; rec."Appl.-from Item Entry")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify(ItemShipmentLines)
        {
            ToolTip = 'View posted sales shipments for the item.';
        }
    }
}

