#pragma implicitwith disable
page 76024 "Declaracion de caja"
{
    ApplicationArea = all;
    Caption = 'Declaración de caja';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Turnos TPV";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. tienda"; rec."No. tienda")
                {
                    Caption = 'Store No.';
                    Editable = false;
                    Importance = Promoted;
                }
                field("No. TPV"; rec."No. TPV")
                {
                    Caption = 'POS Terminal No.';
                    Editable = false;
                    Importance = Promoted;
                }
                field(Fecha; rec.Fecha)
                {
                    Caption = 'Fecha';
                    Editable = false;
                    Importance = Promoted;
                }
                field("No. turno"; rec."No. turno")
                {
                    Caption = 'Receipt No.';
                    Editable = false;
                    Importance = Promoted;
                }
                group(Apertura)
                {
                    field("Hora apertura"; rec."Hora apertura")
                    {
                        Editable = false;
                    }
                    field("Usuario apertura"; rec."Usuario apertura")
                    {
                        Editable = false;
                    }
                    field(FondoCaja; rec."Fondo de caja")
                    {
                        Caption = 'Fondo de caja';
                        Editable = false;
                    }
                }
                group(Cierre)
                {
                    field("Hora cierre"; rec."Hora cierre")
                    {
                        Editable = false;
                    }
                    field("Usuario cierre"; rec."Usuario cierre")
                    {
                        Editable = false;
                    }
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                }
            }
            part(ResumenTransacciones; "Subform declaracion caja")
            {
                Caption = 'Resumen de Transacciones';
                SubPageLink = "No. tienda" = FIELD("No. tienda"),
                              "No. TPV" = FIELD("No. TPV"),
                              Fecha = FIELD(Fecha),
                              "No. turno" = FIELD("No. turno");
                SubPageView = SORTING("No. tienda", "No. TPV", Fecha, "No. turno", "Forma de pago");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Cerrar Turno")
            {
                Caption = 'Cerrar Turno';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text001: Label '¿Desea cerrar el turno?';

                begin
                    /*                 if not IsEmpty then
                                        if Confirm(Text001, false) then begin
                                            if cduControl.CerrarTurno(Rec, codUsuario) then
                                                CurrPage.Close;
                                        end; */
                end;
            }
            action("Introducir fondo de caja")
            {
                Caption = 'Introducir fondo de caja';
                Image = Bin;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var

                    decFondoCaja: Decimal;
                    Text001: Label 'Esta acción la debe realizar un supervisor.';
                begin
                    /*                     if cduControl.UsuarioSuper("No. tienda", codUsuario) then begin
                                            CalcFields("Fondo de caja");
                                            decFondoCaja := "Fondo de caja";
                                            cduControl.PedirFondoDeCaja(decFondoCaja);
                                            ActualizarFondoCaja(codUsuario, decFondoCaja);
                                            CurrPage.Update;
                                        end
                                        else
                                            Error(Text001); */
                end;
            }
        }
        area(reporting)
        {
            action("Cuadre de caja")
            {
                Caption = 'Cuadre de caja';
                Ellipsis = true;
                Image = CashFlow;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recTurno: Record "Turnos TPV";
                    repCuadre: Report "DsPOS - Cuadre de caja";
                begin
                    recTurno.Reset;
                    recTurno.SetRange("No. tienda", Rec."No. tienda");
                    recTurno.SetRange("No. TPV", Rec."No. TPV");
                    recTurno.SetRange(Fecha, Rec.Fecha);
                    recTurno.SetRange("No. turno", Rec."No. turno");
                    repCuadre.SetTableView(recTurno);
                    repCuadre.RunModal;
                end;
            }
        }
    }

    var
        codUsuario: Code[20];



}

#pragma implicitwith restore

