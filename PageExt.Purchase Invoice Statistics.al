pageextension 50052 pageextension50052 extends "Purchase Invoice Statistics"
{
    layout
    {
        modify(InvDiscAmount)
        {
            ToolTip = 'Specifies the invoice discount amount for the purchase document.';
        }
        addafter(Vendor)
        {
            group(Retencion)
            {
                Caption = 'Retention';
                field("txtRet[1]"; txtRet[1])
                {
                ApplicationArea = All;
                    Editable = false;
                }
                field("wRet[1]"; wRet[1])
                {
                ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("txtRet[2]"; txtRet[2])
                {
                ApplicationArea = All;
                    Editable = false;
                }
                field("wRet[2]"; wRet[2])
                {
                ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("txtRet[3]"; txtRet[3])
                {
                ApplicationArea = All;
                    Editable = false;
                }
                field("wRet[3]"; wRet[3])
                {
                ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("txtRet[4]"; txtRet[4])
                {
                ApplicationArea = All;
                    Editable = false;
                }
                field("wRet[4]"; wRet[4])
                {
                ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
            }
        }
    }

    var
        HistRetProv: Record "Historico Retencion Prov.";
        txtRet: array[9] of Text[30];
        wRet: array[9] of Decimal;
        Contador: Integer;
        RetencionDoc: Record "Retencion Doc. Proveedores";
        cuRetenciones: Codeunit "Proceso Retenciones";
        wImporteRetencion: Decimal;
        PurchLine: Record "Purchase Line";
        Adicionales: Decimal;
        IvaAdicional: Decimal;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //001
        Contador := 0;
        HistRetProv.Reset;
        HistRetProv.SetRange("Tipo documento", HistRetProv."Tipo documento"::Invoice);
        HistRetProv.SetRange("No. documento", Rec."No.");
        if HistRetProv.FindSet(false) then
            repeat
                Contador += 1;
                wRet[Contador] := HistRetProv."Importe Retenido";
                txtRet[Contador] := HistRetProv."Código Retención";
            until HistRetProv.Next = 0;
        //001
    end;
}

