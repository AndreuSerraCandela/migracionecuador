page 56068 "Lista Cupones"
{
    ApplicationArea = all;
    CardPageID = "Cab. Cupon";
    Editable = false;
    PageType = List;
    SourceTable = "Cab. Cupon.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Cupon"; rec."No. Cupon")
                {
                }
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field("Nombre Cliente"; rec."Nombre Cliente")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field("Valido Desde"; rec."Valido Desde")
                {
                }
                field("Valido Hasta"; rec."Valido Hasta")
                {
                }
                field("No. Series"; rec."No. Series")
                {
                }
                field(Impreso; rec.Impreso)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Descuento a Colegio"; rec."Descuento a Colegio")
                {
                }
                field("Descuento a Padres de Familia"; rec."Descuento a Padres de Familia")
                {
                }
                field("Campaña"; rec.Campaña)
                {
                }
                field(Pendiente; rec.Pendiente)
                {
                }
                field("No. Lote"; rec."No. Lote")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Razon Anulacion"; rec."Razon Anulacion")
                {
                }
                field(Anulado; rec.Anulado)
                {
                }
                field("Fecha Creacion"; rec."Fecha Creacion")
                {
                }
                field("Hora Creacion"; rec."Hora Creacion")
                {
                }
                field("Creado por Usuario"; rec."Creado por Usuario")
                {
                }
            }
        }
    }

    actions
    {
    }
}

