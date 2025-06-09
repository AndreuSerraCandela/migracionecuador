pageextension 50141 pageextension50141 extends "Sales Order List"
{
    layout
    {
        modify("External Document No.")
        {
            ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
        }
        modify("Bill-to Customer No.")
        {
            ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
        }
        modify("Bill-to Name")
        {
            ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';
        }
        modify("Bill-to Country/Region Code")
        {
            ToolTip = 'Specifies the country/region code of the customer''s billing address.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Location Code")
        {
            ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
        }
        modify("Payment Discount %")
        {
            ToolTip = 'Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }
        modify("Package Tracking No.")
        {
            ToolTip = 'Specifies the shipping agent''s package number.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Completely Shipped")
        {
            ToolTip = 'Specifies whether all the items on the order have been shipped or, in the case of inbound items, completely received.';
        }
        addafter("No.")
        {
            field("No. Serie NCF Facturas"; rec."No. Serie NCF Facturas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Address"; rec."Sell-to Address")
            {
            ApplicationArea = All;
            }
            field("Sell-to Address 2"; rec."Sell-to Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sell-to City"; rec."Sell-to City")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Sell-to County"; rec."Sell-to County")
            {
                ApplicationArea = Basic, Suite;
            }
            field(wAliasCliente; wAliasCliente)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sell-to Customer Search Name';
            }
        }
        addafter("Sell-to Contact")
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Procesar EAN-Picking Masivo"; rec."Procesar EAN-Picking Masivo")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Estatus EAN-Picking Masivo"; rec."Estatus EAN-Picking Masivo")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("Ship-to Name")
        {
            field("Ship-to Address"; rec."Ship-to Address")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to Address 2"; rec."Ship-to Address 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Ship-to City"; rec."Ship-to City")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Ship-to Post Code")
        {
            field("Ship-to Phone"; rec."Ship-to Phone")
            {
            ApplicationArea = All;
            }
        }
        addafter("Ship-to Country/Region Code")
        {
            field("Ship-to County"; rec."Ship-to County")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Aprobado cobros"; rec."Aprobado cobros")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Numero Guia"; rec."Numero Guia")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Guia"; rec."Nombre Guia")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {

        modify(Release)
        {
            ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';
        }
        modify(Reopen)
        {
            ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
        }
        modify("Order &Promising")
        {
            ToolTip = 'Calculate the shipment and delivery dates based on the item''s known and expected availability dates, and then promise the dates to the customer.';
        }
        modify("Delete Invoiced")
        {
            Caption = 'Delete Invoiced Sales Orders';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        modify("Remove From Job Queue")
        {
            ToolTip = 'Remove the scheduled processing of this record from the job queue.';
        }
        modify("Sales Reservation Avail.")
        {
            ToolTip = 'View, print, or save an overview of availability of items for shipment on sales documents, filtered on shipment status.';
        }
        addafter("Order &Promising")
        {
            action("Excel Import")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Excel Import';
                Ellipsis = true;
                Image = Excel;

                trigger OnAction()
                var
                    ReportImportfromExcel: Report "Importa desde Excel";
                begin
                    ReportImportfromExcel.RunModal;
                end;
            }
            separator(Action1000000000)
            {
            }
        }
        addafter("Create &Warehouse Shipment")
        {
            action("<Action1000000000>")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Customer Statement';
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    //001
                    if SH.Get(rec."Document Type", rec."No.") then begin
                        Cust.Reset;
                        Cust.SetRange(Cust."No.", SH."Bill-to Customer No.");
                        Cust.FindFirst;
                        REPORT.RunModal(10072, true, true, Cust);
                    end
                    else
                        REPORT.RunModal(10072, true, true, Cust);
                    //001
                end;
            }
            action("Crear EAN-Picking Masivos")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Crear EAN-Picking Masivos';
                Image = ShipmentLines;
                RunObject = Codeunit "Creacion de AEN";
            }
        }
    }

    var
        "***Santillana***": Integer;
        Cust: Record Customer;
        SH: Record "Sales Header";
        wAliasCliente: Code[75];

    trigger OnAfterGetRecord()
    var
        lrCliente: Record Customer;
    begin
        //+003
        wAliasCliente := '';
        if lrCliente.Get(Rec."Sell-to Customer No.") then
            wAliasCliente := lrCliente."Search Name";
        //-003
    end;
}

