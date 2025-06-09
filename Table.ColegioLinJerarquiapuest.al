table 76329 "Colegio - Lin. Jerarquia puest"
{
    DrillDownPageID = "Lista de Personal Colegio";
    LookupPageID = "Lista de Personal Colegio";

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
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
        }
        field(5; "Cod. Cargo"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Puestos de trabajo"));

            trigger OnLookup()
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                Cargo.SetTableView(DA);
                Cargo.SetRecord(DA);
                Cargo.LookupMode(true);
                if Cargo.RunModal = ACTION::LookupOK then begin
                    Cargo.GetRecord(DA);
                    "Cod. Cargo" := DA.Codigo;
                    Empleado.Get("Cod. Empleado");
                    if "Cod. Cargo" <> Empleado."Job Type Code" then begin
                        Empleado.Validate(Empleado."Job Type Code", "Cod. Cargo");
                        Empleado.Modify;
                    end;
                end;

                Clear(Cargo);
            end;

            trigger OnValidate()
            begin
                if "Cod. Cargo" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, "Cod. Cargo");
                    DA.FindFirst;

                    "Descripcion Cargo" := DA.Descripcion;

                end
            end;
        }
        field(6; "Cod. Empleado"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Docentes"."Cod. Docente" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));

            trigger OnValidate()
            begin
                if "Cod. Empleado" <> '' then begin
                    Empleado.Get("Cod. Empleado");
                    "Nombre Empleado" := Empleado."Full Name";
                    Validate("Cod. Cargo", Empleado."Job Type Code");
                end;
            end;
        }
        field(7; "Nombre Colegio"; Text[100])
        {
        }
        field(8; "Descripcion Cargo"; Text[100])
        {
        }
        field(9; "Nombre Empleado"; Text[60])
        {
            Editable = false;
        }
        field(10; Seleccionar; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Cod. Local", "Cod. Nivel", "Cod. Turno", "Cod. Cargo", "Cod. Empleado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Colegio: Record Contact;
        Nivel: Record "Colegio - Nivel";
        Turno: Record "Clientes Relacionados";
        Empleado: Record Docentes;
        DA: Record "Datos auxiliares";
        Cargo: Page "Lista Puestos";
}

