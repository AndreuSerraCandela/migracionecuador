page 76365 "Promotores - Ppto Muestras"
{
    ApplicationArea = all;
    Caption = 'Samples budget Commercial';
    DataCaptionFields = "Cod. Promotor", "Nombre Promotor";
    PageType = Card;
    SourceTable = "Promotor - Ppto Muestras";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Visible = false;
                }
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field("Item Description"; rec."Item Description")
                {
                    Editable = false;
                }
                field(Quantity; rec.Quantity)
                {
                }
                field("Extended Quantity"; rec."Extended Quantity")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                action("&Item card")
                {
                    Caption = '&Item card';
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("Cod. Producto");
                    ShortCutKey = 'Shift+F5';
                }
                action("&Equivalent Item card")
                {
                    Caption = '&Equivalent Item card';
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("Cod. producto equivalente");
                }
                separator(Action1000000020)
                {
                }
                action("&Insert Items")
                {
                    Caption = '&Insert Items';

                    trigger OnAction()
                    begin
                        CopiaProducto.RecibeDatos(rec."Cod. Promotor", 1);
                        CopiaProducto.RunModal();
                    end;
                }
                action("I&mport Budget")
                {
                    Caption = 'I&mport Budget';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ProcImportaPpto: Report "Importa Presupuestos Comercial";
                    begin
                        ProcImportaPpto.RecibeParametros(1);
                        ProcImportaPpto.RunModal;
                    end;
                }
            }
        }
    }

    var
        CopiaProducto: Report "Copia productos";
}

