table 76415 "Colegio - Adopciones Detalle"
{
    DrillDownPageID = "Colegio - Adopciones Detalles";
    LookupPageID = "Colegio - Adopciones Detalles";

    fields
    {
        field(1; "Cod. Editorial"; Code[20])
        {
            Caption = 'Cod. Editorial';
            NotBlank = true;

            trigger OnValidate()
            begin

                if (Adopcion < 1) or (Adopcion > 2) then begin
                    Editora.Get("Cod. Editorial");
                    //    IF xRec."Cod. Editorial" <> "Cod. Editorial" THEN
                    //       Adopcion := 0;
                end;
                //ELSE
                //   ERROR(Err001);
            end;
        }
        field(2; "Cod. Colegio"; Code[20])
        {
            Caption = 'Cod. Colegio';
            NotBlank = true;
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(3; "Cod. Local"; Code[20])
        {
            Caption = 'Sublínea';
        }
        field(4; "Cod. Nivel"; Code[20])
        {
            NotBlank = true;
        }
        field(5; "Cod. Grado"; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                /*GRN 17/02/2020, a requerimiento, ya no se validara
                
                
                IF "Cod. Grado" <> '' THEN
                   BEGIN
                    Nivel.GET("Cod. Nivel");
                    GradoCol.RESET;
                    GradoCol.SETRANGE("Cod. Colegio","Cod. Colegio");
                    GradoCol.SETRANGE("Cod. Local","Cod. Local");
                    {
                    IF Nivel."Verificación cruzada" THEN
                       BEGIN
                //        GradoCol.SETRANGE("Cod. Nivel","Cod. Nivel");
                        GradoCol.SETRANGE("Cod. Grado","Cod. Grado");
                        GradoCol.SETRANGE("Cod. Turno","Cod. Turno");
                        IF GradoCol.FINDFIRST THEN
                    //       BEGIN
                           "Cantidad Alumnos" := GradoCol."Cantidad Alumnos";
                
                       END
                    ELSE
                    }
                       BEGIN
                        {GRN  A solicitud de Paul
                        GradoCol.SETRANGE("Cod. Nivel","Cod. Nivel");
                        GradoCol.SETRANGE("Cod. Grado","Cod. Grado");
                        GradoCol.SETRANGE("Cod. Turno","Cod. Turno");
                        IF GradoCol.FINDFIRST THEN
                    //       BEGIN
                            "Cantidad Alumnos" := GradoCol."Cantidad Alumnos";
                       }
                       END;
                   END;
                */

            end;
        }
        field(6; "Cod. Turno"; Code[20])
        {
        }
        field(7; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));
        }
        field(8; "Cod. Producto"; Code[20])
        {
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Cod. Producto" <> '' then begin
                    ConfAPS.Get();
                    Item.Get("Cod. Producto");
                    "Descripcion producto" := Item.Description;
                    if ProdEq.Get("Cod. Producto") then begin
                        "Cod. Equiv. Santillana" := ProdEq."Cod. Producto Anterior";
                        "Descripcion Equiv. Santillana" := ProdEq."Nombre Producto Anterior";
                    end;
                end;
                /*
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
        field(9; Seccion; Text[60])
        {
            Caption = 'Nombre combo';
        }
        field(10; "Cod. Equiv. Santillana"; Code[20])
        {
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
            DecimalPlaces = 0 : 0;
        }
        field(19; "% Dto. Padres"; Decimal)
        {
            Caption = 'DIRECTO';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(20; "% Dto. Colegio"; Decimal)
        {
            Caption = 'DONACION';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(21; "% Dto. Docente"; Decimal)
        {
            Caption = 'LIBRER´A';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(22; "% Dto. Feria Padres"; Decimal)
        {
            Caption = 'PROMOCIONAL PLANTEL';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(23; "% Dto. Feria Colegio"; Decimal)
        {
            Caption = 'PROMOCIONAL PROFE';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(24; "Cod. Motivo perdida adopcion"; Code[20])
        {
            Caption = 'Sublínea 2';

            trigger OnValidate()
            begin

                /*DA.RESET;
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
                Item.Get("Cod. Producto");
                //ActualizaAdopcion(Item);
            end;
        }
        field(29; "Adopcion anterior"; Option)
        {
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(30; Santillana; Text[9])
        {
            Caption = 'Código combo';
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
                ConfAPS.Get();
                ConfAPS.TestField("Cod. Dimension Lin. Negocio");

                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Lin. Negocio");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    "Linea de negocio" := DimVal.Code;
                end;

                Clear(DimForm);
            end;
        }
        field(34; Familia; Code[20])
        {

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField("Cod. Dimension Familia");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Familia");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Familia := DimVal.Code;
                end;

                Clear(DimForm);
            end;
        }
        field(35; "Sub Familia"; Integer)
        {
            Caption = 'Alumnos';
            MaxValue = 9999;
            MinValue = 0;

            trigger OnLookup()
            begin
                /*30/11/2020
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
                ConfAPS.Get();
                ConfAPS.TestField("Cod. Dimension Serie");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Serie");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Serie := DimVal.Code;
                end;

                Clear(DimForm);
            end;
        }
        field(37; "Fecha Ult. Modificacion"; Date)
        {
        }
        field(38; "Adopcion Real"; Decimal)
        {
        }
        field(39; "Motivo perdida adopcion"; Text[12])
        {
            Caption = 'Tipo Producto';

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
        field(41; "Cod. Producto Editora"; Code[6])
        {
            Caption = 'Código canal 2';

            trigger OnValidate()
            begin
                /*
                IF "Cod. Producto Editora" <> '' THEN
                   BEGIN
                    ProdEdit.GET("Cod. Editorial","Cod. Producto Editora","Cod. Nivel");
                    "Nombre Producto Editora" := ProdEdit.Description;
                   END;
                */

            end;
        }
        field(42; "Nombre Producto Editora"; Text[13])
        {
            Caption = 'EAN KIT';
        }
        field(43; "Grupo de Negocio"; Code[20])
        {
            Caption = 'Marca';
        }
        field(44; "Carga horaria"; Code[20])
        {
        }
        field(45; "Tipo Ingles"; Integer)
        {
            Caption = 'Alumnos activados';
            MaxValue = 9999;
        }
        field(46; Materia; Code[10])
        {

            trigger OnLookup()
            var
                Materia: Page Materias;
            begin
            end;
        }
        field(47; "Mes de Lectura"; Date)
        {
            Caption = 'Fecha de despacho';
        }
        field(48; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Cod. Producto")));
            Caption = 'Quantity on Hand';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Max("Price List Line"."Unit Price" WHERE("Product No." = FIELD("Cod. Producto"),
                                                                "Ending Date" = FILTER(0D),
                                                                "Asset Type" = const(Item)));
            Caption = 'Unit Price';
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(100; "Item - Item Category Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = FIELD("Cod. Producto")));
            FieldClass = FlowField;
        }
        field(101; "Sales Price - Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Max("Price List Line"."Unit Price" WHERE("Product No." = FIELD("Cod. Producto"),
                                                                "Ending Date" = FILTER(0D),
                                                                "Asset Type" = const(Item)));
            Caption = 'Unit Price';
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(102; "Item - Product Group Code"; Code[20])
        {
            //CalcFormula = Lookup(Item."Product Group Code" WHERE("No." = FIELD("Cod. Producto")));
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = FIELD("Cod. Producto")));
            FieldClass = FlowField;
        }
        field(103; "Item - Grado"; Code[20])
        {
            CalcFormula = Lookup(Item."Nivel Escolar (Grado)" WHERE("No." = FIELD("Cod. Producto")));
            FieldClass = FlowField;
        }
        field(104; "% Dto. Donacion Plantel"; Decimal)
        {
            Caption = 'INFRAESTRUCTURA';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(105; Campana; Code[20])
        {
            Caption = 'Campaign';
        }
        field(106; "Codigo Canal Ventas"; Code[6])
        {
            Caption = 'Código canal';
        }
        field(107; "Nombre Canal"; Text[100])
        {
        }
        field(108; "Infraestructura para PLANTEL"; Decimal)
        {
            Caption = 'BECAS';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(109; "Becas PLANTEL"; Decimal)
        {
            Caption = 'EQUIPOS';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(110; "Equipos PLANTEL"; Decimal)
        {
            Caption = 'CAPACITACION';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(111; "Capacitación PLANTEL"; Decimal)
        {
            Caption = 'CAPEX';

            trigger OnValidate()
            begin
                DescTotal;
            end;
        }
        field(112; "Descuento Total"; Decimal)
        {
            Caption = 'Descuento Total';
            Editable = false;
        }
        field(113; "PVP Campaña"; Decimal)
        {
        }
        field(55000; "Fecha de lectura"; Date)
        {
        }
        field(55001; Linea; Code[20])
        {
            Caption = 'Línea';
            Description = 'EC';
        }
        field(55002; "Anos convenio"; Integer)
        {
            Caption = 'Años convenio';
        }
        field(55003; "Capex amortizado"; Decimal)
        {
        }
        field(55004; "Canal venta 3"; Code[20])
        {
            Caption = 'Código canal 3';
        }
        field(55005; "Tipo Canal"; Code[20])
        {
        }
        field(55006; "Tipo verificacion"; Code[10])
        {
        }
        field(55007; "Nombre De Canal 2"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Colegio", "Grupo de Negocio", Serie, "Cod. Producto")
        {
        }
        key(Key3; "Cod. Colegio", "Cod. Nivel", "Cod. Grado", "Cod. Producto")
        {
            SumIndexFields = "Cantidad Alumnos", "Adopcion Real";
        }
        key(Key4; "Cod. Colegio", "Cod. Promotor", "Cod. Producto")
        {
        }
        key(Key5; "Cod. Colegio", "Cod. Nivel", "Sub Familia")
        {
        }
        key(Key6; "Cod. Colegio", "Linea de negocio", Familia, "Sub Familia", Serie, "Grupo de Negocio")
        {
        }
        key(Key7; "Cod. Colegio", "Cod. Promotor", "Descripcion producto")
        {
        }
        key(Key8; "Cod. Colegio", "Cod. Grado", "Cod. Promotor", Adopcion)
        {
            SumIndexFields = "Adopcion Real";
        }
        key(Key9; "Cod. Colegio", "Cod. Local", "Cod. Nivel", "Cod. Grado", "Cod. Producto", "Linea de negocio")
        {
            SumIndexFields = "Adopcion Real";
        }
        key(Key10; "Cod. Colegio", Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Adopcion,0);
    end;

    trigger OnInsert()
    begin
        //"Fecha Adopcion" := TODAY;

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
            Campana := CabAdopciones.Campana;
        end;
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
        Nivel: Record "Nivel Educativo APS";
        Err001: Label 'This item has Status of adopted by Santillana';


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


    procedure OpenItem()
    var
        ItemCard: Page "Item Card";
    begin
        Item.Get("Cod. Producto");
        ItemCard.SetRecord(Item);
        ItemCard.RunModal;
        Clear(ItemCard);
    end;


    procedure ActualizaAdopcion(lItem: Record Item)
    var
        PromRuta: Record "Promotor - Rutas";
        ColAdopcion: Record "Colegio - Adopciones Detalle";
    begin
        Editora.SetRange(Santillana, true);
        Editora.FindFirst;

        /*GRN 17/02/2020, a requerimiento, ya no se validara
        GradoCol.GET("Cod. Colegio","Cod. Nivel","Cod. Turno","Cod. Grado",Seccion);
        //GRN Paul pidio no validarlo GradoCol.TESTFIELD("Cantidad Alumnos");
        IF "Cantidad Alumnos" = 0 THEN
           "Cantidad Alumnos" := GradoCol."Cantidad Alumnos";
        */

        //Item.GET("Cod. Producto");
        /*GRN 17/02/2020, a requerimiento, ya no se validara
        PromRuta.SETRANGE("Cod. Promotor","Cod. Promotor");
        PromRuta.FINDFIRST;
        
        //MESSAGE('%1 %2 %3 %4',"Cod. Producto",lItem."% Castigo Mantenimiento",lItem."% Castigo Conquista",lItem."% Castigo Perdida");
        CASE Adopcion OF
          1: //Conquista
           BEGIN
            "Cod. Editorial" := Editora.Code;
            "Adopcion Real" := ROUND("Cantidad Alumnos" - ("Cantidad Alumnos" * lItem."% Castigo Conquista" /100),1);
            "Cod. Editorial" := Editora.Code;
        
            ColNiv.RESET;
            ColNiv.SETRANGE("Cod. Colegio","Cod. Colegio");
            ColNiv.SETRANGE(Turno,"Cod. Turno");
            ColNiv.SETRANGE(Ruta,PromRuta."Cod. Ruta");
            ColNiv.FINDFIRST;
            ColNiv.Adoptado := 1;
            ColNiv.MODIFY;
        
           END;
          2: //Mantener
           BEGIN
            "Cod. Editorial" := Editora.Code;
            "Adopcion Real" := ROUND("Cantidad Alumnos" - ("Cantidad Alumnos"* lItem."% Castigo Mantenimiento" / 100),1);
            "Cod. Editorial" := Editora.Code;
        
            ColNiv.RESET;
            ColNiv.SETRANGE("Cod. Colegio","Cod. Colegio");
            ColNiv.SETRANGE(Turno,"Cod. Turno");
            ColNiv.SETRANGE(Ruta,PromRuta."Cod. Ruta");
            ColNiv.FINDFIRST;
            ColNiv.Adoptado := 1;
            ColNiv.MODIFY;
        
           END;
          3: //Perdida
           BEGIN
            "Adopcion Real" := ROUND("Cantidad Alumnos" - ("Cantidad Alumnos"* lItem."% Castigo Perdida" / 100),1);
            "Cod. Editorial" := '';
           END;
          0,4: //Blanco o Retiro
           BEGIN
            "Adopcion Real" := 0;
            "Cod. Editorial" := '';
        
            ColNiv.RESET;
            ColNiv.SETRANGE("Cod. Colegio","Cod. Colegio");
            ColNiv.SETRANGE(Turno,"Cod. Turno");
            ColNiv.SETRANGE(Ruta,PromRuta."Cod. Ruta");
            ColNiv.FINDFIRST;
            ColNiv.Adoptado := 0;
        
            ColAdopcion.RESET;
            ColAdopcion.SETRANGE("Cod. Colegio","Cod. Colegio");
            ColAdopcion.SETRANGE("Cod. Turno","Cod. Turno");
        //    ColAdopcion.SETRANGE("Cod. Nivel","Cod. Nivel");
            ColAdopcion.SETFILTER("Cod. Producto",'<>%1',"Cod. Producto");
            ColAdopcion.SETRANGE("Cod. Promotor","Cod. Promotor");
            ColAdopcion.SETRANGE(Adopcion,1,2);
            IF ColAdopcion.FINDFIRST THEN
               BEGIN
                ColNiv.RESET;
                ColNiv.SETRANGE("Cod. Colegio","Cod. Colegio");
                ColNiv.SETRANGE(Turno,"Cod. Turno");
                ColNiv.SETRANGE(Ruta,PromRuta."Cod. Ruta");
                ColNiv.FINDFIRST;
                ColNiv.Adoptado := 1;
               END
            ELSE
              BEGIN
                ColNiv.MODIFY;
              END;
           END;
        
        ELSE
          CLEAR("Cod. Editorial");
        END;
        */

        if ColAdopcion.Get("Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto") then begin
            if xRec.Adopcion <> Rec.Adopcion then begin
                if not ColegioAdopciones2.FindLast then
                    ColegioAdopciones2.Secuencia := 0;

                "Fecha Ult. Modificacion" := Today;
                //    message('paso %1',today);
                //"Fecha Adopcion" := TODAY;
                ColegioAdopciones.Init;
                ColegioAdopciones.TransferFields(Rec);
                ColegioAdopciones.Secuencia := ColegioAdopciones2.Secuencia + 1;
                ColegioAdopciones.Insert;

                Modify;
            end;
        end;

    end;


    procedure DescTotal()
    begin

        "Descuento Total" :=
            "% Dto. Padres" + "% Dto. Colegio" + "% Dto. Docente" + "% Dto. Feria Padres" + "% Dto. Feria Colegio" +
            "% Dto. Donacion Plantel" + "Infraestructura para PLANTEL" + "Becas PLANTEL" + "Equipos PLANTEL" + "Capacitación PLANTEL" + "Capex amortizado";
    end;
}

