pageextension 50063 pageextension50063 extends "Issued Finance Charge Memo"
{
    Caption = 'Issued Finance Charge Memo';
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
        addafter("No. Printed")
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
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
    }
}

