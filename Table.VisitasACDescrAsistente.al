table 76310 "Visitas A/C - Descr. Asistente"
{

    fields
    {
        field(1; "No. Visita"; Code[20])
        {
        }
        field(2; Codigo; Code[20])
        {
            TableRelation = IF (Tipo = CONST (Nivel)) "Nivel Educativo APS"."Código"
            ELSE
            IF (Tipo = CONST (Especialidad)) "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Especialidades))
            ELSE
            IF (Tipo = CONST (Grado)) "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));

            trigger OnValidate()
            var
                Nivel: Record "Nivel Educativo APS";
                DA: Record "Datos auxiliares";
            begin

                if Codigo <> '' then begin
                    case Tipo of
                        Tipo::Nivel:
                            begin
                                Nivel.Get(Codigo);
                                Descripción := Nivel.Descripción;
                            end;
                        Tipo::Grado:
                            begin
                                DA.Reset;
                                DA.SetRange("Tipo registro", DA."Tipo registro"::Grados);
                                DA.SetRange(Codigo, Codigo);
                                DA.FindFirst;
                                Descripción := DA.Descripcion;
                            end;
                        Tipo::Especialidad:
                            begin
                                DA.Reset;
                                DA.SetRange("Tipo registro", DA."Tipo registro"::Especialidades);
                                DA.SetRange(Codigo, Codigo);
                                DA.FindFirst;
                                Descripción := DA.Descripcion;
                            end;
                    end;
                end
                else
                    Descripción := '';
            end;
        }
        field(3; "Descripción"; Text[80])
        {
        }
        field(4; "No. Asistentes"; Integer)
        {
        }
        field(5; Tipo; Option)
        {
            OptionCaption = 'Nivel,Grado,Especialidad';
            OptionMembers = Nivel,Grado,Especialidad;
        }
    }

    keys
    {
        key(Key1; "No. Visita", Tipo, Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

