codeunit 76058 "Pre Tr-Order to Tr-Order"
{
    // #71176  JPT 29/06/2017 Fecha Aprobacion Pedido .Este campo se debe llenar solo al momento de convertirse de un Pre Pedido a Pedido tanto para venta como transferencia tomando la fecha en la que se esta ejecutando
    //                        siendo este un valor no editable y fijo, cabe recalcar que este campo debe viajar como referencia al histórico de facturas de venta y guía de remisión para su trazabilidad.

    TableNo = "Transfer Header";

    trigger OnRun()
    begin
        Rec.TestField("Pre pedido", true);
        ConfSant.Get;

        ValidaReq.Maestros(5740, Rec."No.");
        ValidaReq.Dimensiones(5740, Rec."No.", 0, 0);

        TH := Rec;
        PrePed := Rec;
        TL.Reset;
        TL.SetRange("Document No.", Rec."No.");
        ContLin := TL.Count;

        // <#71176  JPT 29/06/2017>
        PrePed."Fecha Aprobacion" := Today;
        PrePed."Hora Aprobacion" := Time;
        PrePed."Usuario Aprobacion" := UserId;
        // <\#71176  JPT 29/06/2017>


        ConfSant.TestField("Cantidad Lin. por factura");
        Result := ContLin / ConfSant."Cantidad Lin. por factura" mod 1;
        if Result <> 0 then
            for I := 1 to Round(ContLin / ConfSant."Cantidad Lin. por factura", 1, '<') + 1 do
                CrearCabecera
        else
            for I := 1 to Round(ContLin / ConfSant."Cantidad Lin. por factura", 1, '<') do
                CrearCabecera;

        Rec.DeleteLinks;
        Rec.Delete;

        TL.Reset;
        TL.SetRange("Document No.", Rec."No.");
        TL.DeleteAll;
    end;

    var
        ValidaReq: Codeunit "Valida Campos Requeridos";
        NewTransLine: Record "Transfer Line";
        TL: Record "Transfer Line";
        TH: Record "Transfer Header";
        ContLin: Integer;
        ConfSant: Record "Config. Empresa";
        Result: Decimal;
        I: Integer;
        Seq: Integer;
        CantLin: Integer;
        DocDim: Codeunit DimensionManagement;
        PrePed: Record "Transfer Header";
        NoLin: Integer;
        RelTraDoc: Codeunit "Release Transfer Document";


    procedure CrearCabecera()
    begin
        Seq += 1;
        CantLin := 0;
        TH.TransferFields(PrePed);
        TH.Status := TH.Status::Open;
        TH."No." := TH."No." + '-' + Format(Seq);
        Clear(TH."Pre pedido");
        TL.LockTable;
        TH.Insert;


        //Lineas
        TL.Reset;
        TL.SetRange("Document No.", PrePed."No.");
        if NoLin <> 0 then
            TL.SetFilter("Line No.", '%1..', NoLin);

        if TL.FindSet then
            repeat
                CantLin += 1;
                NoLin := TL."Line No.";
                if CantLin > ConfSant."Cantidad Lin. por factura" then begin
                    TH.CopyLinks(PrePed);
                    RelTraDoc.Run(TH);
                    exit;
                end;
                NewTransLine.Init;
                NewTransLine := TL;
                NewTransLine."Document No." := TH."No.";
                NewTransLine.Insert;

            until TL.Next = 0;
        TH.CopyLinks(PrePed);
        RelTraDoc.Run(TH);
    end;


    procedure GetSalesOrderHeader(var TransHeader2: Record "Transfer Header")
    begin
        TransHeader2 := TH;
    end;
}

