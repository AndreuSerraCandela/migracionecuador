#pragma implicitwith disable
page 76173 "Diario Nominas"
{
    ApplicationArea = all;
    AdditionalSearchTerms = 'Payroll journal';
    Caption = 'Payroll journal';
    DataCaptionFields = "No.", "Full Name";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(GETFILTERS; rec.GetFilters)
            {
                Editable = false;
                Visible = false;
            }
            group(ListEmpl)
            {
                Caption = 'Employees';
                repeater(ListEmplR)
                {
                    Editable = false;
                    FreezeColumn = "Full Name";
                    field("No."; rec."No.")
                    {
                        Editable = false;
                        Importance = Promoted;
                    }
                    field("Full Name"; rec."Full Name")
                    {
                        Importance = Promoted;
                    }
                    field("Document ID"; rec."Document ID")
                    {
                        Editable = false;
                    }
                    field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                    {
                        Editable = false;
                    }
                    field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                    {
                        Editable = false;
                    }
                    field("Employment Date"; rec."Employment Date")
                    {
                        Editable = false;
                    }
                    field("Job Type Code"; rec."Job Type Code")
                    {
                        Editable = false;
                    }
                    field("Job Title"; rec."Job Title")
                    {
                        Editable = false;
                    }
                    field("Calcular Nomina"; rec."Calcular Nomina")
                    {
                        Editable = false;
                    }
                    field(Departamento; rec.Departamento)
                    {
                        Editable = false;
                    }
                    field("Desc. Departamento"; rec."Desc. Departamento")
                    {
                        Editable = false;
                    }
                }
            }
            part(subformesqsal; "Page Lin. Esq. Ingresos")
            {
                SubPageLink = "No. empleado" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Procesos")
            {
                Caption = '&Procesos';
                action("Init Wedges")
                {
                    Caption = 'Init Wedges';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        /*           FuncionesNomina.InicializaConceptosSalariales; */
                    end;
                }
                separator(Action1000000001)
                {
                }
                action("Import employee data")
                {
                    Caption = 'Import employee data';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Importa datos empleados";
                }
                action("Import Expenses from G/L")
                {
                    Caption = 'Import Expenses from G/L';
                    Image = ReceiveLoaner;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Proceso Carga Gtos. a Nomina";
                }
                action("Calculate payroll")
                {
                    Caption = 'Calculate payroll';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Registrar nóminas por lotes";
                }
                action("Init Wedge")
                {
                    Caption = 'Init Wedge';
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Inic. Concepto Salarial";
                }
                separator(Action1000000017)
                {
                }
                action(CalculoIncentivoProy)
                {
                    Caption = 'Calculate operator incentive';
                    Image = CalculateRemainingUsage;
                    Promoted = true;
                    PromotedCategory = Process;
                    //RunObject = Report Report50211;
                }
                group(Reports)
                {
                    Caption = 'Reports';
                }
                action(Prestamos)
                {
                    Caption = 'Employee loans report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Listado de prestamos personal";
                }
                action(Vacaciones)
                {
                    Caption = 'Employee vacation report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Listado de vacaciones personal";
                }
                action("ListNomxDepto8.5")
                {
                    Caption = 'Payroll report';
                    Image = Report;
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin
                        ConfNominas.Get();
                        ConfNominas.TestField("ID Informe de nomina");
                        REPORT.Run(ConfNominas."ID Informe de nomina", true, true);
                    end;
                }
                action(ExportExcel)
                {
                    Caption = 'Export payroll to excel';
                    Image = Excel;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "DSN-Export Payroll To Excel";
                }
            }
            group("&Empleado")
            {
                Caption = '&Empleado';
                action("Employee Card")
                {
                    Caption = 'Employee Card';
                    Image = Employee;
                    RunObject = Page "Ficha Empleados";
                    RunPageLink = Company = FIELD(Company),
                                  "No." = FIELD("No.");
                }
                action("Posted Payrolls")
                {
                    Caption = 'Posted Payrolls';
                    Image = Documents;

                    trigger OnAction()
                    begin

                        CabHistorico.Reset;
                        CabHistorico.SetRange("No. empleado", Rec."No.");
                        if CabHistorico.Find('-') then begin
                            formCabNominas.SetTableView(CabHistorico);
                            formCabNominas.RunModal;
                            Clear(formCabNominas);
                        end else
                            Message(StrSubstNo(Text001), Rec."No.", CabHistorico.TableCaption);
                        //   MESSAGE('El empleado No. %1 no tiene movimientos en el Histórico \' +
                        //            'de Nóminas, Verifique', "No.");
                    end;
                }
                action("Absence Registration")
                {
                    Caption = 'Absence Registration';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = FIELD("No."),
                                  Closed = CONST(false);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        StatusEmpl := true;
        TipoColumna := 2;
        TipoConcepto := 2;

        //RESET;
        if Empresa <> '' then
            Rec.SetRange(Company, Empresa);

        if FiltroDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Code", FiltroDim1);

        if FiltroDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Code", FiltroDim2);

        if StatusEmpl then
            Rec.SetRange("Termination Date", 0D);
    end;

    var
        formCabNominas: Page "Lista historico nóminas";
        Empl: Record Employee;
        CabHistorico: Record "Historico Cab. nomina";
        ConfNominas: Record "Configuracion nominas";
        /*      FuncionesNomina: Codeunit "Funciones Nomina"; */
        StatusEmpl: Boolean;
        TipoConcepto: Option Ingresos,Deducciones,Ambos;
        TipoColumna: Option Cantidad,Importe,Ambos;
        FiltroDim1: Text[250];
        FiltroDim2: Text[250];
        Empresa: Text[30];
        EmplAct: Boolean;
        FiltroConcepto: Text[250];
        CodEmpl: Code[20];
        Text001: Label 'Employee %1 doesn''t have entries in the %2';

    local procedure FiltroDim1OnAfterValidate()
    begin
        Rec.Reset;
        if Empresa <> '' then
            Rec.SetRange(Company, Empresa);

        if FiltroDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Code", FiltroDim1);

        if FiltroDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Code", FiltroDim2);

        if StatusEmpl then
            Rec.SetRange("Fecha salida empresa", 0D);

        CurrPage.Update(false);
    end;

    local procedure FiltroDim2OnAfterValidate()
    begin
        Rec.Reset;
        if Empresa <> '' then
            Rec.SetRange(Company, Empresa);

        if FiltroDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Code", FiltroDim1);

        if FiltroDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Code", FiltroDim2);

        if StatusEmpl then
            Rec.SetRange("Fecha salida empresa", 0D);

        CurrPage.Update(false);
    end;

    local procedure StatusEmplOnAfterValidate()
    begin
        Rec.Reset;
        if Empresa <> '' then
            Rec.SetRange(Company, Empresa);

        if FiltroDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Code", FiltroDim1);

        if FiltroDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Code", FiltroDim2);

        if StatusEmpl then
            Rec.SetRange("Fecha salida empresa", 0D);

        CurrPage.Update(false);
    end;

    local procedure EmpresaOnAfterValidate()
    begin
        Rec.Reset;
        if Empresa <> '' then
            Rec.SetRange(Company, Empresa);

        if FiltroDim1 <> '' then
            Rec.SetFilter("Global Dimension 1 Code", FiltroDim1);

        if FiltroDim2 <> '' then
            Rec.SetFilter("Global Dimension 2 Code", FiltroDim2);

        if StatusEmpl then
            Rec.SetRange("Fecha salida empresa", 0D);

        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

