page 76075 Contratos
{
    ApplicationArea = all;
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = List;
    SourceTable = Contratos;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Empresa cotización"; rec."Empresa cotización")
                {
                    Visible = false;
                }
                field("No. empleado"; rec."No. empleado")
                {
                    Visible = false;
                }
                field("No. Orden"; rec."No. Orden")
                {
                    Visible = false;
                }
                field("Cód. contrato"; rec."Cód. contrato")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field("Frecuencia de pago"; rec."Frecuencia de pago")
                {
                }
                field("Fecha inicio"; rec."Fecha inicio")
                {
                }
                field(Duracion; rec.Duracion)
                {
                }
                field("Fecha finalización"; rec."Fecha finalización")
                {
                }
                field(Activo; rec.Activo)
                {
                }
                field(Indefinido; rec.Indefinido)
                {
                }
                field(Cargo; rec.Cargo)
                {
                }
                field("Centro trabajo"; rec."Centro trabajo")
                {
                }
                field(Finalizado; rec.Finalizado)
                {
                }
                field("Días preaviso"; rec."Días preaviso")
                {
                }
                field("Período prueba"; rec."Período prueba")
                {
                    Visible = false;
                }
                field(Jornada; rec.Jornada)
                {
                    Visible = false;
                }
                field("Días semana"; rec."Días semana")
                {
                    Visible = false;
                }
                field("Horas dia"; rec."Horas dia")
                {
                    Visible = false;
                }
                field("Horas semana"; rec."Horas semana")
                {
                }
                field("Motivo baja"; rec."Motivo baja")
                {
                }
                field("Causa de la Baja"; rec."Causa de la Baja")
                {
                }
                field("Pagar preaviso"; rec."Pagar preaviso")
                {
                    Visible = false;
                }
                field("Pagar cesantia"; rec."Pagar cesantia")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        ContratoCopiaBasica: Record Contratos;
}

