pageextension 50098 pageextension50098 extends "Location Card"
{
    layout
    {
        modify("Post Code")
        {
            ToolTip = 'Specifies the ZIP Code.';
        }
        // modify(ElectronicDocument)
        // {
        //     Visible = false;
        // }
        /*         modify("SAT State Code")
                {
                    Visible = false;
                }
                modify("SAT Municipality Code")
                {
                    Visible = false;
                }
                modify("SAT Locality Code")
                {
                    Visible = false;
                }
                modify("SAT Suburb Code")
                {
                    Visible = false;
                }
                modify("SAT Postal Code")
                {
                    Visible = false;
                }
                modify("ID Ubicacion")
                {
                    Visible = false;
                } */
        // addafter("Provincial Tax Area Code")
        // {
        //     field(Inactivo; rec.Inactivo)
        //     {
        //         ApplicationArea = Basic, Suite;
        //     }
        //     field("Cod. Transportista"; rec."Cod. Transportista")
        //     {
        //         ApplicationArea = Basic, Suite;
        //     }
        // }
        addfirst(Warehouse)
        {
            field("Cant. Lineas a Man. Por dia"; rec."Cant. Lineas a Man. Por dia")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Aviso cuando resten"; rec."Aviso cuando resten")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Require Put-away")
        {
            field("Packing requerido"; rec."Packing requerido")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Cross-Dock Due Date Calc.")
        {
            field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
            {
                Caption = 'Tax Prod. Posting Group Advanced';
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Inventory Posting Setup")
        {
            ToolTip = 'Set up links between inventory posting groups, inventory locations, and general ledger accounts to define where transactions for inventory items are recorded in the general ledger.';
        }
        modify("&Bins")
        {
            ToolTip = 'View or edit information about bins that you use at this location to hold items.';
        }
        modify("Online Map")
        {
            ToolTip = 'View the address on an online map.';
        }
    }
}

