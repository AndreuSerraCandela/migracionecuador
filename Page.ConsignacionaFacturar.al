#pragma implicitwith disable
page 56049 "Consignacion a Facturar"
{
    ApplicationArea = all;
    Caption = 'Consignment to Invoice';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Lin. Consig. Dev.Transfer Line";

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
                field("Item No."; rec."Item No.")
                {
                    Editable = false;
                }
                field(Quantity; rec.Quantity)
                {
                }
                field(Description; rec.Description)
                {
                    Editable = false;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Shipment Date"; rec."Shipment Date")
                {
                    Editable = false;
                }
                field("Precio Venta Consignacion"; rec."Precio Venta Consignacion")
                {
                    Editable = false;
                }
                field("Descuento % Consignacion"; rec."Descuento % Consignacion")
                {
                    Editable = false;
                }
                field("Importe Consignacion"; rec."Importe Consignacion")
                {
                    Editable = false;
                }
                field("No. Pedido Consignacion"; rec."No. Pedido Consignacion")
                {
                    Editable = false;
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
            action("<Action1000000006>")
            {
                Caption = 'Actualizar Desde Archivo Excel';
                Image = ImportExport;
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
        }
    }

    trigger OnClosePage()
    begin
        Ejecuta;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("ID Usuario", UserId);
    end;

    var
        NoPedido: Code[20];
        SalesLine1: Record "Sales Line";
        SalesLine: Record "Sales Line";
        rConsAFact: Record "Lin. Consig. Dev.Transfer Line";
        NoLinea: Integer;
        TransferLine1: Record "Transfer Line";
        TransferLines: Record "Transfer Line";
        DescrProd: Text[200];
        rItem: Record Item;
        FuncSant: Codeunit "Funciones Santillana";


    procedure RecibeNoPedido(NoPedido_Loc: Code[20])
    begin
        NoPedido := NoPedido_Loc;
    end;


    procedure Ejecuta()
    begin
        rConsAFact.Reset;
        rConsAFact.SetRange("Document No.", NoPedido);
        rConsAFact.SetRange("ID Usuario", UserId);
        rConsAFact.SetRange(Marcada, true);
        if rConsAFact.FindSet then
            repeat
                TransferLine1.Reset;
                TransferLine1.SetRange("Document No.", NoPedido);
                if TransferLine1.FindLast then
                    NoLinea := TransferLine1."Line No."
                else
                    NoLinea := 0;

                NoLinea += 10000;
                TransferLines.Init;
                TransferLines.Validate("Document No.", NoPedido);
                TransferLines.Validate("Line No.", NoLinea);
                TransferLines.Validate("Item No.", rConsAFact."Item No.");

                TransferLines.Validate("No. Mov. Prod. Cosg. a Liq.", rConsAFact."No. Mov. Prod. Cosg. a Liq.");

                //La cantidad que se pasa a las lineas de venta es la pendiente en el
                //Mov. producto
                TransferLines.Validate(Quantity, rConsAFact.Quantity);

                TransferLines.Validate("Unit of Measure Code", rConsAFact."Unit of Measure Code");
                //TransferLines.VALIDATE("Precio Venta Consignacion",rConsAFact."Precio Venta Consignacion");
                //TransferLines.VALIDATE("Descuento % Consignacion",rConsAFact."Descuento % Consignacion");
                TransferLines.Validate("No. Pedido Consignacion", rConsAFact."Document No.");
                TransferLines.Validate("No. Linea Pedido Consignacion", rConsAFact."Line No.");
                TransferLines.Validate(Quantity, rConsAFact.Quantity);
                TransferLines.Validate("Qty. to Ship", rConsAFact.Quantity);
                //TransferLines.VALIDATE("Descuento % Consignacion",rConsAFact."Descuento % Consignacion");
                //TransferLines.VALIDATE("Precio Venta Consignacion",rConsAFact."Precio Venta Consignacion");
                //si la cantidad pendiente es 0 no sube la linea al pedido.
                if TransferLines.Quantity > 0 then
                    TransferLines.Insert(true);

            until rConsAFact.Next = 0;
    end;
}

#pragma implicitwith restore

