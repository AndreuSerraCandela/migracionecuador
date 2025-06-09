pageextension 50025 pageextension50025 extends "Purchase Statistics"
{
    layout
    {
        modify(InvDiscountAmount)
        {
            ToolTip = 'Specifies the invoice discount amount for the purchase document.';
        }
        modify(TotalAmount1)
        {
            ToolTip = 'Specifies the total amount less any invoice discount amount and excluding tax for the purchase document.';
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
        txtRet: array[9] of Text[30];
        wRet: array[9] of Decimal;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        OnAfterCalculateTotals;
    end;

    local procedure OnAfterCalculateTotals()
    var
        cuRetenciones: Codeunit "Proceso Retenciones";
        wImporteRetencion: Decimal;
        Contador: Integer;
        PurchLine: Record "Purchase Line";
        Adicionales: Decimal;
        IvaAdicional: Decimal;
        RetencionDoc: Record "Retencion Doc. Proveedores";
        TotalPurchLine: Record "Purchase Line";
        TotalPurchLineLCY: Record "Purchase Line";
        PurchPost: Codeunit "Purch.-Post";
        VATAmount: Decimal;
        TempPurchLine: Record "Purchase Line" temporary;
        VATAmountText: Text[30];
        TotalAmt1: Decimal;
        TotalAmt2: Decimal;
    begin
        Clear(TotalPurchLine);
        Clear(TotalPurchLineLCY);
        Clear(PurchPost);

        PurchPost.GetPurchLines(Rec, TempPurchLine, 0);
        Clear(PurchPost);
        PurchPost.SumPurchLinesTemp(
          Rec, TempPurchLine, 0, TotalPurchLine, TotalPurchLineLCY, VATAmount, VATAmountText);

        if Rec."Prices Including VAT" then begin
            TotalAmt2 := TotalPurchLine.Amount;
            TotalAmt1 := TotalAmt2 + VATAmount;
        end else begin
            TotalAmt1 := TotalPurchLine.Amount;
            TotalAmt2 := TotalPurchLine."Amount Including VAT";
        end;

        //DSLoc1.01
        Contador := 0;
        RetencionDoc.Reset;
        RetencionDoc.SetCurrentKey("Cód. Proveedor", "Tipo documento", "No. documento");
        RetencionDoc.SetRange("Cód. Proveedor", Rec."Buy-from Vendor No.");
        RetencionDoc.SetRange("Tipo documento", Rec."Document Type");
        RetencionDoc.SetRange("No. documento", Rec."No.");
        if RetencionDoc.FindSet(false) then begin
            repeat
                Contador += 1;
                if RetencionDoc."Base Cálculo" <> RetencionDoc."Base Cálculo"::Ninguno then begin
                    if Rec."Prices Including VAT" then
                        wImporteRetencion := cuRetenciones.CalculaRetencion(RetencionDoc, (VATAmount + IvaAdicional), (TotalAmt2 - Adicionales),
                        TotalAmt1 - Adicionales)
                    else
                        wImporteRetencion := cuRetenciones.CalculaRetencion(RetencionDoc, (VATAmount + IvaAdicional), (TotalAmt1 - Adicionales),
                        (TotalAmt2 - Adicionales));
                end
                else begin
                    Rec.TestField("Base Retencion Indefinida");
                    wImporteRetencion := cuRetenciones.CalculaRetencion(RetencionDoc, VATAmount, TotalAmt1, Rec."Base Retencion Indefinida");
                end;
                wRet[Contador] := wImporteRetencion;
                txtRet[Contador] := RetencionDoc."Código Retención";
            until RetencionDoc.Next = 0;
        end;
        //DSLoc1.01
    end;
}

