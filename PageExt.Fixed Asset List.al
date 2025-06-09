pageextension 50095 pageextension50095 extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; rec."Description 2")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
        }
        moveafter("Description 2"; "Search Description")
        addafter("Vendor No.")
        {
            field("Total Costo"; rec."Total Costo")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
            field("Total Amortizacion"; rec."Total Amortizacion")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
        }
        addafter("Responsible Employee")
        {
            field("Nombre Responsable"; rec."Nombre Responsable")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
        }
        addafter("FA Subclass Code")
        {
            field("Serial No."; rec."Serial No.")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
            field("Cod. Barras"; rec."Cod. Barras")
            {
                ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
            }
        }
        addafter("Budgeted Asset")
        {
            field("FA Posting Group"; rec."FA Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Main Asset/Component"; rec."Main Asset/Component")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Component of Main Asset"; rec."Component of Main Asset")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Warranty Date"; rec."Warranty Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Under Maintenance"; rec."Under Maintenance")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Next Service Date"; rec."Next Service Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Blocked; rec.Blocked)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Inactive; rec.Inactive)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Producto; rec.Producto)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Dimensions-&Multiple")
        {
            ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
        }
    }
}