#pragma implicitwith disable
page 76098 "Arqueo de caja"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    RefreshOnActivate = true;
    SourceTable = "Arqueo de caja";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tipo; Rec.Tipo)
                {
                    Editable = false;
                }
                field(Importe; Rec.Importe)
                {
                    Editable = false;
                }
                field(Cantidad; Rec.Cantidad)
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                        CurrPage.Update;
                    end;
                }
                field(Total; Rec.Total)
                {
                    Editable = false;
                }
                field("Descripción"; Rec.TraerDescripcion)
                {
                    Editable = false;
                }
            }
            group(GrupoTotal)
            {
                Caption = 'Total en caja';
                field("Total contado"; TraerTotalContado)
                {
                }
            }
        }
    }

    actions
    {
    }


    procedure TraerTotalContado(): Decimal
    var
        recArqueo: Record "Arqueo de caja";
        decTotal: Decimal;
    begin
        recArqueo.Reset;
        recArqueo.SetRange("Cod. tienda", Rec."Cod. tienda");
        recArqueo.SetRange("Cod. TPV", Rec."Cod. TPV");
        recArqueo.SetRange(Fecha, Rec.Fecha);
        recArqueo.SetRange("No. turno", Rec."No. turno");
        recArqueo.SetRange("Forma de pago", Rec."Forma de pago");
        recArqueo.SetRange("Cod. divisa", Rec."Cod. divisa");
        if recArqueo.FindFirst then begin
            repeat
                decTotal += recArqueo.Total;
            until recArqueo.Next = 0;
            exit(decTotal);
        end;
    end;
}

#pragma implicitwith restore

