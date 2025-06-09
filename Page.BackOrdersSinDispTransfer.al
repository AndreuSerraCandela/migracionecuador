#pragma implicitwith disable
page 56059 "BackOrders Sin Disp. Transfer."
{
    ApplicationArea = all;
    // $001   25/06/2014    PLB   Campo "Cantidad a ajustar" editable
    //                            Permitir modificar registro
    //                            Nuevos puntos de menú:
    //                              - Sugerir Cantidad a Anular
    //                              - Actualizar Cantidad Pendiente
    // $002   14/10/2014    PLB   Utilizar función ActLinBO para actualizar la cantidad anulada
    //                            Campo "Cantidad Anulada"
    //                            Abrir y lanzar la transferencia
    //                            Mejorado rendimiento al abrir formulario
    // 
    // #56090 26/09/2016    PLB   Utilzar la funcion de disponibilidad personalizada para BackOrders
    //                            Ajustes en la visualización disponibilidad backorders


    Caption = 'BackOrder Without Availability Order Transfer';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Transfer Line";
    SourceTableTemporary = true;
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
                field(Status; Rec.Status)
                {
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
                field("Transfer-to Code"; Rec."Transfer-to Code")
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
                field("Cantidad a Anular"; Rec."Cantidad a Anular")
                {
                }
                field("Cantidad a Ajustar"; Rec."Cantidad a Ajustar")
                {
                    Editable = false;
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
            action("<Action1000000017>")
            {
                Caption = '&Abrir Documento';
                Image = View;
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

                        Clear(TH); //$+002

                        Counter := 0;
                        Window.Open(Text002);
                        CounterTotal := Rec.Count;
                        if Rec.FindSet then begin
                            repeat
                                Counter := Counter + 1;
                                Window.Update(1, Rec."Item No.");
                                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

                                if Rec."Cantidad a Anular" > 0 then begin
                                    //+$002
                                    if TH."No." <> Rec."Document No." then begin
                                        if (TH."No." <> '') and (TH.Status = TH.Status::Open) then
                                            ReleaseTransfDoc.Run(TH);
                                        TH.Get(Rec."Document No.");
                                        if (TH.Status <> TH.Status::Open) then
                                            ReleaseTransfDoc.Reopen(TH);
                                    end;
                                    //-$002

                                    TL.Get(Rec."Document No.", Rec."Line No.");

                                    //+$002
                                    //TL.VALIDATE("Cantidad pendiente BO", "Cantidad pendiente BO" - "Cantidad a Anular");
                                    TL."Cantidad a Anular" := Rec."Cantidad a Anular";
                                    TL.ActLinBO;
                                    //-$002

                                    TL.Modify;
                                    if TL."Cantidad pendiente BO" = 0 then
                                        Rec.Delete
                                    else begin
                                        Rec."Cantidad pendiente BO" := TL."Cantidad pendiente BO";
                                        Rec."Cantidad a Anular" := 0;
                                        Rec.Modify;
                                    end;
                                end;
                            until Rec.Next = 0;
                            //+$002
                            if (TH."No." <> '') and (TH.Status = TH.Status::Open) then
                                ReleaseTransfDoc.Run(TH);
                            //-$002
                        end;

                        Window.Close;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TH.Get(Rec."Document No.");
        estatusTrans := TH.Status;
    end;

    trigger OnOpenPage()
    begin
        Window.Open(Text003);
        TL.Reset;
        CounterTotal := TL.Count;
        PrevTime := Time; //+$002
        if TL.FindFirst then
            repeat
                Counter := Counter + 1;
                //+$002
                //Window.UPDATE(1,TL."Item No.");
                //Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                if (Time > (PrevTime + 1000)) then begin
                    PrevTime := Time;
                    Window.Update(1, Round((Counter / CounterTotal) * 10000, 1));
                end;
                //-$002
                //IF (SalesInfoPaneMgt.CalcAvailabilityTransLine(TL) = 0) AND (TL."Cantidad pendiente BO" <> 0) THEN //-#56090
                if (SalesInfoPaneMgt.CalcAvailabilityTL_BackOrder(TL) <= 0) and (TL."Cantidad pendiente BO" <> 0) then //+#56090
                    begin
                    WHSL.Reset;
                    WHSL.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                    WHSL.SetRange("Source Type", 5741);
                    WHSL.SetRange("Source Subtype", 0);
                    WHSL.SetRange("Source No.", TL."Document No.");
                    WHSL.SetRange(WHSL."Item No.", TL."Item No.");
                    if not WHSL.FindFirst then begin
                        Rec.TransferFields(TL);
                        Rec."Cantidad a Anular" := 0; //+$001
                        Rec."Cantidad a Ajustar" := 0; //+$002
                        Rec.Insert;
                    end;
                end;
            until TL.Next = 0;
        Window.Close;
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
        TL: Record "Transfer Line";
        TH: Record "Transfer Header";
        estatusTrans: Option Abierto,Lanzado;
        ReleaseTransfDoc: Codeunit "Release Transfer Document";
        TL1: Record "Transfer Line";
        WHSL: Record "Warehouse Shipment Line";
        PedTrans: Page "Transfer Order";
}

#pragma implicitwith restore

