tableextension 50098 tableextension50098 extends "Cause of Absence"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(76060; "Dias laborables"; Boolean)
        {
            Caption = 'Working days';
            DataClassification = ToBeClassified;
        }
        field(76049; "Cod. concepto salarial"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Conceptos salariales".Codigo;
        }
        field(76031; "Tipo de novedad TSS"; Option)
        {
            Caption = 'TSS leaves types';
            DataClassification = ToBeClassified;
            OptionCaption = ',Vacation,Voluntary License,Maternity,Disability';
            OptionMembers = " ",Vacaciones,"Licencia Voluntaria","Lic. por Maternidad","Lic. por Discapacidad";
        }
        field(76053; Publish; Boolean)
        {
            Caption = 'Publish';
            DataClassification = ToBeClassified;
        }
        field(76075; "Descripcion APP"; Text[30])
        {
            Caption = 'APP description';
            DataClassification = ToBeClassified;
        }
        field(76001; "Maximo de dias"; Integer)
        {
            Caption = 'Top days allowed';
            DataClassification = ToBeClassified;
        }
    }
}

