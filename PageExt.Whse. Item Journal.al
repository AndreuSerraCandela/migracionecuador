pageextension 50119 pageextension50119 extends "Whse. Item Journal"
{
    layout
    {
        modify(Description)
        {
            ToolTip = 'Specifies the description of the item.';

            //Unsupported feature: Property Modification (ImplicitType) on "Description(Control 10)".

        }
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        modify("Unit of Measure Code")
        {
            ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
        }
        addafter("Registering Date")
        {
            /*         field("Entry Type"; "Entry Type")
                    {
                        ApplicationArea = Basic, Suite;
                    } */
        }
        addafter("Whse. Document No.")
        {
            field("From Zone Code"; rec."From Zone Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("From Bin Code"; rec."From Bin Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("To Zone Code"; rec."To Zone Code")
            {
            ApplicationArea = All;
            }
            field("To Bin Code"; rec."To Bin Code")
            {
            ApplicationArea = All;
            }
            field("Line No."; rec."Line No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Variant Code")
        {
            field("Location Code"; rec."Location Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("Item &Tracking Lines")
        {
            ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';
        }
        modify("Reservation Entries")
        {
            ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';
        }
        modify("Test Report")
        {
            ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
        }
        addafter("&Registering")
        {
            group("<Action1000000002>")
            {
                Caption = '&Acciones';
                action("<Action1000000001>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cargar productos desde Excel';
                    Image = ImportExport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ImportProductos: Report "Importa Productos";
                    begin
                        //#2936
                        Clear(ImportProductos);
                        ImportProductos.RecibeSeccion(rec."Journal Batch Name", rec."Journal Template Name", rec."Location Code");
                        ImportProductos.RunModal;
                        //#2936
                    end;
                }
            }
        }
    }
}

