#pragma implicitwith disable
page 56064 "Gestion BackOrder - SL"
{
    ApplicationArea = all;
    // $001    25/06/2014      PLB           Campo "Cantidad a ajustar" editable
    //                                       Permitir modificar registro
    //                                       Nuevo puntos de menú:
    //                                         - Actualizar BO
    // $002   13/10/2014   PLB   Añadidas las opciones de anular pendiente BO
    //                           Mejorado el rendimiento al abrir la page
    //                           Campo "Cantidad Anulada"
    // 
    // $003   10/11/2014   PLB   Sólo revisar las líneas que tienen "Cantidad pendiente BO"
    // 
    // #56090 27/09/2016   PLB   Ajustes en la visualización disponibilidad backorders


    Caption = 'BackOrder Management Sales line';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = SORTING(Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type", "Shipment Date")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(Order),
                            Type = FILTER(Item),
                            "No." = FILTER(<> ''),
                            "Cantidad pendiente BO" = FILTER(<> 0),
                            "Disponible BackOrder" = FILTER(true));
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
                    Editable = false;
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
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    Editable = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Cantidad Aprobada"; Rec."Cantidad Aprobada")
                {
                    Editable = false;
                }
                field("Cantidad Anulada"; Rec."Cantidad Anulada")
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
                field("Cantidad Solicitada"; Rec."Cantidad Solicitada")
                {
                    Editable = false;
                }
                field("Cantidad a Ajustar"; Rec."Cantidad a Ajustar")
                {
                }
                field("Cantidad a Anular"; Rec."Cantidad a Anular")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Documento)
            {
                Caption = '&Document';
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(PedVta);
                    SH.Get(Rec."Document Type", Rec."Document No.");
                    PedVta.SetRecord(SH);
                    PedVta.GestBackOrd(true);
                    PedVta.RunModal;
                    Clear(PedVta);
                end;
            }
            group("<Action1906587504>")
            {
                Caption = 'F&unctions';
                action(ActualizarBO)
                {
                    Caption = '&Update BO';
                    Image = RefreshPlanningLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        //$001
                        SL.Copy(Rec);
                        if SL.FindSet(true) then begin
                            Clear(SH);
                            Counter := 0;
                            Window.Open(Text006);
                            CounterTotal := SL.Count;
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, Rec."No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                                if SL."Cantidad a Ajustar" <> 0 then begin
                                    if SH."No." <> SL."Document No." then begin
                                        if (SH."No." <> '') and (SH.Status = SH.Status::Open) then
                                            ReleaseSalesDoc.PerformManualRelease(SH);
                                        SH.Get(SL."Document Type", SL."Document No.");
                                        if SH.Status <> SH.Status::Open then begin //+$002
                                            ReleaseSalesDoc.PerformManualReopen(SH);
                                            SL.Find; //+$002
                                        end; //+$002
                                    end;

                                    //SL.FIND; //-$002
                                    SL.ActLinBO;
                                    SL.Modify;

                                    //+$002
                                end
                                else
                                    if SL."Cantidad a Anular" > 0 then begin
                                        if SH."No." <> SL."Document No." then begin
                                            if (SH."No." <> '') and (SH.Status = SH.Status::Open) then
                                                ReleaseSalesDoc.PerformManualRelease(SH);
                                            SH.Get(SL."Document Type", SL."Document No.");
                                            if SH.Status <> SH.Status::Open then begin
                                                ReleaseSalesDoc.PerformManualReopen(SH);
                                                SL.Find;
                                            end;
                                        end;

                                        SL.ActLinBO;
                                        SL.Modify;
                                        //-$002

                                    end;
                            until SL.Next = 0;

                            if (SH."No." <> '') and (SH.Status = SH.Status::Open) then
                                ReleaseSalesDoc.PerformManualRelease(SH);
                            Window.Close;
                        end;
                    end;
                }
                separator(Action1000000020)
                {
                }
                action("<Action1000000025>")
                {
                    Caption = '&Sugerir Cantidades';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CantDisp: Decimal;
                    begin
                        //$002
                        SL.Copy(Rec);
                        if SL.FindSet(true) then begin
                            Counter := 0;
                            Window.Open(Text002);
                            CounterTotal := SL.Count;
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, SL."No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                CantDisp := SalesInfoPaneMgt.CalcAvailability_BackOrder(SL);
                                if CantDisp > SL."Cantidad pendiente BO" then
                                    SL."Cantidad a Anular" := 0
                                else
                                    SL."Cantidad a Anular" := SL."Cantidad pendiente BO" - SalesInfoPaneMgt.CalcAvailability_BackOrder(SL);
                                SL."Cantidad a Ajustar" := SL."Cantidad pendiente BO" - SL."Cantidad a Anular";
                                SL.Modify;
                            until SL.Next = 0;
                            Window.Close;
                        end;
                    end;
                }
                action("<Action1000000033>")
                {
                    Caption = '&Borrar Pedidos enviados';
                    Image = Delete;

                    trigger OnAction()
                    begin
                        //$002
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
        //Desmarcar todas las lineas de pedidos

        //+$002
        // Para mejorar el rendimiento, realizamos un MODIFYALL
        /****************************************************
        Counter := 0;
        Window.OPEN(Text004);
        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Disponible BackOrder");
        SalesLine.SETRANGE(SalesLine."Disponible BackOrder",TRUE);
        IF SalesLine.FINDSET THEN
          BEGIN
            CounterTotal := SalesLine.COUNT;
            REPEAT
              Counter := Counter + 1;
              Window.UPDATE(1,SalesLine."No.");
              Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
        
              IF SL.GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN
                BEGIN
                  SL."Disponible BackOrder" := FALSE;
                  SL.MODIFY;
                END;
            UNTIL SalesLine.NEXT = 0;
          END;
        Window.CLOSE;
        COMMIT;
        ****************************************************/
        Window.Open(Text004);
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        if not SalesLine.IsEmpty then
            SalesLine.ModifyAll("Disponible BackOrder", false);
        Window.Close;
        //-$002

        Counter := 0;
        Window.Open(Text003);
        SalesLine.Reset;
        SalesLine.SetCurrentKey("Document Type", Type); //+$002
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order); //+$002
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet then begin
            PrevTime := Time; //+$002
            CounterTotal := SalesLine.Count;
            repeat
                Counter := Counter + 1;
                //+$002
                //Window.UPDATE(1,SalesLine."No.");
                //Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                if (Time > (PrevTime + 1000)) then begin
                    PrevTime := Time;
                    Window.Update(1, Round((Counter / CounterTotal) * 10000, 1));
                end;
                //-$002

                if (SalesLine."Cantidad pendiente BO" > 0) then // +$003
                    if (SalesInfoPaneMgt.CalcAvailability_BackOrder(SalesLine) > 0) and
                        (SH.Get(SalesLine."Document Type", SalesLine."Document No.")) then
                        //+$002
                        // El ELSE no tenía ningún sentido, los registros ya están marcados como FALSE
                        /*********************************************************
                          SalesLine."Disponible BackOrder" := TRUE
                      ELSE
                        BEGIN
                          //Se verifica que la linea no esté en Envios de Almacen
                          WHSL.RESET;
                            whsl.setcurrentkey("Source Document","Source No."); //+$002
                          WHSL.SETRANGE("Source No.",SalesLine."Document No.");
                          WHSL.SETRANGE("Item No.",SalesLine."No.");
                          IF NOT WHSL.FINDFIRST THEN
                              SalesLine."Disponible BackOrder" := FALSE;
                        END;
                      SalesLine.MODIFY;
                        *********************************************************/
                        begin
                        SalesLine."Disponible BackOrder" := true;
                        SalesLine."Cantidad a Anular" := 0;
                        SalesLine.Modify;
                    end;
            //-$002
            until SalesLine.Next = 0;
        end;
        Window.Close;
        Commit;

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
        PrevTime: Time;
        SalesLine2: Record "Sales Line";
        WHSL: Record "Warehouse Shipment Line";
        CantidadDis: Decimal;
        SH: Record "Sales Header";
        AppEnt: Record "Approval Entry";
        AppEnt1: Record "Approval Entry";
        AppEnt2: Record "Approval Entry";
        SL: Record "Sales Line";
        PedVta: Page "Sales Order";
        Error001: Label 'Qty. to Adjust cannot be grater than the availability';
        Error002: Label 'User does not have permision to approve quantities in sales orders';
        Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text002: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text003: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text004: Label 'Reading ';
        Text005: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        Text006: Label 'Reading  #1########## @2@@@@@@@@@@@@@';


    procedure BorrarPedidosNoPdtes()
    var
        wPendiente: Boolean;
    begin
        //$002
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

