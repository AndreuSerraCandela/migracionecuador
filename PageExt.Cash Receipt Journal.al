pageextension 50033 pageextension50033 extends "Cash Receipt Journal"
{
    layout
    {
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
            ToolTip = 'Specifies the salesperson or purchaser who is linked to the journal line.';
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
        modify("Amount (LCY)")
        {
            ToolTip = 'Specifies the total amount in local currency (including Tax) that the journal line consists of.';
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
            ToolTip = 'Specifies the difference between the calculate tax amount and the tax amount that you have entered manually.';
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
        modify(Correction)
        {
            ToolTip = 'Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify(BalAccName)
        {
            ToolTip = 'Specifies the name of the balancing account that has been entered on the journal line.';
        }
        addafter(Description)
        {
            field("Forma de Pago"; rec."Forma de Pago")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Agencia; rec.Agencia)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Collector Code"; rec."Collector Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Due Date"; rec."Due Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Currency Code")
        {
            field("Cheque Posfechado"; rec."Cheque Posfechado")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("ID Retencion Venta"; rec."ID Retencion Venta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Retencion Venta"; rec."Retencion Venta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Retención"; rec."Tipo Retención")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify(IncomingDoc)
        {
            ToolTip = 'View or create an incoming document record that is linked to the entry or document.';
        }
        /*modify("Insert Conv. $ Rndg. Lines") //nuevo grupo validar y traer funcionalidad de nav
        {
            ToolTip = 'Insert a rounding correction line in the journal. This rounding correction line will balance in $ when amounts in the foreign currency also balance. You can then post the journal.';
        }*/
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        /*        modify(CreateFlow)
               {
                   ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
               } */
        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
    }
}

