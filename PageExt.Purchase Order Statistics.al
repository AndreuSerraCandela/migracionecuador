pageextension 50053 pageextension50053 extends "Purchase Order Statistics"
{
    layout
    {
        modify("Quantity_General")
        {
            ToolTip = 'Specifies the total quantity of G/L account entries, fixed assets, and/or items in the purchase order.';
        }
        modify("Quantity_Invoicing")
        {
            ToolTip = 'Specifies the total quantity of G/L account entries, fixed assets, and/or items in the purchase order.';
        }
        modify("Quantity_Shipping")
        {
            ToolTip = 'Specifies the total quantity of G/L account entries, fixed assets, and/or items in the purchase order.';
        }
        modify(PrepmtInvPct)
        {
            Caption = 'Invoiced % of Prepayment Amt.';
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
        modify("TotalPurchLine[1].""Prepmt Amt to Deduct""")
        {
            CaptionClass = GetCaptionClass(Text009, false);
        }
        modify(NoOfVATLines_Invoicing)
        {
            trigger OnDrillDown()
            var
                myInt: Integer;
            begin
                //Unsupported feature:
                //if TempVATAmountLine2.GetAnyLineModified() then Validar no tengo acceso a la variable
                OnAfterRefreshOnAfterGetRecord();
            end;
        }
    }

    var
        txtRet: array[9] of Text[30];
        wRet: array[9] of Decimal;
        PurchLine: Record "Purchase Line";
        Text009: Label 'Prepmt. Amt. to Deduct'; //ESM=Importe anticipo para descontar;FRC=Montant de paiement anticipé à déduire;ENC=Prepmt. Amt. to Deduct

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        OnAfterRefreshOnAfterGetRecord;
    end;

    local procedure OnAfterRefreshOnAfterGetRecord()
    var
        Contador: Integer;
        RetencionDoc: Record "Retencion Doc. Proveedores";
        wImporteRetencion: Decimal;
        cuRetenciones: Codeunit "Proceso Retenciones";
        Adicionales: Decimal;
        IvaAdicional: Decimal;
        i: Integer;
        VATAmount: array[3] of Decimal;
        PurchPost: Codeunit "Purch.-Post";
        TotalPurchLine: array[3] of Record "Purchase Line";
        TotalPurchLineLCY: array[3] of Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        VATAmountText: array[3] of Text[30];
        TotalAmount1: array[3] of Decimal;
        TotalAmount2: array[3] of Decimal;
    begin
        for i := 1 to 3 do begin
            TempPurchLine.DeleteAll();
            Clear(TempPurchLine);
            Clear(PurchPost);
            PurchPost.GetPurchLines(Rec, TempPurchLine, i - 1);
            PurchPost.SumPurchLinesTemp(
                          Rec, TempPurchLine, i - 1, TotalPurchLine[i], TotalPurchLineLCY[i],
                          VATAmount[i], VATAmountText[i]);

            if Rec."Prices Including VAT" then begin
                TotalAmount2[i] := TotalPurchLine[i].Amount;
                TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
            end else begin
                TotalAmount1[i] := TotalPurchLine[i].Amount;
                TotalAmount2[i] := TotalPurchLine[i]."Amount Including VAT";
            end;
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
                        wImporteRetencion := cuRetenciones.CalculaRetencion(RetencionDoc, (VATAmount[Contador] + IvaAdicional), (TotalAmount2[Contador] - Adicionales),
                        TotalAmount1[Contador] - Adicionales)
                    else
                        wImporteRetencion := cuRetenciones.CalculaRetencion(RetencionDoc, (VATAmount[Contador] + IvaAdicional), (TotalAmount1[Contador] - Adicionales),
                        (TotalAmount2[Contador] - Adicionales));
                end;
                wRet[Contador] := wImporteRetencion;
                txtRet[Contador] := RetencionDoc."Código Retención";
            until RetencionDoc.Next = 0;
        end;
        //DSLoc1.01
    end;
}

