#pragma implicitwith disable
page 56026 "Clasificacion devoluciones"
{
    ApplicationArea = all;
    // #36182  19/11/2015  MOI   Se añaden los nuevos campos de la tabla.

    Caption = 'Returns classification';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Cab. clas. devolucion";
    SourceTableView = WHERE(Closed = CONST(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(CustNo; Rec."Customer no.")
                {
                    Caption = 'Customer no.';
                    TableRelation = Customer;
                }
                field("Customer name"; Rec."Customer name")
                {
                    Editable = false;
                }
                field("External document no."; Rec."External document no.")
                {
                    Caption = 'External Doc. Number';
                }
                field(barcode; Barcode)
                {
                    Caption = 'EAN';
                    TableRelation = "Item Reference"."Reference No.";

                    trigger OnValidate()
                    begin
                        ICR.SetCurrentKey("Reference No.");
                        ICR.SetRange("Reference No.", Barcode);
                        if ICR.FindFirst then
                            Item.Get(ICR."Item No.")
                        else begin
                            Item.Get(Barcode);
                            ICR."Item No." := Barcode;
                        end;

                        ItemNo := ICR."Item No.";
                        Desc := Item.Description;
                        Iuom := Item."Base Unit of Measure";
                    end;
                }
                field(ItemNo; ItemNo)
                {
                    Caption = 'Item no.';
                    TableRelation = Item WHERE(Inactivo = CONST(false));

                    trigger OnValidate()
                    begin
                        Item.Get(ItemNo);
                        Desc := Item.Description;
                        Iuom := Item."Base Unit of Measure";
                    end;
                }
                field(Cant; Cant)
                {
                    Caption = 'Quantity';
                }
                field(Desc; Desc)
                {
                    Editable = false;
                }
                field(Iuom; Iuom)
                {
                    Caption = 'Unit of measure';
                    TableRelation = "Item Unit of Measure";
                }
                field("Comentario producto"; ComentarioProd)
                {
                }
                field("Cod. Almacen"; Rec."Cod. Almacen")
                {
                }
                field("No Serie NCF Abono"; Rec."No Serie NCF Abono")
                {
                }
                field("Establecimiento Nota Credito"; Rec."Establecimiento Nota Credito")
                {
                    Editable = false;
                }
                field("Punto Emision Nota Credito"; Rec."Punto Emision Nota Credito")
                {
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
            }
            part(Detalle; "Subform clas. devoluciones")
            {
                SubPageLink = "No. Documento" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Insert")
            {
                Caption = '&Insert';
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+Return';

                trigger OnAction()
                begin
                    if Cant <= 0 then
                        Error(Err001);

                    CD2.Reset;
                    CD2.SetRange("No. Documento", Rec."No.");
                    if CD2.FindLast then;

                    CD.Init;
                    CD."No. Documento" := Rec."No.";
                    CD.Validate("Customer No.", Rec."Customer no.");
                    CD.Validate("Item No.", ItemNo);
                    CD.Validate(Quantity, Cant);
                    CD."Line No." := CD2."Line No." + 1;
                    //CD."External Doc. Number" := EDoc;
                    CD."External Doc. Number" := Rec."External document no.";
                    CD."Cross-Reference No." := Barcode;
                    CD.Comentario := ComentarioProd;
                    CD.Insert(true);

                    Rec."Receipt date" := WorkDate;
                    //"External document no." := EDoc;
                    Rec.Modify;

                    CurrPage.Detalle.PAGE.Refrescar;
                    Clear(ItemNo);
                    Clear(Desc);
                    Clear(Barcode);
                    Clear(Iuom);
                    Clear(Cant);
                    Clear(ComentarioProd);
                    Cant := 1;

                    CurrPage.Update;
                end;
            }
            action("<Action1000000021>")
            {
                Caption = 'Cerrar recepción';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("Customer no.");
                    Rec.Closed := true;
                    Rec."User id" := UserId;
                    Rec."Closing Datetime" := CurrentDateTime;
                    Rec.Modify;

                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Cant := 1;
    end;

    var
        CD: Record "Lin. clas. devoluciones";
        CD2: Record "Lin. clas. devoluciones";
        ICR: Record "Item Reference";
        Item: Record Item;
        CDR: Record "Cab. clas. devolucion";
        Cant: Integer;
        Err001: Label 'Quantity can''t be negative or zero';
        Desc: Text[60];
        Iuom: Code[20];
        ItemNo: Code[20];
        CustNo: Code[20];
        Barcode: Code[22];
        _EDoc: Code[20];
        Err002: Label 'Quantity can''t be negative or zero';
        ComentarioProd: Text[250];
}

#pragma implicitwith restore

