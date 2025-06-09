report 76225 "Alcance presupuesto detallado"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Alcancepresupuestodetallado.rdlc';

    dataset
    {
        dataitem(Presupuesto; "Temp Reportes APS")
        {
            CalcFields = "Descripcion nivel", "Descripcion producto";
            DataItemTableView = SORTING(Usuario, "Fecha hora", "Cod. Nivel", "Linea de negocio", Familia, "Sub Familia");
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cod__Nivel_________Descripcion_nivel_; "Cod. Nivel" + ' - ' + "Descripcion nivel")
            {
            }
            column(TraerDescripcionSubFamilia; TraerDescripcionSubFamilia)
            {
            }
            column(TraerDescripcionLinNeg; TraerDescripcionLinNeg)
            {
            }
            column(Presupuesto__Cdad__presupuestada_; "Cdad. presupuestada")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Monto__presupuestado_; "Monto. presupuestado")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Cdad__alcance_; "Cdad. alcance")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Monto_alcance_; "Monto alcance")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Cdad__mnto__; "Cdad. mnto.")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Cdad__conquista_; "Cdad. conquista")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Cdad__perdida_; "Cdad. perdida")
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Cod__producto_; "Cod. producto")
            {
            }
            column(Presupuesto__Descripcion_producto_; "Descripcion producto")
            {
            }
            column(TraerDescripcionFamilia; TraerDescripcionFamilia)
            {
            }
            column(Adoption_StatisticCaption; Adoption_StatisticCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cdad__alcanceCaption; Cdad__alcanceCaptionLbl)
            {
            }
            column(SubfamiliaCaption; SubfamiliaCaptionLbl)
            {
            }
            column(FamiliaCaption; FamiliaCaptionLbl)
            {
            }
            column("Línea_de_negocioCaption"; Línea_de_negocioCaptionLbl)
            {
            }
            column(decCdadPresCaption; decCdadPresCaptionLbl)
            {
            }
            column(decMontoPresCaption; decMontoPresCaptionLbl)
            {
            }
            column(decMontoAlcanceCaption; decMontoAlcanceCaptionLbl)
            {
            }
            column(decCdadMantCaption; decCdadMantCaptionLbl)
            {
            }
            column(decCdadConquistaCaption; decCdadConquistaCaptionLbl)
            {
            }
            column(decCdadPerdidasCaption; decCdadPerdidasCaptionLbl)
            {
            }
            column(Presupuesto__Descripcion_producto_Caption; FieldCaption("Descripcion producto"))
            {
            }
            column(Presupuesto__Cod__producto_Caption; FieldCaption("Cod. producto"))
            {
            }
            column(Nivel_Caption; Nivel_CaptionLbl)
            {
            }
            column(Presupuesto_Usuario; Usuario)
            {
            }
            column(Presupuesto_Fecha_hora; "Fecha hora")
            {
            }
            column(Presupuesto_No__mov; "No. mov")
            {
            }
            column(Presupuesto_Cod__Nivel; "Cod. Nivel")
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange(Usuario, UserId);
                SetRange("Fecha hora", dtImpresion);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(Promotor; codPromotor)
                {
                ApplicationArea = All;
                    TableRelation = "Salesperson/Purchaser";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        recTemp.Reset;
        recTemp.SetRange(Usuario, UserId);
        recTemp.SetRange("Fecha hora", dtImpresion);
        recTemp.DeleteAll;
    end;

    trigger OnPreReport()
    begin
        dtImpresion := CurrentDateTime;
        CargarDatosTemp;
    end;

    var
        recTemp: Record "Temp Reportes APS";
        dlgProgreso: Dialog;
        codPromotor: Code[20];
        dtImpresion: DateTime;
        decMontoPRes: Decimal;
        decMontoAlcance: Decimal;
        Text001: Label 'Cargando datos presupuestos';
        Text002: Label '##############################1\\';
        Text003: Label '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2';
        Text004: Label 'Cargando datos adopciones';
        Adoption_StatisticCaptionLbl: Label 'Alcance de presupuesto detallado';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        Cdad__alcanceCaptionLbl: Label 'Cdad. alcance';
        SubfamiliaCaptionLbl: Label 'Subfamilia';
        FamiliaCaptionLbl: Label 'Familia';
        "Línea_de_negocioCaptionLbl": Label 'Línea de negocio';
        decCdadPresCaptionLbl: Label 'Cdad. presup.';
        decMontoPresCaptionLbl: Label 'Monto presup.';
        decMontoAlcanceCaptionLbl: Label 'Monto alcance';
        decCdadMantCaptionLbl: Label 'Cdad. mante.';
        decCdadConquistaCaptionLbl: Label 'Cdad. Conquis.';
        decCdadPerdidasCaptionLbl: Label 'Cdad perdidas';
        Nivel_CaptionLbl: Label 'Nivel:';


    procedure CalcularPrecio(codPrmProd: Code[20]): Decimal
    var
        recProducto: Record Item;
        recTarifas: Record "Price List Line";
    begin

        if recProducto.Get(codPrmProd) then begin
            recTarifas.Reset;
            recTarifas.SetRange("Product No.", codPrmProd);
            recTarifas.SetFilter("Variant Code", '%1', '');
            recTarifas.SetFilter("Ending Date", '%1|>=%2', 0D, WorkDate);
            recTarifas.SetFilter("Currency Code", '%1', '');
            recTarifas.SetFilter("Unit of Measure Code", '%1|%2', recProducto."Sales Unit of Measure", '');
            recTarifas.SetRange("Starting Date", 0D, WorkDate);
            recTarifas.SetRange("Source Type", recTarifas."Source Type"::"All Customers");
            if recTarifas.FindFirst then
                exit(recTarifas."Unit Price")
            else
                exit(recProducto."Unit Price");
        end;
    end;


    procedure TraerDescripcionDimension(codPrmDim: Code[20]; codPrmValor: Code[20]): Text[100]
    var
        recDimVal: Record "Dimension Value";
    begin
        if recDimVal.Get(codPrmDim, codPrmValor) then
            exit(recDimVal.Name);
    end;


    procedure CargarDatosTemp()
    var
        recTmpRep: Record "Temp Reportes APS" temporary;
        recPpto: Record "Promotor - Ppto Vtas";
        recAdopciones: Record "Colegio - Adopciones Detalle";
        recProducto: Record Item;
        codNivel: Code[20];
        codLinNeg: Code[20];
        codFamilia: Code[20];
        codSubFamilia: Code[20];
        decPrecio: Decimal;
        intProcesados: Integer;
        intTotal: Integer;
        intMov: Integer;
    begin

        dlgProgreso.Open(Text002 + Text003);

        recPpto.Reset;
        if codPromotor <> '' then
            recPpto.SetRange("Cod. Promotor", codPromotor);
        if recPpto.FindSet then begin
            dlgProgreso.Update(1, Text001);
            intTotal := recPpto.Count;
            repeat
                if recProducto.Get(recPpto."Cod. Producto") then begin
                    codNivel := recProducto."Nivel Educativo";
                    codLinNeg := recProducto.GetLineaNegocio;
                    codFamilia := recProducto.GetFamilia;
                    codSubFamilia := recProducto.GetSubfamilia;
                    decPrecio := CalcularPrecio(recProducto."No.");

                    recTmpRep.Reset;
                    recTmpRep.SetCurrentKey(Usuario, "Fecha hora", "Cod. Nivel", "Linea de negocio", Familia, "Sub Familia", "Cod. producto");
                    recTmpRep.SetRange(Usuario, UserId);
                    recTmpRep.SetRange("Fecha hora", dtImpresion);
                    recTmpRep.SetRange("Cod. Nivel", codNivel);
                    recTmpRep.SetRange("Linea de negocio", codLinNeg);
                    recTmpRep.SetRange(Familia, codFamilia);
                    recTmpRep.SetRange("Sub Familia", codSubFamilia);
                    recTmpRep.SetRange("Cod. producto", recProducto."No.");
                    if recTmpRep.FindFirst then begin
                        recTmpRep."Cdad. presupuestada" += recPpto.Quantity;
                        recTmpRep."Monto. presupuestado" += (decPrecio * recPpto.Quantity);
                        recTmpRep.Modify;
                    end
                    else begin
                        intMov += 1;
                        recTmpRep.Init;
                        recTmpRep."No. mov" := intMov;
                        recTmpRep."Cod. Nivel" := codNivel;
                        recTmpRep."Linea de negocio" := codLinNeg;
                        recTmpRep.Familia := codFamilia;
                        recTmpRep."Sub Familia" := codSubFamilia;
                        recTmpRep."Cod. producto" := recProducto."No.";
                        recTmpRep."Cdad. presupuestada" := recPpto.Quantity;
                        recTmpRep."Monto. presupuestado" := (decPrecio * recPpto.Quantity);
                        recTmpRep.Usuario := UserId;
                        recTmpRep."Fecha hora" := dtImpresion;
                        recTmpRep.Insert;
                    end;
                end;

                intProcesados += 1;
                if intProcesados mod 100 = 0 then
                    dlgProgreso.Update(2, Round(intProcesados / intTotal * 10000, 1));
            until recPpto.Next = 0;
        end;

        recAdopciones.Reset;
        if codPromotor <> '' then
            recAdopciones.SetRange("Cod. Promotor", codPromotor);
        if recAdopciones.FindSet then begin
            dlgProgreso.Update(1, Text004);
            intTotal := recAdopciones.Count;
            intProcesados := 0;
            repeat

                if recProducto.Get(recAdopciones."Cod. Producto") then begin
                    codNivel := recProducto."Nivel Educativo";
                    codLinNeg := recProducto.GetLineaNegocio;
                    codFamilia := recProducto.GetFamilia;
                    codSubFamilia := recProducto.GetSubfamilia;
                    decPrecio := CalcularPrecio(recProducto."No.");

                    recTmpRep.Reset;
                    recTmpRep.SetCurrentKey(Usuario, "Fecha hora", "Cod. Nivel", "Linea de negocio", Familia, "Sub Familia");
                    recTmpRep.SetRange(Usuario, UserId);
                    recTmpRep.SetRange("Fecha hora", dtImpresion);
                    recTmpRep.SetRange("Cod. Nivel", codNivel);
                    recTmpRep.SetRange("Linea de negocio", codLinNeg);
                    recTmpRep.SetRange(Familia, codFamilia);
                    recTmpRep.SetRange("Sub Familia", codSubFamilia);
                    recTmpRep.SetRange("Cod. producto", recProducto."No.");
                    if recTmpRep.FindFirst then begin
                        case recAdopciones.Adopcion of
                            recAdopciones.Adopcion::Conquista:
                                begin
                                    recTmpRep."Cdad. conquista" += recAdopciones."Adopcion Real";
                                    recTmpRep."Cdad. alcance" += recAdopciones."Adopcion Real";
                                    recTmpRep."Monto alcance" += (recAdopciones."Adopcion Real" * decPrecio);
                                end;
                            recAdopciones.Adopcion::Mantener:
                                begin
                                    recTmpRep."Cdad. mnto." += recAdopciones."Adopcion Real";
                                    recTmpRep."Cdad. alcance" += recAdopciones."Adopcion Real";
                                    recTmpRep."Monto alcance" += (recAdopciones."Adopcion Real" * decPrecio);
                                end;
                            recAdopciones.Adopcion::Perdida:
                                recTmpRep."Cdad. perdida" += recAdopciones."Adopcion Real";
                        end;
                        recTmpRep.Modify;
                    end
                    else begin
                        recTmpRep.Init;
                        intMov += 1;
                        recTmpRep."No. mov" := intMov;
                        recTmpRep."Cod. Nivel" := codNivel;
                        recTmpRep."Linea de negocio" := codLinNeg;
                        recTmpRep.Familia := codFamilia;
                        recTmpRep."Sub Familia" := codSubFamilia;
                        recTmpRep."Cod. producto" := recProducto."No.";
                        case recAdopciones.Adopcion of
                            recAdopciones.Adopcion::Conquista:
                                recTmpRep."Cdad. conquista" := recAdopciones."Adopcion Real";
                            recAdopciones.Adopcion::Mantener:
                                recTmpRep."Cdad. mnto." := recAdopciones."Adopcion Real";
                            recAdopciones.Adopcion::Perdida:
                                recTmpRep."Cdad. perdida" := recAdopciones."Adopcion Real";
                        end;
                        recTmpRep."Cdad. alcance" := recTmpRep."Cdad. conquista" + recTmpRep."Cdad. mnto.";
                        recTmpRep."Monto alcance" := recTmpRep."Cdad. alcance" * decPrecio;
                        recTmpRep.Usuario := UserId;
                        recTmpRep."Fecha hora" := dtImpresion;
                        recTmpRep.Insert;
                    end;
                end;

                intProcesados += 1;
                if intProcesados mod 100 = 0 then
                    dlgProgreso.Update(2, Round(intProcesados / intTotal * 10000, 1));
            until recAdopciones.Next = 0;
        end;
        dlgProgreso.Close;


        //Cargo los datos primero en un record temporary = Yes por una cuestion de rendiemiento.
        recTmpRep.Reset;
        if recTmpRep.FindSet then
            repeat
                recTemp := recTmpRep;
                recTemp.Insert;
            until recTmpRep.Next = 0;
    end;
}

