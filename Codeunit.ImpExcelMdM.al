codeunit 75002 "Imp Excel MdM"
{

    trigger OnRun()
    begin
    end;

    var
        Text0001: Label 'No se ha encontrado relación de tabla de la pestaña %1';
        wFieldsNo: array[100] of Integer;
        wFieldsName: array[100] of Text[100];
        wExcelBuf: Record "Excel Buffer" temporary;
        cFileMng: Codeunit "File Management";
        Text0002: Label 'Abrir Excel';
        Text0003: Label 'No existe %1';
        Text0004: Label 'Importando Valores MdM';
        wDia: Dialog;
        Text0005: Label 'Operación Terminada';
        Text0006: Label 'No ha quedado definido el destino del valor %1';
        wTotalFlds: Integer;
        cGesImptMdm: Codeunit "Gest. Maestros MdM";
        cFubMdM: Codeunit "Funciones MdM";
        cTrasp: Codeunit "MdM Gen. Prod.";


    procedure ImportaFile(pwTodas: Boolean; pwOperacion: Option Insert,Update,Delete)
    var
        lwFileName: Text;
    begin
        // ImportaFile

        lwFileName := GetFilenameDialog;
        Importa(lwFileName, pwTodas, pwOperacion);
    end;


    procedure Importa(pwFileName: Text; pwTodas: Boolean; pwOperacion: Option Insert,Update,Delete)
    var
        lwSheetNames: array[50] of Text;
        lwSheetName: Text;
        lwFila: Integer;
        lwTipo: Integer;
        lwTableId: Integer;
        lwPTotal: Integer;
        lwInt: Integer;
        lwCodProds: Text;
        lwPgn: Integer;
        lwDef: Boolean;
        lwCol: Integer;
        lwTotalRows: Integer;
        lwMdMTabla: Record "Imp.MdM Tabla" temporary;
        lRecRef: RecordRef;
        lwFieRef: FieldRef;
        lwOk: Boolean;
        lwValue: Text[250];
        lwFilename2: Text;
        lwDefFields: array[3] of Integer;
    begin
        // Importa
        // pwTodas Indica que se quieren importar a la vez todas las pestañas de la hoja


        //pwFileName := wFileMng.OpenFileDialog(Text0002, '(Excel|*.xlsx|All Files (*.*)|*.*,', '');

        cGesImptMdm.ResetAll;

        if pwFileName = '' then
            exit;

        /*    if not cFileMng.ClientFileExists(pwFileName) then
               Error(Text0003, pwFileName);
    */

        /*     lwFilename2 := cFileMng.UploadFileSilent(pwFileName);
     */
        /*  Clear(lwSheetNames);
         lwPTotal := 0;
         if pwTodas then
             lwPTotal := wExcelBuf.FindAllSheetsNames(lwFilename2, lwSheetNames)
         else begin
             lwSheetNames[1] := wExcelBuf.SelectSheetsName(lwFilename2);
             if lwSheetNames[1] <> '' then
                 lwPTotal := 1;
         end;
  */
        if lwPTotal = 0 then
            exit;

        cGesImptMdm.AddMstRegHeader(pwOperacion, 1); // Cabecera de importacion

        // LO que hacemos ahor es dejar la pagina de productos para el final ya que es necesario pasar antes todas las demás auxiliares
        if lwPTotal > 1 then begin
            lwCodProds := 'PRODUCTOS';
            for lwPgn := 1 to lwPTotal - 1 do begin
                if lwSheetNames[lwPgn] = lwCodProds then begin
                    lwSheetNames[lwPgn] := lwSheetNames[lwPTotal];
                    lwSheetNames[lwPTotal] := lwCodProds;
                    lwPgn := lwPTotal - 1; // Terminamos el bucle
                end;
            end;
        end;

        wDia.Open(Text0004 + '\#1###############################\@2@@@@@@@@@@@@@@@@@@@@@@@@@');

        for lwPgn := 1 to lwPTotal do begin
            lwSheetName := lwSheetNames[lwPgn];
            lwTipo := GetIdTipo(lwSheetName);
            lwTableId := GetIdTabla(lwSheetName);
            if lwTableId > 0 then begin
                if lwPgn = 1 then
                    /*   wExcelBuf.OpenBook(lwFilename2, lwSheetName); */
                    /*    wExcelBuf.ReadSheet2(lwSheetName, false);
        */
                lwFila := 0;

                wDia.Update(1, lwSheetName);
                FillArrays(lwTableId);
                Clear(lwTotalRows);
                //wExcelBuf.RESET;
                if wExcelBuf.FindLast then
                    lwTotalRows := wExcelBuf."Row No.";

                if lwTotalRows > 2 then begin
                    for lwFila := 3 to lwTotalRows do begin  // Las dos primeras filas no se tienen en cuenta

                        wDia.Update(2, Round(lwFila / lwTotalRows * 10000, 1));

                        Clear(lwMdMTabla);
                        lwMdMTabla."Id Tabla" := lwTableId;
                        if lwTipo >= 0 then // Tipo Predeterminado
                            lwMdMTabla.Tipo := lwTipo
                        else
                            lwMdMTabla.Tipo := -1;

                        // Los tres campos por defecto
                        lwDefFields[1] := lwMdMTabla.GetIdCodeField;
                        lwDefFields[2] := lwMdMTabla.GetIdDescField;
                        lwDefFields[3] := lwMdMTabla.GetIdTipoField;

                        cGesImptMdm.AddMstReg(pwOperacion, lwTableId, lwTipo, '', '', lwSheetName, ''); // Inserta la cabecera de tabla
                        for lwCol := 1 to wTotalFlds do begin
                            if wExcelBuf.Get(lwFila, lwCol) then begin
                                //lwValue := DELCHR(wExcelBuf."Cell Value as Text",'<>'); // Le quitamos los espacios en blanco
                                lwValue := GestVal(wExcelBuf."Cell Value as Text");

                                if UpperCase(lwValue) <> '' then begin // El valor no se importará ni modificará
                                    if wFieldsNo[lwCol] = lwDefFields[1] then
                                        lwMdMTabla.Code := lwValue;

                                    if wFieldsNo[lwCol] = lwDefFields[2] then
                                        lwMdMTabla.Descripcion := lwValue;

                                    if (lwTipo = -1) and (wFieldsNo[lwCol] = lwDefFields[3]) then begin
                                        lwOk := Evaluate(lwInt, lwValue);
                                        if not lwOk then begin // Miramos si es un valor Option
                                            lRecRef.Open(lwTableId);
                                            lwFieRef := lRecRef.Field(wFieldsNo[3]);
                                            if UpperCase(Format(lwFieRef.Type)) = 'OPTION' then begin
                                                lwInt := cTrasp.GeOptionValueId(lwFieRef.OptionCaption, lwValue);
                                                if lwInt = -1 then
                                                    //lwInt := cTrasp.GeOptionValueId(lwFieRef.OptionString, lwValue);
                                                    lwInt := cTrasp.GeOptionValueId(lwFieRef.OptionMembers, lwValue);
                                                lwOk := lwInt > -1;
                                            end;
                                            lRecRef.Close;
                                            Clear(lwFieRef);
                                        end;
                                        if lwOk then
                                            lwMdMTabla.Tipo := lwInt;
                                    end;

                                    lwDef := false;
                                    if lwCol in [1 .. 3] then
                                        lwDef := (wFieldsNo[lwCol] = lwDefFields[lwCol]);
                                    if not lwDef then
                                        cGesImptMdm.AddMstRegField(wFieldsNo[lwCol], lwValue, wFieldsName[lwCol]); // Si no es un valor por defecto
                                end;
                            end;
                        end;

                        // Dimension Value .
                        if (lwTableId = 349) and (lwTipo > -1) then //  Introducimos "Dimension Code"
                            cGesImptMdm.AddMstRegField(1, cFubMdM.GetDimCode(lwTipo, true), 'CODE');
                        // Rellenamos los campos principales de la tabla
                        cGesImptMdm.UpdtMstReg(lwMdMTabla.Tipo, lwMdMTabla.Code, lwMdMTabla.Descripcion, '');
                    end;
                end;
            end;
        end;

        wExcelBuf.QuitExcel;
        wDia.Close;
        cGesImptMdm.ImpCabExcel;

        Message(Text0005);
    end;


    procedure GetIdTabla(pwCode: Code[30]) wId: Integer
    begin
        // GetIdTabla
        // Devuelve el Id de Tabla según la pestaña

        wId := 0;

        case pwCode of
            'PRODUCTOS':
                wId := 27;     // Item
            'SOCIEDAD':
                wId := 75001;  // Datos MDM;
            'TIPOLOG´A':
                wId := 5722;   // Item Category
            'TIPO PRODUCTO':
                wId := 75001;  // Datos MDM;
            'SOPORTE':
                wId := 75001;  // Datos MDM;
            'EMPRESA EDITORA':
                wId := 75001;  // Datos MDM;
            'L´NEA':
                wId := 75001;  // Datos MDM;
            'SELLO':
                wId := 75001;  // Datos MDM;
            'IDIOMA':
                wId := 8;      // Language
            'SERIE MÉTODO':
                wId := 349;    // Dimension Value
            'AUTOR':
                wId := 75001;  // Datos MDM;
            'PA´S':
                wId := 9;      // Country/Region
            'PLAN EDITORIAL':
                wId := 75001;  // Datos MDM;
            'EDICIÊN':
                wId := 75001;  // Datos MDM;
            'DESTINO':
                wId := 349;    // Dimension Value
            'CUENTA':
                wId := 349;    // Dimension Value;
            'ESTRUCTURA ANAL´TICA':
                wId := 75002;  // Estructura Analitica
            'ESTADO':
                wId := 75001;  // Datos MDM;
            'TIPO TEXTO':
                wId := 349;    // Dimension Value
            'ASIGNATURA':
                wId := 75001;  // Datos MDM;
            'MATERIA':
                wId := 349;    // Dimension Value
            'CURSO':
                wId := 75001;  // Datos MDM;      // Grado
            'CARGA HORARIA':
                wId := 349;    // Dimension Value
            'ORIGEN':
                wId := 349;    // Dimension Value
            'CICLO':
                wId := 75001;  // Datos MDM;
            'NIVEL':
                wId := 75001;  // Datos MDM;
            'CAMPAÑA':
                wId := 75001;  // Datos MDM;
        end;

        if wId = 0 then
            wId := ExtractTableId(pwCode);

        if wId = 0 then
            Error(Text0001, pwCode);
    end;


    procedure GetIdTipo(pwCode: Code[30]) wTipo: Integer
    begin
        // GetIdTabla
        // Devuelve el Id del Tipo Fijo según la pestaña

        wTipo := -1; // Si no encuntra nada, delvuelve -1

        case pwCode of
            'SERIE MÉTODO':
                wTipo := 0;    // Dimension Value
            'DESTINO':
                wTipo := 1;    // Dimension Value
            'CUENTA':
                wTipo := 2;    // Dimension Value
            'TIPO TEXTO':
                wTipo := 3;    // Dimension Value
            'MATERIA':
                wTipo := 4;    // Dimension Value
            'CARGA HORARIA':
                wTipo := 5;    // Dimension Value
            'ORIGEN':
                wTipo := 6;    // Dimension Value

            'TIPO PRODUCTO':
                wTipo := 0;  // Datos MDM;
            'SOPORTE':
                wTipo := 1;  // Datos MDM;
            'EMPRESA EDITORA':
                wTipo := 2;  // Datos MDM;
            'SOCIEDAD':
                wTipo := 2;  // Datos MDM; // Tiene el mismo valor que "EMPRESA EDITORA"
            'NIVEL':
                wTipo := 3;  // Datos MDM;
            'PLAN EDITORIAL':
                wTipo := 4;  // Datos MDM;
            'AUTOR':
                wTipo := 5;  // Datos MDM;
            'CICLO':
                wTipo := 6;  // Datos MDM;
            'L´NEA':
                wTipo := 7;  // Datos MDM;
            'ASIGNATURA':
                wTipo := 8;  // Datos MDM;
            'CURSO':
                wTipo := 9;  // Datos MDM; // Grado
            'SELLO':
                wTipo := 10; // Datos MDM;
            'EDICIÊN':
                wTipo := 11; // Datos MDM;
            'ESTADO':
                wTipo := 12; // Datos MDM;
            'CAMPAÑA':
                wTipo := 13; // Datos MDM;
        end;
    end;


    procedure FillArrays(pwTableId: Integer) wDef: Boolean
    var
        lwN: Integer;
        lwTotal: Integer;
        lwMdMTabla: Record "Imp.MdM Tabla" temporary;
        lwIdsDefs: array[10] of Integer;
        lwMax: Integer;
    begin
        // FillArrays
        // Devuelve true si se han definido los valores de campos por defecto según la id de tabla,
        // Eso es, que no hace falta registros de campos

        Clear(wFieldsNo);
        if pwTableId = 0 then
            exit;

        // Buscamos si se han establecido los numeros de campos en la primera fila (Productos)
        //wExcelBuf.RESET;
        wExcelBuf.SetRange("Row No.", 2); // Segunda Fila, Las cabeceras. Definimos el total de campos a importar
        wTotalFlds := wExcelBuf.Count;
        if wExcelBuf.FindSet then begin
            repeat
                wFieldsName[wExcelBuf."Column No."] := wExcelBuf."Cell Value as Text";
            until wExcelBuf.Next = 0;
        end;

        wExcelBuf.SetRange("Row No.", 1); // Primera Fila, Total de cabeceras que esta definido expresamente el numero de campo
        lwTotal := wExcelBuf.Count;
        if lwTotal > wTotalFlds then
            wTotalFlds := lwTotal;
        if wExcelBuf.FindSet then begin
            repeat
                if Evaluate(lwN, wExcelBuf."Cell Value as Text") then
                    wFieldsNo[wExcelBuf."Column No."] := lwN;
            until wExcelBuf.Next = 0;
        end;


        // Si no está definido expresamente determinamos los tres primeros valores como Codigo, Descripción, Tipo
        // El valor predefinido tiene prioridad
        lwMdMTabla."Id Tabla" := pwTableId;
        lwIdsDefs[1] := lwMdMTabla.GetIdCodeField;
        lwIdsDefs[2] := lwMdMTabla.GetIdDescField;
        lwIdsDefs[3] := lwMdMTabla.GetIdTipoField;

        // wDef Determina que los tres primeros valores son por defecto
        lwMax := 0;
        lwN := 1;
        while (lwN <= 3) and (lwN <= wTotalFlds) and (lwIdsDefs[lwN] <> 0) and ((wFieldsNo[lwN] = 0) or (wFieldsNo[lwN] = lwIdsDefs[lwN])) do begin
            lwMax += 1;
            lwN += 1;
        end;

        wDef := lwMax > 0;

        for lwN := 1 to 3 do begin
            if wFieldsNo[lwN] = 0 then
                wFieldsNo[lwN] := lwIdsDefs[lwN];
        end;

        wExcelBuf.SetRange("Row No.");
        //wExcelBuf.RESET;

        //Comprobamos que se han rellanado todos los ids de campo
        for lwN := 1 to wTotalFlds do begin
            if wFieldsNo[lwN] = 0 then begin
                wExcelBuf.Get(2, lwN);
                Error(Text0006, wExcelBuf."Cell Value as Text");
            end;
        end;
    end;


    procedure GetFilenameDialog() wFilename: Text
    begin
        // GetFilenameDialog

        /*    wFilename := cFileMng.OpenFileDialog(Text0002, '', '(Excel|*.xlsx|All Files (*.*)|*.*,'); */
    end;


    procedure ExtractTableId(pwCode: Code[30]) wId: Integer
    var
        lwCode2: Code[30];
        lwN: Integer;
        lwCh: Char;
        lwOK: Integer;
        lwId: Integer;
    begin
        // ExtractTableId
        // Devuelve el numero de tabla si esta en algún punto del nombre de hoja entre #. Por ejempo "Articulo #27#" devolvería 27

        wId := 0;

        if pwCode = '' then
            exit;

        Clear(lwCode2);
        lwOK := 0;
        for lwN := 1 to StrLen(pwCode) do begin
            lwCh := pwCode[lwN];
            if lwOK = 1 then begin
                if lwCh in ['0' .. '9'] then
                    lwCode2 := lwCode2 + Format(lwCh)
                else
                    lwOK += 1;
            end;
            if lwCh in ['#'] then
                lwOK += 1;
        end;

        if Evaluate(lwId, lwCode2) then
            wId := lwId;
    end;


    procedure GestVal(pwText: Text) Result: Text
    var
        lwCR: Char;
        lwText2: Text;
        lwPos: Integer;
    begin
        // GestVal

        lwCR := 13; // Salto de Linea
        Result := pwText;
        Result := DelChr(Result, '=', Format(lwCR));
        lwCR := 10; //
        Result := DelChr(Result, '=', Format(lwCR));

        lwText2 := '_x000D_';
        lwPos := StrPos(Result, lwText2);
        while lwPos <> 0 do begin
            Result := DelStr(Result, lwPos, StrLen(lwText2));
            lwPos := StrPos(Result, lwText2);
        end;

        Result := DelChr(Result, '<>');
    end;
}

