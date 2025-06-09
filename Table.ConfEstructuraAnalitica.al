table 75009 "Conf. Estructura Analitica"
{
    // El objetivo de esta tabla es poder realizar una serie de configuración de valores a partir de la tabla Estructura Analitica


    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(10; Codigo; Code[21])
        {
            Caption = 'Código';
            TableRelation = "Estructura Analitica";
        }
        field(11; Nivel; Integer)
        {
            CalcFormula = Lookup("Estructura Analitica".Nivel WHERE(Codigo = FIELD(Codigo)));
            Caption = 'Nivel';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; Descripcion; Text[100])
        {
            CalcFormula = Lookup("Estructura Analitica".Descripcion WHERE(Codigo = FIELD(Codigo)));
            Caption = 'Descripción';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Id Field"; Integer)
        {
            BlankZero = true;
            Caption = 'Campo';
            TableRelation = "Filtro Campo Buffer"."Field No" WHERE("Table Id" = CONST(27),
                                                                    "Field No" = FILTER(56022));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Id Field" <> 0 then begin
                    // De momento limitados los ids de campos
                    if not ("Id Field" in [56022]) then
                        Error(Text001, "Id Field");
                end;
                pFiltrCmp.TestCampo(27, "Id Field");
                Valor := '';
            end;
        }
        field(101; FieldName; Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = CONST(27),
                                                              "No." = FIELD("Id Field")));
            Caption = 'Nombre Campo';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; Valor; Text[30])
        {
            TableRelation = "Filtro Valor Campo Buffer".Value WHERE("Table Id" = CONST(27),
                                                                     "Field No" = FIELD("Id Field"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CompDupl;
    end;

    trigger OnModify()
    begin
        CompDupl;
    end;

    var
        pFiltrCmp: Page "Filtro Valor Campo";
        Text001: Label 'El campo %1 No está permitido';
        Text002: Label 'Ya existe el registro';


    procedure CompDupl()
    var
        lrConfAn: Record "Conf. Estructura Analitica";
    begin
        // CompDupl
        // Comprueba Duplicidad

        Clear(lrConfAn);
        lrConfAn.SetRange(Codigo, Codigo);
        lrConfAn.SetRange("Id Field", "Id Field");
        lrConfAn.SetFilter(Id, '<>%1', Id);
        if lrConfAn.FindFirst then
            Error(Text002);
    end;
}

