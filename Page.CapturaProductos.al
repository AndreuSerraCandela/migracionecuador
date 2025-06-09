#pragma implicitwith disable
page 56037 "Captura Productos"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'Nuevo,Proceso,Informes,Linea De Negocio,Formato,Varios,Category7,Category,Category9,Category10';
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Mark; Rec.Mark)
                {
                    Caption = 'Marked';
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("SalesInfoPaneMgt.CalcAvailability_Item(""No."",_Location)"; SalesInfoPaneMgt.CalcAvailability_Item(Rec."No.", _Location))
                {
                    Caption = 'Disponibilidad';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Macado Manualmente"; Marcado)
                {

                    trigger OnValidate()
                    begin
                        if Marcado then
                            Rec.Mark(true)
                        else
                            Rec.Mark(false);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000005>")
            {
                Caption = 'Linea De Negocio';
                action("<Action1000000006>")
                {
                    Caption = 'Texto';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Global Dimension 1 Code", '01_TEXTO');
                    end;
                }
                action("<Action1000000007>")
                {
                    Caption = 'Idiomas';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        Rec.SetFilter("Global Dimension 1 Code", '02_IDIOMAS');
                    end;
                }
                action("<Action1000000008>")
                {
                    Caption = 'Generales';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Global Dimension 1 Code", '03_GENERALES');
                    end;
                }
                action("<Action1000000009>")
                {
                    Caption = 'Formación';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        Rec.SetFilter("Global Dimension 1 Code", '04_FORMACION');
                    end;
                }
                action("<Action1000000010>")
                {
                    Caption = 'Otros';
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.SetFilter("Global Dimension 1 Code", '05_OTROS');
                    end;
                }
            }
            group("<Action1000000016>")
            {
                Caption = 'Formato';
                action("<Action1000000015>")
                {
                    Caption = 'Libro';
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Formato, Rec.Formato::Libro);
                    end;
                }
                action("<Action1000000014>")
                {
                    Caption = 'Cuaderno';
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Formato, 1);
                    end;
                }
                action("<Action1000000013>")
                {
                    Caption = 'Guía';
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Formato, 2);
                    end;
                }
                action("<Action1000000012>")
                {
                    Caption = 'Otros';
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        Rec.SetRange(Formato, 3);
                    end;
                }
            }
            group("<Action1000000020>")
            {
                Caption = 'Varios';
                action("<Action1000000019>")
                {
                    Caption = 'Catalogo';
                    Promoted = true;
                    PromotedCategory = Category6;

                    trigger OnAction()
                    begin

                        if ((Rec.GetFilter(Catalogo)) = '') or ((Rec.GetFilter(Catalogo)) = 'No') then begin
                            Rec.SetRange(Catalogo, true);
                        end
                        else begin
                            Rec.SetRange(Catalogo, false);
                        end;
                    end;
                }
                action("<Action1000000018>")
                {
                    Caption = 'Precio Venta 0';
                    Promoted = true;
                    PromotedCategory = Category6;

                    trigger OnAction()
                    begin

                        if ((Rec.GetFilter("Unit Price")) = '<>0') then begin
                            Rec.SetRange("Unit Price", 0);
                        end
                        else begin
                            Rec.SetFilter("Unit Price", '<>%1', 0);
                        end;
                    end;
                }
            }
            group("<Action1000000011>")
            {
                Caption = 'Acciones';
                action("<Action1000000017>")
                {
                    Caption = 'Capturar Producto';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F2';

                    trigger OnAction()
                    begin
                        InsertaProducto;
                    end;
                }
                action(Action1000000022)
                {
                    Caption = 'Mark';
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F1';

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(Prod);
                        if Prod.FindSet(false) then begin
                            repeat
                                Prod.Mark(not Rec.Mark);
                            until Prod.Next = 0;
                            Rec.Copy(Prod);
                        end;
                    end;
                }
                action("&Only Marked")
                {
                    Caption = '&Only Marked';
                    Image = ChangeDates;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.MarkedOnly(not Rec.MarkedOnly);
                    end;
                }
                action("&Clear Mark")
                {
                    Caption = '&Clear Mark';
                    Image = ClearFilter;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F3';

                    trigger OnAction()
                    begin
                        Prod.CopyFilters(Rec);
                        Rec.Reset;
                        Rec.CopyFilters(Prod);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Description, '*');
    end;

    var
        _Doc: Code[20];
        Text001: Label 'Producto capturado.';
        pgCantidad: Page "Captura Cantidad";
        _Cantidad: Decimal;
        Text002: Label 'Cancelado por el usuario';
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
        _Location: Code[20];
        _Disponibilidad: Decimal;
        Prod: Record Item;
        Prod1: Record Item;
        Marcado: Boolean;


    procedure InsertaProducto()
    var
        rSalesLine2: Record "Sales Line";
        rSalesLine: Record "Sales Line";
        NoLinea: Integer;
        lText001: Label 'ERROR: La cantidad introducida (%1) supera la disponibilidad (%2)';
    begin
        //AMS De momento Santillana Dominincana no trabaja sobre Disponibilidad
        //_Disponibilidad := SalesInfoPaneMgt.CalcAvailability_Item("No.",_Location);

        CapturaCantidad;

        if _Cantidad = 0 then
            exit;

        Prod.Reset;
        Prod.ClearMarks;
        Prod.Copy(Rec);
        Commit;
        Prod.MarkedOnly(true);
        if Prod.Count > 0 then begin
            if Prod.FindSet(false) then
                repeat
                    rSalesLine2.Reset;
                    rSalesLine2.SetRange(rSalesLine2."Document Type", rSalesLine2."Document Type"::Order);
                    rSalesLine2.SetRange(rSalesLine2."Document No.", _Doc);
                    if rSalesLine2.FindLast then
                        NoLinea := rSalesLine2."Line No."
                    else
                        NoLinea := 10000;

                    rSalesLine.Init;
                    rSalesLine."Document Type" := rSalesLine."Document Type"::Order;
                    rSalesLine.Validate("Document Type");
                    rSalesLine."Document No." := _Doc;
                    rSalesLine.Validate("Document No.");
                    rSalesLine."Line No." := NoLinea + 1000;
                    rSalesLine.Validate("Line No.");
                    rSalesLine.Type := rSalesLine.Type::Item;
                    rSalesLine.Validate(Type);
                    rSalesLine."No." := Prod."No.";
                    rSalesLine.Validate("No.");
                    rSalesLine."Unit of Measure Code" := rSalesLine."Unit of Measure Code";
                    rSalesLine.Validate("Unit of Measure Code");
                    rSalesLine.Quantity := _Cantidad;
                    rSalesLine.Validate(Quantity);
                    rSalesLine.Insert(true);
                    rSalesLine.AutoReserve;
                until Prod.Next = 0;
        end;

        //AMS de momento Santillana Dominicana no trabaja sobre Disponibilidad
        /*
        IF _Cantidad > _Disponibilidad THEN
          ERROR(lText001,_Cantidad,_Disponibilidad);
        */

        Message(Text001);

    end;


    procedure RecibeParametros(par_Doc: Code[20]; par_Location: Code[20])
    begin
        _Doc := par_Doc;
        _Location := par_Location;
    end;


    procedure CapturaCantidad()
    begin
        Clear(pgCantidad);
        pgCantidad.LookupMode(true);
        if pgCantidad.RunModal = ACTION::LookupOK then
            _Cantidad := pgCantidad.GetCantidad
        else
            Error(Text002);
    end;
}

#pragma implicitwith restore

