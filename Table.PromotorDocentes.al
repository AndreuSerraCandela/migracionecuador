table 76127 "Promotor - Docentes"
{
    DrillDownPageID = "Canales de ventas";
    LookupPageID = "Canales de ventas";

    fields
    {
        field(1; "Codigo Docente"; Code[20])
        {
            TableRelation = Docentes;
        }
        field(2; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(3; "Nombre Docente"; Text[70])
        {
            CalcFormula = Lookup(Docentes."Full Name" WHERE("No." = FIELD("Codigo Docente")));
            FieldClass = FlowField;
        }
        field(4; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(5; "Nivel decision"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Nivel de decisión"));

            trigger OnValidate()
            begin
                if "Nivel decision" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Nivel de decisión");
                    DA.SetRange(Codigo, "Nivel decision");
                    DA.FindFirst;
                end;
            end;
        }
        field(6; "Cod. Cargo"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Puestos de trabajo"));

            trigger OnValidate()
            begin
                if "Cod. Cargo" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, "Cod. Cargo");
                    DA.FindFirst;
                    "Descripcion Cargo" := DA.Descripcion;
                end;
            end;
        }
        field(7; "Descripcion Cargo"; Text[60])
        {
        }
    }

    keys
    {
        key(Key1; "Codigo Docente", "Cod. Promotor")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Promotor", "Codigo Docente")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DA: Record "Datos auxiliares";
        ColNiv: Record "Colegio - Nivel";
        NivelE: Record "Nivel Educativo APS";
        PromRuta: Record "Promotor - Rutas";
        Promotor: Record "Salesperson/Purchaser";
        Docente: Record Docentes;
        Cargo: Page "Lista Puestos";
}

