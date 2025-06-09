table 76112 "Beneficios laborales"
{
    Caption = 'Beneficios cargos';
    DrillDownPageID = "Beneficios puestos laborales";
    LookupPageID = "Beneficios puestos laborales";

    fields
    {
        field(2; "Tipo Beneficio"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Income,Others';
            OptionMembers = Ingresos,Otro;
        }
        field(3; Codigo; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF ("Tipo Beneficio" = CONST (Ingresos)) "Conceptos salariales".Codigo WHERE ("Tipo concepto" = CONST (Ingresos))
            ELSE
            IF ("Tipo Beneficio" = CONST (Otro)) "Datos adicionales RRHH".Code WHERE ("Tipo registro" = CONST (Beneficio));

            trigger OnValidate()
            begin
                if "Tipo Beneficio" = 0 then //Ingresos
                    begin
                    if Conceptossalariales.Get(Codigo) then
                        Descripcion := Conceptossalariales.Descripcion
                    else
                        Descripcion := '';
                end
                else begin
                    if DatosadicionalesRRHH.Get(0, Codigo) then
                        Descripcion := DatosadicionalesRRHH.Descripcion
                    else
                        Descripcion := '';
                end;
            end;
        }
        field(4; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Tipo Beneficio", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Tipo Beneficio", Codigo, Descripcion)
        {
        }
    }

    var
        Conceptossalariales: Record "Conceptos salariales";
        DatosadicionalesRRHH: Record "Datos adicionales RRHH";
}

