page 50037 ListaDescuentoProntoPago
{
    ApplicationArea = all;
    Caption = 'Posted Credit Memos (Discount Soon Payment)';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Cust. Ledger Entry" = r;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = SORTING("Closed by Entry No.")
                      ORDER(Descending)
                      WHERE(Open = CONST(false),
                            "Pmt. Disc. Given (LCY)" = FILTER(> 0),
                            "No. Comprobante Fiscal DPP" = FILTER(<> ''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; rec."Customer No.")
                {
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                }
                field("DetailedCustLedgEntry.""Posting Date"""; DetailedCustLedgEntry."Posting Date")
                {
                    Caption = 'Fecha Registro';
                }
                field("DetailedCustLedgEntry.""Document No."""; DetailedCustLedgEntry."Document No.")
                {
                    Caption = 'Documento DPP';
                }
                field("Pmt. Disc. Given (LCY)"; rec."Pmt. Disc. Given (LCY)")
                {
                }
                field("No. Comprobante Fiscal DPP"; rec."No. Comprobante Fiscal DPP")
                {
                }
                field("Fecha vencimiento NCF DPP"; rec."Fecha vencimiento NCF DPP")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print Credit Memo (Discount Soon Payment) v2")
            {
                Caption = 'Print Credit Memo (Discount Soon Payment) v2';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(CustLedgEntry);
                    Clear(ReporteDPPv2);

                    CurrPage.SetSelectionFilter(CustLedgEntry);
                    ReporteDPPv2.SetTableView(CustLedgEntry);
                    ReporteDPPv2.RunModal;
                end;
            }
            action("Discount Soon Payment by customer v2")
            {
                Caption = 'Discount Soon Payment by customer v2';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(ReporteDPPXclientev2);

                    ReporteDPPXclientev2.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DetailedCustLedgEntry.Reset;
        DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", rec."Closed by Entry No.");
        DetailedCustLedgEntry.SetRange("Entry Type", DetailedCustLedgEntry."Entry Type"::"Payment Discount");
        if DetailedCustLedgEntry.FindFirst then;
    end;

    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ReporteDPPv2: Report "Formato DPP v2";
        ReporteDPPXclientev2: Report "Formato DPP x Clientes v2";
        CustLedgEntry: Record "Cust. Ledger Entry";
}

