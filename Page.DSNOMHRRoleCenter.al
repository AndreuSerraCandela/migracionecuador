page 76188 "DSNOM HR Role Center"
{
    ApplicationArea = all;
    Caption = 'Home';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1000000002; "Headline RC Order Processor")
            {
                ApplicationArea = Basic, Suite;
            }
            group(Control1000000031)
            {
                ShowCaption = false;
                part(Control1000000030; "DSNOM HR Activities")
                {
                }
                part(Control1000000015; "DSNOM Employees Activities")
                {
                }
            }
            group(Control1000000007)
            {
                Caption = 'Vacations';
                ShowCaption = false;
                part(Control1000000012; "DSNOM Vacaciones Activities")
                {
                }
            }
            group(Control1000000000)
            {
                ShowCaption = false;
                systempart(Control1000000003; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            ToolTip = 'Manage human resource processes, view';
            action(EmpleadosActivos)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Active employees';
                Image = "Order";
                RunObject = Page "Employee List";
                RunPageView = WHERE(Status = CONST(Active));
                ToolTip = 'Visualize Employees with Active status';
            }
            action(EmpleadosInactivos)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Inactive Employees';
                RunObject = Page "Employee List";
                RunPageView = WHERE(Status = CONST(Inactive));
                ToolTip = 'View sales documents that are shipped but not yet invoiced.';
            }
            action(Empleados)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employees';
                Image = Item;
                RunObject = Page "Employee List";
                ToolTip = 'View or edit detailed information for the emplolyees.';
            }
        }
        area(reporting)
        {
            action("Employee - Labels")
            {
                Caption = 'Employee - Labels';
                Image = "Report";
                RunObject = Report "Employee - Labels";
                ToolTip = 'View a list of employees'' mailing labels.';
            }
            action("Employee - List")
            {
                Caption = 'Employee - List';
                Image = "Report";
                RunObject = Report "Employee - List";
                ToolTip = 'View a list of all employees.';
            }
            action("Employee - Misc. Article Info.")
            {
                Caption = 'Employee - Misc. Article Info.';
                Image = "Report";
                RunObject = Report "Employee - Misc. Article Info.";
                ToolTip = 'View a list of employees'' miscellaneous articles.';
            }
            action("Employee - Confidential Info.")
            {
                Caption = 'Employee - Confidential Info.';
                Image = "Report";
                RunObject = Report "Employee - Confidential Info.";
                ToolTip = 'View a list of employees'' confidential information.';
            }
            action("Employee - Staff Absences")
            {
                Caption = 'Employee - Staff Absences';
                Image = "Report";
                RunObject = Report "Employee - Staff Absences";
                ToolTip = 'View a list of employee absences by date. The list includes the cause of each employee absence.';
            }
            action("Employee - Absences by Causes")
            {
                Caption = 'Employee - Absences by Causes';
                Image = "Report";
                RunObject = Report "Employee - Absences by Causes";
                ToolTip = 'View a list of all employees'' absences categorized by absence code.';
            }
            action("Employee - Qualifications")
            {
                Caption = 'Employee - Qualifications';
                Image = "Report";
                RunObject = Report "Employee - Qualifications";
                ToolTip = 'View a list of employees'' qualifications.';
            }
            action("Employee - Addresses")
            {
                Caption = 'Employee - Addresses';
                Image = "Report";
                RunObject = Report "Employee - Addresses";
                ToolTip = 'View a list of employees'' addresses.';
            }
            action("Employee - Relatives")
            {
                Caption = 'Employee - Relatives';
                Image = "Report";
                RunObject = Report "Employee - Relatives";
                ToolTip = 'View a list of employees'' relatives.';
            }
            action("Employee - Birthdays")
            {
                Caption = 'Employee - Birthdays';
                Image = "Report";
                RunObject = Report "Employee - Birthdays";
                ToolTip = 'View a list of employees'' birthdays.';
            }
            action("Employee - Phone Nos.")
            {
                Caption = 'Employee - Phone Nos.';
                Image = "Report";
                RunObject = Report "Employee - Phone Nos.";
                ToolTip = 'View a list of employees'' phone numbers.';
            }
            action("Employee - Unions")
            {
                Caption = 'Employee - Unions';
                Image = "Report";
                RunObject = Report "Employee - Unions";
                ToolTip = 'View a list of employees'' union memberships.';
            }
            action("Employee - Contracts")
            {
                Caption = 'Employee - Contracts';
                Image = "Report";
                RunObject = Report "Employee - Contracts";
                ToolTip = 'View all employee contracts.';
            }
            action("Employee - Alt. Addresses")
            {
                Caption = 'Employee - Alt. Addresses';
                Image = "Report";
                RunObject = Report "Employee - Alt. Addresses";
                ToolTip = 'View a list of employees'' alternate addresses.';
            }
        }
        area(sections)
        {
            group("Administration HR")
            {
                Caption = 'Administration HR';
                Image = HumanResources;
                action("Human Resources Unit of Measure")
                {
                    Caption = 'Human Resources Unit of Measure';
                    RunObject = Page "Human Res. Units of Measure";
                    ToolTip = 'View or edit the Units in which you measure human resources'' work, such as Hours.';
                }
                action("Vend. Causes of Absence")
                {
                    Caption = 'Vend. Causes of Absence';
                    RunObject = Page "Causes of Absence";
                    ToolTip = 'View or edit causes of absence for your vendor resources. These codes can be used to indicate various reasons for employee absences, such as sickness, vacation, personal days, personal emergencies, and so on.';
                }
                action("Causes of Inactivity")
                {
                    Caption = 'Causes of Inactivity';
                    RunObject = Page "Causes of Inactivity";
                    ToolTip = 'Register causes of inactivity codes for your employees. These codes can be used for various reasons causing employee inactiveness, such as maternity leave, long-term illness, sabbatical, and so on.';
                }
                action("Grounds for Termination")
                {
                    Caption = 'Grounds for Termination';
                    RunObject = Page "Grounds for Termination";
                    ToolTip = 'View or edit grounds for termination codes for your employees. These codes can be used for various reasons for employee termination, such as dismissal, retirement, resignation, and so on.';
                }
                action(Unions)
                {
                    Caption = 'Unions';
                    RunObject = Page Unions;
                    ToolTip = 'View a list of labor and trade unions. For each union, the report shows the employees who are members of the union.';
                }
                action("Employment Contracts")
                {
                    Caption = 'Employment Contracts';
                    RunObject = Page "Employment Contracts";
                    ToolTip = 'View or edit employment contracts.';
                }
                action(Relatives)
                {
                    Caption = 'Relatives';
                    Image = Relatives;
                    RunObject = Page Relatives;
                    ToolTip = 'View a list of employees'' relatives for selected employees. For each employee, the report shows basic information about the employee''s relatives such as name and date of birth.';
                }
                action("Misc. Articles")
                {
                    Caption = 'Misc. Articles';
                    RunObject = Page "Misc. Articles";
                    ToolTip = 'View the benefits that your employees receive and other articles that are in your employees'' possession (keys, computers, company cars, memberships in company clubs, and so on).';
                }
                action(Confidential)
                {
                    Caption = 'Confidential';
                    RunObject = Page Confidential;
                    ToolTip = 'Register confidential information related to your employees such as salaries, stock option plans, pensions, and so on.';
                }
                action(Qualifications)
                {
                    Caption = 'Qualifications';
                    Image = Certificate;
                    RunObject = Page Qualifications;
                    ToolTip = 'View or register qualification codes for your employees. These codes can be used for various employee qualifications: job titles, employee computer skills, education, courses, and so on.';
                }
                action("Employee Statistics Groups")
                {
                    Caption = 'Employee Statistics Groups';
                    RunObject = Page "Employee Statistics Groups";
                    ToolTip = 'View or edit the grouping of employees for statistical purposes.';
                }
            }
        }
        area(processing)
        {
            separator(Administration)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("Human Resources Setup")
            {
                Caption = 'Human Resources Setup';
                RunObject = Page "Human Resources Setup";
                ToolTip = 'Set up number series for creating new employee cards and define if employment time is measured by days or hours.';
            }
        }
    }
}

