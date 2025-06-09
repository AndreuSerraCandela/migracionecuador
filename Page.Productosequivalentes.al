page 76357 "Productos equivalentes"
{
    ApplicationArea = all;

    Caption = 'Equivalent Products';
    PageType = Card;
    SourceTable = "Productos Equivalentes";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field("Nombre Producto"; rec."Nombre Producto")
                {
                    Editable = false;
                }
                field("Cod. Producto Anterior"; rec."Cod. Producto Anterior")
                {
                }
                field("Nombre Producto Anterior"; rec."Nombre Producto Anterior")
                {
                    Editable = false;
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
                    RunPageLink = "No." = FIELD("Cod. Producto Anterior");
                }
                separator(Action1000000015)
                {
                }
                action("&Import Items")
                {
                    Caption = '&Import Items';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ImportaProdEquiv: Report "Importa Productos Equivalentes";
                    begin
                        ImportaProdEquiv.RunModal;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }
}

