pageextension 50050 pageextension50050 extends "General Journal"
{
    layout
    {
        modify(CurrentJnlBatchName)
        {
            ToolTip = 'Specifies the name of the journal batch.';
        }
        modify("<Document No. Simple Page>")
        {
            ToolTip = 'Specifies a document number for the journal line.';
        }
        modify("Document Date")
        {
            ToolTip = 'Specifies the date on the document that provides the basis for the entry on the journal line.';
        }
        modify("Document No.")
        {
            ToolTip = 'Specifies a document number for the journal line.';
        }
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
        }
        addafter("External Document No.")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
            field("Fecha vencimiento NCF"; rec."Fecha vencimiento NCF")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
        }
        addafter(Description)
        {
            field("Line No."; rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("RUC/Cedula"; rec."RUC/Cedula")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Fecha Caducidad"; rec."Fecha Caducidad")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("Cod. Retencion"; rec."Cod. Retencion")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
        }
    }
    actions
    {
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify(PostAndPrint)
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        modify(ImportBankStatement)
        {
            ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.';
        }
        modify(ShowStatementLineDetails)
        {
            ToolTip = 'View the content of the imported bank statement file, such as account number, posting date, and amounts.';
        }
        modify(Match)
        {
            ToolTip = 'Apply payments to their related open entries based on data matches between bank transaction text and entry information.';
        }
        modify(AddMappingRule)
        {
            ToolTip = 'Associate text on payments with debit, credit, and balancing accounts, so payments are posted to the accounts when you post payments. The payments are not applied to invoices or credit memos, and are suited for recurring cash receipts or expenses.';
        }
        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
    }
}