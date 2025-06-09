table 75006 "Conf. Tipologias MdM"
{
    Caption = 'Conf. Tipologias MdM';
    DrillDownPageID = "Conf. Tipologias MdM";
    LookupPageID = "Conf. Tipologias MdM";

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
        }
        field(10; Tipologia; Code[10])
        {
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                "Product Group Code" := '';
            end;
        }
        field(51; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(52; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(53; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Tax Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(54; "Costing Method"; Option)
        {
            Caption = 'Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(55; "Item Disc. Group"; Code[20])
        {
            Caption = 'Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(97; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(98; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Item Category".Code WHERE("Parent Category" = FIELD(Tipologia));
        }
        field(1001; "Referencia 1"; Code[20])
        {
            CaptionClass = '75000,1';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(1),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(1, "Referencia 1");
            end;
        }
        field(1002; "Referencia 2"; Code[20])
        {
            CaptionClass = '75000,2';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(2),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(2, "Referencia 2");
            end;
        }
        field(1003; "Referencia 3"; Code[20])
        {
            CaptionClass = '75000,3';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(3),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(3, "Referencia 3");
            end;
        }
        field(1004; "Referencia 4"; Code[20])
        {
            CaptionClass = '75000,4';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(4),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(4, "Referencia 4");
            end;
        }
        field(1005; "Referencia 5"; Code[20])
        {
            CaptionClass = '75000,5';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(5),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(5, "Referencia 5");
            end;
        }
        field(1006; "Referencia 6"; Code[20])
        {
            CaptionClass = '75000,6';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(6),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(6, "Referencia 6");
            end;
        }
        field(1007; "Referencia 7"; Code[20])
        {
            CaptionClass = '75000,7';
            TableRelation = "Valores Filtros Tipologia MdM".Code WHERE("Id Filtro" = CONST(7),
                                                                        "Filtro Tipologia" = FIELD(Tipologia));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                ValidaReferencia(7, "Referencia 7");
            end;
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
        TestDupl;
    end;

    trigger OnModify()
    begin
        TestDupl;
    end;

    var
        Text0001: Label 'Ya existe una configuración %1';
        cFunMdm: Codeunit "Funciones MdM";
        Text0002: Label 'El Valor %1 No puede permanecer vacio';


    procedure TestDupl()
    var
        lrConfTipo: Record "Conf. Tipologias MdM";
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lwNo: Integer;
    begin
        // TestDupl
        // Comprueba que no se duplique la configuración para la misma combinación

        Clear(lrConfTipo);
        TestField(Tipologia);
        lrConfTipo.SetRange(Tipologia, Tipologia);
        for lwNo := 1 to lrFiltroTipo.MaxId do begin
            if lrFiltroTipo.Get(lwNo) then begin
                TestFieldRef(lwNo);
                lrConfTipo.SetFilterRef(lwNo, GetRefValue(lwNo));
            end;
        end;

        lrConfTipo.SetFilter(Id, '<>%1', Id);
        if lrConfTipo.FindFirst then
            Error(Text0001, lrConfTipo.GetFilters);
    end;


    procedure ValidaReferencia(pwId: Integer; pwValor: Code[20])
    var
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lrDatosMdM: Record "Datos MDM";
        lwCodDim: Code[20];
        lrValDim: Record "Dimension Value";
        ItemCategory: Record "Item Category";
    begin
        // ValidaReferencia
        // Valida que el valor sea Correcto

        if pwValor = '' then
            exit;

        if lrFiltroTipo.Get(pwId) then begin
            case lrFiltroTipo.Tipo of
                lrFiltroTipo.Tipo::Dimension:
                    begin
                        lwCodDim := cFunMdm.GetDimCode(lrFiltroTipo."Valor Id", true);
                        lrValDim.Get(lwCodDim, pwValor);
                    end;
                lrFiltroTipo.Tipo::"Dato MdM":
                    begin
                        Clear(lrDatosMdM);
                        lrDatosMdM.Get(lrFiltroTipo."Valor Id", pwValor);
                    end;
                lrFiltroTipo.Tipo::Otros:
                    begin
                        case lrFiltroTipo."Valor Id" of
                            1:
                                begin 
                                    if not ItemCategory.Get(pwValor) then
                                        Error('El Código de Categoría de Producto "%1" no existe.', pwValor);
                                    if ItemCategory."Parent Category" <> Tipologia then
                                        Error('La categoría "%1" no pertenece a la Tipología "%2".', pwValor, Tipologia);
                                end;
                        end;
                    end;
            end;
        end;
    end;


    procedure TestFieldRef(pwId: Integer)
    var
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        wRcRef: RecordRef;
        wFieldRef: FieldRef;
        lwIdF: Integer;
        lwCode: Code[20];
        lwName: Text;
    begin
        // TestFieldRef

        wRcRef.GetTable(Rec);
        lwIdF := 1000 + pwId;
        wFieldRef := wRcRef.Field(lwIdF);
        lwCode := wFieldRef.Value;
        if lwCode = '' then begin
            lwName := lrFiltroTipo.GetFiltDescrpt(pwId);
            Error(Text0002, lwName);
        end;
    end;


    procedure TesAlltFieldsRef()
    var
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lrNo: Integer;
    begin
        // TesAlltFieldsRef
        // Comprueba que se hayan rellenado todos los campos configurados

        TestField(Tipologia);
        for lrNo := 1 to lrFiltroTipo.MaxId do begin
            if lrFiltroTipo.Get(lrNo) then
                TestFieldRef(lrNo);
        end;
    end;


    procedure GetRefValue(pwId: Integer) Result: Code[20]
    begin
        // GetRefValue
        // Devuelve el valor del registro

        case pwId of
            1:
                Result := "Referencia 1";
            2:
                Result := "Referencia 2";
            3:
                Result := "Referencia 3";
            4:
                Result := "Referencia 4";
            5:
                Result := "Referencia 5";
            6:
                Result := "Referencia 6";
            7:
                Result := "Referencia 7";
        end;
    end;


    procedure SetFilterRef(pwId: Integer; pwValue: Code[20])
    begin
        // SetFilterRef

        case pwId of
            1:
                SetRange("Referencia 1", pwValue);
            2:
                SetRange("Referencia 2", pwValue);
            3:
                SetRange("Referencia 3", pwValue);
            4:
                SetRange("Referencia 4", pwValue);
            5:
                SetRange("Referencia 5", pwValue);
            6:
                SetRange("Referencia 6", pwValue);
            7:
                SetRange("Referencia 7", pwValue);
        end;
    end;
}

