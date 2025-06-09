table 75007 "Conversion NAV MdM"
{
    DrillDownPageID = "Conversion NAV MdM";
    LookupPageID = "Conversion NAV MdM";

    fields
    {
        field(1; "Tipo Registro"; Option)
        {
            OptionMembers = "Codigo Producto",ISBN,"ISBN Tramitado",EAN,"Encuadernación",Sello,Idioma,"Serie/Método",Autor,"Formato Digital","Peso Digital Unidad","Tipo Protección","País","Edición",Destino,Cuenta,Estado,"Tipo Texto",Materia,"Nivel Escolar","Carga Horaria",Origen,"Artículo Pack","Vida util";

            trigger OnValidate()
            begin
                SetDimFilter;
            end;
        }
        field(2; "Codigo MdM"; Code[20])
        {

            trigger OnValidate()
            var
                lwMaxLng: Integer;
                lwLng: Integer;
            begin

                lwLng := StrLen("Codigo NAV");
                if lwLng > 0 then begin
                    if "Tipo Registro" = "Tipo Registro"::ISBN then begin
                        "Codigo NAV" := DelChr("Codigo NAV", '=', '-'); //Eliminamos los guiones
                        rConfMdM.Get;
                        if rConfMdM."Control ISBN" then
                            cFunMdM.ControlIBN("Codigo NAV", true);
                    end;
                end;

                // Controlamos la longitud máxima
                lwMaxLng := GetMaxLen;
                lwLng := StrLen("Codigo NAV");
                if lwMaxLng > 0 then begin
                    if lwLng > lwMaxLng then
                        Error(Text001, "Tipo Registro", lwMaxLng);
                end;
            end;
        }
        field(3; "Codigo NAV"; Code[20])
        {
            TableRelation = IF ("Tipo Registro" = CONST("Codigo Producto")) Item."No."
            ELSE
            IF ("Tipo Registro" = CONST(Idioma)) Language.Code
            ELSE
            IF ("Tipo Registro" = CONST(Autor)) "Datos MDM".Codigo WHERE(Tipo = CONST(Autor))
            ELSE
            IF ("Tipo Registro" = CONST("País")) "Country/Region".Code
            ELSE
            IF ("Tipo Registro" = CONST("Edición")) Edicion.Codigo
            ELSE
            IF ("Tipo Registro" = CONST(Estado)) "Estado productos"."Código"
            ELSE
            IF ("Tipo Registro" = CONST("Nivel Escolar")) "Datos MDM".Codigo WHERE(Tipo = CONST(Grado))
            ELSE
            IF ("Tipo Registro" = CONST("Artículo Pack")) "Production BOM Line"."No."
            ELSE
            IF ("Tipo Registro" = FILTER("Serie/Método" | Destino | Cuenta | "Tipo Texto" | Materia | "Carga Horaria" | Origen)) "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dim Code Filter"));

            trigger OnValidate()
            var
                lwIdDim: Integer;
                lwDimCode: Code[20];
                lrDimVal: Record "Dimension Value";
            begin


                /* las relaciones ya hacen la comprobacion
                IF "Codigo NAV" <> '' THEN BEGIN
                
                  // Valores que están relacionados con dimensiones
                  // Validamos el valor
                  lwIdDim := GetDimId;
                  IF lwIdDim > -1 THEN BEGIN
                    lwDimCode := cFunMdM.GetDimCode(lwIdDim,TRUE);
                    lrDimVal.GET(lwDimCode, "Codigo NAV");
                  END;
                END;
                */

            end;
        }
        field(100; "Dim Code Filter"; Code[20])
        {
            Description = 'Flowfilter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Tipo Registro", "Codigo MdM")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cFunMdM: Codeunit "Funciones MdM";
        Text001: Label 'La longitud máxima para %1 es %2';
        rConfMdM: Record "Configuracion MDM";


    procedure GetNav2MdM(pTipo: Integer; pNavCode: Code[20]; pwTest: Boolean): Code[20]
    var
        lwOK: Boolean;
        lrConv: Record "Conversion NAV MdM";
    begin
        // GetNav2MdM
        // Si se pasa pwTest como true, validará que el valor exista realmente

        lwOK := pwTest;

        Clear(lrConv);
        lrConv.SetRange("Tipo Registro", pTipo);
        lrConv.SetRange("Codigo NAV", pNavCode);
        if pwTest then
            lrConv.FindFirst
        else
            lwOK := lrConv.FindFirst;

        if lwOK then
            exit(lrConv."Codigo MdM")
        else
            exit(pNavCode);
    end;


    procedure GetMdm2NAV(pTipo: Integer; pMdMCode: Code[20]; var pNavCode: Code[20]; pwForce: Boolean; pwError: Boolean) wOK: Boolean
    var
        lrConv: Record "Conversion NAV MdM";
    begin
        // GetMdm2NAV
        // Tener en cuenta que pwError y pwForce No son compatibles obviamente

        wOK := false;
        Clear(lrConv);
        if pwError then begin
            lrConv.Get(pTipo, pMdMCode);
            wOK := true;
        end
        else
            wOK := lrConv.Get(pTipo, pMdMCode);

        if wOK then begin
            pNavCode := lrConv."Codigo NAV";
        end
        else begin
            if pwForce then // Si no existe, lo crea utilizando el valor pNavCode por defecto
                wOK := SetNav2Mdm(pTipo, pNavCode, pMdMCode);
        end;
    end;


    procedure SetNav2Mdm(pTipo: Integer; pNavCode: Code[20]; pMdMCode: Code[20]) Rslt: Boolean
    var
        lrConv: Record "Conversion NAV MdM";
    begin

        Rslt := (pMdMCode <> '') and (pNavCode <> '') and (pNavCode <> pMdMCode);

        Clear(lrConv);
        if lrConv.Get(pTipo, pMdMCode) then begin
            if Rslt then begin
                if lrConv."Codigo NAV" <> pNavCode then begin
                    lrConv."Codigo NAV" := pNavCode;
                    lrConv.Modify;
                end;
            end
            else
                lrConv.Delete;
        end
        else
            if Rslt then begin
                lrConv."Tipo Registro" := pTipo;
                lrConv."Codigo MdM" := pMdMCode;
                lrConv."Codigo NAV" := pNavCode;
                lrConv.Insert;
            end;
    end;


    procedure GetDimId() wId: Integer
    begin
        // GetDimId

        wId := -1;
        case "Tipo Registro" of
            "Tipo Registro"::"Serie/Método":
                wId := 0;
            "Tipo Registro"::Destino:
                wId := 1;
            "Tipo Registro"::Cuenta:
                wId := 2;
            "Tipo Registro"::"Tipo Texto":
                wId := 3;
            "Tipo Registro"::Materia:
                wId := 4;
            "Tipo Registro"::"Carga Horaria":
                wId := 5;
            "Tipo Registro"::Origen:
                wId := 6;
        end;
    end;


    procedure GetTipoDim(pwId: Integer) wTipo: Integer
    begin
        // GetTipoDim

        wTipo := -1;
        case pwId of
            0:
                wTipo := "Tipo Registro"::"Serie/Método";
            1:
                wTipo := "Tipo Registro"::Destino;
            2:
                wTipo := "Tipo Registro"::Cuenta;
            3:
                wTipo := "Tipo Registro"::"Tipo Texto";
            4:
                wTipo := "Tipo Registro"::Materia;
            5:
                wTipo := "Tipo Registro"::"Carga Horaria";
            6:
                wTipo := "Tipo Registro"::Origen;
        end;
    end;


    procedure LookUpDim(lwIdDim: Integer; lrDimVal: Record "Dimension Value"; lwDimCode: Code[20]; lwOK: Boolean)
    begin
        // LookUpDim

        // ********** NO SE UTILIZA **********
        // Se ha solucionado mediante relaciones
        lwIdDim := GetDimId;
        if lwIdDim > -1 then begin
            lwDimCode := cFunMdM.GetDimCode(lwIdDim, true);
            Clear(lrDimVal);
            lrDimVal.FilterGroup(2);
            lrDimVal.SetRange("Dimension Code", lwDimCode);
            lrDimVal.FilterGroup(0);
            lwOK := lrDimVal.Get(lwDimCode, "Codigo MdM"); // Posicionamos el valor por defecto
            if PAGE.RunModal(0, lrDimVal) = ACTION::LookupOK then
                "Codigo MdM" := lrDimVal.Code;
        end;
    end;


    procedure SetDimFilter()
    var
        lwIdDim: Integer;
        lwDimCode: Code[20];
    begin
        // SetDimFilter

        lwIdDim := GetDimId;
        if lwIdDim > -1 then begin
            lwDimCode := cFunMdM.GetDimCode(lwIdDim, true);
            SetRange("Dim Code Filter", lwDimCode);
        end
        else
            SetRange("Dim Code Filter");
    end;


    procedure GetMaxLen() wMax: Integer
    begin
        // GetMaxLen
        // Devuelve la longitud máxima según el tipo

        wMax := 0;
        case "Tipo Registro" of
            "Tipo Registro"::"Codigo Producto":
                wMax := 10;
            "Tipo Registro"::ISBN:
                wMax := 13;
            "Tipo Registro"::"ISBN Tramitado":
                wMax := 10;
            "Tipo Registro"::EAN:
                wMax := 13;
            "Tipo Registro"::"Encuadernación":
                wMax := 10;
            "Tipo Registro"::Sello:
                wMax := 10;
            "Tipo Registro"::Idioma:
                wMax := 10;
            "Tipo Registro"::"Serie/Método":
                wMax := 10;
            "Tipo Registro"::Autor:
                wMax := 10;
            "Tipo Registro"::"Formato Digital":
                wMax := 10;
            "Tipo Registro"::"Peso Digital Unidad":
                wMax := 10;
            "Tipo Registro"::"Tipo Protección":
                wMax := 10;
            "Tipo Registro"::"País":
                wMax := 10;
            "Tipo Registro"::"Edición":
                wMax := 10;
            "Tipo Registro"::Destino:
                wMax := 10;
            "Tipo Registro"::Cuenta:
                wMax := 10;
            "Tipo Registro"::Estado:
                wMax := 10;
            "Tipo Registro"::"Tipo Texto":
                wMax := 10;
            "Tipo Registro"::Materia:
                wMax := 10;
            "Tipo Registro"::"Nivel Escolar":
                wMax := 10;
            "Tipo Registro"::"Carga Horaria":
                wMax := 10;
            "Tipo Registro"::Origen:
                wMax := 10;
            "Tipo Registro"::"Artículo Pack":
                wMax := 10;
            "Tipo Registro"::"Vida util":
                wMax := 10;
        end;
    end;


    procedure GetTipoTable(prImpTabl: Record "Imp.MdM Tabla" temporary) pwTipo: Integer
    begin
        // GetTipoTable

        pwTipo := -1;
        case prImpTabl."Id Tabla" of
            27:
                pwTipo := "Tipo Registro"::"Codigo Producto";
            //"Tipo Registro"::ISBN;
            //"Tipo Registro"::"ISBN Tramitado";
            //"Tipo Registro"::EAN;
            //"Tipo Registro"::Encuadernación;
            56003:
                pwTipo := "Tipo Registro"::Sello;
            8:
                pwTipo := "Tipo Registro"::Idioma;
            349:
                begin // Dimensiones
                    case prImpTabl.Tipo of
                        0:
                            pwTipo := "Tipo Registro"::"Serie/Método";
                        1:
                            pwTipo := "Tipo Registro"::Destino;
                        2:
                            pwTipo := "Tipo Registro"::Cuenta;
                        3:
                            pwTipo := "Tipo Registro"::"Tipo Texto";
                        4:
                            pwTipo := "Tipo Registro"::Materia;
                        5:
                            pwTipo := "Tipo Registro"::"Carga Horaria";
                        6:
                            pwTipo := "Tipo Registro"::Origen;
                    end;
                end;
            75001:
                begin // Datos Mdm
                    case prImpTabl.Tipo of
                        5:
                            pwTipo := "Tipo Registro"::Autor;
                        9:
                            pwTipo := "Tipo Registro"::"Nivel Escolar";
                    end;
                end;

            //"Tipo Registro"::"Formato Digital";
            //"Tipo Registro"::"Peso Digital Unidad";
            //"Tipo Registro"::"Tipo Protección";
            9:
                pwTipo := "Tipo Registro"::"País";
            56007:
                pwTipo := "Tipo Registro"::"Edición";
            56008:
                pwTipo := "Tipo Registro"::Estado;
            90:
                pwTipo := "Tipo Registro"::"Artículo Pack";
        //"Tipo Registro"::"Vida util";
        end;
    end;


    procedure GetTipoField(prImpTabl: Record "Imp.MdM Tabla" temporary; prField: Record "Imp.MdM Campos" temporary) pwTipo: Integer
    begin
        // GetTipoTable

        pwTipo := -1;
        case prImpTabl."Id Tabla" of
            27:
                begin // PRODUCTO
                    case prField."Id Field" of
                        1, 2:
                            pwTipo := "Tipo Registro"::"Codigo Producto";
                        50002:
                            pwTipo := "Tipo Registro"::ISBN;
                        //"Tipo Registro"::"ISBN Tramitado";
                        -499 .. -400:
                            pwTipo := "Tipo Registro"::EAN;
                        //"Tipo Registro"::Encuadernación;
                        56010:
                            pwTipo := "Tipo Registro"::Sello;
                        56013:
                            pwTipo := "Tipo Registro"::Idioma;
                        // Dimensiones
                        -200:
                            pwTipo := "Tipo Registro"::"Serie/Método";
                        -201:
                            pwTipo := "Tipo Registro"::Destino;
                        -202:
                            pwTipo := "Tipo Registro"::Cuenta;
                        -203:
                            pwTipo := "Tipo Registro"::"Tipo Texto";
                        -204:
                            pwTipo := "Tipo Registro"::Materia;
                        -205:
                            pwTipo := "Tipo Registro"::"Carga Horaria";
                        -206:
                            pwTipo := "Tipo Registro"::Origen;

                        56015:
                            pwTipo := "Tipo Registro"::Autor;
                        50005:
                            pwTipo := "Tipo Registro"::"Nivel Escolar";

                        //"Tipo Registro"::"Formato Digital";
                        //"Tipo Registro"::"Peso Digital Unidad";
                        //"Tipo Registro"::"Tipo Protección";
                        95:
                            pwTipo := "Tipo Registro"::"País";
                        56007:
                            pwTipo := "Tipo Registro"::"Edición";
                        56008:
                            pwTipo := "Tipo Registro"::Estado;
                        -110:
                            pwTipo := "Tipo Registro"::"Artículo Pack";
                    //"Tipo Registro"::"Vida util";
                    end;
                end;
            349:
                if prField."Id Field" = 2 then begin // Dimensiones
                    case prImpTabl.Tipo of
                        0:
                            pwTipo := "Tipo Registro"::"Serie/Método";
                        1:
                            pwTipo := "Tipo Registro"::Destino;
                        2:
                            pwTipo := "Tipo Registro"::Cuenta;
                        3:
                            pwTipo := "Tipo Registro"::"Tipo Texto";
                        4:
                            pwTipo := "Tipo Registro"::Materia;
                        5:
                            pwTipo := "Tipo Registro"::"Carga Horaria";
                        6:
                            pwTipo := "Tipo Registro"::Origen;
                    end;
                end;
        end;

        if pwTipo = -1 then begin
            if prImpTabl.GetIdCodeField = prField."Id Field" then begin
                case prImpTabl."Id Tabla" of
                    56003:
                        pwTipo := "Tipo Registro"::Sello;
                    8:
                        pwTipo := "Tipo Registro"::Idioma;
                    9:
                        pwTipo := "Tipo Registro"::"País";
                    56007:
                        pwTipo := "Tipo Registro"::"Edición";
                    56008:
                        pwTipo := "Tipo Registro"::Estado;
                    75001:
                        begin // Datos Mdm
                            case prImpTabl.Tipo of
                                5:
                                    pwTipo := "Tipo Registro"::Autor;
                                9:
                                    pwTipo := "Tipo Registro"::"Nivel Escolar";
                            end;
                        end;
                end;
            end;
        end;
    end;
}

