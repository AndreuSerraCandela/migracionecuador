table 76262 "Libros Competencia"
{

    fields
    {
        field(1; "Cod. Editorial"; Code[20])
        {
        }
        field(2; "Cod. Libro"; Code[20])
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Nivel; Code[20])
        {
            Caption = 'Adresse 2';
            NotBlank = true;
            TableRelation = "Nivel Educativo APS";
        }
        field(5; "Cod. Grado"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Grados));

            trigger OnValidate()
            begin
                if "Cod. Grado" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Grados);
                    DA.SetRange(Codigo, "Cod. Grado");
                    DA.FindFirst;
                end;
            end;
        }
        field(6; "Grupo de Negocio"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Grupo de Negocio"));

            trigger OnValidate()
            begin
                if "Cod. Grado" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Grupo de Negocio");
                    DA.SetRange(Codigo, "Grupo de Negocio");
                    DA.FindFirst;
                end;
            end;
        }
        field(7; "Cod. Libro Santillana"; Code[20])
        {
            Caption = 'Code de territoire';
            TableRelation = Item;
        }
        field(8; "Description Santillana"; Text[100])
        {
            CalcFormula = Lookup (Item.Description WHERE ("No." = FIELD ("Cod. Libro Santillana")));
            Caption = 'Code pays/région';
            FieldClass = FlowField;
        }
        field(9; "Nombre Editorial"; Text[60])
        {
            Caption = 'Code postal';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; Precio; Decimal)
        {
        }
        field(11; "Carga horaria"; Code[20])
        {
            TableRelation = "Carga Horaria";
        }
        field(12; "Tipo Ingles"; Option)
        {
            OptionCaption = ' ,USA,England';
            OptionMembers = " ",USA,England;
        }
        field(13; "Año Edición"; Date)
        {
        }
        field(14; "Año Uso"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Editorial", "Cod. Libro", Nivel)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
        DA: Record "Datos auxiliares";
}

