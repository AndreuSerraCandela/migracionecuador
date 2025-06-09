page 76406 "Subform declaracion caja"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    MultipleNewLines = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "Lin. declaracion caja";
    SourceTableView = SORTING("No. tienda", "No. TPV", Fecha, "No. turno", "Forma de pago")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Forma de pago"; rec."Forma de pago")
                {
                    Editable = false;
                }
                field(Descripcion; rec.Descripcion)
                {
                    Editable = false;
                }
                field("Cod. divisa"; rec."Cod. divisa")
                {
                    Editable = false;
                }
                field("Requiere recueto"; rec."Requiere recueto")
                {
                    Editable = false;
                }
                field("Importe calculado"; rec."Importe calculado")
                {
                    Editable = false;
                }
                field("Importe contado"; rec."Importe contado")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rec.LookupArqueo;
                        ActualizarEstiloTexto;
                    end;

                    trigger OnValidate()
                    begin
                        ActualizarEstiloTexto;
                    end;
                }
                field(Diferencia; rec.TraerDiferencia)
                {
                    Caption = 'Descuadre';
                    Editable = false;
                    StyleExpr = texEstiloTexto;
                }
                field("Importe calculado (DL)"; rec."Importe calculado (DL)")
                {
                    Editable = false;
                }
                field("Importe contado (DL)"; rec."Importe contado (DL)")
                {
                }
                field(DiferenciaDL; rec.TraerDiferenciaDL)
                {
                    Caption = 'Descuadre (DL)';
                    Editable = false;
                    StyleExpr = texEstiloTexto;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Recuento de caja")
            {
                Image = InsertCurrency;

                trigger OnAction()
                begin
                    rec.LookupArqueo;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActualizarEstiloTexto;
    end;

    trigger OnAfterGetRecord()
    begin
        ActualizarEstiloTexto;
    end;

    var
        texEstiloTexto: Text;


    procedure ActualizarEstiloTexto()
    var
        Text001: Label 'Favorable';
        Text002: Label 'Unfavorable';
    begin
        if rec.TraerDiferencia = 0 then
            texEstiloTexto := Text001
        else
            texEstiloTexto := Text002;
    end;
}

