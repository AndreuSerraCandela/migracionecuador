#pragma implicitwith disable
page 76199 "Employee List - Payroll"
{
    ApplicationArea = all;
    Caption = 'Employee List';
    CardPageID = "Employee Card";
    Editable = false;
    PageType = List;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; rec."No.")
                {
                }
                field(FullName; rec.FullName)
                {
                    Caption = 'Full Name';
                }
                field("First Name"; rec."First Name")
                {
                    Visible = false;
                }
                field("Middle Name"; rec."Middle Name")
                {
                    Visible = false;
                }
                field("Last Name"; rec."Last Name")
                {
                    Visible = false;
                }
                field(Initials; rec.Initials)
                {
                    Visible = false;
                }
                field("Job Title"; rec."Job Title")
                {
                }
                field("Post Code"; rec."Post Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                    Visible = false;
                }
                field(Extension; rec.Extension)
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                    Visible = false;
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                    Visible = false;
                }
                field("E-Mail"; rec."E-Mail")
                {
                    Visible = false;
                }
                field("Birth Date"; rec."Birth Date")
                {
                }
                field("Mes Nacimiento"; rec."Mes Nacimiento")
                {
                }
                field("Statistics Group Code"; rec."Statistics Group Code")
                {
                    Visible = false;
                }
                field("Resource No."; rec."Resource No.")
                {
                    Visible = false;
                }
                field("Search Name"; rec."Search Name")
                {
                }
                field("Incentivos/Puntos"; rec."Incentivos/Puntos")
                {
                }
                field(Departamento; rec.Departamento)
                {
                }
                field("Sub-Departamento"; rec."Sub-Departamento")
                {
                }
                field("Fecha salida empresa"; rec."Fecha salida empresa")
                {
                }
                field(Salario; rec.Salario)
                {
                }
                field("Total ingresos"; rec."Total ingresos")
                {
                }
                field("Total deducciones"; rec."Total deducciones")
                {
                }
                field(Cuenta; rec.Cuenta)
                {
                }
                field(Comment; rec.Comment)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(5200),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
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
                    RunObject = Page "Alternative Address List";
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
                separator(Action51)
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
            }
        }
    }

    trigger OnOpenPage()
    begin
        Parametros(GFiltro);
        ParamCompany(Emp);
        if Emp <> '' then
            Rec.ChangeCompany(Emp);
    end;

    var
        GFiltro: Date;
        Emp: Text[150];


    procedure Parametros(var Filtro: Date)
    begin
    end;


    procedure ParamCompany(Empresa: Text[150])
    begin
        Emp := Empresa
    end;
}

#pragma implicitwith restore

