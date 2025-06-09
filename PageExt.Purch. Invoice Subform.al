pageextension 50093 pageextension50093 extends "Purch. Invoice Subform"
{
    layout
    {
        modify("Location Code")
        {
            ToolTip = 'Specifies the code for the location where the items on the line will be located.';
        }
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify(Quantity)
        {
            ToolTip = 'Specifies the number of units of the item specified on the line.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        modify("Direct Unit Cost")
        {
            ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
        }
        modify("Unit Cost (LCY)")
        {
            ToolTip = 'Specifies the unit cost of the item on the line.';
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
        modify("Use Tax")
        {
            ToolTip = 'Specifies that the purchase is subject to use tax. Use tax is a sales tax that is paid on items that are purchased by a company and are used by that company instead of being sold to a customer.';
        }
        modify("Inv. Discount Amount")
        {
            ToolTip = 'Specifies the invoice discount amount for the line.';
        }
        modify("Job Task No.")
        {
            ToolTip = 'Specifies the number of the related job task.';
        }
        modify("Job Line Type")
        {
            ToolTip = 'Specifies the type of planning line that was created when the job ledger entry is posted from the purchase line. If the field is empty, no planning lines were created for this entry.';
        }
        modify("Job Unit Price")
        {
            ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
        }
        modify("Job Line Amount")
        {
            ToolTip = 'Specifies the line amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Discount Amount")
        {
            ToolTip = 'Specifies the line discount amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Discount %")
        {
            ToolTip = 'Specifies the line discount percentage of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Unit Price (LCY)")
        {
            ToolTip = 'Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
        }
        modify("Job Line Amount (LCY)")
        {
            ToolTip = 'Specifies the line amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Job Line Disc. Amount (LCY)")
        {
            ToolTip = 'Specifies the line discount amount of the job ledger entry that is related to the purchase line.';
        }
        modify("Depr. Acquisition Cost")
        {
            ToolTip = 'Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
        }
        modify("Duplicate in Depreciation Book")
        {
            ToolTip = 'Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.';
        }
        modify("Use Duplication List")
        {
            ToolTip = 'Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. ';
        }
        modify("Appl.-to Item Entry")
        {
            ToolTip = 'Specifies the number of the item ledger entry that the document or journal line is applied -to.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify("Shortcut Dimension 2 Code")
        {
            ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
        }
        modify(AmountBeforeDiscount)
        {
            ToolTip = 'Specifies the sum of the value in the Line Amount Excl. Tax field on all lines in the document.';
        }
        /*  modify("VAT Prod. Posting Group")
         {
             Visible = false;
         }
         modify("Depreciation Book Code")
         {
             Visible = false;
         }
         modify("Line No.")
         {
             Visible = false;
         } */
        addafter(FilteredTypeField)
        {
            /*             field("Line No."; "Line No.")
                        {
                            ApplicationArea = Basic, Suite;
                        } */
        }
        addafter("No.")
        {
            field("Parte del IVA"; rec."Parte del IVA")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addafter("IC Partner Reference")
        {
            /* field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
            }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';

                trigger OnValidate()
                begin
                    DeltaUpdateTotals;
                end;
            } */
        }
        addafter("Location Code")
        {
            /*  field("Depreciation Book Code"; "Depreciation Book Code")
             {
                 ApplicationArea = Basic, Suite;
             } */
        }
        addafter("Direct Unit Cost")
        {
            field(Propina; rec.Propina)
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Punto de Emision Reembolso"; rec."Punto de Emision Reembolso")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Establecimiento Reembolso"; rec."Establecimiento Reembolso")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Comprobante Reembolso"; rec."No. Comprobante Reembolso")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion Reembolso"; rec."No. Autorizacion Reembolso")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Unit Price (LCY)")
        {
            field("Cod. Colegio"; rec."Cod. Colegio")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Vendedor"; rec."Cod. Vendedor")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Cod. Taller"; rec."Cod. Taller")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Job Line Amount")
        {
            /*  field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
             {
                 ApplicationArea = Basic, Suite;
             } */
        }
    }
    actions
    {
        modify("E&xplode BOM")
        {
            ToolTip = 'Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.';
        }
        modify(InsertExtTexts)
        {
            ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';
        }
        modify("Event")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        modify(ItemChargeAssignment)
        {
            ToolTip = 'Assign additional direct costs, for example for freight, to the item on the line.';
        }
        modify("Item &Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        addafter("Related Information")
        {
            separator(Action1000000001)
            {
            }
            action("<Action1000000002>")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Item Charges Split';

                trigger OnAction()
                begin
                    //001
                    SplitIC;
                end;
            }
        }
    }

    procedure SplitIC()
    var
        PurchLinSIC: Record "Purchase Line";
    begin
        CurrPage.SetSelectionFilter(PurchLinSIC);
        REPORT.Run(REPORT::"Split Item Charge", false, false, PurchLinSIC);
    end;

    procedure Distribucion()
    var
        PurchLin: Record "Purchase Line";
    begin
        //CurrPage.SETSELECTIONFILTER(PurchLin);
        //REPORT.RUN(REPORT::"Split CC Distribution",FALSE,FALSE,PurchLin);
    end;
}

