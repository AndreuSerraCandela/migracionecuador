page 75005 "Imp.MdM Campos"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Imp.MdM Campos";
    SourceTableView = SORTING("Id Rel", Orden, Id);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id) // Agregado rec.
                {
                    Visible = false;
                }
                field("Id Rel"; rec."Id Rel") // Agregado rec.
                {
                    Visible = false;
                }
                field("Id Cab."; rec."Id Cab.") // Agregado rec.
                {
                    Visible = false;
                }
                field("Table Id"; rec."Table Id") // Agregado rec.
                {
                    Visible = false;
                }
                field("Id Field"; rec."Id Field") // Agregado rec.
                {
                }
                field("cFumImp.GetFieldCaption(""Table Id"",""Id Field"")"; cFumImp.GetFieldCaption(rec."Table Id", rec."Id Field")) // Agregado rec.
                {
                    Caption = 'Nombre Campo';
                }
                field(Value; rec.Value) // Agregado rec.
                {
                }
                field("MdM Value"; rec."MdM Value") // Agregado rec.
                {
                }
                field(Orden; rec.Orden) // Agregado rec.
                {
                }
                field("Nombre Elemento"; rec."Nombre Elemento") // Agregado rec.
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        cFumImp: Codeunit "Gest. Maestros MdM";
}