table 76202 "Hist. Colegio - Adopciones Cab"
{

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(2; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(3; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));

            trigger OnValidate()
            begin
                Nivel.Get("Cod. Nivel");
                "Filtro Nivel" := Nivel."Filtros Combinaciones Niveles";
            end;
        }
        field(4; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));
        }
        field(5; Turno; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(6; "Nombre Colegio"; Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Cod. Colegio")));
            FieldClass = FlowField;
        }
        field(7; "Descripcion Nivel"; Text[100])
        {
            CalcFormula = Lookup("Nivel Educativo APS"."Descripción" WHERE("Código" = FIELD("Cod. Nivel")));
            FieldClass = FlowField;
        }
        field(8; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(9; "% Dto. Padres"; Decimal)
        {

            trigger OnValidate()
            begin
                if "% Dto. Padres" <> xRec."% Dto. Padres" then begin
                    if Confirm(Msg001, false) then begin
                        AdopcionesD.Reset;
                        AdopcionesD.SetRange("Cod. Colegio", "Cod. Colegio");
                        AdopcionesD.SetRange("Cod. Local", "Cod. Local");
                        //        AdopcionesD.SETRANGE("Cod. Nivel",gCodNivel);
                        AdopcionesD.SetRange("Cod. Turno", Turno);
                        AdopcionesD.SetRange("Cod. Promotor", "Cod. Promotor");
                        if AdopcionesD.FindSet(true) then
                            repeat
                                AdopcionesD."% Dto. Padres" := "% Dto. Padres";
                                AdopcionesD.Modify;
                            until AdopcionesD.Next = 0;
                    end;
                end;
            end;
        }
        field(10; "% Dto. Colegio"; Decimal)
        {

            trigger OnValidate()
            begin
                if "% Dto. Colegio" <> xRec."% Dto. Colegio" then begin
                    if Confirm(Msg001, false) then begin
                        AdopcionesD.Reset;
                        AdopcionesD.SetRange("Cod. Colegio", "Cod. Colegio");
                        AdopcionesD.SetRange("Cod. Local", "Cod. Local");
                        //        AdopcionesD.SETRANGE("Cod. Nivel",gCodNivel);
                        AdopcionesD.SetRange("Cod. Turno", Turno);
                        AdopcionesD.SetRange("Cod. Promotor", "Cod. Promotor");
                        if AdopcionesD.FindSet(true) then
                            repeat
                                AdopcionesD."% Dto. Colegio" := "% Dto. Colegio";
                                AdopcionesD.Modify;
                            until AdopcionesD.Next = 0;
                    end;
                end;
            end;
        }
        field(11; "% Dto. Docente"; Decimal)
        {

            trigger OnValidate()
            begin
                if "% Dto. Docente" <> xRec."% Dto. Docente" then begin
                    if Confirm(Msg001, false) then begin
                        AdopcionesD.Reset;
                        AdopcionesD.SetRange("Cod. Colegio", "Cod. Colegio");
                        AdopcionesD.SetRange("Cod. Local", "Cod. Local");
                        //        AdopcionesD.SETRANGE("Cod. Nivel",gCodNivel);
                        AdopcionesD.SetRange("Cod. Turno", Turno);
                        AdopcionesD.SetRange("Cod. Promotor", "Cod. Promotor");
                        if AdopcionesD.FindSet(true) then
                            repeat
                                AdopcionesD."% Dto. Docente" := "% Dto. Docente";
                                AdopcionesD.Modify;
                            until AdopcionesD.Next = 0;
                    end;
                end;
            end;
        }
        field(12; "% Dto. Feria Padres"; Decimal)
        {

            trigger OnValidate()
            begin
                if "% Dto. Feria Padres" <> xRec."% Dto. Feria Padres" then begin
                    if Confirm(Msg001, false) then begin
                        AdopcionesD.Reset;
                        AdopcionesD.SetRange("Cod. Colegio", "Cod. Colegio");
                        AdopcionesD.SetRange("Cod. Local", "Cod. Local");
                        //        AdopcionesD.SETRANGE("Cod. Nivel",gCodNivel);
                        AdopcionesD.SetRange("Cod. Turno", Turno);
                        AdopcionesD.SetRange("Cod. Promotor", "Cod. Promotor");
                        if AdopcionesD.FindSet(true) then
                            repeat
                                AdopcionesD."% Dto. Feria Padres" := "% Dto. Feria Padres";
                                AdopcionesD.Modify;
                            until AdopcionesD.Next = 0;
                    end;
                end;
            end;
        }
        field(13; "% Dto. Feria Colegio"; Decimal)
        {

            trigger OnValidate()
            begin
                if "% Dto. Feria Colegio" <> xRec."% Dto. Feria Colegio" then begin
                    if Confirm(Msg001, false) then begin
                        AdopcionesD.Reset;
                        AdopcionesD.SetRange("Cod. Colegio", "Cod. Colegio");
                        AdopcionesD.SetRange("Cod. Local", "Cod. Local");
                        //        AdopcionesD.SETRANGE("Cod. Nivel",gCodNivel);
                        AdopcionesD.SetRange("Cod. Turno", Turno);
                        AdopcionesD.SetRange("Cod. Promotor", "Cod. Promotor");
                        if AdopcionesD.FindSet(true) then
                            repeat
                                AdopcionesD."% Dto. Feria Colegio" := "% Dto. Feria Colegio";
                                AdopcionesD.Modify;
                            until AdopcionesD.Next = 0;
                    end;
                end;
            end;
        }
        field(14; Usuario; Code[20])
        {
        }
        field(15; Santillana; Boolean)
        {
        }
        field(16; "Cod. Editorial"; Code[20])
        {
            TableRelation = Editoras;
        }
        field(17; "Nombre editorial"; Text[100])
        {
            CalcFormula = Lookup(Editoras.Description WHERE(Code = FIELD("Cod. Editorial")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Filtro fecha"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(19; "Filtro Linea de negocio"; Code[20])
        {
        }
        field(20; "Filtro Grupo de Negocio"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Grupo de Negocio"));
        }
        field(21; "Filtro Sub Familia"; Code[20])
        {

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField("Cod. Dimension Sub Familia");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Sub Familia");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Validate("Filtro Sub Familia", DimVal.Code);
                end;

                Clear(DimForm);
            end;
        }
        field(22; "Filtro Serie"; Code[20])
        {
        }
        field(23; Adopcion; Option)
        {
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquest,Keep,Lost,Retired;
        }
        field(24; "Filtro Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";
        }
        field(25; Campana; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Cod. Promotor", Turno)
        {
            Clustered = true;
        }
        key(Key2; "Cod. Promotor", "Cod. Colegio")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Colegio", "Nombre Colegio", "Cod. Nivel", "Descripcion Nivel", "Cod. Promotor", "Nombre Promotor")
        {
        }
    }

    trigger OnDelete()
    begin
        AdopcionDet.Reset;
        AdopcionDet.SetRange("Cod. Colegio", "Cod. Colegio");
        AdopcionDet.SetRange("Cod. Local", "Cod. Local");
        AdopcionDet.SetRange("Cod. Nivel", "Cod. Nivel");
        AdopcionDet.SetRange("Cod. Turno", Turno);
        AdopcionDet.SetRange("Cod. Promotor", "Cod. Promotor");
        if AdopcionDet.FindFirst then
            Error(Err001);
    end;

    var
        ConfAPS: Record "Commercial Setup";
        Nivel: Record "Nivel Educativo APS";
        ColNiv: Record "Colegio - Nivel";
        Editora: Record Editoras;
        GradoCol: Record "Colegio - Grados";
        Item: Record Item;
        ProdEq: Record "Productos Equivalentes";
        AdopcionDet: Record "Colegio - Adopciones Detalle";
        Err001: Label 'You must delete the lines before delete this record';
        DimVal: Record "Dimension Value";
        AdopcionesD: Record "Colegio - Adopciones Detalle";
        DimForm: Page "Dimension Value List";
        Msg001: Label 'There''s a change in the discount, do you wish to update the lines?';
        Text001: Label 'Filling  #1########## @2@@@@@@@@@@@@@';
}

