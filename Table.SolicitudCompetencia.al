table 76332 "Solicitud - Competencia"
{

    fields
    {
        field(1; "No. Solicitud"; Code[20])
        {
        }
        field(2; "Cod. Editorial"; Code[20])
        {
            TableRelation = Editoras;

            trigger OnValidate()
            var
                rEditoriales: Record Editoras;
            begin
                if rEditoriales.Get("Cod. Editorial") then
                    "Nombre Editorial" := rEditoriales.Description;
            end;
        }
        field(3; "Cod. Libro"; Code[20])
        {

            trigger OnLookup()
            begin
                Libros;
            end;

            trigger OnValidate()
            var
                LibComp: Record "Libros Competencia";
                Err001: Label 'El libro introducido no existe.';
            begin
                if "Cod. Libro" <> '' then begin
                    if "Cod. Editorial" <> '' then
                        LibComp.SetRange("Cod. Editorial", "Cod. Editorial");
                    LibComp.SetRange(LibComp."Cod. Libro", "Cod. Libro");
                    if not LibComp.FindFirst then
                        Error(Err001);
                end;
            end;
        }
        field(4; Description; Text[100])
        {
        }
        field(5; Nivel; Code[20])
        {
            Caption = 'Adresse 2';
            NotBlank = true;
            TableRelation = "Nivel Educativo APS";
        }
        field(6; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Grados));
        }
        field(7; "Grupo de Negocio"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Grupo de Negocio"));
        }
        field(8; "Cod. Libro Santillana"; Code[20])
        {
            Caption = 'Code de territoire';
            TableRelation = Item;
        }
        field(9; "Description Santillana"; Text[100])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Cod. Libro Santillana")));
            Caption = 'Code pays/région';
            FieldClass = FlowField;
        }
        field(10; "Nombre Editorial"; Text[60])
        {
            Caption = 'Code postal';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11; Precio; Decimal)
        {
        }
        field(12; "Carga horaria"; Code[20])
        {
            TableRelation = "Carga Horaria";
        }
        field(13; "Tipo Ingles"; Option)
        {
            OptionCaption = ' ,USA,England';
            OptionMembers = " ",USA,England;
        }
        field(14; "Horas a la semana"; Decimal)
        {
        }
        field(15; "Año Adopción"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No. Solicitud", "Cod. Editorial", "Cod. Libro")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure Libros()
    var
        rLib: Record "Libros Competencia";
        fLib: Page "Libros Competencia";
    begin

        if "Cod. Editorial" <> '' then
            rLib.SetRange("Cod. Editorial", "Cod. Editorial");
        fLib.SetTableView(rLib);
        fLib.LookupMode(true);
        if fLib.RunModal = ACTION::LookupOK then begin
            fLib.GetRecord(rLib);
            "Cod. Editorial" := rLib."Cod. Editorial";
            "Cod. Libro" := rLib."Cod. Libro";
            Nivel := rLib.Nivel;
            Description := rLib.Description;
            "Cod. Grado" := rLib."Cod. Grado";
            "Carga horaria" := rLib."Carga horaria";
            "Tipo Ingles" := rLib."Tipo Ingles";
            Insert;
        end;
    end;
}

