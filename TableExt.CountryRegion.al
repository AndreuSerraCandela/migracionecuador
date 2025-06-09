tableextension 50168 tableextension50168 extends "Country/Region"
{
    fields
    {
        field(50000; "Tiene Convenio"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Sujeto a Retencion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Codigo Pais ATS"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '#16511';
        }
        field(50003; "Reg. fiscal preferente/paraiso"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(75000; Bloqueado; Boolean)
        {
            Caption = 'Bloqueado';
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
    }
}

