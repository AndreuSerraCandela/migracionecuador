page 76566 "ES Role Center"
{
    ApplicationArea = all;
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                /*           part(Control1900699908; "ES Activities")
                          {
                          } */
                systempart(Control1901420308; Outlook)
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                /*                 part(Control1906259808; "ES Roles and Logins FactBox")
                                {
                                }
                                part(Control1900585008; "ES FLADS FactBox")
                                {
                                } */
                systempart(Control1901377608; MyNotes)
                {
                }
            }
        }
    }

    /*  actions
     {
         area(reporting)
         {
             action("Compare Login")
             {
                 Caption = 'Compare Login';
                 Image = Print;
                 RunObject = Report "ES Compare Login";
             }
             action("Compare Role")
             {
                 Caption = 'Compare Role';
                 Image = Print;
                 RunObject = Report "ES Compare Role";
             }
             action("Compare Recording")
             {
                 Caption = 'Compare Recording';
                 Image = Print;
                 RunObject = Report "ES Compare Recording";
             }
             action("Compare Restore Point")
             {
                 Caption = 'Compare Restore Point';
                 Image = Print;
                 RunObject = Report "ES Compare Restore Point";
             }
         }
         area(embedding)
         {
         }
         area(sections)
         {
             group("Easy Security")
             {
                 Caption = 'Easy Security';
                 action(Logins)
                 {
                     Caption = 'Logins';
                     Image = TeamSales;
                     RunObject = Page "ES Logins";
                 }
                 action("Role Groups")
                 {
                     Caption = 'Role Groups';
                     Image = Components;
                     RunObject = Page "ES Role Groups";
                 }
                 action("Company Groups")
                 {
                     Caption = 'Company Groups';
                     RunObject = Page "ES Company Groups";
                 }
                 action(Roles)
                 {
                     Caption = 'Roles';
                     Image = Components;
                     RunObject = Page "ES Roles";
                 }
                 action(Recordings)
                 {
                     Caption = 'Recordings';
                     Image = TaskList;
                     RunObject = Page "ES Recordings";
                 }
                 action(Relations)
                 {
                     Caption = 'Relations';
                     Image = Track;
                     RunObject = Page "ES Relations";
                 }
                 action("Table Relations")
                 {
                     Caption = 'Table Relations';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST ("Table Relation");
                 }
                 action(Flowfields)
                 {
                     Caption = 'Flowfields';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST (Flowfield);
                 }
                 action("Source Tables")
                 {
                     Caption = 'Source Tables';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST ("Source Table");
                 }
                 action("Data Items")
                 {
                     Caption = 'Data Items';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST ("Data Item");
                 }
                 action(Permissions)
                 {
                     Caption = 'Permissions';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST (Permission);
                 }
                 action("Data Per Company")
                 {
                     Caption = 'Data Per Company';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST ("Data Per Company");
                 }
                 action(PagePartID)
                 {
                     Caption = 'PagePartID';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST (PagePartID);
                 }
                 action(Manual)
                 {
                     Caption = 'Manual';
                     Image = Track;
                     RunObject = Page "ES Relations";
                     RunPageLink = Type = CONST (Manual);
                 }
                 action(Variables)
                 {
                     Caption = 'Variables';
                     Image = Track;
                     RunObject = Page "ES Variables";
                 }
                 action("Global Variable")
                 {
                     Caption = 'Global Variable';
                     Image = Track;
                     RunObject = Page "ES Variables";
                     RunPageLink = "Reference Type" = CONST ("Global Variable");
                 }
                 action("Local Variable")
                 {
                     Caption = 'Local Variable';
                     Image = Track;
                     RunObject = Page "ES Variables";
                     RunPageLink = "Reference Type" = CONST ("Local Variable");
                 }
                 action(Parameter)
                 {
                     Caption = 'Parameter';
                     Image = Track;
                     RunObject = Page "ES Variables";
                     RunPageLink = "Variable is a Parameter" = CONST (true);
                 }
                 action("Return Value")
                 {
                     Caption = 'Return Value';
                     Image = Track;
                     RunObject = Page "ES Variables";
                     RunPageLink = "Return Value" = CONST (true);
                 }
                 separator(Action1240520031)
                 {
                 }
                 action("Windows Logins")
                 {
                     Caption = 'Windows Logins';
                     Image = TeamSales;
                     RunObject = Page "ES Windows Logins";
                 }
                 action("Role Details")
                 {
                     Caption = 'Role Details';
                     Image = Components;
                     RunObject = Page "ES Role Details";
                 }
                 separator(Action1240520032)
                 {
                 }
                 action("Restore Points")
                 {
                     Caption = 'Restore Points';
                     Image = History;
                     RunObject = Page "ES Restore Points";
                 }
             }
             group("Field Level and Data Security")
             {
                 Caption = 'Field Level and Data Security';
                 action("User Security Setup")
                 {
                     Caption = 'User Security Setup';
                     RunObject = Page "ES User Security Setup";
                 }
                 action("Field Level and Data Security Group Members")
                 {
                     Caption = 'Field Level and Data Security Group Members';
                     RunObject = Page "ES FLADS Group Members";
                 }
                 action("Field Level Security Codes")
                 {
                     Caption = 'Field Level Security Codes';
                     Image = ListPage;
                     RunObject = Page "ES Field Level Security Codes";
                 }
                 action("Data Security Codes")
                 {
                     Caption = 'Data Security Codes';
                     Image = ListPage;
                     RunObject = Page "ES Data Security Codes";
                 }
                 separator(Action1240520102)
                 {
                 }
                 action("Source Table Setups")
                 {
                     Caption = 'Source Table Setups';
                     Image = Worksheet;
                     RunObject = Page "ES Source Table Setups";
                 }
                 separator(Action1240520105)
                 {
                 }
                 action(Action1240520107)
                 {
                     Caption = 'Relations';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                 }
                 action(Editable)
                 {
                     Caption = 'Editable';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                     RunPageView = WHERE (Type = CONST (Editable));
                 }
                 action(OnLookup)
                 {
                     Caption = 'OnLookup';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                     RunPageView = WHERE (Type = CONST (OnLookup));
                 }
                 action("Source Table")
                 {
                     Caption = 'Source Table';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                     RunPageView = WHERE (Type = CONST ("Source Table"));
                 }
                 action("Data Item")
                 {
                     Caption = 'Data Item';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                     RunPageView = WHERE (Type = CONST ("Data Item"));
                 }
                 action(Action1240520077)
                 {
                     Caption = 'PagePartID';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                     RunPageView = WHERE (Type = CONST (PagePartID));
                 }
                 action("Field Level and Data Security Changes")
                 {
                     Caption = 'Field Level and Data Security Changes';
                     Image = Track;
                     RunObject = Page "ES FLADS Relations";
                     RunPageView = WHERE (Type = CONST ("FLADS Change"));
                 }
                 action(Controls)
                 {
                     Caption = 'Controls';
                     Image = EntriesList;
                     RunObject = Page "ES FLADS Controls";
                 }
             }
             group(Live)
             {
                 Caption = 'Live';
                 action("Live Windows Logins")
                 {
                     Caption = 'Live Windows Logins';
                     Image = TeamSales;
                     RunObject = Page "ES Live Windows Logins";
                 }
                 action("Live Roles")
                 {
                     Caption = 'Live Roles';
                     Image = Components;
                     RunObject = Page "ES Live Roles";
                 }
                 action("Live Objects")
                 {
                     Caption = 'Live Objects';
                     Image = EntriesList;
                     RunObject = Page "ES Live Objects";
                 }
                 action("Live Object Informations")
                 {
                     Caption = 'Live Object Informations';
                     Image = EntriesList;
                     RunObject = Page "ES Live Object Informations";
                 }
                 separator(Action1240520038)
                 {
                 }
                 action("Live Companies")
                 {
                     Caption = 'Live Companies';
                     RunObject = Page "ES Live Companies";
                 }
                 action("Live Relations")
                 {
                     Caption = 'Live Relations';
                     Image = Track;
                     RunObject = Page "ES Live Relations";
                 }
                 action("Live Variables")
                 {
                     Caption = 'Live Variables';
                     Image = Track;
                     RunObject = Page "ES Live Variables";
                 }
                 action(Sessions)
                 {
                     Caption = 'Sessions';
                     RunObject = Page "ES Live Sessions";
                 }
                 action("License Permissions")
                 {
                     Caption = 'License Permissions';
                     Image = EntriesList;
                     RunObject = Page "ES License Permissions";
                 }
             }
         }
         area(processing)
         {
             separator(Tasks)
             {
                 Caption = 'Tasks';
                 IsHeader = true;
             }
             action("Publish Permissions")
             {
                 Caption = 'Publish Permissions';
                 Image = CreateInteraction;
                 RunObject = Page "ES Publish Permissions";
             }
             action("Update Summary Permissions")
             {
                 Caption = 'Update Summary Permissions';
                 Enabled = false;
                 Image = Refresh;
                 RunObject = Page "ES Update Summary Permissions";
                 Visible = false;
             }
             action("Launch Objects")
             {
                 Caption = 'Launch Objects';
                 Enabled = false;
                 Image = Start;
                 RunObject = Page "ES Launch Objects";
                 Visible = false;
             }
             action("Copy Data Between Companies")
             {
                 Caption = 'Copy Data Between Companies';
                 Image = CopyLedgerToBudget;
                 RunObject = Page "ES Copy Data Between Companies";
             }
             action("NAS Process Entries")
             {
                 Caption = 'NAS Process Entries';
                 Image = ExplodeBOM;
                 RunObject = Page "ES NAS Process Entries";
             }
             separator("Roles and Logins")
             {
                 Caption = 'Roles and Logins';
                 IsHeader = true;
             }
             action(Action1240520030)
             {
                 Caption = 'Logins';
                 Enabled = false;
                 Image = TeamSales;
                 RunObject = Page "ES Logins";
                 Visible = false;
             }
             action(Action1240520014)
             {
                 Caption = 'Role Groups';
                 Enabled = false;
                 Image = Components;
                 RunObject = Page "ES Role Groups";
                 Visible = false;
             }
             action(Action1240520018)
             {
                 Caption = 'Company Groups';
                 Enabled = false;
                 RunObject = Page "ES Company Groups";
                 Visible = false;
             }
             action(Action1240520026)
             {
                 Caption = 'Roles';
                 Enabled = false;
                 Image = Components;
                 RunObject = Page "ES Roles";
                 Visible = false;
             }
             separator(Action1240520003)
             {
                 Caption = 'Field Level and Data Security';
                 IsHeader = true;
             }
             action(Action1240520079)
             {
                 Caption = 'User Security Setup';
                 Enabled = false;
                 RunObject = Page "ES User Security Setup";
                 Visible = false;
             }
             action(Action1240520080)
             {
                 Caption = 'Field Level Security Codes';
                 Enabled = false;
                 Image = ListPage;
                 RunObject = Page "ES Field Level Security Codes";
                 Visible = false;
             }
             action(Action1240520081)
             {
                 Caption = 'Data Security Codes';
                 Enabled = false;
                 Image = ListPage;
                 RunObject = Page "ES Data Security Codes";
                 Visible = false;
             }
             separator("Where-used")
             {
                 Caption = 'Where-used';
                 IsHeader = true;
             }
             action("Object Where-used")
             {
                 Caption = 'Object Where-used';
                 Image = "Where-Used";
                 RunObject = Page "ES Object Where-used";
             }
             action("Role Where-used")
             {
                 Caption = 'Role Where-used';
                 Enabled = false;
                 Image = "Where-Used";
                 RunObject = Page "ES Role Where-used";
                 Visible = false;
             }
             action("Company Where-used")
             {
                 Caption = 'Company Where-used';
                 Enabled = false;
                 Image = "Where-Used";
                 RunObject = Page "ES Company Where-used";
                 Visible = false;
             }
             separator(Setup)
             {
                 Caption = 'Setup';
                 IsHeader = true;
             }
             action("Security Setup")
             {
                 Caption = 'Security Setup';
                 Image = Setup;
                 RunObject = Page "ES Security Setup";
             }
             action("Field Level and Data Security Setup")
             {
                 Caption = 'Field Level and Data Security Setup';
                 Image = Setup;
                 RunObject = Page "ES FLADS Setup";
             }
             action("Object Properties")
             {
                 Caption = 'Object Properties';
                 Image = EntriesList;
                 RunObject = Page "ES Object Properties";
             }
         }
     }
 } */
}
