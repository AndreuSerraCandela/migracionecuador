page 76421 "Transfer Order Subform Muestra"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Transfer Order Subform';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Item No."; rec."Item No.")
                {
                    Editable = false;
                }
                field("Variant Code"; rec."Variant Code")
                {
                    Visible = false;
                }
                field(Description; rec.Description)
                {
                    Editable = false;
                }
                field("Transfer-from Bin Code"; rec."Transfer-from Bin Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Transfer-To Bin Code"; rec."Transfer-To Bin Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Quantity; rec.Quantity)
                {
                    BlankZero = true;
                }
                field("Reserved Quantity Inbnd."; rec."Reserved Quantity Inbnd.")
                {
                    BlankZero = true;
                }
                field("Reserved Quantity Shipped"; rec."Reserved Quantity Shipped")
                {
                    BlankZero = true;
                }
                field("Reserved Quantity Outbnd."; rec."Reserved Quantity Outbnd.")
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    Visible = false;
                }
                field("Qty. to Ship"; rec."Qty. to Ship")
                {
                    BlankZero = true;
                }
                field("Quantity Shipped"; rec."Quantity Shipped")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransShptLine: Record "Transfer Shipment Line";
                    begin
                        rec.TestField("Document No.");
                        rec.TestField("Item No.");
                        TransShptLine.SetCurrentKey("Transfer Order No.", "Item No.", "Shipment Date");
                        TransShptLine.SetRange("Transfer Order No.", rec."Document No.");
                        TransShptLine.SetRange("Item No.", rec."Item No.");
                        PAGE.RunModal(0, TransShptLine);
                    end;
                }
                field("Qty. to Receive"; rec."Qty. to Receive")
                {
                    BlankZero = true;
                }
                field("Quantity Received"; rec."Quantity Received")
                {
                    BlankZero = true;

                    trigger OnDrillDown()
                    var
                        TransRcptLine: Record "Transfer Receipt Line";
                    begin
                        rec.TestField("Document No.");
                        rec.TestField("Item No.");
                        TransRcptLine.SetCurrentKey("Transfer Order No.", "Item No.", "Receipt Date");
                        TransRcptLine.SetRange("Transfer Order No.", rec."Document No.");
                        TransRcptLine.SetRange("Item No.", rec."Item No.");
                        PAGE.RunModal(0, TransRcptLine);
                    end;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                }
                field("Receipt Date"; rec."Receipt Date")
                {
                }
                field("Shipping Agent Code"; rec."Shipping Agent Code")
                {
                    Visible = false;
                }
                field("Shipping Agent Service Code"; rec."Shipping Agent Service Code")
                {
                    Visible = false;
                }
                field("Shipping Time"; rec."Shipping Time")
                {
                    Visible = false;
                }
                field("Outbound Whse. Handling Time"; rec."Outbound Whse. Handling Time")
                {
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; rec."Inbound Whse. Handling Time")
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
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(3, ShortcutDimCode[3]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(4, ShortcutDimCode[4]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(5, ShortcutDimCode[5]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(6, ShortcutDimCode[6]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(7, ShortcutDimCode[7]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupShortcutDimCode(8, ShortcutDimCode[8]);
                    end;

                    trigger OnValidate()
                    begin
                        rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
    begin
        Commit;
        if not ReserveTransferLine.DeleteLineConfirm(Rec) then
            exit(false);
        ReserveTransferLine.DeleteLine(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
        TransferLine: Record "Transfer Line";

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;
}

