#pragma implicitwith disable
page 76023 "Control TPV"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Control de TPV";
    SourceTableView = SORTING("No. tienda", "No. TPV", Fecha)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            group(Filtros)
            {
                Editable = blnEditable;
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field(WORKDATE; WorkDate)
                {
                    Caption = 'Fecha de Trabajo';
                    Editable = false;
                    Importance = Promoted;
                }
                field(Tienda; codTienda)
                {
                    TableRelation = Tiendas;

                    trigger OnValidate()
                    begin
                        FiltrarTienda;
                    end;
                }
                field(TPV; codTPV)
                {
                    TableRelation = "Configuracion TPV"."Id TPV";

                    trigger OnValidate()
                    begin
                        FiltrarTPV;
                    end;
                }
                field(NombreTienda; TraerNombreTienda)
                {
                    Caption = 'Descripción Tienda';
                }
                field(NombreTPV; TraerNombreTPV)
                {
                    Caption = 'Descripción TPV';
                }
            }
            repeater(Group)
            {
                Editable = false;
                field("No. tienda"; Rec."No. tienda")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No. TPV"; Rec."No. TPV")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Fecha; Rec.Fecha)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Hora apertura"; Rec."Hora apertura")
                {
                    Caption = 'Hora apertura';
                }
                field("Usuario apertura"; Rec."Usuario apertura")
                {
                }
                field("Hora cierre"; Rec."Hora cierre")
                {
                    AutoFormatType = 1;
                }
                field("Usuario cierre"; Rec."Usuario cierre")
                {
                }
                field(Estado; Rec.Estado)
                {
                    Caption = 'Estado';
                    StyleExpr = texEstilo;
                }
                field("No. Reaperturas"; Rec."No. Reaperturas")
                {
                    Editable = false;
                }
                field("Usuario reapertura"; Rec."Usuario reapertura")
                {
                    Visible = false;
                }
                field("Hora reapertura"; Rec."Hora reapertura")
                {
                    Visible = false;
                }
                field("Motivo reapertura"; Rec."Motivo reapertura")
                {
                }
            }
            part(Turnos; "Subform turnos TPV")
            {
                Caption = 'Turnos';
                ShowFilter = false;
                SubPageLink = "No. tienda" = FIELD("No. tienda"),
                              "No. TPV" = FIELD("No. TPV"),
                              Fecha = FIELD(Fecha);
                SubPageView = SORTING("No. tienda", "No. TPV", Fecha, "No. turno");
            }
        }
        area(factboxes)
        {
            part(Permisos; "FactBox permisos Usuario")
            {
                Caption = 'Permisos';
                ShowFilter = false;
            }
            part(Totales; "FactBox total ventas")
            {
                Caption = 'Total del día';
                Editable = false;
                SubPageLink = Tienda = FIELD("No. tienda"),
                              "Filtro fecha" = FIELD(Fecha);
                SubPageView = SORTING(Tienda, "Id TPV");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Abrir Día")
            {
                Caption = 'Abrir día';
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var

                    Error001: Label 'Debe seleccionar tienda y TPV.';
                begin

                    if (codTienda = '') or (codTPV = '') then
                        Error(Error001);



                    if Rec.FindFirst then;
                end;
            }
            action("Cerrar Día")
            {
                Caption = 'Cerrar día';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var

                    Text001: Label '¿Desea cerrar el día %1?';
                begin
                    if not Rec.IsEmpty then
                        if Confirm(Text001, false, Rec.Fecha) then;

                end;
            }
        }
        area(reporting)
        {
            action("Resumen del día")
            {
                Caption = 'Resumen del día';
                Ellipsis = true;
                Image = Sales;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recDia: Record "Control de TPV";
                begin
                    //fes mig
                    /*
                    recDia.RESET;
                    recDia.SETRANGE("No. tienda","No. tienda");
                    recDia.SETRANGE("No. TPV","No. TPV");
                    recDia.SETRANGE(Fecha,Fecha);
                    repResumen.SETTABLEVIEW(recDia);
                    repResumen.RUNMODAL;
                    */
                    //fes mig

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

    trigger OnOpenPage()
    begin
        blnEditable := true;
        if FiltrarUsuarioTPV then begin
            blnEditable := false;
            /*             if cduControl.LoginCajero(codTienda, codUsuario) then begin
                            CurrPage.Turnos.PAGE.PasarDatos(codTienda, codUsuario);
                            CurrPage.Permisos.PAGE.PasarDatos(codTienda, codUsuario);
                        end
                        else
                            Error(''); */
        end;

        if Rec.FindFirst then;
    end;

    var

        texEstilo: Text;
        codTienda: Code[20];
        codTPV: Code[20];
        blnEditable: Boolean;
        codUsuario: Code[20];
        texSupervisor: Text;


    procedure FormatTexto()
    var
        texAbierto: Label 'Favorable';
        texCerrado: Label 'Standar';
    begin
        case Rec.Estado of
            Rec.Estado::Abierto:
                texEstilo := texAbierto;
            Rec.Estado::Cerrado:
                texEstilo := texCerrado;
        end;
    end;


    procedure CerrarTPV()
    var
        /*   cduControl: Codeunit "Control TPV"; */
        Text001: Label '¿Desea cerrar el TPV %1 de la tienda %2?';
    begin
        /*         if Confirm(Text001, false, "No. TPV", "No. tienda") then
                    cduControl.CerrarDia(Rec, codUsuario); */
    end;


    procedure TraerNombreTienda(): Text
    var
        recTienda: Record Tiendas;
    begin
        if recTienda.Get(codTienda) then
            exit(recTienda.Descripcion);
    end;


    procedure TraerNombreTPV(): Text
    var
        recTPV: Record "Configuracion TPV";
    begin
        if recTPV.Get(codTienda, codTPV) then
            exit(recTPV.Descripcion);
    end;


    procedure FiltrarUsuarioTPV(): Boolean
    var
        recTPV: Record "Configuracion TPV";
    begin
        recTPV.Reset;
        recTPV.SetRange("Usuario windows", UserId);
        if recTPV.FindFirst then begin
            codTienda := recTPV.Tienda;
            codTPV := recTPV."Id TPV";
            FiltrarTienda;
            FiltrarTPV;
            exit(true);
        end;
    end;


    procedure FiltrarTienda()
    begin
        Rec.SetRange("No. tienda");
        if codTienda <> '' then
            Rec.SetRange("No. tienda", codTienda);

        CurrPage.Update(false);
    end;


    procedure FiltrarTPV()
    begin
        Rec.SetRange("No. TPV");
        if codTPV <> '' then
            Rec.SetRange("No. TPV", codTPV);

        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

