table 76363 "Ranking CVM vertical"
{
    DrillDownPageID = "Promotores - Ppto Vtas";
    LookupPageID = "Promotores - Ppto Vtas";

    fields
    {
        field(1; "Cod. Docente"; Code[20])
        {
            NotBlank = true;
            TableRelation = Docentes;
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE (Type = CONST (Company));
        }
        field(3; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));
        }
        field(4; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));
        }
        field(5; "Cod. Grado"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));
        }
        field(6; "Cod. Turno"; Code[20])
        {
        }
        field(7; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
        field(8; "Cod. Producto"; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            var
                DefDim: Record "Default Dimension";
                ConfAPS: Record "Commercial Setup";
            begin
                ConfAPS.Get();
                if ConfAPS."Cod. Dimension Serie" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Serie");
                    if DefDim.FindFirst then
                        "Edicion Coleccion" := DefDim."Dimension Value Code";
                end;

                if ConfAPS."Cod. Dimension Lin. Negocio" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Lin. Negocio");
                    if DefDim.FindFirst then
                        "Linea de negocio" := DefDim."Dimension Value Code";
                end;

                if ConfAPS."Cod. Dimension Familia" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Familia");
                    if DefDim.FindFirst then
                        Familia := DefDim."Dimension Value Code";
                end;

                if ConfAPS."Cod. Dimension Sub Familia" <> '' then begin
                    DefDim.Reset;
                    DefDim.SetRange("Table ID", 27);
                    DefDim.SetRange("No.", "Cod. Producto");
                    DefDim.SetRange("Dimension Code", ConfAPS."Cod. Dimension Sub Familia");
                    if DefDim.FindFirst then
                        "Sub Familia" := DefDim."Dimension Value Code";
                end;
            end;
        }
        field(9; "Linea de negocio"; Code[20])
        {
        }
        field(10; Familia; Code[20])
        {
        }
        field(11; "Sub Familia"; Code[20])
        {
        }
        field(12; Serie; Code[20])
        {
        }
        field(88; "Descripción producto"; Text[100])
        {
        }
        field(89; "Edicion Coleccion"; Code[20])
        {
        }
        field(90; Adopcion; Option)
        {
            Caption = 'Adopción';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(100; CDS; Option)
        {
            Caption = 'CDS';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(110; Alumnado; Decimal)
        {
            CalcFormula = Sum ("Colegio - Adopciones Detalle"."Adopcion Real" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                                    "Cod. Local" = FIELD ("Cod. Local"),
                                                                                    "Cod. Nivel" = FIELD ("Cod. Nivel"),
                                                                                    "Cod. Grado" = FIELD ("Cod. Grado"),
                                                                                    "Cod. Producto" = FIELD ("Cod. Producto"),
                                                                                    "Linea de negocio" = FIELD ("Linea de negocio")));
            Caption = 'Alumnado';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Cod. Docente", "Cod. Colegio", "Cod. Local", "Cod. Producto", "Cod. Grado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

