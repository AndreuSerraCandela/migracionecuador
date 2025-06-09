page 76066 "Seleccion beneficios"
{
    ApplicationArea = all;
    Caption = 'Benefit selection';
    PageType = ListPart;
    SourceTable = "Seleccion beneficios";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Seleccionar; rec.Seleccionar)
                {
                }
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tipo Beneficio"; rec."Tipo Beneficio")
                {
                    Editable = false;
                }
                field(Codigo; rec.Codigo)
                {
                    Editable = false;
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
                field(Importe; rec.Importe)
                {
                    Editable = EditaImporte;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        EditaImporte := false;
        if rec."Tipo Beneficio" = rec."Tipo Beneficio"::Ingresos then
            EditaImporte := true;
    end;

    var

        EditaImporte: Boolean;
}

