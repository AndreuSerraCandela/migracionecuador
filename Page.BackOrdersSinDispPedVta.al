#pragma implicitwith disable
page 56024 "BackOrders Sin Disp. Ped. Vta"
{
    ApplicationArea = all;
    // $001   25/06/2014    PLB   Nueva función BorrarPedidosNoPdtes()
    //                            Campo "Cantidad a ajustar" editable
    //                            Permitir modificar registro
    //                            Nuevos puntos de menú:
    //                            - Sugerir Cantidad a Anular
    //                            - Actualizar Cantidad Pendiente
    //                            - Borrar Pedidos enviados
    // $002   13/10/2014    PLB   Utilizar función ActLinBO para actualizar la cantidad anulada
    //                            Campo "Cantidad Anulada"
    //                            Abrir y lanzar los pedidos
    //                            Mejorar rendimiento al abrir página
    // MOI - 23/02/2015(#9653): Se muestran las lineas de venta que tienen disponibilidad negativa.
    // 
    // #56090 27/09/2016    PLB   Ajustes en la visualización disponibilidad backorders


    Caption = 'BackOrder No Availability Sales Order';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field(EstatusPed; EstatusPed)
                {
                    Editable = false;
                }
                field("Cantidad Solicitada"; Rec."Cantidad Solicitada")
                {
                    Editable = false;
                }
                field("Cantidad Anulada"; Rec."Cantidad Anulada")
                {
                    Editable = false;
                }
                field("Porcentaje Cant. Aprobada"; Rec."Porcentaje Cant. Aprobada")
                {
                    Editable = false;
                }
                field("Cantidad Aprobada"; Rec."Cantidad Aprobada")
                {
                    Editable = false;
                }
                field("Cantidad pendiente BO"; Rec."Cantidad pendiente BO")
                {
                    Editable = false;
                }
                field("SalesInfoPaneMgt.CalcAvailability_BackOrder(Rec)"; SalesInfoPaneMgt.CalcAvailability_BackOrder(Rec))
                {
                    Caption = 'Qty. Available';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Cantidad a Anular"; Rec."Cantidad a Anular")
                {
                }
                field("Cantidad a Ajustar"; Rec."Cantidad a Ajustar")
                {
                    Editable = false;
                    Importance = Additional;
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000021>")
            {
                Caption = '&Abrir Documento';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(PedVta);
                    SH.Get(Rec."Document Type", Rec."Document No.");
                    PedVta.SetRecord(SH);
                    PedVta.RunModal;
                    Clear(PedVta);
                end;
            }
            group("<Action1906587504>")
            {
                Caption = 'F&unctions';
                action("<Action1000000025>")
                {
                    Caption = '&Sugerir Cantidad a Anular';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //$001
                        if Rec.FindSet then
                            repeat
                                Rec."Cantidad a Anular" := Rec."Cantidad pendiente BO";
                                Rec.Modify;
                            until Rec.Next = 0;
                    end;
                }
                action("<Action1000000027>")
                {
                    Caption = 'A&ctualizar BO';
                    Image = RefreshPlanningLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //$001
                        if not (UserSetup.Get(UserId) and UserSetup."Aprueba Cantidades") then
                            Error(Error002);

                        Clear(SH); //$+002

                        Counter := 0;
                        Window.Open(Text002);
                        CounterTotal := Rec.Count;
                        if Rec.FindSet then begin
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, Rec."No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                if Rec."Cantidad a Anular" > 0 then begin
                                    //+$002
                                    if SH."No." <> Rec."Document No." then begin
                                        if (SH."No." <> '') and (SH.Status = SH.Status::Open) then
                                            ReleaseSalesDoc.PerformManualRelease(SH);
                                        SH.Get(Rec."Document Type", Rec."Document No.");
                                        if SH.Status <> SH.Status::Open then
                                            ReleaseSalesDoc.PerformManualReopen(SH);
                                    end;
                                    //-$002

                                    SL.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.");

                                    //+$002
                                    //SL.VALIDATE("Cantidad pendiente BO", "Cantidad pendiente BO" - "Cantidad a Anular");
                                    SL."Cantidad a Anular" := Rec."Cantidad a Anular";
                                    SL.ActLinBO;
                                    //-$002

                                    SL.Modify;
                                    if SL."Cantidad pendiente BO" = 0 then
                                        Rec.Delete
                                    else begin
                                        Rec."Cantidad pendiente BO" := SL."Cantidad pendiente BO";
                                        Rec."Cantidad a Anular" := 0;
                                        Rec.Modify;
                                    end;
                                end;
                            until Rec.Next = 0;
                            //+$002
                            if (SH."No." <> '') and (SH.Status = SH.Status::Open) then
                                ReleaseSalesDoc.PerformManualRelease(SH);
                            //-$002
                        end;

                        Window.Close;
                    end;
                }
                action("<Action1000000033>")
                {
                    Caption = '&Borrar Pedidos enviados';
                    Image = Delete;

                    trigger OnAction()
                    begin
                        //$001
                        if Confirm(Text004, false) then
                            BorrarPedidosNoPdtes();
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        salesheader.Get(Rec."Document Type", Rec."Document No.");
        EstatusPed := salesheader.Status;
    end;

    trigger OnOpenPage()
    begin
        Counter := 0;
        Window.Open(Text003);
        SL.Reset;
        SL.SetFilter("Document Type", '%1|%2', SL."Document Type"::Order, SL."Document Type"::Invoice);
        CounterTotal := SL.Count;
        PrevTime := Time; //+$002
        if SL.FindFirst then
            repeat
                Counter := Counter + 1;
                //+$002
                //Window.UPDATE(1,SL."No.");
                //Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                if (Time > (PrevTime + 1000)) then begin
                    PrevTime := Time;
                    Window.Update(1, Round((Counter / CounterTotal) * 10000, 1));
                end;
                //-$002
                //IF (SalesInfoPaneMgt.CalcAvailability_BackOrder(SL) = 0) AND (SL."Cantidad pendiente BO" <> 0) THEN//MOI - 23/02/2015
                if (SalesInfoPaneMgt.CalcAvailability_BackOrder(SL) <= 0) and (SL."Cantidad pendiente BO" <> 0) then begin
                    WHSL.Reset;
                    WHSL.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                    WHSL.SetRange("Source Type", 37);
                    WHSL.SetRange("Source Subtype", 1);
                    WHSL.SetRange("Source No.", SL."Document No.");
                    WHSL.SetRange("Item No.", SL."No.");
                    if not WHSL.FindFirst then begin
                        Rec.TransferFields(SL);
                        Rec."Cantidad a Anular" := 0; //+$001
                        Rec."Cantidad a Ajustar" := 0; //+$002
                        Rec.Insert;
                    end;
                end;
            until SL.Next = 0;
        Window.Close;
    end;

    var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
        SalesLine: Record "Sales Line";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        salesheader: Record "Sales Header";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        //EstatusPed: Option Abierto,Lanzado,"Aprobación pendiente","Anticipo pendiente";
        EstatusPed: Enum "Sales Document Status";
        UserSetup: Record "User Setup";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Error001: Label 'Qty. to Adjust cannot be grater than the availability';
        Error002: Label 'User does not have permision to approve quantities in sales orders';
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text002: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text003: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        PrevTime: Time;
        SalesLine2: Record "Sales Line";
        WHSL: Record "Warehouse Shipment Line";
        SL: Record "Sales Line";
        PedVta: Page "Sales Order";
        SH: Record "Sales Header";
        Text004: Label 'Se revisarán todos los pedidos y se borrarán aquellos que no tengan cantidad pendiente para enviar. ¿Continuar?';


    procedure BorrarPedidosNoPdtes()
    var
        wPendiente: Boolean;
    begin
        //$001
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

                wPendiente := true;
                SL.SetRange("Document Type", SH."Document Type");
                SL.SetRange("Document No.", SH."No.");
                SL.SetRange(Type, SL.Type::Item);
                if SL.FindSet then
                    repeat
                        wPendiente := (SL."Outstanding Quantity" <> 0) or (SL."Cantidad pendiente BO" <> 0);
                    until (SL.Next = 0) or wPendiente;
                if not wPendiente then begin
                    SH.Delete(true);
                end;
            until SH.Next = 0;
            Window.Close;
        end;
    end;
}

#pragma implicitwith restore

