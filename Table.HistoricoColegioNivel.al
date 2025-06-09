table 76142 "Historico Colegio - Nivel"
{
    DrillDownPageID = "Colegio - Nivel";
    LookupPageID = "Colegio - Nivel";

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            TableRelation = Contact WHERE (Type = CONST (Company));

            trigger OnValidate()
            begin
                Col.Get("Cod. Colegio");
                City := Col.City;
                "Post Code" := Col."Post Code";
                County := Col.County;
            end;
        }
        field(2; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));
        }
        field(3; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Nivel Educativo APS";
        }
        field(4; Turno; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Turnos));
        }
        field(5; "Categoria colegio"; Code[10])
        {
        }
        field(6; Ruta; Code[20])
        {

            trigger OnLookup()
            begin
                ConfAPS.Get();
                if ConfAPS."Activar control de C.P." then begin
                    RD.Reset;
                    RD.SetRange("Post Code", "Post Code");
                    Rutas.SetTableView(RD);
                    Rutas.SetRecord(RD);
                    Rutas.LookupMode(true);
                    if Rutas.RunModal = ACTION::LookupOK then begin
                        Rutas.GetRecord(RD);
                        Validate(Ruta, RD."Cod. Ruta");
                    end;
                end
                else begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Rutas);
                    Rutas2.SetTableView(DA);
                    Rutas2.SetRecord(DA);
                    Rutas2.LookupMode(true);
                    if Rutas2.RunModal = ACTION::LookupOK then begin
                        Rutas2.GetRecord(DA);
                        Validate(Ruta, DA.Codigo);
                    end;
                end;

                Clear(Rutas);
                Clear(Rutas2);
            end;

            trigger OnValidate()
            begin
                ConfAPS.Get();
                if Ruta <> '' then begin
                    if ConfAPS."Activar control de C.P." then begin
                        "P-Ruta".Reset;
                        "P-Ruta".SetRange("Cod. Ruta", Ruta);
                        "P-Ruta".FindFirst;
                        "Cod. Promotor" := "P-Ruta"."Cod. Promotor";
                    end
                    else begin
                        DA.Reset;
                        DA.SetRange("Tipo registro", DA."Tipo registro"::Rutas);
                        DA.SetRange(Codigo, Ruta);
                        DA.FindFirst;
                    end;

                    Clear("P-LC");
                    "P-LC".Validate("Cod. Promotor", "P-Ruta"."Cod. Promotor");
                    "P-LC".Validate("Cod. Colegio", "Cod. Colegio");
                    "P-LC".Validate("Cod. Ruta", Ruta);
                    if "P-LC".Insert(true) then;
                end;
            end;
        }
        field(7; "Dto. Ticket Colegio"; Decimal)
        {
            CalcFormula = Lookup ("Colegio - Adopciones Cab"."% Dto. Colegio" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                                    "Cod. Local" = FIELD ("Cod. Local"),
                                                                                    "Cod. Nivel" = FIELD ("Cod. Nivel")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Dto. Ticket Padres"; Decimal)
        {
            CalcFormula = Lookup ("Colegio - Adopciones Cab"."% Dto. Padres" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                                   "Cod. Local" = FIELD ("Cod. Local"),
                                                                                   "Cod. Nivel" = FIELD ("Cod. Nivel")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Dto. Feria Colegio"; Decimal)
        {
            CalcFormula = Lookup ("Colegio - Adopciones Cab"."% Dto. Feria Colegio" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                                          "Cod. Local" = FIELD ("Cod. Local"),
                                                                                          "Cod. Nivel" = FIELD ("Cod. Nivel")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Dto. Feria Padres"; Decimal)
        {
            CalcFormula = Lookup ("Colegio - Adopciones Cab"."% Dto. Feria Padres" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                                         "Cod. Local" = FIELD ("Cod. Local"),
                                                                                         "Cod. Nivel" = FIELD ("Cod. Nivel")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Adoptado; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ","Sí",No;

            trigger OnValidate()
            begin
                if Adoptado = 1 then begin
                    ColAdopcion.Reset;
                    ColAdopcion.SetRange("Cod. Colegio", "Cod. Colegio");
                    ColAdopcion.SetRange("Cod. Turno", Turno);
                    ColAdopcion.SetRange("Cod. Nivel", "Cod. Nivel");
                    ColAdopcion.SetRange(Adopcion, 1, 2);
                    if not ColAdopcion.FindFirst then
                        Error(StrSubstNo(Err001, Adoptado, ColAdopcion.GetFilters));
                end;
            end;
        }
        field(12; "Estatus observado"; Boolean)
        {
        }
        field(13; City; Text[30])
        {
            Caption = 'City';
            TableRelation = Contact.City;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(14; "Post Code"; Code[20])
        {
            Caption = 'ZIP Code';
            TableRelation = Contact."Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(15; County; Text[30])
        {
            Caption = 'State';
        }
        field(16; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(17; "Dto. Docente"; Decimal)
        {
            CalcFormula = Lookup ("Colegio - Adopciones Cab"."% Dto. Docente" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"),
                                                                                    "Cod. Local" = FIELD ("Cod. Local"),
                                                                                    "Cod. Nivel" = FIELD ("Cod. Nivel")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Campana; Code[4])
        {
            Caption = 'Campaña';
            TableRelation = Campaign;
        }
        field(53501; "Distrito Code"; Code[10])
        {
            Caption = 'Cod. Distrito';
            Description = '//Peru';
            Enabled = false;

            trigger OnValidate()
            begin
                /*Peru
                IF xRec."Distrito Code" <>"Distrito Code" THEN
                  Distritos :='';
                
                IF PostCode.GET("Post Code","Territory Code","Distrito Code") THEN
                   Distritos :=PostCode.Descripcion;
                */

            end;
        }
        field(53502; Departamento; Text[30])
        {
            Caption = 'District';
            Description = '//Peru';
            Enabled = false;
        }
        field(53503; Distritos; Text[30])
        {
            Description = '//Peru';
            Enabled = false;
        }
        field(53504; Provincia; Text[30])
        {
            Description = '//Peru';
            Enabled = false;
        }
        field(53505; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            Description = '//Peru';
            Enabled = false;
            TableRelation = Territory;
        }
        field(53506; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = '//Peru';
            TableRelation = "Country/Region";
        }
        field(76012; "Codigo Postal"; Code[10])
        {
            Description = '//Peru';
            Enabled = false;
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Colegio", "Cod. Nivel", Turno, Ruta)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Nivel", Ruta)
        {
        }
    }

    var
        ConfAPS: Record "Commercial Setup";
        Col: Record Contact;
        PostCode: Record "Post Code";
        DA: Record "Datos auxiliares";
        ColAdopcion: Record "Colegio - Adopciones Detalle";
        "P-LC": Record "Promotor - Lista de Colegios";
        "P-Ruta": Record "Promotor - Rutas";
        RD: Record "Rutas - CP";
        Nivel: Record "Nivel Educativo";
        Rutas: Page "Rutas - Distribucion Geo.";
        Rutas2: Page Rutas;
        Err001: Label 'Adopted only can be %1, if there is at least one book for the combination of %2';
}

