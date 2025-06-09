page 56063 "Seguimientos Peds. Transfer."
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                }
                field("Transfer-to Code"; rec."Transfer-to Code")
                {
                }
                field("Transfer-to Name"; rec."Transfer-to Name")
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
        TH.Reset;
        if TH.FindSet then begin
            Counter := 0;
            Window.Open(Text003);
            CounterTotal := TH.Count;
            repeat
                Counter := Counter + 1;
                Window.Update(1, TH."No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                //envio de almacen
                WHSL.Reset;
                WHSL.SetCurrentKey("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
                WHSL.SetRange("Source Type", 5741);
                WHSL.SetRange("Source No.", TH."No.");
                if WHSL.FindFirst then
                    TH."No. Envio de Almacen" := WHSL."No.";

                //Picking
                WHAl.Reset;
                WHAl.SetCurrentKey("Source Document", "Source No.");
                WHAl.SetRange("Source Document", WHAl."Source Document"::"Outbound Transfer");
                WHAl.SetRange("Source No.", TH."No.");
                if WHAl.FindFirst then
                    TH."No. Picking" := WHAl."No.";

                //Picking Registrado
                RWAL.Reset;
                RWAL.SetCurrentKey("Source Document", "Source No.");
                RWAL.SetRange("Source Document", RWAL."Source Document"::"Outbound Transfer");
                RWAL.SetRange("Source No.", TH."No.");
                if RWAL.FindFirst then
                    TH."No. Picking Reg." := RWAL."No.";

                //Packing
                LP.Reset;
                LP.SetCurrentKey("No. Picking");
                LP.SetRange("No. Picking", RWAL."No.");
                if LP.FindFirst then
                    TH."No. Packing" := LP."No.";

                //Packing Registrado
                LPR.Reset;
                LPR.SetCurrentKey("No. Picking");
                LPR.SetRange(LPR."No. Picking", RWAL."No.");
                if LPR.FindFirst then
                    TH."No. Packing Reg." := LPR."No.";
                TH.Modify;

                //Envio de transferencia
                TSH.Reset;
                TSH.SetCurrentKey("Transfer Order No.");
                TSH.SetRange("Transfer Order No.", TH."No.");
                if TSH.FindFirst then
                    TH."No. Envio" := TSH."No.";
                TH.Modify;
            until TH.Next = 0;
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
        TH: Record "Transfer Header";
        TSH: Record "Transfer Shipment Header";
        Text003: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
}

