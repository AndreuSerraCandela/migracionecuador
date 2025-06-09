page 76286 "Lista de Talleres - Eventos"
{
    ApplicationArea = all;

    Caption = 'List of workshops - events';
    CardPageID = "Ficha Talleres - Eventos";
    Editable = false;
    PageType = List;
    SourceTable = Eventos;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field("Tipo de Evento"; rec."Tipo de Evento")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field(Categoria; rec.Categoria)
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Expositores; rec.Expositores)
                {
                }
                field(Sala; rec.Sala)
                {
                }
                field("Fecha creacion"; rec."Fecha creacion")
                {
                }
                field("Horas programadas"; rec."Horas programadas")
                {
                }
                field("Capacidad de vacantes"; rec."Capacidad de vacantes")
                {
                }
                field("Eventos programados"; rec."Eventos programados")
                {
                }
                field("Importe Gasto Expositor"; rec."Importe Gasto Expositor")
                {
                }
                field("Importe Gasto mensajeria"; rec."Importe Gasto mensajeria")
                {
                }
                field("ImporteGastos Impresion"; rec."ImporteGastos Impresion")
                {
                }
                field("Importe Utiles"; rec."Importe Utiles")
                {
                }
                field("Importe Atenciones"; rec."Importe Atenciones")
                {
                }
                field("Otros Importes"; rec."Otros Importes")
                {
                }
            }
        }
    }

    actions
    {
    }
}

