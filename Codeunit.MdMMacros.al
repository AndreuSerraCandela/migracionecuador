codeunit 75009 "MdM Macros"
{

    trigger OnRun()
    begin
        RellenaFechasMdM;
        Message('Proceso Finalizado');
    end;

    var
        GLSetup: Record "General Ledger Setup";
        rConfMdM: Record "Configuracion MDM";
        wCont: Integer;
        wTotal: Integer;
        wStep: Integer;
        wCasos: Integer;
        wDia: Dialog;
        cFuncMdM: Codeunit "Funciones MdM";


    procedure GestDimGral()
    var
        lrProd: Record Item;
        lwValue: Code[20];
        lwOK: Boolean;
        lwCod: Code[20];
        LTEXT001: Label 'Se han procesado %1 casos';
    begin
        // GestDimGral
        // Regenera las dimensiones globales en producto

        if not Confirm('¿Desea regenear las dimensiones globales en producto?') then
            exit;

        GLSetup.Get;

        // Restaura las dimensiones generales en los productos
        if lrProd.FindSet then begin
            InitDia(lrProd.Count);
            wDia.Open('Generando Dim Globales @1@@@@@@@@@@@@@@@@@@@@@@@');
            repeat
                lwOK := false;
                lwValue := GetDefDimesions(27, lrProd."No.", GLSetup."Global Dimension 1 Code");
                if lwValue <> lrProd."Global Dimension 1 Code" then begin
                    lrProd."Global Dimension 1 Code" := lwValue;
                    lwOK := true;
                end;

                lwValue := GetDefDimesions(27, lrProd."No.", GLSetup."Global Dimension 2 Code");
                if lwValue <> lrProd."Global Dimension 2 Code" then begin
                    lrProd."Global Dimension 2 Code" := lwValue;
                    lwOK := true;
                end;
                if lwOK then begin
                    lrProd.Modify(true);
                    wCasos += 1;
                end;
                UpdateDia(1);
            until lrProd.Next = 0;
            wDia.Close;
        end;

        Message(LTEXT001, wCasos);
    end;


    procedure GetDefDimesions(pwIdTabla: Integer; pwNo: Code[20]; pwDimcode: Code[20]) Result: Code[20]
    var
        lrDefDim: Record "Default Dimension";
    begin
        // GetDefDimesions
        // Añadimos dimensiones por defecto

        if (pwIdTabla = 0) or (pwNo = '') or (pwDimcode = '') then
            exit;

        Clear(lrDefDim);
        if lrDefDim.Get(pwIdTabla, pwNo, pwDimcode) then
            Result := lrDefDim."Dimension Value Code"
    end;


    procedure InitDia(pwTotal: Integer)
    begin
        // InitDia

        wCasos := 0;
        wCont := 0;
        wTotal := pwTotal;
        SetStep;
    end;


    procedure UpdateDia(pwId: Integer)
    begin
        // UpdateDia

        wCont += 1;
        if wCont mod wStep = 0 then
            wDia.Update(pwId, Round(wCont / wTotal * 1000, 1));
    end;


    procedure SetStep()
    begin
        // SetStep

        wStep := wTotal div 100;
        if wStep = 0 then
            wStep := 1;
    end;


    procedure SetTipoDimensiones()
    var
        lwId: Integer;
        lwCode: Code[20];
    begin
        // SetTipoDimensiones

        for lwId := 0 to 6 do begin
            lwCode := cFuncMdM.GetDimCode(lwId, false);
            cFuncMdM.SetTipoDim(lwCode, lwId);
        end;
    end;


    procedure BorraDescrpEAN()
    var
        lrRefC: Record "Item Reference";
    begin
        // BorraDescrpEAN
        // Borra la descripción de todas las referencias cruzadas

        if not Confirm('¿Desea borrar la descripción de todos los códigos de barra?') then
            exit;

        Clear(lrRefC);
        lrRefC.SetRange("Reference Type", lrRefC."Reference Type"::"Bar Code");
        lrRefC.ModifyAll(Description, '');
    end;


    procedure RellenaUnidadEnPrecios()
    var
        lrPreV: Record "Price List Line";
        lrPreV2: Record "Price List Line";
        lrPreV3: Record "Price List Line";
        lrProd: Record Item;
    begin
        // RellenaUnidadEnPrecios
        // Rellena los precios que tienen la unidad en blanco con la de los productos
        // Se diseño inicialmente para puerto rico

        // Customer,Customer Price Group,All Customers,Campaign
        // Todos clientes,Grupo precio cliente,Sin Filtrar


        if not Confirm('¿Desea realmente iniciar el proceso de llenado de unidad de medida en las líneas de precio de venta producto?') then
            exit;

        rConfMdM.Get;

        Clear(lrPreV);
        case rConfMdM."Tipo Precio Venta" of
            rConfMdM."Tipo Precio Venta"::"Todos clientes":
                begin
                    lrPreV.SetRange("Source Type", lrPreV."Source Type"::"All Customers");
                end;
            rConfMdM."Tipo Precio Venta"::"Grupo precio cliente":
                begin
                    lrPreV.SetRange("Source Type", lrPreV."Source Type"::"Customer Price Group");
                    if rConfMdM."Grupo Precio Cliente" <> '' then
                        lrPreV.SetRange("Assign-to No.", rConfMdM."Grupo Precio Cliente");
                end;
        end;
        lrPreV.SetFilter("Unit of Measure Code", '%1', '');

        wCasos := 0;
        if lrPreV.FindSet(true) then begin
            InitDia(lrPreV.Count);
            wDia.Open('Rellenando Unidad en Precios Venta @1@@@@@@@@@@@@@@@@@@@@@@@');
            repeat
                if lrProd.Get(lrPreV."Product No.") and (lrProd."Base Unit of Measure" <> '') then begin
                    lrPreV2 := lrPreV;
                    lrPreV2."Unit of Measure Code" := lrProd."Base Unit of Measure";
                    if not lrPreV2.Find then begin
                        lrPreV3 := lrPreV;
                        lrPreV3.Delete;
                        lrPreV2.Insert;
                        wCasos += 1;
                    end;
                end;
                UpdateDia(1);
            until lrPreV.Next = 0;
            wDia.Close;
        end;

        Message('Se han modificado %1 casos', wCasos);
    end;


    procedure RellenaFechasMdM()
    var
        lrProd: Record Item;
    begin
        // RellenaFechasMdM
        // #209115

        if not Confirm('Iniciar procesod de rellando de fechas MdM en Producto') then
            exit;

        Clear(lrProd);
        lrProd.SetRange("Gestionado MdM", true);
        InitDia(lrProd.Count);
        wDia.Open('Rellenando Fechas MdM @1@@@@@@@@@@@@@@@@@');
        //lrProd.SETRANGE("Assembly BOM",TRUE);
        if lrProd.FindSet then begin
            repeat
                UpdateDia(1);
                if cFuncMdM.GestContrlFechasProd(lrProd, 0, 2) then
                    wCasos += 1
            until (lrProd.Next = 0) or (wCont > 20);
        end;

        wDia.Close;
        Message('Se han modificado %1 casos', wCasos);
    end;
}

