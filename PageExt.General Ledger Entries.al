pageextension 50028 pageextension50028 extends "General Ledger Entries"
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Global Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
        }
        modify("Gen. Bus. Posting Group")
        {
            ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
        }
        modify("FA Entry Type")
        {
            ToolTip = 'Specifies the number of the fixed asset entry.';
        }
        modify("FA Entry No.")
        {
            ToolTip = 'Specifies the number of the fixed asset entry.';
        }
        modify("Dimension Set ID")
        {
            ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
        }
        modify("Source Code")
        {
            Visible = false;
        }
        addafter("Posting Date")
        {
            field("System-Created Entry"; rec."System-Created Entry")
            {
                ApplicationArea = Basic, Suite;
            }
            //Se agregan con Modify para dejarlos no visibles "Source Code"
            field("Cod. Vendedor"; rec."Cod. Vendedor")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter("Document Type"; "Source Type", "Source No.")
        addafter("Document Type")
        {
            field("Document Date"; rec."Document Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter("Document No."; "External Document No.")
        addafter("Document No.")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = Basic, Suite;
            }
            field(RNC; rec.RNC)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("G/L Account No.")
        {
            field("ID Retencion"; rec."ID Retencion")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Entry No.")
        {
            field("Transaction No."; rec."Transaction No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo de Comprobante"; rec."Tipo de Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sustento del Comprobante"; rec."Sustento del Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Comprobante"; rec."No. Autorizacion Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Caducidad"; rec."Fecha Caducidad")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Retencion"; rec."Cod. Retencion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Caja Chica"; rec."Caja Chica")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Cuenta Original"; rec."No. Cuenta Original")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Beneficiario; rec.Beneficiario)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.GetFilters <> '' then
            if Rec.FindFirst then;
    end;
}

