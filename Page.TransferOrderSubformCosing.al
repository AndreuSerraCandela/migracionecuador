page 56054 "Transfer Order Subform Cosing."
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    InsertAllowed = false;
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
                }
                field("Variant Code"; rec."Variant Code")
                {
                    Visible = false;
                }
                field("Planning Flexibility"; rec."Planning Flexibility")
                {
                    Visible = false;
                }
                field(Description; rec.Description)
                {
                }
                field("Transfer-from Bin Code"; rec."Transfer-from Bin Code")
                {
                    Visible = false;
                }
                field("Transfer-To Bin Code"; rec."Transfer-To Bin Code")
                {
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
                field("Precio Venta Consignacion"; rec."Precio Venta Consignacion")
                {
                    Caption = 'Consignment Sales Price';
                    Editable = false;
                }
                field("Descuento % Consignacion"; rec."Descuento % Consignacion")
                {
                    Caption = 'Consignment Discount %';
                    Editable = false;
                }
                field("Importe Consignacion"; rec."Importe Consignacion")
                {
                    Caption = 'Consignment Amount';
                    Editable = false;
                }
                field("Importe Consignacion Original"; rec."Importe Consignacion Original")
                {
                    Caption = 'Original Consignment Amount';
                    Editable = false;
                    Visible = false;
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
                field("Transfer-to Code"; rec."Transfer-to Code")
                {
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
                field("Tipo Transferencia"; rec."Tipo Transferencia")
                {
                    Editable = false;
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Reserve")
                {
                    Caption = '&Reserve';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferLines.PAGE.*/
                        _ShowReservation;

                    end;
                }
                separator(Action1000000001)
                {
                }
                action("<Action1000000012>")
                {
                    Caption = 'Undo Shipment';

                    trigger OnAction()
                    begin
                        DeshacerEnvio;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            _ItemAvailability(0);

                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            _ItemAvailability(1);

                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            _ItemAvailability(2);

                        end;
                    }
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                        /*CurrPage.TransferLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                group("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    action(Shipment)
                    {
                        Caption = 'Shipment';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            _OpenItemTrackingLines(0);

                        end;
                    }
                    action(Receipt)
                    {
                        Caption = 'Receipt';

                        trigger OnAction()
                        begin
                            //This functionality was copied from page #5740. Unsupported part was commented. Please check it.
                            /*CurrPage.TransferLines.PAGE.*/
                            _OpenItemTrackingLines(1);

                        end;
                    }
                }
            }
        }
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


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;




    procedure _ItemAvailability(AvailabilityType: Option Date,Variant,Location)
    begin
        Rec.ItemAvailability(AvailabilityType);
    end;





    procedure _ShowReservation()
    begin
        rec.Find;
        Rec.ShowReservation;
    end;





    procedure _OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    begin


    end;


    procedure OpenItemTrackingLines(Direction: Option Outbound,Inbound)
    var
        TransferDirectionEnum: Enum "Transfer Direction";
    begin
        case Direction of
            Direction::Outbound:
                TransferDirectionEnum := TransferDirectionEnum::Outbound;
            Direction::Inbound:
                TransferDirectionEnum := TransferDirectionEnum::Inbound;
        end;
        rec.OpenItemTrackingLines(TransferDirectionEnum);
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure DeshacerEnvio()
    begin
        DeshacerEnvio;
    end;
}

