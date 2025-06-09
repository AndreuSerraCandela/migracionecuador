pageextension 50103 pageextension50103 extends "Transfer Order Subform"
{
    layout
    {

        //Unsupported feature: Property Modification (ImplicitType) on "Description(Control 4)".

        modify("Transfer-from Bin Code")
        {
            Visible = true;
        }
        modify("Transfer-To Bin Code")
        {
            Visible = true;
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Qty. to Ship")
        {
            ToolTip = 'Specifies the quantity of items that remain to be shipped.';
        }
        modify("Quantity Shipped")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';
        }
        modify("Qty. to Receive")
        {
            ToolTip = 'Specifies the quantity of items that remains to be received.';
        }
        modify("Quantity Received")
        {
            ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
        }
        modify("Shipment Date")
        {
            ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
        }
        modify("Appl.-to Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied to.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }

        // modify("Custom Transit Number")
        // {
        //     Visible = false;
        // }
        addafter("Transfer-To Bin Code")
        {
            field("Cantidad Solicitada"; rec."Cantidad Solicitada")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Porcentaje Cant. Aprobada"; rec."Porcentaje Cant. Aprobada")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cantidad Aprobada"; rec."Cantidad Aprobada")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Cantidad pendiente BO"; rec."Cantidad pendiente BO")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("Qty. to Ship")
        {
            field("Precio Venta Consignacion"; rec."Precio Venta Consignacion")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Consignment Sales Price';
                Editable = false;
            }
            field("Descuento % Consignacion"; rec."Descuento % Consignacion")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Consignment Discount %';
                Editable = false;
            }
            field("Importe Consignacion"; rec."Importe Consignacion")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Consignment Amount';
                Editable = false;
            }
            field("Importe Consignacion Original"; rec."Importe Consignacion Original")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Original Consignment Amount';
                Editable = false;
                Visible = false;
            }
        }
    }
    actions
    {
        modify(Reserve)
        {
            ToolTip = 'Reserve the quantity that is required on the document line that you opened this window for.';
        }
        modify("Event")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify(Shipment)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify(Receipt)
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
    }

    var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetDimensionsVisibility;
    IsPACEnabled := EInvoiceMgt.IsPACEnvironmentEnabled;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetDimensionsVisibility;
    */
    //end;
}

