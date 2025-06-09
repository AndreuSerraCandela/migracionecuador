report 76291 "Alcance presupuesto promotor"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Alcancepresupuestopromotor.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Import Adoptions';
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Presupuesto; "Promotor - Ppto Vtas")
        {
            DataItemTableView = SORTING("Cod. Promotor", "Cod. Producto") WHERE("Cod. Promotor" = FILTER(<> ''));
            RequestFilterFields = "Cod. Promotor", "Cod. Producto";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Presupuesto__Cod__Promotor_; "Cod. Promotor")
            {
            }
            column(Presupuesto__Nombre_Promotor_; "Nombre Promotor")
            {
            }
            column(codNivel; codNivel)
            {
            }
            column(texDescLinNeg; texDescLinNeg)
            {
            }
            column(decMontoPres; decMontoPres)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decMontoAlcance; decMontoAlcance)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decCdadMant; decCdadMant)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decCdadConquista; decCdadConquista)
            {
                DecimalPlaces = 0 : 2;
            }
            column(decCdadPres; Quantity)
            {
                //DecimalPlaces = 0 : 2;
            }
            column(texDescFamilia; texDescFamilia)
            {
            }
            column(texDescSubFamilia; texDescSubFamilia)
            {
            }
            column(texDescEdicionCol; texDescEdicionCol)
            {
            }
            column(decCdadPerdidas; decCdadPerdidas)
            {
                DecimalPlaces = 0 : 2;
            }
            column(Presupuesto__Item_Description_; "Item Description")
            {
            }
            column(Presupuesto__Cod__Producto_; "Cod. Producto")
            {
            }
            column(Adoption_StatisticCaption; Adoption_StatisticCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(codNivelCaption; codNivelCaptionLbl)
            {
            }
            column(codFamiliaCaption; codFamiliaCaptionLbl)
            {
            }
            column(codSubFamiliaCaption; codSubFamiliaCaptionLbl)
            {
            }
            column(codEdicionColCaption; codEdicionColCaptionLbl)
            {
            }
            column(codLinNegCaption; codLinNegCaptionLbl)
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
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(Presupuesto__Cod__Producto_Caption; FieldCaption("Cod. Producto"))
            {
            }
            column(PromotorCaption; PromotorCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin

                Clear(codLinNeg);
                Clear(texDescLinNeg);
                Clear(codFamilia);
                Clear(texDescFamilia);
                Clear(codSubFamilia);
                Clear(texDescSubFamilia);
                Clear(codEdicionCol);
                Clear(texDescEdicionCol);
                Clear(codNivel);
                Clear(texDescNivel);
                Clear(decMontoPres);
                Clear(decMontoAlcance);
                Clear(decCdadMant);
                Clear(decCdadConquista);
                Clear(decCdadPerdidas);
                Clear(decPrecio);

                recAdopciones.Reset;
                recAdopciones.SetRange("Cod. Promotor", "Cod. Promotor");
                recAdopciones.SetRange("Cod. Producto", "Cod. Producto");
                if recAdopciones.FindSet then begin

                    codLinNeg := recAdopciones."Linea de negocio";
                    texDescLinNeg := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Lin. Negocio", codLinNeg);

                    codFamilia := recAdopciones.Familia;
                    texDescFamilia := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Familia", codFamilia);

                    //fes mig codSubFamilia := recAdopciones."Sub Familia";
                    texDescSubFamilia := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Sub Familia", codSubFamilia);

                    codEdicionCol := recAdopciones.Serie;
                    texDescEdicionCol := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Serie", codEdicionCol);

                    codNivel := recAdopciones."Cod. Nivel";
                    if recNivel.Get(codNivel) then
                        texDescNivel := recNivel.Descripción;

                    repeat
                        case recAdopciones.Adopcion of
                            recAdopciones.Adopcion::Conquista:
                                decCdadConquista += recAdopciones."Adopcion Real";
                            recAdopciones.Adopcion::Mantener:
                                decCdadMant += recAdopciones."Adopcion Real";
                            recAdopciones.Adopcion::Perdida:
                                decCdadPerdidas += recAdopciones."Adopcion Real";
                        end;
                    until recAdopciones.Next = 0;

                end;

                decPrecio := CalcularPrecio("Cod. Producto");
                decMontoPres := decPrecio * Quantity;
                decMontoAlcance := decPrecio * (decCdadConquista + decCdadMant);
            end;

            trigger OnPreDataItem()
            begin
                recCfgAPS.Get;
                recCfgAPS.TestField("Cod. Dimension Lin. Negocio");
                recCfgAPS.TestField("Cod. Dimension Familia");
                recCfgAPS.TestField("Cod. Dimension Sub Familia");
                recCfgAPS.TestField("Cod. Dimension Serie");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recCfgAPS: Record "Commercial Setup";
        recAdopciones: Record "Colegio - Adopciones Detalle";
        recNivel: Record "Nivel Educativo APS";
        codLinNeg: Code[20];
        texDescLinNeg: Text[100];
        codFamilia: Code[20];
        texDescFamilia: Text[100];
        codSubFamilia: Code[20];
        texDescSubFamilia: Text[100];
        codEdicionCol: Code[20];
        texDescEdicionCol: Text[100];
        codNivel: Code[20];
        texDescNivel: Text[100];
        decMontoPres: Decimal;
        decMontoAlcance: Decimal;
        decCdadMant: Decimal;
        decCdadConquista: Decimal;
        decCdadPerdidas: Decimal;
        decPrecio: Decimal;
        Adoption_StatisticCaptionLbl: Label 'Alcance de presupuesto';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        codNivelCaptionLbl: Label 'Nivel';
        codFamiliaCaptionLbl: Label 'Familia';
        codSubFamiliaCaptionLbl: Label 'Subfamilia';
        codEdicionColCaptionLbl: Label 'Edición colección';
        codLinNegCaptionLbl: Label 'Línea de negocio';
        decCdadPresCaptionLbl: Label 'Cdad. presup.';
        decMontoPresCaptionLbl: Label 'Monto presup.';
        decMontoAlcanceCaptionLbl: Label 'Monto alcance';
        decCdadMantCaptionLbl: Label 'Cdad. mante.';
        decCdadConquistaCaptionLbl: Label 'Cdad. Conquis.';
        decCdadPerdidasCaptionLbl: Label 'Cdad perdidas';
        "DescripciónCaptionLbl": Label 'Descripción';
        PromotorCaptionLbl: Label 'Promotor:';


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
}

