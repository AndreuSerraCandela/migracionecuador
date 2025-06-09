pageextension 50066 pageextension50066 extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
        }
        modify("Purchasing Code")
        {
            ToolTip = 'Specifies which purchaser is assigned to the vendor.';
        }
        modify(Description)
        {
            Editable = false;
        }
        modify("Drop Shipment")
        {
            ToolTip = 'Specifies if your vendor ships the items directly to your customer.';
        }
        modify("Special Order")
        {
            ToolTip = 'Specifies that the item on the sales line is a special-order item.';
        }
        // modify("Package Tracking No.")
        // {
        //     ToolTip = 'Specifies the shipping agent''s package number.';
        // }
        modify("Location Code")
        {
            ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
        }
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify(Quantity)
        {
            Editable = false;
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Unit Cost (LCY)")
        {
            ToolTip = 'Specifies the unit cost of the item on the line.';
        }
        modify("Unit Price")
        {
            ToolTip = 'Specifies the price for one unit on the sales line.';
            trigger OnAfterValidate()
            begin
                //001
                // if UsSetUp.Get(UserId) then begin
                //     if not UsSetUp."Modifica Precio Venta" then
                //         Error(Error001, Rec."Unit Price");
                // end
                // else
                //     Error(Error001, Rec."Unit Price");
                //001
            end;
        }
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        }
        modify("Tax Group Code")
        {
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        // modify("Amount Including VAT")
        // {
        //     ToolTip = 'Specifies the sum of the amounts in the Amount Including Tax fields on the associated sales lines.';
        // }
        modify("Inv. Discount Amount")
        {
            ToolTip = 'Specifies the total calculated invoice discount amount for the line.';
        }
        modify("Quantity Shipped")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
        }
        modify("Quantity Invoiced")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';
        }
        modify("Prepmt Amt to Deduct")
        {
            ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
        }
        modify("Prepmt Amt Deducted")
        {
            ToolTip = 'Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Depreciation Book Code")
        {
            ToolTip = 'Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
        }
        modify("Use Duplication List")
        {
            ToolTip = 'Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. ';
        }
        modify("Duplicate in Depreciation Book")
        {
            ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
        }
        modify("Appl.-from Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied from.';
        }
        modify("Appl.-to Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
        }
        modify("Deferral Code")
        {
            ToolTip = 'Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify(Control51)
        {
            Visible = false;
        }
        modify("TotalSalesLine.""Line Amount""")
        {
            ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document.';
        }
        modify("Invoice Disc. Pct.")
        {
            ToolTip = 'Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';
        }
        modify("Line Discount %")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //001
                // if UsSetUp.Get(UserId) then begin
                //     if not UsSetUp."Modifica Descuento Venta" then
                //         Error(Error001, Rec.FieldCaption("Line Discount %"));
                // end
                // else
                //     Error(Error001, Rec.FieldCaption("Line Discount %"));
                // //001
            end;
        }
        modify("Line Discount Amount")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //001
                // if UsSetUp.Get(UserId) then begin
                //     if not UsSetUp."Modifica Descuento Venta" then
                //         Error(Error001, Rec.FieldCaption("Line Discount Amount"));
                // end
                // else
                //     Error(Error001, Rec.FieldCaption("Line Discount Amount"));
                //001
            end;
        }
        // modify("Retention Attached to Line No.")
        // {
        //     Visible = false;
        // }
        // modify("Retention VAT %")
        // {
        //     Visible = false;
        // }
        // modify("Custom Transit Number")
        // {
        //     Visible = false;
        //}
        addafter("No.")
        {
            field("Parte del IVA"; rec."Parte del IVA")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Cantidad Alumnos"; rec."Cantidad Alumnos")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Adopcion; rec.Adopcion)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Nonstock)
        {

        }
        addafter(Description)
        {

            field("Cantidad pendiente BO"; rec."Cantidad pendiente BO")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Cantidad a Anular"; rec."Cantidad a Anular")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Cantidad a Ajustar"; rec."Cantidad a Ajustar")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cantidad Solicitada"; rec."Cantidad Solicitada")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cantidad Anulada"; rec."Cantidad Anulada")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Porcentaje Cant. Aprobada"; rec."Porcentaje Cant. Aprobada")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cantidad Aprobada"; rec."Cantidad Aprobada")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    //004
                    rec."Porcentaje Cant. Aprobada" := 0;
                    CurrPage.Update;
                    CurrPage.SaveRecord;
                    //004
                end;
            }
        }
    }
    actions
    {
        modify("ExplodeBOM_Functions")
        {
            ToolTip = 'Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.';
        }
        modify("Insert Ext. Texts")
        {
            ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';
        }
        modify(Reserve)
        {
            ToolTip = 'Reserve the quantity that is required on the document line that you opened this window for.';
        }
        modify(OrderTracking)
        {
            ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';
        }
        modify("<Action3>")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(ItemAvailabilityByVariant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify("Reservation Entries")
        {
            ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';
        }
        modify(ItemTrackingLines)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify("Item Charge &Assignment")
        {
            ToolTip = 'Assign additional direct costs, for example for freight, to the item on the line.';
        }
        modify(OrderPromising)
        {
            ToolTip = 'Calculate the shipment and delivery dates based on the item''s known and expected availability dates, and then promise the dates to the customer.';
        }
        modify(DeferralSchedule)
        {
            ToolTip = 'View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';
        }
        addafter("F&unctions")
        {
            separator(Action1000000003)
            {
            }
            action("&Split Item Charges")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Split Item Charges';

                trigger OnAction()
                begin
                    //001
                    SplitIC;
                    //001
                end;
            }
            separator(Action1000000001)
            {
            }
            action("&Update BO")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Update BO';

                trigger OnAction()
                begin
                    rec.ActLinBO;//004
                end;
            }
        }
    }

    var
        UsSetUp: Record "User Setup";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        Error003: Label 'Qty to Adjust BO cannont be greater than Qty. BO Pending';
        //Error001: Label 'User has not permission to change Unit Price %1';Usuario no tiene permisos para cambiar %1
        Error001: Label 'Usuario no tiene permisos para cambiar %1'; //Pendiente


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        //005
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        SalesHeader.TestField("Pedido Consignacion", false);
        //005
    end;


    procedure SplitIC()
    var
        SalesLinSIC: Record "Sales Line";
    begin
        CurrPage.SetSelectionFilter(SalesLinSIC);
        REPORT.Run(REPORT::"Split Sales Item Charge", false, false, SalesLinSIC);
    end;


}

