pageextension 50061 pageextension50061 extends "Finance Charge Memo"
{
    layout
    {
        modify("Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        addafter("Assigned User ID")
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
            ApplicationArea = All;
            }
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
            ApplicationArea = All;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
            ApplicationArea = All;
            }
            field("Fecha vencimiento NCF"; rec."Fecha vencimiento NCF")
            {
            ApplicationArea = All;
            }
            field("Tipo de ingreso"; rec."Tipo de ingreso")
            {
            ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify(CreateFinanceChargeMemos)
        {
            ToolTip = 'Create finance charge memos for one or more customers with overdue payments.';
        }
        modify(SuggestFinChargeMemoLines)
        {
            Caption = 'Suggest Fin. Charge Memo Lines';
        }
        modify(TestReport)
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Customer - Balance to Date")
        {
            Caption = 'Customer - Balance to Date';
            ToolTip = 'View a list with customers'' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';
        }
        modify("Customer - Detail Trial Bal.")
        {
            Caption = 'Customer - Detail Trial Bal.';
            ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';
        }
    }
}

