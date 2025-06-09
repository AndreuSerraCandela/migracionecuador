xmlport 55017 "Import/Export Permissions asd"
{
    // test

    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Permission; "Expanded Permission") //Permission)
            {
                AutoUpdate = true;
                XmlName = 'Permission';
                fieldelement(RoleID; Permission."Role ID")
                {
                }
                fieldelement(RoleName; Permission."Role Name")
                {
                }
                fieldelement(ObjectType; Permission."Object Type")
                {
                }
                fieldelement(ObjectID; Permission."Object ID")
                {
                }
                fieldelement(ObjectName; Permission."Object Name")
                {
                }
                fieldelement(ReadPermission; Permission."Read Permission")
                {
                }
                fieldelement(InsertPermission; Permission."Insert Permission")
                {
                }
                fieldelement(ModifyPermission; Permission."Modify Permission")
                {
                }
                fieldelement(DeletePermission; Permission."Delete Permission")
                {
                }
                fieldelement(ExecutePermission; Permission."Execute Permission")
                {
                }
                fieldelement(SecurityFilter; Permission."Security Filter")
                {
                }

                trigger OnAfterInitRecord()
                begin
                    Permission."Read Permission" := Permission."Read Permission"::" ";
                    Permission."Insert Permission" := Permission."Insert Permission"::" ";
                    Permission."Modify Permission" := Permission."Modify Permission"::" ";
                    Permission."Delete Permission" := Permission."Delete Permission"::" ";
                    Permission."Execute Permission" := Permission."Execute Permission"::" ";
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

