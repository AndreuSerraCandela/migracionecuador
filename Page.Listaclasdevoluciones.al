page 56025 "Lista clas. devoluciones"
{
    ApplicationArea = all;

    Caption = 'Classification Returns';
    CardPageID = "Clasificacion devoluciones";
    PageType = List;
    SourceTable = "Cab. clas. devolucion";
    SourceTableView = WHERE(Closed = CONST(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Customer no."; rec."Customer no.")
                {
                }
                field("Customer name"; rec."Customer name")
                {
                }
                field("External document no."; rec."External document no.")
                {
                }
                field("Cod. Almacen"; rec."Cod. Almacen")
                {
                }
                field("Receipt date"; rec."Receipt date")
                {
                }
                field(Comentario; rec.Comentario)
                {
                    Editable = false;
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
                action("&Insert")
                {
                    Caption = '&Insert';

                    trigger OnAction()
                    var
                        CPD: Record "Cab. clas. devolucion";
                    begin
                        Clear(CPD);
                        CPD.Insert(true);
                        CurrPage.Update;
                        rec.FindSet();
                    end;
                }
                action("&Get Items")
                {
                    Caption = '&Get Items';
                    RunObject = Page "Clasificacion devoluciones";
                    RunPageOnRec = true;
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

