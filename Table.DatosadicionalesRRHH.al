table 76154 "Datos adicionales RRHH"
{
    Caption = 'Datos adicionales';
    DataCaptionFields = "Tipo registro";
    DrillDownPageID = "Datos adicionales";
    LookupPageID = "Datos adicionales";

    fields
    {
        field(1; "Tipo registro"; Option)
        {
            Caption = 'Record type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Benefit,ARS,AFP,Blood type,Driver''s licence category,Employee''s category,Hobby,Job profile,Loan type,Training type,Knowledge area,Classroom,Category';
            OptionMembers = Beneficio,ARS,AFP,"Tipo de Sangre","Categoría de Licencia","Categoría de Empleado",Pasatiempo,"Requisitos puestos","Tipo de préstamo","Tipo Entrenamiento","Area curricular","Salón","Categoría";
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Tipo registro", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Descripcion)
        {
        }
    }
}

