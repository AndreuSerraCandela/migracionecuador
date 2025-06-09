table 76407 "Hist. Docente - Expos - Espec."
{
    Caption = 'Specialty';

    fields
    {
        field(1; "Tipo Registro"; Option)
        {
            OptionCaption = 'Teacher,Exhibitor';
            OptionMembers = Docente,Expositor;
        }
        field(2; "Cod. Docente/Expositor"; Code[20])
        {
            TableRelation = IF ("Tipo Registro" = CONST (Docente)) Docentes
            ELSE
            IF ("Tipo Registro" = CONST (Expositor)) "Expositores APS";

            trigger OnValidate()
            begin
                if "Tipo Registro" = 0 then begin
                    Docente.Get("Cod. Docente/Expositor");
                    "Nombre completo" := Docente."Full Name";
                end
                else begin
                    Expositor.Get("Cod. Docente/Expositor");
                    "Nombre completo" := Expositor.Name;
                end;
            end;
        }
        field(3; "Cod. especialidad"; Code[20])
        {
            Caption = 'Specialism code';
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Especialidades));

            trigger OnValidate()
            begin
                if "Cod. especialidad" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Especialidades);
                    DA.SetRange(Codigo, "Cod. especialidad");
                    DA.FindFirst;
                    "Descripcion especialidad" := DA.Descripcion;
                end;
            end;
        }
        field(4; "Nombre completo"; Text[60])
        {
            Caption = 'Full name';
        }
        field(5; "Descripcion especialidad"; Text[100])
        {
            Caption = 'Specialism description';
        }
        field(6; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo";
        }
        field(7; "Cod. grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));
        }
        field(8; Campana; Integer)
        {
            Caption = 'Campaign';
        }
    }

    keys
    {
        key(Key1; Campana, "Tipo Registro", "Cod. Docente/Expositor", "Cod. especialidad")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Docente: Record Docentes;
        Expositor: Record "Expositores APS";
        DA: Record "Datos auxiliares";
}

