pageextension 50032 pageextension50032 extends "Customer Ledger Entries"
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
        modify("Debit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits.';
        }
        modify("Debit Amount (LCY)")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent debits, expressed in $.';
        }
        modify("Credit Amount")
        {
            ToolTip = 'Specifies the total of the ledger entries that represent credits.';
        }
        modify("Exported to Payment File")
        {
            ToolTip = 'Specifies that the entry was created as a result of exporting a payment journal line.';
        }
        modify("Dimension Set ID")
        {
            ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
        }
        // modify("CFDI Cancellation Reason Code")
        // {
        //     Visible = false;
        // }
        // modify("Substitution Entry No.")
        // {
        //     Visible = false;
        // }
        moveafter("Document No."; "External Document No.")
        addafter("Document No.")
        {
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal Rel."; rec."No. Comprobante Fiscal Rel.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Liq. retencion"; rec."No. Comprobante Liq. retencion")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Customer Name")
        {
            field("Nombre Cliente"; rec."Nombre Cliente")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        moveafter("IC Partner Code"; "Salesperson Code")
        addafter("IC Partner Code")
        {
            field("ID Retencion Venta"; rec."ID Retencion Venta")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Amount)
        {
            field("Forma de Pago"; rec."Forma de Pago")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Agencia; rec.Agencia)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Credit Amount")
        {
            field("Collector Code"; rec."Collector Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Remaining Amt. (LCY)")
        {
            field("Cheque Posfechado"; rec."Cheque Posfechado")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Cheque Protestado"; rec."Cheque Protestado")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Entry No.")
        {
            field("Importe provisionado"; rec."Importe provisionado")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha ult. provision"; rec."Fecha ult. provision")
            {
                ApplicationArea = All;
            }
            field("Provisionado por insolvencia"; rec."Provisionado por insolvencia")
            {
                ApplicationArea = All;
            }
        }
        addafter("Dimension Set ID")
        {
            field("Date Filter"; rec."Date Filter")
            {
                ApplicationArea = Basic, Suite;
            }
            field("<TIPO CLIENTE>"; dimTIPO_CLIENTE)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TIPO CLIENTE';
                Editable = false;
            }
            field("<CAMDELEGADO>"; dimCAMDELEGADO)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'CAMPDELEGADO';
                Editable = false;
            }
        }
    }
    actions
    {
        modify(AppliedEntries)
        {
            ToolTip = 'View the ledger entries that have been applied to this record.';
        }
        modify(Customer)
        {
            ToolTip = 'View or edit detailed information about the customer.';
        }
        modify("Apply Entries")
        {
            ToolTip = 'Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
        }
        modify(SelectIncomingDoc)
        {
            ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
        }
        modify(IncomingDocAttachFile)
        {
            ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';
        }
        // modify("S&end")
        // {
        //     ToolTip = 'Send an email to the customer with the electronic invoice attached as an XML file.';
        // }
        modify("&Navigate")
        {
            ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
        }
        modify(ShowDocumentAttachment)
        {
            ToolTip = 'View documents or images that are attached to the posted invoice or credit memo.';
        }
    }

    var
        GrupoDimension: Record "Dimension Set Entry";
        dimTIPO_CLIENTE: Text;
        dimCAMDELEGADO: Text;
        GrupoDimensionValue: Record "Dimension Value";

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        GrupoDimension.SetRange("Dimension Set ID", Rec."Dimension Set ID");
        GrupoDimension.SetRange("Dimension Code", 'TIPO_CLIENTE');
        if GrupoDimension.FindFirst then begin
            repeat
                GrupoDimensionValue.SetRange("Dimension Code", GrupoDimension."Dimension Code");
                GrupoDimensionValue.SetRange(Code, GrupoDimension."Dimension Value Code");
                if GrupoDimensionValue.FindFirst then begin
                    dimTIPO_CLIENTE := GrupoDimensionValue.Code;
                    GrupoDimension.Next := 1;
                end
                else
                    dimTIPO_CLIENTE := '';
            until GrupoDimension.Next = 0;
        end;

        GrupoDimension.Reset;
        GrupoDimension.SetRange("Dimension Set ID", Rec."Dimension Set ID");
        GrupoDimension.SetRange("Dimension Code", 'CAMPDELEGADO');
        if GrupoDimension.FindFirst then begin
            repeat
                GrupoDimensionValue.Reset;
                GrupoDimensionValue.SetRange("Dimension Code", GrupoDimension."Dimension Code");
                GrupoDimensionValue.SetRange(Code, GrupoDimension."Dimension Value Code");
                if GrupoDimensionValue.FindFirst then begin
                    dimCAMDELEGADO := GrupoDimensionValue.Code;
                    GrupoDimension.Next := 1;
                end
                else
                    dimCAMDELEGADO := '';
            until GrupoDimension.Next = 0;
        end;
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec.GetFilters <> '' then
            if Rec.FindFirst then;
    end;
}

