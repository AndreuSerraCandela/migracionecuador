table 76999 "Import Version"
{
    DataCaptionFields = "Code", Description;
    /*     DrillDownPageID = 99003601;
        LookupPageID = 99003601; */

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "Description 2"; Text[100])
        {
        }
        field(5; Date; Date)
        {
        }
        field(6; "Basic Objects"; Boolean)
        {
            Editable = false;
        }
        field(10; "Last Import No."; Integer)
        {
            //CalcFormula = Max ("Object Imported"."Import No." WHERE ("Import Version Code" = FIELD (Code)));
            Editable = false;
            //FieldClass = FlowField;
        }
        field(11; "Import File Name"; Text[250])
        {
            Editable = false;
        }
        field(12; "Update Option"; Option)
        {
            Editable = false;
            InitValue = Replace;
            OptionMembers = Add,Replace;
        }
        field(13; "Import Date"; Date)
        {
            Editable = false;
        }
        field(15; "Import Duration"; Text[30])
        {
            Editable = false;
        }
        field(16; "No. of Objects"; Integer)
        {
            //CalcFormula = Count ("Object Imported" WHERE ("Import Version Code" = FIELD (Code)));
            Editable = false;
            //FieldClass = FlowField;
        }
        field(20; "STX File Name"; Text[250])
        {
            Editable = false;
        }
        field(21; "Date Expression"; Text[30])
        {
            Editable = false;
        }
        field(22; "Time Expression"; Text[30])
        {
            Editable = false;
        }
        field(23; "Modified  Expression"; Text[30])
        {
            Editable = false;
        }
        field(24; "Version List  Expression"; Text[30])
        {
            Editable = false;
            Enabled = true;
        }
        field(25; "Yes  Expression"; Text[30])
        {
            Editable = false;
        }
        field(26; "No  Expression"; Text[30])
        {
            Editable = false;
        }
        field(30; "Program Version Code"; Code[20])
        {
            Editable = false;
        }
        field(31; "Version No."; Integer)
        {
            Editable = false;
        }
        field(32; "New Version"; Boolean)
        {
            Editable = false;
        }
        field(33; "Base Version Code"; Code[20])
        {
            Editable = false;
        }
        field(34; "Import Completed"; Boolean)
        {
            Editable = false;
        }
        field(35; "FOB Version"; Option)
        {
            Editable = false;
            OptionMembers = "201";
        }
        field(36; "From Navision Client"; Boolean)
        {
        }
        field(37; "Filter Type"; Text[30])
        {
        }
        field(38; "Filter ID"; Text[30])
        {
        }
        field(39; "Filter Date"; Text[30])
        {
        }
        field(40; "Filter Time"; Text[30])
        {
        }
        field(41; "Filter Version List"; Text[30])
        {
        }
        field(42; "Filter Modified"; Option)
        {
            OptionMembers = " ",Yes,No;
        }
        field(43; "Type Expression"; Text[30])
        {
        }
        field(44; "ID Expression"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; "Version No.")
        {
            MaintainSIFTIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //fes mig NDTManagement.DeleteVersion(Rec);
    end;
}

