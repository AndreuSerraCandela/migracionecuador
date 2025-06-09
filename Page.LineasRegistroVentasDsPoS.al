page 76265 "Lineas Registro Ventas DsPoS"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Detalle Log Registro DsPOS";
    SourceTableView = SORTING ("Fecha Documento", Tienda, TPV, "No. Documento")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Control1000000010)
            {
                ShowCaption = false;
                field("Fecha Documento"; rec."Fecha Documento")
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(TPV; rec.TPV)
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("No. Documento"; rec."No. Documento")
                {
                }
                field(Texto; rec.Texto)
                {
                }
                field(Error; rec.Error)
                {
                }
                field(Registrado; rec.Registrado)
                {
                }
                field(Liquidado; rec.Liquidado)
                {
                }
            }
        }
    }

    actions
    {
    }
}

