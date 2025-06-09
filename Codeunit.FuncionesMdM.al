codeunit 75000 "Funciones MdM"
{
    // 
    // 
    // Dimensiones:
    //   0 SerieMetodo
    //   1 Destino
    //   2 Cuenta
    //   3 TipoTexto
    //   4 Materia
    //   5 CargaHoraria
    //   6 Origen
    // 
    // 
    // #209115 JPT 03/04/2019  Gestionamos el control de rellenado automatico de las fechas MdM de producto


    trigger OnRun()
    begin
    end;

    var
        wConfMdM: Record "Configuracion MDM";
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        ErrEditDim: Label 'No puede editar esta dimensión predeterminada para este producto, se gestiona por el MdM.';
        ErrEditDim2: Label 'No puede editar esta dimensión, se gestiona por MdM.';
        ErrEditTable: Label 'No puede editar %1. Se gestiona por MdM';
        ErrISBN: Label 'El código ISBN %1 No es correcto';
        ErrFieldM: Label 'Debe de rellenar el valor %1';
        lrDim: Record Dimension;
        rTmpBuff: Record "Fechas Productos MdM Buffer" temporary;


    procedure GetTotalGestDim(): Integer
    begin
        // GetTotalGestDim
        // Devuelve el total de dimensiones gestionadas por MdM
        // Se define aqui por si hay que ampliar alguna

        exit(7);
    end;


    procedure GetDimValueT(pwCodProd: Code[20]; pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen): Code[20]
    var
        lwDimCode: Code[20];
    begin
        // GetDimValueT
        // Devuelve el valor de una dimension determinada (por Tipo)

        lwDimCode := GetDimCode(pwTipoDim, false);
        exit(GetDimValueC(pwCodProd, lwDimCode));
    end;


    procedure GetDimValueC(pwCodProd: Code[20]; pwCode: Code[20]): Code[20]
    var
        lrDefDim: Record "Default Dimension";
    begin
        // GetDimValueC
        // Devuelve el valor de una dimension determinada (por Codigo)

        Clear(lrDefDim);
        if lrDefDim.Get(27, pwCodProd, pwCode) then
            exit(lrDefDim."Dimension Value Code");
    end;


    procedure GetDimCode(pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen; pwTest: Boolean) wCode: Code[20]
    begin
        // GetDimCode
        // Devuelve el Código de una dimension determinada

        GetConfM;

        wCode := '';

        if pwTest then begin
            case pwTipoDim of
                pwTipoDim::SerieMetodo:
                    wConfMdM.TestField("Dim Serie/Metodo");
                pwTipoDim::Destino:
                    wConfMdM.TestField("Dim Destino");
                pwTipoDim::Cuenta:
                    wConfMdM.TestField("Dim Cuenta");
                pwTipoDim::TipoTexto:
                    wConfMdM.TestField("Dim Tipo Texto");
                pwTipoDim::Materia:
                    wConfMdM.TestField("Dim Materia");
                pwTipoDim::CargaHoraria:
                    wConfMdM.TestField("Dim Carga Horaria");
                pwTipoDim::Origen:
                    wConfMdM.TestField("Dim Origen");
            end;
        end;

        case pwTipoDim of
            pwTipoDim::SerieMetodo:
                wCode := wConfMdM."Dim Serie/Metodo";
            pwTipoDim::Destino:
                wCode := wConfMdM."Dim Destino";
            pwTipoDim::Cuenta:
                wCode := wConfMdM."Dim Cuenta";
            pwTipoDim::TipoTexto:
                wCode := wConfMdM."Dim Tipo Texto";
            pwTipoDim::Materia:
                wCode := wConfMdM."Dim Materia";
            pwTipoDim::CargaHoraria:
                wCode := wConfMdM."Dim Carga Horaria";
            pwTipoDim::Origen:
                wCode := wConfMdM."Dim Origen";
        end;
    end;


    procedure GetDimCodeName(pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen): Text[30]
    var
        lrDim: Record Dimension;
        lwDimCode: Code[20];
    begin
        // GetDimCodeName
        // Devuelve el nombre de un codigo de dimensión

        lwDimCode := GetDimCode(pwTipoDim, false);
        Clear(lrDim);
        if lrDim.Get(lwDimCode) then
            exit(lrDim.Name);
    end;


    procedure GetDimValueName(pwCodProd: Code[20]; pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen): Text[50]
    var
        lrDimVal: Record "Dimension Value";
        lwDimValue: Code[20];
        lwDimCode: Code[20];
    begin
        // GetDimValueName
        // Devuelve el nombre de un valor de dimensión

        lwDimCode := GetDimCode(pwTipoDim, false);
        lwDimValue := GetDimValueC(pwCodProd, lwDimCode);

        Clear(lrDimVal);
        if lrDimVal.Get(lwDimCode, lwDimValue) then
            exit(lrDimVal.Name);
    end;


    procedure GetDimNameField(pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen) wName: Text
    var
        lText001: Label 'Serie';
        lText002: Label 'Destino';
        lText003: Label 'Cuenta';
        lText004: Label 'Tipo Texto';
        lText005: Label 'Materia';
        lText006: Label 'Carga Horaria';
        lText007: Label 'Origen';
    begin
        // GetDimNameField

        wName := '';
        case pwTipoDim of
            pwTipoDim::SerieMetodo:
                wName := lText001;
            pwTipoDim::Destino:
                wName := lText002;
            pwTipoDim::Cuenta:
                wName := lText003;
            pwTipoDim::TipoTexto:
                wName := lText004;
            pwTipoDim::Materia:
                wName := lText005;
            pwTipoDim::CargaHoraria:
                wName := lText006;
            pwTipoDim::Origen:
                wName := lText007;
        end;
    end;


    procedure TestDimValT(pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen; pwValue: Code[20])
    var
        lwDimCode: Code[20];
    begin
        // TestDimValT

        lwDimCode := GetDimCode(pwTipoDim, true);
        TestDimValC(lwDimCode, pwValue);
    end;


    procedure TestDimValC(pwDimCode: Code[20]; pwValue: Code[20])
    var
        lrDimVal: Record "Dimension Value";
    begin
        // TestDimValC
        // Comprueba que exista el valor de dimensión

        Clear(lrDimVal);
        if pwValue <> '' then
            lrDimVal.Get(pwDimCode, pwValue);
    end;


    procedure ExistDimValT(pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen; pwValue: Code[20]) Result: Boolean
    var
        lwDimCode: Code[20];
    begin
        // ExistDimValT

        lwDimCode := GetDimCode(pwTipoDim, true);
        Result := ExistDimValC(lwDimCode, pwValue);
    end;


    procedure ExistDimValC(pwDimCode: Code[20]; pwValue: Code[20]) Result: Boolean
    var
        lrDimVal: Record "Dimension Value";
    begin
        // ExistDimValC
        // Devuelve true si existe el valor de dimensión

        Clear(lrDimVal);
        Result := lrDimVal.Get(pwDimCode, pwValue);
    end;


    procedure ValidaDimValT(var prProd: Record Item; pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen; pwValue: Code[20])
    var
        lwDimCode: Code[20];
    begin
        // ValidaDimValT
        // Valida una dimensión

        lwDimCode := GetDimCode(pwTipoDim, true);
        ValidaDimValC(prProd, lwDimCode, pwValue);
    end;


    procedure ValidaDimValC(var prProd: Record Item; pwDimCode: Code[20]; pwValue: Code[20])
    var
        lrDefDim: Record "Default Dimension";
        lwExists: Boolean;
    begin
        // ValidaDimValC
        // Valida una dimensión

        // Comprueba que exista
        TestDimValC(pwDimCode, pwValue);

        Clear(lrDefDim);
        lwExists := lrDefDim.Get(27, prProd."No.", pwDimCode);

        if pwValue = '' then begin
            if lwExists then
                lrDefDim.Delete;
        end
        else begin
            GetConfM;
            if not lwExists then begin
                Clear(lrDefDim);
                lrDefDim.Validate("Table ID", 27);
                lrDefDim.Validate("No.", prProd."No.");
                lrDefDim.Validate("Dimension Code", pwDimCode);
                lrDefDim.Validate("Dimension Value Code", pwValue);
                /*
                IF pwDimCode IN [wConfMdM."Dim Carga Horaria",wConfMdM."Dim Destino",wConfMdM."Dim Origen",wConfMdM."Dim Tipo Texto"] THEN
                  lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Same Code"
                ELSE
                  lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Code Mandatory";
                */
                lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Same Code";
                lrDefDim.Insert;
                //lrDefDim.INSERT(TRUE);
            end
            else begin
                if lrDefDim."Dimension Value Code" <> pwValue then
                    lrDefDim.Validate("Dimension Value Code", pwValue);
                /*
                IF pwDimCode IN [wConfMdM."Dim Carga Horaria",wConfMdM."Dim Destino",wConfMdM."Dim Origen",wConfMdM."Dim Tipo Texto"] THEN
                  lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Same Code"
                ELSE
                  lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Code Mandatory";
                */
                lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Same Code";
                lrDefDim.Modify
                //lrDefDim.MODIFY(TRUE);
            end;
        end;

        SetGlobalDim(prProd, pwDimCode, pwValue);

    end;


    procedure GetDimValueLookupT(pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen; pwDefault: Code[20]): Code[20]
    var
        lwDimCode: Code[20];
    begin
        // GetDimValueLookupT
        // Devuelve un codigo de valor de la lista solicitado (Por Tipo)

        lwDimCode := GetDimCode(pwTipoDim, true);
        exit(GetDimValueLookupC(lwDimCode, pwDefault));
    end;


    procedure GetDimValueLookupC(pwDimCode: Code[20]; pwDefault: Code[20]) wCode: Code[20]
    var
        lrDimVal: Record "Dimension Value";
        lwOK: Boolean;
    begin
        // GetDimValueLookupC
        // Devuelve un codigo de valor de la lista solicitado (Por Codigo)

        wCode := '';
        if pwDimCode = '' then
            exit;

        Clear(lrDimVal);
        lrDimVal.FilterGroup(2);
        lrDimVal.SetRange("Dimension Code", pwDimCode);
        lrDimVal.SetRange(Blocked, false);
        lrDimVal.FilterGroup(0);
        if pwDefault <> '' then
            lwOK := lrDimVal.Get(pwDimCode, pwDefault); // Posicionamos el valor por defecto
        if PAGE.RunModal(0, lrDimVal) = ACTION::LookupOK then
            wCode := lrDimVal.Code;
    end;


    procedure ExecDimValLookupT(prProd: Record Item; pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen)
    var
        lwDimCode: Code[20];
    begin
        // ExecDimValLookupT
        // Solicita un codigo de valor de dimensión y lo valida. (Por Tipo)

        lwDimCode := GetDimCode(pwTipoDim, true);
        ExecDimValLookupC(prProd, lwDimCode);
    end;


    procedure ExecDimValLookupC(prProd: Record Item; pwDimCode: Code[20])
    var
        lwValue: Code[20];
        lwDefault: Code[20];
    begin
        // ExecDimValLookupC
        // Solicita un codigo de valor de dimensión y lo valida (Por Codigo)

        lwDefault := GetDimValueC(prProd."No.", pwDimCode);
        lwValue := GetDimValueLookupC(pwDimCode, lwDefault);
        if lwValue <> '' then
            ValidaDimValC(prProd, pwDimCode, lwValue);
    end;


    procedure ShowDimT(prProd: Record Item; pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen)
    var
        lwDimCode: Code[20];
    begin
        // ShowDimT
        // Muestra la dimensión establecida

        lwDimCode := GetDimCode(pwTipoDim, true);
        ShowDimC(prProd, lwDimCode);
    end;


    procedure ShowDimC(prProd: Record Item; pwDimCode: Code[20])
    var
        lrDefDim: Record "Default Dimension";
        lrDimVal: Record "Dimension Value";
        lwPag: Page "Default Dimensions";
        lwEnc: Boolean;
    begin
        // ShowDimC
        // Muestra la dimensión establecida

        Clear(lrDimVal);
        lrDimVal.SetRange("Dimension Code", pwDimCode);
        lrDimVal.SetRange(Blocked, false);
        if PAGE.RunModal(0, lrDimVal) = ACTION::LookupOK then begin
            Clear(lrDefDim);
            lrDefDim.SetRange("Table ID", 27);
            lrDefDim.SetRange("No.", prProd."No.");
            lrDefDim.SetRange("Dimension Code", pwDimCode);
            lwEnc := lrDefDim.FindFirst;
            if not lwEnc then begin
                lrDefDim.Validate("Table ID", 27);
                lrDefDim.Validate("No.", prProd."No.");
                lrDefDim.Validate("Dimension Code", pwDimCode);
            end;
            lrDefDim.Validate("Dimension Value Code", lrDimVal.Code);
            lrDefDim."Value Posting" := lrDefDim."Value Posting"::"Same Code";
            if lwEnc then
                lrDefDim.Modify(true)
            else
                lrDefDim.Insert(true);
        end;

        /*
        
        CLEAR(lrDefDim);
        lrDefDim.SETRANGE("Table ID"      , 27);
        lrDefDim.SETRANGE("No."           , prProd."No.");
        lrDefDim.SETRANGE("Dimension Code", pwDimCode);
        
        
        CLEAR(lwPag);
        // lwPag.SetEditable(wEditaMDM);
        lwPag.SETTABLEVIEW(lrDefDim);
        lwPag.SETRECORD(lrDefDim);
        lwPag.RUN;
        */

    end;


    procedure SetTipoDim(pwCode: Code[20]; pwTipoDim: Option SerieMetodo,Destino,Cuenta,TipoTexto,Materia,CargaHoraria,Origen)
    var
        lrDim: Record Dimension;
    begin
        // SetTipoDim
        // Define el valor "Tipo MdM" de la tabla de Dimensiones en virtud del valor de configuración

        Clear(lrDim);
        if pwCode = '' then begin
            lrDim.SetRange("Tipo MdM", pwTipoDim + 1);
            lrDim.ModifyAll("Tipo MdM", 0);
        end
        else
            if lrDim.Get(pwCode) then begin
                lrDim.Validate("Tipo MdM", pwTipoDim + 1);
                lrDim.Modify;
            end;
    end;


    procedure GetDatoMdM(prProd: Record Item; pwId: Integer) wValue: Code[20]
    var
        lwRecRef: RecordRef;
        lwFieldRef: FieldRef;
        lwIdField: Integer;
    begin
        // GetDatoMdM

        wValue := '';
        lwIdField := 0;
        lwRecRef.GetTable(prProd);

        lwIdField := GetDatoMdMFieldNo(pwId);

        if lwIdField > 0 then begin
            lwFieldRef := lwRecRef.Field(lwIdField);
            wValue := lwFieldRef.Value;
        end;
    end;


    procedure GetDatosOtros(prProd: Record Item; pwId: Integer) wValue: Code[20]
    var
        lwRecRef: RecordRef;
        lwFieldRef: FieldRef;
        lwIdField: Integer;
    begin
        // GetDatosOtros

        wValue := '';
        lwIdField := 0;
        lwRecRef.GetTable(prProd);

        lwIdField := GetOtrosFieldNo(pwId);

        if lwIdField > 0 then begin
            lwFieldRef := lwRecRef.Field(lwIdField);
            wValue := lwFieldRef.Value;
        end;
    end;


    procedure GetDatoMdMCod(pwCodProd: Code[20]; pwId: Integer) wValue: Code[20]
    var
        lrItem: Record Item;
    begin
        // GetDatoMdMCod

        if lrItem.Get(pwCodProd) then
            exit(GetDatoMdM(lrItem, pwId));
    end;


    procedure GetDatoMdMFieldNo(pwId: Integer) wIdField: Integer
    begin
        // GetDatoMdMFieldNo
        // Devuelve el numero de campo en Producto referente al Dato MdM

        case pwId of
            0:
                wIdField := 75001; // Tipo Producto
            1:
                wIdField := 75002; // Soporte
            2:
                wIdField := 75003; // Editora
            3:
                wIdField := 0; // Nivel (No se encuntra)
            5:
                wIdField := 56015; // Autor
            6:
                wIdField := 0; // Ciclo (No se encuntra)
            7:
                wIdField := 75004; // Linea de Negocio
            8:
                wIdField := 75010; // Asignatura
            9:
                wIdField := 50005; // Nivel Escolar (Grado);
            10:
                wIdField := 56010; // Sello
            11:
                wIdField := 56007; // Edicion
            12:
                wIdField := 56008; // Estado
            13:
                wIdField := 75011; // Campaña
        end;
    end;


    procedure GetOtrosFieldNo(pwId: Integer) wIdField: Integer
    begin
        // GetOtrosFieldNo
        // Devuelve el numero de campo en Producto referente al Otros datos

        case pwId of
            1:
                wIdField := 5704; // Cód. Grupo Producto
        end;
    end;


    procedure GetGLSetup()
    begin
        // GetGLSetup

        //IF NOT GLSetupRead THEN
        GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure GetConfM()
    begin
        // GetConfM
        if not wConfMdM.Activo then
            wConfMdM.Get;
    end;


    procedure GetBarCode(prProd: Record Item): Code[20]
    var
        lwRecRef: Record "Item Reference";
    begin
        // GetBarCode

        Clear(lwRecRef);
        lwRecRef.SetRange("Item No.", prProd."No.");
        lwRecRef.SetRange("Variant Code", '');
        //lwRecRef.SetRange("Unit of Measure Code", prProd."Base Unit of Measure");
        lwRecRef.SetRange("Reference Type", lwRecRef."Reference Type"::"Bar Code");
        lwRecRef.SetRange("Reference Type No.", '');
        if lwRecRef.FindFirst then
            exit(lwRecRef."Reference No.");
    end;


    procedure GetDatDescrp(pwTipo: Integer; pwCode: Code[20]) wDesc: Text[100]
    var
        lrDat: Record "Datos MDM";
    begin
        // GetDatDescrp
        // Devuelve la descripción de un dato de la tabla Datos MdM

        wDesc := '';
        if StrLen(pwCode) > MaxStrLen(lrDat.Codigo) then
            exit;
        Clear(lrDat);
        if lrDat.Get(pwTipo, pwCode) then
            wDesc := lrDat.Descripcion;
    end;


    procedure GetEstrcturaAnaliticaDescr(prProd: Record Item) wDesc: Text[100]
    var
        lrEsct: Record "Estructura Analitica";
    begin
        // GetEstrcturaAnaliticaDescr
        // Devuelve la descripción de la estructura analitica

        wDesc := '';
        Clear(lrEsct);
        if lrEsct.Get(prProd."Estructura Analitica") then
            wDesc := lrEsct.Descripcion;
    end;


    procedure GetIdiomaDesc(prProd: Record Item) wDesc: Text[50]
    var
        lrLang: Record Language;
    begin
        // GetIdiomaDesc
        // Devuelve la descripción del idioma

        wDesc := '';
        Clear(lrLang);
        if lrLang.Get(prProd.Idioma) then
            wDesc := lrLang.Name;
    end;


    procedure GetTipologiaDesc(prProd: Record Item) wDesc: Text
    var
        lrItemCat: Record "Item Category";
    begin
        // GetTipologiaDesc

        wDesc := '';
        if lrItemCat.Get(prProd."Item Category Code") then
            wDesc := lrItemCat.Description;
    end;


    procedure GetPaisDesc(prProd: Record Item) wDesc: Text
    var
        lrCountry: Record "Country/Region";
    begin
        // GetPaisDesc

        if lrCountry.Get(prProd."Country/Region of Origin Code") then
            wDesc := lrCountry.Name;
    end;


    procedure GetDatosAuxDesc(pwTipo: Option Aficiones,"Areas de interés",Atenciones,"Canal de venta",Especialidades,Grados,Materiales,"Nivel de decisión","Puestos de trabajo",Rutas,"Tipo de educacion","Tipos de colegios","Tipos de contactos",Turnos,Zonas,"Linea Negocio","Sub familia",Objetivos,Tareas,"Motivos Perdida","Orden religiosa","Asociacion educativa",Materia,"Grupo de Negocio","Equipos T&E","Iniciales Almacen"; pwCode: Code[20]) Result: Text
    var
        lrDatosAux: Record "Datos auxiliares";
    begin
        // GetDatosAuxDesc
        // Devuelve descripcion de Datos Auxiliares (APS)

        Clear(lrDatosAux);
        if lrDatosAux.Get(pwTipo, pwCode) then
            Result := lrDatosAux.Descripcion;
    end;


    procedure GetEAN(prProd: Record Item) wEan: Text
    var
        lrCrossRef: Record "Item Reference";
    begin
        // GetEAN

        wEan := '';
        if prProd."No." = '' then
            exit;

        Clear(lrCrossRef);
        lrCrossRef.SetRange("Item No.", prProd."No.");
        lrCrossRef.SetRange("Reference Type", lrCrossRef."Reference Type"::"Bar Code");
        if lrCrossRef.FindFirst then
            wEan := lrCrossRef."Reference No.";
    end;


    procedure GetEditable() wEditable: Boolean
    var
        lrUserStp: Record "User Setup";
    begin

        // GetEditable

        GetConfM;
        wEditable := not (wConfMdM."Bloquea Datos MDM");

        if (not wEditable) then begin
            if lrUserStp.Get(UserId) then begin
                wEditable := lrUserStp."Editar Prod. MdM Total";
            end;
        end;
    end;


    procedure GetEditableErr(pwIssueName: Text) wEditable: Boolean
    begin
        // GetEditableErr

        wEditable := GetEditable;
        if not wEditable then
            SetEditableError(pwIssueName);
    end;


    procedure SetEditableError(pwIssueName: Text)
    begin
        // SetEditableError

        Error(ErrEditTable, pwIssueName);
    end;


    procedure GetEditableP(prProd: Record Item; pwAut: Boolean) wEditable: Boolean
    var
        lrUserStp: Record "User Setup";
    begin
        // GetEditableP
        // Determina si los campos MdM son editables en un producto
        // pwAut solicita el usuario tiene la marca para modificar parcialmente productos MdM

        GetConfM;

        wEditable := not (wConfMdM."Bloquea Datos MDM" and prProd."Gestionado MdM");
        //wEditable := NOT (wConfMdM."Bloquea Datos MDM");

        if not wEditable then begin
            if lrUserStp.Get(UserId) then begin
                if pwAut then
                    wEditable := lrUserStp."Editar Prod. MdM Parcial" or lrUserStp."Editar Prod. MdM Total"
                else
                    wEditable := lrUserStp."Editar Prod. MdM Total";
            end;
        end;
    end;


    procedure GetDimEditable(prDefDim: Record "Default Dimension"; pwError: Boolean) wEditable: Boolean
    var
        lwN: Integer;
        lrUserStp: Record "User Setup";
        lrItem: Record Item;
    begin
        // GetDimEditable
        // Determina si la dimensión es editable

        wEditable := true;

        if prDefDim."Table ID" = 27 then begin // Producto
            if prDefDim."Dimension Code" <> '' then begin
                GetConfM;
                if wConfMdM."Bloquea Datos MDM" then begin
                    if lrDim.Get(prDefDim."Dimension Code") then begin
                        wEditable := lrDim."Tipo MdM" = lrDim."Tipo MdM"::Ninguno;
                    end;
                    if not wEditable then begin
                        if lrItem.Get(prDefDim."No.") then
                            wEditable := not lrItem."Gestionado MdM";
                    end;
                end;
            end;
        end;

        if (not wEditable) then begin
            if lrUserStp.Get(UserId) then
                wEditable := lrUserStp."Editar Prod. MdM Total";
        end;

        if (not wEditable) and pwError then
            Error(ErrEditDim);
    end;


    procedure GetDimValueEditable(prDimVal: Record "Dimension Value"; pwError: Boolean) wEditable: Boolean
    var
        lwN: Integer;
        lrUserStp: Record "User Setup";
    begin
        // GetDimValueEditable
        // Determina un valor de dimensión es editable

        wEditable := true;

        if prDimVal."Dimension Code" <> '' then begin
            GetConfM;
            if wConfMdM."Bloquea Datos MDM" then begin
                if lrDim.Get(prDimVal."Dimension Code") then begin
                    wEditable := lrDim."Tipo MdM" = lrDim."Tipo MdM"::Ninguno;
                end;
            end;
        end;

        if (not wEditable) then begin
            if lrUserStp.Get(UserId) then
                wEditable := lrUserStp."Editar Prod. MdM Total";
        end;

        if (not wEditable) and pwError then
            Error(ErrEditDim2);
    end;


    procedure SetConfTipologiaMdM(var prProd: Record Item; pwTipologia: Code[10]; pwValores: array[10] of Code[20]) Result: Boolean
    var
        lrConfTip: Record "Conf. Tipologias MdM";
        lrItemCat: Record "Item Category";
        lwNo: Integer;
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
    begin
        // SetConfTipologiaMdM
        // Tener en cuenta que no se hace Modify en la tabla

        Clear(lrConfTip);
        Clear(lrFiltroTipo);

        lrConfTip.SetRange(Tipologia, pwTipologia);
        for lwNo := 1 to lrFiltroTipo.MaxId do
            if lrFiltroTipo.Get(lwNo) then
                lrConfTip.SetFilterRef(lwNo, pwValores[lwNo]);

        Result := lrConfTip.Find('-');

        if Result then
            SetConfTipologiaData(prProd, lrConfTip);

        // Se supone que por defecto ya se han validado estos valores
        //ELSE BEGIN
        //  IF lrItemCat.GET(pwTipologia) THEN BEGIN
        //    prProd.VALIDATE("Gen. Prod. Posting Group", lrItemCat."Def. Gen. Prod. Posting Group");
        //    prProd.VALIDATE("Inventory Posting Group" , lrItemCat."Def. Inventory Posting Group");
        //    prProd.VALIDATE("VAT Prod. Posting Group" , lrItemCat."Def. VAT Prod. Posting Group");
        //    prProd.VALIDATE("Costing Method"          , lrItemCat."Def. Costing Method");
        //  END;
        //END;
    end;


    procedure SetConfTipologiaData(var prProd: Record Item; var prConfTip: Record "Conf. Tipologias MdM")
    begin
        // SetConfTipologiaData
        // Tener en cuenta que no se hace Modify en la tabla

        prProd.Validate("Gen. Prod. Posting Group", prConfTip."Gen. Prod. Posting Group");
        prProd.Validate("Inventory Posting Group", prConfTip."Inventory Posting Group");
        prProd.Validate("VAT Prod. Posting Group", prConfTip."VAT Prod. Posting Group");
        prProd.Validate("Costing Method", prConfTip."Costing Method");
        prProd.Validate("Item Disc. Group", prConfTip."Item Disc. Group");
        //fes mig prProd.VALIDATE("Product Group Code"      , prConfTip."Product Group Code");
    end;


    procedure ConfiguraTipologiaMdM(var prProd: Record Item) Result: Boolean
    var
        lrConv: Record "Conversion NAV MdM";
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lwNo: Integer;
        lwValores: array[20] of Code[20];
    begin
        // ConfiguraTipologiaMdM

        Clear(lwValores);
        for lwNo := 1 to lrFiltroTipo.MaxId do begin
            if lrFiltroTipo.Get(lwNo) then begin
                //lwValores[lwNo] :=
                case lrFiltroTipo.Tipo of
                    lrFiltroTipo.Tipo::Dimension:
                        lwValores[lwNo] := GetDimValueT(prProd."No.", lrFiltroTipo."Valor Id");
                    lrFiltroTipo.Tipo::"Dato MdM":
                        lwValores[lwNo] := GetDatoMdM(prProd, lrFiltroTipo."Valor Id");
                    lrFiltroTipo.Tipo::Otros:
                        lwValores[lwNo] := GetDatosOtros(prProd, lrFiltroTipo."Valor Id");
                end;
            end;
        end;

        Result := SetConfTipologiaMdM(prProd, prProd."Item Category Code", lwValores);
    end;


    procedure ShowSalesPrice(var prProd: Record Item)
    var
        lrSPrice: Record "Price List Line";
    begin
        // ShowSalesPrice

        Clear(lrSPrice);
        lrSPrice.SetRange("Product No.", prProd."No.");
        PAGE.Run(PAGE::"Price List Lines", lrSPrice);
    end;


    procedure ControlIBN(pwCode: Code[13]; pwError: Boolean) wOK: Boolean
    var
        lwChar: Char;
        lwN: Integer;
        lwInt: Integer;
        lwTotal: Integer;
        lwCont: Integer;
        lwCont2: Integer;
    begin
        // ControlIBN
        // Devuelve true si el dígito de control es correcto

        wOK := false;
        if pwCode = '' then
            exit;

        lwTotal := 0;
        wOK := Evaluate(lwCont, Format(pwCode[13])); // Dígito de control
        if wOK then begin
            for lwN := 1 to 12 do begin
                lwChar := pwCode[lwN];
                if wOK then begin
                    wOK := Evaluate(lwInt, Format(lwChar));
                    if wOK then begin
                        if lwN mod 2 = 0 then
                            lwInt := lwInt * 3;
                        lwTotal += lwInt
                    end;
                end;
            end;
        end;

        if wOK then begin
            lwCont2 := 0;
            while ((lwTotal + lwCont2) mod 10 <> 0) do
                lwCont2 += 1;
            wOK := lwCont = lwCont2;
        end;

        if (not wOK) and pwError then
            Error(ErrISBN, pwCode);
    end;


    procedure ObligaCampos(prProd: Record Item)
    var
        ltEan: Label 'EAN';
        lwN: Integer;
        lPrecioVta: Label 'Precio de Venta';
    begin
        // ObligaCampos
        // Genera un error si no se han rellenado debidamente los campos MdM

        GetConfM;
        if not wConfMdM."Obliga Campos MdM" then
            exit;

        if not prProd."Gestionado MdM" then
            exit;

        prProd.TestField("Item Category Code");
        prProd.TestField(Description);
        prProd.TestField("Search Description");
        prProd.TestField("Tipo Producto");
        prProd.TestField(Soporte);
        prProd.TestField(Linea);
        prProd.TestField(Sello);
        prProd.TestField(Idioma);
        ObligaDim(prProd, 0, 2); // Serie
        //prProd.TESTFIELD(Autor);
        prProd.TestField("Empresa Editora");
        prProd.TestField("Plan Editorial");
        prProd.TestField(Edicion);
        ObligaDim(prProd, 1, 2); // Destino
        ObligaDim(prProd, 2, 2); // Cuenta
        prProd.TestField("Estructura Analitica");
        ObligaDim(prProd, 3, 2); // Tipo Texto
        prProd.TestField(Asignatura);
        prProd.TestField("Nivel Escolar (Grado)");
        ObligaDim(prProd, 5, 2); // Carga Horaria
        ObligaDim(prProd, 6, 2); // Origen
        prProd.TestField(Estado);

        /*  // De momento no obligatorios
        prProd.TESTFIELD(ISBN);
        IF GetEAN(prProd) = '' THEN
          ERROR(ErrFieldM, ltEan);
        prProd.TESTFIELD("No. Paginas");
        
        prProd.TESTFIELD("Country/Region of Origin Code");
        
        */

    end;


    procedure ObligaCampos2(prProd: Record Item) Result: Boolean
    var
        ltEan: Label 'EAN';
        lwN: Integer;
        lPrecioVta: Label 'Precio de Venta';
        lwOK: Boolean;
        lwRecRef: RecordRef;
    begin
        // ObligaCampos2
        // Genera un Aviso si no se han rellenado debidamente los campos MdM

        GetConfM;
        if not wConfMdM."Obliga Campos MdM" then
            exit;

        if not prProd."Gestionado MdM" then
            exit;

        lwOK := true;
        lwRecRef.GetTable(prProd);


        // Campos
        if lwOK then
            lwOK := ObligaField(lwRecRef, 5702, 1); // "Item Category Code"
        if lwOK then
            lwOK := ObligaField(lwRecRef, 2, 1); // Description
        if lwOK then
            lwOK := ObligaField(lwRecRef, 4, 1); // Search Description"
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75001, 1); // "Tipo Producto"
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75002, 1); // Soporte
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75004, 1); // Linea
        if lwOK then
            lwOK := ObligaField(lwRecRef, 56010, 1); // Sello
        if lwOK then
            lwOK := ObligaField(lwRecRef, 56013, 1); // Idioma
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75003, 1); // "Empresa Editora"
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75006, 1); // "Plan Editorial"
        if lwOK then
            lwOK := ObligaField(lwRecRef, 56007, 1); // Edicion
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75007, 1); // "Estructura Analitica"
        if lwOK then
            lwOK := ObligaField(lwRecRef, 56008, 1); // Estado
        if lwOK then
            lwOK := ObligaField(lwRecRef, 75010, 1); // Asignatura
        if lwOK then
            lwOK := ObligaField(lwRecRef, 50005, 1);  // "Nivel Escolar (Grado)"


        // Dimensiones
        if lwOK then
            lwOK := ObligaDim(prProd, 0, 1); // Serie
        if lwOK then
            lwOK := ObligaDim(prProd, 1, 1); // Destino
        if lwOK then
            lwOK := ObligaDim(prProd, 2, 1); // Cuenta
        if lwOK then
            lwOK := ObligaDim(prProd, 3, 1); // Tipo Texto
        if lwOK then
            lwOK := ObligaDim(prProd, 5, 1); // Carga Horaria
        if lwOK then
            lwOK := ObligaDim(prProd, 6, 1); // Origen

        Result := lwOK;
    end;


    procedure ObligaDim(prProd: Record Item; pwDim: Integer; pwTipo: Option Nada,Aviso,Error) Result: Boolean
    var
        lwDimCode: Code[20];
    begin
        // ObligaDim

        Result := true;
        lwDimCode := GetDimCode(pwDim, true);
        if GetDimValueC(prProd."No.", lwDimCode) = '' then begin
            Result := false;
            case pwTipo of
                pwTipo::Aviso:
                    Message(ErrFieldM, GetDimNameField(pwDim));
                pwTipo::Error:
                    Error(ErrFieldM, GetDimNameField(pwDim));
            end;
        end;
    end;


    procedure ObligaField(var pRecRef: RecordRef; pwIdField: Integer; pwTipo: Option Nada,Aviso,Error) Result: Boolean
    var
        lwFieldRef: FieldRef;
    begin
        // ObligaField

        Result := true;
        lwFieldRef := pRecRef.Field(pwIdField);
        if Format(lwFieldRef.Value) = '' then begin
            Result := false;
            case pwTipo of
                pwTipo::Aviso:
                    Message(ErrFieldM, lwFieldRef.Caption);
                pwTipo::Error:
                    Error(ErrFieldM, lwFieldRef.Caption);
            end;
        end;
    end;


    procedure GetOtrosName(pwId: Integer) Result: Text
    var
        lwIdTable: Integer;
        lrRecRef: RecordRef;
    begin
        // GetOtrosName

        Result := '';
        lwIdTable := GetOtrosTableId(pwId);

        if lwIdTable > 0 then begin
            lrRecRef.Open(lwIdTable, true);
            Result := lrRecRef.Caption;
            lrRecRef.Close;
        end;
    end;


    procedure GetOtrosTableId(pwId: Integer) Result: Integer
    begin
        // GetOtrosTableId

        Result := 0;
        case pwId of
            1:
                Result := 5723; // Product Group
        end;
    end;


    procedure GetTotalOtrosOptions(): Integer
    begin
        // GetTotalOtrosOptions
        // Devuelve el total de opciones Otros Existentes

        exit(1);
    end;


    procedure GetDefDimesions(var prProd: Record Item)
    var
        lrDefDim: Record "Default Dimension";
        lrDefDim2: Record "Default Dimension";
        lrDefDim3: Record "Default Dimension";
    begin
        // GetDefDimesions
        // Añadimos dimensiones por defecto

        if prProd."No." = '' then
            exit;

        Clear(lrDefDim);
        lrDefDim.SetRange("Table ID", 27);
        lrDefDim.SetFilter("No.", '=%1', '');
        lrDefDim.SetFilter("Dimension Value Code", '<>%1', ''); // JPT 06/02/2019 No consideramos valores en blanco
        if lrDefDim.FindSet then begin
            repeat
                if lrDefDim."Value Posting" in [lrDefDim."Value Posting"::"Code Mandatory", lrDefDim."Value Posting"::"Same Code"] then begin
                    lrDefDim2.Copy(lrDefDim);
                    lrDefDim2."No." := prProd."No.";
                    lrDefDim3 := lrDefDim2;
                    if lrDefDim3.Find then // Si existe la modifica
                        lrDefDim2.Modify
                    else
                        lrDefDim2.Insert;

                    SetGlobalDim(prProd, lrDefDim2."Dimension Code", lrDefDim2."Dimension Value Code");
                end;
            until lrDefDim.Next = 0;
        end;
    end;


    procedure SetGlobalDim(var prProd: Record Item; pwDimCode: Code[20]; pwValue: Code[20])
    begin
        // SetGlobalDim

        GetGLSetup;
        if pwDimCode = GLSetup."Global Dimension 1 Code" then
            prProd."Global Dimension 1 Code" := pwValue;
        if pwDimCode = GLSetup."Global Dimension 2 Code" then
            prProd."Global Dimension 2 Code" := pwValue;
    end;


    procedure SetEstadoProd(var prItem: Record Item)
    begin
        // SetEstadoProd
        // Gestionamos el campo Inactivo a través del estado
        // El campo Inactivo de Navision se marque cuando un artículo adquiera en el MdM el estado Y8 FONDO DE BAJA
        // JPT 08/01/2019

        GetConfM;
        if wConfMdM."Estado Inactivo" <> '' then begin
            if prItem.Estado = wConfMdM."Estado Inactivo" then
                prItem.Validate(Inactivo, true);
        end;
    end;


    procedure ContrlFechasDocV(prSalesHd: Record "Sales Header")
    var
        lrLin: Record "Sales Line";
    begin
        // ContrlFechasDocV
        // #209115 JPT 03/04/2019

        if not (prSalesHd."Document Type" in [prSalesHd."Document Type"::Order, prSalesHd."Document Type"::Invoice]) then
            exit;

        if prSalesHd."No." = '' then
            exit;

        ClearFechasBuff;
        Clear(lrLin);
        lrLin.SetRange("Document Type", prSalesHd."Document Type");
        lrLin.SetRange("Document No.", prSalesHd."No.");
        lrLin.SetRange(Type, lrLin.Type::Item);
        lrLin.SetFilter("No.", '<>%1', '');
        lrLin.SetFilter(Quantity, '<>%1', 0);
        if lrLin.FindSet then begin
            repeat
                if not rTmpBuff.Get(lrLin."No.") then begin
                    rTmpBuff."Cod Producto" := lrLin."No.";
                    rTmpBuff.Insert;
                end;
            until lrLin.Next = 0;
        end;
    end;


    procedure ContrlFechasDocC(prPurchHd: Record "Purchase Header")
    var
        lrLin: Record "Purchase Line";
    begin
        // ContrlFechasDocC
        // #209115 JPT 03/04/2019

        if not (prPurchHd."Document Type" in [prPurchHd."Document Type"::Order, prPurchHd."Document Type"::Invoice]) then
            exit;

        if prPurchHd."No." = '' then
            exit;

        ClearFechasBuff;
        Clear(lrLin);
        lrLin.SetRange("Document Type", prPurchHd."Document Type");
        lrLin.SetRange("Document No.", prPurchHd."No.");
        lrLin.SetRange(Type, lrLin.Type::Item);
        lrLin.SetFilter("No.", '<>%1', '');
        lrLin.SetFilter(Quantity, '<>%1', 0);
        if lrLin.FindSet then begin
            repeat
                if not rTmpBuff.Get(lrLin."No.") then begin
                    rTmpBuff."Cod Producto" := lrLin."No.";
                    rTmpBuff.Insert;
                end;
            until lrLin.Next = 0;
        end;
    end;


    procedure ContrlFechasAlbC(prCabAlbC: Record "Purch. Rcpt. Header")
    var
        lrLin: Record "Purch. Rcpt. Line";
        lrTmpBuff: Record "Fechas Productos MdM Buffer" temporary;
    begin
        // ContrlFechaAlbC
        // #209115 JPT 03/04/2019
        // Gestion de fechas MdM por Albarán Compra

        if prCabAlbC."No." = '' then
            exit;

        Clear(lrLin);
        lrLin.SetRange("Document No.", prCabAlbC."No.");
        lrLin.SetRange(Type, lrLin.Type::Item);
        lrLin.SetRange(Correction, false);
        if lrLin.FindSet then begin
            repeat
                if not lrTmpBuff.Get(lrLin."No.") then begin
                    lrTmpBuff."Cod Producto" := lrLin."No.";
                    lrTmpBuff.Insert;
                end;
            until lrLin.Next = 0;

            ContrlFechasMdM(lrTmpBuff, 1);
        end;
    end;


    procedure ContrlFechasAlbV(prCabAlbV: Record "Sales Shipment Header")
    var
        lrLin: Record "Sales Shipment Line";
        lrTmpBuff: Record "Fechas Productos MdM Buffer" temporary;
    begin
        // ContrlFechaAlbV
        // #209115 JPT 03/04/2019
        // Gestion de fechas MdM por Albarán Venta

        if prCabAlbV."No." = '' then
            exit;

        Clear(lrLin);
        lrLin.SetRange("Document No.", prCabAlbV."No.");
        lrLin.SetRange(Type, lrLin.Type::Item);
        lrLin.SetRange(Correction, false);
        if lrLin.FindSet then begin
            repeat
                if not lrTmpBuff.Get(lrLin."No.") then begin
                    lrTmpBuff."Cod Producto" := lrLin."No.";
                    lrTmpBuff.Insert;
                end;
            until lrLin.Next = 0;

            ContrlFechasMdM(lrTmpBuff, 2);
        end;
    end;


    procedure ContrlFechasFactV(prCabFactV: Record "Sales Invoice Header")
    var
        lrLin: Record "Sales Invoice Line";
        lrTmpBuff: Record "Fechas Productos MdM Buffer" temporary;
    begin
        // ContrlFechasFactV
        // #209115 JPT 03/04/2019
        // Gestion de fechas MdM por Factura Venta

        if prCabFactV."No." = '' then
            exit;

        Clear(lrLin);
        lrLin.SetRange("Document No.", prCabFactV."No.");
        lrLin.SetRange(Type, lrLin.Type::Item);
        if lrLin.FindSet then begin
            repeat
                if not lrTmpBuff.Get(lrLin."No.") then begin
                    lrTmpBuff."Cod Producto" := lrLin."No.";
                    lrTmpBuff.Insert;
                end;
            until lrLin.Next = 0;

            ContrlFechasMdM(lrTmpBuff, 2);
        end;
    end;


    procedure ContrlFechasEns(prAssemHd: Record "Posted Assembly Header") Result: Boolean
    var
        lrLin: Record "Posted Assembly Line";
        lrProd: Record Item;
        lrTmpFechasBuff: Record "Fechas Productos MdM Buffer" temporary;
        lrTmpf2: Record "Fechas Productos MdM Buffer" temporary;
        lrProd2: Record Item;
        lwBEntrada: Boolean;
        lwBComerc: Boolean;
        lrTmpBuff: Record "Fechas Productos MdM Buffer" temporary;
    begin
        // ContrlFechasEns - Ensamblado
        // #209115 JPT 01/07/2019

        if (prAssemHd."No." = '') or (prAssemHd."Item No." = '') then
            exit;

        if not lrProd.Get(prAssemHd."Item No.") then
            exit;

        if not lrProd."Gestionado MdM" then
            exit;

        Result := GestValoresFechasBuff(lrProd, lrTmpFechasBuff, 1, true, true, 2);

        if lrTmpFechasBuff."Fecha Almacen" = 0D then
            lrTmpFechasBuff."Fecha Almacen" := lrProd."Fecha Almacen";

        Clear(lrLin);
        lrLin.SetRange("Document No.", prAssemHd."No.");
        lrLin.SetRange(Type, lrLin.Type::Item);
        lrLin.SetFilter("No.", '<>%1', '');
        lrLin.SetFilter(Quantity, '<>%1', 0);
        if lrLin.FindSet then begin
            repeat
                if lrProd2.Get(lrLin."No.") then begin
                    if DesfFechasBuff(lrProd2, 1, lwBEntrada, lwBComerc) then begin
                        GestValoresFechasBuff(lrProd2, lrTmpf2, 1, true, false, 0);
                        if lwBEntrada then begin
                            if lrTmpFechasBuff."Fecha Almacen" <> 0D then
                                if (lrTmpFechasBuff."Fecha Almacen" < lrTmpf2."Fecha Almacen") or (lrTmpf2."Fecha Almacen" = 0D) then
                                    lrTmpf2."Fecha Almacen" := lrTmpFechasBuff."Fecha Almacen";
                        end;
                        Result := Result or GestValoresFechasBuff(lrProd2, lrTmpf2, 1, false, true, 2);
                    end;
                end;
            until lrLin.Next = 0;
        end;


        /*
        IF NOT lrTmpBuff.GET(prAssemHd."Item No.") THEN BEGIN
          lrTmpBuff."Cod Producto" := prAssemHd."Item No.";
          lrTmpBuff.INSERT;
        END;
        
        CLEAR(lrLin);
        lrLin.SETRANGE("Document No." , prAssemHd."No.");
        lrLin.SETRANGE(Type           , lrLin.Type::Item);
        lrLin.SETFILTER("No."         , '<>%1','');
        lrLin.SETFILTER(Quantity      , '<>%1',0);
        IF lrLin.FINDSET THEN BEGIN
          REPEAT
            IF NOT lrTmpBuff.GET(lrLin."No.") THEN BEGIN
              lrTmpBuff."Cod Producto" := lrLin."No.";
              lrTmpBuff.INSERT;
            END;
          UNTIL lrLin.NEXT=0;
        
          ContrlFechasMdM(lrTmpBuff,1);
        END;
        */

    end;


    procedure ContrlFechasMdM(var prTmpBuff: Record "Fechas Productos MdM Buffer" temporary; pwTipoFecha: Option Todas,Entrada,Comercializacion)
    begin
        // ContrlFechasMdM
        // #209115 JPT 03/04/2019
        // Gestion de fechas MdM

        if prTmpBuff.FindSet then begin
            repeat
                GestContrlFechasProd2(prTmpBuff."Cod Producto", pwTipoFecha);
            until prTmpBuff.Next = 0;
        end;
    end;


    procedure ContrlFechasMdMTmp(pwTipoFecha: Option Todas,Entrada,Comercializacion)
    begin
        // ContrlFechasMdMTmp
        // #209115 JPT 03/04/2019
        // Gestion de fechas MdM

        ContrlFechasMdM(rTmpBuff, pwTipoFecha);
        ClearFechasBuff;
    end;


    procedure GestContrlFechasProd(var prProd: Record Item; pwTipoFecha: Option Todas,Entrada,Comercializacion; pwGuardar: Option No,Single,RunTrigger) Result: Boolean
    var
        lrTmpFechasBuff: Record "Fechas Productos MdM Buffer" temporary;
        lrTmpf2: Record "Fechas Productos MdM Buffer" temporary;
        lrBoomC: Record "BOM Component";
        lrProd2: Record Item;
        lwBEntrada: Boolean;
        lwBComerc: Boolean;
    begin
        // GestContrlFechasProd
        // #209115 JPT 03/04/2019  Gestionamos el control de rellenado automatico de las fechas MdM de producto
        // OJO : pwGuardar = Single Provocará que NO se lancen las notificaciones a MdM

        Result := false;

        if prProd."No." = '' then
            exit;

        if not prProd."Gestionado MdM" then
            exit;

        Result := GestValoresFechasBuff(prProd, lrTmpFechasBuff, pwTipoFecha, true, true, pwGuardar);


        if not prProd."Assembly BOM" then
            prProd.CalcFields("Assembly BOM");
        if prProd."Assembly BOM" then begin

            if lrTmpFechasBuff."Fecha Almacen" = 0D then
                lrTmpFechasBuff."Fecha Almacen" := prProd."Fecha Almacen";
            if lrTmpFechasBuff."Fecha Comercializacion" = 0D then
                lrTmpFechasBuff."Fecha Comercializacion" := prProd."Fecha Comercializacion";

            Clear(lrBoomC);
            lrBoomC.SetRange("Parent Item No.", prProd."No.");
            lrBoomC.SetRange(Type, lrBoomC.Type::Item);
            if lrBoomC.FindSet then begin
                repeat
                    if lrProd2.Get(lrBoomC."No.") then begin
                        if DesfFechasBuff(lrProd2, pwTipoFecha, lwBEntrada, lwBComerc) then begin
                            GestValoresFechasBuff(lrProd2, lrTmpf2, pwTipoFecha, true, false, 0);
                            if lwBEntrada then begin
                                if lrTmpFechasBuff."Fecha Almacen" <> 0D then
                                    if (lrTmpFechasBuff."Fecha Almacen" < lrTmpf2."Fecha Almacen") or (lrTmpf2."Fecha Almacen" = 0D) then
                                        lrTmpf2."Fecha Almacen" := lrTmpFechasBuff."Fecha Almacen";
                            end;
                            if lwBComerc then begin
                                if lrTmpFechasBuff."Fecha Comercializacion" <> 0D then
                                    if (lrTmpFechasBuff."Fecha Comercializacion" < lrTmpf2."Fecha Comercializacion") or (lrTmpf2."Fecha Comercializacion" = 0D) then
                                        lrTmpf2."Fecha Comercializacion" := lrTmpFechasBuff."Fecha Comercializacion";
                            end;
                            Result := Result or GestValoresFechasBuff(lrProd2, lrTmpf2, pwTipoFecha, false, true, pwGuardar);
                        end;
                    end;
                until lrBoomC.Next = 0;
            end;
        end;
    end;


    procedure GestContrlFechasProd2(pwCodPro: Code[20]; pwTipoFecha: Option Todas,Entrada,Comercializacion) Result: Boolean
    var
        lrProd: Record Item;
    begin
        // GestContrlFechasProd2
        // #209115

        Result := false;
        if pwCodPro = '' then
            exit;

        if lrProd.Get(pwCodPro) then
            Result := GestContrlFechasProd(lrProd, pwTipoFecha, 2); // Guardamos validando
    end;

    local procedure GestValoresFechasBuff(var prProd: Record Item; var prTmpFechasBuff: Record "Fechas Productos MdM Buffer" temporary; pwTipoFecha: Option Todas,Entrada,Comercializacion; pwCalcula: Boolean; pwAsigna: Boolean; pwGuardar: Option No,Single,RunTrigger) Result: Boolean
    var
        lwBEntrada: Boolean;
        lwBComerc: Boolean;
        lwOk: Boolean;
        lwDate: Date;
        lrProd2: Record Item;
    begin
        // GestValoresFechasBuff
        // OJO : pwGuardar = Single Provocará que NO se lancen las notificaciones a MdM
        // #209115

        Result := false;

        if pwCalcula then
            Clear(prTmpFechasBuff);

        if prProd."No." = '' then
            exit;

        if not prProd."Gestionado MdM" then
            exit;

        if not DesfFechasBuff(prProd, pwTipoFecha, lwBEntrada, lwBComerc) then // Si está todo rellenado
            exit;

        prTmpFechasBuff."Cod Producto" := prProd."No.";

        if pwCalcula then begin
            case true of
                lwBEntrada and lwBComerc:
                    prTmpFechasBuff.CalcFields("Fecha Alb Compra", "Fecha Ensamblado", "Fecha Alb Venta", "Fecha Fact Venta");
                lwBEntrada:
                    prTmpFechasBuff.CalcFields("Fecha Alb Compra", "Fecha Ensamblado");
                lwBComerc:
                    prTmpFechasBuff.CalcFields("Fecha Alb Venta", "Fecha Fact Venta");
            end;

            if lwBEntrada then begin
                lwDate := prTmpFechasBuff."Fecha Alb Compra";
                //"Fecha Almacen" := "Fecha Alb Compra";
                if prTmpFechasBuff."Fecha Ensamblado" <> 0D then begin
                    if (prTmpFechasBuff."Fecha Ensamblado" < lwDate) or (lwDate = 0D) then
                        lwDate := prTmpFechasBuff."Fecha Ensamblado";
                end;
                if lwDate = 0D then begin // Miramos si es un componente de ensamblado
                    prTmpFechasBuff.CalcFields(CodProdEsamblado);
                    if prTmpFechasBuff.CodProdEsamblado <> '' then begin
                        if lrProd2.Get(prTmpFechasBuff.CodProdEsamblado) then
                            lwDate := lrProd2."Fecha Almacen";
                    end;
                end;
                prTmpFechasBuff."Fecha Almacen" := lwDate;
            end;

            if lwBComerc then begin
                lwDate := prTmpFechasBuff."Fecha Alb Venta";
                if prTmpFechasBuff."Fecha Fact Venta" <> 0D then begin
                    if (prTmpFechasBuff."Fecha Fact Venta" < lwDate) or (lwDate = 0D) then
                        lwDate := prTmpFechasBuff."Fecha Fact Venta"
                end;
                prTmpFechasBuff."Fecha Comercializacion" := lwDate;
            end;
        end;

        if pwAsigna then begin
            if lwBEntrada then begin
                if prTmpFechasBuff."Fecha Almacen" <> 0D then begin
                    prProd.Validate("Fecha Almacen", prTmpFechasBuff."Fecha Almacen");
                    Result := true;
                end;
            end;

            if lwBComerc then begin
                if prTmpFechasBuff."Fecha Comercializacion" <> 0D then begin
                    prProd.Validate("Fecha Comercializacion", prTmpFechasBuff."Fecha Comercializacion");
                    Result := true;
                end;
            end;
        end;

        if Result then begin
            case pwGuardar of
                pwGuardar::Single:
                    prProd.Modify(false);
                pwGuardar::RunTrigger:
                    prProd.Modify(true);
            end;
        end;
    end;


    procedure DesfFechasBuff(prProd: Record Item; pwTipoFecha: Option Todas,Entrada,Comercializacion; var pwBEntrada: Boolean; var pwBComerc: Boolean) Result: Boolean
    begin
        // DesfFechasBuff
        // #209115

        Clear(pwBEntrada);
        Clear(pwBComerc);
        if pwTipoFecha in [pwTipoFecha::Todas, pwTipoFecha::Entrada] then
            pwBEntrada := prProd."Fecha Almacen" = 0D;
        if pwTipoFecha in [pwTipoFecha::Todas, pwTipoFecha::Comercializacion] then
            pwBComerc := prProd."Fecha Comercializacion" = 0D;

        Result := pwBEntrada or pwBComerc;
    end;


    procedure ClearFechasBuff()
    begin
        // ClearFechasBuff
        // #209115

        Clear(rTmpBuff);
        rTmpBuff.DeleteAll;
    end;
}

