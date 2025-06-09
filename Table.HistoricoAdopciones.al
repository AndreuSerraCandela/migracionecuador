table 76139 "Historico Adopciones"
{

    fields
    {
        field(1; Campana; Code[4])
        {
            Caption = 'Campaña';
            TableRelation = Campaign;
        }
        field(2; "Cod. Editorial"; Code[20])
        {
            Caption = 'Cód. Editorial';
            TableRelation = Editoras;
        }
        field(3; "Cod. Colegio"; Code[20])
        {
            Caption = 'Cód. Colegio';
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
        field(4; "Cod. Local"; Code[20])
        {
            Caption = 'Cód. Local';
            TableRelation = "Contact Alt. Address".Code WHERE("Contact No." = FIELD("Cod. Colegio"));
        }
        field(5; "Cod. Nivel"; Code[20])
        {
            Caption = 'Cód. Nivel';
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"));
        }
        field(6; "Cod. Grado"; Code[20])
        {
            Caption = 'Cód. Grado';
            TableRelation = "Colegio - Grados"."Cod. Grado" WHERE("Cod. Colegio" = FIELD("Cod. Colegio"),
                                                                   "Cod. Nivel" = FIELD("Cod. Nivel"));
        }
        field(7; "Cod. Turno"; Code[20])
        {
            Caption = 'Cód. Turno';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Turnos));
        }
        field(8; "Cod. Promotor"; Code[20])
        {
            Caption = 'Cód. Promotor';
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = CONST(Vendedor));
        }
        field(9; "Cod. producto"; Code[20])
        {
            Caption = 'Cód. producto';
            TableRelation = Item;
        }
        field(10; Seccion; Code[20])
        {
            Caption = 'Sección';
        }
        field(11; "Cod. Equiv. Santillana"; Code[20])
        {
            Caption = 'Cód. Equiv. Santillana';
            TableRelation = "Productos Equivalentes"."Cod. Producto Anterior" WHERE("Cod. Producto" = FIELD("Cod. producto"));
        }
        field(12; "Descripcion Equiv. Santillana"; Text[100])
        {
            CalcFormula = Lookup("Productos Equivalentes"."Nombre Producto Anterior" WHERE("Cod. Producto Anterior" = FIELD("Cod. Equiv. Santillana")));
            Caption = 'Descripción Equiv. Santillana';
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(13; "Nombre Editorial"; Text[100])
        {
            CalcFormula = Lookup(Editoras.Description WHERE(Code = FIELD("Cod. Editorial")));
            Caption = 'Nombre Editorial';
            Enabled = false;
            FieldClass = FlowField;
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(14; "Nombre Libro"; Text[100])
        {
            Caption = 'Nombre Libro';
        }
        field(15; "Nombre Colegio"; Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Cod. Colegio")));
            Caption = 'Nombre Colegio';
            FieldClass = FlowField;
        }
        field(16; "Descripcion Nivel"; Text[100])
        {
            CalcFormula = Lookup("Nivel Educativo APS"."Descripción" WHERE("Código" = FIELD("Cod. Nivel")));
            Caption = 'Descripcion Nivel';
            FieldClass = FlowField;
        }
        field(17; "Descripcion Grado"; Text[100])
        {
            CalcFormula = Lookup("Datos auxiliares".Descripcion WHERE("Tipo registro" = CONST(Grados),
                                                                       Codigo = FIELD("Cod. Grado")));
            Caption = 'Descripcion Grado';
            FieldClass = FlowField;
        }
        field(18; "Fecha Adopcion"; Date)
        {
            Caption = 'Fecha Adopción';
        }
        field(19; "Cantidad Alumnos"; Integer)
        {
            Caption = 'Cantidad Alumnos';
        }
        field(20; "% Dto. Padres de familia"; Decimal)
        {
            Caption = '% Dto. Padres de familia';
        }
        field(21; "% Dto. Colegio"; Decimal)
        {
            Caption = '% Dto. Colegio';
        }
        field(22; "% Dto. Docente"; Decimal)
        {
            Caption = '% Dto. Docente';
        }
        field(23; "% Dto. Feria Padres de familia"; Decimal)
        {
            Caption = '% Dto. Feria Padres de familia';
        }
        field(24; "% Dto. Feria Colegio"; Decimal)
        {
            Caption = '% Dto. Feria Colegio';
        }
        field(25; "Cod. Motivo perdida adopcion"; Code[20])
        {
            Caption = 'Cod. Motivo perdida adopcion';
        }
        field(26; "Cod. Libro Equivalente"; Code[20])
        {
            Caption = 'Cod. Libro Equivalente';
            TableRelation = "Productos Equivalentes" WHERE("Cod. Producto" = FIELD("Cod. producto"));
        }
        field(27; "Adopciones Camp. Anterior"; Integer)
        {
            Caption = 'Adopciones Camp. Anterior';
        }
        field(28; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup("Salesperson/Purchaser".Name WHERE(Code = FIELD("Cod. Promotor")));
            Caption = 'Nombre Promotor';
            FieldClass = FlowField;
        }
        field(29; Adopcion; Option)
        {
            Caption = 'Adopcion';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(30; "Adopcion anterior"; Option)
        {
            Caption = 'Adopcion anterior';
            OptionCaption = ' ,Conquest,Keep,Lost,Retired';
            OptionMembers = " ",Conquista,Mantener,Perdida,Retiro;
        }
        field(31; Santillana; Boolean)
        {
            Caption = 'Santillana';
        }
        field(32; "Ano adopcion"; Integer)
        {
            Caption = 'Year of decition';
        }
        field(40; "Descripcion producto"; Text[100])
        {
            Caption = 'Descripción producto';
        }
        field(41; Usuario; Code[20])
        {
            Caption = 'Usuario';
        }
        field(42; "Linea de negocio"; Code[20])
        {
            Caption = 'Linea de negocio';
        }
        field(43; Familia; Code[20])
        {
            Caption = 'Familia';
        }
        field(44; "Sub Familia"; Code[20])
        {
            Caption = 'Sub Familia';
        }
        field(45; Serie; Code[20])
        {
            Caption = 'Serie';
        }
        field(46; "Fecha Ult. Modificacion"; Date)
        {
            Caption = 'Fecha Ult. Modificación';
        }
        field(47; "Adopcion Real"; Decimal)
        {
            Caption = 'Adopcion Real';
        }
        field(48; "Motivo perdida adopcion"; Text[60])
        {
            Caption = 'Motivo perdida adopcion';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Motivos Perdida"));
        }
        field(49; "Cod. Producto Editora"; Code[20])
        {
            Caption = 'Cód. Producto Editora';
            TableRelation = "Libros Competencia"."Cod. Libro" WHERE("Cod. Editorial" = FIELD("Cod. Editorial"),
                                                                     Nivel = FIELD("Cod. Nivel"));
        }
        field(50; "Nombre Producto Editora"; Text[100])
        {
            Caption = 'Nombre Producto Editora';
        }
        field(51; "Grupo de Negocio"; Code[20])
        {
            Caption = 'Grupo de Negocio';
        }
        field(52; "Carga horaria"; Code[20])
        {
            Caption = 'Carga horaria';
        }
        field(53; "Tipo Ingles"; Option)
        {
            Caption = 'Tipo Ingles';
            OptionCaption = ' ,USA,England';
            OptionMembers = " ",USA,England;
        }
        field(54; Materia; Code[10])
        {
            Caption = 'Matería';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Materia));

            trigger OnLookup()
            var
                Materia: Page Materias;
            begin
            end;
        }
        field(55; "Mes de Lectura"; Option)
        {
            Caption = 'Mes de Lectura';
            OptionCaption = ' ,January,February,March,April,May,Jun,July,August,September,October,November,December';
            OptionMembers = " ",Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        }
        field(100; "Item - Item Category Code"; Code[20])
        {
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = FIELD("Cod. producto")));
            FieldClass = FlowField;
        }
        field(101; "Sales Price - Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Max("Price List Line"."Unit Price" WHERE("Product No." = FIELD("Cod. producto"),
                                                                "Ending Date" = FILTER(0D),
                                                                "Asset Type" = CONST(Item)));
            Caption = 'Unit Price';
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(102; "Item - Product Group Code"; Code[20])
        {
            /*             CalcFormula = Lookup (Item."Product Group Code" WHERE ("No." = FIELD ("Cod. producto")));
                        FieldClass = FlowField; */
        }
        field(103; "Item - Grado"; Code[20])
        {
            CalcFormula = Lookup(Item."Nivel Escolar (Grado)" WHERE("No." = FIELD("Cod. producto")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Editorial", "Cod. Colegio", "Grupo de Negocio", "Cod. Nivel", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. producto", "Fecha Adopcion")
        {
            Clustered = true;
        }
        key(Key2; "Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. producto")
        {
        }
        key(Key3; "Cod. Editorial", "Cod. Colegio", "Cod. Local", "Cod. Nivel")
        {
        }
        key(Key4; Campana, "Cod. Editorial", "Cod. Colegio", "Cod. Local", "Cod. Nivel", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. producto")
        {
        }
        key(Key5; "Cod. Colegio", Campana, Adopcion, "Cod. Editorial", "Grupo de Negocio", "Linea de negocio")
        {
        }
        key(Key6; Campana, "Cod. Colegio", "Linea de negocio")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ColNiv: Record "Colegio - Nivel";
        Editora: Record Editoras;
        GradoCol: Record "Colegio - Grados";
        Item: Record Item;
        ProdEq: Record "Productos Equivalentes";
}

