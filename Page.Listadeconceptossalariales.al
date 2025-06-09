page 76065 "Lista de conceptos salariales"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Conceptos salariales";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Dimension Nomina"; rec."Dimension Nomina")
                {
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Tipo Cuenta Cuota Obrera"; rec."Tipo Cuenta Cuota Obrera")
                {
                }
                field("No. Cuenta Cuota Obrera"; rec."No. Cuenta Cuota Obrera")
                {
                }
                field("Tipo Cuenta Cuota Patronal"; rec."Tipo Cuenta Cuota Patronal")
                {
                }
                field("No. Cuenta Cuota Patronal"; rec."No. Cuenta Cuota Patronal")
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                    Visible = false;
                }
                field("Imprimir descripcion"; rec."Imprimir descripcion")
                {
                    Visible = false;
                }
                field(Provisionar; rec.Provisionar)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Alta/modificación")
            {
                Caption = '&Alta/modificación';
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Conceptos salariales";
                RunPageLink = "Dimension Nomina" = FIELD ("Dimension Nomina"),
                              Descripcion = FIELD (Descripcion);
                Visible = false;
            }
            action("&Listado")
            {
                Caption = '&Listado';
                Ellipsis = true;
                Enabled = false;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Listado de Nominas";
                Visible = false;
            }
        }
    }
}

