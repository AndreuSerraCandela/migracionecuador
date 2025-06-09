page 76187 "DSNOM HR  Employee Self Serv."
{
    ApplicationArea = all;
    Caption = 'Home';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1000000031)
            {
                ShowCaption = false;
                part(Control1000000030; "DSNOM HR Activities")
                {
                }
                part(Control1000000015; "DSNOM Employees Activities")
                {
                }
                part(Control1000000012; "DSNOM Vacaciones Activities")
                {
                }
            }
            group(Control1000000006)
            {
                ShowCaption = false;
                systempart(Control1000000005; Notes)
                {
                }
                systempart(Control1000000003; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
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
    }
}

