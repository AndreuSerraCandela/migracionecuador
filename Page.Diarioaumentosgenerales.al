#pragma implicitwith disable
page 76172 "Diario aumentos generales"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'Diario aumentos generales';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Diario de aumentos generales";

    layout
    {
        area(content)
        {
            group("General ")
            {
                Caption = 'General';
                field("Tipo Aumento"; Rec."Tipo Aumento")
                {

                    trigger OnValidate()
                    begin
                        case Rec."Tipo Aumento" of
                            1:
                                begin
                                    "% AumentoVisible" := true;
                                    "Tope SalarioVisible" := true;
                                    ImporteVisible := true;
                                    "Codigo EmpleadoVisible" := false;
                                end;
                            2:
                                begin
                                    "% AumentoVisible" := true;
                                    "Tope SalarioVisible" := false;
                                    ImporteVisible := false;
                                    "Codigo EmpleadoVisible" := false;
                                end;
                            else begin
                                "Codigo EmpleadoVisible" := true;
                                ImporteVisible := true;
                                "% AumentoVisible" := false;
                                "Tope SalarioVisible" := false;
                            end;
                        end;
                    end;
                }
                field(RedondeoEntero; RedondeoEntero)
                {
                    Caption = 'Redondear a Entero';
                }
            }
            repeater(Detail)
            {
                Caption = 'Detail';
                field("No. empleado"; Rec."No. empleado")
                {
                    Visible = "Codigo EmpleadoVisible";
                }
                field("Full name"; Rec."Full name")
                {
                }
                field("Fecha Efectividad"; Rec."Fecha Efectividad")
                {
                }
                field("Salario actual"; Rec."Salario actual")
                {
                }
                field("% Aumento"; Rec."% Aumento")
                {
                    Visible = "% AumentoVisible";
                }
                field("Nuevo salario"; Rec."Nuevo salario")
                {
                    Visible = ImporteVisible;
                }
                field("Tope Salario"; Rec."Tope Salario")
                {
                    Visible = "Tope SalarioVisible";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Registrar)
            {
                Caption = 'Registrar';
                action(aumento)
                {
                    Caption = 'Propose employees';
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Report "Proponer aumentos por rangos";
                }
                separator(Action1000000001)
                {
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin

                        case Rec."Tipo Aumento" of
                            2:
                                "Gral. por % de Salario";
                            1:
                                "Gral. por Rangos de Salarios";
                            else
                                General;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        "Codigo EmpleadoVisible" := true;
        ImporteVisible := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Tipo Aumento" := optTipoAumento;
    end;

    trigger OnOpenPage()
    begin
        ConfNomina.Get;
    end;

    var
        LinEsqPercepcion: Record "Perfil Salarial";
        AcumuladoSalarios: Record "Acumulado Salarios";
        Empl: Record Employee;
        ConfNomina: Record "Configuracion nominas";
        DiarioAumentos: Record "Diario de aumentos generales";
        ImporteAnterior: Decimal;
        optTipoAumento: Option " ","Gral. por Rango de Salarios","Gral. por % Aumento";
        RedondeoEntero: Boolean;
        "% AumentoVisible": Boolean;
        "Tope SalarioVisible": Boolean;
        ImporteVisible: Boolean;
        "Codigo EmpleadoVisible": Boolean;
        Err001: Label 'There is no line wage salary concept \ for employee # %1';
        Text001: Label 'There have been movements successfully';


    procedure "Gral. por % de Salario"()
    begin
        ConfNomina.TestField("Concepto Sal. Base");
        Rec.Find('-');
        repeat
            LinEsqPercepcion.Reset;
            LinEsqPercepcion.SetRange("Concepto salarial", ConfNomina."Concepto Sal. Base");
            LinEsqPercepcion.SetRange("No. empleado", Rec."No. empleado");
            LinEsqPercepcion.SetRange("Salario Base", true);
            if LinEsqPercepcion.FindFirst then begin
                Empl.Get(LinEsqPercepcion."No. empleado");
                if (Empl."Fecha salida empresa" = 0D) and (Empl.Status <> Empl.Status::Terminated) then begin
                    ImporteAnterior := LinEsqPercepcion.Importe;
                    if RedondeoEntero then begin
                        LinEsqPercepcion.Importe := Round(LinEsqPercepcion.Importe + (LinEsqPercepcion.Importe * Rec."% Aumento" / 100), 1);
                    end
                    else
                        LinEsqPercepcion.Importe := LinEsqPercepcion.Importe + (LinEsqPercepcion.Importe * Rec."% Aumento" / 100);

                    LinEsqPercepcion.Modify;
                    LinEsqPercepcion.MiraSiFormula; //Recalcula los conceptos que tienen formula
                                                    //LinEsqPercepcion.MODIFY;
                                                    // Modifica la fecha final del ultimo salario

                    AcumuladoSalarios."Empresa cotización" := Rec."Empresa Cotizacion";
                    AcumuladoSalarios."No. empleado" := LinEsqPercepcion."No. empleado";
                    AcumuladoSalarios."Fecha Hasta" := CalcDate('-1D', Rec."Fecha Efectividad");
                    AcumuladoSalarios."Fecha Desde" := Rec."Fecha Efectividad";
                    AcumuladoSalarios.Importe := ImporteAnterior;
                    if not AcumuladoSalarios.Insert then
                        AcumuladoSalarios.Modify;
                end;
            end
            else
                Error(Err001, LinEsqPercepcion."No. empleado");
        until Rec.Next = 0;

        Rec.DeleteAll;
        Message(Text001);
    end;


    procedure "Gral. por Rangos de Salarios"()
    begin
        ConfNomina.TestField("Concepto Sal. Base");
        DiarioAumentos.CopyFilters(Rec);
        DiarioAumentos.Find('-');
        repeat
            LinEsqPercepcion.Reset;
            LinEsqPercepcion.SetRange("No. empleado", DiarioAumentos."No. empleado");
            LinEsqPercepcion.SetRange("Concepto salarial", ConfNomina."Concepto Sal. Base");
            LinEsqPercepcion.SetRange("Salario Base", true);
            if LinEsqPercepcion.FindFirst then begin
                Empl.Get(LinEsqPercepcion."No. empleado");
                if (Empl."Fecha salida empresa" = 0D) and (Empl.Status <> Empl.Status::Terminated) then begin
                    ImporteAnterior := LinEsqPercepcion.Importe;

                    if RedondeoEntero then begin
                        LinEsqPercepcion.Validate(Importe, Round(Rec."Nuevo salario", 1));
                    end
                    else
                        LinEsqPercepcion.Validate(Importe, Rec."Nuevo salario");

                    LinEsqPercepcion.Modify;

                    // Modifica la fecha final del ultimo salario

                    AcumuladoSalarios.Reset;
                    AcumuladoSalarios.SetRange("No. empleado", LinEsqPercepcion."No. empleado");
                    if not AcumuladoSalarios.FindLast then begin
                        AcumuladoSalarios."Empresa cotización" := DiarioAumentos."Empresa Cotizacion";
                        AcumuladoSalarios."No. empleado" := LinEsqPercepcion."No. empleado";
                        AcumuladoSalarios."Fecha Desde" := Empl."Employment Date";
                        AcumuladoSalarios."Fecha Hasta" := CalcDate('-1D', DiarioAumentos."Fecha Efectividad");
                    end
                    else begin
                        AcumuladoSalarios."Empresa cotización" := DiarioAumentos."Empresa Cotizacion";
                        AcumuladoSalarios."No. empleado" := LinEsqPercepcion."No. empleado";
                        AcumuladoSalarios."Fecha Hasta" := CalcDate('-1D', DiarioAumentos."Fecha Efectividad");
                        AcumuladoSalarios."Fecha Desde" := DiarioAumentos."Fecha Efectividad";
                    end;
                    AcumuladoSalarios.Importe := ImporteAnterior;
                    if AcumuladoSalarios.Insert then;

                end;
            end
            else
                Error(Err001, LinEsqPercepcion."No. empleado");

        until DiarioAumentos.Next = 0;

        DiarioAumentos.DeleteAll;
        Message(Text001);
    end;


    procedure General()
    begin
        ConfNomina.TestField("Concepto Sal. Base");
        repeat
            if not Rec.Procesado then begin
                LinEsqPercepcion.Reset;
                //       LinEsqPercepcion.SETRANGE("Empresa cotización", "Empresa Cotizacion");
                LinEsqPercepcion.SetRange("No. empleado", Rec."No. empleado");
                LinEsqPercepcion.SetRange("Concepto salarial", ConfNomina."Concepto Sal. Base");
                LinEsqPercepcion.SetRange("Salario Base", true);
                if LinEsqPercepcion.FindFirst then begin
                    ImporteAnterior := LinEsqPercepcion.Importe;
                    LinEsqPercepcion.Importe := Rec."Nuevo salario";
                    LinEsqPercepcion.Modify;
                    LinEsqPercepcion.MiraSiFormula;
                    LinEsqPercepcion.Modify;
                end
                else
                    Error(Err001, Rec."No. empleado");

                // Modifica la fecha final del ultimo salario
                Empl.Get(Rec."No. empleado");
                AcumuladoSalarios.Reset;
                //       AcumuladoSalarios.SETRANGE("Empresa cotización", "Empresa Cotizacion");
                AcumuladoSalarios.SetRange("No. empleado", Rec."No. empleado");
                if not AcumuladoSalarios.FindLast then begin
                    AcumuladoSalarios."Empresa cotización" := Rec."Empresa Cotizacion";
                    AcumuladoSalarios."No. empleado" := Rec."No. empleado";
                    AcumuladoSalarios."Fecha Desde" := Empl."Employment Date";
                    AcumuladoSalarios."Fecha Hasta" := CalcDate('-1D', Rec."Fecha Efectividad");
                    AcumuladoSalarios.Importe := ImporteAnterior;
                    AcumuladoSalarios.Insert;
                end
                else begin
                    AcumuladoSalarios."Fecha Hasta" := CalcDate('-1D', Rec."Fecha Efectividad");
                    AcumuladoSalarios."Fecha Desde" := Rec."Fecha Efectividad";
                    AcumuladoSalarios.Importe := ImporteAnterior;
                    AcumuladoSalarios.Insert;
                end;
                Rec.Procesado := true;
                Rec.Modify;
            end;
        until LinEsqPercepcion.Next = 0;
        Rec.DeleteAll;
        Message(Text001);
    end;
}

#pragma implicitwith restore

