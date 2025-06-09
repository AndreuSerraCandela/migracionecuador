table 76308 "Colegio - Adopciones compet."
{
    DrillDownPageID = "Colegio - Adopciones Detalles";
    LookupPageID = "Colegio - Adopciones Detalles";

    fields
    {
        field(1; "Cod. Editorial"; Code[20])
        {
            NotBlank = true;
            TableRelation = Editoras;

            trigger OnValidate()
            begin
                /*
                IF Adopcion <> 0 THEN
                   BEGIN
                    Editora.GET("Cod. Editorial");
                    IF xRec."Cod. Editorial" <> "Cod. Editorial" THEN
                       Adopcion := 0;
                   END;
                */

            end;
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(3; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(4; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));
        }
        field(5; "Cod. Grado"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Grados"."Cod. Grado" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                   "Cod. Nivel" = FIELD("Cod. Nivel"),
                                                                   "Cod. Turno" = FIELD("Cod. Turno"));

            trigger OnValidate()
            begin
                /*
                IF "Cod. Grado" <> '' THEN
                   BEGIN
                    GradoCol.RESET;
                    GradoCol.SETRANGE("Cod. Colegio","Cod. Colegio");
                    GradoCol.SETRANGE("Cod. Local","Cod. Local");
                    GradoCol.SETRANGE("Cod. Nivel","Cod. Nivel");
                    GradoCol.SETRANGE("Cod. Grado","Cod. Grado");
                    GradoCol.SETRANGE("Cod. Turno","Cod. Turno");
                    IF GradoCol.FINDFIRST THEN
                //       BEGIN
                       "Cantidad Alumnos" := GradoCol."Cantidad Alumnos";
                //       END;
                   END;
                */

            end;
        }
        field(6; "Cod. Turno"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(7; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));
        }
        field(8; "Cod. Producto"; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                /*
                IF "Cod. Producto" <> '' THEN
                   BEGIN
                    ConfAPS.GET();
                    Item.GET("Cod. Producto");
                    "Descripcion producto" := Item.Description;
                    IF ProdEq.GET("Cod. Producto") THEN
                       BEGIN
                        "Cod. Equiv. Santillana" := ProdEq."Cod. Producto Anterior";
                        "Descripcion Equiv. Santillana" := ProdEq."Nombre Producto Anterior";
                       END;
                    IF ConfAPS."Cod. Dimension Lin. Negocio" <> '' THEN
                       BEGIN
                        DefDim.RESET;
                        DefDim.SETRANGE("Table ID",27);
                        DefDim.SETRANGE("No.","Cod. Producto");
                        DefDim.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Lin. Negocio");
                        IF DefDim.FINDFIRST THEN
                           "Linea de negocio" := DefDim."Dimension Value Code";
                       END;
                    IF ConfAPS."Cod. Dimension Familia" <> '' THEN
                       BEGIN
                        DefDim.RESET;
                        DefDim.SETRANGE("Table ID",27);
                        DefDim.SETRANGE("No.","Cod. Producto");
                        DefDim.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Familia");
                        IF DefDim.FINDFIRST THEN
                           Familia := DefDim."Dimension Value Code";
                       END;
                    IF ConfAPS."Cod. Dimension Sub Familia" <> '' THEN
                       BEGIN
                        DefDim.RESET;
                        DefDim.SETRANGE("Table ID",27);
                        DefDim.SETRANGE("No.","Cod. Producto");
                        DefDim.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Sub Familia");
                        IF DefDim.FINDFIRST THEN
                           "Sub Familia" := DefDim."Dimension Value Code";
                       END;
                    IF ConfAPS."Cod. Dimension Serie" <> '' THEN
                       BEGIN
                        DefDim.RESET;
                        DefDim.SETRANGE("Table ID",27);
                        DefDim.SETRANGE("No.","Cod. Producto");
                        DefDim.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Serie");
                        IF DefDim.FINDFIRST THEN
                           Serie := DefDim."Dimension Value Code";
                       END;
                   END;
                */

            end;
        }
        field(9; Seccion; Code[20])
        {
            NotBlank = true;
        }
        field(10; "Cod. Equiv. Santillana"; Code[20])
        {
            TableRelation = "Productos Equivalentes"."Cod. Producto Anterior" WHERE("Cod. Producto" = FIELD("Cod. Producto"));
        }
        field(11; "Descripcion Equiv. Santillana"; Text[100])
        {
        }
        field(12; "Nombre Editorial"; Text[100])
        {
            CalcFormula = Lookup(Editoras.Description WHERE(Code = FIELD("Cod. Editorial")));
            FieldClass = FlowField;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(13; "Descripcion producto"; Text[100])
        {
        }
        field(14; "Nombre Colegio"; Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Cod. Colegio")));
            FieldClass = FlowField;
        }
        field(15; "Descripcion Nivel"; Text[100])
        {
            CalcFormula = Lookup("Nivel Educativo APS"."Descripción" WHERE("Código" = FIELD("Cod. Nivel")));
            FieldClass = FlowField;
        }
        field(16; "Descripcion Grado"; Text[100])
        {
        }
        field(17; "Fecha Adopcion"; Date)
        {
        }
        field(18; "Cantidad Alumnos"; Decimal)
        {
            CalcFormula = Lookup("Colegio - Adopciones Detalle"."Cantidad Alumnos" WHERE("Cod. Editorial" = FIELD("Cod. Editorial"),
                                                                                          "Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                                          "Cod. Local" = FIELD("Cod. Local"),
                                                                                          "Cod. Nivel" = FIELD("Cod. Nivel"),
                                                                                          "Cod. Grado" = FIELD("Cod. Grado"),
                                                                                          "Cod. Promotor" = FIELD("Cod. Promotor"),
                                                                                          "Cod. Producto" = FIELD("Cod. Producto")));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(19; "% Dto. Padres"; Decimal)
        {
        }
        field(20; "% Dto. Colegio"; Decimal)
        {
        }
        field(21; "% Dto. Docente"; Decimal)
        {
        }
        field(22; "% Dto. Feria Padres"; Decimal)
        {
        }
        field(23; "% Dto. Feria Colegio"; Decimal)
        {
        }
        field(24; "Cod. Motivo perdida adopcion"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Motivos Perdida"));

            trigger OnValidate()
            begin
                /*
                DA.RESET;
                DA.SETRANGE("Tipo registro",DA."Tipo registro"::"Motivos Perdida");
                DA.SETRANGE(Codigo,"Cod. Motivo perdida adopcion");
                DA.FINDFIRST;
                "Motivo perdida adopcion" := DA.Descripcion;
                */

            end;
        }
        field(27; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(28; Adopcion; Option)
        {
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;

            trigger OnValidate()
            begin
                /*
                Editora.SETRANGE(Santillana,TRUE);
                Editora.FINDFIRST;
                
                GradoCol.GET("Cod. Colegio","Cod. Nivel","Cod. Turno","Cod. Grado",Seccion);
                GradoCol.TESTFIELD("Cantidad Alumnos");
                IF "Cantidad Alumnos" = 0 THEN
                   "Cantidad Alumnos" := GradoCol."Cantidad Alumnos";
                
                Item.GET("Cod. Producto");
                
                CASE Adopcion OF
                  1: //Conquista
                   BEGIN
                    "Cod. Editorial" := Editora.Code;
                    "Adopcion Real" := ROUND("Cantidad Alumnos" - ("Cantidad Alumnos" * Item."% Castigo Conquista" /100),1);
                   END;
                  2: //Mantener
                   BEGIN
                    "Cod. Editorial" := Editora.Code;
                    "Adopcion Real" := ROUND("Cantidad Alumnos" - ("Cantidad Alumnos"* Item."% Castigo Mantenimiento" / 100),1);
                   END;
                  3: //Perdida
                   BEGIN
                    "Adopcion Real" := ROUND("Cantidad Alumnos" - ("Cantidad Alumnos"* Item."% Castigo Perdida" / 100),1);
                   END;
                ELSE
                  CLEAR("Cod. Editorial");
                END;
                
                IF xRec.Adopcion <> Rec.Adopcion THEN
                   BEGIN
                    IF ColegioAdopciones2.FINDLAST THEN;
                    "Fecha Ult. Modificacion" := TODAY;
                    ColegioAdopciones.INIT;
                    ColegioAdopciones.TRANSFERFIELDS(Rec);
                    ColegioAdopciones.Secuencia := ColegioAdopciones2.Secuencia +1;
                    ColegioAdopciones.INSERT;
                    MODIFY;
                   END;
                */

            end;
        }
        field(29; "Adopcion anterior"; Option)
        {
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(30; Santillana; Boolean)
        {
        }
        field(31; Usuario; Code[20])
        {
        }
        field(32; "Ano adopcion"; Integer)
        {
            Caption = 'Year of decition';
        }
        field(33; "Linea de negocio"; Code[20])
        {

            trigger OnLookup()
            begin
                /*
                ConfAPS.GET();
                ConfAPS.TESTFIELD("Cod. Dimension Lin. Negocio");
                
                DimVal.RESET;
                DimVal.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Lin. Negocio");
                DimVal.SETRANGE("Dimension Value Type",DimVal."Dimension Value Type"::Standard);
                DimForm.SETTABLEVIEW(DimVal);
                DimForm.SETRECORD(DimVal);
                DimForm.LOOKUPMODE(TRUE);
                IF DimForm.RUNMODAL = ACTION::LookupOK THEN
                   BEGIN
                    DimForm.GETRECORD(DimVal);
                    "Linea de negocio" := DimVal.Code;
                   END;
                
                CLEAR(DimForm);
                */

            end;
        }
        field(34; Familia; Code[20])
        {

            trigger OnLookup()
            begin
                /*
                ConfAPS.GET();
                ConfAPS.TESTFIELD("Cod. Dimension Familia");
                DimVal.RESET;
                DimVal.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Familia");
                DimVal.SETRANGE("Dimension Value Type",DimVal."Dimension Value Type"::Standard);
                DimForm.SETTABLEVIEW(DimVal);
                DimForm.SETRECORD(DimVal);
                DimForm.LOOKUPMODE(TRUE);
                IF DimForm.RUNMODAL = ACTION::LookupOK THEN
                   BEGIN
                    DimForm.GETRECORD(DimVal);
                    Familia := DimVal.Code;
                   END;
                
                CLEAR(DimForm);
                */

            end;
        }
        field(35; "Sub Familia"; Code[20])
        {

            trigger OnLookup()
            begin
                /*
                ConfAPS.GET();
                ConfAPS.TESTFIELD("Cod. Dimension Sub Familia");
                DimVal.RESET;
                DimVal.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Sub Familia");
                DimVal.SETRANGE("Dimension Value Type",DimVal."Dimension Value Type"::Standard);
                DimForm.SETTABLEVIEW(DimVal);
                DimForm.SETRECORD(DimVal);
                DimForm.LOOKUPMODE(TRUE);
                IF DimForm.RUNMODAL = ACTION::LookupOK THEN
                   BEGIN
                    DimForm.GETRECORD(DimVal);
                    "Sub Familia" := DimVal.Code;
                   END;
                
                CLEAR(DimForm);
                */

            end;
        }
        field(36; Serie; Code[20])
        {

            trigger OnLookup()
            begin
                /*
                ConfAPS.GET();
                ConfAPS.TESTFIELD("Cod. Dimension Serie");
                DimVal.RESET;
                DimVal.SETRANGE("Dimension Code",ConfAPS."Cod. Dimension Serie");
                DimVal.SETRANGE("Dimension Value Type",DimVal."Dimension Value Type"::Standard);
                DimForm.SETTABLEVIEW(DimVal);
                DimForm.SETRECORD(DimVal);
                DimForm.LOOKUPMODE(TRUE);
                IF DimForm.RUNMODAL = ACTION::LookupOK THEN
                   BEGIN
                    DimForm.GETRECORD(DimVal);
                    Serie := DimVal.Code;
                   END;
                
                CLEAR(DimForm);
                */

            end;
        }
        field(37; "Fecha Ult. Modificacion"; Date)
        {
        }
        field(38; "Adopcion Real"; Integer)
        {
        }
        field(39; "Motivo perdida adopcion"; Text[60])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Motivos Perdida"));

            trigger OnValidate()
            begin
                /*
                DA.RESET;
                DA.SETRANGE("Tipo registro",DA."Tipo registro"::"Motivos Perdida");
                DA.SETRANGE(Codigo,"Cod. Motivo perdida adopcion");
                DA.FINDFIRST;
                */

            end;
        }
        field(41; "Cod. Producto Editora"; Code[20])
        {
            TableRelation = "Libros Competencia"."Cod. Libro" WHERE("Cod. Editorial" = FIELD("Cod. Editorial"),
                                                                     Nivel = FIELD("Cod. Nivel"));

            trigger OnValidate()
            begin
                if "Cod. Producto Editora" <> '' then begin
                    ProdEdit.Get("Cod. Editorial", "Cod. Producto Editora", "Cod. Nivel");
                    "Nombre Producto Editora" := ProdEdit.Description;
                end;
            end;
        }
        field(42; "Nombre Producto Editora"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Colegio", "Cod. Producto", "Cod. Editorial", "Cod. Producto Editora", "Cod. Nivel")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Colegio", "Cod. Nivel", "Cod. Grado", "Linea de negocio", Familia, "Sub Familia", Serie, "Cod. Producto")
        {
        }
        key(Key3; "Cod. Colegio", "Cod. Promotor", "Cod. Producto")
        {
        }
        key(Key4; "Cod. Colegio", "Cod. Nivel", "Sub Familia")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Adopcion, 0);
    end;

    trigger OnInsert()
    begin
        "Fecha Adopcion" := Today;

        CabAdopciones.Reset;
        CabAdopciones.SetRange("Cod. Colegio", "Cod. Colegio");
        CabAdopciones.SetRange("Cod. Local", "Cod. Local");
        CabAdopciones.SetRange("Cod. Nivel", "Cod. Nivel");
        CabAdopciones.SetRange("Cod. Promotor", "Cod. Promotor");
        CabAdopciones.SetRange(Turno, "Cod. Turno");
        if CabAdopciones.FindFirst then begin
            "% Dto. Padres" := CabAdopciones."% Dto. Padres";
            "% Dto. Colegio" := CabAdopciones."% Dto. Colegio";
            "% Dto. Docente" := CabAdopciones."% Dto. Docente";
            "% Dto. Feria Padres" := CabAdopciones."% Dto. Feria Padres";
            "% Dto. Feria Colegio" := CabAdopciones."% Dto. Feria Colegio";
        end;

        Item.Get("Cod. Producto");
        "Descripcion producto" := Item.Description;
    end;

    var
        ConfAPS: Record "Commercial Setup";
        ColNiv: Record "Colegio - Nivel";
        Editora: Record Editoras;
        GradoCol: Record "Colegio - Grados";
        Item: Record Item;
        ProdEq: Record "Productos Equivalentes";
        CabAdopciones: Record "Colegio - Adopciones Cab";
        DA: Record "Datos auxiliares";
        ColegioAdopciones: Record "Colegio - Log - Adopciones";
        ColegioAdopciones2: Record "Colegio - Log - Adopciones";
        DimVal: Record "Dimension Value";
        DimForm: Page "Dimension Value List";
        DefDim: Record "Default Dimension";
        ProdEdit: Record "Libros Competencia";


    procedure BuscaHistorico()
    var
        Adopciones: Record "Colegio - Log - Adopciones";
        Adopciones2: Record "Colegio - Log - Adopciones";
        AdopcionesD: Record "Colegio - Adopciones Detalle";
        HAdopciones: Record "Historico Adopciones";
        Editoriales: Record Editoras;
        GradosCol: Record "Colegio - Grados";
        PptoPromotor: Record "Promotor - Ppto Vtas";
        Camp: Integer;
    begin
        /*
        ConfAPS.GET();
        AdopcionesD.RESET;
        AdopcionesD.SETRANGE("Cod. Colegio","Cod. Colegio");
        AdopcionesD.SETRANGE("Cod. Nivel","Cod. Nivel");
        AdopcionesD.SETRANGE("Cod. Turno","Cod. Turno");
        AdopcionesD.SETRANGE("Cod. Promotor","Cod. Promotor");
        
        IF NOT AdopcionesD.FINDFIRST THEN
           BEGIN
            Editoriales.SETRANGE(Santillana,TRUE);
            Editoriales.FINDFIRST;
        
            GradosCol.SETRANGE("Cod. Colegio","cod. colegio");
            GradosCol.SETRANGE("Cod. Nivel","cod. nivel");
            GradosCol.SETRANGE("Cod. Turno","cod. turno");
            GradosCol.FINDFIRST;
        
            PptoPromotor.RESET;
            PptoPromotor.SETRANGE("Cod. Promotor","cod. Promotor");
            if PptoPromotor.FINDfirst then
               begin
                Item.GET(PptoPromotor."Cod. Producto");
                ConfAPS.testfield(Campana);
                evaluate(camp,ConfAPS.Campana);
                HAdopciones.SETRANGE(Campaña,);
                HAdopciones.SETRANGE("Cod. Colegio",gCodCol);
                HAdopciones.SETRANGE("Cod. Nivel",gCodNivel);
                IF PptoPromotor."Cod. producto equivalente" <> '' THEN
                   HAdopciones.SETFILTER("Cod. Libro",'%1|%2','',PptoPromotor."Cod. producto equivalente")
                ELSE
                   HAdopciones.SETFILTER("Cod. Libro",'%1|%2','',PptoPromotor."Cod. Producto");
                IF HAdopciones.FINDFIRST THEN
                    BEGIN
                      CLEAR(AdopcionesD);
                      AdopcionesD.VALIDATE("Cod. Colegio",gCodCol);
                      AdopcionesD.VALIDATE("Cod. Local",gCodLocal);
                      AdopcionesD.VALIDATE("Cod. Nivel",gCodNivel);
                      AdopcionesD.VALIDATE("Cod. Turno",gCodTurno);
                      AdopcionesD.VALIDATE("Cod. Promotor",gCodPromotor);
                      AdopcionesD.VALIDATE("Cod. Producto",PptoPromotor."Cod. Producto");
                      AdopcionesD.VALIDATE("Cod. Grado",Item.Grado);
                      AdopcionesD."Adopcion anterior" := HAdopciones.Adopcion;
                      IF AdopcionesD.INSERT(TRUE) THEN;
                    END
             ELSE
                BEGIN
                  CLEAR(AdopcionesD);
                  AdopcionesD.VALIDATE("Cod. Colegio",gCodCol);
                  AdopcionesD.VALIDATE("Cod. Local",gCodLocal);
                  AdopcionesD.VALIDATE("Cod. Nivel",gCodNivel);
                  AdopcionesD.VALIDATE("Cod. Turno",gCodTurno);
                  AdopcionesD.VALIDATE("Cod. Promotor",gCodPromotor);
                  AdopcionesD.VALIDATE("Cod. Producto",PptoPromotor."Cod. Producto");
                  AdopcionesD.VALIDATE("Cod. Editorial",Editoriales.Code);
                  AdopcionesD.VALIDATE("Cod. Grado",Item.Grado);
        //          AdopcionesD.Santillana := Editoriales.Santillana;
                  IF AdopcionesD.INSERT(TRUE) THEN;
                END;
            UNTIL PptoPromotor.NEXT =0;
        */

    end;
}

