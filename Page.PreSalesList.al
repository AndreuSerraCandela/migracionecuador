page 76355 "Pre Sales List"
{
    ApplicationArea = all;
    Caption = 'Sales List';
    CardPageID = "NCF Anulados";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Pre pedido" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field(Amount; rec.Amount)
                {
                }
                field("Posting No."; rec."Posting No.")
                {
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; rec."Sell-to Customer Name")
                {
                }
                field(Comment; rec.Comment)
                {
                    ShowCaption = false;
                }
                field("Promised Delivery Date"; rec."Promised Delivery Date")
                {
                }
                field("Requested Delivery Date"; rec."Requested Delivery Date")
                {
                }
                field("External Document No."; rec."External Document No.")
                {
                }
                field("Sell-to Post Code"; rec."Sell-to Post Code")
                {
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; rec."Sell-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Sell-to Contact"; rec."Sell-to Contact")
                {
                    Visible = false;
                }
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                    Visible = false;
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                    Visible = false;
                }
                field("Bill-to Post Code"; rec."Bill-to Post Code")
                {
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; rec."Bill-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Bill-to Contact"; rec."Bill-to Contact")
                {
                    Visible = false;
                }
                field("Ship-to Code"; rec."Ship-to Code")
                {
                    Visible = false;
                }
                field("Ship-to Name"; rec."Ship-to Name")
                {
                    Visible = false;
                }
                field("Ship-to Post Code"; rec."Ship-to Post Code")
                {
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; rec."Ship-to Country/Region Code")
                {
                    Visible = false;
                }
                field("Ship-to Contact"; rec."Ship-to Contact")
                {
                    Visible = false;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Location Code"; rec."Location Code")
                {
                    Visible = true;
                }
                field("Salesperson Code"; rec."Salesperson Code")
                {
                    Visible = false;
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                    Visible = false;
                }
                field("Document Date"; rec."Document Date")
                {
                }
                field(Status; rec.Status)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                        case rec."Document Type" of
                            rec."Document Type"::Quote:
                                PageID := PAGE::"Sales Quote";
                            rec."Document Type"::Order:
                                PageID := PAGE::"Sales Order";
                            rec."Document Type"::Invoice:
                                PageID := PAGE::"Sales Invoice";
                            rec."Document Type"::"Return Order":
                                PageID := PAGE::"Sales Return Order";
                            rec."Document Type"::"Credit Memo":
                                PageID := PAGE::"Sales Credit Memo";
                            rec."Document Type"::"Blanket Order":
                                PageID := PAGE::"Blanket Sales Order";
                        end;

                        PageID := GetPageId(PageID);

                        if PageID <> 0 then
                            PAGE.Run(PageID, Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Sales Reservation Avail.")
            {
                Caption = 'Sales Reservation Avail.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Sales Reservation Avail.";
            }
        }
    }

    local procedure GetPageId(PageId: Integer): Integer
    begin
        /*IF MiniPagesMapping.READPERMISSION THEN
          IF MiniPagesMapping.GET(PageId) THEN
            EXIT(MiniPagesMapping.SubstitutePageID);*/ //fes mig

        exit(PageId);

    end;
}

