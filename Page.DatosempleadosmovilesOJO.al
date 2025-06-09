#pragma implicitwith disable
page 76165 "Datos empleados moviles OJO"
{
    ApplicationArea = all;
    Caption = 'Temporary Employee Information';
    PageType = Card;
    SourceTable = Employee;
    SourceTableView = WHERE("Tipo Empleado" = CONST(Temporal));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        /*IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                          */

                    end;
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document ID"; Rec."Document ID")
                {
                }
                field(Filtros; 'Filtros : ' + Rec.GetFilters)
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Caption = 'Middle Name/Initials';
                }
                field("Second Last Name"; Rec."Second Last Name")
                {
                }
                field(Salario; Rec.Salario)
                {
                }
            }
            group(Control1000000062)
            {
                Caption = 'General';
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field(County; Rec.County)
                {
                    Caption = 'State/ZIP Code';
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(Nacionalidad; Rec.Nacionalidad)
                {
                }
                field("Codigo Cliente"; Rec."Codigo Cliente")
                {
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                }
                field("<Division>"; Rec.Departamento)
                {
                }
                field("<Departamento>"; Rec."Sub-Departamento")
                {
                }
                field("Calcular Nomina"; Rec."Calcular Nomina")
                {
                }
                field("Tipo Empleado"; Rec."Tipo Empleado")
                {
                }
                field("Employee Level"; Rec."Employee Level")
                {
                }
                field("Incentivos/Puntos"; Rec."Incentivos/Puntos")
                {
                }
            }
            part(Lineas; "Lin. conceptos salariales Emp.")
            {
                SubPageLink = "No. empleado" = FIELD("No.");
            }
            group(Contratacion)
            {
                Caption = 'Employee Information';
                field("Employment Date"; Rec."Employment Date")
                {
                }
                field(Company; Rec.Company)
                {
                }
                field("Working Center"; Rec."Working Center")
                {
                }
                field("Job Type Code"; Rec."Job Type Code")
                {
                }
                field("Job Title"; Rec."Job Title")
                {
                }
                field("Cod. Supervisor"; Rec."Cod. Supervisor")
                {
                }
                field("Nombre Supervisor"; Rec."Nombre Supervisor")
                {
                }
                field("Posting Group"; Rec."Posting Group")
                {
                }
                field(Pensionado; Rec.Pensionado)
                {
                }
                field("Alta contrato"; Rec."Alta contrato")
                {
                }
                field("Fin contrato"; Rec."Fin contrato")
                {
                }
                field("Fecha salida empresa"; Rec."Fecha salida empresa")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
            }
            group(Complementarios)
            {
                Caption = 'Complementarios';
                field(Gender; Rec.Gender)
                {
                }
                field("Birth Date"; Rec."Birth Date")
                {
                }
                field("Lugar nacimiento"; Rec."Lugar nacimiento")
                {
                }
                field("Mes Nacimiento"; Rec."Mes Nacimiento")
                {
                }
                field("Estado civil"; Rec."Estado civil")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                }
                field("Fax No."; Rec."Fax No.")
                {
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field(Extension; Rec.Extension)
                {
                }
            }
            group(GrupoBancoAfiliaciones)
            {
                Caption = 'Banco/Afiliaciones';
                group(GrupoBanco)
                {
                    Caption = 'Banco';
                    field("Forma de Cobro"; Rec."Forma de Cobro")
                    {
                    }
                    field("Disponible 1"; Rec."Disponible 1")
                    {
                    }
                    field("Disponible 2"; Rec."Disponible 2")
                    {
                    }
                    field(Cuenta; Rec.Cuenta)
                    {
                    }
                }
                group(GrupoSeguridad)
                {
                    Caption = 'Seguridad Social';
                    field("Dia nacimiento"; Rec."Dia nacimiento")
                    {
                    }
                    field("Cod. AFP"; Rec."Cod. AFP")
                    {
                    }
                    field("Cod. ARS"; Rec."Cod. ARS")
                    {
                    }
                    field("Agente de Retencion ISR"; Rec."Agente de Retencion ISR")
                    {
                    }
                    field("RNC Agente de Retencion ISR"; Rec."RNC Agente de Retencion ISR")
                    {
                    }
                    field("Excluído Cotización TSS"; Rec."Excluído Cotización TSS")
                    {
                    }
                    field("Excluído Cotización ISR"; Rec."Excluído Cotización ISR")
                    {
                    }
                }
            }
        }
        area(factboxes)
        {
            part("Informacion del empleado"; "Informacion del empleado")
            {
                Caption = 'Informacion del empleado';
            }
            part("Informacion de nominas"; "Informacion de nominas")
            {
                Caption = 'Informacion de nominas';
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Employee),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(5200),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = FIELD("No.");
                }
                action("&Alternative Addresses")
                {
                    Caption = '&Alternative Addresses';
                    RunObject = Page "Alternative Address Card";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Relati&ves")
                {
                    Caption = 'Relati&ves';
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Mi&sc. Article Information")
                {
                    Caption = 'Mi&sc. Article Information';
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Con&fidential Information")
                {
                    Caption = 'Con&fidential Information';
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("Q&ualifications")
                {
                    Caption = 'Q&ualifications';
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = FIELD("No.");
                }
                separator(Action1000000059)
                {
                }
                action("&Related Companies")
                {
                    Caption = '&Related Companies';
                    RunObject = Page "Relacion Empresas Empleados";
                    RunPageLink = "Cod. Empleado" = FIELD("No.");
                }
                separator(Action23)
                {
                }
                action("Absences b&y Categories")
                {
                    Caption = 'Absences b&y Categories';
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = FIELD("No."),
                                  "Employee No. Filter" = FIELD("No.");
                }
                action("Misc. Articles &Overview")
                {
                    Caption = 'Misc. Articles &Overview';
                    RunObject = Page "Misc. Articles Overview";
                }
                action("Confidential Info. Overvie&w")
                {
                    Caption = 'Confidential Info. Overvie&w';
                    RunObject = Page "Confidential Info. Overview";
                }
                separator(Action61)
                {
                }
                action("Online Map")
                {
                    Caption = 'Online Map';

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
            }
            group("&Payroll")
            {
                Caption = '&Payroll';
                action("&Contract")
                {
                    Caption = '&Contract';
                    RunObject = Page Contratos;
                    RunPageLink = "Empresa cotización" = FIELD(Company),
                                  "No. empleado" = FIELD("No.");
                }
                action("&History")
                {
                    Caption = '&History';
                    RunObject = Page "Lista historico nóminas";
                    RunPageLink = "No. empleado" = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            action(Payroll)
            {
                Caption = 'Payroll';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Action1000000003)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Qualifications)
            {
                Caption = 'Qualifications';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
            action(Absenses)
            {
                Caption = 'Absenses';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.GetFilter("Date Filter") = '' then
            Rec.SetRange("Date Filter", 0D, DMY2Date(31, 12, Date2DMY(Today, 3)));

        FechaIni := Rec.GetRangeMin("Date Filter");
        FechaFin := Rec.GetRangeMax("Date Filter");
    end;

    trigger OnInit()
    begin
        MapPointVisible := true;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        if not MapMgt.TestSetup then
            MapPointVisible := false;
    end;

    var
        Mail: Codeunit Mail;

        FechaIni: Date;
        FechaFin: Date;

        MapPointVisible: Boolean;
}

#pragma implicitwith restore

