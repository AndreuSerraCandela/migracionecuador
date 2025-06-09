#pragma implicitwith disable
page 76059 "Control de asistencia"
{
    ApplicationArea = all;
    Caption = 'Time and attendance';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Control de asistencia";

    layout
    {
        area(content)
        {
            field(filtroempleado; FiltroEmpleado)
            {
                Caption = 'Employee code filter';

                trigger OnValidate()
                begin
                    Filtrar;
                end;
            }
            field(filtrofechadesde; FiltroFechaDesde)
            {
                Caption = 'From date filter';

                trigger OnValidate()
                begin
                    Filtrar;
                end;
            }
            field(filtrofechaHasta; FiltroFechaHasta)
            {
                Caption = 'To date filter';

                trigger OnValidate()
                begin
                    Filtrar;
                end;
            }
            repeater(Control1000000001)
            {
                ShowCaption = false;
                field("Cod. Empleado"; Rec."Cod. Empleado")
                {
                    StyleExpr = Styletxt;
                }
                field("Fecha registro"; Rec."Fecha registro")
                {
                }
                field("Nombre dia"; Rec."Nombre dia")
                {
                    Editable = false;
                }
                field("Hora registro"; Rec."Hora registro")
                {
                }
                field("No. tarjeta"; Rec."No. tarjeta")
                {
                    Visible = false;
                }
                field("ID Equipo"; Rec."ID Equipo")
                {
                    Visible = false;
                }
                field("Full name"; Rec."Full name")
                {
                    StyleExpr = Styletxt;
                }
                field("Job Title"; Rec."Job Title")
                {
                }
                field("Fecha Entrada"; Rec."Fecha Entrada")
                {
                }
                field("Fecha Salida"; Rec."Fecha Salida")
                {
                }
                field("1ra entrada"; Rec."1ra entrada")
                {

                    trigger OnValidate()
                    begin
                        if Rec."1ra entrada" <> xRec."1ra entrada" then
                            Rec."Metodo registro" := Rec."Metodo registro"::"Completado manualmente";
                    end;
                }
                field("1ra salida"; Rec."1ra salida")
                {

                    trigger OnValidate()
                    begin
                        if Rec."2da salida" <> xRec."2da salida" then
                            Rec."Metodo registro" := Rec."Metodo registro"::"Completado manualmente";
                    end;
                }
                field("2da entrada"; Rec."2da entrada")
                {

                    trigger OnValidate()
                    begin
                        if Rec."2da entrada" <> xRec."2da entrada" then
                            Rec."Metodo registro" := Rec."Metodo registro"::"Completado manualmente";
                    end;
                }
                field("2da salida"; Rec."2da salida")
                {

                    trigger OnValidate()
                    begin
                        if Rec."2da salida" <> xRec."2da salida" then
                            Rec."Metodo registro" := Rec."Metodo registro"::"Completado manualmente";
                    end;
                }
                field("Total Horas"; Rec."Total Horas")
                {
                }
                field("Horas receso"; Rec."Horas receso")
                {
                }
                field("Horas laboradas"; Rec."Horas laboradas")
                {
                }
                field("Horas regulares"; Rec."Horas regulares")
                {
                    Editable = false;
                    Visible = HorasVisibles;
                }
                field("Horas nocturnas"; Rec."Horas nocturnas")
                {
                }
                field("Horas extras al 35"; Rec."Horas extras al 35")
                {
                    Editable = false;
                    Visible = HorasVisibles;
                }
                field("Horas extras 100"; Rec."Horas extras 100")
                {
                    Editable = false;
                    Visible = HorasVisibles;
                }
                field("Horas feriadas"; Rec."Horas feriadas")
                {
                    Editable = false;
                    Visible = HorasVisibles;
                }
            }
            group(Control1000000041)
            {
                ShowCaption = false;
                fixed(Control1000000032)
                {
                    ShowCaption = false;
                    group("Worked hours total")
                    {
                        Caption = 'Worked hours total';
                        field(TotalHorasLab; TotalHorasLab)
                        {
                        }
                    }
                    group("Rest hours total")
                    {
                        Caption = 'Rest hours total';
                        field(TotalHorasRec; TotalHorasRec)
                        {
                            Caption = 'Total Hours recess';
                            Editable = false;
                        }
                    }
                    group("Regular hours total")
                    {
                        Caption = 'Regular hours total';
                        field(TotalHorReg; TotalHorReg)
                        {
                            Caption = 'Regular hours total';
                            Editable = false;
                        }
                    }
                    group("35% Hours total")
                    {
                        Caption = '35% Hours total';
                        field(TotalHorE35; TotalHorE35)
                        {
                            AutoFormatType = 1;
                            Caption = '35% hours total';
                            Editable = false;
                        }
                    }
                    group("Holliday hours total")
                    {
                        Caption = 'Holliday hours total';
                        field(TotalHorFer; TotalHorFer)
                        {
                            Caption = 'Total Holliday hours';
                            Editable = false;
                        }
                    }
                    group("100% hours total")
                    {
                        Caption = '100% hours total';
                        field(TotalHorE100; TotalHorE100)
                        {
                            Editable = false;
                        }
                    }
                    group("Night hour total")
                    {
                        Caption = 'Night hour total';
                        field(TotalHorNoc; TotalHorNoc)
                        {
                            Editable = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Action")
            {
                Caption = '&Action';
                Image = HumanResources;
                action(ImportDataManually)
                {
                    Caption = 'Import data manually';
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                    end;
                }
                action(ImportAuto)
                {
                    Caption = 'Import data from T&A Clock';
                    Image = LinesFromTimesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var

                    begin
                        //AdoConn.ReadEmp;

                    end;
                }
                action("Page Distrib. Control de asis. ")
                {
                    Caption = 'Distrib. Job attendance control';
                    Image = Splitlines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DCA: Record "Distrib. Control de asis. Proy";
                    begin
                        Rec.TestField("Cod. Empleado");
                        Rec.TestField("Fecha registro");
                        Rec.TestField("Hora registro");

                        DCA.Reset;
                        DCA.SetRange("Cod. Empleado", Rec."Cod. Empleado");
                        DCA.SetRange("Fecha registro", Rec."Fecha registro");
                        DCA.SetRange("Hora registro", Rec."Hora registro");
                        DistribAsistencia.SetTableView(DCA);
                        DistribAsistencia.RunModal();
                        Clear(DistribAsistencia);
                    end;
                }
                action("Page Datos Ponchador")
                {
                    Caption = 'View Time attendance';
                    Image = ViewWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Datos Ponchador";
                    RunPageLink = "Cod. Empleado" = FIELD("Cod. Empleado"),
                                  "Fecha registro" = FIELD("Fecha registro");
                }
                action(GenerarCalculo)
                {
                    Caption = 'Calc payroll payment';
                    Image = CalculateRemainingUsage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Procesar datos ponchador";

                    trigger OnAction()
                    var

                    begin
                    end;
                }
                action(ProcesarDatosPonchador)
                {
                    Caption = 'Process batch punch';
                    Image = ExecuteAndPostBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Acumula;
        StyleTxt := SetStyle;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        StyleTxt := SetStyle;
    end;

    trigger OnOpenPage()
    begin
        ConfNom.Get();
        HorasVisibles := ConfNom."Calcular horas reg. asistencia";
        Filtrar;
        Acumula;
    end;

    var
        ConfNom: Record "Configuracion nominas";
        DistribAsistencia: Page "Provisiones Fijas x Empleados";

        HorasVisibles: Boolean;
        TotalHorasLab: Decimal;
        TotalHorasRec: Decimal;
        TotalHorReg: Decimal;
        TotalHorE35: Decimal;
        TotalHorE100: Decimal;
        TotalHorNoc: Decimal;
        TotalHorFer: Decimal;
        FiltroFechaDesde: Date;
        FiltroFechaHasta: Date;
        FiltroEmpleado: Code[20];
        TotalhorasLablbl: Label 'Total Horas Laboradas';
        TotalHorasReclbl: Label 'Total Hours recess';
        Dummy: Text[1];
        StyleTxt: Text;

    local procedure Filtrar()
    begin
        Rec.Reset;
        if FiltroEmpleado <> '' then
            Rec.SetRange("Cod. Empleado", FiltroEmpleado);
        if (FiltroFechaDesde <> 0D) and (FiltroFechaHasta <> 0D) then
            Rec.SetRange("Fecha registro", FiltroFechaDesde, FiltroFechaHasta);
        CurrPage.Update(false);
    end;

    local procedure Acumula()
    var
        ControlAsist: Record "Control de asistencia";
    begin
        TotalHorasLab := 0;
        TotalHorasRec := 0;
        TotalHorReg := 0;
        TotalHorE35 := 0;
        TotalHorE100 := 0;
        TotalHorNoc := 0;
        TotalHorFer := 0;

        ControlAsist.CopyFilters(Rec);
        //MESSAGE('%1',ControlAsist.GETFILTERS);
        if ControlAsist.FindSet then
            repeat
                TotalHorasLab += ControlAsist."Horas regulares" + ControlAsist."Horas receso";
                TotalHorasRec += ControlAsist."Horas receso";
                TotalHorReg += ControlAsist."Horas regulares";
                TotalHorE35 += ControlAsist."Horas extras al 35";
                TotalHorE100 += ControlAsist."Horas extras 100";
                TotalHorNoc += ControlAsist."Horas nocturnas";
                TotalHorFer += ControlAsist."Horas feriadas";
            until ControlAsist.Next = 0;
        //CurrPage.UPDATE();
    end;

    procedure SetStyle(): Text
    begin
        case Rec."Metodo registro" of
            2:
                exit('StandardAccent');
            3:
                exit('StrongAccent');
            else
                exit('');
        end;

        /*
        Value            Description
        None            None
        Standard          Standard
        StandardAccent    Blue
        Strong          Bold
        StrongAccent    Blue + Bold
        Attention        Red + Italic
        AttentionAccent   Blue + Italic
        Favorable        Bold + Green
        Unfavorable      Bold + Italic + Red
        Ambiguous        Yellow
        Subordinate      Grey
        */

    end;
}

#pragma implicitwith restore

