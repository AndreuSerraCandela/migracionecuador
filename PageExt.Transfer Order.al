pageextension 50102 pageextension50102 extends "Transfer Order"
{

    //Unsupported feature: Property Insertion (InsertAllowed) on ""Transfer Order"(Page 5740)".

    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify("Transfer-from Name 2")
        {
            ToolTip = 'Specifies an additional part of the name of the sender at the location that the items are transferred from.';
        }
        modify("Transfer-from Address 2")
        {
            ToolTip = 'Specifies an additional part of the address of the location that items are transferred from.';
        }
        modify("Transfer-to Name 2")
        {
            ToolTip = 'Specifies an additional part of the name of the recipient at the location that the items are transferred to.';
        }
        modify("Transfer-to Address 2")
        {
            ToolTip = 'Specifies an additional part of the address of the location that the items are transferred to.';
        }
        modify("Transfer-to Post Code")
        {
            ToolTip = 'Specifies the ZIP Code of the location that the items are transferred to.';
        }
        modify("Inbound Whse. Handling Time")
        {
            ToolTip = 'Specifies the time it takes to make items part of available inventory, after the items have been posted as received.';
        }
        modify("Transport Method")
        {
            ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
        }
        modify("Partner VAT ID")
        {
            Visible = false;
        }
        // modify(ElectronicDocument)
        // {
        //     Visible = false;
        // }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // modify("Transport Operators")
        // {
        //     Visible = false;
        // }
        // modify("Transit-from Date/Time")
        // {
        //     Visible = false;
        // }
        // modify("Transit Hours")
        // {
        //     Visible = false;
        // }
        // modify("Transit Distance")
        // {
        //     Visible = false;
        // }
        // modify("Vehicle Code")
        // {
        //     Visible = false;
        // }
        // modify("Trailer 1")
        // {
        //     Visible = false;
        // }
        // modify("Trailer 2")
        // {
        //     Visible = false;
        // }
        // modify(Control1310002)
        // {
        //     Visible = false;
        // }
        // modify("Insurer Name")
        // {
        //     Visible = false;
        // }
        // modify("Insurer Policy Number")
        // {
        //     Visible = false;
        // }
        // modify("Medical Insurer Name")
        // {
        //     Visible = false;
        // }
        // modify("Medical Ins. Policy Number")
        // {
        //     Visible = false;
        // }
        // modify("SAT Weight Unit Of Measure")
        // {
        //     Visible = false;
        // }
        addafter(Status)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Serie Comprobante Fiscal"; rec."No. Serie Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Vendedor"; rec."Cod. Vendedor")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Aprobacion"; rec."Fecha Aprobacion")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Hora Aprobacion"; rec."Hora Aprobacion")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Usuario Aprobacion"; rec."Usuario Aprobacion")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
            field("Fecha Creacion Pedido"; rec."Fecha Creacion Pedido")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
            }
        }
    }
    actions
    {
        modify("In&vt. Put-away/Pick Lines")
        {
            ToolTip = 'View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.';
        }
        modify("&Print")
        {
            ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
        }
        modify("Re&lease")
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify("Create &Whse. Receipt")
        {
            Caption = 'Create &Whse. Receipt';
        }
        modify(Post)
        {
            ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
        }
        modify(PostAndPrint)
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetDocNoVisible;
    EnableTransferFields := not IsPartiallyShipped;
    ActivateFields;
    IsPACEnabled := EInvoiceMgt.IsPACEnvironmentEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    */
    //end;
}

