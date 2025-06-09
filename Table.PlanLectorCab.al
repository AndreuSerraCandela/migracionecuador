table 76179 "Plan Lector Cab."
{

    fields
    {
        field(1; "Cod. Colegio"; Code[10])
        {
            TableRelation = Contact WHERE (Type = CONST (Company),
                                           "Tipo educacion" = CONST ('YES'));

            trigger OnValidate()
            var
                Colegio: Record Contact;
                DimVal: Record "Dimension Value";
                ConfAPS: Record "Commercial Setup";
            begin
                Colegio.SetRange(Colegio."No.", "Cod. Colegio");
                if Colegio.FindFirst then begin
                    "Nombre Colegio" := Colegio.Name;
                    Distrito := Colegio.Distritos;
                    "Cod. Delegacion" := Colegio.Región;
                    ConfAPS.Get;
                    ConfAPS.TestField("Cod. Dimension Delegacion");
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                    DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                    DimVal.SetRange(Code, Colegio.Región);
                    if DimVal.FindFirst then
                        "Descripción Delegacion" := DimVal.Name;


                end;
            end;
        }
        field(2; "Nombre Colegio"; Text[50])
        {
            Editable = false;
        }
        field(3; "Cod. Local"; Code[10])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));

            trigger OnValidate()
            var
                Local_Cont: Record "Contact Alt. Address";
            begin
                Local_Cont.SetRange(Code, "Cod. Local");
                if Local_Cont.FindFirst then
                    "Descripcion Local" := Local_Cont."Company Name";
            end;
        }
        field(4; "Descripcion Local"; Text[50])
        {
            Editable = false;
        }
        field(5; "Cod. Turno"; Code[10])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Turnos));

            trigger OnValidate()
            var
                DA: Record "Datos auxiliares";
            begin
                DA.SetRange("Tipo registro", DA."Tipo registro"::Turnos);
                if DA.FindFirst then
                    "Descripcion Turno" := DA.Descripcion;
            end;
        }
        field(6; "Descripcion Turno"; Text[30])
        {
            Editable = false;
        }
        field(7; Distrito; Text[30])
        {
            Editable = false;
        }
        field(8; "Cod. Delegacion"; Code[20])
        {
        }
        field(9; "Descripción Delegacion"; Text[50])
        {
        }
        field(50; "Campaña"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Campaña", "Cod. Colegio", "Cod. Local", "Cod. Turno")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    var
        Text001: Label 'You cannot rename a %1.';
    begin
        Error(Text001, TableCaption);
    end;
}

