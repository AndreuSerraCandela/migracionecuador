page 76408 "Subform turnos TPV"
{
    ApplicationArea = all;
    Caption = 'Control turnos TPV';
    CardPageID = "Declaracion de caja";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Turnos TPV";
    SourceTableView = SORTING("No. tienda", "No. TPV", Fecha, "No. turno");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("No. tienda"; rec."No. tienda")
                {
                    Caption = 'Store No.';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No. TPV"; rec."No. TPV")
                {
                    Caption = 'POS Terminal No.';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Fecha; rec.Fecha)
                {
                    Caption = 'Receipt No.';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No. turno"; rec."No. turno")
                {
                    Caption = 'Receipt No.';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Hora apertura"; rec."Hora apertura")
                {
                    Caption = 'Hora apertura';
                }
                field("Usuario apertura"; rec."Usuario apertura")
                {
                    Caption = 'Usuario apertura';
                }
                field("Hora cierre"; rec."Hora cierre")
                {
                    AutoFormatType = 1;
                    Caption = 'Hora cierre';
                }
                field("Usuario cierre"; rec."Usuario cierre")
                {
                    Caption = 'Usuario cierre';
                }
                field(Estado; rec.Estado)
                {
                    Caption = 'Estado';
                    StyleExpr = texEstiloEstado;
                }
                field("Fondo de caja"; rec."Fondo de caja")
                {
                    Caption = 'Fondo de caja';
                }
                field(Descuadre; rec.TraerDescuadreTurno)
                {
                    Caption = 'Descuadre';
                    StyleExpr = texEstiloDescuadre;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Abrir turno")
            {
                Caption = 'Abrir turno';
                Image = Open;

                trigger OnAction()
                var
                //cduControl: Codeunit "Control TPV"; //TPV
                begin
                    /* cduControl.AbrirTurno("No. tienda", "No. TPV", Fecha, codUsuario); */
                end;
            }
            action("Cerrar Turno")
            {
                Caption = 'Cerrar Turno';
                Image = Close;

                trigger OnAction()
                var
                    Text001: Label '¿Desea cerrar el turno %1?';
                //cduControl: Codeunit "Control TPV";  //TPV
                begin
                    /*if not IsEmpty then
                        if Confirm(Text001, false, "No. turno") then begin
                            if cduControl.CerrarTurno(Rec, codUsuario) then
                                CurrPage.Close;
                        end;*/
                end;
            }
            action("Declaración de caja")
            {
                Caption = 'Declaración de caja';
                Image = InsertCurrency;

                trigger OnAction()
                var
                    recTurnos: Record "Turnos TPV";
                    frmDecCaja: Page "Declaracion de caja";
                begin
                    recTurnos.Reset;
                    recTurnos.SetRange("No. tienda", rec."No. tienda");
                    recTurnos.SetRange("No. TPV", rec."No. TPV");
                    recTurnos.SetRange(Fecha, rec.Fecha);
                    recTurnos.SetRange("No. turno", rec."No. turno");

                    frmDecCaja.SetTableView(recTurnos);
                    frmDecCaja.RunModal;
                end;
            }
            action("Informe resumen del turno")
            {
                Caption = 'Informe resumen del turno';
                Image = Sales;

                trigger OnAction()
                var
                    recTurno: Record "Turnos TPV";
                    repResumen: Report "DsPOS - Resumen del turno";
                begin
                    recTurno.Reset;
                    recTurno.SetRange("No. tienda", rec."No. tienda");
                    recTurno.SetRange("No. TPV", rec."No. TPV");
                    recTurno.SetRange(Fecha, rec.Fecha);
                    recTurno.SetRange("No. turno", rec."No. turno");
                    repResumen.SetTableView(recTurno);
                    repResumen.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        FormatTexto;
    end;

    trigger OnAfterGetRecord()
    begin
        FormatTexto;
    end;

    var
        codTienda: Code[20];
        codUsuario: Code[20];
        texEstiloEstado: Text;
        texEstiloDescuadre: Text;
        texFavorable: Label 'Favorable';
        texUnfavorable: Label 'Unfavorable';
        texStandar: Label 'Standar';


    procedure PasarDatos(codPrmTienda: Code[20]; codPrmUsuario: Code[20])
    begin
        codTienda := codPrmTienda;
        codUsuario := codPrmUsuario;
    end;


    procedure FormatTexto()
    begin
        case rec.Estado of
            rec.Estado::Abierto:
                texEstiloEstado := texFavorable;
            rec.Estado::Cerrado:
                texEstiloEstado := texStandar;
        end;
        if rec.TraerDescuadreTurno = 0 then
            texEstiloDescuadre := texStandar
        else
            texEstiloDescuadre := texUnfavorable;
    end;
}

