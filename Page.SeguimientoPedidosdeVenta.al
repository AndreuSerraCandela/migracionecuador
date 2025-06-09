page 56062 "Seguimiento Pedidos de Venta"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bill-to Customer No."; rec."Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; rec."Bill-to Name")
                {
                }
                field("No."; rec."No.")
                {
                }
                field("Posting Date"; rec."Posting Date")
                {
                }
                field("No. Envio de Almacen"; rec."No. Envio de Almacen")
                {
                }
                field("No. Picking"; rec."No. Picking")
                {
                }
                field("No. Picking Reg."; rec."No. Picking Reg.")
                {
                }
                field("No. Packing"; rec."No. Packing")
                {
                }
                field("No. Packing Reg."; rec."No. Packing Reg.")
                {
                }
                field("No. Factura"; rec."No. Factura")
                {
                }
                field("No. Envio"; rec."No. Envio")
                {
                }
                field("Assigned User ID"; rec."Assigned User ID")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SH.Reset;
        SH.SetRange("Document Type", SH."Document Type"::Order);
        if SH.FindSet then begin
            Counter := 0;
            Window.Open(Text003);
            CounterTotal := SH.Count;
            repeat
                Counter := Counter + 1;
                Window.Update(1, SH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                //envio de almacen
                WHSL.Reset;
                WHSL.SetCurrentKey("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WHSL.SetRange("Source Type", 37);
                WHSL.SetRange("Source No.", SH."No.");
                if WHSL.FindFirst then
                    SH."No. Envio de Almacen" := WHSL."No.";

                //Picking
                WHAl.Reset;
                WHAl.SetCurrentKey("Source Document", "Source No.");
                WHAl.SetRange("Source Document", WHAl."Source Document"::"Sales Order");
                WHAl.SetRange("Source No.", SH."No.");
                if WHAl.FindFirst then
                    SH."No. Picking" := WHAl."No.";

                //Picking Registrado  No.,Source Document,Source No.
                RWAL.Reset;
                RWAL.SetCurrentKey("Source Document", "Source No.");
                RWAL.SetRange("Source Document", RWAL."Source Document"::"Sales Order");
                RWAL.SetRange("Source No.", SH."No.");
                if RWAL.FindFirst then
                    SH."No. Picking Reg." := RWAL."No.";

                //Packing
                LP.Reset;
                LP.SetCurrentKey("No. Picking");
                LP.SetRange("No. Picking", RWAL."No.");
                if LP.FindFirst then
                    SH."No. Packing" := LP."No.";

                //Packing Registrado
                LPR.Reset;
                LPR.SetCurrentKey("No. Picking");
                LPR.SetRange(LPR."No. Picking", RWAL."No.");
                if LPR.FindFirst then
                    SH."No. Packing Reg." := LPR."No.";
                SH.Modify;

                //Remision de venta
                SSH.Reset;
                SSH.SetCurrentKey("Order No.");
                SSH.SetRange("Order No.", SH."No.");
                if SSH.FindFirst then
                    SH."No. Envio" := SSH."No.";

                //Factura de venta
                SIH.Reset;
                SIH.SetCurrentKey("Order No.");
                SIH.SetRange(SIH."Order No.", SH."No.");
                if SIH.FindFirst then
                    SH."No. Factura" := SIH."No.";
                SH.Modify;
            until SH.Next = 0;
            Window.Close;
            Commit
        end;
    end;

    var
        WHSL: Record "Warehouse Shipment Line";
        WHAl: Record "Warehouse Activity Line";
        RWAL: Record "Registered Whse. Activity Line";
        LP: Record "Lin. Packing";
        LPR: Record "Lin. Packing Registrada";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        SH: Record "Sales Header";
        SSH: Record "Sales Shipment Header";
        SIH: Record "Sales Invoice Header";
        Text003: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
}

