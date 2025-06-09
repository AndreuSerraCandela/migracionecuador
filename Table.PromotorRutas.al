table 76299 "Promotor - Rutas"
{
    DrillDownPageID = "Promotor - Rutas";
    LookupPageID = "Promotor - Rutas";

    fields
    {
        field(1; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
        field(2; "Cod. Ruta"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Rutas));

            trigger OnValidate()
            begin
                if "Cod. Ruta" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Rutas);
                    DA.SetRange(Codigo, "Cod. Ruta");
                    DA.FindFirst;
                    "Descripcion Ruta" := DA.Descripcion;
                end;
            end;
        }
        field(3; "Cod. Zona"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Zonas));

            trigger OnValidate()
            begin
                if "Cod. Zona" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Zonas);
                    DA.SetRange(Codigo, "Cod. Zona");
                    DA.FindFirst;
                    "Descripcion zona" := DA.Descripcion;
                end;
            end;
        }
        field(4; "Nombre Promotor"; Text[100])
        {
            CalcFormula = Lookup ("Salesperson/Purchaser".Name WHERE (Code = FIELD ("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(5; "Descripcion Ruta"; Text[100])
        {
        }
        field(6; "Cod. Supervisor"; Code[20])
        {
            Caption = 'Superviser code';
            TableRelation = "Salesperson/Purchaser".Code WHERE (Tipo = CONST (Supervisor));
        }
        field(7; "Nombre Supervisor"; Text[100])
        {
            CalcFormula = Lookup ("Salesperson/Purchaser".Name WHERE (Code = FIELD ("Cod. Supervisor")));
            FieldClass = FlowField;
        }
        field(8; "Descripcion zona"; Text[100])
        {
        }
        field(9; Delegacion; Code[20])
        {

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Validate(Delegacion, DimVal.Code);
                end;

                Clear(DimForm);
            end;

            trigger OnValidate()
            begin
                if Delegacion <> '' then begin
                    ConfAPS.Get();
                    ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                    DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                    DimVal.SetRange(Code, Delegacion);
                    DimVal.FindFirst;
                    "Descripcion Delegacion" := DimVal.Name;
                end;
            end;
        }
        field(10; "Descripcion Delegacion"; Text[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Cod. Promotor", "Cod. Ruta")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DA: Record "Datos auxiliares";
        ConfAPS: Record "Commercial Setup";
        DimVal: Record "Dimension Value";
        DimForm: Page "Dimension Value List";
}

