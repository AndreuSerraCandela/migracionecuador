page 56000 Packing
{
    ApplicationArea = all;
    // #842 03/02/14 Mostramos el campo "No. Palet abierto"
    //               Creación de las funciones: AbrirPalet, CerrarPalet, CheckPalet
    // #4191  PLB  30/09/2014  Añadido atajo de teclado a "Crear caja" -> Mayús+Ctrl+N

    PageType = Document;
    SourceTable = "Cab. Packing";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; rec."No.")
                {
                }
                field("Cod. Empleado"; rec."Cod. Empleado")
                {
                    Editable = false;
                }
                field("No. Mesa"; rec."No. Mesa")
                {
                }
                field("Picking No."; rec."Picking No.")
                {
                }
                field("Fecha Apertura"; rec."Fecha Apertura")
                {
                }
                field("Total de Productos"; rec."Total de Productos")
                {
                }
                field("No. Palet Abierto"; rec."No. Palet Abierto")
                {
                    Editable = false;
                }
            }
            part(Control1000000009; "Lin. Packing")
            {
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.", "No. Caja")
                              ORDER(Ascending);
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000016>")
            {
                Caption = '&Abrir Palet';
                Image = Bins;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //+#842
                    AbrirPalet;
                    Message('Palet Abierto');
                end;
            }
            action("&Close Palet")
            {
                Caption = '&Close Palet';
                Image = BinLedger;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //+#842
                    CerrarPalet;
                    Message('Palet Cerrado');
                end;
            }
            action("<Action1000000011>")
            {
                Caption = '&Crear Caja';
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Shift+Ctrl+N';

                trigger OnAction()
                begin
                    if Confirm(txt001, false) then begin
                        rec.TestField("Picking No.");
                        ConfSant.Get;
                        ConfSant.TestField("No. Serie Cajas Packing");

                        LinPack.Reset;
                        LinPack.Init;
                        LinPack.Validate("No.", rec."No.");
                        LinPack."No. Caja" := NoSerMang.GetNextNo(ConfSant."No. Serie Cajas Packing", WorkDate, true);
                        LinPack.Validate("Fecha Apertura Caja", WorkDate);
                        LinPack."Estado Caja" := LinPack."Estado Caja"::Abierta;
                        LinPack.Validate("No. Picking", rec."Picking No.");
                        LinPack.Validate("No. Palet", rec."No. Palet Abierto"); //+#842
                        LinPack.Insert;
                    end;
                    CurrPage.Update;
                end;
            }
            group("<Action1000000008>")
            {
                Caption = '&Post';
                action("<Action1000000012>")
                {
                    Caption = '&Registrar';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CheckPalet;//+#842

                        if Confirm(txt002, false) then begin
                            FuncSant.RegistraPacking(Rec);
                            Message(txt003);
                        end;
                    end;
                }
                action("&Post & Print")
                {
                    Caption = '&Post & Print';
                    Promoted = true;
                    PromotedCategory = Process;
                }
                action("<Action1000000014>")
                {
                    Caption = '&Print Packing';

                    trigger OnAction()
                    begin

                        CheckPalet;//+#842

                        ConfSant.Get;
                        ConfSant.TestField("ID Reporte Etiqueta de Caja");
                        CurrPage.SetSelectionFilter(CabPack);
                        REPORT.RunModal(ConfSant."ID Reporte Borrador Packing", true, true, CabPack);
                    end;
                }
            }
        }
    }

    var
        LinPack: Record "Lin. Packing";
        NoLinea: Integer;
        txt001: Label 'Confirm that you want to create a new box';
        ConfSant: Record "Config. Empresa";
        NoSerMang: Codeunit "No. Series";
        FuncSant: Codeunit "Funciones Santillana";
        txt002: Label 'Confirm that you want to post';
        txt003: Label 'The packing was successfully posted';
        CabPack: Record "Cab. Packing";
        txt004: Label 'Antes de registrar, el palet tiene que estar cerrado.';


    procedure AbrirPalet()
    var
        NoSeriesMgt: Codeunit "No. Series";
        ConfSant: Record "Config. Empresa";
    begin

        //+#842
        if rec."No. Palet Abierto" = '' then begin
            ConfSant.Get;
            ConfSant.TestField("No. serie Palet");
            NoSeriesMgt.GetNextNo(ConfSant."No. serie Palet")

        end;
    end;


    procedure CerrarPalet()
    begin

        //+#842
        rec."No. Palet Abierto" := '';
    end;


    procedure CheckPalet()
    begin
        if rec."No. Palet Abierto" <> '' then
            Error(txt004);
    end;
}

