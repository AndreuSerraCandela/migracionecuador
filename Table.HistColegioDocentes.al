table 76421 "Hist. Colegio - Docentes"
{

    fields
    {
        field(1; "Cod. Colegio"; Code[20])
        {
            NotBlank = true;
            TableRelation = Contact;
        }
        field(2; "Cod. Docente"; Code[20])
        {
            NotBlank = true;
            TableRelation = Docentes;

            trigger OnValidate()
            begin
                if "Cod. Docente" <> '' then begin
                    Docente.Get("Cod. Docente");
                    "Nombre docente" := Docente."Full Name";
                    "Pertenece al CDS" := Docente."Pertenece al CDS";
                end
                else
                    Clear("Nombre docente");
            end;
        }
        field(3; "Nombre colegio"; Text[100])
        {
            CalcFormula = Lookup (Contact.Name WHERE ("No." = FIELD ("Cod. Colegio")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Nombre docente"; Text[100])
        {
        }
        field(5; "Cod. Cargo"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Puestos de trabajo"));

            trigger OnValidate()
            begin
                if "Cod. Cargo" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Puestos de trabajo");
                    DA.SetRange(Codigo, "Cod. Cargo");
                    DA.FindFirst;
                    "Nombre Cargo" := DA.Descripcion;
                end;
            end;
        }
        field(6; Principal; Boolean)
        {
            Caption = 'Default';
        }
        field(7; "Cod. Nivel"; Code[20])
        {
            TableRelation = "Colegio - Nivel"."Cod. Nivel" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));

            trigger OnValidate()
            begin
                ColNiv.Reset;
                ColNiv.SetRange("Cod. Colegio", "Cod. Colegio");
                ColNiv.SetRange("Cod. Nivel", "Cod. Nivel");
                ColNiv.FindFirst;
                begin
                    ColNiv.TestField(Ruta);
                    PromRuta.Reset;
                    PromRuta.SetRange("Cod. Ruta", ColNiv.Ruta);
                    PromRuta.FindFirst;
                    Validate("Cod. Promotor", PromRuta."Cod. Promotor");
                end;

                NivelE.Get("Cod. Nivel");
                "Descripcion Nivel" := NivelE.Descripción;
            end;
        }
        field(8; "Descripcion Nivel"; Text[100])
        {
            Editable = false;
        }
        field(9; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Promotor - Lista de Colegios"."Cod. Promotor" WHERE ("Cod. Colegio" = FIELD ("Cod. Colegio"));

            trigger OnValidate()
            begin
                Promotor.Get("Cod. Promotor");
                "Nombre Promotor" := Promotor.Name;
            end;
        }
        field(10; "Nombre Promotor"; Text[60])
        {
            CalcFormula = Lookup ("Salesperson/Purchaser".Name WHERE (Code = FIELD ("Cod. Promotor")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Aplica Jerarquia Puestos"; Boolean)
        {
        }
        field(12; "Cod. Local"; Code[20])
        {
            TableRelation = "Contact Alt. Address".Code WHERE ("Contact No." = FIELD ("Cod. Colegio"));
        }
        field(13; "Pertenece al CDS"; Boolean)
        {
        }
        field(14; "Nombre Cargo"; Text[60])
        {
        }
        field(15; "Nivel decision"; Code[20])
        {
            TableRelation = "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST ("Nivel de decisión"));

            trigger OnValidate()
            begin
                if "Nivel decision" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Nivel de decisión");
                    DA.SetRange(Codigo, "Nivel decision");
                    DA.FindFirst;
                end;
            end;
        }
        field(16; Campana; Code[20])
        {
            Caption = 'Campaign';
        }
        field(17; Distritos; Text[30])
        {
        }
        field(20; "Apellido paterno"; Text[30])
        {
        }
        field(30; "Distrito colegio"; Text[30])
        {
        }
        field(31; "Docente - Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(32; "Docente - Document ID"; Text[20])
        {
            Caption = 'Document ID';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
            end;
        }
        field(33; "Docente - E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(34; "Docente - Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(35; "Docente - E-Mail 2"; Text[80])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
        }
        field(36; "Docente - Tipo documento"; Code[20])
        {
            TableRelation = "Tipos de documentos personales";
        }
    }

    keys
    {
        key(Key1; Campana, "Cod. Colegio", "Cod. Local", "Cod. Docente")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DA: Record "Datos auxiliares";
        ColNiv: Record "Colegio - Nivel";
        NivelE: Record "Nivel Educativo APS";
        PromRuta: Record "Promotor - Rutas";
        Promotor: Record "Salesperson/Purchaser";
        Docente: Record Docentes;
        Cargo: Page "Lista Puestos";
}

