#pragma implicitwith disable
page 76222 "Ficha Facturas Pdtes POS"
{
    ApplicationArea = all;
    // #815  19/12/2013  PLB   Se muestra el campo "Texto de registro"

    Caption = 'Sales Invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = SORTING("Posting Date", "Venta TPV", Tienda, "Registrado TPV")
                      WHERE("Document Type" = FILTER(Order | Invoice),
                            "Venta TPV" = CONST(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("No. Documento SIC"; rec."No. Documento SIC")
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; rec."Sell-to Contact No.")
                {

                    trigger OnValidate()
                    begin
                        if Rec.GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
                            if Rec."Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                Rec.SetRange("Sell-to Contact No.");
                    end;
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field("VAT Registration No."; rec."VAT Registration No.")
                {
                }
                field("Sell-to Phone"; rec."Sell-to Phone")
                {
                }
                field("Sell-to Address"; rec."Sell-to Address")
                {
                    Importance = Additional;
                }
                field("Sell-to Address 2"; rec."Sell-to Address 2")
                {
                    Importance = Additional;
                }
                field("Sell-to City"; rec."Sell-to City")
                {
                }
                field("Sell-to County"; rec."Sell-to County")
                {
                    Caption = 'Sell-to State / ZIP Code';
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Importance = Additional;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                }
                field("Tipo de Venta"; rec."Tipo de Venta")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                    Importance = Promoted;
                }
                field("Document Date"; rec."Document Date")
                {
                }
                field("Incoming Document Entry No."; rec."Incoming Document Entry No.")
                {
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                    Importance = Promoted;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("No. Comprobante Fiscal"; rec."No. Comprobante Fiscal")
                {
                }
                field("Campaign No."; rec."Campaign No.")
                {
                    Importance = Additional;
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {
                    Importance = Additional;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                    Importance = Additional;
                }
                field("Job Queue Status"; rec."Job Queue Status")
                {
                    Importance = Additional;
                }
                field(Status; rec.Status)
                {
                    Importance = Promoted;
                }
                field(Correction; rec.Correction)
                {
                }
                field("Tipo de Comprobante"; rec."Tipo de Comprobante")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Establecimiento Factura"; rec."Establecimiento Factura")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Punto de Emision Factura"; rec."Punto de Emision Factura")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            part(SalesLines; "Sales Invoice Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(DsPOS)
            {
                Caption = 'DsPOS';
                Editable = false;
                field("Venta TPV"; rec."Venta TPV")
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("ID Cajero"; rec."ID Cajero")
                {
                }
                field("Hora creacion"; rec."Hora creacion")
                {
                }
                field("Anulado TPV"; rec."Anulado TPV")
                {
                }
                field("Anulado por Documento"; rec."Anulado por Documento")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; rec."Bill-to Contact No.")
                {
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                    Importance = Additional;
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                    Importance = Additional;
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                }
                field("Bill-to County"; rec."Bill-to County")
                {
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Importance = Additional;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                    Importance = Promoted;
                }
                field("Due Date"; rec."Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Discount %"; rec."Payment Discount %")
                {
                }
                field("Pmt. Discount Date"; rec."Pmt. Discount Date")
                {
                    Importance = Additional;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                }
                field("Tax Liable"; rec."Tax Liable")
                {
                    Importance = Promoted;
                }
                field("Tax Area Code"; rec."Tax Area Code")
                {
                    Importance = Promoted;
                }
                field("Direct Debit Mandate ID"; rec."Direct Debit Mandate ID")
                {
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                }
                field("Ship-to Address"; rec."Ship-to Address")
                {
                    Importance = Additional;
                }
                field("Ship-to Address 2"; rec."Ship-to Address 2")
                {
                    Importance = Additional;
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                }
                field("Ship-to County"; rec."Ship-to County")
                {
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Importance = Additional;
                }
                // field("Ship-to UPS Zone"; rec."Ship-to UPS Zone")
                // {
                // }
                field("Location Code"; rec."Location Code")
                {
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                }
                field("Package Tracking No."; '')
                {
                    Importance = Additional;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Importance = Promoted;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; rec."Currency Code")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; rec."EU 3-Party Trade")
                {
                }
                field("Transaction Type"; rec."Transaction Type")
                {
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                }
                field("Transport Method"; rec."Transport Method")
                {
                }
                field("Exit Point"; rec."Exit Point")
                {
                }
                field("Area"; rec.Area)
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = true;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = false;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = true;
            }
            part(Control1906354007; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        Commit;
                        if Rec."Tax Area Code" = '' then
                            PAGE.RunModal(PAGE::"Sales Statistics", Rec)
                        // else
                        //     PAGE.RunModal(PAGE::"Sales Order Stats.", Rec)
                    end;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Customer)
                {
                    Caption = 'Customer';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetSalesFilter);
            Rec.FilterGroup(0);
        end;
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        JobQueueVisible: Boolean;

    local procedure Post(PostingCodeunitID: Integer)
    begin
        Rec.SendToPosting(PostingCodeunitID);
        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.Close;
        CurrPage.Update(false);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        if Rec.GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
            if Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." then
                Rec.SetRange("Sell-to Customer No.");
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdatePage(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;
}

#pragma implicitwith restore

