table 75000 "Configuracion MDM"
{
    Caption = 'Configuración MDM';
    DrillDownPageID = "Configuracion MDM";
    LookupPageID = "Configuracion MDM";

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Activo; Boolean)
        {
            Description = 'Sirve para determinar si está cargado';
            Editable = false;
        }
        field(5; "Bloquea Datos MDM"; Boolean)
        {
            Caption = 'Bloquea Datos MDM';
            Description = 'MdM: Bloquea ciertos valor en Producto para que no sean editables';
        }
        field(6; "Grupo Precio PVP"; Code[10])
        {
            Caption = 'Grupo Precio PVP';
            Description = 'MdM';
            TableRelation = "Customer Price Group".Code;
        }
        field(7; "Grupo Precio PROM"; Code[10])
        {
            Caption = 'Grupo Precio PROM';
            Description = 'MdM';
            TableRelation = "Customer Price Group".Code;
        }
        field(8; "URL Async Reply"; Text[250])
        {
            Caption = 'MdM URL Async Reply';
            Description = 'MdM';
        }
        field(9; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Tax Bus. Posting Gr. (Price For Migration)';
            Description = 'MdM';
            TableRelation = "VAT Business Posting Group";
        }
        field(15; "URL Notif.MdM"; Text[250])
        {
            Caption = 'URL Notif. MdM';
            Description = 'MdM';
        }
        field(21; "Control ISBN"; Boolean)
        {
            Caption = 'Control ISBN';
        }
        field(22; "Dias Borrado Historico"; Integer)
        {
            Caption = 'Dias Borrado Histórico';
            Description = 'Indica con cuantos días tiene que borrarse el histórico.0 No se borra nunca';
        }
        field(25; "Notifica a MdM"; Boolean)
        {
            Caption = 'Notifica a MdM';
            Description = 'Notifica cambios de productos a MdM';
        }
        field(28; "Obliga Campos MdM"; Boolean)
        {
            Caption = 'Obliga Campos MdM';
            Description = 'Genera error si no rellenan debidamente todos los campos MdM';
        }
        field(29; "Activar Cola Proy. Auto."; Boolean)
        {
            Caption = 'Activar Cola Proy. Auto.';
            Description = 'Si se activa, la cola de proyecto se activara automaticamente y el mov se activara y desactivara';
        }
        field(30; "Mov. cola proyecto"; Guid)
        {
            Caption = 'Job Queue Entry';
            TableRelation = "Job Queue Entry".ID;
        }
        field(31; "Cola proyecto"; Code[10])
        {
            Caption = 'Job Queue';
        }
        field(33; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(34; "Divisa Local MdM"; Code[10])
        {
        }
        field(35; "Job Queue Category"; Code[10])
        {
            Caption = 'Job Queue Category';
            Description = 'Categoria de Cola de proyecto relacioando con MdM';
            TableRelation = "Job Queue Category";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(37; "Sistema Origen"; Text[30])
        {
        }
        field(40; "Tipo Precio Venta"; Option)
        {
            Caption = 'Tipo Precio Venta';
            OptionMembers = "Todos clientes","Grupo precio cliente","Sin Filtrar";

            trigger OnValidate()
            begin
                "Grupo Precio Cliente" := '';
            end;
        }
        field(41; "Grupo Precio Cliente"; Code[20])
        {
            Caption = 'Grupo Precio Cliente';
            TableRelation = "Customer Price Group".Code;

            trigger OnValidate()
            begin
                if "Grupo Precio Cliente" <> '' then
                    TestField("Tipo Precio Venta", "Tipo Precio Venta"::"Grupo precio cliente");
            end;
        }
        field(50; "Estado Inactivo"; Code[10])
        {
            TableRelation = "Datos MDM".Codigo WHERE (Tipo = CONST (Estado));
        }
        field(100; "Serie Producto"; Code[10])
        {
            Caption = 'Serie Producto';
            TableRelation = "No. Series";
        }
        field(1001; "Dim Serie/Metodo"; Code[20])
        {
            Caption = 'Dim Serie/Metodo';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Serie/Metodo", 0);
            end;
        }
        field(1002; "Dim Destino"; Code[20])
        {
            Caption = 'Dim Destino';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Destino", 1);
            end;
        }
        field(1003; "Dim Cuenta"; Code[20])
        {
            Caption = 'Dim Cuenta';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Cuenta", 2);
            end;
        }
        field(1004; "Dim Tipo Texto"; Code[20])
        {
            Caption = 'Dim Tipo Texto';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Tipo Texto", 3);
            end;
        }
        field(1005; "Dim Materia"; Code[20])
        {
            Caption = 'Dim Materia';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Materia", 4);
            end;
        }
        field(1006; "Dim Carga Horaria"; Code[20])
        {
            Caption = 'Dim Carga Horaria';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Carga Horaria", 5);
            end;
        }
        field(1007; "Dim Origen"; Code[20])
        {
            Caption = 'Dim Origen';
            Description = 'MDM';
            TableRelation = Dimension.Code;

            trigger OnValidate()
            begin
                cFuncMdM.SetTipoDim("Dim Origen", 6);
            end;
        }
        field(50000; Pruebas; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Activo := true;
    end;

    trigger OnModify()
    begin
        Activo := true;
    end;

    var
        cFuncMdM: Codeunit "Funciones MdM";
}

