report 76322 "Adopciones por colegio"
{
    // Falta como obtener precio.
    DefaultLayout = RDLC;
    RDLCLayout = './Adopcionesporcolegio.rdlc';


    dataset
    {
        dataitem(Adopciones; "Colegio - Adopciones Detalle")
        {
            DataItemTableView = SORTING("Cod. Colegio", "Cod. Promotor", "Cod. Producto");
            RequestFilterFields = "Cod. Colegio", "Cod. Promotor";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Adopciones__Cod__Colegio_; "Cod. Colegio")
            {
            }
            column(Adopciones__Nombre_Colegio_; "Nombre Colegio")
            {
                AutoCalcField = true;
            }
            column(Presupuesto__Nombre_Promotor_; "Nombre Promotor")
            {
            }
            column(Presupuesto__Cod__Promotor_; "Cod. Promotor")
            {
            }
            column(texDescLinNeg; texDescLinNeg)
            {
            }
            column(decPrecio; decPrecio)
            {
                DecimalPlaces = 0 : 2;
            }
            column(codMarca; Adopcion)
            {
                //DecimalPlaces = 0 : 2;
            }
            column(intCdadAlumnos; "Cantidad Alumnos")
            {
                DecimalPlaces = 0 : 2;
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
            column(Adopciones__Descripcion_producto_; "Descripcion producto")
            {
                AutoCalcField = true;
            }
            column(Presupuesto__Cod__Producto_; "Cod. Producto")
            {
            }
            column(Adopciones__Cod__Nivel_; "Cod. Nivel")
            {
            }
            column(decCdadPres; "Cod. Grado")
            {
                //DecimalPlaces = 0 : 2;
            }
            column(codCategoria; codCategoria)
            {
            }
            column(Adopciones_por_colegioCaption; Adopciones_por_colegioCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
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
            column(decMontoPresCaption; decMontoPresCaptionLbl)
            {
            }
            column(decMontoAlcanceCaption; decMontoAlcanceCaptionLbl)
            {
            }
            column(decCdadMantCaption; decCdadMantCaptionLbl)
            {
            }
            column("DescripciónCaption"; DescripciónCaptionLbl)
            {
            }
            column(Presupuesto__Cod__Producto_Caption; FieldCaption("Cod. Producto"))
            {
            }
            column(codNivelCaption; codNivelCaptionLbl)
            {
            }
            column(decCdadPresCaption; FieldCaption("Cod. Grado"))
            {
            }
            column(Categ_Caption; Categ_CaptionLbl)
            {
            }
            column(Colegio_Caption; Colegio_CaptionLbl)
            {
            }
            column(PromotorCaption; PromotorCaptionLbl)
            {
            }
            column(Adopciones_Grupo_de_Negocio; "Grupo de Negocio")
            {
            }
            column(Adopciones_Cod__Turno; "Cod. Turno")
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
                Clear(texDescNivel);
                Clear(decPrecio);
                Clear(intCdadAlumnos);

                codCategoria := TraerCategoria("Cod. Colegio", "Cod. Nivel");

                texDescLinNeg := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Lin. Negocio", "Linea de negocio");
                texDescFamilia := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Familia", Familia);
                //fes mig texDescSubFamilia := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Sub Familia","Sub Familia");
                texDescEdicionCol := TraerDescripcionDimension(recCfgAPS."Cod. Dimension Serie", Serie);

                decPrecio := CalcularPrecio("Cod. Producto");

                if Adopcion = Adopcion::Perdida then
                    "Cantidad Alumnos" := -"Cantidad Alumnos"
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
        _recNivel: Record "Nivel Educativo APS";
        codLinNeg: Code[20];
        texDescLinNeg: Text[100];
        codFamilia: Code[20];
        texDescFamilia: Text[100];
        codSubFamilia: Code[20];
        texDescSubFamilia: Text[100];
        codEdicionCol: Code[20];
        texDescEdicionCol: Text[100];
        texDescNivel: Text[100];
        decPrecio: Decimal;
        intCdadAlumnos: Integer;
        codCategoria: Code[10];
        Adopciones_por_colegioCaptionLbl: Label 'Adopciones por colegio';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        codFamiliaCaptionLbl: Label 'Familia';
        codSubFamiliaCaptionLbl: Label 'Subfamilia';
        codEdicionColCaptionLbl: Label 'Edición colección';
        codLinNegCaptionLbl: Label 'Línea de negocio';
        decMontoPresCaptionLbl: Label 'Precio';
        decMontoAlcanceCaptionLbl: Label 'Marca';
        decCdadMantCaptionLbl: Label 'Cantidad alumnos';
        "DescripciónCaptionLbl": Label 'Descripción';
        codNivelCaptionLbl: Label 'Nivel';
        Categ_CaptionLbl: Label 'Categ.';
        Colegio_CaptionLbl: Label 'Colegio:';
        PromotorCaptionLbl: Label 'Promotor:';


    procedure CalcularPrecio(codPrmProd: Code[20]): Decimal
    var
        recProducto: Record Item;
    begin
        if recProducto.Get(codPrmProd) then
            exit(recProducto."Unit Price");
        //De momento devuelvo el precio del a ficha a falta de saber como obteener el precio que quieren
    end;


    procedure TraerDescripcionDimension(codPrmDim: Code[20]; codPrmValor: Code[20]): Text[100]
    var
        recDimVal: Record "Dimension Value";
    begin
        if recDimVal.Get(codPrmDim, codPrmValor) then
            exit(recDimVal.Name);
    end;


    procedure TraerCategoria(codPrmColegio: Code[20]; codPrmNivel: Code[20]): Code[10]
    var
        recNivel: Record "Colegio - Nivel";
    begin
        recNivel.Reset;
        recNivel.SetRange("Cod. Colegio", codPrmColegio);
        //recNivel.SETRANGE("Cod. Promotor", codPrmProm);
        recNivel.SetRange("Cod. Nivel", codPrmNivel);
        if recNivel.FindFirst then
            exit(recNivel."Categoria colegio");
    end;
}

