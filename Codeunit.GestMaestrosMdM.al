codeunit 75001 "Gest. Maestros MdM"
{
    // Tengase en cuenta que tanto rImp como rCab y rField son registros TEMPORALES


    trigger OnRun()
    begin
        // Utilizamos el OnRun para lanzar la función de asegurar que esté activa la cola de proyecto
        // Así si falla no detendrá nada
        //fes mig ActColaProy;
    end;

    var
        cFuncMdm: Codeunit "Funciones MdM";
        cFileMng: Codeunit "File Management";
        cAsynMng: Codeunit "MdM Async Manager";
        cTrasp: Codeunit "MdM Gen. Prod.";
        cNotifPrec: Codeunit "MdM Notifica Precios";
        rConfMdM: Record "Configuracion MDM";
        rImp: Record "Imp.MdM Tabla" temporary;
        rCab: Record "Imp.MdM Cabecera" temporary;
        rCabRl: Record "Imp.MdM Cabecera";
        rField: Record "Imp.MdM Campos" temporary;
        Text001: Label 'El tipo de dato %1 no está permitido en la importación de datos. Campo %2';
        rConvNM: Record "Conversion NAV MdM";
        rConfSant: Record "Config. Empresa";
        rConfCont: Record "General Ledger Setup";
        wIds: array[3] of Integer;
        Text002: Label '%1 No es un valor permitido para %2.\ Los valores permitidos son %3';
        wDia: Dialog;
        wTotal: Integer;
        wCont: Integer;
        Text003: Label 'Traspasando';
        wStep: Integer;
        Text004: Label 'No Aplica';
        wAllowEmptyValues: Boolean;
        Text005: Label 'Se ha producido una referencia Circular en %1 %2. Producto %3';


    procedure SetValues(var prCab: Record "Imp.MdM Cabecera" temporary; var prImp: Record "Imp.MdM Tabla" temporary; var prField: Record "Imp.MdM Campos" temporary)
    begin
        // Introduce los valores de las talas temporales
        // Para que funcione las tablas que se pasan por parametro tienen que ser temporales
        ResetAll;
        rCab.Copy(prCab);
        rImp.Copy(prImp);
        rField.Copy(prField);
    end;


    procedure GetValues(var prCab: Record "Imp.MdM Cabecera" temporary; var prImp: Record "Imp.MdM Tabla" temporary; var prField: Record "Imp.MdM Campos" temporary)
    begin
        // Devueelve los valores de las tablas temporales
        // Para que funcione las tablas que se pasan por parametro tienen que ser temporales

        prCab.Copy(rCab);
        prImp.Copy(rImp);
        prField.Copy(rField);
    end;


    procedure ImpCabExcel()
    var
        lrCabR: Record "Imp.MdM Cabecera";
    begin
        // ImpCabExcel

        PasarAReal2(true);
    end;


    procedure ResetAll()
    begin

        Clear(wIds);

        rImp.Reset;
        rImp.DeleteAll;

        rCab.Reset;
        rCab.DeleteAll;

        rField.Reset;
        rField.DeleteAll;
    end;


    procedure AddMstReg(pwOperacion: Option Insert,Update,Delete; pwIdTabla: Integer; pwTipo: Integer; pwCode: Code[30]; pwDescripcion: Text; pwNombreElemento: Text[50]; pwVisible: Text[10]) IDR: Integer
    begin
        // AddMstReg
        // Añade una linea en la tabla previa de maestros MdM
        // Devolvemos el valor Id del registro insertado

        IDR := AddMstReg2(pwOperacion, pwIdTabla, pwTipo, pwCode, pwDescripcion, pwNombreElemento, pwVisible, false);
    end;


    procedure AddMstReg2(pwOperacion: Option Insert,Update,Delete; pwIdTabla: Integer; pwTipo: Integer; pwCode: Code[30]; pwDescripcion: Text; pwNombreElemento: Text[50]; pwVisible: Text[10]; pwValMdM: Boolean) IDR: Integer
    begin
        // AddMstReg2
        // Añade una linea en la tabla previa de maestros MdM
        // Devolvemos el valor Id del registro insertado

        wIds[2] += 1;
        wIds[3] := 0;
        Clear(rImp);
        rImp.Id := wIds[2];
        rImp."Id Cab." := rCab.Id;
        rImp.Operacion := pwOperacion;
        rImp."Id Tabla" := pwIdTabla;
        if pwValMdM then
            rImp."Code MdM" := pwCode
        else
            rImp.Code := pwCode;

        if StrLen(pwDescripcion) > MaxStrLen(rImp.Descripcion) then
            pwDescripcion := CopyStr(pwDescripcion, 1, MaxStrLen(rImp.Descripcion));
        rImp.Descripcion := pwDescripcion;
        rImp.Tipo := pwTipo;
        rImp."Nombre Elemento" := pwNombreElemento;
        rImp.SetVisibleTx(pwVisible);
        RespNoAplica(rImp);
        rImp.Insert;

        IDR := rImp.Id;

        cTrasp.ConvierteTabl(rImp, false);
    end;


    procedure UpdtMstReg(pwTipo: Integer; pwCode: Code[30]; pwDescripcion: Text[100]; pwVisible: Text[10]) IDR: Integer
    begin
        // UpdtMstReg
        // Modifica linea en la tabla previa de maestros MdM
        // Devolvemos el valor Id del registro insertado

        rImp.Code := pwCode;
        rImp.Descripcion := pwDescripcion;
        rImp.Tipo := pwTipo;
        rImp.SetVisibleTx(pwVisible);
        RespNoAplica(rImp);
        rImp.Modify;

        IDR := rImp.Id;

        cTrasp.ConvierteTabl(rImp, false);
    end;


    procedure GetMstReg(pwOperacion: Option Insert,Update,Delete; pwIdTabla: Integer; pwTipo: Integer; pwCode: Code[30]; pwDescripcion: Text[100]; pwNombreElemento: Text[50]; pwVisible: Text[10]; pwValMdM: Boolean) IDR: Integer
    begin
        // GetMstReg
        // Busca la última línea de la misma operación/tabla/clave, si no la encuentra añade una linea en la tabla previa de maestros MdM
        // Devolvemos el valor Id del registro econtrado o insertado

        Clear(rImp);
        rImp.SetRange("Id Cab.", rCab.Id);
        rImp.SetRange(Operacion, pwOperacion);
        rImp.SetRange("Id Tabla", pwIdTabla);
        rImp.SetRange(Tipo, pwTipo);
        rImp.SetRange(Code, pwCode);
        if rImp.FindLast then
            IDR := rImp.Id
        else
            IDR := AddMstReg2(pwOperacion, pwIdTabla, pwTipo, pwCode, pwDescripcion, pwNombreElemento, pwVisible, pwValMdM);
        rImp.Reset;
    end;


    procedure AddMstRegField(pwIdField: Integer; pwValue: Text[250]; pwNombreElemento: Text[50])
    begin
        // AddMstRegField
        // Insertamos el valor del campo relacionado

        AddMstRegField2(pwIdField, pwValue, pwNombreElemento, false);
    end;


    procedure AddMstRegField2(pwIdField: Integer; pwValue: Text[250]; pwNombreElemento: Text[50]; pwValMdM: Boolean)
    var
        lwExist: Boolean;
    begin
        // AddMstRegField2
        // Insertamos el valor del campo relacionado

        pwValue := DelChr(pwValue, '<>'); // Trim
        if (rImp.Id = 0) or (pwIdField = 0) then
            exit;

        if (not wAllowEmptyValues) and (pwValue = '') then // Definimos si permitimos valors vacios
            exit;

        // Pueden llegar valores en blanco que anulen
        if pwValue = '' then begin
            pwValue := 'NULL';
        end;

        Clear(rField);
        lwExist := rField.Get(rImp.Id, pwIdField);
        if lwExist then begin
            if pwValMdM then
                rField."MdM Value" := pwValue
            else
                rField.Value := pwValue;
            rField.Modify;
        end
        else begin
            wIds[3] += 1;
            Clear(rField);
            rField."Id Cab." := rImp."Id Cab.";
            rField."Id Rel" := rImp.Id;
            rField."Table Id" := rImp."Id Tabla";
            rField."Id Field" := pwIdField;
            rField.Id := wIds[3]; // Viene a ser el orden de insercción
            if pwValMdM then
                rField."MdM Value" := pwValue
            else
                rField.Value := pwValue;
            rField."Nombre Elemento" := pwNombreElemento;
            rField.Insert(true); // Establece el orden
        end;
    end;


    procedure AddRenameField(pwValue: Text[250])
    begin
        // AddRenameField
        // Renombra a

        rField."Renamed Val" := pwValue;
        rField.Modify;
    end;


    procedure AddMstRegHeader(pwOperacion: Option Insert,Update,Delete; pwEntrada: Option INT_WS,INT_Excel,NOTIFICA) IDC: Integer
    begin

        // AddMstRegHeader

        wIds[1] += 1;
        Clear(rCab);
        rCab.Id := wIds[1];
        rCab.Operacion := pwOperacion;
        rCab."Fecha Creacion" := CurrentDateTime;
        rCab.Entrada := pwEntrada;
        rCab.Insert(true);

        IDC := rCab.Id;
    end;


    procedure GetOutStrm(var pwOutStrm: OutStream)
    begin
        // GetOutStrm

        rCab.DOC.CreateOutStream(pwOutStrm);
    end;


    procedure GestMessageXML(var pxResp: XMLport "Resp. Web Service MdM")
    var
        lwError: Boolean;
        lwErrorText: Text;
        Text001: Label 'No hay nada que traspasar a Navision';
        NewSessionId: Integer;
    begin
        // GestMessageXML

        rCab.Modify;

        PasarAReal2(false);

        Clear(lwErrorText);
        lwError := not rCabRl.FindFirst;
        if lwError then
            lwErrorText := Text001;

        pxResp.SetCab(rCabRl, lwError, lwErrorText);
        pxResp.Export;

        // Lo Traspasamos en otra sesión.
        // En realidad llamamos a cAsynMng.TraspasaCab pero en otra sesión
        //cAsynMng.TraspasaCab(rCabRl);
        Commit;
        StartSession(NewSessionId, CODEUNIT::"MdM Async Sender", CompanyName, rCabRl);

        ResetAll;

        //fes mig GestColaProy(0); // Nos aseguramos que la cola de proyecto está activada
    end;

    local procedure GetUnid(pwItemNo: Code[20]; pwCodUnidadBase: Code[10]; pwTipo: Option Ancho,Alto,Peso) wValor: Decimal
    var
        lrUnid: Record "Item Unit of Measure";
    begin
        // GetUnid
        // Devuelve elementos de la unidad de medida

        if pwItemNo = '' then
            exit;

        Clear(lrUnid);
        if lrUnid.Get(pwItemNo, pwCodUnidadBase) then begin
            case pwTipo of
                pwTipo::Ancho:
                    wValor := lrUnid.Width;
                pwTipo::Alto:
                    wValor := lrUnid.Height;
                pwTipo::Peso:
                    wValor := lrUnid.Weight;
            end;
        end;
    end;


    procedure SetDatosCab(pwIdMensaje: Text[50]; pwSistemaOrigen: Text[50]; pwPaisOrigen: Text[50]; pwFechaOrigen: DateTime; pwFecha: DateTime; pwTipo: Text[50])
    begin
        // SetDatosCab

        rCab.id_mensaje := pwIdMensaje;
        rCab.sistema_origen := pwSistemaOrigen;
        rCab.pais_origen := pwPaisOrigen;
        rCab.fecha_origen := pwFechaOrigen;
        rCab.fecha := pwFecha;
        rCab.tipo := pwTipo;
        rCab.Modify;
    end;


    procedure PasarAReal(var prCab: Record "Imp.MdM Cabecera" temporary; var prImp: Record "Imp.MdM Tabla" temporary; var prField: Record "Imp.MdM Campos" temporary; pwTraspasa: Boolean)
    var
        lrImpR: Record "Imp.MdM Tabla";
        lrFieldR: Record "Imp.MdM Campos";
        lwDesde: Integer;
        lwHasta: Integer;
    begin
        // PasarAReal
        // Pasa los valores temporales a la tabla real;
        // Devuelve el Id de la cabecera real


        Clear(rCabRl);
        Clear(lwDesde);
        Clear(lwHasta);
        if prCab.FindSet then begin
            repeat
                prCab.CalcFields(DOC, prCab."Send XML", prCab."Send XML Reply");
                //rCabRl    := prCab;
                rCabRl.TransferFields(prCab);
                rCabRl.Id := 0;
                prImp.SetRange("Id Cab.", prCab.Id);
                if prImp.FindSet then begin
                    rCabRl.Insert; // Si no tiene lineas no insertamos la cabecera
                    if lwDesde = 0 then
                        lwDesde := rCabRl.Id;
                    lwHasta := rCabRl.Id;
                    repeat
                        lrImpR := prImp;
                        lrImpR.Id := 0;
                        lrImpR."Id Cab." := rCabRl.Id;
                        lrImpR.Insert;
                        prField.SetRange("Id Rel", prImp.Id);
                        if prField.FindSet then begin
                            repeat
                                lrFieldR := prField;
                                lrFieldR."Id Rel" := lrImpR.Id;
                                lrFieldR."Id Cab." := rCabRl.Id;
                                lrFieldR.Insert;
                            until prField.Next = 0;
                        end;
                    until prImp.Next = 0;
                    if pwTraspasa then
                        cTrasp.Run(rCabRl);
                end;

            until prCab.Next = 0;
        end;

        rCabRl.SetRange(Id, lwDesde, lwHasta);
    end;


    procedure PasarAReal2(pwTraspasa: Boolean)
    begin
        // PasarAReal2

        PasarAReal(rCab, rImp, rField, pwTraspasa);
    end;


    procedure GetTableCaption(pwId: Integer) wText: Text
    var
        /*  lrObjects: Record "Object"; */
        lrObjects2: Record AllObjWithCaption;
    begin
        // GetTableCaption
        // Devuelve el caption de la tabla

        wText := '';
        /*
        CLEAR(lrObjects);
        lrObjects.SETRANGE(Type, lrObjects.Type::Table);
        lrObjects.SETRANGE(ID, pwId);
        IF lrObjects.FINDFIRST THEN BEGIN
          lrObjects.CALCFIELDS(Caption);
          wText := lrObjects.Caption;
        END;
        */

        case pwId of
            -1:
                wText := Text004; // No aplica
            else begin
                Clear(lrObjects2);
                lrObjects2.SetRange("Object Type", lrObjects2."Object Type"::Table);
                lrObjects2.SetRange("Object ID", pwId);
                if lrObjects2.FindFirst then begin
                    //lrObjects2.CALCFIELDS("Object Caption");
                    wText := lrObjects2."Object Caption";
                end;
            end;
        end;

    end;


    procedure GetFieldCaption(pwTableId: Integer; pwFieldId: Integer) wText: Text
    var
        lrFields: Record "Field";
        LTEXT0001: Label 'Ancho';
        LTEXT0002: Label 'Alto';
        LTEXT0003: Label 'Peso';
        LTEXT0004: Label 'Dimensiones';
        LTEXT0005: Label 'Precio Venta';
        LTEXT0006: Label 'Cód. Barras';
        LTEXT0007: Label 'Observaciones';
        lwIdDim: Integer;
        LTEXT0008: Label 'Código Pack';
        LTEXT0009: Label 'Unidades Pack';
        LTEXT0010: Label 'Codigo Dimensión';
        LTEXT0011: Label 'Valor Dimensión';
        LTEXT0012: Label 'Moneda';
    begin
        // GetFieldCaption

        wText := '';

        if pwFieldId > 0 then begin // Campos Reales
            Clear(lrFields);
            lrFields.SetRange(TableNo, pwTableId);
            lrFields.SetRange("No.", pwFieldId);
            if lrFields.FindFirst then begin
                //lrFields.CALCFIELDS("Field Caption");
                wText := lrFields."Field Caption";
            end;
        end
        else begin // Campos virtuales
            case pwTableId of
                27:
                    begin
                        case pwFieldId of
                            -101:
                                wText := LTEXT0001;
                            -102:
                                wText := LTEXT0002;
                            -103:
                                wText := LTEXT0003;
                            -110:
                                wText := LTEXT0008;
                            -111:
                                wText := LTEXT0009;
                            -120:
                                wText := LTEXT0010;
                            -121:
                                wText := LTEXT0011;

                            -299 .. -200:
                                begin // Dimensiones
                                    lwIdDim := -(pwFieldId + 200);
                                    wText := cFuncMdm.GetDimCode(lwIdDim, false);
                                end;
                            -349 .. -300:
                                wText := LTEXT0005;
                            -501:
                                wText := LTEXT0012;
                            -499 .. -400:
                                wText := LTEXT0006;
                            -500:
                                wText := LTEXT0007;
                        end;
                    end;
            end;
        end;
    end;


    procedure ExpMigracion(prProd: Record Item)
    var
        lwFileName: Text;
        lwFileName2: Text;
        lwFile: File;
        lwOutStr: OutStream;
        lText001: Label 'Guardar Archivo';
        lwXML: XMLport "MDM-Migracion Inicial Art.";
    begin
        // ExpMigracion2

        /*  lwFileName := cFileMng.ServerTempFileName('xml');

         lwFile.Create(lwFileName);
         lwFile.CreateOutStream(lwOutStr);
         XMLPORT.Export(XMLPORT::"MDM-Migracion Inicial Art.", lwOutStr, prProd);
         lwFile.Close;


         //lwFileName2 := cFileMng.SaveFileDialog(lText001,'','XML|*.XML');
         cFileMng.DownloadHandler(lwFileName, lText001, '', 'XML|*.XML', lwFileName2);
     end; */
    end;


    procedure NotifyProd(prProd: Record Item; pwOperacion: Option Insert,Update,Delete; pwCambs: array[10] of Boolean)
    var
        lwPeso: Decimal;
        lwPrecConImpt: Decimal;
        lwPreSinImpt: Decimal;
        lwCodProd: Code[20];
        lwSysOrigen: Text;
        lwFecha: DateTime;
        lwDivisa: Code[10];
    begin
        // NotifyProd

        ResetAll;

        //SetAlowEmptyValues(TRUE); //Permitimos valores en blanco
        AddMstRegHeader(pwOperacion, rCab.Entrada::NOTIFICA);

        rConfSant.Get;
        lwSysOrigen := cAsynMng.GetSistemaOrigen;
        lwFecha := CurrentDateTime;
        // 28/09/2017 Defino el tipo '0008' a piñon por indicación de Daniel Cibrian
        SetDatosCab('', lwSysOrigen, rConfSant."Cod. pais maestros Santill", lwFecha, lwFecha, '0008');

        // Informamos del valor Navision y no del MdM
        //AddMstReg2(pwOperacion, 27, 0, prProd."No. 2", prProd.Description, 'Articulos','', TRUE);
        AddMstReg2(pwOperacion, 27, 0, prProd."No.", prProd.Description, 'Articulos', '', false);

        rImp.Code := prProd."No.";
        rImp.Modify;

        if pwCambs[1] then begin
            lwPeso := GetUnid(prProd."No.", prProd."Base Unit of Measure", 2);
            AddMstRegField(-103, Format(lwPeso), 'Peso'); // Virtual.
        end;

        if pwCambs[6] then
            AddMstRegField(49, prProd."Country/Region of Origin Code", 'Pais');
        if pwCambs[7] then
            AddMstRegField(75005, prProd.Sociedad, 'Sociedad');

        if pwCambs[2] then
            AddMstRegField(75008, Format(prProd."Fecha Almacen", 0, 9), 'Fecha_Almacen');
        // AddMstRegField(, FORMAT(), 'Fecha_Prevista_Almacen',0,9); // No se guarda en Navision
        if pwCambs[3] then
            AddMstRegField(75009, Format(prProd."Fecha Comercializacion", 0, 9), 'Fecha_Comercializacion');

        if pwCambs[4] then begin
            GetPrecioVta(prProd, GestFechaPrecio, lwPrecConImpt, lwPreSinImpt, lwDivisa);
            AddMstRegField(-300, Format(lwPreSinImpt, 0, 9), 'Precio_sin_Impuestos');  // Virtual.
            AddMstRegField(-325, Format(lwPrecConImpt, 0, 9), 'Precio_con_Impuestos');  // Virtual.
            lwDivisa := GestCurrency(lwDivisa); // Actualiza la moneda si es la local
            AddMstRegField(-501, lwDivisa, 'Moneda');  // Virtual.
        end;

        //SetAlowEmptyValues(FALSE);
    end;


    procedure GestNotityProd(prXProd: Record Item; prProd: Record Item)
    var
        lwOk: Boolean;
        lwCambs: array[10] of Boolean;
    begin
        // GestNotityProd

        if not prProd."Gestionado MdM" then
            exit;

        if not rConfMdM.Activo then
            rConfMdM.Get;
        if not rConfMdM."Notifica a MdM" then
            exit;

        // #209115 JPT prXProd lo vamos a buscar ya que no siempre llega bien
        prXProd := prProd;
        if not prXProd.Find then
            Clear(prXProd);


        Clear(lwCambs);
        lwCambs[2] := (prProd."Fecha Almacen" <> prXProd."Fecha Almacen") and (prProd."Fecha Almacen" <> 0D);
        lwCambs[3] := (prProd."Fecha Comercializacion" <> prXProd."Fecha Comercializacion") and (prProd."Fecha Comercializacion" <> 0D);
        lwCambs[6] := (prProd."Country/Region of Origin Code" <> prXProd."Country/Region of Origin Code") and (prProd."Country/Region of Origin Code" <> '');
        lwCambs[7] := (prProd.Sociedad <> prXProd.Sociedad) and (prProd.Sociedad <> '');

        lwOk := lwCambs[2] or lwCambs[3] or lwCambs[6] or lwCambs[7];

        //lwOk := lwOk OR (prProd."Base Unit of Measure" <> prXProd."Base Unit of Measure");

        if lwOk then begin
            lwCambs[6] := true;
            lwCambs[7] := true;
            NotifyProd(prProd, 1, lwCambs);
            ProcesaNotif;
        end;
    end;


    procedure GestNotityUnid(prXUnid: Record "Item Unit of Measure"; prUnid: Record "Item Unit of Measure"; pwDelete: Boolean)
    var
        lwPeso: Decimal;
        lrProd: Record Item;
        lwCambs: array[10] of Boolean;
    begin
        // GestNotityUnid

        if not rConfMdM.Activo then
            rConfMdM.Get;
        if not rConfMdM."Notifica a MdM" then
            exit;

        Clear(lwCambs);
        if (prXUnid.Weight <> prUnid.Weight) or (prXUnid.Code <> prUnid.Code) or pwDelete then begin
            if lrProd.Get(prUnid."Item No.") and (lrProd."Base Unit of Measure" = prUnid.Code) then begin
                if not lrProd."Gestionado MdM" then
                    exit;

                if pwDelete then
                    lwPeso := 0
                else
                    lwPeso := prUnid.Weight;

                lwCambs[1] := true;
                NotifyProd(lrProd, 1, lwCambs);
                AddMstRegField(-103, Format(lwPeso), 'Peso'); // Virtual.
                ProcesaNotif;
            end;
        end;
    end;


    procedure GestNotityPrec(prXrPrec: Record "Price List Line"; var prPrec: Record "Price List Line"; pwDelete: Boolean)
    var
        lwPrecConImpt: array[2] of Decimal;
        lwPrecSinImpt: array[2] of Decimal;
        lrProd: Record Item;
        //lrPrec: Record "Sales Price";
        lrPrec: Record "Price List Line";
        //lrPrTmp: Record "Sales Price" temporary;
        lrPrTmp: Record "Price List Line" temporary;
        lwEnc: Boolean;
        lwCambs: array[10] of Boolean;
        lwDivisa: array[2] of Code[10];
        lwFechaPrec: Date;
    begin
        // GestNotityPrec

        if not rConfMdM.Activo then
            rConfMdM.Get;
        if not rConfMdM."Notifica a MdM" then
            exit;

        Clear(lwPrecConImpt);
        Clear(lwPrecSinImpt);
        Clear(lwDivisa);

        if not (prPrec."Asset Type" = prPrec."Asset Type"::"Item") then
            exit;
        if not lrProd.Get(prPrec."Product No.") then
            exit;
        if not lrProd."Gestionado MdM" then
            exit;

        // Si el código de unidad de medida no es la del producto, NO notifica nada
        //IF (lrProd."Base Unit of Measure" <> prPrec."Unit of Measure Code") THEN
        //  EXIT;

        // En vez de utilizar prXrPrec de entrada (que a veces viene mal) lo busco en la BBDD - JPT 29/03/2019
        // Rectifico  - No funciona en Rename
        /* No funciona en rename
        prXrPrec := prPrec;
        IF NOT prXrPrec.FIND THEN
          CLEAR(prXrPrec);
        */

        lwFechaPrec := GestFechaPrecio; // Fecha del día

        // OJO: Determinamos el ultimo precio de venta, no el actual
        // Actualización.... NI CASO realmente es el actual
        //Se cambia "Sales Type" por "Source Type" y "Sales Code" por "Assign-to No." para que funcione con el nuevo campo de la tabla de precios
        if (prXrPrec."Starting Date" <> prPrec."Starting Date") or (prXrPrec."Ending Date" <> prPrec."Ending Date") or
           (prXrPrec."Unit Price" <> prPrec."Unit Price") or (prXrPrec."Unit of Measure Code" <> prPrec."Unit of Measure Code") or
           (prXrPrec."Source Type" <> prPrec."Source Type") or (prXrPrec."VAT Bus. Posting Gr. (Price)" <> prPrec."VAT Bus. Posting Gr. (Price)") or
           (prXrPrec."Currency Code" <> prPrec."Currency Code") or (prXrPrec."Assign-to No." <> prPrec."Assign-to No.") or
           (prXrPrec."Price Includes VAT" <> prPrec."Price Includes VAT") or pwDelete then begin

            if (lrProd."Base Unit of Measure" = prPrec."Unit of Measure Code") then begin
                GetPrecioVta(lrProd, lwFechaPrec, lwPrecConImpt[1], lwPrecSinImpt[1], lwDivisa[1]); // Precios actuales

                // Utilizamos temporales para determinar el último precio de venta

                Clear(lrPrec);
                lrPrec.SetRange("Product No.", lrProd."No.");
                if lrPrec.FindSet then begin
                    repeat
                        lrPrTmp := lrPrec;
                        lrPrTmp.Insert;
                    until lrPrec.Next = 0;
                end;

                lrPrTmp := prPrec;
                lwEnc := lrPrTmp.Find;
                if lwEnc then begin
                    if pwDelete then
                        lrPrTmp.Delete
                    else begin
                        lrPrTmp := prPrec;
                        lrPrTmp.Modify
                    end;
                end
                else
                    if not pwDelete then begin
                        lrPrTmp := prPrec;
                        lrPrTmp.Insert;
                    end;


                // lrPrTmp.SETRANGE("Sales Type", lrPrTmp."Sales Type"::"All Customers");
                case rConfMdM."Tipo Precio Venta" of
                    rConfMdM."Tipo Precio Venta"::"Todos clientes":
                        lrPrTmp.SetRange("Source Type", lrPrTmp."Source Type"::"All Customers");
                    rConfMdM."Tipo Precio Venta"::"Grupo precio cliente":
                        begin
                            lrPrTmp.SetRange("Source Type", lrPrTmp."Source Type"::"Customer Price Group");
                            if rConfMdM."Grupo Precio Cliente" <> '' then
                                lrPrec.SetRange("Assign-to No.", rConfMdM."Grupo Precio Cliente");
                        end
                end;

                lrPrTmp.SetFilter("Currency Code", '%1', '');
                lrPrTmp.SetRange("Unit of Measure Code", lrProd."Base Unit of Measure");
                lrPrTmp.SetFilter("Starting Date", '<=%1', lwFechaPrec);
                lrPrTmp.SetFilter("Ending Date", '>=%1|%2', lwFechaPrec, 0D);
                lwEnc := lrPrTmp.FindLast;
                if lwEnc then begin
                    ConfPrecVta(lrProd, lrPrTmp, lwPrecConImpt[2], lwPrecSinImpt[2], lwDivisa[2]);
                end;
            end;
        end;

        if (lwPrecConImpt[1] <> lwPrecConImpt[2]) or (lwPrecSinImpt[1] <> lwPrecSinImpt[2]) or (lwDivisa[1] <> lwDivisa[2]) then begin
            Clear(lwCambs);
            //lwCambs[4] := TRUE;
            lwCambs[6] := true;
            lwCambs[7] := true;
            NotifyProd(lrProd, 1, lwCambs);
            AddMstRegField(-300, Format(lwPrecSinImpt[2], 0, 9), 'Precio_sin_Impuestos');  // Virtual.
            AddMstRegField(-325, Format(lwPrecConImpt[2], 0, 9), 'Precio_con_Impuestos');  // Virtual.
            lwDivisa[2] := GestCurrency(lwDivisa[2]); // Actualiza la moneda si es la local
            AddMstRegField(-501, lwDivisa[2], 'Moneda');  // Virtual.
            ProcesaNotif;
        end;

        // Crea una notificación a futuro
        // IF (lrPrTmp."Starting Date" <> prPrec."Starting Date") OR (lrPrTmp."Ending Date"  <> prPrec."Ending Date") OR pwDelete THEN
        //   cNotifPrec.CreaNotif(prPrec, pwDelete);
        cNotifPrec.CreaNotif2(prXrPrec, prPrec, pwDelete);

    end;


    procedure GestNotityPrecProd(prProd: Record Item)
    var
        lwPrecConImpt: Decimal;
        lwPrecSinImpt: Decimal;
        //lrPrec: Record "Sales Price";
        lrPrec: Record "Price List Line";
        lwCambs: array[10] of Boolean;
        lwDivisa: Code[10];
        lwFechaPrec: Date;
    begin
        // GestNotityPrecProd
        // Notifica el precio de un producto

        if not prProd."Gestionado MdM" then
            exit;

        if not rConfMdM.Activo then
            rConfMdM.Get;
        if not rConfMdM."Notifica a MdM" then
            exit;

        Clear(lwPrecConImpt);
        Clear(lwPrecSinImpt);
        Clear(lwDivisa);

        lwFechaPrec := GestFechaPrecio; // Fecha del día
        GetPrecioVta(prProd, lwFechaPrec, lwPrecConImpt, lwPrecSinImpt, lwDivisa); // Precios actuales

        Clear(lwCambs);
        //lwCambs[4] := TRUE;
        lwCambs[6] := true;
        lwCambs[7] := true;
        NotifyProd(prProd, 1, lwCambs);
        AddMstRegField(-300, Format(lwPrecSinImpt, 0, 9), 'Precio_sin_Impuestos');  // Virtual.
        AddMstRegField(-325, Format(lwPrecConImpt, 0, 9), 'Precio_con_Impuestos');  // Virtual.
        lwDivisa := GestCurrency(lwDivisa); // Actualiza la moneda si es la local
        AddMstRegField(-501, lwDivisa, 'Moneda');  // Virtual.
        ProcesaNotif;
    end;


    procedure GetPrecioVta(prProd: Record Item; pwFecha: Date; var pwPrecConImpt: Decimal; var pwPrecSinImpt: Decimal; var pwDivisa: Code[10]) wEnc: Boolean
    var
        //lrPrec: Record "Sales Price";
        lrPrec: Record "Price List Line";
    begin

        // GetPrecioVta

        Clear(pwPrecConImpt);
        Clear(pwPrecSinImpt);
        Clear(pwDivisa);

        Clear(lrPrec);

        if not rConfMdM.Activo then
            rConfMdM.Get;

        if pwFecha = 0D then
            pwFecha := GestFechaPrecio;

        lrPrec.SetRange("Asset Type", lrPrec."Asset Type"::"Item");
        lrPrec.SetRange("Product No.", prProd."No.");
        //lrPrec.SETRANGE("Sales Type", lrPrec."Sales Type"::"All Customers");
        case rConfMdM."Tipo Precio Venta" of
            rConfMdM."Tipo Precio Venta"::"Todos clientes":
                lrPrec.SetRange("Source Type", lrPrec."Source Type"::"All Customers");
            rConfMdM."Tipo Precio Venta"::"Grupo precio cliente":
                begin
                    lrPrec.SetRange("Source Type", lrPrec."Source Type"::"Customer Price Group");
                    if rConfMdM."Grupo Precio Cliente" <> '' then
                        //lrPrec.SetRange("Sales Code", rConfMdM."Grupo Precio Cliente");
                        lrPrec.SetRange("Assign-to No.", rConfMdM."Grupo Precio Cliente");
                end;
        end;
        lrPrec.SetFilter("Currency Code", '%1', ''); // Siempre en divisa local
        lrPrec.SetRange("Unit of Measure Code", prProd."Base Unit of Measure");
        if pwFecha <> 0D then begin
            lrPrec.SetFilter("Starting Date", '<=%1', pwFecha);
            lrPrec.SetFilter("Ending Date", '>%1|%2', pwFecha, 0D);
        end;
        wEnc := lrPrec.FindLast;
        if wEnc then begin
            ConfPrecVta(prProd, lrPrec, pwPrecConImpt, pwPrecSinImpt, pwDivisa);
        end;
    end;


    procedure FindVatConf(prProd: Record Item; prPrec: Record "Price List Line"; var prVatSetup: Record "VAT Posting Setup") Result: Boolean
    var
        lwGRIVAProd: Code[10];
        lwGRIVANeg: Code[10];
    begin
        // FindVatConf
        // Busca la configuración de IVA

        Result := false;
        Clear(lwGRIVANeg);
        Clear(lwGRIVAProd);
        Clear(prVatSetup);
        lwGRIVAProd := prProd."VAT Prod. Posting Group";
        if lwGRIVAProd <> '' then begin
            if prPrec."VAT Bus. Posting Gr. (Price)" <> '' then
                lwGRIVANeg := prPrec."VAT Bus. Posting Gr. (Price)"
            else
                if prProd."VAT Bus. Posting Gr. (Price)" <> '' then
                    lwGRIVANeg := prProd."VAT Bus. Posting Gr. (Price)"
                else
                    lwGRIVANeg := rConfMdM."VAT Bus. Posting Group";
            if lwGRIVANeg <> '' then
                Result := prVatSetup.Get(lwGRIVANeg, lwGRIVAProd);
        end;

        if not Result then
            Clear(prVatSetup);
    end;


    procedure ConfPrecVta(prProd: Record Item; prPrec: Record "Price List Line"; var pwPrecConImpt: Decimal; var pwPrecSinImpt: Decimal; var pwDivisa: Code[10])
    var
        lrVatSetup: Record "VAT Posting Setup";
        lrDiv: Record Currency;
    begin
        // ConfPrecVta

        if not FindVatConf(prProd, prPrec, lrVatSetup) then
            Clear(lrVatSetup);

        pwDivisa := prPrec."Currency Code";

        if pwDivisa = '' then
            lrDiv.InitRoundingPrecision
        else begin
            lrDiv.Get(pwDivisa);
            lrDiv.TestField("Amount Rounding Precision");
        end;

        if prPrec."Price Includes VAT" then begin
            pwPrecConImpt := prPrec."Unit Price";
            //pwPrecSinImpt := pwPrecConImpt / (1 + lrVatSetup."VAT %");
            pwPrecSinImpt := Round(pwPrecConImpt / (1 + lrVatSetup."VAT %" / 100), lrDiv."Amount Rounding Precision");
        end
        else begin
            pwPrecSinImpt := prPrec."Unit Price";
            //pwPrecConImpt := pwPrecSinImpt * (1 + lrVatSetup."VAT %");
            pwPrecConImpt := Round(pwPrecSinImpt * (1 + lrVatSetup."VAT %" / 100), lrDiv."Amount Rounding Precision");
        end;
    end;


    procedure ProcesaNotif()
    var
        NewSessionId: Integer;
    begin
        // ProcesaNotif

        PasarAReal2(false);
        if rCabRl.FindSet then begin
            Commit;
            repeat
                // Lo ejecutamos en otra sesión para que no perjudique al usuario...
                // cAsynMng.TraspasaCab(rCabRl);
                StartSession(NewSessionId, CODEUNIT::"MdM Async Sender", CompanyName, rCabRl);
            until rCabRl.Next = 0;
        end;
    end;


    procedure GestColaProy(prStatus: Option Ready,Hold)
    var
        lrMvJobQ: Record "Job Queue Entry";
        lwActDT: DateTime;
        lrJobLog: Record "Job Queue Log Entry";
    begin
        // GestColaProy

        //fes mig
        /*
        IF NOT rConfMdM.Activo THEN
          rConfMdM.GET;
        IF NOT rConfMdM."Activar Cola Proy. Auto." THEN
          EXIT;
        
        rConfMdM.TESTFIELD("Cola proyecto");
        rConfMdM.TESTFIELD("Mov. cola proyecto");
        
        // El activa el mov cola de proyecto
        CLEAR(lrMvJobQ);
        lrMvJobQ.GET(rConfMdM."Mov. cola proyecto");
        
        // Nos aseguramos de darnos un minuto por lo menos
        lwActDT := CURRENTDATETIME + 60000; // Añadimos un minuto
        IF lrMvJobQ."Earliest Start Date/Time" < lwActDT THEN BEGIN
          lrMvJobQ."Earliest Start Date/Time" := lwActDT;
          lrMvJobQ.MODIFY;
        END;
        
        // Se activa la cola de proyecto (No se desativa)
        IF prStatus = prStatus::Ready THEN BEGIN
          CLEAR(lrJobQ);
          lrJobQ.GET(rConfMdM."Cola proyecto");
          lrJobQ.StartQueueFromUI(COMPANYNAME);
        END;
        
        // Movimientos de cola de proyecto
        CASE prStatus OF
          prStatus::Ready : IF lrMvJobQ.Status <> lrMvJobQ.Status::Ready THEN BEGIN
                              lrMvJobQ."Hold On Finish" := FALSE;
                              lrMvJobQ.SetStatus(lrMvJobQ.Status::Ready);
                            END;
          prStatus::Hold  : CASE lrMvJobQ.Status OF
                              lrMvJobQ.Status::Ready        : BEGIN
                                                                lrMvJobQ."Hold On Finish" := FALSE;
                                                                lrMvJobQ.SetStatus(lrMvJobQ.Status::"On Hold");
                                                              END;
                              lrMvJobQ.Status::"In Process" : BEGIN
                                                                lrMvJobQ."Hold On Finish" := TRUE;
                                                                lrMvJobQ.MODIFY;
                                                              END;
                           END;
        
        END;
        */
        //fes mig

    end;


    procedure ActColaProy()
    var
        lrJobLog: Record "Job Queue Log Entry";
        lrUserStp: Record "User Setup";
    begin
        // ActColaProy
        // Activa la cola de proyecto (solo la cola no el movimiento)

        //fes mig
        /*
        IF NOT rConfMdM.Activo THEN
          rConfMdM.GET;
        IF NOT rConfMdM."Activar Cola Proy. Auto." THEN
          EXIT;
        
        // JPT 28/01/19 Buscamos que el usario tenga permisos super
        IF lrUserStp.GET(USERID) THEN BEGIN
          IF NOT lrUserStp."Arranca Cola Proyecto MdM" THEN
            EXIT;
        END ELSE
          EXIT;
        
        IF GUIALLOWED THEN
          rConfMdM.TESTFIELD("Cola proyecto");
        
        // Se activa la cola de proyecto (No se desativa)
        CLEAR(lrJobQ);
        lrJobQ.GET(rConfMdM."Cola proyecto");
        lrJobQ.StartQueueFromUI(COMPANYNAME);
        */
        //fes mig

    end;


    procedure TrasPasaCab(var prCab: Record "Imp.MdM Cabecera")
    begin
        // TrasPasaCab

        //prCab.TESTFIELD(Estado, prCab.Estado::Pendiente);
        if prCab.Entrada = prCab.Entrada::INT_Excel then
            cTrasp.Run(prCab)
        else
            cAsynMng.TraspasaCab(prCab);
    end;


    procedure RespNoAplica(var prImp: Record "Imp.MdM Tabla" temporary)
    begin
        // RespNoAplica
        // Respuesta de algunos llamadas a elementos que no Aplican a Navision

        exit; // No debe de devolverse valor

        if prImp."Id Tabla" <> -1 then  // Si no es un elemento No aplicable
            exit;

        if prImp.Code <> '' then
            exit;

        // No debe de devolverse valor
        /*
        CASE prImp.Tipo OF
          ELSE prImp.Code := prImp."Code MdM";
        END;
        */

    end;


    procedure SetAlowEmptyValues(pwAllow: Boolean)
    begin
        // SetAlowEmptyValues
        wAllowEmptyValues := pwAllow;
    end;


    procedure GetAlowEmptyValues() wAllow: Boolean
    begin
        // GetAlowEmptyValues

        exit(wAllowEmptyValues);
    end;


    procedure GestCurrency(pwDivisa: Code[10]) Result: Code[10]
    begin
        // GestCurrency
        // Si la divisa en blanco, busca la configurada en la empresa

        Result := pwDivisa;
        if Result = '' then begin
            if not rConfMdM.Activo then
                rConfMdM.Get;
            Result := rConfMdM."Divisa Local MdM";
        end;
    end;


    procedure GestFechaPrecio() wFecha: Date
    begin
        // GestFechaPrecio
        // Función para poder definir en un momento dado si la fecha la tomamos la del sistema o la de trabajo

        wFecha := Today;
    end;


    procedure SetEstrAnalitica(var prProd: Record Item) Result: Boolean
    var
        lwCod: Code[21];
        lwCod2: Code[21];
        lrConfEA: Record "Conf. Estructura Analitica";
        lwN: Integer;
        lwFId: Integer;
        lwRecR: RecordRef;
        lrFieldR: FieldRef;
        lrValBff: Record "Filtro Valor Campo Buffer" temporary;
        lPValBff: Page "Filtro Valor Campo";
        lwVal: Variant;
    begin
        // SetEstrAnalitica
        // Se ha creado una automatización de campos por estructura analítica

        Result := false;

        lwCod := prProd."Estructura Analitica";
        if lwCod = '' then
            exit;

        Clear(lwCod2);
        Clear(lwN);

        lwRecR.GetTable(prProd);
        //prProd.COPY(prProd);
        repeat
            lwN += 3;
            lwCod2 := CopyStr(lwCod, 1, lwN);
            Clear(lrConfEA);
            lrConfEA.SetRange(Codigo, lwCod2);
            if lrConfEA.FindSet then begin
                Result := true;
                repeat
                    lwFId := lrConfEA."Id Field";
                    if lwFId > 0 then begin
                        lrFieldR := lwRecR.Field(lwFId);
                        lPValBff.GetFieldValue(lrFieldR, lrConfEA.Valor, lwVal);
                        lrFieldR.Validate(lwVal);
                        case lwFId of
                            56022:
                                prProd.Validate("Grupo de Negocio", lrConfEA.Valor) // Grupo Negocio
                        end;
                    end;
                until lrConfEA.Next = 0;
            end;
        until (lwCod = lwCod2);

        lwRecR.SetTable(prProd);
    end;


    procedure SetCamposRelacionados(var prProd: Record Item) Result: Boolean
    var
        lrCampRel: Record "Conf. Campos Relacionados";
        lrCRlTmp: Record "Conf. Campos Relacionados" temporary;
        lrFieldsTmp: Record "Integer" temporary;
        lwIdFieldOr: Integer;
        lwIdFieldDs: Integer;
        lwIdDim: Integer;
        lwFieldValOr: Text;
        lwFieldValDs: Text;
        lwRecf: RecordRef;
        lwFieldRef: FieldRef;
        lwVal: Variant;
    begin
        // SetCamposRelacionados
        // Devuelve true si se ha cambiado algo

        Clear(lrCampRel);
        Result := false;

        // Temporal de campos a considerar
        // Para que sea un poco más rápido No consideraremos todos los campos

        Clear(lrFieldsTmp);
        if lrCampRel.FindSet then begin
            repeat
                if lrCampRel."Id Fld Origen" <> 0 then begin
                    if not lrFieldsTmp.Get(lrCampRel."Id Fld Origen") then begin
                        lrFieldsTmp.Number := lrCampRel."Id Fld Origen";
                        lrFieldsTmp.Insert;
                    end;
                end;
            until lrCampRel.Next = 0;
        end;

        // Por cada campo configurado
        Clear(lrCampRel);
        lrCampRel.SetCurrentKey("Id Fld Origen", "Valor Origen");
        if lrFieldsTmp.FindSet then begin
            lwRecf.GetTable(prProd);
            repeat
                lwIdFieldOr := lrFieldsTmp.Number;
                if lwIdFieldOr > 0 then begin
                    lwFieldRef := lwRecf.Field(lwIdFieldOr);
                    lwFieldValOr := DelChr(Format(lwFieldRef.Value), '<>');
                end
                else begin // Campos Virtuales
                    case lwIdFieldOr of
                        -299 .. -200:
                            begin // Dimensiones
                                lwIdDim := Abs(lwIdFieldOr + 200);
                                lwFieldValOr := cFuncMdm.GetDimValueT(prProd."No.", lwIdDim);
                            end;
                    end;
                end;

                lwFieldValOr := DelChr(lwFieldValOr, '<>');
                lrCampRel.SetRange("Id Fld Origen", lwIdFieldOr);
                lrCampRel.SetRange("Valor Origen", lwFieldValOr);
                if lrCampRel.FindSet then begin // Pueden informarse diversos destinos por cada origen
                    Result := true;
                    repeat
                        // Evitamos una referencia circular
                        lrCRlTmp := lrCampRel;
                        if lrCRlTmp.Find then
                            Error(Text005, lrCampRel.TableCaption, lrCampRel.Id, prProd."No.")
                        else
                            lrCRlTmp.Insert;

                        lwIdFieldDs := lrCampRel."Id Fld Destino";
                        lwFieldValDs := DelChr(lrCampRel."Valor Destino");
                        if lwIdFieldDs > 0 then begin
                            lwFieldRef := lwRecf.Field(lwIdFieldDs);
                            cTrasp.GetFieldValue(lwFieldRef, lwFieldValDs, lwVal);
                            lwFieldRef.Validate(lwVal);
                        end
                        else begin  // Campos Virtuales
                            case lwIdFieldDs of
                                -299 .. -200:
                                    begin // Dimensiones
                                        lwIdDim := Abs(lwIdFieldDs + 200);
                                        cFuncMdm.ValidaDimValT(prProd, lwIdDim, lwFieldValDs);
                                    end;
                            end;
                        end;
                    until lrCampRel.Next = 0;
                end;
            until lrFieldsTmp.Next = 0;
        end;

        if Result then
            lwRecf.SetTable(prProd);
    end;


    procedure SetCamposRelacionados2(var prProd: Record Item; var prTmpField: Record "Imp.MdM Campos" temporary) Result: Boolean
    var
        lrCampRel: Record "Conf. Campos Relacionados";
        lrCRlTmp: Record "Conf. Campos Relacionados" temporary;
        lrFieldsTmp: Record "Integer" temporary;
        lwIdFieldOr: Integer;
        lwIdFieldDs: Integer;
        lwIdDim: Integer;
        lwFieldValOr: Text;
        lwFieldValDs: Text;
        lwRecf: RecordRef;
        lwFieldRef: FieldRef;
        lwVal: Variant;
    begin
        // SetCamposRelacionados2
        // Devuelve true si se ha cambiado algo

        Clear(prTmpField);
        Clear(lrCampRel);
        Result := false;

        // Temporal de campos a considerar
        // Para que sea un poco más rápido No consideraremos todos los campos

        Clear(lrFieldsTmp);
        if lrCampRel.FindSet then begin
            repeat
                if lrCampRel."Id Fld Origen" <> 0 then begin
                    // Miramos que esté en la importación
                    prTmpField.SetRange("Id Field", lrCampRel."Id Fld Origen");
                    if prTmpField.FindFirst then begin
                        if not lrFieldsTmp.Get(lrCampRel."Id Fld Origen") then begin
                            lrFieldsTmp.Number := lrCampRel."Id Fld Origen";
                            lrFieldsTmp.Insert;
                        end;
                    end;
                end;
            until lrCampRel.Next = 0;
        end;

        // Por cada campo configurado
        Clear(lrCampRel);
        lrCampRel.SetCurrentKey("Id Fld Origen", "Valor Origen");
        if lrFieldsTmp.FindSet then begin
            lwRecf.GetTable(prProd);
            repeat
                lwIdFieldOr := lrFieldsTmp.Number;
                if lwIdFieldOr > 0 then begin
                    lwFieldRef := lwRecf.Field(lwIdFieldOr);
                    lwFieldValOr := DelChr(Format(lwFieldRef.Value), '<>');
                end
                else begin // Campos Virtuales
                    case lwIdFieldOr of
                        -299 .. -200:
                            begin // Dimensiones
                                lwIdDim := Abs(lwIdFieldOr + 200);
                                lwFieldValOr := cFuncMdm.GetDimValueT(prProd."No.", lwIdDim);
                            end;
                    end;
                end;

                lwFieldValOr := DelChr(lwFieldValOr, '<>');
                lrCampRel.SetRange("Id Fld Origen", lwIdFieldOr);
                lrCampRel.SetRange("Valor Origen", lwFieldValOr);
                if lrCampRel.FindSet then begin // Pueden informarse diversos destinos por cada origen
                    Result := true;
                    repeat
                        // Evitamos una referencia circular
                        lrCRlTmp := lrCampRel;
                        if lrCRlTmp.Find then
                            Error(Text005, lrCampRel.TableCaption, lrCampRel.Id, prProd."No.")
                        else
                            lrCRlTmp.Insert;

                        lwIdFieldDs := lrCampRel."Id Fld Destino";
                        lwFieldValDs := DelChr(lrCampRel."Valor Destino");
                        if lwIdFieldDs > 0 then begin
                            lwFieldRef := lwRecf.Field(lwIdFieldDs);
                            cTrasp.GetFieldValue(lwFieldRef, lwFieldValDs, lwVal);
                            lwFieldRef.Validate(lwVal);
                        end
                        else begin  // Campos Virtuales
                            case lwIdFieldDs of
                                -299 .. -200:
                                    begin // Dimensiones
                                        lwIdDim := Abs(lwIdFieldDs + 200);
                                        cFuncMdm.ValidaDimValT(prProd, lwIdDim, lwFieldValDs);
                                    end;
                            end;
                        end;
                    until lrCampRel.Next = 0;
                end;
            until lrFieldsTmp.Next = 0;
        end;

        if Result then
            lwRecf.SetTable(prProd);
    end;
}

