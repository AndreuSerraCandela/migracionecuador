page 56052 "Lin. Consignacion a Facturar"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Lin. Consignacion a Facturar";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; rec."Document No.")
                {
                    Editable = false;
                }
                field(Type; rec.Type)
                {
                    Editable = false;
                }
                field("No."; rec."No.")
                {
                    Editable = false;
                }
                field(Description; rec.Description)
                {
                    Editable = false;
                }
                field("Line Discount %"; rec."Line Discount %")
                {
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; rec.Quantity)
                {
                    Editable = false;
                }
                field("Cantidad a Facturar"; rec."Cantidad a Facturar")
                {
                }
                field(Marcada; rec.Marcada)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Excel Document")
            {
                Caption = 'Import Excel Document';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FuncSant.RecibeNoDoc(NoPedido);
                    REPORT.RunModal(56027);
                    CurrPage.Update;
                end;
            }
            separator(Action1000000015)
            {
            }
            action("Update Discounts")
            {
                Caption = 'Update Discounts';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(PageActDesc);
                    PageActDesc.RecibeNoPedido(NoPedido);
                    PageActDesc.RunModal;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        rec.Reset;
        rec.SetRange("Document Type", rec."Document Type"::Order);
        rec.SetRange("Document No.", NoPedido);
        rec.SetRange("ID Usuario", UserId);
        rec.SetRange(Marcada, true);
        if rec.FindSet then
            repeat
                SalesLine1.Reset;
                SalesLine1.SetRange(SalesLine1."Document Type", SalesLine1."Document Type"::Order);
                SalesLine1.SetRange(SalesLine1."Document No.", NoPedido);
                if SalesLine1.FindLast then
                    NoLinea := SalesLine1."Line No."
                else
                    NoLinea := 0;

                NoLinea += 10000;
                SalesLine.Init;
                SalesLine.Validate("Document Type", SalesLine."Document Type"::Order);
                SalesLine.Validate("Document No.", NoPedido);
                SalesLine.Validate("Line No.", NoLinea);
                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine.Validate("No.", rec."No.");

                SalesLine.Validate("No. Mov. Prod. Cosg. a Liq.", rec."No. Mov. Prod. Cosg. a Liq.");

                //La cantidad que se pasa a las lineas de venta es la pendiente en el
                //Mov. producto
                SalesLine.Validate(Quantity, rec."Cantidad a Facturar");
                SalesLine.Validate("Unit of Measure Code", rec."Unit of Measure Code");
                SalesLine.Validate("No. Pedido Consignacion", rec."No. Pedido Consignacion");
                SalesLine.Validate("No. Linea Pedido Consignacion", rec."No. Linea Pedido Consignacion");
                SalesLine.Validate("Line Discount %", rec."Line Discount %");
                SalesLine.Insert(true);

            until rec.Next = 0;


        rec.Reset;
        rec.SetRange("ID Usuario", UserId);
        rec.DeleteAll;
    end;

    trigger OnOpenPage()
    begin
        rec.Reset;
        rec.setRange("ID Usuario", UserId);
    end;

    var
        NoPedido: Code[20];
        SalesLine1: Record "Sales Line";
        SalesLine: Record "Sales Line";
        rConsAFact: Record "Lin. Consignacion a Facturar" temporary;
        NoLinea: Integer;
        SH: Record "Sales Header";
        rLinCons: Record "Lin. Consignacion a Facturar" temporary;
        rItem: Record Item;
        rLCF: Record "Lin. Consignacion a Facturar";
        FuncSant: Codeunit "Funciones Santillana";
        PageActDesc: Page "Actualiza Descuento";


    procedure RecibeNoPedido(NoPedido_Loc: Code[20])
    begin
        NoPedido := NoPedido_Loc;
    end;
}

