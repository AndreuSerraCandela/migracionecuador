page 75017 "Lista Imp.Mdm Tabla"
{
    ApplicationArea = all;
    CardPageID = "Imp.MdM Tabla";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = true;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Imp.MdM Tabla";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id)
                {
                    Visible = false;
                }
                field(Operacion; rec.Operacion)
                {
                    Visible = false;
                }
                field("Id Tabla"; rec."Id Tabla")
                {
                }
                field("cFumImp.GetTableCaption(""Id Tabla"")"; cFumImp.GetTableCaption(rec."Id Tabla"))
                {
                    Caption = 'Nombre Tabla';
                }
                field("Code"; rec.Code)
                {
                }
                field("Code MdM"; rec."Code MdM")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Tipo; rec.Tipo)
                {
                }
                field("Nombre Elemento"; rec."Nombre Elemento")
                {
                }
                field(Visible; rec.Visible)
                {
                }
                field(Procesado; rec.Procesado)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Tabla)
            {
                Caption = 'Tabla';
                Image = "Table";
                action(Ver)
                {
                    Caption = 'Ver';
                    Image = View;
                    RunObject = Page "Imp.MdM Tabla";
                    RunPageOnRec = true;
                }
                action(Ficha)
                {
                    Image = Form;

                    trigger OnAction()
                    begin

                        rec.VerFicha;
                    end;
                }
            }
            action("Solo Pendientes")
            {

                trigger OnAction()
                begin
                    rec.SetRange(Procesado, false);
                end;
            }
        }
    }

    var
        cFumImp: Codeunit "Gest. Maestros MdM";
}

