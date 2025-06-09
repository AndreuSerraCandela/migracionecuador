page 50118 "Lista Medios de Pagos SIC"
{
    ApplicationArea = all;

    PageType = List;
    SourceTable = "Medios de Pago SIC";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("No. documento SIC"; rec."No. documento SIC")
                {
                }
                field("No. linea"; rec."No. linea")
                {
                }
                field("Cod. medio de pago"; rec."Cod. medio de pago")
                {
                }
                field("Cod. cliente"; rec."Cod. cliente")
                {
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("Cod. divisa"; rec."Cod. divisa")
                {
                }
                field("Tasa de cambio"; rec."Tasa de cambio")
                {
                }
                field("Source Counter"; rec."Source Counter")
                {
                }
                field(Transferido; rec.Transferido)
                {
                }
                field("No. Serie Pos"; rec."No. Serie Pos")
                {
                }
                field("Location Code"; rec."Location Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

