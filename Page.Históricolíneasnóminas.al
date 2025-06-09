#pragma implicitwith disable
page 76063 "Histórico líneas nóminas"
{
    ApplicationArea = all;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Historico Lin. nomina";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("Concepto salarial"; rec."Concepto salarial")
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field(Cantidad; rec.Cantidad)
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
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field("Salario Base"; rec."Salario Base")
                {
                }
                field("Sujeto Cotización"; rec."Sujeto Cotización")
                {
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                }
                field("Cotiza ISR"; rec."Cotiza ISR")
                {
                }
                field("Cotiza SFS"; rec."Cotiza SFS")
                {
                }
                field("Cotiza AFP"; rec."Cotiza AFP")
                {
                }
                field("Fórmula"; rec.Fórmula)
                {
                }
                field("Texto Informativo"; rec."Texto Informativo")
                {
                }
                field("Cotiza SRL"; rec."Cotiza SRL")
                {
                }
                field("Cotiza Infotep"; rec."Cotiza Infotep")
                {
                }
                field("Aplica para Regalia"; rec."Aplica para Regalia")
                {
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

