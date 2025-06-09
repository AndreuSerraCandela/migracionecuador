pageextension 50096 pageextension50096 extends "Fixed Asset G/L Journal"
{
    layout
    {
        modify("Document Type")
        {
            ToolTip = 'Specifies the appropriate document type for the amount you want to post.';
        }
        modify("Document No.")
        {
            ToolTip = 'Specifies a document number for the journal line.';
        }
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
        }
        modify("Account Type")
        {
            ToolTip = 'Specifies the type of account that the entry on the journal line will be posted to.';
        }
        modify("Salespers./Purch. Code")
        {
            ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
        }
        modify("Gen. Bus. Posting Group")
        {
            ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
        }
        modify("VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("VAT Prod. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("Debit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits.';
        }
        modify("Credit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent credits.';
        }
        modify("Bal. VAT Difference")
        {
            ToolTip = 'Specifies the difference between the calculate Tax amount and the Tax amount that you have entered manually.';
        }
        modify("Bal. Gen. Posting Type")
        {
            ToolTip = 'Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
        }
        modify("Bal. VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.';
        }
        modify("Bal. VAT Prod. Posting Group")
        {
            ToolTip = 'Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.';
        }
        modify("Applies-to Doc. Type")
        {
            ToolTip = 'Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify("Applies-to Doc. No.")
        {
            ToolTip = 'Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
        }
        modify("Applies-to ID")
        {
            ToolTip = 'Specifies the ID of entries that will be applied to when you choose the Apply Entries action.';
        }
        modify("Depr. Acquisition Cost")
        {
            ToolTip = 'Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
        }
        modify("Budgeted FA No.")
        {
            ToolTip = 'Specifies the number of a fixed asset with the Budgeted Asset check box selected. When you post the journal or document line, an additional entry is created for the budgeted fixed asset where the amount has the opposite sign.';
        }
        modify("Duplicate in Depreciation Book")
        {
            ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
        }
        modify("Use Duplication List")
        {
            ToolTip = 'Specifies whether the line is to be posted to all depreciation books, using different journal batches and with a check mark in the Part of Duplication List field.';
        }
        modify("FA Reclassification Entry")
        {
            ToolTip = 'Specifies if the entry was generated from a fixed asset reclassification journal.';
        }
        modify("FA Error Entry No.")
        {
            ToolTip = 'Specifies the number of a posted FA ledger entry to mark as an error entry.';
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
            ToolTip = 'Specifies the dimension value code linked to the journal line.';
        }
        modify(ShortcutDimCode4)
        {
            ToolTip = 'Specifies the dimension value code linked to the journal line.';
        }
        modify(ShortcutDimCode5)
        {
            ToolTip = 'Specifies the dimension value code linked to the journal line.';
        }
        modify(ShortcutDimCode6)
        {
            ToolTip = 'Specifies the dimension value code linked to the journal line.';
        }
        modify(ShortcutDimCode7)
        {
            ToolTip = 'Specifies the dimension value code linked to the journal line.';
        }
        modify(ShortcutDimCode8)
        {
            ToolTip = 'Specifies the dimension value code linked to the journal line.';
        }

        modify(BalAccountName)
        {
            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
        }
        addfirst(Control1)
        {
            field("Line No."; rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Amount)
        {
            field("Job No."; rec."Job No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Job Task No."; rec."Job Task No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
    }
}

