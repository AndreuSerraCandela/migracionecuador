table 76133 "Colegio - Log - Adopciones"
{
    DrillDownPageID = "Colegio - Adopciones Cab";
    LookupPageID = "Colegio - Adopciones Cab";

    fields
    {
        field(1; "Cod. Editorial"; Code[20])
        {
            NotBlank = true;
            TableRelation = Editoras;
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
            TableRelation = "Nivel Educativo APS";
        }
        field(5; "Cod. Grado"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Colegio - Grados"."Cod. Grado" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                   "Cod. Turno" = FIELD ("Cod. Turno"));
        }
        field(6; "Cod. Turno"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Turnos));
        }
        field(7; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));
        }
        field(8; "Cod. Producto"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Promotor - Ppto Vtas"."Cod. Producto" WHERE ("Cod. Promotor" = FIELD ("Cod. Promotor"));
        }
        field(9; Seccion; Code[20])
        {
            NotBlank = true;
        }
        field(10; "Cod. Equiv. Santillana"; Code[20])
        {
            TableRelation = "Productos Equivalentes"."Cod. Producto Anterior" WHERE ("Cod. Producto" = FIELD ("Cod. Producto"));
        }
        field(11; "Descripcion Equiv. Santillana"; Text[100])
        {
        }
        field(12; "Nombre Editorial"; Text[100])
        {
            CalcFormula = Lookup (Editoras.Description WHERE (Code = FIELD ("Cod. Editorial")));
            FieldClass = FlowField;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(13; "Descripcion producto"; Text[100])
        {
        }
        field(14; "Nombre Colegio"; Text[100])
        {
            CalcFormula = Lookup (Contact.Name WHERE ("No." = FIELD ("Cod. Colegio")));
            FieldClass = FlowField;
        }
        field(15; "Descripcion Nivel"; Text[100])
        {
            CalcFormula = Lookup ("Nivel Educativo APS"."Descripción" WHERE ("Código" = FIELD ("Cod. Nivel")));
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
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Motivos Perdida"));
        }
        field(27; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup ("Salesperson/Purchaser".Name WHERE (Code = FIELD ("Cod. Promotor")));
            FieldClass = FlowField;
        }
        field(28; Adopcion; Option)
        {
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
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
        }
        field(34; Familia; Code[20])
        {
        }
        field(35; "Sub Familia"; Code[20])
        {
        }
        field(36; Serie; Code[20])
        {
        }
        field(37; "Fecha Ult. Modificacion"; Date)
        {
        }
        field(38; "Adopcion Real"; Decimal)
        {
        }
        field(39; "Motivo perdida adopcion"; Text[60])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Motivos Perdida"));
        }
        field(41; "Cod. Producto Editora"; Code[20])
        {
            TableRelation = "Libros Competencia"."Cod. Libro" WHERE ("Cod. Editorial" = FIELD ("Cod. Editorial"),
                                                                     Nivel = FIELD ("Cod. Nivel"));
        }
        field(42; "Nombre Producto Editora"; Text[100])
        {
        }
        field(43; "Grupo de Negocio"; Code[20])
        {
        }
        field(44; "Carga horaria"; Code[20])
        {            
        }
        field(45; "Tipo Ingles"; Option)
        {
            OptionCaption = ' ,USA,England';
            OptionMembers = " ",USA,England;
        }
        field(46; Materia; Code[10])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Materia));

            trigger OnLookup()
            var
                Materia: Page Materias;
            begin
            end;
        }
        field(47; "Mes de Lectura"; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,Jun,July,August,September,October,November,December';
            OptionMembers = " ",Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        }
        field(48; Secuencia; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Secuencia)
        {
            Clustered = true;
        }
        key(Key2; "Cod. Colegio", "Cod. Local", "Cod. Nivel", "Cod. Grado")
        {
        }
    }

    fieldgroups
    {
    }

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
}

