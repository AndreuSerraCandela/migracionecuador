#pragma implicitwith disable
page 76032 "Historico lineas nomina"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    PageType = ListPart;
    Permissions = TableData "Historico Lin. nomina" = rimd;
    SourceTable = "Historico Lin. nomina";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field("Salario Base"; rec."Salario Base")
                {
                }
                field("Período"; rec.Período)
                {
                    Visible = false;
                }
                field("Cotiza ISR"; rec."Cotiza ISR")
                {
                }
                field("Sujeto Cotización"; rec."Sujeto Cotización")
                {
                }
                field("Texto Informativo"; rec."Texto Informativo")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("Currency Code"; rec."Currency Code")
                {
                }
                field("Importe Base"; rec."Importe Base")
                {
                }
                field(Total; rec.Total)
                {
                }
                field("% Cotizable"; rec."% Cotizable")
                {
                }
                field("% Pago Empleado"; rec."% Pago Empleado")
                {
                }
                field("Fórmula"; rec.Fórmula)
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field(Comentario; rec.Comentario)
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
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
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                separator(Action1000000004)
                {
                }
            }
        }
    }

    var
        AccumImporte: Decimal;
        TotalImporte: Decimal;
        AccumParcial: Decimal;
        TotalParcial: Decimal;
}

#pragma implicitwith restore

