table 76217 "Colegio - Cab. Jerarquia puest"
{

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact;

            trigger OnValidate()
            begin
                if "Cod. Colegio" <> '' then begin
                    Colegio.Get("Cod. Colegio");
                    "Nombre Colegio" := Colegio.Name;
                end
            end;
        }
        field(2; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));
        }
        field(3; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                  "Cod. Local" = FIELD ("Cod. Local"));
        }
        field(4; "Cod. Turno"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Turnos));

            trigger OnLookup()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::Turnos);
                Turnos.SetTableView(DA);
                Turnos.SetRecord(DA);
                Turnos.LookupMode(true);
                if Turnos.RunModal = ACTION::LookupOK then begin
                    Turnos.GetRecord(DA);
                    "Cod. Turno" := DA.Codigo;
                end;

                Clear(Turnos);
            end;
        }
        field(5; "Nombre Colegio"; Text[60])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Colegio: Record Contact;
        Empleado: Record Docentes;
        DA: Record "Datos auxiliares";
        Turnos: Page Turnos;
        Grados: Page Grados;
}

