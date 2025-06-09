#pragma implicitwith disable
page 76045 "Facturas comprimidas"
{
    ApplicationArea = all;
    // #65232, RRT, 30.01.2018: Corrección para poder compilar.

    Caption = 'Sales Invoice';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Invoice),
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
                    Editable = ESACC_F3_Editable;
                    HideValue = ESACC_F3_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F3_Visible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    Editable = ESACC_F2_Editable;
                    HideValue = ESACC_F2_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F2_Visible;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Contact No."; rec."Sell-to Contact No.")
                {
                    Editable = ESACC_F5052_Editable;
                    Enabled = ESACC_F5052_Editable;
                    HideValue = ESACC_F5052_HideValue;
                    Visible = ESACC_F5052_Visible;

                    trigger OnValidate()
                    begin
                        if Rec.GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
                            if Rec."Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                Rec.SetRange("Sell-to Contact No.");
                    end;
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                    Editable = ESACC_F79_Editable;
                    HideValue = ESACC_F79_HideValue;
                    Visible = ESACC_F79_Visible;
                }
                field("Sell-to Address"; rec."Sell-to Address")
                {
                    Editable = ESACC_F81_Editable;
                    HideValue = ESACC_F81_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F81_Visible;
                }
                field("Sell-to Address 2"; rec."Sell-to Address 2")
                {
                    Editable = ESACC_F82_Editable;
                    HideValue = ESACC_F82_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F82_Visible;
                }
                field("Sell-to City"; rec."Sell-to City")
                {
                    Editable = ESACC_F83_Editable;
                    HideValue = ESACC_F83_HideValue;
                    Visible = ESACC_F83_Visible;
                }
                field("Sell-to County"; rec."Sell-to County")
                {
                    Caption = 'Sell-to State / ZIP Code';
                    Editable = ESACC_F89_Editable;
                    HideValue = ESACC_F89_HideValue;
                    Visible = ESACC_F89_Visible;
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Editable = ESACC_F88_Editable;
                    HideValue = ESACC_F88_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F88_Visible;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                    Editable = ESACC_F84_Editable;
                    HideValue = ESACC_F84_HideValue;
                    Visible = ESACC_F84_Visible;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    Editable = ESACC_F20_Editable;
                    HideValue = ESACC_F20_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F20_Visible;
                }
                field("Document Date"; rec."Document Date")
                {
                    Editable = ESACC_F99_Editable;
                    HideValue = ESACC_F99_HideValue;
                    Visible = ESACC_F99_Visible;
                }
                field("Incoming Document Entry No."; rec."Incoming Document Entry No.")
                {
                    Editable = ESACC_F165_Editable;
                    HideValue = ESACC_F165_HideValue;
                    Visible = false;
                }
                field("External Document No."; rec."External Document No.")
                {
                    Editable = ESACC_F100_Editable;
                    HideValue = ESACC_F100_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F100_Visible;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    Editable = ESACC_F43_Editable;
                    HideValue = ESACC_F43_HideValue;
                    Visible = ESACC_F43_Visible;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Campaign No."; rec."Campaign No.")
                {
                    Editable = ESACC_F5050_Editable;
                    HideValue = ESACC_F5050_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F5050_Visible;
                }
                field("Responsibility Center"; rec."Responsibility Center")
                {
                    Editable = ESACC_F5700_Editable;
                    HideValue = ESACC_F5700_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F5700_Visible;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                    Editable = ESACC_F9000_Editable;
                    HideValue = ESACC_F9000_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F9000_Visible;
                }
                field("Job Queue Status"; rec."Job Queue Status")
                {
                    Editable = ESACC_F160_Editable;
                    Enabled = ESACC_F160_Editable;
                    HideValue = ESACC_F160_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F160_Visible;
                }
                field(Status; rec.Status)
                {
                    Editable = ESACC_F120_Editable;
                    HideValue = ESACC_F120_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F120_Visible;
                }
            }
            part(SalesLines; "Sales Invoice Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Editable = ESACC_F4_Editable;
                    HideValue = ESACC_F4_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F4_Visible;

                    trigger OnValidate()
                    begin
                        BilltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Bill-to Contact No."; rec."Bill-to Contact No.")
                {
                    Editable = ESACC_F5053_Editable;
                    Enabled = ESACC_F5053_Editable;
                    HideValue = ESACC_F5053_HideValue;
                    Visible = ESACC_F5053_Visible;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    Editable = ESACC_F5_Editable;
                    HideValue = ESACC_F5_HideValue;
                    Visible = ESACC_F5_Visible;
                }
                field("Bill-to Address"; rec."Bill-to Address")
                {
                    Editable = ESACC_F7_Editable;
                    HideValue = ESACC_F7_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F7_Visible;
                }
                field("Bill-to Address 2"; rec."Bill-to Address 2")
                {
                    Editable = ESACC_F8_Editable;
                    HideValue = ESACC_F8_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F8_Visible;
                }
                field("Bill-to City"; rec."Bill-to City")
                {
                    Editable = ESACC_F9_Editable;
                    HideValue = ESACC_F9_HideValue;
                    Visible = ESACC_F9_Visible;
                }
                field("Bill-to County"; rec."Bill-to County")
                {
                    Caption = 'State / ZIP Code';
                    Editable = ESACC_F86_Editable;
                    HideValue = ESACC_F86_HideValue;
                    Visible = ESACC_F86_Visible;
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Editable = ESACC_F85_Editable;
                    HideValue = ESACC_F85_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F85_Visible;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Editable = ESACC_F10_Editable;
                    HideValue = ESACC_F10_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F10_Visible;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Editable = ESACC_F29_Editable;
                    HideValue = ESACC_F29_HideValue;
                    Visible = ESACC_F29_Visible;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Editable = ESACC_F30_Editable;
                    HideValue = ESACC_F30_HideValue;
                    Visible = ESACC_F30_Visible;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {
                    Editable = ESACC_F23_Editable;
                    HideValue = ESACC_F23_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F23_Visible;
                }
                field("Due Date"; rec."Due Date")
                {
                    Editable = ESACC_F24_Editable;
                    HideValue = ESACC_F24_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F24_Visible;
                }
                field("Payment Discount %"; rec."Payment Discount %")
                {
                    Editable = ESACC_F25_Editable;
                    HideValue = ESACC_F25_HideValue;
                    Visible = ESACC_F25_Visible;
                }
                field("Pmt. Discount Date"; rec."Pmt. Discount Date")
                {
                    Editable = ESACC_F26_Editable;
                    HideValue = ESACC_F26_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F26_Visible;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                    Editable = ESACC_F104_Editable;
                    HideValue = ESACC_F104_HideValue;
                    Visible = ESACC_F104_Visible;
                }
                field("Tax Liable"; rec."Tax Liable")
                {
                    Editable = ESACC_F115_Editable;
                    HideValue = ESACC_F115_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F115_Visible;
                }
                field("Tax Area Code"; rec."Tax Area Code")
                {
                    Editable = ESACC_F114_Editable;
                    HideValue = ESACC_F114_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F114_Visible;
                }
                field("Direct Debit Mandate ID"; rec."Direct Debit Mandate ID")
                {
                    Editable = ESACC_F1200_Editable;
                    HideValue = ESACC_F1200_HideValue;
                    Visible = ESACC_F1200_Visible;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Editable = ESACC_F12_Editable;
                    HideValue = ESACC_F12_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F12_Visible;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    Editable = ESACC_F13_Editable;
                    HideValue = ESACC_F13_HideValue;
                    Visible = ESACC_F13_Visible;
                }
                field("Ship-to Address"; rec."Ship-to Address")
                {
                    Editable = ESACC_F15_Editable;
                    HideValue = ESACC_F15_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F15_Visible;
                }
                field("Ship-to Address 2"; rec."Ship-to Address 2")
                {
                    Editable = ESACC_F16_Editable;
                    HideValue = ESACC_F16_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F16_Visible;
                }
                field("Ship-to City"; rec."Ship-to City")
                {
                    Editable = ESACC_F17_Editable;
                    HideValue = ESACC_F17_HideValue;
                    Visible = ESACC_F17_Visible;
                }
                field("Ship-to County"; rec."Ship-to County")
                {
                    Caption = 'Ship-to State / ZIP Code';
                    Editable = ESACC_F92_Editable;
                    HideValue = ESACC_F92_HideValue;
                    Visible = ESACC_F92_Visible;
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Editable = ESACC_F91_Editable;
                    HideValue = ESACC_F91_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F91_Visible;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Editable = ESACC_F18_Editable;
                    HideValue = ESACC_F18_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F18_Visible;
                }
                // field("Ship-to UPS Zone"; rec."Ship-to UPS Zone")
                // {
                //     Editable = ESACC_F10005_Editable;
                //     HideValue = ESACC_F10005_HideValue;
                //     Visible = ESACC_F10005_Visible;
                // }
                field("Location Code"; rec."Location Code")
                {
                    Editable = ESACC_F28_Editable;
                    HideValue = ESACC_F28_HideValue;
                    Visible = ESACC_F28_Visible;
                }
                field("Shipment Method Code"; rec."Shipment Method Code")
                {
                    Editable = ESACC_F27_Editable;
                    HideValue = ESACC_F27_HideValue;
                    Visible = ESACC_F27_Visible;
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                    Editable = ESACC_F105_Editable;
                    HideValue = ESACC_F105_HideValue;
                    Visible = ESACC_F105_Visible;
                }
                field("Package Tracking No."; '')
                {
                    Editable = ESACC_F106_Editable;
                    HideValue = ESACC_F106_HideValue;
                    Importance = Additional;
                    Visible = ESACC_F106_Visible;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Editable = ESACC_F21_Editable;
                    HideValue = ESACC_F21_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F21_Visible;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; rec."Currency Code")
                {
                    Editable = ESACC_F32_Editable;
                    HideValue = ESACC_F32_HideValue;
                    Importance = Promoted;
                    Visible = ESACC_F32_Visible;

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
                    Editable = ESACC_F75_Editable;
                    HideValue = ESACC_F75_HideValue;
                    Visible = ESACC_F75_Visible;
                }
                field("Transaction Type"; rec."Transaction Type")
                {
                    Editable = ESACC_F76_Editable;
                    HideValue = ESACC_F76_HideValue;
                    Visible = ESACC_F76_Visible;
                }
                field("Transaction Specification"; rec."Transaction Specification")
                {
                    Editable = ESACC_F102_Editable;
                    HideValue = ESACC_F102_HideValue;
                    Visible = ESACC_F102_Visible;
                }
                field("Transport Method"; rec."Transport Method")
                {
                    Editable = ESACC_F77_Editable;
                    HideValue = ESACC_F77_HideValue;
                    Visible = ESACC_F77_Visible;
                }
                field("Exit Point"; rec."Exit Point")
                {
                    Editable = ESACC_F97_Editable;
                    HideValue = ESACC_F97_HideValue;
                    Visible = ESACC_F97_Visible;
                }
                field("Area"; rec.Area)
                {
                    Editable = ESACC_F101_Editable;
                    HideValue = ESACC_F101_HideValue;
                    Visible = ESACC_F101_Visible;
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
                    Enabled = ESACC_C59_Enabled;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    Visible = ESACC_C59_Visible;

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
                    Enabled = ESACC_C116_Enabled;
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = ESACC_C116_Visible;

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Customer)
                {
                    Caption = 'Customer';
                    Enabled = ESACC_C60_Enabled;
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                    Visible = ESACC_C60_Visible;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Enabled = ESACC_C162_Enabled;
                    Image = Approvals;
                    Visible = ESACC_C162_Visible;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Enabled = ESACC_C61_Enabled;
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    Visible = ESACC_C61_Visible;
                }
                separator(Action171)
                {
                }
            }
            group("Credit Card")
            {
                Caption = 'Credit Card';
                Image = CreditCardLog;
                action("Credit Cards Transaction Lo&g Entries")
                {
                    Caption = 'Credit Cards Transaction Lo&g Entries';
                    Enabled = ESACC_C172_Enabled;
                    Image = CreditCardLog;


                    Visible = ESACC_C172_Visible;
                }
            }
        }
        area(processing)
        {
            group(Action9)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    Caption = 'Re&lease';
                    Enabled = ESACC_C123_Enabled;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = ESACC_C123_Visible;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Enabled = ESACC_C124_Enabled;
                    Image = ReOpen;
                    Visible = ESACC_C124_Visible;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
                separator(Action168)
                {
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate &Invoice Discount")
                {
                    Caption = 'Calculate &Invoice Discount';
                    Enabled = ESACC_C63_Enabled;
                    Image = CalculateInvoiceDiscount;
                    Visible = ESACC_C63_Visible;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action142)
                {
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    Caption = 'Get St&d. Cust. Sales Codes';
                    Ellipsis = true;
                    Enabled = ESACC_C134_Enabled;
                    Image = CustomerCode;
                    Visible = ESACC_C134_Visible;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                separator(Action139)
                {
                }
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Enabled = ESACC_C64_Enabled;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ESACC_C64_Visible;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;
                    Enabled = ESACC_C115_Enabled;
                    Image = MoveNegativeLines;
                    Visible = ESACC_C115_Visible;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                separator(Action141)
                {
                }
                action("Send A&pproval Request")
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = ESACC_C159_Enabled;
                    Image = SendApprovalRequest;
                    Visible = ESACC_C159_Visible;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.SendSalesApprovalRequest(Rec) THEN; //MIGEC
                        if ApprovalMgt.CheckSalesApprovalPossible(Rec) then
                            ApprovalMgt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = ESACC_C160_Enabled;
                    Image = Cancel;
                    Visible = ESACC_C160_Visible;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        //IF ApprovalMgt.CancelSalesApprovalRequest(Rec,TRUE,TRUE) THEN; //MIGEC
                        ApprovalMgt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    end;
                }
                separator(Action161)
                {
                }
            }
            group(Action11)
            {
                Caption = 'Credit Card';
                Image = AuthorizeCreditCard;
                action(Authorize)
                {
                    Caption = 'Authorize';
                    Enabled = ESACC_C169_Enabled;
                    Image = AuthorizeCreditCard;
                    Visible = ESACC_C169_Visible;

                    trigger OnAction()
                    begin
                        //fes mig Authorize;
                    end;
                }
                action("Void A&uthorize")
                {
                    Caption = 'Void A&uthorize';
                    Enabled = ESACC_C170_Enabled;
                    Image = VoidCreditCard;
                    Visible = ESACC_C170_Visible;

                    trigger OnAction()
                    begin
                        //fes mig Void;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action("Post ")
                {
                    Caption = 'P&ost';
                    Enabled = ESACC_C71_Enabled;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    Visible = ESACC_C71_Visible;

                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"Sales-Post (Yes/No)");
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Enabled = ESACC_C70_Enabled;
                    Image = TestReport;
                    Visible = ESACC_C70_Visible;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Enabled = ESACC_C72_Enabled;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    Visible = ESACC_C72_Visible;

                    trigger OnAction()
                    begin
                        Post(CODEUNIT::"Sales-Post + Print");
                    end;
                }
                action("Post &Batch")
                {
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Enabled = ESACC_C73_Enabled;
                    Image = PostBatch;
                    Visible = ESACC_C73_Visible;

                    trigger OnAction()
                    begin
                        REPORT.RunModal(REPORT::"Batch Post Sales Invoices", true, true, Rec);
                        CurrPage.Update(false);
                    end;
                }
                action("Remove From Job Queue")
                {
                    Caption = 'Remove From Job Queue';
                    Enabled = ESACC_C3_Enabled;
                    Image = RemoveLine;
                    Visible = JobQueueVisible;

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting;
                    end;
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
        ;

    end;

    var


        ESACC_C3_Visible: Boolean;

        ESACC_C3_Enabled: Boolean;

        ESACC_C59_Visible: Boolean;

        ESACC_C59_Enabled: Boolean;

        ESACC_C60_Visible: Boolean;

        ESACC_C60_Enabled: Boolean;

        ESACC_C61_Visible: Boolean;

        ESACC_C61_Enabled: Boolean;

        ESACC_C63_Visible: Boolean;

        ESACC_C63_Enabled: Boolean;

        ESACC_C64_Visible: Boolean;

        ESACC_C64_Enabled: Boolean;

        ESACC_C70_Visible: Boolean;

        ESACC_C70_Enabled: Boolean;

        ESACC_C71_Visible: Boolean;

        ESACC_C71_Enabled: Boolean;

        ESACC_C72_Visible: Boolean;

        ESACC_C72_Enabled: Boolean;

        ESACC_C73_Visible: Boolean;

        ESACC_C73_Enabled: Boolean;

        ESACC_C115_Visible: Boolean;

        ESACC_C115_Enabled: Boolean;

        ESACC_C116_Visible: Boolean;

        ESACC_C116_Enabled: Boolean;

        ESACC_C123_Visible: Boolean;

        ESACC_C123_Enabled: Boolean;

        ESACC_C124_Visible: Boolean;

        ESACC_C124_Enabled: Boolean;

        ESACC_C134_Visible: Boolean;

        ESACC_C134_Enabled: Boolean;

        ESACC_C159_Visible: Boolean;

        ESACC_C159_Enabled: Boolean;

        ESACC_C160_Visible: Boolean;

        ESACC_C160_Enabled: Boolean;

        ESACC_C162_Visible: Boolean;

        ESACC_C162_Enabled: Boolean;

        ESACC_C169_Visible: Boolean;

        ESACC_C169_Enabled: Boolean;

        ESACC_C170_Visible: Boolean;

        ESACC_C170_Enabled: Boolean;

        ESACC_C172_Visible: Boolean;

        ESACC_C172_Enabled: Boolean;

        ESACC_F2_Visible: Boolean;

        ESACC_F2_Editable: Boolean;

        ESACC_F2_HideValue: Boolean;

        ESACC_F3_Visible: Boolean;

        ESACC_F3_Editable: Boolean;

        ESACC_F3_HideValue: Boolean;

        ESACC_F4_Visible: Boolean;

        ESACC_F4_Editable: Boolean;

        ESACC_F4_HideValue: Boolean;

        ESACC_F5_Visible: Boolean;

        ESACC_F5_Editable: Boolean;

        ESACC_F5_HideValue: Boolean;

        ESACC_F7_Visible: Boolean;

        ESACC_F7_Editable: Boolean;

        ESACC_F7_HideValue: Boolean;

        ESACC_F8_Visible: Boolean;

        ESACC_F8_Editable: Boolean;

        ESACC_F8_HideValue: Boolean;

        ESACC_F9_Visible: Boolean;

        ESACC_F9_Editable: Boolean;

        ESACC_F9_HideValue: Boolean;

        ESACC_F10_Visible: Boolean;

        ESACC_F10_Editable: Boolean;

        ESACC_F10_HideValue: Boolean;

        ESACC_F12_Visible: Boolean;

        ESACC_F12_Editable: Boolean;

        ESACC_F12_HideValue: Boolean;

        ESACC_F13_Visible: Boolean;

        ESACC_F13_Editable: Boolean;

        ESACC_F13_HideValue: Boolean;

        ESACC_F15_Visible: Boolean;

        ESACC_F15_Editable: Boolean;

        ESACC_F15_HideValue: Boolean;

        ESACC_F16_Visible: Boolean;

        ESACC_F16_Editable: Boolean;

        ESACC_F16_HideValue: Boolean;

        ESACC_F17_Visible: Boolean;

        ESACC_F17_Editable: Boolean;

        ESACC_F17_HideValue: Boolean;

        ESACC_F18_Visible: Boolean;

        ESACC_F18_Editable: Boolean;

        ESACC_F18_HideValue: Boolean;

        ESACC_F20_Visible: Boolean;

        ESACC_F20_Editable: Boolean;

        ESACC_F20_HideValue: Boolean;

        ESACC_F21_Visible: Boolean;

        ESACC_F21_Editable: Boolean;

        ESACC_F21_HideValue: Boolean;

        ESACC_F23_Visible: Boolean;

        ESACC_F23_Editable: Boolean;

        ESACC_F23_HideValue: Boolean;

        ESACC_F24_Visible: Boolean;

        ESACC_F24_Editable: Boolean;

        ESACC_F24_HideValue: Boolean;

        ESACC_F25_Visible: Boolean;

        ESACC_F25_Editable: Boolean;

        ESACC_F25_HideValue: Boolean;

        ESACC_F26_Visible: Boolean;

        ESACC_F26_Editable: Boolean;

        ESACC_F26_HideValue: Boolean;

        ESACC_F27_Visible: Boolean;

        ESACC_F27_Editable: Boolean;

        ESACC_F27_HideValue: Boolean;

        ESACC_F28_Visible: Boolean;

        ESACC_F28_Editable: Boolean;

        ESACC_F28_HideValue: Boolean;

        ESACC_F29_Visible: Boolean;

        ESACC_F29_Editable: Boolean;

        ESACC_F29_HideValue: Boolean;

        ESACC_F30_Visible: Boolean;

        ESACC_F30_Editable: Boolean;

        ESACC_F30_HideValue: Boolean;

        ESACC_F32_Visible: Boolean;

        ESACC_F32_Editable: Boolean;

        ESACC_F32_HideValue: Boolean;

        ESACC_F43_Visible: Boolean;

        ESACC_F43_Editable: Boolean;

        ESACC_F43_HideValue: Boolean;

        ESACC_F75_Visible: Boolean;

        ESACC_F75_Editable: Boolean;

        ESACC_F75_HideValue: Boolean;

        ESACC_F76_Visible: Boolean;

        ESACC_F76_Editable: Boolean;

        ESACC_F76_HideValue: Boolean;

        ESACC_F77_Visible: Boolean;

        ESACC_F77_Editable: Boolean;

        ESACC_F77_HideValue: Boolean;

        ESACC_F79_Visible: Boolean;

        ESACC_F79_Editable: Boolean;

        ESACC_F79_HideValue: Boolean;

        ESACC_F81_Visible: Boolean;

        ESACC_F81_Editable: Boolean;

        ESACC_F81_HideValue: Boolean;

        ESACC_F82_Visible: Boolean;

        ESACC_F82_Editable: Boolean;

        ESACC_F82_HideValue: Boolean;

        ESACC_F83_Visible: Boolean;

        ESACC_F83_Editable: Boolean;

        ESACC_F83_HideValue: Boolean;

        ESACC_F84_Visible: Boolean;

        ESACC_F84_Editable: Boolean;

        ESACC_F84_HideValue: Boolean;

        ESACC_F85_Visible: Boolean;

        ESACC_F85_Editable: Boolean;

        ESACC_F85_HideValue: Boolean;

        ESACC_F86_Visible: Boolean;

        ESACC_F86_Editable: Boolean;

        ESACC_F86_HideValue: Boolean;

        ESACC_F88_Visible: Boolean;

        ESACC_F88_Editable: Boolean;

        ESACC_F88_HideValue: Boolean;

        ESACC_F89_Visible: Boolean;

        ESACC_F89_Editable: Boolean;

        ESACC_F89_HideValue: Boolean;

        ESACC_F91_Visible: Boolean;

        ESACC_F91_Editable: Boolean;

        ESACC_F91_HideValue: Boolean;

        ESACC_F92_Visible: Boolean;

        ESACC_F92_Editable: Boolean;

        ESACC_F92_HideValue: Boolean;

        ESACC_F97_Visible: Boolean;

        ESACC_F97_Editable: Boolean;

        ESACC_F97_HideValue: Boolean;

        ESACC_F99_Visible: Boolean;

        ESACC_F99_Editable: Boolean;

        ESACC_F99_HideValue: Boolean;

        ESACC_F100_Visible: Boolean;

        ESACC_F100_Editable: Boolean;

        ESACC_F100_HideValue: Boolean;

        ESACC_F101_Visible: Boolean;

        ESACC_F101_Editable: Boolean;

        ESACC_F101_HideValue: Boolean;

        ESACC_F102_Visible: Boolean;

        ESACC_F102_Editable: Boolean;

        ESACC_F102_HideValue: Boolean;

        ESACC_F104_Visible: Boolean;

        ESACC_F104_Editable: Boolean;

        ESACC_F104_HideValue: Boolean;

        ESACC_F105_Visible: Boolean;

        ESACC_F105_Editable: Boolean;

        ESACC_F105_HideValue: Boolean;

        ESACC_F106_Visible: Boolean;

        ESACC_F106_Editable: Boolean;

        ESACC_F106_HideValue: Boolean;

        ESACC_F114_Visible: Boolean;

        ESACC_F114_Editable: Boolean;

        ESACC_F114_HideValue: Boolean;

        ESACC_F115_Visible: Boolean;

        ESACC_F115_Editable: Boolean;

        ESACC_F115_HideValue: Boolean;

        ESACC_F120_Visible: Boolean;

        ESACC_F120_Editable: Boolean;

        ESACC_F120_HideValue: Boolean;

        ESACC_F160_Visible: Boolean;

        ESACC_F160_Editable: Boolean;

        ESACC_F160_HideValue: Boolean;

        ESACC_F165_Visible: Boolean;

        ESACC_F165_Editable: Boolean;

        ESACC_F165_HideValue: Boolean;

        ESACC_F827_Visible: Boolean;

        ESACC_F827_Editable: Boolean;

        ESACC_F827_HideValue: Boolean;

        ESACC_F1200_Visible: Boolean;

        ESACC_F1200_Editable: Boolean;

        ESACC_F1200_HideValue: Boolean;

        ESACC_F5050_Visible: Boolean;

        ESACC_F5050_Editable: Boolean;

        ESACC_F5050_HideValue: Boolean;

        ESACC_F5052_Visible: Boolean;

        ESACC_F5052_Editable: Boolean;

        ESACC_F5052_HideValue: Boolean;

        ESACC_F5053_Visible: Boolean;

        ESACC_F5053_Editable: Boolean;

        ESACC_F5053_HideValue: Boolean;

        ESACC_F5700_Visible: Boolean;

        ESACC_F5700_Editable: Boolean;

        ESACC_F5700_HideValue: Boolean;

        ESACC_F9000_Visible: Boolean;

        ESACC_F9000_Editable: Boolean;

        ESACC_F9000_HideValue: Boolean;

        ESACC_F10005_Visible: Boolean;

        ESACC_F10005_Editable: Boolean;

        ESACC_F10005_HideValue: Boolean;
        ChangeExchangeRate: Page "Change Exchange Rate";
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";

        JobQueueVisible: Boolean;
    /* 
        local procedure ESACC_EasySecurity(OpenObject: Boolean)
        var

            TempBoolean: Boolean;
        begin
            if OpenObject then begin
                //+65232
                //SetFilters.Filter36(Rec,8,76045);
                //-65232

                TempBoolean := CurrPage.Editable;
                if ESACC_ESFLADSMgt.PageGeneral(36, 76045, TempBoolean) then
                    CurrPage.Editable := TempBoolean;
            end;

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 3,
              ESACC_C3_Visible, ESACC_C3_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 59,
              ESACC_C59_Visible, ESACC_C59_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 60,
              ESACC_C60_Visible, ESACC_C60_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 61,
              ESACC_C61_Visible, ESACC_C61_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 63,
              ESACC_C63_Visible, ESACC_C63_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 64,
              ESACC_C64_Visible, ESACC_C64_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 70,
              ESACC_C70_Visible, ESACC_C70_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 71,
              ESACC_C71_Visible, ESACC_C71_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 72,
              ESACC_C72_Visible, ESACC_C72_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 73,
              ESACC_C73_Visible, ESACC_C73_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 115,
              ESACC_C115_Visible, ESACC_C115_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 116,
              ESACC_C116_Visible, ESACC_C116_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 123,
              ESACC_C123_Visible, ESACC_C123_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 124,
              ESACC_C124_Visible, ESACC_C124_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 134,
              ESACC_C134_Visible, ESACC_C134_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 159,
              ESACC_C159_Visible, ESACC_C159_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 160,
              ESACC_C160_Visible, ESACC_C160_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 162,
              ESACC_C162_Visible, ESACC_C162_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 169,
              ESACC_C169_Visible, ESACC_C169_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 170,
              ESACC_C170_Visible, ESACC_C170_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 1, 172,
              ESACC_C172_Visible, ESACC_C172_Enabled, TempBoolean);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 2,
              ESACC_F2_Visible, ESACC_F2_Editable, ESACC_F2_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 3,
              ESACC_F3_Visible, ESACC_F3_Editable, ESACC_F3_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 4,
              ESACC_F4_Visible, ESACC_F4_Editable, ESACC_F4_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 5,
              ESACC_F5_Visible, ESACC_F5_Editable, ESACC_F5_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 7,
              ESACC_F7_Visible, ESACC_F7_Editable, ESACC_F7_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 8,
              ESACC_F8_Visible, ESACC_F8_Editable, ESACC_F8_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 9,
              ESACC_F9_Visible, ESACC_F9_Editable, ESACC_F9_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 10,
              ESACC_F10_Visible, ESACC_F10_Editable, ESACC_F10_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 12,
              ESACC_F12_Visible, ESACC_F12_Editable, ESACC_F12_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 13,
              ESACC_F13_Visible, ESACC_F13_Editable, ESACC_F13_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 15,
              ESACC_F15_Visible, ESACC_F15_Editable, ESACC_F15_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 16,
              ESACC_F16_Visible, ESACC_F16_Editable, ESACC_F16_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 17,
              ESACC_F17_Visible, ESACC_F17_Editable, ESACC_F17_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 18,
              ESACC_F18_Visible, ESACC_F18_Editable, ESACC_F18_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 20,
              ESACC_F20_Visible, ESACC_F20_Editable, ESACC_F20_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 21,
              ESACC_F21_Visible, ESACC_F21_Editable, ESACC_F21_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 23,
              ESACC_F23_Visible, ESACC_F23_Editable, ESACC_F23_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 24,
              ESACC_F24_Visible, ESACC_F24_Editable, ESACC_F24_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 25,
              ESACC_F25_Visible, ESACC_F25_Editable, ESACC_F25_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 26,
              ESACC_F26_Visible, ESACC_F26_Editable, ESACC_F26_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 27,
              ESACC_F27_Visible, ESACC_F27_Editable, ESACC_F27_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 28,
              ESACC_F28_Visible, ESACC_F28_Editable, ESACC_F28_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 29,
              ESACC_F29_Visible, ESACC_F29_Editable, ESACC_F29_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 30,
              ESACC_F30_Visible, ESACC_F30_Editable, ESACC_F30_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 32,
              ESACC_F32_Visible, ESACC_F32_Editable, ESACC_F32_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 43,
              ESACC_F43_Visible, ESACC_F43_Editable, ESACC_F43_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 75,
              ESACC_F75_Visible, ESACC_F75_Editable, ESACC_F75_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 76,
              ESACC_F76_Visible, ESACC_F76_Editable, ESACC_F76_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 77,
              ESACC_F77_Visible, ESACC_F77_Editable, ESACC_F77_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 79,
              ESACC_F79_Visible, ESACC_F79_Editable, ESACC_F79_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 81,
              ESACC_F81_Visible, ESACC_F81_Editable, ESACC_F81_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 82,
              ESACC_F82_Visible, ESACC_F82_Editable, ESACC_F82_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 83,
              ESACC_F83_Visible, ESACC_F83_Editable, ESACC_F83_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 84,
              ESACC_F84_Visible, ESACC_F84_Editable, ESACC_F84_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 85,
              ESACC_F85_Visible, ESACC_F85_Editable, ESACC_F85_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 86,
              ESACC_F86_Visible, ESACC_F86_Editable, ESACC_F86_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 88,
              ESACC_F88_Visible, ESACC_F88_Editable, ESACC_F88_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 89,
              ESACC_F89_Visible, ESACC_F89_Editable, ESACC_F89_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 91,
              ESACC_F91_Visible, ESACC_F91_Editable, ESACC_F91_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 92,
              ESACC_F92_Visible, ESACC_F92_Editable, ESACC_F92_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 97,
              ESACC_F97_Visible, ESACC_F97_Editable, ESACC_F97_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 99,
              ESACC_F99_Visible, ESACC_F99_Editable, ESACC_F99_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 100,
              ESACC_F100_Visible, ESACC_F100_Editable, ESACC_F100_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 101,
              ESACC_F101_Visible, ESACC_F101_Editable, ESACC_F101_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 102,
              ESACC_F102_Visible, ESACC_F102_Editable, ESACC_F102_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 104,
              ESACC_F104_Visible, ESACC_F104_Editable, ESACC_F104_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 105,
              ESACC_F105_Visible, ESACC_F105_Editable, ESACC_F105_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 106,
              ESACC_F106_Visible, ESACC_F106_Editable, ESACC_F106_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 114,
              ESACC_F114_Visible, ESACC_F114_Editable, ESACC_F114_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 115,
              ESACC_F115_Visible, ESACC_F115_Editable, ESACC_F115_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 120,
              ESACC_F120_Visible, ESACC_F120_Editable, ESACC_F120_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 160,
              ESACC_F160_Visible, ESACC_F160_Editable, ESACC_F160_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 165,
              ESACC_F165_Visible, ESACC_F165_Editable, ESACC_F165_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 827,
              ESACC_F827_Visible, ESACC_F827_Editable, ESACC_F827_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 1200,
              ESACC_F1200_Visible, ESACC_F1200_Editable, ESACC_F1200_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 5050,
              ESACC_F5050_Visible, ESACC_F5050_Editable, ESACC_F5050_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 5052,
              ESACC_F5052_Visible, ESACC_F5052_Editable, ESACC_F5052_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 5053,
              ESACC_F5053_Visible, ESACC_F5053_Editable, ESACC_F5053_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 5700,
              ESACC_F5700_Visible, ESACC_F5700_Editable, ESACC_F5700_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 9000,
              ESACC_F9000_Visible, ESACC_F9000_Editable, ESACC_F9000_HideValue);

            ESACC_ESFLADSMgt.PageControl(
              36, 76045, 0, 10005,
              ESACC_F10005_Visible, ESACC_F10005_Editable, ESACC_F10005_HideValue);

            ESACC_EasySecurityManual(OpenObject);
        end;
     */
    local procedure ESACC_EasySecurityManual(OpenObject: Boolean)
    begin
    end;

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

