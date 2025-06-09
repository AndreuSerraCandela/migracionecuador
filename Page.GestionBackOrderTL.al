#pragma implicitwith disable
page 56065 "Gestion BackOrder - TL"
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


    Caption = 'Management BackOrder Line Transfer';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Transfer Line";
    SourceTableView = SORTING("Item No.")
                      ORDER(Ascending)
                      WHERE("Item No." = FILTER(<> ''),
                            "Cantidad pendiente BO" = FILTER(<> 0),
                            "Disponible BackOrder" = FILTER(true));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                }
                field(Quantity; Rec.Quantity)
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
                field("Cantidad Aprobada"; Rec."Cantidad Aprobada")
                {
                    Editable = false;
                }
                field("Cantidad pendiente BO"; Rec."Cantidad pendiente BO")
                {
                    Editable = false;
                }
                field("SalesInfoPaneMgt.CalcAvailabilityTL_BackOrder(Rec)"; SalesInfoPaneMgt.CalcAvailabilityTL_BackOrder(Rec))
                {
                    Caption = 'Available Qty.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
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
                    Clear(PedTrans);
                    TH.Get(Rec."Document No.");
                    PedTrans.SetRecord(TH);
                    PedTrans.RunModal;
                    Clear(PedTrans);
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
                        ReleaseTransfDoc: Codeunit "Release Transfer Document";
                    begin
                        //$001
                        TL.Copy(Rec);
                        if TL.FindSet(true) then begin
                            Clear(TH);
                            Counter := 0;
                            Window.Open(Text006);
                            CounterTotal := TL.Count;
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, TL."Item No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                                if TL."Cantidad a Ajustar" <> 0 then begin
                                    if TH."No." <> TL."Document No." then begin
                                        if (TH."No." <> '') and (TH.Status = TH.Status::Open) then
                                            ReleaseTransfDoc.Run(TH);
                                        TH.Get(TL."Document No.");
                                        if (TH.Status <> TH.Status::Open) then begin //+$002
                                            ReleaseTransfDoc.Reopen(TH);
                                            TL.Find; //+$002
                                        end; //+$002
                                    end;

                                    //TL.FIND; //-$002
                                    TL.ActLinBO;
                                    TL.Modify;

                                    //+$002
                                end
                                else
                                    if TL."Cantidad a Anular" > 0 then begin
                                        if TH."No." <> TL."Document No." then begin
                                            if (TH."No." <> '') and (TH.Status = TH.Status::Open) then
                                                ReleaseTransfDoc.Run(TH);
                                            TH.Get(TL."Document No.");
                                            if (TH.Status <> TH.Status::Open) then begin
                                                ReleaseTransfDoc.Reopen(TH);
                                                TL.Find;
                                            end;
                                        end;

                                        TL.ActLinBO;
                                        TL.Modify;
                                        //-$002

                                    end;
                            until TL.Next = 0;

                            if (TH."No." <> '') and (TH.Status = TH.Status::Open) then
                                ReleaseTransfDoc.Run(TH);

                            Window.Close;
                        end;
                    end;
                }
                separator(Action1000000018)
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
                        cantdisp: Decimal;
                    begin
                        //$002
                        TL.Copy(Rec);
                        if TL.FindSet(true) then begin
                            Clear(TH);
                            Counter := 0;
                            Window.Open(Text006);
                            CounterTotal := TL.Count;
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, TL."Item No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                cantdisp := SalesInfoPaneMgt.CalcAvailabilityTL_BackOrder(TL);
                                if cantdisp > TL."Cantidad pendiente BO" then
                                    TL."Cantidad a Anular" := 0
                                else
                                    TL."Cantidad a Anular" := TL."Cantidad pendiente BO" - SalesInfoPaneMgt.CalcAvailabilityTL_BackOrder(TL);
                                TL."Cantidad a Ajustar" := TL."Cantidad pendiente BO" - TL."Cantidad a Anular";
                                TL.Modify;
                            until TL.Next = 0;

                            Window.Close;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Desmarcar todas las lineas de pedidos
        //+$002
        /*****************************************************
        Counter := 0;
        Window.OPEN(Text004);
        TL.RESET;
        TL.SETCURRENTKEY("Disponible BackOrder");
        TL.SETRANGE("Disponible BackOrder",TRUE);
        IF TL.FINDSET THEN
          BEGIN
        CounterTotal := TL.COUNT;
           REPEAT
            Counter := Counter + 1;
            Window.UPDATE(1,TL."Item No.");
            Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
        
              IF TL1.GET(TL."Document No.",TL."Line No.") THEN
               BEGIN
                  TL1."Disponible BackOrder" := FALSE;
                  TL1.MODIFY;
                END;
            UNTIL TL.NEXT = 0;
          END;
        Window.CLOSE;
        COMMIT;
        *****************************************************/
        Window.Open(Text004);
        TL.ModifyAll("Disponible BackOrder", false);
        Window.Close;
        //-$002

        Counter := 0;
        Window.Open(Text003);
        TL.Reset;
        CounterTotal := TL.Count;
        PrevTime := Time; //+$002
        if TL.Find('-') then
            repeat
                Counter := Counter + 1;
                //+$002
                //Window.UPDATE(1,TL."Item No.");
                //Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                if (Time > (PrevTime + 1000)) then begin
                    PrevTime := Time;
                    Window.Update(1, Round((Counter / CounterTotal) * 10000, 1));
                end;

                if TL."Cantidad pendiente BO" > 0 then begin //+$003

                    //Se verifica que la linea no esté en Envios de Almacen
                    WHSL.Reset;
                    WHSL.SetCurrentKey("Source Document", "Source No.");
                    WHSL.SetRange("Source No.", TL."Document No.");
                    WHSL.SetRange("Item No.", TL."Item No.");
                    if not WHSL.FindFirst then
                        //-$002
                        if (SalesInfoPaneMgt.CalcAvailabilityTL_BackOrder(TL) > 0) and TH.Get(TL."Document No.") then begin //+$002
                            TL."Disponible BackOrder" := true;
                            //+$002
                            TL."Cantidad a Anular" := 0;
                            TL.Modify;
                        end;
                    //-$002

                    //Se verifica que la linea no esté en Envios de Almacen
                    //+$002
                    //WHSL.RESET;
                    //WHSL.SETRANGE("Source No.",TL."Document No.");
                    //WHSL.SETRANGE("Item No.",TL."Item No.");
                    //IF WHSL.FINDFIRST THEN
                    //  TL."Disponible BackOrder" := FALSE;
                    //TL.MODIFY;
                    //-$002

                end; //+$003
            until TL.Next = 0;
        Window.Close;
        Commit;

    end;

    var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
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
        TH: Record "Transfer Header";
        TL: Record "Transfer Line";
        WHSL: Record "Warehouse Shipment Line";
        Text004: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
        TL1: Record "Transfer Line";
        PedTrans: Page "Transfer Order";
        Text006: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
}

#pragma implicitwith restore

