codeunit 75007 "MdM Gen. Prod."
{
    // Proyecto: Microsoft Dynamics Business Central on Premise Santillana
    // AMS     : Agustin Mendez
    // FES     : Fausto Serrata
    // ----------------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ----------------------------------------------------------------------------------
    // 001     06-09-2023      FES           SANTINAV-4973 - No producto común - Cod MDM
    // 
    // 
    // Tengase en cuenta que, en esta ocasión,  tanto rImp como rCab y rField son registros REALES no temporales

    TableNo = "Imp.MdM Cabecera";

    trigger OnRun()
    begin

        //Introduce los valores de las tablas temporales


        rCab := Rec;
        rCab.SetRecFilter;

        Code(rCab);

        Rec.Traspasado := true;
        Rec.Estado := Rec.Estado::Finalizado;
        Rec.Modify;
    end;

    var
        cFuncMdm: Codeunit "Funciones MdM";
        cFileMng: Codeunit "File Management";
        cAsynMng: Codeunit "MdM Async Manager";
        cGestMdM: Codeunit "Gest. Maestros MdM";
        rConfMdM: Record "Configuracion MDM";
        NoSeriesMgt: Codeunit "No. Series";
        rImp: Record "Imp.MdM Tabla";
        rCab: Record "Imp.MdM Cabecera";
        rField: Record "Imp.MdM Campos";
        Text001: Label 'El tipo de dato %1 no está permitido en la importación de datos. Campo %2';
        rTmpField: Record "Imp.MdM Campos" temporary;
        rConvNM: Record "Conversion NAV MdM";
        wIds: array[3] of Integer;
        Text002: Label '%1 No es un valor permitido para %2.\ Los valores permitidos son %3';
        wDia: Dialog;
        wTotal: Integer;
        wCont: Integer;
        Text003: Label 'Traspasando';
        wStep: Integer;
        wClaveMdM: Code[20];


    procedure "Code"(var prCab: Record "Imp.MdM Cabecera")
    var
        Item: Record Item;
        lrCabR: Record "Imp.MdM Cabecera";
        lrLinBom: Record "BOM Component";
        RecRef: RecordRef;
        FieRef: FieldRef;
        lwKeyRef: KeyRef;
        ValDecimal: Decimal;
        ValInteger: Integer;
        ValDate: Date;
        ValDateTime: DateTime;
        ValBoolean: Boolean;
        Dim1: Code[20];
        Dim2: Code[20];
        BlockedFieldNo: Integer;
        lwId2: Integer;
        lwMod: Boolean;
        lwVerDia: Boolean;
        lwPack: Code[20];
        lwDec: Decimal;
        lwCodDim: Code[20];
        lwFieldValue: Text;
        lwMngd: Boolean;
        lwN: Integer;
        lwOK: Boolean;
    begin
        Commit;

        if not rConfMdM.Activo then
            rConfMdM.Get;

        lwVerDia := GuiAllowed; // Ver el cuadro de dialogo

        if prCab.Id = 0 then
            exit;

        rImp.Reset;
        if Item.Count > 10000 then
            rImp.SetCurrentKey("Id Cab.");
        rImp.SetRange("Id Cab.", prCab.Id);
        rImp.SetFilter("Id Tabla", '>0');
        rImp.SetRange(Procesado, false);
        if rImp.FindSet then begin
            // Muestra dialogo
            if lwVerDia then begin
                wDia.Open(Text003 + '\#1##############\@2@@@@@@@@@@@@@@@');
                wTotal := rImp.Count;
                wCont := 0;
                wStep := wTotal div 100;
                if wStep = 0 then
                    wStep := 1;
            end;

            repeat
                if lwVerDia then begin
                    wCont += 1;
                    if wCont mod wStep = 0 then begin
                        wDia.Update(1, rImp."Nombre Elemento");
                        wDia.Update(2, Round(wCont / wTotal * 10000, 1));
                    end;
                end;

                Clear(RecRef);
                RecRef.Open(rImp."Id Tabla");
                RecRef.Init;

                // Comprobamos si s precisan conversion
                ConvierteTabl(rImp, true);
                FillTempFields(rImp); // Crea un temporal de campos
                Clear(rField);
                rField.SetCurrentKey("Id Rel", Orden, Id); // Por orden
                rField.SetRange("Id Rel", rImp.Id);
                rField.SetRange("Id Cab.", rImp."Id Cab.");
                if rField.FindSet then begin
                    repeat
                        ConvierteField(rImp, rField, true); // Algunos campos precisan conversion
                    until rField.Next = 0;
                end;

                FillPrimKey(RecRef);

                case rImp.Operacion of
                    rImp.Operacion::Insert:
                        InsertReg(rImp, RecRef);
                    rImp.Operacion::Update:
                        RecRef.Find;
                    rImp.Operacion::Delete:
                        DeleteReg(rImp, RecRef);
                end;

                if rImp.Operacion in [rImp.Operacion::Insert, rImp.Operacion::Update] then begin
                    // campos reales
                    Clear(rField);
                    rField.SetCurrentKey("Id Rel", Orden, Id); // Por orden
                    rField.SetRange("Id Rel", rImp.Id);
                    rField.SetRange("Id Cab.", rImp."Id Cab.");
                    rField.SetRange(PK, false); // Los campos de la clave primaria ya se han introducido
                    rField.SetFilter("Id Field", '>0');
                    if rField.FindSet then begin
                        repeat
                            FieRef := RecRef.Field(rField."Id Field");
                            SetFieldValue(FieRef, rField.Value, true);
                        until rField.Next = 0;

                        //001+ //Pasar Clave MdM a No. Producto Comun+
                        if rImp."Id Tabla" = 27 then begin
                            wClaveMdM := '';
                            FieRef := RecRef.Field(2); //Clave MdM
                            wClaveMdM := FieRef.Value;
                            FieRef := RecRef.Field(99008500); //No. Producto Comun
                            FieRef.Value := wClaveMdM;
                        end;
                        //001-

                        if rImp."Id Tabla" = 27 then begin
                            RecRef.SetTable(Item);
                            Item.SetModificadoMdM(true);
                        end;
                        RecRef.Modify(true);

                    end;

                    // campos virtuales
                    if rImp."Id Tabla" = 27 then begin

                        RecRef.SetTable(Item);

                        Item.SetModificadoMdM(true);
                        lwMod := false;

                        rField.SetFilter("Id Field", '<0');
                        if rField.FindSet then begin
                            if rImp.Operacion <> rImp.Operacion::Insert then begin
                                Dim1 := Item."Global Dimension 1 Code";
                                Dim2 := Item."Global Dimension 2 Code";
                            end;

                            repeat
                                lwFieldValue := rField.GetValue;
                                lwCodDim := '';
                                lwPack := ''; // Inicializamos este valor

                                case rField."Id Field" of
                                    // Unidad de medida
                                    -101:
                                        SetUnid(Item."No.", Item."Base Unit of Measure", 0, StrtoDec(lwFieldValue)); // Ancho
                                    -102:
                                        SetUnid(Item."No.", Item."Base Unit of Measure", 1, StrtoDec(lwFieldValue)); // Alto
                                    -103:
                                        SetUnid(Item."No.", Item."Base Unit of Measure", 2, StrtoDec(lwFieldValue)); // Peso

                                    // Packs
                                    -110:
                                        begin
                                            lwPack := lwFieldValue;
                                            SetProdBOMValue(Item."No.", lwPack, false, 0);
                                        end;
                                    // Unidades Packs
                                    -111:
                                        SetProdBOMValue(Item."No.", lwPack, true, StrtoDec(lwFieldValue));

                                    // Dimensiones Generales
                                    // Codigo de Dimension
                                    -120:
                                        lwCodDim := lwFieldValue;
                                    // Valor de Dimension
                                    -121:
                                        if lwCodDim <> '' then begin
                                            cFuncMdm.ValidaDimValC(Item, lwCodDim, lwFieldValue);
                                            lwMod := true;
                                        end;

                                    // Dimensiones MdM
                                    -299 .. -200:
                                        begin
                                            lwId2 := Abs(rField."Id Field" + 200);
                                            cFuncMdm.ValidaDimValT(Item, lwId2, lwFieldValue);
                                            lwMod := true;
                                        end;

                                    // Precio venta (Sin impuesto)
                                    -324 .. -300:
                                        if prCab.Entrada = prCab.Entrada::INT_Excel then begin
                                            SetPrecioVta(Item."No.", Item."Base Unit of Measure", Today, StrtoDec(lwFieldValue), false);
                                        end;
                                    // LOS PRECIOS NO DEBEN DE INFORMARSE NUNCA DESDE EL MDM (Si por Excel)
                                    // -349..-325 Precio venta (Con impuesto)
                                    // -399..-350 Lo reservasmos para precios de compra si algún día hace falta
                                    // -501 Lo reservamos para código de divisa
                                    // -901 Lo reservamos para guardar la Codigo de Articulo Pack Anterior en modificaciones
                                    // cód. barras
                                    // 25/10/2018 Se solicita que la descripción del código de barras sea la del producto
                                    -499 .. -400:
                                        SetRefCruz(Item."No.", Item."Base Unit of Measure", lwFieldValue, Item.Description);

                                    // observaciones
                                    -500:
                                        SetCommentLine(Item."No.", lwFieldValue);

                                    // Autores
                                    -601:
                                        if GestAutor(Item, lwFieldValue) then
                                            lwMod := true;

                                end;
                            until rField.Next = 0;

                            // en el update, si alguna dimensión actualizada es global, hay que actualizar el producto
                            if (rImp.Operacion = rImp.Operacion::Update) and
                               (Dim1 <> Item."Global Dimension 1 Code") or (Dim2 <> Item."Global Dimension 2 Code") then
                                lwMod := true;
                        end;
                        Item."Gestionado MdM" := true;
                        Clear(rField);
                        if rImp.Operacion in [rImp.Operacion::Insert, rImp.Operacion::Update] then begin
                            //IF cFuncMdm.ConfiguraTipologiaMdM(Item) THEN
                            if ConfiguraTipologiaMdM(Item, rImp) then
                                lwMod := true;
                        end;
                        // Solo en el insert de la importación por Web Service
                        if (prCab.Operacion in [prCab.Operacion::Insert]) and (prCab.Entrada = prCab.Entrada::INT_WS) then begin
                            // MdM Hay una configuración a partir de estructura analítica
                            if cGestMdM.SetEstrAnalitica(Item) then
                                lwMod := true;

                            // Hay una modificación por campos relacionados
                            if cGestMdM.SetCamposRelacionados(Item) then
                                lwMod := true;
                        end;

                        // Hay una modificación por campos relacionados
                        /*
                        CLEAR(rTmpField);
                        IF cGestMdM.SetCamposRelacionados2(Item,rTmpField) THEN
                          lwMod := TRUE;
                        */

                        if lwMod then begin
                            Item.Modify;
                            RecRef.GetTable(Item);
                        end;
                    end;

                    if rImp."Id Tabla" = 90 then begin // BOM Component
                        RecRef.SetTable(lrLinBom); // Añadimos la descripcion
                        if (lrLinBom.Description = '') or (lrLinBom."Unit of Measure Code" = '') then begin
                            if Item.Get(lrLinBom."Parent Item No.") then begin
                                if lrLinBom.Description = '' then
                                    lrLinBom.Description := Item.Description;
                                if lrLinBom."Unit of Measure Code" = '' then
                                    lrLinBom."Unit of Measure Code" := Item."Base Unit of Measure";
                                lrLinBom.Modify(true);
                            end;
                        end;
                    end;

                    // Ahora igual falta por rellenar algún campo por defecto
                    lwMod := false;
                    Clear(rField);
                    for lwN := 1 to 4 do begin
                        case lwN of
                            1:
                                begin
                                    lwId2 := rImp.GetIdTipoField;
                                    lwFieldValue := rImp.GetTipoText;
                                end;
                            2:
                                begin
                                    lwId2 := rImp.GetIdCodeField;
                                    lwFieldValue := rImp.Code;
                                end;
                            3:
                                begin
                                    lwId2 := rImp.GetIdDescField;
                                    lwFieldValue := rImp.Descripcion;
                                end;
                            4:
                                begin
                                    lwId2 := GetBlockedFieldNo(rImp."Id Tabla");
                                    lwFieldValue := rImp.GetBloqueadoTx;
                                end; // No Visible
                        end;
                        if (lwId2 <> 0) and (lwFieldValue <> '') then begin
                            if not IsFieldPrimKey(RecRef, lwId2) then begin // Si no es clave primaria (se supone que ya se ha rellenado)
                                FieRef := RecRef.Field(lwId2);
                                if (not rField.Get(rImp.Id, lwId2)) or (Format(FieRef.Value) <> lwFieldValue) then begin
                                    SetFieldValue(FieRef, lwFieldValue, (lwN <> 4)); // No validamos el campo bloqueado
                                    lwMod := true;
                                end;
                            end;
                        end;
                    end;


                    if lwMod then
                        RecRef.Modify;
                end;

                RecRef.Close;
                rImp.Procesado := true;
                rImp.Modify;
                if prCab.Entrada = prCab.Entrada::INT_Excel then
                    Commit;
            until rImp.Next = 0;

            if lwVerDia then
                wDia.Close;
        end;

    end;


    procedure ConvierteTabl(var prImp: Record "Imp.MdM Tabla"; pwError: Boolean)
    var
        lwForce: Boolean;
        lwOK: Boolean;
        lwTipo: Integer;
        lwId: Integer;
        lwExists: Boolean;
    begin
        // ConvierteTabl

        if (prImp.Code <> '') or (prImp."Code MdM" = '') then
            exit;

        lwExists := false;
        case prImp."Id Tabla" of
            // Producto
            27:
                begin
                    pwError := pwError and (rCab.Operacion <> rCab.Operacion::Insert);
                    prImp.Code := GetProdNav(prImp."Code MdM", pwError);
                    if prImp.Code <> '' then
                        prImp.Modify;
                end;

            90:
                begin // Production BOM Line : BEGIN // Production BOM Header
                    prImp.Code := GetProdNav(prImp."Code MdM", pwError);
                    if prImp.Code <> '' then
                        prImp.Modify;
                end;

            349:
                begin
                    lwId := Abs(prImp.Tipo + 200);
                    lwTipo := rConvNM.GetTipoDim(lwId);
                    case lwId of
                        // Dim Series
                        0:
                            begin
                                lwForce := prImp.Operacion = prImp.Operacion::Insert;
                                if lwForce then
                                    prImp.Code := 'Z' + prImp."Code MdM";
                                if rConvNM.GetMdm2NAV(lwTipo, prImp."Code MdM", prImp.Code, lwForce, (not lwForce) and pwError) then
                                    prImp.Modify;
                            end;
                        // Dim Cuenta
                        2:
                            begin // Si no existe le incorporamos una Z
                                lwForce := prImp.Operacion = prImp.Operacion::Insert;
                                if lwForce then begin
                                    lwExists := cFuncMdm.ExistDimValT(lwId, prImp."Code MdM");
                                    if lwExists then
                                        prImp.Code := 'Z' + prImp."Code MdM"
                                    else begin
                                        prImp.Code := prImp."Code MdM";
                                        prImp.Modify;
                                    end;
                                end;
                                if not lwExists then
                                    if rConvNM.GetMdm2NAV(lwTipo, prImp."Code MdM", prImp.Code, lwForce, (not lwForce) and pwError) then
                                        prImp.Modify;
                            end;
                        // Otros
                        else begin
                            if rConvNM.GetMdm2NAV(lwTipo, prImp."Code MdM", prImp.Code, false, pwError) then
                                prImp.Modify;
                        end;
                    end;
                end;

            75008:
                begin // Autores Producto
                    prImp.Code := GetProdNav(prImp."Code MdM", true);
                    if prImp.Code <> '' then
                        prImp.Modify;
                end;


            else begin
                lwTipo := rConvNM.GetTipoTable(prImp);
                if lwTipo > -1 then
                    if rConvNM.GetMdm2NAV(lwTipo, prImp."Code MdM", prImp.Code, false, pwError) then
                        prImp.Modify;
            end;
        end;
    end;


    procedure ConvierteField(var prImp: Record "Imp.MdM Tabla"; var prField: Record "Imp.MdM Campos"; pwError: Boolean)
    var
        lrProd: Record Item;
        lwOK: Boolean;
        lwTipo: Integer;
        lwId: Integer;
        lwCode: Code[20];
        lwErr2: Boolean;
    begin
        // ConvierteField

        if (prField.Value <> '') or (prField."MdM Value" = '') then
            exit;

        lwErr2 := pwError;
        case prImp."Id Tabla" of
            //27 : lwErr2 := lwErr2 AND (prImp.Operacion <> prImp.Operacion::Insert);
            27:
                case prField."Id Field" of // Producto
                    1:
                        begin // Clave primaria
                            prField.Value := prImp.Code;
                            prField.Modify;
                        end;
                end;
            90:
                begin // Production BOM Line
                    case prField."Id Field" of
                        1, 4:
                            begin
                                prField.Value := GetProdNav(prField."MdM Value", true);
                                prField.Modify;
                            end;

                    end;
                end;
        end;

        if (prField.Value <> '') or (prField."MdM Value" = '') then
            exit;

        case prImp."Id Tabla" of
            // Espacio destinado a casos especiales
            // ************
            else begin
                lwTipo := rConvNM.GetTipoField(prImp, prField);
                if lwTipo > -1 then begin
                    if rConvNM.GetMdm2NAV(lwTipo, prField."MdM Value", lwCode, false, lwErr2) then begin
                        prField.Value := lwCode;
                        prField.Modify;
                    end;
                end;
            end;
        end;
    end;

    local procedure SetRefCruz(pwItemNo: Code[20]; pwCodUnidadBase: Code[10]; pwEan: Code[20]; pwDescrip: Text)
    var
        lrRef: Record "Item Reference";
    begin
        // SetRefCruz
        // Crea y actualiza una referencia cruzada si no existe
        // Para codigos de barra

        Clear(lrRef);
        lrRef.SetRange("Item No.", pwItemNo);
        lrRef.SetRange("Reference Type", lrRef."Reference Type"::"Bar Code");
        // lrRef.SETRANGE("Unit of Measure", pwCodUnidadBase);
        lrRef.SetFilter("Unit of Measure", '%1|%2', pwCodUnidadBase, '');
        lrRef.SetRange("Reference No.", pwEan);
        if lrRef.FindFirst then
            exit;

        lrRef.SetRange("Reference No.");
        lrRef.DeleteAll;

        if pwEan <> '' then begin
            lrRef.SetRange("Reference Type");
            lrRef.SetRange("Reference No.", pwEan);
            lrRef.DeleteAll;

            Clear(lrRef);
            lrRef."Item No." := pwItemNo;
            lrRef."Unit of Measure" := pwCodUnidadBase;
            lrRef."Reference Type" := lrRef."Reference Type"::"Bar Code";
            lrRef."Reference No." := pwEan;
            lrRef.Description := CopyStr(pwDescrip, 1, MaxStrLen(lrRef.Description));
            lrRef.Insert(true);
        end;
    end;

    local procedure SetUnid(pwItemNo: Code[20]; pwCodUnidadBase: Code[10]; pwTipo: Option Ancho,Alto,Peso; pwValor: Decimal)
    var
        lrUnid: Record "Item Unit of Measure";
    begin
        // SetUnid
        // Determina elementos de la unidad de medida

        if pwItemNo = '' then
            exit;

        Clear(lrUnid);
        if not lrUnid.Get(pwItemNo, pwCodUnidadBase) then begin
            lrUnid."Item No." := pwItemNo;
            lrUnid.Code := pwCodUnidadBase;
            lrUnid."Qty. per Unit of Measure" := 1;
            lrUnid.Insert(true);
        end;

        case pwTipo of
            pwTipo::Ancho:
                lrUnid.Width := pwValor;
            pwTipo::Alto:
                lrUnid.Height := pwValor;
            pwTipo::Peso:
                lrUnid.Weight := pwValor;
            else
                exit;
        end;

        lrUnid.SetModificadoMdM(true);
        lrUnid.Modify(true);
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

    local procedure SetPrecioVta(pwItemNo: Code[20]; pwCodUnidadBase: Code[10]; pwFecha: Date; pwPrecio: Decimal; pwImpInc: Boolean)
    var
        //lrPrec: Record "Sales Price";
        lrPrec: Record "Price List Line";
        lwExits: Boolean;
        lwIgual: Boolean;
        lwFecha2: Date;
    begin
        // SetPrecioVta

        if pwFecha = 0D then
            pwFecha := Today;

        lwIgual := false;

        Clear(lrPrec);
        lrPrec.SetRange("Asset Type", lrPrec."Asset Type"::Item);
        lrPrec.SetRange("Product No.", pwItemNo);
        lrPrec.SetRange("Source Type", lrPrec."Source Type"::"All Customers");
        lrPrec.SetFilter("Assign-to No.", '');
        lrPrec.SetFilter("Currency Code", '%1', '');
        lrPrec.SetRange("Unit of Measure Code", pwCodUnidadBase);
        lrPrec.SetFilter("Starting Date", '<=%1', pwFecha);
        lrPrec.SetFilter("Ending Date", '>%1|%2', pwFecha, 0D);
        lrPrec.SetRange("Price Includes VAT", pwImpInc);
        lwExits := lrPrec.FindLast;
        if lwExits then begin
            lwIgual := lrPrec."Unit Price" = pwPrecio;
        end;

        if not lwIgual then begin
            if lwExits then begin // Cerramos el precio anterior
                lwFecha2 := CalcDate('<-1D>', pwFecha);
                if (lwFecha2 <> lrPrec."Ending Date") and (lrPrec."Source Type" <> lrPrec."Source Type"::Campaign) then begin
                    lrPrec.Validate("Ending Date", lwFecha2);
                    lrPrec.SetModificadoMdM(true);
                    lrPrec.Modify(true);
                end;
            end;

            Clear(lrPrec);
            lrPrec."Asset Type" := lrPrec."Asset Type"::Item;
            lrPrec.Validate("Product No.", pwItemNo);
            lrPrec."Source Type" := lrPrec."Source Type"::"All Customers"; // ***
            lrPrec.Validate("Assign-to No.", '');
            lrPrec.Validate("Unit of Measure Code", pwCodUnidadBase);
            lrPrec.Validate("Starting Date", pwFecha);
            lrPrec.Validate("Unit Price", pwPrecio);
            lrPrec."Currency Code" := '';
            lrPrec."Price Includes VAT" := pwImpInc;
            lrPrec.Insert(true)
        end;
    end;

    local procedure StrtoDec(pwTexto: Text[1024]) Dec: Decimal
    begin
        // StrtoDec

        if pwTexto = '' then
            pwTexto := '0';
        Dec := 0;
        Evaluate(Dec, pwTexto);
    end;


    procedure SetProdBOMValue(pwCodItem: Code[20]; pwCod: Code[20]; pwSetVal: Boolean; pwUnidades: Decimal)
    var
        lrLinBOM: Record "BOM Component";
        lwLinNo: Integer;
    begin
        // SetProdBOMValue
        if pwCod = '' then
            exit;


        Clear(lrLinBOM);
        lrLinBOM.SetRange("Parent Item No.", pwCod);
        lrLinBOM.SetRange(Type, lrLinBOM.Type::Item);
        lrLinBOM.SetRange("No.", pwCodItem);
        if lrLinBOM.FindFirst then begin
            if pwSetVal then begin
                if lrLinBOM."Quantity per" <> pwUnidades then begin
                    lrLinBOM.Validate("Quantity per", pwUnidades);
                    lrLinBOM.Modify;
                end;
            end;
        end
        else begin
            // Buscamos el útlimo Nº de línea
            Clear(lwLinNo);
            Clear(lrLinBOM);
            lrLinBOM.SetRange("Parent Item No.", pwCod);
            if lrLinBOM.FindLast then
                lwLinNo := lrLinBOM."Line No.";
            lwLinNo := lwLinNo + 10000;

            Clear(lrLinBOM);
            lrLinBOM.Validate("Parent Item No.", pwCod);
            lrLinBOM.Validate("Line No.", lwLinNo);
            lrLinBOM.Validate(Type, lrLinBOM.Type::Item);
            lrLinBOM.Validate("No.", pwCodItem);
            if pwSetVal then
                lrLinBOM.Validate("Quantity per", pwUnidades);
            lrLinBOM.Insert(true);
        end;
    end;


    procedure DeleteReg(prImp: Record "Imp.MdM Tabla"; var pwRecRef: RecordRef)
    var
        lwFieldN: Integer;
        lwFieRef: FieldRef;
        lwVal: Boolean;
    begin
        // DeleteReg
        // Borra el registro o lo marca como bloqueado, según la tabla

        if (prImp."Id Tabla" = 0) or (prImp.Operacion <> prImp.Operacion::Delete) then
            exit;
        // lwField es el id del campo bloqueado de la tabla
        // Si no se le asigna (no tiene) el registro se borrará, sino se marcará bloqueado
        lwFieldN := 0;
        //IF pwRecRef.FIND THEN BEGIN
        // Provocamos un error si no se encuentra
        pwRecRef.Find;
        begin
            lwFieldN := GetBlockedFieldNo(prImp."Id Tabla");

            if lwFieldN = 0 then
                pwRecRef.Delete(true)
            else begin
                lwFieRef := pwRecRef.Field(lwFieldN);
                lwVal := lwFieRef.Value;
                if not lwVal then begin // Marca como bloqueado
                    lwFieRef.Validate(true);
                    pwRecRef.Modify(true);
                end;
            end;
        end;
    end;


    procedure InsertReg(prImp: Record "Imp.MdM Tabla"; var pwRecRef: RecordRef)
    var
        lwFieldN: Integer;
        lwFieRef: FieldRef;
        lwField2: FieldRef;
        lwVal: Boolean;
        lwUpdated: Boolean;
        lwMngd: Boolean;
        lrPK: KeyRef;
        lwN: Integer;
        lwNo: Code[20];
        lwSerie: Code[10];
    begin
        // InsertReg
        // Inserta el registro o lo marca como NO bloqueado, según la tabla

        if (prImp."Id Tabla" = 0) or (prImp.Operacion = prImp.Operacion::Delete) then
            exit;

        // lwField es el id del campo bloqueado de la tabla
        lwFieldN := 0;
        lwMngd := true;
        if pwRecRef.Find then begin
            lwUpdated := MdmManaged(prImp, pwRecRef, lwMngd);
            if rCab.Entrada <> rCab.Entrada::INT_Excel then
                lwFieldN := GetBlockedFieldNo(prImp."Id Tabla");

            if lwFieldN <> 0 then begin
                lwFieRef := pwRecRef.Field(lwFieldN);
                lwVal := lwFieRef.Value;
                if lwVal then begin // desbloquea
                    lwFieRef.Validate(false);
                    if not lwUpdated then
                        lwUpdated := true;
                end;
            end;

            if lwUpdated then
                pwRecRef.Modify(true);

        end
        else begin
            if rCab.Entrada = rCab.Entrada::INT_WS then begin
                if prImp."Id Tabla" = 27 then begin
                    lwFieRef := pwRecRef.Field(1); // No. de lo dejamos en blanco
                    lwFieRef.Value := '';

                    // Buscamos en la configuración de tipologia
                    lwSerie := GestSerieTip(prImp);
                    // Si no está configurada, buscamos la serie por defecto
                    if lwSerie = '' then
                        lwSerie := rConfMdM."Serie Producto";

                    if lwSerie <> '' then begin
                        lwNo := '';
                        //NoSeriesMgt.InitSeries(lwSerie, lwSerie, 0D, lwNo, lwSerie);
                        lwNo := NoSeriesMgt.GetNextNo(lwSerie);
                        lwFieRef.Value := lwNo;
                        // le ponemos la serie
                        lwFieRef := pwRecRef.Field(97); // Serie

                        lwFieRef.Value := lwSerie;
                    end;
                    // En algunos paises la serie viene dada por la Conf. Tipologias

                end;
            end;
            MdmManaged(prImp, pwRecRef, lwMngd);
            pwRecRef.Insert(true);

            // Esto es despues de la insercción
            if EsProducto then begin
                // Le ponemos la unidad de medida base
                rConfMdM.TestField("Base Unit of Measure");
                lwFieRef := pwRecRef.Field(8); // Unidad de Medida Base
                lwFieRef.Validate(rConfMdM."Base Unit of Measure");
                if rCab.Entrada <> rCab.Entrada::INT_Excel then begin
                    lwFieRef := pwRecRef.Field(54); // Bloqueado
                    lwFieRef.Value := false; // Por defecto se bloquea, lo desbloqueamos
                end;

                //001+
                //Pasar Clave MdM a No. Producto Comun+
                wClaveMdM := '';
                lwFieRef := pwRecRef.Field(2); //Clave MdM
                wClaveMdM := lwFieRef.Value;
                lwFieRef := pwRecRef.Field(99008500); //No. Producto Comun
                lwFieRef.Value := wClaveMdM;
                //001-

                pwRecRef.Modify;
            end;

            // Si se crea la clave primaria, la rellenamos en la tabla de campos
            lrPK := pwRecRef.KeyIndex(1);
            Clear(rField);
            for lwN := 1 to lrPK.FieldCount do begin
                lwField2 := lrPK.FieldIndex(lwN);
                if rField.Get(rImp.Id, lwField2.Number) then begin
                    if (rField.Value = '') then begin
                        rField.Value := Format(lwField2.Value);
                        rField.Modify;
                    end;
                end;
                if rImp.Code = '' then begin
                    if rImp.GetIdCodeField = lwField2.Number then begin
                        rImp.Code := Format(lwField2.Value);
                        rImp.Modify;
                    end;
                end;
            end;
        end;
    end;


    procedure MdmManaged(prImp: Record "Imp.MdM Tabla"; var pwRecRef: RecordRef; pwMngd: Boolean) Updated: Boolean
    var
        lwFieldN: Integer;
        lwFieRef: FieldRef;
        lwVal: Boolean;
    begin
        // MdmManaged
        // marcamos el registro para que se gestione desde el MdM

        Updated := false; // si se actualiza el valor, devolveremos TRUE

        if rCab.Entrada <> rCab.Entrada::INT_WS then
            exit;
        lwFieldN := GetFieldMdMMngd(prImp."Id Tabla");
        if lwFieldN <> 0 then begin
            lwFieRef := pwRecRef.Field(lwFieldN);
            lwVal := lwFieRef.Value;
            if lwVal <> pwMngd then begin
                lwFieRef.Value := pwMngd;
                Updated := true;
            end;
        end;
    end;


    procedure GetBlockedFieldNo(pwTableId: Integer) wField: Integer
    begin
        // GetBlockedFieldNo

        wField := 0;
        case pwTableId of
            75001:
                wField := 5;      // Datos MdM
            56003:
                wField := 50;     // Sello/Marca
            349:
                wField := 6;      // Dimension Value
            56007:
                wField := 50;     // Edicion
            75002:
                wField := 50;     // Estructura Analitica
            56008:
                wField := 50;     // Estado productos
            27:
                wField := 54;     // Item
            9:
                wField := 75000;  // Country/Region
            8:
                wField := 75000;  // Language
            75010:
                wField := 50;     // Sociedad Comercializadora
            75009:
                wField := 50;     // Tipo Autoria
            5722:
                wField := 75000;  // Item Category
        end;
    end;


    procedure GetFieldMdMMngd(pwTableId: Integer) wField: Integer
    begin

        wField := 0;
        case pwTableId of
            27:
                wField := 75000; // producto y LM
            5722:
                wField := 75001; // Categoria de producto
        end;
    end;


    procedure SetCommentLine(pwCodPro: Code[20]; pwComment: Text)
    var
        lrComntLine: Record "Comment Line";
        lwNxtLine: Integer;
        lwComment2: Text;
        lwMax: Integer;
        lwEnc: Boolean;
    begin
        // SetCommentLine

        Clear(lrComntLine);

        lwComment2 := DelChr(pwComment, '<>');
        if lwComment2 = '' then
            exit;

        lwMax := MaxStrLen(lrComntLine.Comment);
        if StrLen(lwComment2) > lwMax then begin
            lwComment2 := CopyStr(lwComment2, 1, lwMax);
            lwComment2 := DelChr(lwComment2, '<>'); // Borramos espacios en blanco
        end;

        lrComntLine.SetRange("Table Name", lrComntLine."Table Name"::Item);
        lrComntLine.SetRange("No.", pwCodPro);
        lrComntLine.SetRange(Comment, lwComment2);
        lwEnc := lrComntLine.FindFirst; // Comprobamos que no exista yá el comentario

        if not lwEnc then begin
            // Buscamos el último no de línea
            Clear(lrComntLine);
            lrComntLine.SetRange("Table Name", lrComntLine."Table Name"::Item);
            lrComntLine.SetRange("No.", pwCodPro);
            if lrComntLine.FindLast then
                lwNxtLine := lrComntLine."Line No." + 10000
            else
                lwNxtLine := 10000;

            lrComntLine.Reset;
            lrComntLine.Init;
            lrComntLine."Table Name" := lrComntLine."Table Name"::Item;
            lrComntLine."No." := pwCodPro;
            lrComntLine."Line No." := lwNxtLine;
            lrComntLine.Date := Today;
            lrComntLine.Comment := lwComment2;
            lrComntLine.Insert;
        end;
    end;


    procedure FillPrimKey(pwRecRef: RecordRef)
    var
        lrPK: KeyRef;
        lwN: Integer;
        lwField2: FieldRef;
        lwCod: Code[20];
        lwNo: Code[20];
        lwOK: Boolean;
        lwFind: Boolean;
        lwRename: Boolean;
    begin
        // FillPrimKey
        // Rellena los valores de la clave primaria

        Clear(lwRename);
        if rImp.Operacion = rImp.Operacion::Update then begin
            rImp.CalcFields(rImp.Rename);
            lwRename := rImp.Rename;
        end;

        lrPK := pwRecRef.KeyIndex(1);

        Clear(rField);

        for lwN := 1 to lrPK.FieldCount do begin
            lwField2 := lrPK.FieldIndex(lwN);
            if rField.Get(rImp.Id, lwField2.Number) then begin // Los campos de la clave primaria deben de existir
                SetFieldValue(lwField2, rField.Value, false); // Por defecto No validamos la clave primaria
                rField.PK := true; // Indicamos que forma parte de la clave primaria
                rField.Modify;
            end
            else begin
                case lwField2.Number of
                    rImp.GetIdTipoField:
                        SetFieldValue(lwField2, rImp.GetTipoText, false); // Por defecto No validamos la clave primaria
                    rImp.GetIdCodeField:
                        SetFieldValue(lwField2, rImp.Code, false);
                    rImp.GetIdDescField:
                        SetFieldValue(lwField2, rImp.Descripcion, false);
                end;
            end;
        end;

        // Aqui tenemos un problema por tener distinta clave primaria
        if rImp."Id Tabla" = 90 then begin // BOM Component
            lwField2 := pwRecRef.Field(1); // Parent Item No.
            lwCod := rImp.Code;
            lwField2.SetRange(lwCod);
            lwField2 := pwRecRef.Field(4); //No.
            lwOK := false;
            lwFind := false;
            if rImp.Operacion = rImp.Operacion::Update then
                lwFind := rField.Get(rImp.Id, -901);  // Valor Anterior
            if not lwFind then
                lwFind := rField.Get(rImp.Id, 4);  //No.

            if lwFind then begin
                lwNo := rField.Value;
                lwField2.SetRange(lwNo);
                lwOK := pwRecRef.FindFirst;
            end;

            if not lwOK then begin
                lwField2 := pwRecRef.Field(2); //Line No.
                if rImp.Operacion = rImp.Operacion::Insert then
                    lwField2.Value := BuscaSigumOrden(lwCod)
                else
                    lwField2.Value := 0;
            end;
        end;

        if lwRename then
            RenameRec(pwRecRef);
    end;


    procedure FindPrimKey(pwRecRef: RecordRef; var pwPKVal: array[10] of Variant) wNoFlds: Integer
    var
        lrPK: KeyRef;
        lwN: Integer;
        lwField2: FieldRef;
    begin
        // FindPrimKey
        // Devuelve la clave primaria del registro en un array(10) pwPKVal Por Dios que debería de bastar.
        // Devuelve el número de campos encontrados

        wNoFlds := 0;
        Clear(pwPKVal);

        lrPK := pwRecRef.KeyIndex(1);

        Clear(rField);
        for lwN := 1 to lrPK.FieldCount do begin
            lwField2 := lrPK.FieldIndex(lwN);
            if rField.Get(rImp.Id, lwField2.Number) then begin // Los campos de la clave primaria deben de existir
                pwPKVal[lwN] := lwField2.Value;
                wNoFlds += 1;
            end;
        end;
    end;


    procedure FindPrimKeyIdField(pwRecRef: RecordRef; var pwPKIdFields: array[10] of Integer) wNoFlds: Integer
    var
        lrPK: KeyRef;
        lwN: Integer;
        lwField2: FieldRef;
    begin
        // FindPrimKeyIdField
        // Devuelve la clave primaria del registro en un array(10) pwPKIdFields (Por Dios que debería de bastar). El array es de integer, id de campos
        // Devuelve el número de campos encontrados


        Clear(pwPKIdFields);
        lrPK := pwRecRef.KeyIndex(1);
        wNoFlds := lrPK.FieldCount;
        for lwN := 1 to wNoFlds do begin
            lwField2 := lrPK.FieldIndex(lwN);
            pwPKIdFields[lwN] := lwField2.Number;
        end;
    end;


    procedure IsFieldPrimKey(pwRecRef: RecordRef; pwFieldNo: Integer) wIsPK: Boolean
    var
        lrPK: KeyRef;
        lwN: Integer;
        lwField2: FieldRef;
    begin
        // IsFieldPrimKey
        // Devuelve True si el campo indicado está en la clave primaria
        // Devuelve el número de campos encontrados


        wIsPK := false;
        lrPK := pwRecRef.KeyIndex(1);
        for lwN := 1 to lrPK.FieldCount do begin
            lwField2 := lrPK.FieldIndex(lwN);
            if pwFieldNo = lwField2.Number then
                exit(true);
        end;
    end;


    procedure RenameRec(pwRecRef: RecordRef)
    var
        lwPKIdFields: array[10] of Integer;
        lwNoFields: Integer;
        lwFieldVals: array[10] of Variant;
        lwField2: FieldRef;
        lwN: Integer;
    begin
        // RenameRec
        // Renombra la tabla

        Clear(lwFieldVals);
        lwNoFields := FindPrimKeyIdField(pwRecRef, lwPKIdFields);

        for lwN := 1 to lwNoFields do begin
            lwField2 := pwRecRef.Field(lwPKIdFields[lwNoFields]);
            if rField.Get(rImp.Id, lwPKIdFields[lwNoFields]) and (rField."Renamed Val" <> '') then
                GetFieldValue(lwField2, rField."Renamed Val", lwFieldVals[lwN])
            else
                lwFieldVals[lwN] := lwField2.Value;
        end;

        // Creo que con 5 debe de bastar
        case lwNoFields of
            1:
                pwRecRef.Rename(lwFieldVals[1]);
            2:
                pwRecRef.Rename(lwFieldVals[1], lwFieldVals[2]);
            3:
                pwRecRef.Rename(lwFieldVals[1], lwFieldVals[2], lwFieldVals[3]);
            4:
                pwRecRef.Rename(lwFieldVals[1], lwFieldVals[2], lwFieldVals[3], lwFieldVals[4]);
            5:
                pwRecRef.Rename(lwFieldVals[1], lwFieldVals[2], lwFieldVals[3], lwFieldVals[4], lwFieldVals[5]);
        end;
    end;


    procedure GetFieldValue(var pwFieRef: FieldRef; pwValue: Text; var pwVariant: Variant)
    var
        ValDecimal: Decimal;
        ValInteger: Integer;
        ValDate: Date;
        ValDateTime: DateTime;
        ValBoolean: Boolean;
        lwIsNULL: Boolean;
        lwOK: Boolean;
        lwValue2: Text;
    begin
        // GetFieldValue
        // Devuelve un valor a un campo
        // pwVariant Es el valor de retorno

        pwValue := DelChr(pwValue, '<>');
        lwIsNULL := EsNulo(pwValue);

        Clear(pwVariant);
        case UpperCase(Format(pwFieRef.Type)) of
            'OPTION':
                begin
                    if lwIsNULL then
                        ValInteger := 0
                    else begin
                        if not Evaluate(ValInteger, pwValue) then begin
                            ValInteger := GeOptionValueId(pwFieRef.OptionCaption, pwValue);
                            if ValInteger = -1 then
                                //ValInteger := GeOptionValueId(pwFieRef.OptionString, pwValue);
                                ValInteger := GeOptionValueId(pwFieRef.OptionMembers, pwValue);
                            if ValInteger = -1 then
                                Error(Text002, pwValue, pwFieRef.Caption, pwFieRef.OptionCaption);
                        end;
                    end;
                    pwVariant := ValInteger;
                end;
            'INTEGER', 'BIGINTEGER':
                begin
                    if lwIsNULL then
                        ValInteger := 0
                    else
                        Evaluate(ValInteger, pwValue);
                    pwVariant := ValInteger;
                end;
            'DECIMAL':
                begin
                    if lwIsNULL then
                        ValDecimal := 0
                    else
                        Evaluate(ValDecimal, pwValue);
                    pwVariant := ValDecimal;
                end;
            'DATE':
                begin
                    if lwIsNULL then
                        ValDate := 0D
                    else begin
                        lwOK := Evaluate(ValDate, pwValue, 9); // 9 Es el formato XML
                        if not lwOK then begin
                            lwValue2 := StrSubstNo('%1/%2/%3', CopyStr(pwValue, 9, 2), CopyStr(pwValue, 6, 2), CopyStr(pwValue, 1, 4));
                            lwOK := Evaluate(ValDate, lwValue2);
                        end;
                        if not lwOK then begin
                            lwValue2 := StrSubstNo('%1/%2/%3', CopyStr(pwValue, 6, 2), CopyStr(pwValue, 9, 2), CopyStr(pwValue, 1, 4));
                            lwOK := Evaluate(ValDate, lwValue2);
                        end;
                        if not lwOK then
                            Evaluate(ValDate, pwValue); // Genera Error
                    end;
                    pwVariant := ValDate;
                end;
            'DATETIME':
                begin
                    if lwIsNULL then
                        ValDateTime := 0DT
                    else
                        Evaluate(ValDateTime, pwValue);
                    pwVariant := ValDateTime;
                end;
            'BOOLEAN':
                begin
                    if lwIsNULL then
                        ValBoolean := false
                    else
                        Evaluate(ValBoolean, pwValue);
                    pwVariant := ValBoolean;
                end;
            'TEXT', 'BIGTEXT', 'CODE':
                begin
                    if lwIsNULL then
                        pwValue := '';
                    // Si la cadena es demasiado larga, la trunca
                    if pwFieRef.Length < StrLen(pwValue) then
                        pwValue := CopyStr(pwValue, 1, pwFieRef.Length);
                    pwVariant := pwValue;
                end
            else
                Error(Text001, Format(pwFieRef.Type), pwFieRef.Caption);
        end;
    end;


    procedure SetFieldValue(var pwFieRef: FieldRef; pwValue: Text; pwValida: Boolean)
    var
        lwValue: Variant;
    begin
        // SetFieldValue
        // Asigna o Valida un valor a un campo

        GetFieldValue(pwFieRef, pwValue, lwValue);

        if pwValida then
            pwFieRef.Validate(lwValue)
        else
            pwFieRef.Value := lwValue;
    end;


    procedure GeOptionValueId(pwOptionValue: Text; pwValue: Text) wId: Integer
    var
        lwOptValues: Text;
        lwPs: Integer;
        lwActVal: Text;
        lwId: Integer;
        lwTotal: Integer;
    begin
        // GeOptionValueId
        // Devolvemos el valor del Id del option (valores separados por comas)
        // Si no lo encuetra devuelve -1;

        wId := -1;

        pwOptionValue := UpperCase(DelChr(pwOptionValue, '<>'));
        lwOptValues := pwOptionValue;
        pwValue := UpperCase(DelChr(pwValue, '<>')); // Le quitamos los valors vacios al principio y fin

        /* Decidimos hacerlo de otro modo
        lwId := 0;
        REPEAT
          lwPs := STRPOS(lwOptValues,',');
          IF lwPs > 0 THEN BEGIN
            lwActVal    := COPYSTR(lwOptValues,1, lwPs-1);
            lwOptValues := COPYSTR(lwOptValues, lwPs+1);
          END
          ELSE
            lwActVal := lwOptValues;
          lwActVal := DELCHR(lwActVal, '<>'); // Le quitamos los valors vacios al principio y fin
          IF lwActVal = pwValue THEN
            wId := lwId;
          lwId +=1;
        UNTIL (lwPs=0) OR (wId > -1);
        */

        // Contamos cuantas posiciones tiene (comas +1)
        lwTotal := 0;
        repeat
            lwPs := StrPos(lwOptValues, ',');
            if lwPs > 0 then
                lwOptValues := CopyStr(lwOptValues, lwPs + 1);
            lwTotal += 1;
        until (lwPs = 0);

        for lwId := 1 to lwTotal do begin
            if pwValue = SelectStr(lwId, pwOptionValue) then
                exit(lwId - 1); // Los option empiezan por 0
        end;

    end;


    procedure GetTableCaption(pwId: Integer) wText: Text
    var
        /*   lrObjects: Record "Object"; */
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

        Clear(lrObjects2);
        lrObjects2.SetRange("Object Type", lrObjects2."Object Type"::Table);
        lrObjects2.SetRange("Object ID", pwId);
        if lrObjects2.FindFirst then begin
            //lrObjects2.CALCFIELDS("Object Caption");
            wText := lrObjects2."Object Caption";
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
                                    lwIdDim := pwFieldId + 200;
                                    wText := cFuncMdm.GetDimCode(lwIdDim, false);
                                end;
                            -349 .. -300:
                                wText := LTEXT0005;
                            -499 .. -400:
                                wText := LTEXT0006;
                            -500:
                                wText := LTEXT0007;
                            -501:
                                wText := LTEXT0012;
                        end;
                    end;
            end;
        end;
    end;


    procedure EsNulo(pwValue: Text) wIsNull: Boolean
    begin
        // EsNulo
        // Determina si es un valor Nulo

        pwValue := DelChr(pwValue, '<>');
        wIsNull := UpperCase(pwValue) = 'NULL';
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

        /* lwFileName := cFileMng.ServerTempFileName('xml');

        lwFile.Create(lwFileName);
        lwFile.CreateOutStream(lwOutStr);
        XMLPORT.Export(XMLPORT::"MDM-Migracion Inicial Art.", lwOutStr, prProd);
        lwFile.Close;


        //lwFileName2 := cFileMng.SaveFileDialog(lText001,'','XML|*.XML');
        cFileMng.DownloadHandler(lwFileName, lText001, '', 'XML|*.XML', lwFileName2); */
    end;


    procedure GetProdNav(pwCodMdm: Code[20]; pwError: Boolean) wCodNav: Code[20]
    var
        lwOK: Boolean;
        lrProd: Record Item;
    begin
        // GetProdNav

        wCodNav := '';

        Clear(lrProd);
        lrProd.SetRange("No. 2", pwCodMdm);
        if pwError then begin
            lrProd.FindFirst;
            lwOK := true;
        end
        else
            lwOK := lrProd.FindFirst;
        if lwOK then
            wCodNav := lrProd."No.";
    end;


    procedure GestAutor(var prProd: Record Item; pwValue: Code[20]) Result: Boolean
    var
        lwAutorCatalogo: Boolean;
        lrField2: Record "Imp.MdM Campos";
    begin
        // GestAutor

        lwAutorCatalogo := false;

        Clear(lrField2);
        // Mira si es un autor de catálogo
        if lrField2.Get(rImp.Id, -600) then
            Evaluate(lwAutorCatalogo, lrField2.GetValue);

        // Si no miramos si es un cambio del valor actual
        if not lwAutorCatalogo then begin
            if lrField2.Get(rImp.Id, -602) then // Valor Anterior
                lwAutorCatalogo := (prProd.Autor = lrField2.GetValue);
        end;

        lwAutorCatalogo := lwAutorCatalogo and (prProd.Autor <> pwValue);

        Result := lwAutorCatalogo;
        if lwAutorCatalogo then begin
            prProd.Validate(Autor, pwValue);
        end;
    end;


    procedure BuscaSigumOrden(pwCodBom: Code[20]) wNum: Integer
    var
        lrBomItem: Record "BOM Component";
    begin
        // BuscaSigumOrden

        wNum := 0;
        Clear(wNum);
        Clear(lrBomItem);
        lrBomItem.SetRange(lrBomItem."Parent Item No.", pwCodBom);
        if lrBomItem.FindLast then
            wNum := lrBomItem."Line No.";

        wNum += 1
    end;


    procedure EsProducto() Res: Boolean
    begin
        // EsProducto
        // Devuelve true si estamos tratando la tabla producto

        Res := rImp."Id Tabla" = 27;
    end;


    procedure GestSerieTip(var prImp: Record "Imp.MdM Tabla") wSerie: Code[10]
    var
        lrConfTip: Record "Conf. Tipologias MdM";
    begin
        // GestSerieTip
        // Buscamos la serie en la configuración tipologia

        wSerie := '';

        if FindTipoConf(prImp, lrConfTip) then
            wSerie := lrConfTip."No. Series";
    end;


    procedure FindFieldValue(pwId1: Integer; pwId2: Integer; pwIdField: Integer) wValue: Text
    var
        lrField2: Record "Imp.MdM Campos";
    begin
        // FindFieldValue

        wValue := '';
        Clear(lrField2);
        if pwId2 = 0 then
            lrField2.SetRange("Id Rel", pwId1)
        else
            lrField2.SetRange("Id Rel", pwId1, pwId2);
        lrField2.SetRange("Id Field", pwIdField);
        if lrField2.FindFirst then
            exit(lrField2.Value)
    end;


    procedure FindTipoConf(var prImp: Record "Imp.MdM Tabla"; var prConfTip: Record "Conf. Tipologias MdM") Result: Boolean
    var
        lrprImp2: Record "Imp.MdM Tabla";
        lwId1: Integer;
        lwId2: Integer;
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lwFieldNo: Integer;
        lwTip: Code[20];
        lwNo: Integer;
        lwValor: Code[20];
    begin
        // FindTipoConf
        // Buscamos la serie Configuración Tipologia

        Result := false;

        if prImp.Tipo <> 1 then // Si no es general
            exit;

        // Buscamos el Id del especifico
        lwId1 := prImp.Id;

        lwId2 := 0;
        Clear(lrprImp2);
        lrprImp2.SetRange("Id Cab.", prImp."Id Cab.");
        lrprImp2.SetRange("Id Tabla", prImp."Id Tabla");
        lrprImp2.SetRange("Code MdM", prImp."Code MdM");
        lrprImp2.SetRange(Tipo, 2);
        if lrprImp2.FindFirst then
            lwId2 := lrprImp2.Id;

        Clear(prConfTip);

        lwTip := FindFieldValue(lwId1, lwId2, 5702); // Busca la tipologia en la importación
        if lwTip = '' then
            exit;

        prConfTip.SetRange(Tipologia, lwTip);
        for lwNo := 1 to lrFiltroTipo.MaxId do begin
            if lrFiltroTipo.Get(lwNo) then begin
                case lrFiltroTipo.Tipo of
                    lrFiltroTipo.Tipo::Dimension:
                        lwFieldNo := -(200 + lrFiltroTipo."Valor Id");
                    lrFiltroTipo.Tipo::"Dato MdM":
                        lwFieldNo := cFuncMdm.GetDatoMdMFieldNo(lrFiltroTipo."Valor Id");
                    lrFiltroTipo.Tipo::Otros:
                        lwFieldNo := cFuncMdm.GetOtrosFieldNo(lrFiltroTipo."Valor Id");
                end;

                lwValor := FindFieldValue(lwId1, lwId2, lwFieldNo);
                prConfTip.SetFilterRef(lwNo, lwValor);
            end;
        end;

        Result := prConfTip.FindFirst;
    end;


    procedure ConfiguraTipologiaMdM(var prProd: Record Item; var prImp: Record "Imp.MdM Tabla") Result: Boolean
    var
        lrConfTip: Record "Conf. Tipologias MdM";
        lrConv: Record "Conversion NAV MdM";
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lwNo: Integer;
        lwValores: array[20] of Code[20];
    begin
        // ConfiguraTipologiaMdM

        Result := FindTipoConf(prImp, lrConfTip);

        if Result then
            cFuncMdm.SetConfTipologiaData(prProd, lrConfTip);
    end;


    procedure FillTempFields(PrImp: Record "Imp.MdM Tabla")
    begin
        // FillTempFields;

        Clear(rTmpField);
        rTmpField.DeleteAll;

        Clear(rField);
        rField.SetRange("Id Rel", PrImp.Id);
        rField.SetRange("Id Cab.", PrImp."Id Cab.");
        if rField.FindSet then begin
            repeat
                rTmpField := rField;
                rTmpField.Insert;
            until rField.Next = 0;
        end;
    end;
}

