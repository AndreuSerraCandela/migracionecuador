page 50000 "Pantalla Scanner manual"
{
    ApplicationArea = all;
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Control1000000007)
            {
                ShowCaption = false;
                label(Control1000000008)
                {
                    CaptionClass = Text19049871;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                label(Control1000000010)
                {
                    CaptionClass = Text19037213;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                label(Control1000000012)
                {
                    CaptionClass = Text19065178;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(NoDocumento; NoDocumento)
                {
                    Editable = false;
                    ShowCaption = false;
                }
                field(CodBarras; cCodBarras)
                {
                }
                label(Control1000000014)
                {
                    CaptionClass = Format(DescPro);
                    Editable = false;
                    ShowCaption = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Cant; wCantidad)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Intro)
            {
                Caption = 'Aceptar';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BuscarEnPedido;
                end;
            }
        }
    }

    var
        NoDocumento: Code[20];
        TipoDocumento: Option;
        DescPro: Text[200];
        wCantidad: Decimal;
        cCodBarras: Code[20];
        rUdadMedProd: Record "Item Unit of Measure";
        rTransferLine: Record "Transfer Line";
        txt0001: Label 'Producto no se encuentra en Lineas de Transferencia %1 %2';
        txt0002: Label 'No se encuentra el codigo de barra %2';
        Text19049871: Label 'No. Documento';
        Text19037213: Label 'Cod. Barras';
        Text19065178: Label 'Cantidad';


    procedure RecibeParam(NoPedido: Code[20])
    begin
        NoDocumento := NoPedido;
    end;


    procedure BuscarEnPedido()
    var
        rItemCrossRe: Record "Item Reference";
        rItem: Record Item;
    begin
        if cCodBarras <> '' then begin
            rItemCrossRe.Reset;
            rItemCrossRe.SetRange(rItemCrossRe."Reference Type", rItemCrossRe."Reference Type"::"Bar Code");
            rItemCrossRe.SetRange(rItemCrossRe."Reference No.", cCodBarras);
            if rItemCrossRe.Find('-') then begin
                if rItem.Get(rItemCrossRe."Item No.") then begin
                    DescPro := rItem.Description;
                    CurrPage.Update;
                end;
                //Buscamo linea en el pedido
                rTransferLine.Reset;
                rTransferLine.SetRange(rTransferLine."Document No.", NoDocumento);
                rTransferLine.SetRange(rTransferLine."Item No.", rItem."No.");
                if rTransferLine.FindFirst then begin
                    rTransferLine."Qty. to Ship" += wCantidad;
                    rTransferLine.Validate("Qty. to Ship");
                    rTransferLine.Modify(true);
                end
                else
                    Message(txt0001, rItem."No.", rItem.Description);
            end
            else
                Message(txt0002, cCodBarras);
        end;
    end;

    local procedure cCodBarrasOnDeactivate()
    var
        rItemCrossRe: Record "Item Reference";
        rItem: Record Item;
    begin
        rItemCrossRe.Reset;
        rItemCrossRe.SetRange(rItemCrossRe."Reference Type", rItemCrossRe."Reference Type"::"Bar Code");
        rItemCrossRe.SetRange(rItemCrossRe."Reference No.", cCodBarras);
        if rItemCrossRe.Find('-') then begin
            if rItem.Get(rItemCrossRe."Item No.") then
                if rItemCrossRe."Unit of Measure" <> '' then begin
                    rUdadMedProd.Get(rItem."No.", rItemCrossRe."Unit of Measure");
                    DescPro := rItem.Description;
                    CurrPage.Update;
                end;
        end;
    end;
}

