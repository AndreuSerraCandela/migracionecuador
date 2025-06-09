page 56027 "Subform clas. devoluciones"
{
    ApplicationArea = all;
    Caption = 'Returns classification subform';
    PageType = ListPart;
    SourceTable = "Lin. clas. devoluciones";
    SourceTableView = WHERE(Processed = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Line No."; rec."Line No.")
                {
                }
                field("Item No."; rec."Item No.")
                {
                }
                field("Item Description"; rec."Item Description")
                {
                }
                field(Quantity; rec.Quantity)
                {
                    Editable = true;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Con defecto"; rec."Con defecto")
                {
                }
                field(Recuperable; rec.Recuperable)
                {
                }
                field("Cross-Reference No."; rec."Cross-Reference No.")
                {
                    Editable = false;
                }
                field("Variant Code"; rec."Variant Code")
                {
                    Editable = false;
                }
                field(Inventory; rec.Inventory)
                {
                    Editable = false;
                }
                field("Inventario en Consignacion"; rec."Inventario en Consignacion")
                {
                    Editable = false;
                }
                field("Receiving date"; rec."Receiving date")
                {
                }
                field(Comentario; rec.Comentario)
                {
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
                action("Update Line")
                {
                    Caption = 'Update Line';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #56026. Unsupported part was commented. Please check it.
                        /*CurrPage.Detalle.PAGE.*/
                        Eliminar;

                    end;
                }
            }
        }
    }


    procedure Refrescar()
    begin
        CurrPage.Update(false);
    end;


    procedure Eliminar()
    begin
        rec.Delete;
    end;
}

