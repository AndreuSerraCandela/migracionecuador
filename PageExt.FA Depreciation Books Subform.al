pageextension 50097 pageextension50097 extends "FA Depreciation Books Subform"
{
    layout
    {
        modify("Depreciation Book Code")
        {
            ToolTip = 'Specifies the depreciation book that is assigned to the fixed asset.';
        }
        /*modify(GetAddCurrCode) no existe el campo validar en nav
        {
            Visible = true;
        }*/
        modify("No. of Depreciation Months")
        {
            Visible = true;
        }
        modify("Straight-Line %")
        {
            Visible = true;
        }
        modify("Fixed Depr. Amount")
        {
            Visible = true;
        }
        modify("First User-Defined Depr. Date")
        {
            Visible = true;
        }
        modify("Depreciation Table Code")
        {
            Visible = true;
        }
        modify("Final Rounding Amount")
        {
            Visible = true;
        }
        modify("Ending Book Value")
        {
            Visible = true;
        }
        modify("Projected Disposal Date")
        {
            Visible = true;
        }
        modify("Projected Proceeds on Disposal")
        {
            Visible = true;
        }
        modify("Depr. Starting Date (Custom 1)")
        {
            ToolTip = 'Specifies the starting date for depreciation of custom 1 entries.';
            Visible = true;
        }
        modify("Depr. Ending Date (Custom 1)")
        {
            Visible = true;
        }
        modify("Accum. Depr. % (Custom 1)")
        {
            Visible = true;
        }
        modify("Depr. This Year % (Custom 1)")
        {
            Visible = true;
        }
        modify("Property Class (Custom 1)")
        {
            Visible = true;
        }
        addafter("Ending Book Value")
        {
            field("Acquisition Cost"; rec."Acquisition Cost")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Depreciation; rec.Depreciation)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Projected Proceeds on Disposal")
        {
            field("Proceeds on Disposal"; rec."Proceeds on Disposal")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Gain/Loss"; rec."Gain/Loss")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Write-Down"; rec."Write-Down")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Appreciation; rec.Appreciation)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Custom 1"; rec."Custom 1")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Custom 2"; rec."Custom 2")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Depreciable Basis"; rec."Depreciable Basis")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Salvage Value"; rec."Salvage Value")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Book Value on Disposal"; rec."Book Value on Disposal")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Maintenance; rec.Maintenance)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Acquisition Date"; rec."Acquisition Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("G/L Acquisition Date"; rec."G/L Acquisition Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Disposal Date"; rec."Disposal Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Acquisition Cost Date"; rec."Last Acquisition Cost Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Depreciation Date"; rec."Last Depreciation Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Write-Down Date"; rec."Last Write-Down Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Appreciation Date"; rec."Last Appreciation Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Custom 1 Date"; rec."Last Custom 1 Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Custom 2 Date"; rec."Last Custom 2 Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Salvage Value Date"; rec."Last Salvage Value Date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Maintenance Date"; rec."Last Maintenance Date")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

