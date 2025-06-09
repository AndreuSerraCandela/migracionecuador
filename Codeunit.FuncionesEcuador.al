codeunit 55001 "Funciones Ecuador"
{
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // FES   : Fausto Serrata
    // ------------------------------------------------------------------------------
    // No.       Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // MOI - 09/12/2014 (#7419): Se añade la funcion que actualiza el estado del registro Transfer Header en el caso de que los campos
    //                           External Document No. y No. Serie Comprobante Fiscal esten informados.
    // MOI - 14/04/2015 (#14637): La funcion ActualizaStatus cambia de nombre a ActualizaDespachado.
    //                             La funcion ActualizaDespachado marca a True el campo solo si se cumple que External Document No. y
    //                             No. Serie Comprobante Fiscal esten informados.
    // 
    // JMB - 24/11/2016 (#59668)  Se corrige la funcion para caluclar RUC PUBLICOS
    // 
    // 001     FES             30-11-2020      SANTINAV-1844. Comentar validacion para permitir crear pedidos de venta con cedulas inician con 0 y
    //                                         no validar el tercer digito.
    // 001-1   FES             02-12-2020      SANTINAV-1844. Reversar a codigo original.
    // 001-2   FES             03-12-2020      SANTINAV-1844. Comentar validacion para permitir crear pedidos de venta con cedulas inician con 0 y
    //                                         no validar el tercer digito.
    // 
    // 002 10/12/2020  YFC : SANTINAV-1580  Limpiar campos de clasificacion devoluciones, para que se llenen con la nueva modificacion
    // 003 17-Feb-2021 FES : SANTINAV-2149  Mejoras importación pedidos call center
    // 
    // #450919, RRT, 11.03.2022: El tipo <RUC PERSONA NATURAL> no debe validarse con la función ValidaDigVefCedula()
    // 
    // 004    JPG             08-07-2022       comentar validacion, Esta validación no se utilizar mas. no hay un algoritmo que se valido deacuerdo al gobierno
    // 
    // 005    LDP             17-01-2024       SANTINAV-5132: Facturas no cargadas en BC - SEE - punto de venta LA Y

    Permissions = TableData "Sales Invoice Line" = m,
                  TableData "Sales Cr.Memo Header" = m;

    trigger OnRun()
    begin
        //  ClasificacionDevoluciones(); //002
        //ActualizaSerieNcfAbonos(); //005+-
    end;

    var
        Error001: Label 'Incorrect Structure for R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA %1';
        Error002: Label 'Incorrect Structure for R.U.C. PUBLICOS %1';
        Error003: Label 'Incorrect Structure for RUC PERSONA NATURAL %1';
        Error004: Label 'ID No. Incorrect %1';
        Error005: Label 'RUC No. Incorrect %1';
        Error006: Label 'Estructura de Cédula incorrecta %1';
        I: Integer;
        ConfSant: Record "Config. Empresa";
        CliContATS: Record "Clientes al Contado ATS";


    procedure ValidaDigitosRUC(Codigo_Loc: Code[40]; Tipo: Integer; pTPV: Boolean): Text[250]
    var
        Prov: Integer;
        Mensaje: Text;
        ErrorTipo: Label 'Debe seleccionar un tipo de RUC/Cédula';
    begin
        //MESSAGE('%1', Tipo);
        case Tipo of
            //R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA
            1:
                begin
                    Evaluate(Prov, CopyStr(Codigo_Loc, 1, 2));
                    case true of
                        StrLen(Codigo_Loc) <> 13,
                      (CopyStr(Codigo_Loc, 3, 1) <> '9'),
                      (Prov < 0) or (Prov > 24),
                      CopyStr(Codigo_Loc, 11, 3) = '000':
                            Mensaje := Error001;
                    // (NOT ValidaDigVerfRUC(Codigo_Loc)) : Mensaje := Error005;     //004 Esta validación no se utilizar mas.++
                    end;
                end;

            //R.U.C. PUBLICOS
            2:
                begin
                    Evaluate(Prov, CopyStr(Codigo_Loc, 1, 2));
                    case true of
                        StrLen(Codigo_Loc) <> 13,
                      CopyStr(Codigo_Loc, 3, 1) <> '6',
                      (Prov < 0) or (Prov > 24),
                      CopyStr(Codigo_Loc, 11, 3) = '000':
                            Mensaje := Error002; // #59668 Ponemos (11,3)
                        (not ValidaDigVerfRUC(Codigo_Loc)):
                            Mensaje := Error005;
                    end;
                end;

            //RUC PERSONA NATURAL
            3:
                begin
                    Evaluate(Prov, CopyStr(Codigo_Loc, 1, 2));
                    case true of
                        StrLen(Codigo_Loc) <> 13,
                      (Prov < 0) or (Prov > 24),
                      //COPYSTR(Codigo_Loc,3,1) < '6'  : Mensaje := Error003;
                      CopyStr(Codigo_Loc, 3, 1) in ['7', '8']:
                            Mensaje := Error003;

                    //+#450919
                    //... Esta validación no es correcta.
                    //(NOT ValidaDigVerfCedula(COPYSTR(Codigo_Loc,1,10))) : Mensaje := Error005;
                    //-#450919

                    end;
                end;


            //Cedula
            4:
                begin
                    Evaluate(Prov, CopyStr(Codigo_Loc, 1, 2));
                    case true of
                        StrLen(Codigo_Loc) <> 10,
                      (Prov < 0) or (Prov > 24),
                      //COPYSTR(Codigo_Loc,3,1) > '5'         : Mensaje := Error006;  //001+-    //001-1+-    //001-2+-
                      (not ValidaDigVerfCedula(Codigo_Loc)):
                            Mensaje := Error004;

                    end;
                end;

            else
                Error(ErrorTipo);

        end;

        if Mensaje <> '' then
            if not pTPV then
                Error(Mensaje, Codigo_Loc) //003+- Adicionar No. Documento para mostrar en el mensaje
            else
                exit(Mensaje);
    end;


    procedure FechaXML(Fecha_: Date): Text[10]
    var
        dia_: Text[2];
        mes_: Text[2];
        anio_: Text[4];
    begin
        exit(Format(Fecha_, 0, '<Day,2>/<Month,2>/<Year4>'));
    end;


    procedure ValidaDigitosRUCCajaChica(Codigo_Loc: Code[40])
    var
        Prov: Integer;
    begin
        if StrLen(Codigo_Loc) <> 13 then
            Error(Error001);

        Evaluate(Prov, CopyStr(Codigo_Loc, 1, 2));
        if (Prov < 0) or (Prov > 24) then
            Error(Error001);

        if CopyStr(Codigo_Loc, 11, 3) = '000' then
            Error(Error001);
    end;


    procedure ValidaCedula(Codigo_Loc: Code[40])
    var
        Prov: Integer;
    begin
        if StrLen(Codigo_Loc) <> 13 then
            Error(Error003);

        Evaluate(Prov, CopyStr(Codigo_Loc, 1, 2));
        if (Prov < 0) or (Prov > 24) then
            Error(Error003);

        if CopyStr(Codigo_Loc, 3, 1) > '5' then
            Error(Error003);
    end;


    procedure ValidaDigVerfCedula(Cedula: Text[10]): Boolean
    var
        Pos: array[9] of Integer;
        I: Integer;
        Pares: Integer;
        Impares: Integer;
        Impar1: Integer;
        Impar2: Integer;
        Impar3: Integer;
        Impar4: Integer;
        impar5: Integer;
        SubTotal: Integer;
        DecenaSup: Integer;
        SegundoDigito: Text[1];
        wSegDigito: Integer;
        aSumar: Integer;
        digitoVerificador: Integer;
        Primerdigito: Text[30];
    begin
        //Capturo el valor de las posiciones
        I := 0;
        Clear(Pos);
        repeat
            I += 1;
            Evaluate(Pos[I], CopyStr(Cedula, I, 1));
        until I = 9;

        //Se suman las posiciones pares
        Pares := Pos[2] + Pos[4] + Pos[6] + Pos[8];

        //Se suman las posiciones impares
        Impar1 := Pos[1] * 2;
        if Impar1 > 9 then
            Impar1 := Impar1 - 9;

        Impar2 := Pos[3] * 2;
        if Impar2 > 9 then
            Impar2 := Impar2 - 9;

        Impar3 := Pos[5] * 2;
        if Impar3 > 9 then
            Impar3 := Impar3 - 9;

        Impar4 := Pos[7] * 2;
        if Impar4 > 9 then
            Impar4 := Impar4 - 9;

        impar5 := Pos[9] * 2;
        if impar5 > 9 then
            impar5 := impar5 - 9;

        Impares := Impar1 + Impar2 + Impar3 + Impar4 + impar5;

        SubTotal := Pares + Impares;

        Primerdigito := CopyStr(Format(SubTotal), 1, 1);
        SegundoDigito := CopyStr(Format(SubTotal), 2, 1);

        //Control adicional
        if (SegundoDigito = '') and (Primerdigito = '9') then
            SegundoDigito := '9';

        if (SegundoDigito = '') and (Primerdigito = '8') then
            SegundoDigito := '8';

        if (SegundoDigito = '') and (Primerdigito = '7') then
            SegundoDigito := '7';

        if (SegundoDigito = '') and (Primerdigito = '6') then
            SegundoDigito := '6';

        if (SegundoDigito = '') and (Primerdigito = '5') then
            SegundoDigito := '5';

        if (SegundoDigito = '') and (Primerdigito = '4') then
            SegundoDigito := '4';

        if (SegundoDigito = '') and (Primerdigito = '3') then
            SegundoDigito := '3';

        if (SegundoDigito = '') and (Primerdigito = '2') then
            SegundoDigito := '2';

        if (SegundoDigito = '') and (Primerdigito = '1') then
            SegundoDigito := '1';
        //Control adicional


        Evaluate(wSegDigito, SegundoDigito);
        aSumar := 10 - wSegDigito;

        DecenaSup := SubTotal + aSumar;
        digitoVerificador := DecenaSup - SubTotal;
        if digitoVerificador = 10 then
            digitoVerificador := 0;
        if Format(digitoVerificador) <> CopyStr(Cedula, 10, 1) then
            exit(false)
        else
            exit(true);
    end;


    procedure ValidaDigVerfRUC(Ruc_Loc: Code[13]): Boolean
    var
        Residuo: Decimal;
        Pos: array[9] of Integer;
        I: Integer;
        Pares: Integer;
        Impares: Integer;
        Impar1: Integer;
        Impar2: Integer;
        Impar3: Integer;
        Impar4: Integer;
        impar5: Integer;
        SubTotal: Integer;
        DecenaSup: Integer;
        SegundoDigito: Text[1];
        wSegDigito: Integer;
        aSumar: Integer;
        digitoVerificador: Integer;
        Par1: Integer;
        Par2: Integer;
        Par3: Integer;
        Par4: Integer;
        ResultMOD: Decimal;
    begin
        //Capturo el valor de las posiciones
        I := 0;
        Clear(Pos);
        repeat
            I += 1;
            Evaluate(Pos[I], CopyStr(Ruc_Loc, I, 1));
        until I = 9;

        //Tercer Digito = 9
        if CopyStr(Ruc_Loc, 3, 1) = '9' then begin
            //Coeficiente 4.3.2.7.6.5.4.3.2
            Pos[1] := Pos[1] * 4;
            Pos[2] := Pos[2] * 3;
            Pos[3] := Pos[3] * 2;
            Pos[4] := Pos[4] * 7;
            Pos[5] := Pos[5] * 6;
            Pos[6] := Pos[6] * 5;
            Pos[7] := Pos[7] * 4;
            Pos[8] := Pos[8] * 3;
            Pos[9] := Pos[9] * 2;

            SubTotal := Pos[1] + Pos[2] + Pos[3] + Pos[4] + Pos[5] + Pos[6] + Pos[7] + Pos[8] + Pos[9];
            ResultMOD := SubTotal mod 11;
            if ResultMOD <> 0 then
                digitoVerificador := 11 - ResultMOD
            else
                digitoVerificador := 0;
        end;

        //Tercer Digito = 6
        if CopyStr(Ruc_Loc, 3, 1) = '6' then begin
            //Coeficiente 3.2.7.6.5.4.3.2
            Pos[1] := Pos[1] * 3;
            Pos[2] := Pos[2] * 2;
            Pos[3] := Pos[3] * 7;
            Pos[4] := Pos[4] * 6;
            Pos[5] := Pos[5] * 5;
            Pos[6] := Pos[6] * 4;
            Pos[7] := Pos[7] * 3;
            Pos[8] := Pos[8] * 2;

            SubTotal := Pos[1] + Pos[2] + Pos[3] + Pos[4] + Pos[5] + Pos[6] + Pos[7] + Pos[8];
            ResultMOD := SubTotal mod 11;
            if ResultMOD <> 0 then
                digitoVerificador := 11 - ResultMOD
            else
                digitoVerificador := 0;
        end;

        if CopyStr(Ruc_Loc, 3, 1) = '9' then begin
            if Format(digitoVerificador) <> CopyStr(Ruc_Loc, 10, 1) then
                exit(false)
            else
                exit(true);
        end;

        if CopyStr(Ruc_Loc, 3, 1) = '6' then begin
            if Format(digitoVerificador) <> CopyStr(Ruc_Loc, 9, 1) then
                exit(false)
            else
                exit(true);
        end;
    end;


    procedure ATS_DetalleVentas(FechaDesde: Date; FechaHasta: Date)
    var
        Cliente: Record Customer;
        DocsCliATS: Record "Documentos por Cliente ATS";
        tpIdCliente: Code[10];
        SIH: Record "Sales Invoice Header";
        SCMH: Record "Sales Cr.Memo Header";
        VE: Record "VAT Entry";
        baseNoGraIva: Decimal;
        baseImponible: Decimal;
        BaseImpGrav: Decimal;
        MontoIva: Decimal;
        CLE: Record "Cust. Ledger Entry";
        valorRetRenta: Decimal;
        valorRetIva: Decimal;
        Existe: Boolean;
        Cust: Record Customer;
        TieneVenta: Boolean;
    begin
        ConfSant.Get;
        ConfSant.TestField("Grupo Reg. Iva Prod. Exento");
        if Cliente.FindSet then
            repeat
                I := 0;
                baseNoGraIva := 0;
                baseImponible := 0;
                BaseImpGrav := 0;
                valorRetRenta := 0;
                valorRetIva := 0; //Santillana no hace retencion IVA
                Existe := false;


                //** FACTURAS

                if Cliente."Tipo Documento" = Cliente."Tipo Documento"::RUC then
                    tpIdCliente := '04';
                if Cliente."Tipo Documento" = Cliente."Tipo Documento"::Cedula then
                    tpIdCliente := '05';
                if Cliente."Tipo Documento" = Cliente."Tipo Documento"::Pasaporte then
                    tpIdCliente := '06';

                if Cliente."VAT Registration No." = '0905068615' then begin
                    I := I;
                    I := I;
                    I := I;
                    I := I;
                end;

                Clear(DocsCliATS);
                if DocsCliATS.Get(tpIdCliente, Cliente."VAT Registration No.", '01') then
                    Existe := true
                else
                    Existe := false;

                DocsCliATS."Tipo ID Cliente" := tpIdCliente;
                DocsCliATS."ID Cliente" := Cliente."VAT Registration No.";
                DocsCliATS.TipoComprobante := '01';

                if not Existe then begin
                    SIH.Reset;
                    SIH.SetCurrentKey("Posting Date", "VAT Registration No.");
                    SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
                    SIH.SetRange("VAT Registration No.", Cliente."VAT Registration No.");
                    if SIH.FindSet then begin
                        TieneVenta := true;
                        repeat
                            //**baseNoGraIva**
                            // Es la base imponible de la compra de bienes o prestación de servicios que no
                            // son objeto del Impuesto al Valor Agregado (IVA), es decir, no se encuentran
                            // gravados de este impuesto por ejemplo la venta de bienes inmuebles: oficinas,
                            // terrenos, locales. Este campo consta de doce caracteres numéricos, nueve
                            // enteros, un punto y dos decimales.
                            I += 1;
                            VE.Reset;
                            VE.SetRange("Posting Date", SIH."Posting Date");
                            VE.SetRange("Document Type", VE."Document Type"::Invoice);
                            VE.SetRange("Document No.", SIH."No.");
                            VE.SetRange(Type, VE.Type::Sale);
                            VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                            if VE.FindSet then begin
                                repeat
                                    if VE.Amount = 0 then
                                        baseNoGraIva += VE.Base;
                                //montoIva_Dec += VE.Amount;
                                until VE.Next = 0;
                            end;
                            //**baseNoGraIva**


                            //**baseImponible
                            // Corresponde a la base imponible de las transacciones de bienes o servicios
                            // gravados con tarifa 0%. Se debe ingresar el total de las ventas tarifa 0%
                            // acumuladas por cliente al mes. Este campo consta de doce caracteres
                            // numéricos, nueve enteros, un punto y dos decimales.
                            VE.Reset;
                            VE.SetRange("Posting Date", SIH."Posting Date");
                            VE.SetRange("Document Type", VE."Document Type"::Invoice);
                            VE.SetRange("Document No.", SIH."No.");
                            VE.SetRange(Type, VE.Type::Sale);
                            VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                            if VE.FindSet then begin
                                repeat
                                    if VE.Amount = 0 then
                                        baseImponible += VE.Base;
                                //montoIva_Dec += VE.Amount;
                                until VE.Next = 0;
                            end;
                            //**baseImponible


                            //**baseImpGrav**
                            // Corresponde a la base imponible de las transacciones de bienes o servicios
                            // gravados con tarifa 10%, 12% ó 14 %, según corresponda. Este valor no
                            // incluye el impuesto al valor agregado.  Se debe ingresar el total de las ventas
                            // gravadas acumuladas por cliente al mes. Este campo consta de doce
                            // caracteres numéricos, compuesto por nueve enteros, un punto y dos decimales.

                            VE.Reset;
                            VE.SetRange("Posting Date", SIH."Posting Date");
                            VE.SetRange("Document Type", VE."Document Type"::Invoice);
                            VE.SetRange("Document No.", SIH."No.");
                            VE.SetRange(Type, VE.Type::Sale);
                            VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                            if VE.FindSet then begin
                                repeat
                                    if VE.Amount <> 0 then
                                        BaseImpGrav += VE.Base;
                                //montoIva_Dec += VE.Amount;
                                until VE.Next = 0;
                            end;
                        until SIH.Next = 0;
                    end
                    else
                        TieneVenta := false;

                    DocsCliATS.NumroComprobantes := I;
                    DocsCliATS.BaseNoGraIva := Abs(baseNoGraIva);
                    DocsCliATS.BaseImponible := Abs(baseImponible);
                    DocsCliATS.BaseImpGrav := Abs(BaseImpGrav);
                    DocsCliATS.MontoIva := Abs(MontoIva);

                    //**valorRetRenta**
                    Cust.Reset;
                    Cust.SetCurrentKey("VAT Registration No.");
                    Cust.SetRange("VAT Registration No.", Cliente."VAT Registration No.");
                    if Cust.FindSet then
                        repeat
                            CLE.Reset;
                            CLE.SetCurrentKey("Customer No.", "Posting Date", "Currency Code");
                            CLE.SetRange("Customer No.", Cust."No.");
                            CLE.SetRange("Posting Date", FechaDesde, FechaHasta);
                            CLE.SetRange("Document Type", CLE."Document Type"::Payment);
                            CLE.SetFilter("ID Retencion Venta", '<>%1', '');
                            if CLE.FindSet then
                                repeat
                                    CLE.CalcFields("Original Amt. (LCY)");
                                    valorRetRenta += Abs(CLE."Original Amt. (LCY)");
                                until CLE.Next = 0;
                        until Cust.Next = 0;


                    DocsCliATS.ValorRetIva := 0;
                    DocsCliATS.ValorRetRenta := valorRetRenta;
                    if TieneVenta then
                        DocsCliATS.Insert;

                end;

                //** NOTAS DE CREDITO
                if Cliente."Tipo Documento" = Cliente."Tipo Documento"::RUC then
                    tpIdCliente := '04';
                if Cliente."Tipo Documento" = Cliente."Tipo Documento"::Cedula then
                    tpIdCliente := '05';
                if Cliente."Tipo Documento" = Cliente."Tipo Documento"::Pasaporte then
                    tpIdCliente := '06';

                Clear(DocsCliATS);
                if DocsCliATS.Get(tpIdCliente, Cliente."VAT Registration No.", '04') then
                    Existe := true
                else
                    Existe := false;

                DocsCliATS."Tipo ID Cliente" := tpIdCliente;
                DocsCliATS."ID Cliente" := Cliente."VAT Registration No.";
                DocsCliATS.TipoComprobante := '04';

                if Existe = false then begin
                    DocsCliATS.Init;
                    I := 0;
                    baseNoGraIva := 0;
                    baseImponible := 0;
                    BaseImpGrav := 0;
                    valorRetRenta := 0;
                    valorRetIva := 0; //Santillana no hace retencion IVA

                    //TipoIDCliente
                    if Cliente."Tipo Documento" = Cliente."Tipo Documento"::RUC then
                        DocsCliATS."Tipo ID Cliente" := '04';
                    if Cliente."Tipo Documento" = Cliente."Tipo Documento"::Cedula then
                        DocsCliATS."Tipo ID Cliente" := '05';
                    if Cliente."Tipo Documento" = Cliente."Tipo Documento"::Pasaporte then
                        DocsCliATS."Tipo ID Cliente" := '06';

                    DocsCliATS."ID Cliente" := Cliente."VAT Registration No.";
                    DocsCliATS.TipoComprobante := '04';

                    SCMH.Reset;
                    SCMH.SetCurrentKey("Posting Date", "VAT Registration No.");
                    SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
                    SCMH.SetRange("VAT Registration No.", Cliente."VAT Registration No.");
                    if SCMH.FindSet then begin
                        TieneVenta := true;
                        repeat
                            //**baseNoGraIva**
                            // Es la base imponible de la compra de bienes o prestación de servicios que no
                            // son objeto del Impuesto al Valor Agregado (IVA), es decir, no se encuentran
                            // gravados de este impuesto por ejemplo la venta de bienes inmuebles: oficinas,
                            // terrenos, locales. Este campo consta de doce caracteres numéricos, nueve
                            // enteros, un punto y dos decimales.
                            I += 1;
                            VE.Reset;
                            VE.SetRange("Posting Date", SCMH."Posting Date");
                            VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                            VE.SetRange("Document No.", SCMH."No.");
                            VE.SetRange(Type, VE.Type::Sale);
                            VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                            if VE.FindSet then begin
                                repeat
                                    if VE.Amount = 0 then
                                        baseNoGraIva += VE.Base;
                                //montoIva_Dec += VE.Amount;
                                until VE.Next = 0;
                            end;
                            //**baseNoGraIva**


                            //**baseImponible
                            // Corresponde a la base imponible de las transacciones de bienes o servicios
                            // gravados con tarifa 0%. Se debe ingresar el total de las ventas tarifa 0%
                            // acumuladas por cliente al mes. Este campo consta de doce caracteres
                            // numéricos, nueve enteros, un punto y dos decimales.
                            VE.Reset;
                            VE.SetRange("Posting Date", SIH."Posting Date");
                            VE.SetRange("Document Type", VE."Document Type"::Invoice);
                            VE.SetRange("Document No.", SIH."No.");
                            VE.SetRange(Type, VE.Type::Sale);
                            VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                            if VE.FindSet then begin
                                repeat
                                    if VE.Amount = 0 then
                                        baseImponible += VE.Base;
                                //montoIva_Dec += VE.Amount;
                                until VE.Next = 0;
                            end;
                            //**baseImponible


                            //**baseImpGrav**
                            // Corresponde a la base imponible de las transacciones de bienes o servicios
                            // gravados con tarifa 10%, 12% ó 14 %, según corresponda. Este valor no
                            // incluye el impuesto al valor agregado.  Se debe ingresar el total de las ventas
                            // gravadas acumuladas por cliente al mes. Este campo consta de doce
                            // caracteres numéricos, compuesto por nueve enteros, un punto y dos decimales.

                            VE.Reset;
                            VE.SetRange("Posting Date", SIH."Posting Date");
                            VE.SetRange("Document Type", VE."Document Type"::Invoice);
                            VE.SetRange("Document No.", SIH."No.");
                            VE.SetRange(Type, VE.Type::Sale);
                            VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                            if VE.FindSet then begin
                                repeat
                                    if VE.Amount <> 0 then
                                        BaseImpGrav += VE.Base;
                                //montoIva_Dec += VE.Amount;
                                until VE.Next = 0;
                            end;
                        until SCMH.Next = 0;
                    end
                    else
                        TieneVenta := false;
                    //**baseImpGrav**

                    DocsCliATS.NumroComprobantes := I;
                    DocsCliATS.BaseNoGraIva := Abs(baseNoGraIva);
                    DocsCliATS.BaseImponible := Abs(baseImponible);
                    DocsCliATS.BaseImpGrav := Abs(BaseImpGrav);
                    DocsCliATS.MontoIva := Abs(MontoIva);
                    if TieneVenta then
                        DocsCliATS.Insert;

                end;
            until Cliente.Next = 0;


        //Clientes al contado
        CliContATS.Reset;
        if CliContATS.FindSet then
            repeat
                I := 0;
                baseNoGraIva := 0;
                baseImponible := 0;
                BaseImpGrav := 0;
                valorRetRenta := 0;
                valorRetIva := 0; //Santillana no hace retencion IVA

                //** FACTURAS
                DocsCliATS.Init;
                if CliContATS."Tipo ID Cliente" = 0 then
                    DocsCliATS."Tipo ID Cliente" := '07';

                if (CliContATS."Tipo ID Cliente" = 1) or (CliContATS."Tipo ID Cliente" = 1) or
                  (CliContATS."Tipo ID Cliente" = 3) then
                    DocsCliATS."Tipo ID Cliente" := '04';

                if CliContATS."Tipo ID Cliente" = 4 then
                    DocsCliATS."Tipo ID Cliente" := '05';


                DocsCliATS."ID Cliente" := Cliente."VAT Registration No.";
                DocsCliATS.TipoComprobante := '01';

                SIH.Reset;
                SIH.SetCurrentKey("Posting Date", "VAT Registration No.");
                SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
                SIH.SetRange("VAT Registration No.", CliContATS."ID Cliente");
                if SIH.FindSet then
                    repeat
                        //**baseNoGraIva**
                        // Es la base imponible de la compra de bienes o prestación de servicios que no
                        // son objeto del Impuesto al Valor Agregado (IVA), es decir, no se encuentran
                        // gravados de este impuesto por ejemplo la venta de bienes inmuebles: oficinas,
                        // terrenos, locales. Este campo consta de doce caracteres numéricos, nueve
                        // enteros, un punto y dos decimales.
                        I += 1;
                        VE.Reset;
                        VE.SetRange("Posting Date", SIH."Posting Date");
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", SIH."No.");
                        VE.SetRange(Type, VE.Type::Sale);
                        VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                        if VE.FindSet then begin
                            repeat
                                if VE.Amount = 0 then
                                    baseNoGraIva += VE.Base;
                            //montoIva_Dec += VE.Amount;
                            until VE.Next = 0;
                        end;
                        //**baseNoGraIva**

                        //**baseImponible
                        // Corresponde a la base imponible de las transacciones de bienes o servicios
                        // gravados con tarifa 0%. Se debe ingresar el total de las ventas tarifa 0%
                        // acumuladas por cliente al mes. Este campo consta de doce caracteres
                        // numéricos, nueve enteros, un punto y dos decimales.
                        VE.Reset;
                        VE.SetRange("Posting Date", SIH."Posting Date");
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", SIH."No.");
                        VE.SetRange(Type, VE.Type::Sale);
                        VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                        if VE.FindSet then begin
                            repeat
                                if VE.Amount = 0 then
                                    baseImponible += VE.Base;
                            //montoIva_Dec += VE.Amount;
                            until VE.Next = 0;
                        end;
                        //**baseImponible


                        //**baseImpGrav**
                        // Corresponde a la base imponible de las transacciones de bienes o servicios
                        // gravados con tarifa 10%, 12% ó 14 %, según corresponda. Este valor no
                        // incluye el impuesto al valor agregado.  Se debe ingresar el total de las ventas
                        // gravadas acumuladas por cliente al mes. Este campo consta de doce
                        // caracteres numéricos, compuesto por nueve enteros, un punto y dos decimales.

                        VE.Reset;
                        VE.SetRange("Posting Date", SIH."Posting Date");
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", SIH."No.");
                        VE.SetRange(Type, VE.Type::Sale);
                        VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                        if VE.FindSet then begin
                            repeat
                                if VE.Amount <> 0 then
                                    BaseImpGrav += VE.Base;
                            //montoIva_Dec += VE.Amount;
                            until VE.Next = 0;
                        end;
                    until SIH.Next = 0;
                //**baseImpGrav**

                DocsCliATS.NumroComprobantes := I;
                DocsCliATS.BaseNoGraIva := Abs(baseNoGraIva);
                DocsCliATS.BaseImponible := Abs(baseImponible);
                DocsCliATS.BaseImpGrav := Abs(BaseImpGrav);
                DocsCliATS.MontoIva := Abs(MontoIva);
                DocsCliATS.ValorRetIva := 0;
                DocsCliATS.ValorRetRenta := 0;
                DocsCliATS.Insert;



                //** NOTAS DE CREDITO
                DocsCliATS.Init;
                I := 0;
                baseNoGraIva := 0;
                baseImponible := 0;
                BaseImpGrav := 0;
                valorRetRenta := 0;
                valorRetIva := 0; //Santillana no hace retencion IVA

                if CliContATS."Tipo ID Cliente" = 0 then
                    DocsCliATS."Tipo ID Cliente" := '07';

                if (CliContATS."Tipo ID Cliente" = 1) or (CliContATS."Tipo ID Cliente" = 1) or
                  (CliContATS."Tipo ID Cliente" = 3) then
                    DocsCliATS."Tipo ID Cliente" := '04';

                if CliContATS."Tipo ID Cliente" = 4 then
                    DocsCliATS."Tipo ID Cliente" := '05';


                DocsCliATS."ID Cliente" := Cliente."VAT Registration No.";
                DocsCliATS.TipoComprobante := '01';


                DocsCliATS."ID Cliente" := Cliente."VAT Registration No.";
                DocsCliATS.TipoComprobante := '04';

                SCMH.Reset;
                SCMH.SetCurrentKey("Posting Date", "VAT Registration No.");
                SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
                SCMH.SetRange("VAT Registration No.", Cliente."VAT Registration No.");
                if SCMH.FindSet then
                    repeat
                        //**baseNoGraIva**
                        // Es la base imponible de la compra de bienes o prestación de servicios que no
                        // son objeto del Impuesto al Valor Agregado (IVA), es decir, no se encuentran
                        // gravados de este impuesto por ejemplo la venta de bienes inmuebles: oficinas,
                        // terrenos, locales. Este campo consta de doce caracteres numéricos, nueve
                        // enteros, un punto y dos decimales.
                        I += 1;
                        VE.Reset;
                        VE.SetRange("Posting Date", SCMH."Posting Date");
                        VE.SetRange("Document Type", VE."Document Type"::"Credit Memo");
                        VE.SetRange("Document No.", SCMH."No.");
                        VE.SetRange(Type, VE.Type::Sale);
                        VE.SetFilter("VAT Prod. Posting Group", ConfSant."Grupo Reg. Iva Prod. Exento");
                        if VE.FindSet then begin
                            repeat
                                if VE.Amount = 0 then
                                    baseNoGraIva += VE.Base;
                            //montoIva_Dec += VE.Amount;
                            until VE.Next = 0;
                        end;
                        //**baseNoGraIva**


                        //**baseImponible
                        // Corresponde a la base imponible de las transacciones de bienes o servicios
                        // gravados con tarifa 0%. Se debe ingresar el total de las ventas tarifa 0%
                        // acumuladas por cliente al mes. Este campo consta de doce caracteres
                        // numéricos, nueve enteros, un punto y dos decimales.
                        VE.Reset;
                        VE.SetRange("Posting Date", SIH."Posting Date");
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", SIH."No.");
                        VE.SetRange(Type, VE.Type::Sale);
                        VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                        if VE.FindSet then begin
                            repeat
                                if VE.Amount = 0 then
                                    baseImponible += VE.Base;
                            //montoIva_Dec += VE.Amount;
                            until VE.Next = 0;
                        end;
                        //**baseImponible


                        //**baseImpGrav**
                        // Corresponde a la base imponible de las transacciones de bienes o servicios
                        // gravados con tarifa 10%, 12% ó 14 %, según corresponda. Este valor no
                        // incluye el impuesto al valor agregado.  Se debe ingresar el total de las ventas
                        // gravadas acumuladas por cliente al mes. Este campo consta de doce
                        // caracteres numéricos, compuesto por nueve enteros, un punto y dos decimales.

                        VE.Reset;
                        VE.SetRange("Posting Date", SIH."Posting Date");
                        VE.SetRange("Document Type", VE."Document Type"::Invoice);
                        VE.SetRange("Document No.", SIH."No.");
                        VE.SetRange(Type, VE.Type::Sale);
                        VE.SetFilter("VAT Prod. Posting Group", '<>%1', ConfSant."Grupo Reg. Iva Prod. Exento");
                        if VE.FindSet then begin
                            repeat
                                if VE.Amount <> 0 then
                                    BaseImpGrav += VE.Base;
                            //montoIva_Dec += VE.Amount;
                            until VE.Next = 0;
                        end;
                    until SCMH.Next = 0;
                //**baseImpGrav**

                DocsCliATS.NumroComprobantes := I;
                DocsCliATS.BaseNoGraIva := Abs(baseNoGraIva);
                DocsCliATS.BaseImponible := Abs(baseImponible);
                DocsCliATS.BaseImpGrav := Abs(BaseImpGrav);
                DocsCliATS.MontoIva := Abs(MontoIva);
                DocsCliATS.Insert;
            until Cliente.Next = 0;
    end;


    procedure ATS_ClientesContado(FechaDesde: Date; FechaHasta: Date)
    var
        SIH: Record "Sales Invoice Header";
        CliContadoATS: Record "Clientes al Contado ATS";
        SCMH: Record "Sales Cr.Memo Header";
        DocsCliATS: Record "Documentos por Cliente ATS";
    begin
        //Facturas
        CliContadoATS.DeleteAll;
        DocsCliATS.DeleteAll;
        SIH.Reset;
        SIH.SetCurrentKey("Posting Date", "VAT Registration No.");
        SIH.SetRange("Posting Date", FechaDesde, FechaHasta);
        SIH.SetRange("Cliente Existente", false);
        if SIH.FindSet then
            repeat
                CliContadoATS.Init;
                CliContadoATS."Tipo ID Cliente" := SIH."Tipo Ruc/Cedula";
                CliContadoATS."ID Cliente" := SIH."VAT Registration No.";
                CliContadoATS.TipoComprobante := '01';
                if not CliContadoATS.Insert then
                    CliContadoATS.Modify;
            until SIH.Next = 0;


        //Notas de Credito
        SCMH.Reset;
        SCMH.SetCurrentKey("Posting Date", "VAT Registration No.");
        SCMH.SetRange("Posting Date", FechaDesde, FechaHasta);
        SCMH.SetRange("Cliente Existente", false);
        if SCMH.FindSet then
            repeat
                CliContadoATS.Init;
                CliContadoATS."Tipo ID Cliente" := SCMH."Tipo Ruc/Cedula";
                CliContadoATS."ID Cliente" := SCMH."VAT Registration No.";
                CliContadoATS.TipoComprobante := '04';
                if not CliContadoATS.Insert then
                    CliContadoATS.Modify;
            until SCMH.Next = 0;
    end;


    procedure ActualizaDespachado(var pTransferHeader: Record "Transfer Header")
    begin
        //MOI - 09/12/2014 (#7419)
        //MOI - 14/04/2015 (#14637): Inicio
        if (pTransferHeader."External Document No." <> '') and (pTransferHeader."No. Serie Comprobante Fiscal" <> '') then
            pTransferHeader.Despachado := true
        else
            pTransferHeader.Despachado := false;
        //MOI - 14/04/2015 (#14637): Fin
    end;


    procedure ClasificacionDevoluciones()
    var
        SLI: Record "Sales Invoice Line";
        Contador: Integer;
    begin
        //  ++ 002-YFC
        SLI.Reset;
        SLI.SetCurrentKey("Cantidad Devuelta", ClasDev);
        SLI.SetFilter("Cantidad Devuelta", '>%1', 0);
        SLI.SetRange(ClasDev, true);
        if SLI.FindSet then
            repeat
                if SLI."Cantidad Devuelta" > SLI.Quantity then begin
                    Contador += 1;
                    SLI."Cantidad Devuelta" := 0;
                    SLI.ClasDev := false;
                    SLI.Modify;
                end;
            until SLI.Next = 0;
        Message(Format(Contador));
        //  -- 002-YFC
    end;

    local procedure ActualizaSerieNcfAbonos()
    var
        CantNcrPorActualizarNcfAbonos: Integer;
        SalesHeader: Record "Sales Header";
        SH: Record "Sales Header";
    begin
        //005+
        CantNcrPorActualizarNcfAbonos := 0;
        /*
        SalesCrMemoHeader.RESET;
        SalesCrMemoHeader.SETRANGE("Venta TPV", TRUE);
        SalesCrMemoHeader.SETRANGE("No. Serie NCF Abonos",'');
        SalesCrMemoHeader.SETFILTER("No. Documento SIC", '<>%1','');
        SalesCrMemoHeader.SETFILTER("Posting Date",'>=%1',010124D);
        SalesCrMemoHeader.SETFILTER("No. Serie NCF Abonos2", '<>%1','');
        CantNcrPorActualizarNcfAbonos := SalesCrMemoHeader.COUNT;
        IF SalesCrMemoHeader.FINDSET THEN
         REPEAT
           SCRMH.RESET;
           SCRMH.SETRANGE("No.",SalesCrMemoHeader."No.");
           IF SCRMH.FINDFIRST THEN BEGIN
            SCRMH."No. Serie NCF Abonos" := SalesCrMemoHeader."No. Serie NCF Abonos2";
            SCRMH.MODIFY
           END;
         UNTIL SalesCrMemoHeader.NEXT = 0;
        //005-
        */

        SalesHeader.Reset;
        SalesHeader.SetRange("Venta TPV", true);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        SalesHeader.SetRange("No. Serie NCF Abonos", '');
        SalesHeader.SetFilter("No. Documento SIC", '<>%1', '');
        SalesHeader.SetFilter("Posting Date", '>=%1', 20240101D);
        //SalesHeader.SETFILTER("No. Serie NCF Abonos2", '<>%1','');
        CantNcrPorActualizarNcfAbonos := SalesHeader.Count;
        if SalesHeader.FindSet then
            repeat
                SH.Reset;
                SH.SetRange("No.", SalesHeader."No.");
                SH.SetRange("Document Type", SalesHeader."Document Type");
                if SH.FindFirst then begin
                    SH."No. Serie NCF Abonos" := SalesHeader."No. Serie NCF Facturas";
                    SH.Modify
                end;
            until SalesHeader.Next = 0;
        Message(Format(CantNcrPorActualizarNcfAbonos));

    end;
}

